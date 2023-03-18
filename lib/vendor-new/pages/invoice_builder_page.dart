import 'dart:convert';

import 'package:beamer/src/beamer.dart';
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
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/bids_model.dart';
import '../vendor_new.dart';
import 'edit_built_invoice.dart';

class InvoiceBuilderPage extends StatefulWidget {
  const InvoiceBuilderPage({Key key}) : super(key: key);

  @override
  State<InvoiceBuilderPage> createState() => _InvoiceBuilderPageState();
}

class _InvoiceBuilderPageState extends State<InvoiceBuilderPage> {
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
  String _cuGst = "";


  final extendedDueDateCont = TextEditingController();
  final fileCont = TextEditingController(text: '');
  DateTime _extentedDueDate;
  bool showExtendedDate = false;
  String grade = '';

  bool customAnchor = false;

  var anchorName;
  String customer_cin = "";

  var anchorNameList = [];

  dynamic companyDetails = null;

  Map<String, bool> _isBlackListed = {};
  Map<String, String> anchorGrade = {};

  bool loading = false;

  TextEditingController discountTypeController =
      TextEditingController(text: '');

  TextEditingController dueDateCont = TextEditingController(text: '');
  TextEditingController dateCont = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  bool vendorDataPresent = false;
  String imageUrl = "";

  // TextEditingController dummyController = TextEditingController(text: '');

  List<String> description = [];
  List<String> quantity = [];
  List<String> rate = [];
  List<String> totalAmount = [];

  String selectedDiscountType = "Amount";
  dynamic discount = "Amount";

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

  DateTime _selectedDueDate;
  DateTime _selectedDate;

  List<String> anchorTerm;
  Map<String, String> cuGst = {};
  Map<String, String> cacAddress = {};

  bool dataLoaded = false;

  InvoiceModel getInvoiceDetails(InvoiceBuilderModel model) {
    final Box box = Hive.box('capsaBox');

    var userData = box.get('userData');

    final InvoiceModel invoice = InvoiceModel(
      cuGst: cuGst[model.anchor] ?? "1234",
      anchor: model.anchor,
      cacAddress: cacAddress[model.anchor] ?? 'XXX123XXX',
      invNo: model.invNo,
      poNo: model.poNo,
      date: DateFormat('yyyy-mm-dd').format(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(model.invDate)),
      invDate: DateFormat('yyyy-mm-dd').format(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(model.invDate)),
      invDueDate: DateFormat('yyyy-mm-dd').format(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(model.invDueDate)),
      terms: model.tenure,
      invAmt: model.total,
      // invDueDate:
      //     dueDateCont.text,
      invAmount: model.total,
      details: model.notes,
      invSell: model.total,
      buyNowPrice: '0',
      rate: '0',
      tenureDaysDiff: model.tenure,

      fileType: '.png',
      bvnNo: userData['panNumber'],
    );

    return invoice;
  }

  void resetData() {
    dummyController = TextEditingController(text: '');
    invoiceNumberController = TextEditingController(text: '');
    vendorController = TextEditingController(text: '');
    anchorController = TextEditingController(text: '');
    anchorNameController = TextEditingController(text: '');
    //anchorName = "";
    tenureController = TextEditingController(text: '');
    poNumberController = TextEditingController(text: '');
    notesController = TextEditingController(text: '');

    subTotalController = TextEditingController(text: '');
    discountController = TextEditingController(text: '');
    taxController = TextEditingController(text: '');
    totalController = TextEditingController(text: '');
    amountPaidController = TextEditingController(text: '');
    dueController = TextEditingController(text: '');

    //anchorTerm = ["Select One"];

    discountTypeController = TextEditingController(text: 'Amount');

    dueDateCont = TextEditingController(text: '');
    dateCont = TextEditingController(text: '');
  }

