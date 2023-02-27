import 'dart:convert';

import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';
import 'package:capsa/vendor-new/dialog_boxes/invoice_builder_dialog_box.dart';
import 'package:capsa/vendor-new/model/invoice_builder_model.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/vendor-new/provider/invoice_builder_provider.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/bids_model.dart';

class InvoiceBuilderEditPage extends StatefulWidget {
  InvoiceBuilderModel model;
  InvoiceBuilderEditPage({Key key, this.model}) : super(key: key);

  @override
  State<InvoiceBuilderEditPage> createState() => _InvoiceBuilderEditPageState();
}

class _InvoiceBuilderEditPageState extends State<InvoiceBuilderEditPage> {
  TextEditingController dummyController = TextEditingController(text: '');
  TextEditingController invoiceNumberController =
  TextEditingController(text: '');
  TextEditingController vendorController = TextEditingController(text: '');
  TextEditingController anchorController = TextEditingController(text: '');
  TextEditingController anchorNameController = TextEditingController(text: '');
  TextEditingController tenureController = TextEditingController(text: '');
  TextEditingController poNumberController = TextEditingController(text: '');
  TextEditingController notesController = TextEditingController(text: '');

  TextEditingController subTotalController = TextEditingController(text: '');
  TextEditingController discountController = TextEditingController(text: '');
  TextEditingController taxController = TextEditingController(text: '');
  TextEditingController totalController = TextEditingController(text: '');
  TextEditingController amountPaidController = TextEditingController(text: '');
  TextEditingController dueController = TextEditingController(text: '');

  bool loading = false;

  TextEditingController discountTypeController =
  TextEditingController(text: '');

  TextEditingController dueDateCont = TextEditingController(text: '');
  TextEditingController dateCont = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  bool vendorDataPresent = false;
  String imageUrl = "";
  String _cuGst = "";

  var anchorName;
  String customer_cin = "";

  var anchorNameList = [];

  dynamic companyDetails = null;

  Map<String, bool> _isBlackListed = {};

  // TextEditingController dummyController = TextEditingController(text: '');

  List<String> description = [];
  List<String> quantity = [];
  List<String> rate = [];
  List<String> totalAmount = [];

  String selectedDiscountType = "";
  dynamic discount;


  List<InvoiceBuilderItemDescriptionModel> invoiceBuilderModel = [];

  PlatformFile file;

  dynamic anchor;
  TextEditingController currencyController = TextEditingController();
  String selectedCurrency = "";
  bool checking = false;
  Map<String, String> currencyAvailability = {};
  List<String> term = ['USD', 'NGN'];

  List<String> discountType = ['None', 'Amount', 'Percentage'];

  int descriptionQuantity = 1;
  bool customAnchorName = false;

  DateTime _selectedDueDate;
  DateTime _selectedDate;

  bool dataLoaded = false;

  List<String> anchorTerm;

  bool isNull(String s){
    if(s == '' || s == null || s.toLowerCase() == 'null')
      return true;
    return false;
  }

  void resetData() {
    dummyController = TextEditingController(text: '');
    invoiceNumberController = TextEditingController(text: '');
    vendorController = TextEditingController(text: '');
    anchorController = TextEditingController(text: '');
    tenureController = TextEditingController(text: '');
    poNumberController = TextEditingController(text: '');
    notesController = TextEditingController(text: '');

    subTotalController = TextEditingController(text: '');
    discountController = TextEditingController(text: '');
    taxController = TextEditingController(text: '');
    totalController = TextEditingController(text: '');
    amountPaidController = TextEditingController(text: '');
    dueController = TextEditingController(text: '');

    discountTypeController = TextEditingController(text: '');

    dueDateCont = TextEditingController(text: '');
    dateCont = TextEditingController(text: '');
  }

  void calculateAmounts() {
    double subTotal = 0;
    double due = 0;
    double discount = discountController.text == ''
        ? 0
        : double.parse(discountController.text);
    double tax =
    taxController.text == '' ? 0 : double.parse(taxController.text);
    double amountPaid = amountPaidController.text == ''
        ? 0
        : double.parse(amountPaidController.text);
    double total = 0;

    for (int i = 0; i < invoiceBuilderModel.length; i++) {
      subTotal = subTotal +
          double.parse(invoiceBuilderModel[i].amount == ''
              ? '0'
              : invoiceBuilderModel[i].amount);
    }

    total = selectedDiscountType == "Percentage"
        ? (subTotal - ((discount / 100) * subTotal) + tax)
        : (subTotal - discount + tax);

    due = total - amountPaid;

    subTotalController.text = subTotal.toString();

    totalController.text = total.toString();
    dueController.text = due.toString();
  }

