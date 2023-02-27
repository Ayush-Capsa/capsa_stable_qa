import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:capsa/admin/models/invoice_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';

import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/GeneratedDesktopMenuWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:http/http.dart' as http;

class EditInvoiceAdmin extends StatefulWidget {
  InvoiceModel invoice;
  EditInvoiceAdmin({Key key, @required this.invoice}) : super(key: key);

  @override
  State<EditInvoiceAdmin> createState() => _EditInvoiceAdminState();
}

class _EditInvoiceAdminState extends State<EditInvoiceAdmin> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');
  final dueDateCont = TextEditingController();
  final dateCont = TextEditingController();
  final fileCont = TextEditingController(text: '');
  DateTime _selectedDate;
  DateTime _selectedDueDate;
  var _cuGst;

  bool saving = false;

  final rateController2 = TextEditingController(text: '');

  dynamic companyDetails = null;

  Future<dynamic> getCompanyNames(BuildContext context) async {
    if (companyDetails == null) {
      print('Comapny Names');
      dynamic data = await getCompanyName();
      companyDetails = data;
    }

    return companyDetails;
  }

  int navigate() {
    Beamer.of(context).beamToNamed('/confirmInvoice');
    return 1;
  }

  // void updateAdmin(String panNumber){
  //
  //
  //
  // }

  void updateInvoice(String panNumber) async{

    print('update field');

    var _body = {};
    _body['company_pan'] = panNumber;
    _body['cu_gst'] = widget.invoice.cu_gst;
    _body['customer_gst'] = widget.invoice.cu_gst;
    _body['previous_invoice_number'] = widget.invoice.invoiceNumber;
    _body['invoice_number'] = invoiceNoController.text;
    _body['invoice_due_date'] = dueDateCont.text;
    _body['description'] = detailsController.text;
    _body['invoice_quantity'] = widget.invoice.invoiceQuantity;
    _body['invoice_value'] = invoiceAmtController.text;
    _body['payment_terms'] = tenureController.text;
    _body['rate'] = rateController2.text;
    _body['buyNowPrice'] = buyAmtController.text;

    String _url = apiUrl + '/admin/';
    dynamic _uri = _url + 'updateInvoice';
    //_uri = Uri.parse(_uri);

    //var request = http.MultipartRequest('POST', Uri.parse(_uri));

    print('Body : $_body \n$_uri');


    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    capsaPrint('Update Invoice e: ${response.body}');
    if(data['res'] == 'success'){
      showToast('Update Successful', context);
    }else{
      showToast(data['msg'], context, type: 'error');
    }
    Navigator.pop(context);
  }

  Future getCompanyName() async {
    String _url = apiUrl + 'dashboard/r/';
    dynamic _uri = _url + 'getCompanyName';
    _uri = Uri.parse(_uri);
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    _body['panNumber'] = userData['panNumber'];
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    capsaPrint("Bank Data $data");
    return data;
  }

  void calculateRate() {
    //print('x');
    rateController2.text = '';
    var invAmt = invoiceAmtController.text;
    var invSell = buyAmtController.text;
    if (invAmt == null) return;
    // if(invSell == null) invSell = 0;
    if (_selectedDate == null) return;
    if (_selectedDueDate == null) return;

    if (invSell == null || invSell == '') invSell = '0';

    tenureDaysDiff = _selectedDueDate.difference(_selectedDate).inDays;

    // num rate = (((num.tryParse(invAmt) - num.tryParse(invSell)) / (num.tryParse(invAmt) * 1) * 100) / 360) * tenureDaysDiff;
    num rate = 0;
    if (num.tryParse(invSell) > 0) {
      rate = ((num.tryParse(invAmt) / num.tryParse(invSell)) - 1) *
          (1 / tenureDaysDiff) *
          365;
    }
    //  (INVOICE AMOUNT/SELL NOW PRICE - 1) * (1-TENURE) * 365 DAYS

    // setState(() {
    if (rate == 'Infinity') {
      rateController2.text = '0';
    }
    rateController2.text = rate.toStringAsFixed(2);
    if (rateController2.text == 'Infinity') {
      rateController2.text = '0';
    }

    // });
  }

  var term = ["Select One"];

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
        ..text = DateFormat('yyyy-MM-dd').format(_selectedDueDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dueDateCont.text.length, affinity: TextAffinity.upstream));
      calculateRate();
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
      calculateRate();
    }
  }

  final anchorNameController = TextEditingController(text: '');
  final anchorController = TextEditingController(text: '');
  final invoiceNoController = TextEditingController(text: '');
  final poController = TextEditingController(text: '');
  final tenureController = TextEditingController(text: '');
  final invoiceAmtController = TextEditingController(text: '');
  final buyAmtController = TextEditingController(text: '');
  final detailsController = TextEditingController(text: '');
  var anchor;

  // var anchor, cacAddress, invNo, po, terms;

  // var invAmt, details, rate, invDueDate;
  // var invSell = '0';

  var tenureDaysDiff = 0;

  var anchorNameList = [];

  PlatformFile file;

  bool loadingCall = false;
  bool loadingConfirm = false;

  bool nextMobileType = false;
  bool nextEnable = false;

  @override
  void initState() {
    super.initState();

    // final invoiceProvider =
    // Provider.of<InvoiceProvider>(context, listen: false);
    
    capsaPrint("\n\ndescription ${widget.invoice.description}");

    if (true) {
      invoiceNoController.text = widget.invoice.invoiceNumber;
      // poController.text = widget.invoice.poNo;
      tenureController.text = widget.invoice.paymentTerms;
      invoiceAmtController.text = widget.invoice.invoiceValue;
      buyAmtController.text = widget.invoice.askAmt;
      //detailsController.text = widget.invoice.details;
      //anchor = invoiceFormData["anchor"];
      anchorNameController.text = widget.invoice.customerName;
      detailsController.text = widget.invoice.description;
      dateCont.text = DateFormat('yyyy-MM-dd')
          .format(DateFormat("yyyy-MM-dd")
          .parse(widget.invoice.invoiceDate))
          .toString();
      _selectedDate = DateFormat("yyyy-MM-dd")
          .parse(widget.invoice.invoiceDate);
      dueDateCont.text = DateFormat('yyyy-MM-dd')
          .format(DateFormat("yyyy-MM-dd")
          .parse(widget.invoice.invoiceDueDate))
          .toString();
      _selectedDueDate = DateFormat("yyyy-MM-dd")
          .parse(widget.invoice.invoiceDueDate);
      //tenureDaysDiff = num.parse(invoiceFormData["tenureDaysDiff"]);
      //rateController2.text = widget.invoice.askRate;
      dueDateCont.text = DateFormat('yyyy-MM-dd')
          .format(DateFormat("yyyy-MM-dd")
          .parse(widget.invoice.invoiceDueDate))
          .toString();
      //fileCont.text = invoiceFormData["fileCont"];
      //_selectedDate = invoiceFormData["_selectedDate"];
      _selectedDueDate = DateFormat("yyyy-MM-dd")
          .parse(widget.invoice.invoiceDueDate);
      //file = invoiceFormData["file"];
      //_cuGst = invoiceFormData["cuGst"];

      calculateRate();
    }

    //invoiceProvider.splitInvoice('DH001', '50000000');
  }

  @override
  Widget build(BuildContext context) {
    // final invoiceProvider =
    // Provider.of<InvoiceProvider>(context, listen: false);

    if (Responsive.isMobile(context)) {
      nextMobileType = true;
      nextEnable = false;
    }

    return Scaffold(
      body: Row(
          children: [
            Container(
              width: Responsive.isMobile(context) ? 0 : 185,
              height: MediaQuery.of(context).size.height * 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0.0),
                ),
                color: Color.fromARGB(255, 15, 15, 15),
              ),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: [
                  Positioned(
                      left: 42.5,
                      top: 38.0,
                      right: null,
                      bottom: null,
                      width: 34,
                      height: 34,
                      child: Container(
                        width: 80.0,
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.zero,
                            child: Image.asset(
                              "assets/images/arrow-left.png",
                              color: null,
                              fit: BoxFit.cover,
                              width: 34.0,
                              height: 34,
                              colorBlendMode: BlendMode.dstATop,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            true?Container(
              //height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        height: 22,
                      ),
                    // TopBarWidget("Edit Invoice", ""),
                    // SizedBox(
                    //   height: (!Responsive.isMobile(context)) ? 8 : 15,
                    // ),
                    if (Responsive.isMobile(context)) mobileFormSteper(),
                    FutureBuilder<Object>(
                        future: getCompanyNames(context),
                        builder: (context, snapshot) {
                          if (companyDetails == null) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          int i = 0;
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'There was an error :(\n' +
                                    snapshot.error.toString(),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            dynamic _data = snapshot.data;

                            var _items = _data['data'];
                            Map<String, bool> _isBlackListed = {};

                            var anchorNameList = [];

                            capsaPrint('Data $_items');

                            if (_data['res'] == 'success') {
                              anchorNameList = _items;
                              term = [];
                              _items.forEach((element) {
                                if(widget.invoice.customerName == element['name']){
                                  anchorController.text = element['name_address'];
                                }
                              });
                            } else {
                              return Center(
                                child: Text(
                                  'There was an error :(\n' +
                                      _data['messg'].toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              );
                            }

                            // ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                            final GlobalKey<FormFieldState> _key =
                                GlobalKey<FormFieldState>();

                            return Container(
                              width: MediaQuery.of(context).size.width - 240,
                              child: Form(
                                // onChanged: ,
                                key: _formKey,
                                child: OrientationSwitcher(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // orientation: Responsive.isMobile(context) ? "Column" : "Row" ,
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            OrientationSwitcher(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Anchor Name",
                                                    hintText: "Select Anchor",
                                                    controller: anchorNameController,
                                                    readOnly: true,
                                                    // textFormField:
                                                    //     DropdownButtonFormField(
                                                    //   isExpanded: true,
                                                    //   validator: (v) {
                                                    //     if (anchorController
                                                    //             .text ==
                                                    //         '') {
                                                    //       return "Can't be empty";
                                                    //     }
                                                    //     return null;
                                                    //   },
                                                    //   items: term
                                                    //       .map((String category) {
                                                    //     return DropdownMenuItem(
                                                    //       value: category,
                                                    //       child: Text(category
                                                    //           .toString()),
                                                    //     );
                                                    //   }).toList(),
                                                    //   onChanged: (v) {
                                                    //     // capsaPrint(anchorNameList);
                                                    //     if (_isBlackListed[v]) {
                                                    //       showToast(
                                                    //           'Functionalities for this anchor is temporarily suspended',
                                                    //           context,
                                                    //           type: 'warning');
                                                    //       _formKey.currentState
                                                    //           .reset();
                                                    //     } else {
                                                    //       anchor = v;
                                                    //       anchorNameList.forEach(
                                                    //           (element1) {
                                                    //         if (element1[
                                                    //                 'name'] ==
                                                    //             v) {
                                                    //           // cacAddress = element1['name_address'];
                                                    //           anchorController
                                                    //                   .text =
                                                    //               element1[
                                                    //                   'name_address'];
                                                    //           _cuGst = element1[
                                                    //               'cu_gst'];
                                                    //
                                                    //           // capsaPrint(cacAddress);
                                                    //
                                                    //         }
                                                    //       });
                                                    //     }
                                                    //   },
                                                    //   value: anchor,
                                                    //   decoration: InputDecoration(
                                                    //     border: InputBorder.none,
                                                    //     filled: true,
                                                    //     fillColor: Colors.white,
                                                    //     hintText: "Select Anchor",
                                                    //     hintStyle: TextStyle(
                                                    //         color: Color.fromRGBO(
                                                    //             130, 130, 130, 1),
                                                    //         fontSize: 14,
                                                    //         letterSpacing:
                                                    //             0 /*percentages not used in flutter. defaulting to zero*/,
                                                    //         fontWeight:
                                                    //             FontWeight.normal,
                                                    //         height: 1),
                                                    //     contentPadding:
                                                    //         const EdgeInsets.only(
                                                    //             left: 8.0,
                                                    //             bottom: 12.0,
                                                    //             top: 12.0),
                                                    //     focusedBorder:
                                                    //         OutlineInputBorder(
                                                    //       borderSide: BorderSide(
                                                    //           color:
                                                    //               Colors.white),
                                                    //       borderRadius:
                                                    //           BorderRadius
                                                    //               .circular(15.7),
                                                    //     ),
                                                    //     enabledBorder:
                                                    //         UnderlineInputBorder(
                                                    //       borderSide: BorderSide(
                                                    //           color:
                                                    //               Colors.white),
                                                    //       borderRadius:
                                                    //           BorderRadius
                                                    //               .circular(15.7),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "CAC/Address",
                                                    hintText: "",
                                                    controller: anchorController,
                                                    readOnly: true,
                                                    validator: (val) {
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            OrientationSwitcher(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Invoice No",
                                                    hintText: "Invoice Number",
                                                    readOnly: true,
                                                    controller:
                                                        invoiceNoController,
                                                    onChanged: (v) {
                                                      String s = v;
                                                      if (v.contains('/') ||
                                                          v.contains(r'\')) {
                                                        showToast(
                                                            'Invoice Number Cannot Contain  /  or  '
                                                            r'\',
                                                            context,
                                                            type: 'warning');
                                                        s = s.replaceAll(
                                                            r'\', '-');
                                                        s = s.replaceAll(
                                                            '/', '-');
                                                      }
                                                      invoiceNoController.text =
                                                          s;
                                                      invoiceNoController
                                                              .selection =
                                                          TextSelection.fromPosition(
                                                              TextPosition(
                                                                  offset:
                                                                      invoiceNoController
                                                                          .text
                                                                          .length));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            OrientationSwitcher(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Issue Date",
                                                    readOnly: true,
                                                    controller: dateCont,
                                                    suffixIcon: Icon(Icons
                                                        .date_range_outlined),
                                                    hintText:
                                                        "Invoice Issue date",
                                                    // onTap: () =>
                                                    //     _selectDate(context),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Due Date",
                                                    suffixIcon: Icon(Icons
                                                        .date_range_outlined),
                                                    readOnly: true,
                                                    controller: dueDateCont,
                                                    hintText: "Invoice Due Date",
                                                    onTap: () =>
                                                        _selectDueDate(context),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            OrientationSwitcher(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Tenure",
                                                    hintText: "30 or 60 Days?",
                                                    controller: tenureController,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Invoice Amount",
                                                    hintText:
                                                        "Enter invoice amount",
                                                    prefixIcon: Image.asset(
                                                        "assets/images/currency.png"),
                                                    controller:
                                                        invoiceAmtController,
                                                    onChanged: (v) {
                                                      calculateRate();
                                                    },
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp(r"[0-9.]")),
                                                      TextInputFormatter
                                                          .withFunction((oldValue,
                                                              newValue) {
                                                        try {
                                                          final text =
                                                              newValue.text;
                                                          if (text.isNotEmpty)
                                                            double.parse(text);
                                                          return newValue;
                                                        } catch (e) {}
                                                        return oldValue;
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            OrientationSwitcher(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Sell Now Price",
                                                    hintText:
                                                        "Amount to sell invoice",
                                                    prefixIcon: Image.asset(
                                                        "assets/images/currency.png"),
                                                    validator: (v) {
                                                      return null;
                                                    },
                                                    onChanged: (v) {
                                                      if (num.parse(v) >=
                                                          num.parse(
                                                              invoiceAmtController
                                                                  .text)) {
                                                        buyAmtController.text =
                                                            "";
                                                        showToast(
                                                            'Sell Now Price cann\'t be greater then invoice amount',
                                                            context);
                                                      }
                                                      calculateRate();
                                                    },
                                                    controller: buyAmtController,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: [
                                                      // CurrencyTextInputFormatter(locale: "en_US",decimalDigits: 2),
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp(r"[0-9.]")),
                                                      TextInputFormatter
                                                          .withFunction((oldValue,
                                                              newValue) {
                                                        try {
                                                          final text =
                                                              newValue.text;
                                                          if (text.isNotEmpty)
                                                            double.parse(text);
                                                          return newValue;
                                                        } catch (e) {}
                                                        return oldValue;
                                                      }),
                                                    ],
                                                    // prefixIcon : Text()
                                                  ),
                                                ),
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Discount rate",
                                                    hintText: "",
                                                    readOnly: true,
                                                    controller: rateController2,
                                                    suffixIcon: Image.asset(
                                                        "assets/images/%.png"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            OrientationSwitcher(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: UserTextFormField(
                                                    // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                    label:
                                                        "Details (e.g items or quantity)",
                                                    hintText: "48 packs of goods",
                                                    controller: detailsController,
                                                    minLines: 1,
                                                    readOnly: true,
                                                    maxLines: 5,
                                                    validator: (val) {
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      saving = true;
                                                    });

                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      updateInvoice(widget.invoice.companyPan);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 230,
                                                    height: 59,
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15),
                                                        topRight: Radius.circular(15),
                                                        bottomLeft:
                                                        Radius.circular(15),
                                                        bottomRight:
                                                        Radius.circular(15),
                                                      ),
                                                      color: Color.fromRGBO(
                                                          0, 152, 219, 1),
                                                    ),
                                                    child: saving
                                                        ? const Center(
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.all(8.0),
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                        ),
                                                      ),
                                                    )
                                                        : Center(
                                                      child: Text(
                                                        'Save',
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                          fontSize: 24,
                                                          letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: 230,
                                                    height: 59,
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15),
                                                        topRight: Radius.circular(15),
                                                        bottomLeft:
                                                        Radius.circular(15),
                                                        bottomRight:
                                                        Radius.circular(15),
                                                      ),
                                                      color: Colors.red,
                                                    ),
                                                    child: saving
                                                        ? const Center(
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.all(8.0),
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                        ),
                                                      ),
                                                    )
                                                        : Center(
                                                      child: Text(
                                                        'Cancel',
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                          fontSize: 24,
                                                          letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )

                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            );
                          } else if (!snapshot.hasData) {
                            return Center(child: Text("No history found."));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ],
                ),
              ),
            ):Container(),
          ],
        ),
    );
  }

  Widget mobileFormSteper() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Center(
          child: Stack(children: <Widget>[
            Positioned(
                top: 14,
                left: 104,
                child: Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(130, 130, 130, 1),
                    ))),
            Positioned(
                top: 0,
                left: 67,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: Color.fromRGBO(245, 251, 255, 1),
                    border: Border.all(
                      color: Color.fromRGBO(0, 152, 219, 1),
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '1',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 0,
                left: 184,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: Color.fromRGBO(245, 251, 255, 1),
                    border: Border.all(
                      color: Color.fromRGBO(130, 130, 130, 1),
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '2',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(130, 130, 130, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                )),
          ]),
        ));
  }
}

class SplitInvoiceWarning extends StatelessWidget {
  String invNo;
  Function nav;
  SplitInvoiceWarning({Key key, @required this.invNo, @required this.nav})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 584,
      height: 579,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: HexColor('#F5FBFF')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/warning.png',
            width: 80,
            height: 80,
          ),
          Text(
            'Invoice Splitting',
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Text(
            'Please note that your invoice will be split into smaller invoices. This will allow for faster trading of your invoice.\n\n This does not affect the invoice value. A breakdown of the split can be seen on the next page.',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: () {
              // nav;
              // Beamer.of(context).beamToNamed('/confirmInvoice');
              Navigator.pop(context);
            },
            child: Container(
              height: 60,
              width: 342,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: HexColor('#0098DB')),
              child: Center(
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