  void calculateAmounts() {
    double subTotal = 0;
    double due = 0;
    double discount = discountController.text == ''
        ? 0
        : double.parse(discountController.text.replaceAll(',', ''));
    double tax =
    taxController.text == '' ? 0 : double.parse(taxController.text.replaceAll(',', ''));
    double amountPaid = amountPaidController.text == ''
        ? 0
        : double.parse(amountPaidController.text.replaceAll(',', ''));
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

    subTotalController.text = formatCurrency(subTotal.toString());

    totalController.text = formatCurrency(total.toString());
    dueController.text = formatCurrency(due.toString());
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

      if (showExtendedDate == true) {
        _extentedDueDate =
            newSelectedDate.add(Duration(days: grade == 'C' ? 30 : 45));
        extendedDueDateCont.text = DateFormat.yMMMd().format(_extentedDueDate);
      }
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
                                if (descriptionQuantity > 1) {
                                  descriptionQuantity--;
                                }
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
    capsaPrint('invoice builder initialisation pass 0');
    final invoiceProvider =
        Provider.of<InvoiceBuilderProvider>(context, listen: false);

    dynamic _vendorData = await invoiceProvider.getVendorInvoiceDetails();

    capsaPrint('Date Initialised $_vendorData ');

    capsaPrint('invoice builder initialisation pass 1');

    if (_vendorData['msg'] == null) {
      dynamic details = _vendorData['data']['details'];
      if (_vendorData['data']['details'] == null) {
        details = _vendorData['data']['data'];
      }
      capsaPrint('invoice builder initialisation pass 1.1');
      imageUrl = details['logo'];
      capsaPrint('invoice builder initialisation pass 1.2');
      capsaPrint('Image Url : $imageUrl');
      capsaPrint('invoice builder initialisation pass 1.3');
      vendorDataPresent = true;
      capsaPrint('invoice builder initialisation pass 1.3');
      vendorController.text = details['vendor_name'];
      capsaPrint('invoice builder initialisation pass 1.4');
    }

    //capsaPrint('invoice builder initialisation pass 1.1');

    // dynamic _data = await invoiceProvider.getCurrencies();
    //
    // capsaPrint('invoice builder initialisation pass 2');
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

    capsaPrint('invoice builder initialisation pass 3');

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
          cuGst[element['name'].toString()] = element['cu_gst'];
          cacAddress[element['name'].toString()] = element['name_address'];
          _isBlackListed[element['name'].toString()] =
              element['isBlacklisted'] != null
                  ? element['isBlacklisted'] == '1'
                      ? true
                      : false
                  : false;
          anchorGrade[element['name'].toString()] =
              element['grade'] ?? '';
        });

        anchorTerm.add('Not in the list');
      }
    }

    capsaPrint('invoice builder initialisation pass 4');

    setState(() {
      dataLoaded = true;
    });
  }

  // Future<dynamic> getCompanyNames(BuildContext context) async {
  //
  //
  //   return companyDetails;
  // }

  Widget invoiceListItem(
      InvoiceBuilderModel model, InvoiceBuilderProvider provider) {
    return Padding(
      padding: Responsive.isMobile(context)
          ? const EdgeInsets.only(left: 30, right: 30, top: 8, bottom: 8)
          : const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: Container(
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  model.invNo,
                  style: GoogleFonts.poppins(
                      fontSize: Responsive.isMobile(context) ? 18 : 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.5)),
                ),
                Row(
                  children: [
                    model.complete
                        ? InkWell(
                            onTap: () {
                              dynamic invoice = getInvoiceDetails(model);

                              showDialog(
                                  // barrierColor: Colors.transparent,
                                  context: context,
                                  //barrierDismissible: false,
                                  builder: (BuildContext context1) {
                                    functionBack() {
                                      Navigator.pop(context1);
                                    }

                                    return AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                12.0, 12.0, 12.0, 12.0),
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //     BorderRadius.all(
                                        //         Radius.circular(
                                        //             32.0))),
                                        elevation: 0,
                                        content: InvoiceViewer(
                                          model: model,
                                          imageFromUrl: true,
                                          uploadForApproval: true,
                                          invoice: invoice,
                                          imageUrl:
                                              "https://storage.googleapis.com/download/storage/v1/b/fir-anchor-creditassessment.appspot.com/o/%2Ffoldername%2F22151153491_company_logo.jpg?generation=1667648335754143&alt=media",
                                        ));
                                  }).then((value) {
                                setState(() {});
                              });
                            },
                            child: Icon(Icons.upload),
                          )
                        : Container(),
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          this.context,
                          MaterialPageRoute(
                            builder: (context) => VendorMain(
                                pageUrl: "/upload-kyc-document",
                                mobileTitle: "Edit Your Invoice",
                                menuList: false,
                                backButton: true,
                                pop: true,
                                body: InvoiceBuilderEditPage(
                                  model: model,
                                )),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Icon(Icons.edit),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    InkWell(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            barrierDismissible: true, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'Are you sure you want to delete invoice\nwith invoice number ${model.invNo}?')

                                      // Text('Would you like to approve of this message?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () async {
                                      dynamic response = await provider
                                          .deleteInvoiceDraft(model.invNo);
                                      if (response['status'] == 'success') {
                                        showToast(
                                            'Invoice deleted successfully',
                                            context);
                                      } else {
                                        showToast(
                                            'Invoice could not be deleted',
                                            context,
                                            type: 'warning');
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.delete))
                  ],
                )
              ],
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();

    capsaPrint('\n\nInvoice Builder Page \n\n\n');

    getData();
  }

  @override
  Widget build(BuildContext context) {
    InvoiceBuilderProvider invoiceBuilderProvider =
        Provider.of<InvoiceBuilderProvider>(
      context,
    );

    capsaPrint('Context Build $anchorTerm');

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
                                                  : vendorDataPresent
                                                      ? Image.network(
                                                          imageUrl,
                                                          fit: BoxFit.fill,
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
                                                    width: 200,
                                                    //height: 90,
                                                    child: UserTextFormField(
                                                      label: '',
                                                      showBorder: false,
                                                      fillColor: Color.fromRGBO(
                                                          239, 239, 239, 1.0),
                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          '#',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: HexColor(
                                                                      '#333333')),
                                                        ),
                                                      ),
                                                      hintText:
                                                          "Invoice Number",
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
                                                      child: UserTextFormField(
                                                        label: "",
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        hintText:
                                                            "Select Anchor",
                                                        fillColor:
                                                            Color.fromRGBO(239,
                                                                239, 239, 1.0),
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
                                                          items: anchorTerm.map(
                                                              (String
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
                                                              setState(() {
                                                                customAnchor =
                                                                    true;
                                                              });
                                                              _cuGst = '';
                                                              customer_cin = '';
                                                              anchorNameController
                                                                  .text = '';
                                                            } else {
                                                              if (customAnchor =
                                                                  true) {
                                                                setState(() {
                                                                  customAnchor =
                                                                      false;
                                                                });
                                                              }
                                                              anchorNameController
                                                                  .text = v;
                                                              if (_isBlackListed[
                                                                  v]) {
                                                                showToast(
                                                                    'Functionalities for this anchor is temporarily suspended',
                                                                    context,
                                                                    type:
                                                                        'warning');
                                                                _formKey
                                                                    .currentState
                                                                    .reset();
                                                              } else {
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
                                                                    grade =
                                                                    anchorGrade[v];
                                                                    capsaPrint(
                                                                        'Grade initiated : ${anchor} $grade');
                                                                    // _cuGst =
                                                                    // element1['cu_gst'];

                                                                    if (grade == 'D' ||
                                                                        grade == 'C') {
                                                                      showDialog(
                                                                          context: context,
                                                                          barrierDismissible:
                                                                          true,
                                                                          builder:
                                                                              (BuildContext
                                                                          context) {
                                                                            return AlertDialog(
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius:
                                                                                  BorderRadius.all(
                                                                                      Radius.circular(32.0))),
                                                                              backgroundColor:
                                                                              Color
                                                                                  .fromRGBO(
                                                                                  245,
                                                                                  251,
                                                                                  255,
                                                                                  1),
                                                                              content:
                                                                              Container(
                                                                                constraints: Responsive
                                                                                    .isMobile(
                                                                                    context)
                                                                                    ? BoxConstraints(
                                                                                  minHeight:
                                                                                  300,
                                                                                )
                                                                                    : BoxConstraints(
                                                                                    minHeight:
                                                                                    220,
                                                                                    maxWidth:
                                                                                    584),
                                                                                decoration:
                                                                                BoxDecoration(
                                                                                  color: Color
                                                                                      .fromRGBO(
                                                                                      245,
                                                                                      251,
                                                                                      255,
                                                                                      1),
                                                                                ),
                                                                                child:
                                                                                Padding(
                                                                                  padding:
                                                                                  const EdgeInsets.fromLTRB(
                                                                                      6,
                                                                                      8,
                                                                                      6,
                                                                                      8),
                                                                                  child:
                                                                                  Column(
                                                                                    mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .center,
                                                                                    crossAxisAlignment:
                                                                                    CrossAxisAlignment
                                                                                        .center,
                                                                                    mainAxisSize:
                                                                                    MainAxisSize
                                                                                        .min,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height:
                                                                                        8,
                                                                                      ),
                                                                                      Image.asset(
                                                                                          'assets/icons/warning.png'),
                                                                                      SizedBox(
                                                                                        height:
                                                                                        22,
                                                                                      ),
                                                                                      Text(
                                                                                          "Your anchor is a Grade $grade Anchor and as such your tenure date and invoice due date has been extended by " +
                                                                                              (grade == 'C' ? '30' : '45') +
                                                                                              " days.\n\nThis will affect the quality of your bid rates. Do you wish to continue with your invoice upload?",
                                                                                          textAlign: TextAlign.center),
                                                                                      SizedBox(
                                                                                        height:
                                                                                        30,
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment:
                                                                                        MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          InkWell(
                                                                                            onTap: () {
                                                                                              anchor = null;
                                                                                              anchorController.text = '';
                                                                                              _cuGst = '';
                                                                                              _formKey.currentState.reset();
                                                                                              Navigator.pop(context);
                                                                                              //capsaPrint('${anchor} ${anchorController.text}');
                                                                                            },
                                                                                            child: Container(
                                                                                                width: Responsive.isMobile(context) ? 100 : 160,
                                                                                                height: 49,
                                                                                                decoration: BoxDecoration(border: Border.all(width: 2, color: HexColor('#0098DB')), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    'Cancel',
                                                                                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: HexColor('#0098DB'), fontSize: Responsive.isMobile(context) ? 12 : 18,),
                                                                                                  ),
                                                                                                )),
                                                                                          ),
                                                                                          InkWell(
                                                                                            onTap: () async {
                                                                                              Navigator.pop(context);
                                                                                              setState(() {
                                                                                                showExtendedDate = true;
                                                                                              });
                                                                                              // Beamer.of(context)
                                                                                              //     .beamToNamed('/confirmInvoice');

                                                                                              // showToast('Confirm invoice Details',
                                                                                              //     context,
                                                                                              //     type: "info");
                                                                                            },
                                                                                            child: Container(
                                                                                                width: Responsive.isMobile(context) ? 100 : 160,
                                                                                                height: 49,
                                                                                                decoration: BoxDecoration(color: HexColor('#0098DB'), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    'Yes, proceed',
                                                                                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white, fontSize: Responsive.isMobile(context) ? 12 : 18,),
                                                                                                  ),
                                                                                                )),
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          });
                                                                    } else {
                                                                      setState(() {
                                                                        showExtendedDate =
                                                                        false;
                                                                      });
                                                                    }

                                                                    capsaPrint(
                                                                        customer_cin);
                                                                  }
                                                                });
                                                              }
                                                            }
                                                          },
                                                          value: anchorName,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            filled: true,
                                                            fillColor:
                                                                Color.fromRGBO(
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
                                                                    top: 12.0),
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
                                                    Visibility(
                                                      visible: customAnchor
                                                          ? true
                                                          : false,
                                                      child: Container(
                                                        width: 200,
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
                                                              "Anchor Name",
                                                          controller:
                                                              anchorNameController,
                                                        ),
                                                      ),
                                                    ),

                                                    // Container(
                                                    //   width: 200,
                                                    //   child: UserTextFormField(
                                                    //     label: "",
                                                    //     hintText: "Select Anchor",
                                                    //     padding: EdgeInsets.all(0),
                                                    //     textFormField: DropdownButtonFormField(
                                                    //       isExpanded: true,
                                                    //       validator: (v) {
                                                    //         if (anchorController.text == '') {
                                                    //           return "Can't be empty";
                                                    //         }
                                                    //         return null;
                                                    //       },
                                                    //       items: anchorTerm.map((String category) {
                                                    //         return DropdownMenuItem(
                                                    //           value: category,
                                                    //           child: Text(category.toString()),
                                                    //         );
                                                    //       }).toList(),
                                                    //       onChanged: (v) async {
                                                    //         //anchorName = v;
                                                    //         // currencyController.text = v;
                                                    //         // anchor = v;
                                                    //         // setState(() {
                                                    //         //   checking = true;
                                                    //         // });
                                                    //       },
                                                    //       value: anchorName,
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
                                                          v = formatCurrency(v);
                                                          discountController.value = TextEditingValue(
                                                            text: v,
                                                            selection: TextSelection.collapsed(offset: v.length),
                                                          );

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
                                                          v = formatCurrency(v);
                                                          taxController.value = TextEditingValue(
                                                            text: v,
                                                            selection: TextSelection.collapsed(offset: v.length),
                                                          );
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
                                                          v = formatCurrency(v);
                                                          amountPaidController.value = TextEditingValue(
                                                            text: v,
                                                            selection: TextSelection.collapsed(offset: v.length),
                                                          );
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
                                    //         anchor = v;
                                    //         setState(() {
                                    //           checking = true;
                                    //         });
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
                                    //                 0 /*percentages not used in flutter. defaulting to zero*/,
                                    //             fontWeight: FontWeight.normal,
                                    //             height: 1),
                                    //         contentPadding:
                                    //             const EdgeInsets.only(
                                    //                 left: 8.0,
                                    //                 bottom: 12.0,
                                    //                 top: 12.0),
                                    //         focusedBorder: OutlineInputBorder(
                                    //           borderSide: BorderSide(
                                    //               color: Colors.white),
                                    //           borderRadius:
                                    //               BorderRadius.circular(15.7),
                                    //         ),
                                    //         enabledBorder: UnderlineInputBorder(
                                    //           borderSide: BorderSide(
                                    //               color: Colors.white),
                                    //           borderRadius:
                                    //               BorderRadius.circular(15.7),
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
                                            discount = v;
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
                                          setState(() {
                                            loading = true;
                                          });

                                          capsaPrint('pass 1');

                                          var userData =
                                              Map<String, dynamic>.from(
                                                  box.get('userData'));

                                          dynamic res;
                                          if (true) {
                                            res = await invoiceBuilderProvider
                                                .saveVendorInvoiceDetails(
                                                    vendorController.text,
                                                    file);

                                            capsaPrint('Response x $res');
                                          }

                                          capsaPrint(
                                              'pass 2 ${invoiceBuilderModel.length}');

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
                                            "tax": taxController.text.replaceAll(',', ''),
                                            "total": totalController.text.replaceAll(',', ''),
                                            "amount_paid":
                                                amountPaidController.text.replaceAll(',', ''),
                                            "balance_due": dueController.text.replaceAll(',', ''),
                                            "currency": selectedCurrency,
                                            "discount_type":
                                                selectedDiscountType,
                                            "cuGst": _cuGst,
                                            "customer_cin": customer_cin,
                                          };

                                          capsaPrint('pass 4');

                                          dynamic saveInvoiceResponse =
                                              await invoiceBuilderProvider
                                                  .saveInvoiceDate(_body);

                                          capsaPrint('pass 5x $anchorTerm');

                                          if (saveInvoiceResponse['status'] ==
                                              'failed') {
                                            showToast(
                                                saveInvoiceResponse['msg'],
                                                context,
                                                type: 'error');
                                            setState(() {
                                              loading = false;
                                            });
                                          } else if (saveInvoiceResponse[
                                                  'status'] ==
                                              'success') {
                                            showToast(
                                                'Invoice saved successfully',
                                                context);
                                          }

                                          capsaPrint('pass 6x');

                                          InvoiceBuilderModel builderModel =
                                              InvoiceBuilderModel(
                                                  vendor: vendorController.text,
                                                  anchor: anchorNameController
                                                      .text,
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
                                                  tenure: tenureController.text.replaceAll(',', ''),
                                                  poNo: poNumberController.text.replaceAll(',', ''),
                                                  descriptions:
                                                      invoiceBuilderModel,
                                                  total: totalController.text.replaceAll(',', ''),
                                                  subTotal:
                                                      subTotalController.text.replaceAll(',', ''),
                                                  tax: taxController.text.replaceAll(',', ''),
                                                  paid:
                                                      amountPaidController.text.replaceAll(',', ''),
                                                  balanceDue:
                                                      dueController.text.replaceAll(',', ''),
                                                  currency: selectedCurrency.replaceAll(',', ''),
                                                  notes: notesController.text,
                                                  customerCin: customer_cin);

                                          capsaPrint('pass 7x');

                                          if (saveInvoiceResponse['status'] !=
                                              'failed') {
                                            showDialog(
                                                // barrierColor: Colors.transparent,
                                                context: context,
                                                //barrierDismissible: false,
                                                builder:
                                                    (BuildContext context1) {
                                                  functionBack() {
                                                    Navigator.pop(context1);
                                                  }

                                                  return AlertDialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              12.0,
                                                              12.0,
                                                              12.0,
                                                              12.0),
                                                      // shape: RoundedRectangleBorder(
                                                      //     borderRadius:
                                                      //     BorderRadius.all(
                                                      //         Radius.circular(
                                                      //             32.0))),
                                                      elevation: 0,
                                                      content: vendorDataPresent
                                                          ? InvoiceViewer(
                                                              model:
                                                                  builderModel,
                                                              imageFromUrl:
                                                                  true,
                                                              imageUrl:
                                                                  imageUrl,
                                                            )
                                                          : InvoiceViewer(
                                                              model:
                                                                  builderModel,
                                                              imageFromUrl:
                                                                  false,
                                                              image: file,
                                                            ));
                                                }).then((value) {
                                              context.beamToNamed(
                                                  '/invoice-history');
                                            });
                                          }
                                          capsaPrint('pass 8x');
                                          //_formKey.currentState.reset();
                                          setState(() {
                                            loading = false;
                                          });
                                          capsaPrint('pass 9x $anchorTerm');
                                          //resetData();
                                          setState(() {
                                            dataLoaded = false;
                                          });
                                          getData();
                                        }
                                      },
                                      child: loading
                                          ? CircularProgressIndicator()
                                          : Container(
                                              height: 59,
                                              width: 233,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                color: HexColor('#0098DB'),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Save Invoice',
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
                                              total: totalController.text.replaceAll(',', ''),
                                              subTotal:
                                              subTotalController.text.replaceAll(',', ''),
                                              tax: taxController.text.replaceAll(',', ''),
                                              paid:
                                              amountPaidController.text.replaceAll(',', ''),
                                              balanceDue:
                                              dueController.text.replaceAll(',', ''),
                                              currency: selectedCurrency,
                                              customerCin: customer_cin,
                                              notes: notesController.text,
                                              discount:
                                              discountController.text);

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

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                          height: 2, color: Colors.grey),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            context.beamToNamed(
                                                '/invoice-history');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Container(
                                              height: 59,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                color: HexColor('#0098DB'),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'History',
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   height: MediaQuery.of(context)
                                    //       .size
                                    //       .height,
                                    //   child: SingleChildScrollView(
                                    //     child: Column(
                                    //       children: [
                                    //         for (var element in models)
                                    //           invoiceListItem(element, invoiceBuilderProvider),
                                    //         SizedBox(height: 20),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),

                                    SizedBox(
                                      height: 10,
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
                                            if (result.files.first.extension ==
                                                    'jpg' ||
                                                result.files.first.extension ==
                                                    'png') {
                                              setState(() {
                                                file = result.files.first;
                                                // fileCont.text = file.name;
                                                capsaPrint('ok');
                                              });
                                            } else if (result
                                                    .files.first.extension ==
                                                'pdf') {
                                              setState(() {
                                                file = result.files.first;
                                                // fileCont.text = file.name;
                                              });
                                              // generateTn(file);

                                            } else {
                                              showDialog<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                          'Invalid Format Selected. Please Select Another File'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                            child: Text(
                                                              'OK',
                                                              style: TextStyle(
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        'No File Selected!'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          child: Text(
                                                            'OK',
                                                            style: TextStyle(
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height: 80,
                                        color: HexColor('#828282'),
                                        child: file != null
                                            ? Image.memory(
                                                file.bytes,
                                                fit: BoxFit.cover,
                                              )
                                            : vendorDataPresent
                                                ? Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child:
                                                        Text('+ Add you logo')),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: '',
                                                showBorder: false,
                                                padding: EdgeInsets.all(0),
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    '#',
                                                    style: GoogleFonts.poppins(
                                                        color: HexColor(
                                                            '#333333')),
                                                  ),
                                                ),
                                                hintText: "Invoice Number",
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                //height: 90,
                                                child: UserTextFormField(
                                                  label: '',
                                                  padding: EdgeInsets.all(0),
                                                  showBorder: false,
                                                  fillColor: Color.fromRGBO(
                                                      239, 239, 239, 1.0),
                                                  hintText: "Vendor Name",
                                                  controller: vendorController,
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                //height: 90,
                                                child: UserTextFormField(
                                                  label: "",
                                                  padding: EdgeInsets.all(0),
                                                  hintText: "Select Anchor",
                                                  fillColor: Color.fromRGBO(
                                                      239, 239, 239, 1.0),
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
                                                        .map((String category) {
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
                                                        setState(() {
                                                          customAnchor = true;
                                                        });
                                                        _cuGst = '';
                                                        customer_cin = '';
                                                        anchorNameController
                                                            .text = '';
                                                      } else {
                                                        if (customAnchor =
                                                            true) {
                                                          setState(() {
                                                            customAnchor =
                                                                false;
                                                          });
                                                        }
                                                        anchorNameController
                                                            .text = v;
                                                        if (_isBlackListed[v]) {
                                                          showToast(
                                                              'Functionalities for this anchor is temporarily suspended',
                                                              context,
                                                              type: 'warning');
                                                          _formKey.currentState
                                                              .reset();
                                                        } else {
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
                                                              _cuGst = element1[
                                                                  'cu_gst'];
                                                              customer_cin =
                                                                  element1[
                                                                      'CIN'];

                                                              capsaPrint(
                                                                  customer_cin);
                                                            }
                                                          });
                                                        }
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
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.7),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.7),
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
                                      visible: customAnchor ? true : false,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        //height: 90,
                                        child: UserTextFormField(
                                          label: '',
                                          padding: EdgeInsets.all(0),
                                          showBorder: false,
                                          fillColor: Color.fromRGBO(
                                              239, 239, 239, 1.0),
                                          hintText: "Anchor Name",
                                          controller: anchorNameController,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: "",
                                                readOnly: true,
                                                controller: dateCont,
                                                padding: EdgeInsets.all(0),
                                                fontSize: 12,
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                suffixIcon: Icon(
                                                    Icons.date_range_outlined),
                                                hintText: "Invoice Issue date",
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: "",
                                                readOnly: true,
                                                controller: dueDateCont,
                                                fontSize: 12,
                                                padding: EdgeInsets.all(0),
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                suffixIcon: Icon(
                                                    Icons.date_range_outlined),
                                                hintText: "Invoice Due date",
                                                onTap: () =>
                                                    _selectDueDate(context),
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
                                              width: MediaQuery.of(context)
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
                                                padding: EdgeInsets.all(0),
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                hintText: "Tenure",
                                                controller: tenureController,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              //height: 90,
                                              child: UserTextFormField(
                                                label: '',
                                                showBorder: false,
                                                fontSize: 12,
                                                padding: EdgeInsets.all(0),
                                                fillColor: Color.fromRGBO(
                                                    239, 239, 239, 1.0),
                                                hintText: "PO Number",
                                                controller: poNumberController,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          borderRadius: BorderRadius.all(
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('SubTotal:'),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      //height: 40,
                                      child: UserTextFormField(
                                        label: '',
                                        padding: EdgeInsets.all(0),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Discount: '),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      //height: 90,
                                      child: UserTextFormField(
                                        label: '',
                                        readOnly: (selectedDiscountType == "" ||
                                                selectedDiscountType == "None")
                                            ? true
                                            : false,
                                        padding: EdgeInsets.all(0),
                                        borderRadius: 0,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Tax:'),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      //height: 40,
                                      child: UserTextFormField(
                                        label: '',
                                        padding: EdgeInsets.all(0),
                                        borderRadius: 0,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Total:'),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      //height: 40,
                                      child: UserTextFormField(
                                        label: '',
                                        padding: EdgeInsets.all(0),
                                        borderRadius: 0,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Amount Paid :'),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      // height: 40,
                                      child: UserTextFormField(
                                        label: '',
                                        //fontSize: 12,
                                        padding: EdgeInsets.all(0),
                                        borderRadius: 0,

                                        // inputFieldHeight: 20,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        showBorder: true,
                                        hintText: "",
                                        //expand: true,
                                        controller: amountPaidController,
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Due :'),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
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
                                          FilteringTextInputFormatter.digitsOnly
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
                                  width: MediaQuery.of(context).size.width,
                                  //height: 120,
                                  //color:HexColor('#828282'),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Notes'),
                                      Container(
                                        height: 300,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        //height: 90,
                                        child: UserTextFormField(
                                          label: '',
                                          showBorder: false,
                                          inputFieldHeight: 280,
                                          expand: true,
                                          padding: const EdgeInsets.all(0.0),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   width: MediaQuery.of(context).size.width *
                                    //       0.9,
                                    //   // decoration: BoxDecoration(
                                    //   //     borderRadius: BorderRadius.all(Radius.circular(0)),
                                    //   //     border: Border.all(color: Colors.black)),
                                    //   child: UserTextFormField(
                                    //     label: "Invoice Currency",
                                    //     hintText: "Select Currency",
                                    //     showBorder: true,
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
                                    //                 0 /*percentages not used in flutter. defaulting to zero*/,
                                    //             fontWeight: FontWeight.normal,
                                    //             height: 1),
                                    //         contentPadding:
                                    //             const EdgeInsets.only(
                                    //                 left: 8.0,
                                    //                 bottom: 12.0,
                                    //                 top: 12.0),
                                    //         focusedBorder: OutlineInputBorder(
                                    //           borderSide: BorderSide(
                                    //               color: Colors.black),
                                    //           borderRadius:
                                    //               BorderRadius.circular(0),
                                    //         ),
                                    //         enabledBorder: UnderlineInputBorder(
                                    //           borderSide: BorderSide(
                                    //               color: Colors.black),
                                    //           borderRadius:
                                    //               BorderRadius.circular(0),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.all(Radius.circular(0)),
                                      //     border: Border.all(color: Colors.black)),
                                      child: UserTextFormField(
                                        label: "Discount Type",
                                        hintText: "Select Discount Type",
                                        readOnly: true,
                                        showBorder: true,
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
                                            if (v == 'None') {
                                              discountController.text = "";
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
                                            hintText: "Select Discount Type",
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    130, 130, 130, 1),
                                                fontSize: 12,
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
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(0),
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
                                SizedBox(height: 10),
                                Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context.beamToNamed('/invoice-history');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text('History',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: Colors.blue)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
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

                                        capsaPrint('pass 1');

                                        var userData =
                                        Map<String, dynamic>.from(
                                            box.get('userData'));

                                        dynamic res;
                                        if (true) {
                                          res = await invoiceBuilderProvider
                                              .saveVendorInvoiceDetails(
                                              vendorController.text,
                                              file);

                                          capsaPrint('Response x $res');
                                        }

                                        capsaPrint(
                                            'pass 2 ${invoiceBuilderModel.length}');

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
                                          "subtotal": subTotalController.text.replaceAll(',', ''),
                                          "discount": discountController.text.replaceAll(',', ''),
                                          "tax": taxController.text.replaceAll(',', ''),
                                          "total": totalController.text.replaceAll(',', ''),
                                          "amount_paid":
                                          amountPaidController.text.replaceAll(',', ''),
                                          "balance_due": dueController.text.replaceAll(',', ''),
                                          "currency": selectedCurrency.replaceAll(',', ''),
                                          "discount_type":
                                          selectedDiscountType,
                                          "cuGst": _cuGst,
                                          "customer_cin": customer_cin,
                                        };

                                        capsaPrint('pass 4');

                                        dynamic saveInvoiceResponse =
                                        await invoiceBuilderProvider
                                            .saveInvoiceDate(_body);

                                        capsaPrint('pass 5x $anchorTerm');

                                        if (saveInvoiceResponse['status'] ==
                                            'failed') {
                                          showToast(
                                              saveInvoiceResponse['msg'],
                                              context,
                                              type: 'error');
                                          setState(() {
                                            loading = false;
                                          });
                                        } else if (saveInvoiceResponse[
                                        'status'] ==
                                            'success') {
                                          showToast(
                                              'Invoice saved successfully',
                                              context);
                                        }

                                        capsaPrint('pass 6x');

                                        InvoiceBuilderModel builderModel =
                                        InvoiceBuilderModel(
                                            vendor: vendorController.text,
                                            anchor: anchorNameController
                                                .text,
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
                                            total: totalController.text.replaceAll(',', ''),
                                            subTotal:
                                            subTotalController.text.replaceAll(',', ''),
                                            tax: taxController.text.replaceAll(',', ''),
                                            paid:
                                            amountPaidController.text.replaceAll(',', ''),
                                            balanceDue:
                                            dueController.text.replaceAll(',', ''),
                                            currency: selectedCurrency,
                                            customerCin: customer_cin);

                                        capsaPrint('pass 7x');

                                        if (saveInvoiceResponse['status'] !=
                                            'failed') {
                                          showDialog(
                                            // barrierColor: Colors.transparent,
                                              context: context,
                                              //barrierDismissible: false,
                                              builder:
                                                  (BuildContext context1) {
                                                functionBack() {
                                                  Navigator.pop(context1);
                                                }

                                                return AlertDialog(
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    contentPadding:
                                                    const EdgeInsets
                                                        .fromLTRB(
                                                        12.0,
                                                        12.0,
                                                        12.0,
                                                        12.0),
                                                    // shape: RoundedRectangleBorder(
                                                    //     borderRadius:
                                                    //     BorderRadius.all(
                                                    //         Radius.circular(
                                                    //             32.0))),
                                                    elevation: 0,
                                                    content: vendorDataPresent
                                                        ? InvoiceViewer(
                                                      model:
                                                      builderModel,
                                                      imageFromUrl:
                                                      true,
                                                      imageUrl:
                                                      imageUrl,
                                                    )
                                                        : InvoiceViewer(
                                                      model:
                                                      builderModel,
                                                      imageFromUrl:
                                                      false,
                                                      image: file,
                                                    ));
                                              }).then((value) {
                                            context.beamToNamed(
                                                '/invoice-history');
                                          });
                                        }
                                        capsaPrint('pass 8x');
                                        //_formKey.currentState.reset();
                                        setState(() {
                                          loading = false;
                                        });
                                        capsaPrint('pass 9x $anchorTerm');
                                        //resetData();
                                        setState(() {
                                          dataLoaded = false;
                                        });
                                        getData();
                                      }
                                    },
                                    child: loading
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
                                              color: HexColor('#0098DB'),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Save Invoice',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
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