  _selectDueDate(BuildContext context) async {
    // capsaPrint("_selectDueDate");

    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate:
        _selectedDueDate != null ? _selectedDueDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                surface: Theme.of(context).primaryColor,
                // onSurface: Colors.yellow,
              ),
              // dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDueDate = newSelectedDate;
      dueDateCont
        ..text = DateFormat.yMMMd().format(_selectedDueDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dueDateCont.text.length, affinity: TextAffinity.upstream));
    }
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                surface: Theme.of(context).primaryColor,
                // onSurface: Colors.yellow,
              ),
              // dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      dateCont
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateCont.text.length, affinity: TextAffinity.upstream));
    }
  }

  Widget descriptionPanel(int index) {
    TextEditingController itemDescription = TextEditingController(text: '');
    TextEditingController itemQuantity = TextEditingController(text: '');
    TextEditingController itemRate = TextEditingController(text: '');
    TextEditingController total = TextEditingController(text: '');

    InvoiceBuilderItemDescriptionModel model =
    InvoiceBuilderItemDescriptionModel(
        description: "", quantity: "", rate: "", amount: "");

    capsaPrint('Index panel $index');

    if (index >= invoiceBuilderModel.length) {
      invoiceBuilderModel.add(model);
    } else {
      capsaPrint('Index $index');
      itemDescription.text = invoiceBuilderModel[index].description;
      itemQuantity.text = invoiceBuilderModel[index].quantity;
      itemRate.text = invoiceBuilderModel[index].rate;
      total.text = invoiceBuilderModel[index].amount;
    }

    //description.add(itemDescription);

    return (!Responsive.isMobile(context))
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: InkWell(
            onTap: () {
              setState(() {
                if (descriptionQuantity > 1) descriptionQuantity--;
                invoiceBuilderModel.removeAt(index);
              });
            },
            child: Icon(
              Icons.clear,
              color: index > 0 ? Colors.red : Colors.transparent,
              size: 12,
            ),
          ),
        ),
        Container(
          height: 110,
          width: MediaQuery.of(context).size.width * 0.4 * 0.6 - 58,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? Text('Description') : Container(),
              Container(
                width: MediaQuery.of(context).size.width * 0.4 * 0.6 - 58,
                //height: 90,
                child: UserTextFormField(
                  label: '',
                  padding: const EdgeInsets.all(0.0),
                  fillColor: Color.fromRGBO(239, 239, 239, 1.0),
                  hintText: "Item Description",
                  controller: itemDescription,
                  onChanged: (v) {
                    invoiceBuilderModel[index].description = v;
                    // capsaPrint(
                    //     'On Changed: ${invoiceBuilderModel[index].description} ${invoiceBuilderModel[index].quantity} ${invoiceBuilderModel[index].rate} ${invoiceBuilderModel[index].amount}');
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 110,
          width: MediaQuery.of(context).size.width * 0.2 * 0.6 - 58,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? Text('Quantity') : Container(),
              Container(
                width: MediaQuery.of(context).size.width * 0.2 * 0.6 - 58,
                //height: 90,
                child: UserTextFormField(
                  label: '',
                  padding: const EdgeInsets.all(0.0),
                  fillColor: Color.fromRGBO(239, 239, 239, 1.0),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hintText: "Item Quantity",
                  controller: itemQuantity,
                  onChanged: (v) {
                    invoiceBuilderModel[index].quantity = v;
                    double a = itemQuantity.text == ''
                        ? 0
                        : double.parse(itemQuantity.text);
                    double b = itemRate.text == ''
                        ? 0
                        : double.parse(itemRate.text);
                    invoiceBuilderModel[index].amount =
                        (a * b).toString();
                    total.text = (a * b).toString();
                    // capsaPrint(
                    //     'On Changed: ${invoiceBuilderModel[index].description} ${invoiceBuilderModel[index].quantity} ${invoiceBuilderModel[index].rate} ${invoiceBuilderModel[index].amount}');

                    calculateAmounts();
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 110,
          width: MediaQuery.of(context).size.width * 0.2 * 0.6 - 58,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? Text('Rate') : Container(),
              Container(
                width: MediaQuery.of(context).size.width * 0.2 * 0.6 - 58,
                //height: 90,
                child: UserTextFormField(
                  label: '',
                  showBorder: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  padding: const EdgeInsets.all(0.0),
                  fillColor: Color.fromRGBO(239, 239, 239, 1.0),
                  hintText: "Item Rate",
                  controller: itemRate,
                  onChanged: (v) {
                    invoiceBuilderModel[index].rate = v;
                    double a = itemQuantity.text == ''
                        ? 0
                        : double.parse(itemQuantity.text);
                    double b = itemRate.text == ''
                        ? 0
                        : double.parse(itemRate.text);
                    invoiceBuilderModel[index].amount =
                        (a * b).toString();
                    total.text = (a * b).toString();
                    // capsaPrint(
                    //     'On Changed: ${invoiceBuilderModel[index].description} ${invoiceBuilderModel[index].quantity} ${invoiceBuilderModel[index].rate} ${invoiceBuilderModel[index].amount}');

                    calculateAmounts();
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 110,
          width: MediaQuery.of(context).size.width * 0.2 * 0.6 - 58,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? Text('Total') : Container(),
              Container(
                width: MediaQuery.of(context).size.width * 0.2 * 0.6 - 58,
                //height: 90,
                child: UserTextFormField(
                  label: '',
                  showBorder: false,
                  padding: const EdgeInsets.all(0.0),
                  fillColor: Color.fromRGBO(239, 239, 239, 1.0),
                  hintText: "",
                  controller: total,
                ),
              ),
            ],
          ),
        )
      ],
    )
        : Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          //height: 210,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              border: Border.all(color: Colors.black)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8, right: 8, top: 12, bottom: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                              'Amount:   ${getCurrencyIcon(selectedCurrency == '' ? 'NGN' : selectedCurrency)} '),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: UserTextFormField(
                            label: '',
                            padding: EdgeInsets.all(0),
                            borderRadius: 0,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            showBorder: false,
                            readOnly: true,
                            hintText: "",
                            controller: total,
                            onChanged: (v) {
                              // capsaPrint(
                              //     'On Changed: ${invoiceBuilderModel[index].description} ${invoiceBuilderModel[index].quantity} ${invoiceBuilderModel[index].rate} ${invoiceBuilderModel[index].amount}');
                            },
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (descriptionQuantity > 1)
                            descriptionQuantity--;
                          invoiceBuilderModel.removeAt(index);
                        });
                      },
                      child: Icon(
                        Icons.clear,
                        color:
                        index > 0 ? Colors.red : Colors.transparent,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  //height: 60,
                  child: UserTextFormField(
                    label: '',
                    padding: EdgeInsets.all(0),
                    borderRadius: 0,
                    showBorder: true,
                    readOnly: false,
                    hintText: "Item Description",
                    controller: itemDescription,
                    onChanged: (v) {
                      invoiceBuilderModel[index].description = v;
                      // capsaPrint(
                      //     'On Changed: ${invoiceBuilderModel[index].description} ${invoiceBuilderModel[index].quantity} ${invoiceBuilderModel[index].rate} ${invoiceBuilderModel[index].amount}');
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      //height: 60,
                      child: UserTextFormField(
                        label: '',
                        padding: EdgeInsets.all(0),
                        borderRadius: 0,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        showBorder: true,
                        readOnly: false,
                        hintText: "Rate",
                        controller: itemRate,
                        onChanged: (v) {
                          invoiceBuilderModel[index].rate = v;
                          double a = itemQuantity.text == ''
                              ? 0
                              : double.parse(itemQuantity.text);
                          double b = itemRate.text == ''
                              ? 0
                              : double.parse(itemRate.text);
                          invoiceBuilderModel[index].amount =
                              (a * b).toString();
                          total.text = (a * b).toString();

                          calculateAmounts();
                        },
                      ),
                    ),
                    Text('X'),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      //height: 60,
                      child: UserTextFormField(
                        label: '',
                        padding: EdgeInsets.all(0),
                        borderRadius: 0,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        showBorder: true,
                        readOnly: false,
                        hintText: "Quantity",
                        controller: itemQuantity,
                        onChanged: (v) {
                          invoiceBuilderModel[index].quantity = v;
                          double a = itemQuantity.text == ''
                              ? 0
                              : double.parse(itemQuantity.text);
                          double b = itemRate.text == ''
                              ? 0
                              : double.parse(itemRate.text);
                          invoiceBuilderModel[index].amount =
                              (a * b).toString();
                          total.text = (a * b).toString();
                          // capsaPrint(
                          //     'On Changed: ${invoiceBuilderModel[index].description} ${invoiceBuilderModel[index].quantity} ${invoiceBuilderModel[index].rate} ${invoiceBuilderModel[index].amount}');

                          calculateAmounts();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  void getData() async {
    final invoiceProvider =
    Provider.of<InvoiceBuilderProvider>(context, listen: false);

    dynamic _vendorData = await invoiceProvider.getVendorInvoiceDetails();

    capsaPrint('Date Initialised $_vendorData ');

    if (_vendorData['msg'] == null) {
      imageUrl = _vendorData['data']['details']['logo'];
      vendorDataPresent = true;
      vendorController.text = _vendorData['data']['details']['vendor_name'];
    }

    // dynamic _data = await invoiceProvider.getCurrencies();
    //
    // List<dynamic> _items = _data['data'];
    // if (_data['msg'] == 'success') {
    //   term = [];
    //   _items.forEach((element) {
    //     term.add(element['currency_code'].toString());
    //     currencyAvailability[element['currency_code']] =
    //         element['is_active'].toString();
    //   });
    // }

    if (companyDetails == null) {
      dynamic _data = await Provider.of<VendorActionProvider>(context, listen: false)
          .getCompanyName();
      List<dynamic> _items = _data['data'];
      companyDetails = _data;
      if (_data['res'] == 'success') {
        anchorNameList = _items;
        anchorTerm = [];
        _items.forEach((element) {
          anchorTerm.add(element['name'].toString());
          //anchorTerm = ['test1'];
          _isBlackListed[element['name'].toString()] =
          element['isBlacklisted'] != null
              ? element['isBlacklisted'] == '1'
              ? true
              : false
              : false;
        });
      }
      anchorTerm.add('Not in the list');
    }

    if(value(widget.model.anchor) != "") {
      if(value(widget.model.customerCin)!='') {
        anchorName = value(widget.model.anchor);
        customer_cin = widget.model.customerCin;
        _cuGst = widget.model.cuGst;
      }
    }

    if(value(widget.model.anchor) != "" && value(widget.model.customerCin)!=''){
      anchorNameList.forEach((element1) {
        if (element1['name'] == widget.model.anchor) {
          // cacAddress = element1['name_address'];
          anchorController.text = element1['name_address'];
          _cuGst = element1['cu_gst'];
          customer_cin = element1['CIN'];

          capsaPrint(customer_cin);
        }
      });
    }

    setState(() {
      dataLoaded = true;
    });
  }

  String value(String s){
    return isNull(s) ? "" : s;
  }

  @override
  void initState() {
    super.initState();
    capsaPrint(widget.model.invDate);
    capsaPrint(widget.model.invDueDate);
    invoiceNumberController.text = value(widget.model.invNo);
    poNumberController.text = value(widget.model.poNo);
    vendorController.text = value(widget.model.vendor);
    anchorNameController.text = value(widget.model.anchor);
    if(value(widget.model.anchor) != "") {
      if(value(widget.model.customerCin)!='') {
        anchorName = value(widget.model.anchor);
        customer_cin = widget.model.customerCin;
        _cuGst = widget.model.cuGst;
      }else{
        anchorName = 'Not in the list';
        customAnchorName = true;
      }
    }
    selectedCurrency = widget.model.currency;
    tenureController.text = value(widget.model.tenure);
    notesController.text = value(widget.model.notes);
    totalController.text = value(widget.model.total);
    subTotalController.text = value(widget.model.subTotal);
    taxController.text = value(widget.model.tax);
    discountController.text = value(widget.model.discount);
    notesController.text = value(widget.model.notes);
    amountPaidController.text = value(widget.model.paid);
    dueController.text = value(widget.model.balanceDue);

    capsaPrint('Pass 1');

    if(widget.model.invDate != null && widget.model.invDate != ''  && widget.model.invDate != 'null'){
      capsaPrint('Pass 2');
      _selectedDate = DateFormat(
          "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.model.invDate);
      dateCont
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateCont.text.length, affinity: TextAffinity.upstream));
    }

    capsaPrint('Pass 3');

    if(widget.model.invDueDate != null && widget.model.invDueDate != ''  && widget.model.invDueDate != 'null'){
      capsaPrint('Pass 4');

      _selectedDueDate = DateFormat(
          "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.model.invDueDate);
      dueDateCont
        ..text = DateFormat.yMMMd().format(_selectedDueDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dueDateCont.text.length, affinity: TextAffinity.upstream));

    }

    capsaPrint('Pass 5');





    invoiceBuilderModel = widget.model.descriptions ?? [];
    descriptionQuantity = invoiceBuilderModel.length ?? "";
    if(widget.model.currency != null && widget.model.currency != ''  && widget.model.currency != 'null') {
      anchor = widget.model.currency;
    }
    currencyController.text = widget.model.currency ?? "";

    if(value(widget.model.discountType)!='') {
      discount = widget.model.discountType ?? "";
      selectedDiscountType = widget.model.discountType ?? "";
    }
    discountTypeController.text = widget.model.discountType ?? "";



    getData();
  }

  @override
  Widget build(BuildContext context) {
    InvoiceBuilderProvider _invoiceBuilderProvider =
    Provider.of<InvoiceBuilderProvider>(
      context,
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      child: dataLoaded
          ? Form(

        child: Container(
          padding:
          EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
          child: Stack(
            children: [
              ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!Responsive.isMobile(context))
                    SizedBox(
                      height: 22,
                    ),
                  TopBarWidget("Invoice Builder", ""),
                  if (!Responsive.isMobile(context))
                    SizedBox(
                      height: 22,
                    ),
                  if (!Responsive.isMobile(context))
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height: 900,
                          width: MediaQuery.of(context).size.width * 0.6,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(58),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        // if (file == null &&
                                        //     vendorDataPresent == false)
                                        {
                                          FilePickerResult result =
                                          await FilePicker.platform
                                              .pickFiles(
                                            withData: true,
                                            onFileLoading:
                                                (FilePickerStatus p) {},
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'jpg',
                                              'jpeg',
                                              'png'
                                            ],
                                          );

                                          if (result != null) {
                                            if (result.files.first
                                                .extension ==
                                                'jpg' ||
                                                result.files.first
                                                    .extension ==
                                                    'png') {
                                              setState(() {
                                                file = result.files.first;
                                                // fileCont.text = file.name;
                                                capsaPrint('ok');
                                              });
                                            } else if (result.files.first
                                                .extension ==
                                                'pdf') {
                                              setState(() {
                                                file = result.files.first;
                                                // fileCont.text = file.name;
                                              });
                                              // generateTn(file);

                                            } else {
                                              showDialog<void>(
                                                  context: context,
                                                  builder: (BuildContext
                                                  context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                          'Invalid Format Selected. Please Select Another File'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                            child: Text(
                                                              'OK',
                                                              style:
                                                              TextStyle(
                                                                color: Theme.of(
                                                                    context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context)),
                                                      ],
                                                    );
                                                  });
                                            }
                                          } else {
                                            showDialog<void>(
                                                context: context,
                                                builder: (BuildContext
                                                context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        'No File Selected!'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          child: Text(
                                                            'OK',
                                                            style:
                                                            TextStyle(
                                                              color: Theme.of(
                                                                  context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context)),
                                                    ],
                                                  );
                                                });
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 200,
                                        height: 120,
                                        color: HexColor('#828282'),
                                        child: file != null
                                            ? Image.memory(
                                          file.bytes,
                                          fit: BoxFit.fill,
                                        )
                                            : Image.network(
                                          imageUrl,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // width: 210,
                                      // height: 120,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Text('Invoice'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Form(
                                            key: _formKey,
                                            child: Container(
                                              width: 200,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: '',
                                                showBorder: false,
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    '#',
                                                    style:
                                                    GoogleFonts.poppins(
                                                        color: HexColor(
                                                            '#333333')),
                                                  ),
                                                ),
                                                hintText: "Invoice Number",
                                                controller:
                                                invoiceNumberController,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Container(
                                          // width: 210,
                                          // height: 120,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text('From (Vendor)'),
                                              Container(
                                                width: 200,
                                                //height: 90,
                                                child: UserTextFormField(
                                                  label: '',
                                                  padding:
                                                  EdgeInsets.all(0),
                                                  showBorder: false,
                                                  fillColor:
                                                  Color.fromRGBO(239,
                                                      239, 239, 1.0),
                                                  hintText: "Vendor Name",
                                                  // readOnly:
                                                  // vendorDataPresent,
                                                  controller:
                                                  vendorController,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Container(
                                          // width: 210,
                                          // height: 120,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text('To (Anchor)'),
                                              Container(
                                                width: 200,
                                                //height: 90,
                                                child:UserTextFormField(
                                                  label: "",
                                                  padding:
                                                  EdgeInsets.all(0),
                                                  hintText: "Select Anchor",
                                                  fillColor: Color.fromRGBO(
                                                      239, 239, 239, 1.0),
                                                  textFormField:
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    validator: (v) {
                                                      if (anchorController.text ==
                                                          '') {
                                                        return "Can't be empty";
                                                      }
                                                      return null;
                                                    },
                                                    items:
                                                    anchorTerm.map((String category) {
                                                      return DropdownMenuItem(
                                                        value: category,
                                                        child:
                                                        Text(category.toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (v) {
                                                      capsaPrint(v);

                                                      if (v ==
                                                          'Not in the list') {
                                                        capsaPrint('not in the list xx');
                                                        setState(
                                                                () {
                                                              customAnchorName = true;
                                                            });
                                                      } else {
                                                        if(customAnchorName == true) {
                                                          setState(() {
                                                            customAnchorName = false;
                                                          });
                                                        }
                                                        anchorNameController.text = v;
                                                        anchorNameList
                                                            .forEach((element1) {
                                                          if (element1['name'] == v) {
                                                            // cacAddress = element1['name_address'];
                                                            anchorController.text =
                                                            element1[
                                                            'name_address'];
                                                            _cuGst =
                                                            element1['cu_gst'];
                                                            customer_cin = element1['CIN'];

                                                            capsaPrint(customer_cin);

                                                          }
                                                        });
                                                      }
                                                    },
                                                    value: anchorName,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      filled: true,
                                                      fillColor: Color.fromRGBO(
                                                          239, 239, 239, 1.0),
                                                      hintText: "Select Anchor",
                                                      hintStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              130, 130, 130, 1),
                                                          fontSize: 14,
                                                          letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          height: 1),
                                                      contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          bottom: 12.0,
                                                          top: 12.0),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.white),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            15.7),
                                                      ),
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.white),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            15.7),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: customAnchorName,
                                                child: Container(
                                                  width: 200,
                                                  //height: 90,
                                                  child: UserTextFormField(
                                                    label: '',
                                                    padding:
                                                    EdgeInsets.all(0),
                                                    showBorder: false,
                                                    fillColor:
                                                    Color.fromRGBO(239,
                                                        239, 239, 1.0),
                                                    hintText: "Anchor Name",
                                                    controller:
                                                    anchorNameController,
                                                  ),
                                                ),
                                              ),
                                              // Container(
                                              //   width: 200,
                                              //   //height: 90,
                                              //   child: UserTextFormField(
                                              //     padding:
                                              //     EdgeInsets.all(0),
                                              //     label: '',
                                              //     showBorder: false,
                                              //     fillColor:
                                              //     Color.fromRGBO(239,
                                              //         239, 239, 1.0),
                                              //     hintText: "Anchor Name",
                                              //     controller:
                                              //     anchorController,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text('Date'),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 200,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: "",
                                                readOnly: true,
                                                controller: dateCont,
                                                padding:
                                                EdgeInsets.all(0),
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                suffixIcon: Icon(Icons
                                                    .date_range_outlined),
                                                hintText:
                                                "Invoice Issue date",
                                                onTap: () =>
                                                    _selectDate(context),
                                                keyboardType:
                                                TextInputType.number,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text('Due Date'),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 200,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: "",
                                                readOnly: true,
                                                controller: dueDateCont,
                                                padding:
                                                EdgeInsets.all(0),
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                suffixIcon: Icon(Icons
                                                    .date_range_outlined),
                                                hintText:
                                                "Invoice Due date",
                                                onTap: () =>
                                                    _selectDueDate(
                                                        context),
                                                keyboardType:
                                                TextInputType.number,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text('Tenure'),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 200,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: '',
                                                showBorder: false,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                padding:
                                                EdgeInsets.all(0),
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                hintText: "Tenure",
                                                controller:
                                                tenureController,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text('PO Number'),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 200,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: '',
                                                showBorder: false,
                                                padding:
                                                EdgeInsets.all(0),
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                hintText: "PO Number",
                                                controller:
                                                poNumberController,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 1,
                                  width:
                                  MediaQuery.of(context).size.width,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Column(
                                  children: [
                                    for (int i = 0;
                                    i < descriptionQuantity;
                                    i++)
                                      descriptionPanel(i),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          descriptionQuantity++;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: HexColor('#3AC0C9'),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '+ ADD ITEM',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 443,
                                      //height: 120,
                                      //color:HexColor('#828282'),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('Notes'),
                                          Container(
                                            height: 300,
                                            width: 443,
                                            //height: 90,
                                            child: UserTextFormField(
                                              label: '',
                                              showBorder: false,
                                              inputFieldHeight: 280,
                                              expand: true,
                                              padding:
                                              const EdgeInsets.all(
                                                  0.0),
                                              fillColor: Color.fromRGBO(
                                                  239, 239, 239, 1.0),
                                              hintText: "",
                                              controller: notesController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      // width: 210,
                                      // height: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Text('SubTotal:'),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                width: 90,
                                                //height: 90,
                                                child: UserTextFormField(
                                                  label: '',
                                                  padding:
                                                  EdgeInsets.all(0),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  showBorder: true,
                                                  hintText: "",
                                                  readOnly: true,
                                                  controller:
                                                  subTotalController,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text('Discount: '),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                width: 90,
                                                //height: 90,
                                                child: UserTextFormField(
                                                  label: '',
                                                  readOnly:
                                                  (selectedDiscountType ==
                                                      "" ||
                                                      selectedDiscountType ==
                                                          "None")
                                                      ? true
                                                      : false,
                                                  padding:
                                                  EdgeInsets.all(0),
                                                  borderRadius: 0,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  showBorder: true,
                                                  hintText: "",
                                                  controller:
                                                  discountController,
                                                  onChanged: (v) {
                                                    calculateAmounts();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text('Tax:'),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                width: 90,
                                                //height: 90,
                                                child: UserTextFormField(
                                                  label: '',
                                                  padding:
                                                  EdgeInsets.all(0),
                                                  borderRadius: 0,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  showBorder: true,
                                                  hintText: "",
                                                  controller:
                                                  taxController,
                                                  onChanged: (v) {
                                                    calculateAmounts();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text('Total:'),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                width: 90,
                                                height: 60,
                                                child: UserTextFormField(
                                                  label: '',
                                                  padding:
                                                  EdgeInsets.all(0),
                                                  borderRadius: 0,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  showBorder: true,
                                                  readOnly: true,
                                                  hintText: "",
                                                  controller:
                                                  totalController,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text('Amount Paid :'),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                width: 90,
                                                child: UserTextFormField(
                                                  label: '',
                                                  //fontSize: 12,
                                                  padding:
                                                  EdgeInsets.all(0),
                                                  borderRadius: 0,
                                                  //expand: true,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  showBorder: true,
                                                  hintText: "",
                                                  controller:
                                                  amountPaidController,
                                                  onChanged: (v) {
                                                    calculateAmounts();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text('Due :'),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                width: 90,
                                                height: 60,
                                                child: UserTextFormField(
                                                  label: '',
                                                  padding:
                                                  EdgeInsets.all(0),
                                                  borderRadius: 0,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  showBorder: true,
                                                  readOnly: true,
                                                  hintText: "",
                                                  controller:
                                                  dueController,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Container(
                              //   width: 300,
                              //   child: UserTextFormField(
                              //     label: "Invoice Currency",
                              //     hintText: "Select Currency",
                              //     padding: EdgeInsets.all(0),
                              //     textFormField: DropdownButtonFormField(
                              //       isExpanded: true,
                              //       validator: (v) {
                              //         if (currencyController.text == '') {
                              //           return "Can't be empty";
                              //         }
                              //         return null;
                              //       },
                              //       items: term.map((String category) {
                              //         return DropdownMenuItem(
                              //           value: category,
                              //           child: Text(category.toString()),
                              //         );
                              //       }).toList(),
                              //       onChanged: (v) async {
                              //         selectedCurrency = v;
                              //         currencyController.text = v;
                              //         //anchor = v;
                              //       },
                              //       value: anchor,
                              //       decoration: InputDecoration(
                              //         border: InputBorder.none,
                              //         filled: true,
                              //         fillColor: Colors.white,
                              //         hintText: "Select Currency",
                              //         hintStyle: TextStyle(
                              //             color: Color.fromRGBO(
                              //                 130, 130, 130, 1),
                              //             fontSize: 14,
                              //             letterSpacing:
                              //             0 /*percentages not used in flutter. defaulting to zero*/,
                              //             fontWeight: FontWeight.normal,
                              //             height: 1),
                              //         contentPadding:
                              //         const EdgeInsets.only(
                              //             left: 8.0,
                              //             bottom: 12.0,
                              //             top: 12.0),
                              //         focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.white),
                              //           borderRadius:
                              //           BorderRadius.circular(15.7),
                              //         ),
                              //         enabledBorder: UnderlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.white),
                              //           borderRadius:
                              //           BorderRadius.circular(15.7),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 300,
                                child: UserTextFormField(
                                  label: "Discount Type",
                                  hintText: "Select Discount Type",
                                  padding: EdgeInsets.all(0),
                                  textFormField: DropdownButtonFormField(
                                    isExpanded: true,
                                    validator: (v) {
                                      if (discountTypeController.text ==
                                          '') {
                                        return "Can't be empty";
                                      }
                                      return null;
                                    },
                                    items: discountType
                                        .map((String category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(category.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (v) async {
                                      selectedDiscountType = v;
                                      discountTypeController.text = v;
                                      //discount = v;
                                      if (v == 'None') {
                                        discountController.text = "";
                                      }
                                      calculateAmounts();
                                      setState(() {
                                        checking = true;
                                      });
                                    },
                                    value: discount,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Select Discount Type",
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              130, 130, 130, 1),
                                          fontSize: 14,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                      contentPadding:
                                      const EdgeInsets.only(
                                          left: 8.0,
                                          bottom: 12.0,
                                          top: 12.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(15.7),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(15.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    var userData =
                                    Map<String, dynamic>.from(
                                        box.get('userData'));

                                    setState(() {
                                      loading = true;
                                    });

                                    dynamic res;
                                    if (file!=null) {
                                      res = await _invoiceBuilderProvider
                                          .saveVendorInvoiceDetails(
                                          vendorController.text,
                                          file);

                                      capsaPrint('Response x $res');
                                    }

                                    var map =
                                    invoiceBuilderModel.map((e) {
                                      return e.toJson();
                                    }).toList(); //convert to map
                                    String itemsList = json.encode(map) ==
                                        "[{\"description\":\"\",\"quantity\":\"\",\"rate\":\"\",\"amount\":\"\"}]"
                                        ? ""
                                        : json.encode(map);

                                    capsaPrint('pass 3');

                                    var _body = {
                                      "panNumber": userData['panNumber'],
                                      "logo": imageUrl,
                                      "old_invoice_number":widget.model.invNo,
                                      "invoice_number":
                                      invoiceNumberController.text,
                                      "invoice_date": dateCont.text != ''
                                          ? DateFormat('yyyy-MM-dd')
                                          .format(_selectedDate)
                                          : '',
                                      "due_date": dueDateCont.text != ''
                                          ? DateFormat('yyyy-MM-dd')
                                          .format(_selectedDueDate)
                                          : '',
                                      "tenure": tenureController.text,
                                      "po_num": poNumberController.text,
                                      "vendor_name":
                                      vendorController.text,
                                      "anchor_name":
                                      anchorNameController.text,
                                      "lineItems": itemsList,
                                      "notes": notesController.text,
                                      "subtotal": subTotalController.text,
                                      "discount": discountController.text,
                                      "tax": taxController.text,
                                      "total": totalController.text,
                                      "amount_paid":
                                      amountPaidController.text,
                                      "balance_due": dueController.text,
                                      "currency": selectedCurrency,
                                      "discount_type":
                                      selectedDiscountType,
                                      "cuGst": _cuGst,
                                      "customer_cin": customer_cin,
                                    };



                                    dynamic saveInvoiceResponse =
                                    await _invoiceBuilderProvider
                                        .updateInvoiceDate(_body);

                                    capsaPrint('Save invoice response xx : $saveInvoiceResponse\n\n$_body\n\n');
                                    if(saveInvoiceResponse['status'] == 'success') {
                                      showToast('Invoice Saved Successfully',
                                        context);
                                    }else{
                                      showToast(saveInvoiceResponse['status'],
                                          context, type: 'error');
                                    }

                                    if(saveInvoiceResponse['status'].toString().toLowerCase() == 'success')
                                    Navigator.pop(context);

                                    //capsaPrint('Pass')

                                    // InvoiceBuilderModel builderModel =
                                    // InvoiceBuilderModel(
                                    //   vendor: vendorController.text,
                                    //   anchor: anchorController.text,
                                    //   invNo: invoiceNumberController.text,
                                    //   invDate: DateFormat('yyyy-MM-dd')
                                    //       .format(_selectedDate),
                                    //   invDueDate: DateFormat('yyyy-MM-dd')
                                    //       .format(_selectedDueDate),
                                    //   tenure: tenureController.text,
                                    //   poNo: poNumberController.text,
                                    //   descriptions: invoiceBuilderModel,
                                    //   total: totalController.text,
                                    //   subTotal: subTotalController.text,
                                    //   tax: taxController.text,
                                    //   paid: amountPaidController.text,
                                    //   balanceDue: dueController.text,
                                    //   currency: selectedCurrency,
                                    // );


                                    // showDialog(
                                    //   // barrierColor: Colors.transparent,
                                    //     context: context,
                                    //     //barrierDismissible: false,
                                    //     builder: (BuildContext context1) {
                                    //       functionBack() {
                                    //         Navigator.pop(context1);
                                    //       }
                                    //
                                    //       return AlertDialog(
                                    //           backgroundColor: Colors
                                    //               .transparent,
                                    //           contentPadding:
                                    //           const EdgeInsets
                                    //               .fromLTRB(12.0,
                                    //               12.0, 12.0, 12.0),
                                    //           // shape: RoundedRectangleBorder(
                                    //           //     borderRadius:
                                    //           //     BorderRadius.all(
                                    //           //         Radius.circular(
                                    //           //             32.0))),
                                    //           elevation: 0,
                                    //           content: vendorDataPresent
                                    //               ? InvoiceViewer(
                                    //             model: builderModel,
                                    //             imageFromUrl: true,
                                    //             imageUrl: imageUrl,
                                    //           )
                                    //               : InvoiceViewer(
                                    //             model: builderModel,
                                    //             imageFromUrl: false,
                                    //             image: file,
                                    //           ));
                                    //     });
                                    // _formKey.currentState.reset();
                                    // resetData();
                                    setState(() {
                                      loading = false;
                                    });
                                    getData();
                                  }
                                },
                                child: loading?CircularProgressIndicator():Container(
                                  height: 59,
                                  width: 233,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15)),
                                    color: HexColor('#0098DB'),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Update Invoice',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              InkWell(
                                onTap: () async {
                                  // if (_formKey.currentState.validate()) {
                                  if (true) {
                                    var userData =
                                    Map<String, dynamic>.from(
                                        box.get('userData'));

                                    // dynamic res;
                                    // if (vendorDataPresent == false) {
                                    //   res = await _invoiceBuilderProvider
                                    //       .saveVendorInvoiceDetails(
                                    //       vendorController.text, file);
                                    //
                                    //   capsaPrint('Response x $res');
                                    // }
                                    //
                                    // var map = invoiceBuilderModel.map((e) {
                                    //   return e.toJson();
                                    // }).toList(); //convert to map
                                    // String itemsList = json.encode(map);


                                    dynamic res;
                                    if (file!=null) {
                                      res = await _invoiceBuilderProvider
                                          .saveVendorInvoiceDetails(
                                          vendorController.text,
                                          file);

                                      capsaPrint('Response x $res');
                                    }

                                    var map =
                                    invoiceBuilderModel.map((e) {
                                      return e.toJson();
                                    }).toList(); //convert to map
                                    String itemsList = json.encode(map) ==
                                        "[{\"description\":\"\",\"quantity\":\"\",\"rate\":\"\",\"amount\":\"\"}]"
                                        ? ""
                                        : json.encode(map);

                                    capsaPrint('pass 3');

                                    var _body = {
                                      "panNumber": userData['panNumber'],
                                      "logo": imageUrl,
                                      "old_invoice_number":widget.model.invNo,
                                      "invoice_number":
                                      invoiceNumberController.text,
                                      "invoice_date": dateCont.text != ''
                                          ? DateFormat('yyyy-MM-dd')
                                          .format(_selectedDate)
                                          : '',
                                      "due_date": dueDateCont.text != ''
                                          ? DateFormat('yyyy-MM-dd')
                                          .format(_selectedDueDate)
                                          : '',
                                      "tenure": tenureController.text,
                                      "po_num": poNumberController.text,
                                      "vendor_name":
                                      vendorController.text,
                                      "anchor_name":
                                      anchorNameController.text,
                                      "lineItems": itemsList,
                                      "notes": notesController.text,
                                      "subtotal": subTotalController.text,
                                      "discount": discountController.text,
                                      "tax": taxController.text,
                                      "total": totalController.text,
                                      "amount_paid":
                                      amountPaidController.text,
                                      "balance_due": dueController.text,
                                      "currency": selectedCurrency,
                                      "discount_type":
                                      discountTypeController.text,
                                      "cuGst": _cuGst,
                                      "customer_cin": customer_cin,
                                    };



                                   _invoiceBuilderProvider
                                        .updateInvoiceDate(_body);

                                    InvoiceBuilderModel builderModel =
                                    InvoiceBuilderModel(
                                        vendor: vendorController.text,
                                        anchor: anchorNameController.text,
                                        invNo: invoiceNumberController
                                            .text,
                                        invDate: dateCont.text != ''
                                            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
                                            _selectedDate)
                                            : '',
                                        invDueDate: dueDateCont
                                            .text !=
                                            ''
                                            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
                                            _selectedDueDate)
                                            : '',
                                        tenure: tenureController.text,
                                        poNo: poNumberController.text,
                                        descriptions:
                                        invoiceBuilderModel,
                                        total: totalController.text,
                                        subTotal:
                                        subTotalController.text,
                                        tax: taxController.text,
                                        paid:
                                        amountPaidController.text,
                                        balanceDue:
                                        dueController.text,
                                        currency: selectedCurrency,
                                        customerCin: customer_cin,
                                    notes: notesController.text);

                                    showDialog(
                                      // barrierColor: Colors.transparent,
                                        context: context,
                                        //barrierDismissible: false,
                                        builder: (BuildContext context1) {
                                          functionBack() {
                                            Navigator.pop(context1);
                                          }

                                          return AlertDialog(
                                              backgroundColor: Colors
                                                  .transparent,
                                              contentPadding:
                                              const EdgeInsets
                                                  .fromLTRB(12.0,
                                                  12.0, 12.0, 12.0),
                                              // shape: RoundedRectangleBorder(
                                              //     borderRadius:
                                              //     BorderRadius.all(
                                              //         Radius.circular(
                                              //             32.0))),
                                              elevation: 0,
                                              content: vendorDataPresent
                                                  ? InvoiceViewer(
                                                model: builderModel,
                                                imageFromUrl: true,
                                                imageUrl: imageUrl,
                                              )
                                                  : InvoiceViewer(
                                                model: builderModel,
                                                imageFromUrl: false,
                                                image: file,
                                              ));
                                        });

                                    // var _body = {
                                    //   "panNumber": userData['panNumber'],
                                    //   "logo": imageUrl,
                                    //   "invoice_number":
                                    //   invoiceNumberController.text,
                                    //   "invoice_date": DateFormat('yyyy-MM-dd')
                                    //       .format(_selectedDate),
                                    //   "due_date": DateFormat('yyyy-MM-dd')
                                    //       .format(_selectedDueDate),
                                    //   "tenure": tenureController.text,
                                    //   "po_num": poNumberController.text,
                                    //   "vendor_name": vendorController.text,
                                    //   "anchor_name": anchorController.text,
                                    //   "lineItems": itemsList,
                                    //   "notes": notesController.text,
                                    //   "subtotal": subTotalController.text,
                                    //   "discount": discountController.text,
                                    //   "tax": taxController.text,
                                    //   "total": totalController.text,
                                    //   "amount_paid":
                                    //   amountPaidController.text,
                                    //   "balance_due": dueController.text,
                                    //   "currency": selectedCurrency,
                                    //   "discount_type":
                                    //   discountTypeController.text
                                    // };
                                    //
                                    // dynamic saveInvoiceResponse =
                                    // await _invoiceBuilderProvider
                                    //     .saveInvoiceDate(_body);
                                    // showToast(
                                    //     saveInvoiceResponse['msg'], context);
                                    // _formKey.currentState.reset();
                                    // resetData();
                                    // setState(() {});
                                    // getData();
                                  }
                                },
                                child: Container(
                                  height: 59,
                                  width: 233,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15)),
                                    color: HexColor('#0098DB'),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Download Invoice',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),

                              // InkWell(
                              //
                              // )
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Container(
                      // height: 900,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (file == null &&
                                      vendorDataPresent ==
                                          false) {
                                    FilePickerResult result =
                                    await FilePicker.platform
                                        .pickFiles(
                                      withData: true,
                                      onFileLoading:
                                          (FilePickerStatus p) {},
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'jpg',
                                        'jpeg',
                                        'png'
                                      ],
                                    );

                                    if (result != null) {
                                      if (result.files.first
                                          .extension ==
                                          'jpg' ||
                                          result.files.first
                                              .extension ==
                                              'png') {
                                        setState(() {
                                          file =
                                              result.files.first;
                                          // fileCont.text = file.name;
                                          capsaPrint('ok');
                                        });
                                      } else if (result.files
                                          .first.extension ==
                                          'pdf') {
                                        setState(() {
                                          file =
                                              result.files.first;
                                          // fileCont.text = file.name;
                                        });
                                        // generateTn(file);

                                      } else {
                                        showDialog<void>(
                                            context: context,
                                            builder: (BuildContext
                                            context) {
                                              return AlertDialog(
                                                content: const Text(
                                                    'Invalid Format Selected. Please Select Another File'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      child: Text(
                                                        'OK',
                                                        style:
                                                        TextStyle(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context)),
                                                ],
                                              );
                                            });
                                      }
                                    } else {
                                      showDialog<void>(
                                          context: context,
                                          builder: (BuildContext
                                          context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  'No File Selected!'),
                                              actions: <Widget>[
                                                FlatButton(
                                                    child: Text(
                                                      'OK',
                                                      style:
                                                      TextStyle(
                                                        color: Theme.of(
                                                            context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context)),
                                              ],
                                            );
                                          });
                                    }
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.4,
                                  height: 80,
                                  color: HexColor('#828282'),
                                  child: file != null
                                      ? Image.memory(
                                    file.bytes,
                                    fit: BoxFit.contain,
                                  )
                                      : vendorDataPresent
                                      ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                  )
                                      : Center(
                                      child: Text(
                                          '+ Add you logo')),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Container(
                                  // width: 210,
                                  // height: 120,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text('Invoice'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.4,
                                        //height: 90,
                                        child: UserTextFormField(
                                          label: '',
                                          showBorder: false,
                                          padding:
                                          EdgeInsets.all(0),
                                          fillColor:
                                          Color.fromRGBO(239,
                                              239, 239, 1.0),
                                          prefixIcon: Padding(
                                            padding:
                                            const EdgeInsets
                                                .all(10.0),
                                            child: Text(
                                              '#',
                                              style: GoogleFonts.poppins(
                                                  color: HexColor(
                                                      '#333333')),
                                            ),
                                          ),
                                          hintText:
                                          "Invoice Number",
                                          fontSize: 12,
                                          controller:
                                          invoiceNumberController,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Container(
                                    // width: 210,
                                    // height: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text('From (Vendor)'),
                                        Container(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width *
                                              0.8,
                                          //height: 90,
                                          child:
                                          UserTextFormField(
                                            label: '',
                                            padding:
                                            EdgeInsets.all(0),
                                            showBorder: false,
                                            fillColor:
                                            Color.fromRGBO(
                                                239,
                                                239,
                                                239,
                                                1.0),
                                            hintText:
                                            "Vendor Name",
                                            readOnly:
                                            vendorDataPresent,
                                            controller:
                                            vendorController,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Container(
                                    // width: 210,
                                    // height: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text('To (Anchor)'),
                                        Container(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width *
                                              0.8,
                                          //height: 90,
                                          child:
                                          UserTextFormField(
                                            label: "",
                                            padding:
                                            EdgeInsets.all(0),
                                            hintText:
                                            "Select Anchor",
                                            fillColor:
                                            Color.fromRGBO(
                                                239,
                                                239,
                                                239,
                                                1.0),
                                            textFormField:
                                            DropdownButtonFormField(
                                              isExpanded: true,
                                              validator: (v) {
                                                if (anchorController
                                                    .text ==
                                                    '') {
                                                  return "Can't be empty";
                                                }
                                                return null;
                                              },
                                              items: anchorTerm
                                                  .map((String
                                              category) {
                                                return DropdownMenuItem(
                                                  value: category,
                                                  child: Text(category
                                                      .toString()),
                                                );
                                              }).toList(),
                                              onChanged: (v) {
                                                // capsaPrint(anchorNameList);
                                              if (v ==
                                                    'Not in the list') {
                                                  setState(
                                                          () {
                                                        customAnchorName =
                                                        true;
                                                      });
                                                } else {
                                                  if(customAnchorName = true) {
                                                    setState(() {
                                                      customAnchorName = false;
                                                    });
                                                  }
                                                  anchorNameController.text = v;
                                                  anchorName = v;
                                                  anchorNameList
                                                      .forEach(
                                                          (element1) {
                                                        if (element1[
                                                        'name'] ==
                                                            v) {
                                                          // cacAddress = element1['name_address'];
                                                          anchorController
                                                              .text =
                                                          element1[
                                                          'name_address'];
                                                          _cuGst =
                                                          element1[
                                                          'cu_gst'];
                                                          customer_cin =
                                                          element1[
                                                          'CIN'];

                                                          // capsaPrint(cacAddress);

                                                        }
                                                      });
                                                }
                                              },
                                              value: anchorName,
                                              decoration:
                                              InputDecoration(
                                                border:
                                                InputBorder
                                                    .none,
                                                filled: true,
                                                fillColor: Color
                                                    .fromRGBO(
                                                    239,
                                                    239,
                                                    239,
                                                    1.0),
                                                hintText:
                                                "Select Anchor",
                                                hintStyle: TextStyle(
                                                    color: Color
                                                        .fromRGBO(
                                                        130,
                                                        130,
                                                        130,
                                                        1),
                                                    fontSize: 14,
                                                    letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                    FontWeight
                                                        .normal,
                                                    height: 1),
                                                contentPadding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    bottom:
                                                    12.0,
                                                    top:
                                                    12.0),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .white),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      15.7),
                                                ),
                                                enabledBorder:
                                                UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .white),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      15.7),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Visibility(
                                visible:
                                customAnchorName
                                    ? true
                                    : false,
                                child: Container(
                                  width:
                                  MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.8,
                                  //height: 90,
                                  child:
                                  UserTextFormField(
                                    label: '',
                                    padding:
                                    EdgeInsets
                                        .all(0),
                                    showBorder:
                                    false,
                                    fillColor: Color
                                        .fromRGBO(
                                        239,
                                        239,
                                        239,
                                        1.0),
                                    hintText:
                                    "Anchor Name",
                                    controller:
                                    anchorNameController,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text('Date'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.4,
                                        //height: 90,
                                        child: UserTextFormField(
                                          label: "",
                                          readOnly: true,
                                          controller: dateCont,
                                          padding:
                                          EdgeInsets.all(0),
                                          fontSize: 12,
                                          fillColor:
                                          Color.fromRGBO(239,
                                              239, 239, 1.0),
                                          suffixIcon: Icon(Icons
                                              .date_range_outlined),
                                          hintText:
                                          "Invoice Issue date",
                                          onTap: () =>
                                              _selectDate(
                                                  context),
                                          keyboardType:
                                          TextInputType
                                              .number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text('Due Date'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.4,
                                        //height: 90,
                                        child: UserTextFormField(
                                          label: "",
                                          readOnly: true,
                                          controller: dueDateCont,
                                          fontSize: 12,
                                          padding:
                                          EdgeInsets.all(0),
                                          fillColor:
                                          Color.fromRGBO(239,
                                              239, 239, 1.0),
                                          suffixIcon: Icon(Icons
                                              .date_range_outlined),
                                          hintText:
                                          "Invoice Due date",
                                          onTap: () =>
                                              _selectDueDate(
                                                  context),
                                          keyboardType:
                                          TextInputType
                                              .number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text('Tenure'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.4,
                                        //height: 90,
                                        child: UserTextFormField(
                                          label: '',
                                          showBorder: false,
                                          fontSize: 12,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          padding:
                                          EdgeInsets.all(0),
                                          fillColor:
                                          Color.fromRGBO(239,
                                              239, 239, 1.0),
                                          hintText: "Tenure",
                                          controller:
                                          tenureController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text('PO Number'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.4,
                                        //height: 90,
                                        child: UserTextFormField(
                                          label: '',
                                          showBorder: false,
                                          fontSize: 12,
                                          padding:
                                          EdgeInsets.all(0),
                                          fillColor:
                                          Color.fromRGBO(239,
                                              239, 239, 1.0),
                                          hintText: "PO Number",
                                          controller:
                                          poNumberController,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Column(
                            children: [
                              for (int i = 0;
                              i < descriptionQuantity;
                              i++)
                                descriptionPanel(i),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    descriptionQuantity++;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(15)),
                                    color: HexColor('#3AC0C9'),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+ ADD ITEM',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Text('SubTotal:'),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.3,
                                //height: 40,
                                child: UserTextFormField(
                                  label: '',
                                  padding: EdgeInsets.all(0),
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  showBorder: true,
                                  hintText: "",
                                  readOnly: true,
                                  controller: subTotalController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Text('Discount: '),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.3,
                                //height: 90,
                                child: UserTextFormField(
                                  label: '',
                                  readOnly: (selectedDiscountType ==
                                      "" ||
                                      selectedDiscountType ==
                                          "None")
                                      ? true
                                      : false,
                                  padding: EdgeInsets.all(0),
                                  borderRadius: 0,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  showBorder: true,
                                  hintText: "",
                                  controller: discountController,
                                  onChanged: (v) {
                                    calculateAmounts();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Text('Tax:'),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.3,
                                //height: 40,
                                child: UserTextFormField(
                                  label: '',
                                  padding: EdgeInsets.all(0),
                                  borderRadius: 0,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  showBorder: true,
                                  hintText: "",
                                  controller: taxController,
                                  onChanged: (v) {
                                    calculateAmounts();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Text('Total:'),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.3,
                                //height: 40,
                                child: UserTextFormField(
                                  label: '',
                                  padding: EdgeInsets.all(0),
                                  borderRadius: 0,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  showBorder: true,
                                  readOnly: true,
                                  hintText: "",
                                  controller: totalController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Text('Amount Paid :'),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.3,
                                // height: 40,
                                child: UserTextFormField(
                                  label: '',
                                  //fontSize: 12,
                                  padding: EdgeInsets.all(0),
                                  borderRadius: 0,

                                  // inputFieldHeight: 20,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  showBorder: true,
                                  hintText: "",
                                  //expand: true,
                                  controller:
                                  amountPaidController,
                                  onChanged: (v) {
                                    calculateAmounts();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Text('Due :'),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.3,
                                // height: 40,
                                child: UserTextFormField(
                                  label: '',
                                  padding: EdgeInsets.all(0),
                                  borderRadius: 0,
                                  // inputFieldHeight: 40,
                                  // fontSize: 12,
                                  //expand: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  showBorder: true,
                                  readOnly: true,
                                  hintText: "",
                                  controller: dueController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width,
                            //height: 120,
                            //color:HexColor('#828282'),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('Notes'),
                                Container(
                                  height: 300,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.9,
                                  //height: 90,
                                  child: UserTextFormField(
                                    label: '',
                                    showBorder: false,
                                    inputFieldHeight: 280,
                                    expand: true,
                                    padding:
                                    const EdgeInsets.all(0.0),
                                    fillColor: Color.fromRGBO(
                                        239, 239, 239, 1.0),
                                    hintText: "",
                                    controller: notesController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              // Container(
                              //   width: MediaQuery.of(context)
                              //       .size
                              //       .width *
                              //       0.9,
                              //   // decoration: BoxDecoration(
                              //   //     borderRadius: BorderRadius.all(Radius.circular(0)),
                              //   //     border: Border.all(color: Colors.black)),
                              //   child: UserTextFormField(
                              //     label: "Invoice Currency",
                              //     hintText: "Select Currency",
                              //     showBorder: true,
                              //     padding: EdgeInsets.all(0),
                              //     textFormField:
                              //     DropdownButtonFormField(
                              //       isExpanded: true,
                              //       validator: (v) {
                              //         if (currencyController
                              //             .text ==
                              //             '') {
                              //           return "Can't be empty";
                              //         }
                              //         return null;
                              //       },
                              //       items: term
                              //           .map((String category) {
                              //         return DropdownMenuItem(
                              //           value: category,
                              //           child: Text(
                              //               category.toString()),
                              //         );
                              //       }).toList(),
                              //       onChanged: (v) async {
                              //         selectedCurrency = v;
                              //         currencyController.text = v;
                              //         anchor = v;
                              //         setState(() {
                              //           checking = true;
                              //         });
                              //       },
                              //       value: anchor,
                              //       decoration: InputDecoration(
                              //         filled: true,
                              //         fillColor: Colors.white,
                              //         hintText: "Select Currency",
                              //         hintStyle: TextStyle(
                              //             color: Color.fromRGBO(
                              //                 130, 130, 130, 1),
                              //             fontSize: 12,
                              //             letterSpacing:
                              //             0 /*percentages not used in flutter. defaulting to zero*/,
                              //             fontWeight:
                              //             FontWeight.normal,
                              //             height: 1),
                              //         contentPadding:
                              //         const EdgeInsets.only(
                              //             left: 8.0,
                              //             bottom: 12.0,
                              //             top: 12.0),
                              //         focusedBorder:
                              //         OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.black),
                              //           borderRadius:
                              //           BorderRadius.circular(
                              //               0),
                              //         ),
                              //         enabledBorder:
                              //         UnderlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.black),
                              //           borderRadius:
                              //           BorderRadius.circular(
                              //               0),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.9,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.all(Radius.circular(0)),
                                //     border: Border.all(color: Colors.black)),
                                child: UserTextFormField(
                                  label: "Discount Type",
                                  hintText:
                                  "Select Discount Type",
                                  readOnly: true,
                                  showBorder: true,
                                  padding: EdgeInsets.all(0),
                                  textFormField:
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    validator: (v) {
                                      if (discountTypeController
                                          .text ==
                                          '') {
                                        return "Can't be empty";
                                      }
                                      return null;
                                    },
                                    items: discountType
                                        .map((String category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                            category.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (v) async {
                                      selectedDiscountType = v;
                                      discountTypeController
                                          .text = v;
                                      if (v == 'None') {
                                        discountController.text =
                                        "";
                                      }
                                      calculateAmounts();
                                      discount = v;
                                      setState(() {
                                        checking = true;
                                      });
                                    },
                                    value: discount,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText:
                                      "Select Discount Type",
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              130, 130, 130, 1),
                                          fontSize: 12,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight:
                                          FontWeight.normal,
                                          height: 1),
                                      contentPadding:
                                      const EdgeInsets.only(
                                          left: 8.0,
                                          bottom: 12.0,
                                          top: 12.0),
                                      focusedBorder:
                                      OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black),
                                        borderRadius:
                                        BorderRadius.circular(
                                            0),
                                      ),
                                      enabledBorder:
                                      UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black),
                                        borderRadius:
                                        BorderRadius.circular(
                                            0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // InkWell(
                              //
                              // )
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context)
                                  .size
                                  .height *
                                  0.1),
                        ],
                      ),
                    ),
                  // Expanded(
                  //   child: ,
                  // ),
                ],
              ),
              Responsive.isMobile(context)
                  ? Positioned(
                  bottom: 0,
                  child: Material(
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Color.fromRGBO(243, 243, 243, 1.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              // if (_formKey.currentState.validate()) {
                              if (true) {
                                var userData =
                                Map<String, dynamic>.from(
                                    box.get('userData'));

                                // dynamic res;
                                // if (vendorDataPresent == false) {
                                //   res = await _invoiceBuilderProvider
                                //       .saveVendorInvoiceDetails(
                                //       vendorController.text, file);
                                //
                                //   capsaPrint('Response x $res');
                                // }
                                //
                                // var map = invoiceBuilderModel.map((e) {
                                //   return e.toJson();
                                // }).toList(); //convert to map
                                // String itemsList = json.encode(map);

                                InvoiceBuilderModel builderModel =
                                InvoiceBuilderModel(
                                  vendor: vendorController.text,
                                  anchor:
                                  anchorNameController.text,
                                  invNo: invoiceNumberController
                                      .text,
                                  invDate: dateCont.text != ''
                                      ? DateFormat(
                                      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                      .format(_selectedDate)
                                      : '',
                                  invDueDate: dueDateCont
                                      .text !=
                                      ''
                                      ? DateFormat(
                                      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                      .format(
                                      _selectedDueDate)
                                      : '',
                                  tenure: tenureController.text,
                                  poNo: poNumberController.text,
                                  descriptions:
                                  invoiceBuilderModel,
                                  total: totalController.text,
                                  subTotal:
                                  subTotalController.text,
                                  tax: taxController.text,
                                  paid:
                                  amountPaidController.text,
                                  balanceDue:
                                  dueController.text,
                                  currency: selectedCurrency,
                                  customerCin: customer_cin,
                                  notes: notesController.text,
                                  discount:
                                  discountController.text,
                                );

                                showDialog(
                                  // barrierColor: Colors.transparent,
                                    context: context,
                                    //barrierDismissible: false,
                                    builder: (BuildContext context1) {
                                      return AlertDialog(
                                          backgroundColor: Colors
                                              .transparent,
                                          contentPadding:
                                          const EdgeInsets
                                              .fromLTRB(12.0,
                                              12.0, 12.0, 12.0),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //     BorderRadius.all(
                                          //         Radius.circular(
                                          //             32.0))),
                                          elevation: 0,
                                          content: vendorDataPresent
                                              ? InvoiceViewer(
                                            model: builderModel,
                                            imageFromUrl: true,
                                            imageUrl: imageUrl,
                                          )
                                              : InvoiceViewer(
                                            model: builderModel,
                                            imageFromUrl: false,
                                            image: file,
                                          ));
                                    });

                                // var _body = {
                                //   "panNumber": userData['panNumber'],
                                //   "logo": imageUrl,
                                //   "invoice_number":
                                //   invoiceNumberController.text,
                                //   "invoice_date": DateFormat('yyyy-MM-dd')
                                //       .format(_selectedDate),
                                //   "due_date": DateFormat('yyyy-MM-dd')
                                //       .format(_selectedDueDate),
                                //   "tenure": tenureController.text,
                                //   "po_num": poNumberController.text,
                                //   "vendor_name": vendorController.text,
                                //   "anchor_name": anchorController.text,
                                //   "lineItems": itemsList,
                                //   "notes": notesController.text,
                                //   "subtotal": subTotalController.text,
                                //   "discount": discountController.text,
                                //   "tax": taxController.text,
                                //   "total": totalController.text,
                                //   "amount_paid":
                                //   amountPaidController.text,
                                //   "balance_due": dueController.text,
                                //   "currency": selectedCurrency,
                                //   "discount_type":
                                //   discountTypeController.text
                                // };
                                //
                                // dynamic saveInvoiceResponse =
                                // await _invoiceBuilderProvider
                                //     .saveInvoiceDate(_body);
                                // showToast(
                                //     saveInvoiceResponse['msg'], context);
                                // _formKey.currentState.reset();
                                // resetData();
                                // setState(() {});
                                // getData();
                              }
                            },
                            child: false
                                ? CircularProgressIndicator()
                                : Container(
                              height: 40,
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)),
                              ),
                              child: Center(
                                child: Text(
                                  'Download Invoice',
                                  style: GoogleFonts.poppins(
                                      color: HexColor('#0098DB'),
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {

                                setState(() {
                                  loading = true;
                                });

                                var userData =
                                Map<String, dynamic>.from(
                                    box.get('userData'));

                                dynamic res;
                                if (file!=null) {
                                  res = await _invoiceBuilderProvider
                                      .saveVendorInvoiceDetails(
                                      vendorController.text,
                                      file);

                                  capsaPrint('Response x $res');
                                }

                                var map =
                                invoiceBuilderModel.map((e) {
                                  return e.toJson();
                                }).toList(); //convert to map
                                String itemsList = json.encode(map) ==
                                    "[{\"description\":\"\",\"quantity\":\"\",\"rate\":\"\",\"amount\":\"\"}]"
                                    ? ""
                                    : json.encode(map);

                                capsaPrint('pass 3');

                                var _body = {
                                  "panNumber": userData['panNumber'],
                                  "logo": imageUrl,
                                  "old_invoice_number": widget.model.invNo,
                                  "invoice_number":
                                  invoiceNumberController.text,
                                  "invoice_date": dateCont.text != ''
                                      ? DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate)
                                      : '',
                                  "due_date": dueDateCont.text != ''
                                      ? DateFormat('yyyy-MM-dd')
                                      .format(_selectedDueDate)
                                      : '',
                                  "tenure": tenureController.text,
                                  "po_num": poNumberController.text,
                                  "vendor_name":
                                  vendorController.text,
                                  "anchor_name":
                                  anchorNameController.text,
                                  "lineItems": itemsList,
                                  "notes": notesController.text,
                                  "subtotal": subTotalController.text,
                                  "discount": discountController.text,
                                  "tax": taxController.text,
                                  "total": totalController.text,
                                  "amount_paid":
                                  amountPaidController.text,
                                  "balance_due": dueController.text,
                                  "currency": selectedCurrency,
                                  "discount_type":
                                  discountTypeController.text,
                                  "cuGst": _cuGst,
                                  "customer_cin": customer_cin,
                                };



                                dynamic saveInvoiceResponse =
                                await _invoiceBuilderProvider
                                    .updateInvoiceDate(_body);
                                showToast(saveInvoiceResponse['status'],
                                    context);

                                if(saveInvoiceResponse['status'].toString().toLowerCase() == 'success')
                                  Navigator.pop(context);

                                //capsaPrint('Pass')

                                // InvoiceBuilderModel builderModel =
                                // InvoiceBuilderModel(
                                //   vendor: vendorController.text,
                                //   anchor: anchorController.text,
                                //   invNo: invoiceNumberController.text,
                                //   invDate: DateFormat('yyyy-MM-dd')
                                //       .format(_selectedDate),
                                //   invDueDate: DateFormat('yyyy-MM-dd')
                                //       .format(_selectedDueDate),
                                //   tenure: tenureController.text,
                                //   poNo: poNumberController.text,
                                //   descriptions: invoiceBuilderModel,
                                //   total: totalController.text,
                                //   subTotal: subTotalController.text,
                                //   tax: taxController.text,
                                //   paid: amountPaidController.text,
                                //   balanceDue: dueController.text,
                                //   currency: selectedCurrency,
                                // );


                                // showDialog(
                                //   // barrierColor: Colors.transparent,
                                //     context: context,
                                //     //barrierDismissible: false,
                                //     builder: (BuildContext context1) {
                                //       functionBack() {
                                //         Navigator.pop(context1);
                                //       }
                                //
                                //       return AlertDialog(
                                //           backgroundColor: Colors
                                //               .transparent,
                                //           contentPadding:
                                //           const EdgeInsets
                                //               .fromLTRB(12.0,
                                //               12.0, 12.0, 12.0),
                                //           // shape: RoundedRectangleBorder(
                                //           //     borderRadius:
                                //           //     BorderRadius.all(
                                //           //         Radius.circular(
                                //           //             32.0))),
                                //           elevation: 0,
                                //           content: vendorDataPresent
                                //               ? InvoiceViewer(
                                //             model: builderModel,
                                //             imageFromUrl: true,
                                //             imageUrl: imageUrl,
                                //           )
                                //               : InvoiceViewer(
                                //             model: builderModel,
                                //             imageFromUrl: false,
                                //             image: file,
                                //           ));
                                //     });
                                // _formKey.currentState.reset();
                                // resetData();
                                setState(() {loading = false;});
                                getData();
                              }
                            },
                            child: loading?CircularProgressIndicator():Container(
                              height: 40,
                              width:
                              MediaQuery.of(context).size.width *
                                  0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)),
                                color: HexColor('#0098DB'),
                              ),
                              child: Center(
                                child: Text(
                                  'Update Invoice',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                  : Container()
            ],
          ),
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
