import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/vendor-new/pages/add_invoice/confirm_invoice.dart';
import 'package:capsa/vendor-new/pages/confirm_invoice_page.dart';

import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class EditInvoice extends StatefulWidget {
  dynamic data;
  EditInvoice({Key key, @required this.data}) : super(key: key);

  @override
  State<EditInvoice> createState() => _EditInvoiceState();
}

class _EditInvoiceState extends State<EditInvoice> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');
  final dueDateCont = TextEditingController();
  final dateCont = TextEditingController();
  final extendedDueDateCont = TextEditingController();
  final fileCont = TextEditingController(text: '');
  DateTime _selectedDate;
  DateTime _selectedDueDate;
  DateTime _extendedDueDate;
  var _cuGst;
  bool showExtendedDate = false;
  dynamic invoiceFileResponse;
  Map<String, String> anchorGrade = {};
  String grade;

  bool saving = false;

  final rateController2 = TextEditingController(text: '');

  dynamic companyDetails = null;

  Future<dynamic> getCompanyNames(BuildContext context) async {
    print('company called');
    if (companyDetails == null) {
      invoiceFileResponse =
      await Provider.of<InvoiceProvider>(context, listen: false)
          .getInvFile({'fName': widget.data['invoice_file']});
      dynamic data =
      await Provider.of<VendorActionProvider>(context, listen: false)
          .getCompanyName();
      companyDetails = data;
      if (data['res'] == 'success') {
        anchorNameList = data['data'];
        term = [];
        anchorNameList.forEach((element) {
          if (!term.contains(element['name'])) {
            term.add(element['name']);
            anchorGrade[element['name'].toString()] = element['grade'] ?? '';
            if (widget.data['customer_name'] == element['name']) {
              anchor = widget.data['customer_name'];
              anchorController.text = element['name_address'];
              _cuGst = element['cu_gst'];
              grade = element['grade'] ?? '';
              if (grade == 'C' || grade == 'D') {
                showExtendedDate = true;
              }
            }
          }
        });
      }
      capsaPrint('Company Details: \n\n$companyDetails');
    }

    return companyDetails;
  }

  int navigate() {
    Beamer.of(context).beamToNamed('/confirmInvoice');
    return 1;
  }

  void calculateRate() {
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
        initialDate: _selectedDueDate != null
            ? _selectedDueDate.difference(DateTime(2000)).inMicroseconds < 0
            ? DateTime.now()
            : _selectedDueDate
            : DateTime.now(),
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
        _extendedDueDate =
            newSelectedDate.add(Duration(days: grade == 'C' ? 30 : 45));
        extendedDueDateCont.text = DateFormat.yMMMd().format(_extendedDueDate);
      }
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

    capsaPrint('\nedit pending invoice data\n\n${widget.data}');

    final invoiceProvider =
    Provider.of<InvoiceProvider>(context, listen: false);

    if (true) {
      final invoiceFormData = invoiceProvider.invoiceFormData;

      print('Invoice Form Data : \n$invoiceFormData \n${widget.data}');

      capsaPrint('pass 1');

      invoiceNoController.text = widget.data['invoice_number'].toString();
      poController.text = widget.data['invoice_line_items'].toString();
      capsaPrint('pass 1.6');
      tenureController.text = widget.data['payment_terms'].toString();
      invoiceAmtController.text = widget.data['invoice_value'].toString();
      buyAmtController.text = widget.data['ask_amt'].toString();

      detailsController.text = widget.data['description'].toString();
      capsaPrint('pass 1.8');
      //anchor = invoiceFormData["anchor"];
      //anchorController.text = invoiceFormData["anchorAddress"];
      _extendedDueDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.data['effective_due_date']);
      tenureDaysDiff = 0;
      rateController2.text =  widget.data['ask_rate'].toString();

      fileCont.text = '';
      capsaPrint('pass 1.9 ${widget.data['invoice_date']}');
      _selectedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(
          widget.data['invoice_date']);
      capsaPrint('pass 1.10 ${widget.data['invoice_due_date']}');
      try{
        _selectedDueDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            .parse(widget.data['invoice_due_date']);
        dueDateCont.text = DateFormat.yMMMd('en_US').format(_selectedDueDate);
        extendedDueDateCont.text =
            DateFormat.yMMMd('en_US').format(_extendedDueDate);
      }catch(e){
        capsaPrint('pass 1.11');
      }


      dateCont.text = DateFormat.yMMMd('en_US').format(_selectedDate);

      _cuGst = widget.data['customer_gst'].toString();
      capsaPrint('pass 2');
    }

    anchor = widget.data['customer_name'];
    anchorController.text = widget.data['customer_name'];
    _cuGst = widget.data['customer_gst'];
    capsaPrint('pass 3');

    //invoiceProvider.splitInvoice('DH001', '50000000');
  }

  @override
  Widget build(BuildContext context) {
    final invoiceProvider =
    Provider.of<InvoiceProvider>(context, listen: false);

    if (Responsive.isMobile(context)) {
      nextMobileType = true;
      nextEnable = false;
    }

    return Scaffold(
      appBar: !Responsive.isMobile(context)
          ? null
          : AppBar(
        title: Text('Invoice Details'),
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        // actions: [
        //   InkWell(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => EditInvoice(
        //                 data: widget.data,
        //               )),
        //         );
        //       },`
        //       child: Icon(
        //         Icons.edit,
        //         color: Colors.black,
        //       )),
        // ],
      ),
      body: Row(
        children: [
          !Responsive.isMobile(context)
              ? Container(
            //width: 185,
            margin: EdgeInsets.all(0),
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.11,
            // color: Colors.black,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              color: Colors.black,
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.fromLTRB(50.5, 36, 50.5, 24),
                    child: SizedBox(
                      width: 80,
                      height: 45.42,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ChangeNotifierProvider(
                      //         create: (BuildContext
                      //         context) =>
                      //             AnchorActionProvider(),
                      //         child:
                      //        AnchorHomePage()),
                      //   ),
                      // );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: HexColor("#0098DB"),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          )
              : Container(),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
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

                    TopBarWidget("Edit Invoice", ""),
                    SizedBox(
                      height: (!Responsive.isMobile(context)) ? 8 : 15,
                    ),
                    //if (Responsive.isMobile(context)) mobileFormSteper(),
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
                            //print('snapshot data $_data');

                            var _items = _data['data'];

                            capsaPrint('Company Data : \n\n$_items');

                            var anchorNameList = [];

                            if (_data['res'] == 'success') {
                              anchorNameList = _items;
                              term = [];
                              _items.forEach((element) {
                                term.add(element['name']);
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

                            return Container(
                              width: MediaQuery.of(context).size.width,
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
                                                      items: term.map(
                                                              (String category) {
                                                            return DropdownMenuItem(
                                                              value: category,
                                                              child: Text(category
                                                                  .toString()),
                                                            );
                                                          }).toList(),
                                                      onChanged: (v) {
                                                        // capsaPrint(anchorNameList);
                                                        anchor = v;
                                                        anchorNameList.forEach(
                                                                (element1) {
                                                              if (element1[
                                                              'name'] ==
                                                                  v) {
                                                                // cacAddress = element1['name_address'];
                                                                anchorController
                                                                    .text =
                                                                element1[
                                                                'name_address'];
                                                                grade = anchorGrade[
                                                                anchor];
                                                                capsaPrint(
                                                                    'Grade initiated : ${anchor} $grade');
                                                                _cuGst = element1[
                                                                'cu_gst'];

                                                                if (grade == 'D' ||
                                                                    grade == 'C') {
                                                                  showDialog(
                                                                      context:
                                                                      context,
                                                                      barrierDismissible:
                                                                      true,
                                                                      builder:
                                                                          (BuildContext
                                                                      context) {
                                                                        return AlertDialog(
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(32.0))),
                                                                          backgroundColor: Color.fromRGBO(
                                                                              245,
                                                                              251,
                                                                              255,
                                                                              1),
                                                                          content:
                                                                          Container(
                                                                            constraints: Responsive.isMobile(
                                                                                context)
                                                                                ? BoxConstraints(
                                                                              minHeight: 300,
                                                                            )
                                                                                : BoxConstraints(
                                                                                minHeight: 220,
                                                                                maxWidth: 584),
                                                                            decoration:
                                                                            BoxDecoration(
                                                                              color: Color.fromRGBO(
                                                                                  245,
                                                                                  251,
                                                                                  255,
                                                                                  1),
                                                                            ),
                                                                            child:
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(
                                                                                  6,
                                                                                  8,
                                                                                  6,
                                                                                  8),
                                                                              child:
                                                                              Column(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                                mainAxisSize:
                                                                                MainAxisSize.min,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Image.asset('assets/icons/warning.png'),
                                                                                  SizedBox(
                                                                                    height: 22,
                                                                                  ),
                                                                                  Text("Your anchor is a Grade $grade Anchor and as such your tenure date and invoice due date has been extended by " + (grade == 'C' ? '30' : '45') + " days.\n\nThis will affect the quality of your bid rates. Do you wish to continue with your invoice upload?", textAlign: TextAlign.center),
                                                                                  SizedBox(
                                                                                    height: 30,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: HexColor('#0098DB'), fontSize: 18),
                                                                                              ),
                                                                                            )),
                                                                                      ),
                                                                                      InkWell(
                                                                                        onTap: () async {
                                                                                          Navigator.pop(context);
                                                                                          if (_selectedDueDate != null) {
                                                                                            _extendedDueDate = _selectedDueDate.add(Duration(days: grade == 'C' ? 30 : 45));
                                                                                            dueDateCont.text = DateFormat.yMMMd('en_US').format(_selectedDueDate);
                                                                                            extendedDueDateCont.text = DateFormat.yMMMd('en_US').format(_extendedDueDate);
                                                                                          }
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

                                                                // capsaPrint(cacAddress);

                                                              }
                                                            });
                                                      },
                                                      value: anchor,
                                                      decoration:
                                                      InputDecoration(
                                                        border:
                                                        InputBorder.none,
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        hintText:
                                                        "Select Anchor",
                                                        hintStyle: TextStyle(
                                                            color:
                                                            Color.fromRGBO(
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
                                                            bottom: 12.0,
                                                            top: 12.0),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .white),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              15.7),
                                                        ),
                                                        enabledBorder:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
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
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "CAC/Address",
                                                    hintText: "",
                                                    controller:
                                                    anchorController,
                                                    readOnly: true,
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
                                                    controller:
                                                    invoiceNoController,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "PO Number",
                                                    controller: poController,
                                                    hintText:
                                                    "Purchase order Number",
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
                                                    controller:
                                                    tenureController,
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
                                                      if (num.parse(v) >=
                                                          20000000) {
                                                        invoiceAmtController
                                                            .text = "";
                                                        showToast(
                                                            'Create new invoice for amounts\ngreater than 20 Million NGN',
                                                            context);
                                                      }
                                                      calculateRate();
                                                    },
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                          r"[0-9.]")),
                                                      TextInputFormatter
                                                          .withFunction(
                                                              (oldValue,
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
                                                    label: "Issue Date",
                                                    readOnly: true,
                                                    controller: dateCont,
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
                                                Flexible(
                                                  child: UserTextFormField(
                                                    label: "Due Date",
                                                    suffixIcon: Icon(Icons
                                                        .date_range_outlined),
                                                    readOnly: true,
                                                    controller: dueDateCont,
                                                    hintText:
                                                    "Invoice Due Date",
                                                    onTap: () =>
                                                        _selectDueDate(context),
                                                    keyboardType:
                                                    TextInputType.number,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            if (showExtendedDate)
                                              OrientationSwitcher(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: UserTextFormField(
                                                      label:
                                                      "Extended Due Date",
                                                      suffixIcon: Icon(Icons
                                                          .date_range_outlined),
                                                      readOnly: true,
                                                      controller:
                                                      extendedDueDateCont,
                                                      hintText:
                                                      "Extended Invoice Due Date",
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
                                                    controller:
                                                    buyAmtController,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                                    inputFormatters: [
                                                      // CurrencyTextInputFormatter(locale: "en_US",decimalDigits: 2),
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                          r"[0-9.]")),
                                                      TextInputFormatter
                                                          .withFunction(
                                                              (oldValue,
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
                                                    hintText:
                                                    "48 packs of goods",
                                                    controller:
                                                    detailsController,
                                                    minLines: 1,
                                                    maxLines: 5,
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
                                                    controller: fileCont,
                                                    // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                    label: "Upload invoice",
                                                    validator: (v) {
                                                      return null;
                                                    },
                                                    hintText:
                                                    "PDF(Single/Multiple page) or Image File",
                                                    minLines: 1,
                                                    onTap: () async {
                                                      FilePickerResult result =
                                                      await FilePicker
                                                          .platform
                                                          .pickFiles(
                                                        withData: true,
                                                        onFileLoading:
                                                            (FilePickerStatus
                                                        p) {},
                                                        type: FileType.custom,
                                                        allowedExtensions: [
                                                          'jpg',
                                                          'jpeg',
                                                          'pdf',
                                                          'png'
                                                        ],
                                                      );

                                                      if (result != null) {
                                                        if (result.files.first
                                                            .extension ==
                                                            'jpg' ||
                                                            result.files.first
                                                                .extension ==
                                                                'png' || result.files.first
                                                            .extension ==
                                                            'jpeg') {
                                                          setState(() {
                                                            file = result
                                                                .files.first;
                                                            fileCont.text =
                                                                file.name;
                                                            capsaPrint('ok');
                                                          });
                                                        } else if (result
                                                            .files
                                                            .first
                                                            .extension ==
                                                            'pdf') {
                                                          setState(() {
                                                            file = result
                                                                .files.first;
                                                            fileCont.text =
                                                                file.name;
                                                          });
                                                          // generateTn(file);

                                                        } else {
                                                          showDialog<void>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                              context) {
                                                                return AlertDialog(
                                                                  content:
                                                                  const Text(
                                                                      'Invalid Format Selected. Please Select Another File'),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                        child:
                                                                        Text(
                                                                          'OK',
                                                                          style:
                                                                          TextStyle(
                                                                            color:
                                                                            Theme.of(context).primaryColor,
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () =>
                                                                            Navigator.pop(context)),
                                                                  ],
                                                                );
                                                              });
                                                        }
                                                      } else {
                                                        showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                            context) {
                                                              return AlertDialog(
                                                                content: const Text(
                                                                    'No File Selected!'),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                      child:
                                                                      Text(
                                                                        'OK',
                                                                        style:
                                                                        TextStyle(
                                                                          color:
                                                                          Theme.of(context).primaryColor,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () =>
                                                                          Navigator.pop(context)),
                                                                ],
                                                              );
                                                            });
                                                      }
                                                    },
                                                    readOnly: true,
                                                    suffixIcon:
                                                    Icon(Icons.upload_file),
                                                    maxLines: 5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    // Beamer.of(context).beamToNamed('/confirmInvoice');
                                                    // showPopupActionInfo(
                                                    //   context,
                                                    //   heading: "Congratulations! Your invoice has been saved and presented. ",
                                                    //   info: "When your Anchor approves the invoice, you will start receiving bids from Investors.",
                                                    //   buttonText: "View Pending Invoice",
                                                    //   onTap: () {
                                                    //     Navigator.of(context, rootNavigator: true).pop();
                                                    //     invoiceProvider.resetInvoiceFormData();
                                                    //     Beamer.of(context).beamToNamed('/pending-invoices');
                                                    //   },
                                                    // ); return;

                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      setState(() {
                                                        saving = true;
                                                      });
                                                      capsaPrint(
                                                          'Pass 1 edti invoice');
                                                      dynamic invoiceFormData =
                                                      {
                                                        "invoiceNo":
                                                        invoiceNoController
                                                            .text,
                                                        "poNumber":
                                                        poController.text,
                                                        "tenure":
                                                        tenureController
                                                            .text,
                                                        "invAmt":
                                                        invoiceAmtController
                                                            .text,
                                                        "butAmt":
                                                        buyAmtController
                                                            .text,
                                                        "details":
                                                        detailsController
                                                            .text,
                                                        "anchor": anchor,
                                                        "anchorAddress":
                                                        anchorController
                                                            .text,
                                                        "dateCont":
                                                        dateCont.text,
                                                        "tenureDaysDiff":
                                                        tenureDaysDiff
                                                            .toString(),
                                                        "rate": rateController2
                                                            .text,
                                                        "dueDateCont":
                                                        dueDateCont.text,
                                                        "fileCont":
                                                        fileCont.text,
                                                        "_selectedDate":
                                                        _selectedDate,
                                                        "_selectedDueDate":
                                                        _selectedDueDate,
                                                        "file": file,
                                                        "cuGst": _cuGst,
                                                      };

                                                      // capsaPrint(invoiceFormData);

                                                      invoiceProvider
                                                          .setInvoiceFormData(
                                                          invoiceFormData);

                                                      // dynamic invoiceData = invoiceProvider.invoiceFormData;

                                                      capsaPrint(
                                                          'Pass 2 edti invoice \n${widget.data} \n\n' );

                                                      var userData = Map<String,
                                                          dynamic>.from(
                                                          box.get(
                                                              'tmpUserData'));

                                                      var _body = {
                                                        'panNumber': userData[
                                                        'panNumber'],
                                                        'company_pan':
                                                        widget.data[
                                                        'company_pan'],
                                                        'old_invoice_number':
                                                        widget.data[
                                                        'invoice_number'],
                                                        'invoice_number':
                                                        invoiceFormData[
                                                        'invoiceNo'],
                                                        'invoice_due_data':
                                                        DateFormat(
                                                            'yyyy-MM-dd')
                                                            .format(
                                                            _selectedDueDate),
                                                        'description':
                                                        invoiceFormData[
                                                        'details'],
                                                        'invoice_quantity': '1',
                                                        'invoice_value':
                                                        invoiceFormData[
                                                        "invAmt"],
                                                        'payment_terms':
                                                        invoiceFormData[
                                                        "tenureDaysDiff"],
                                                        'rate': invoiceFormData[
                                                        'rate'],
                                                        'buyNowPrice':
                                                        invoiceFormData[
                                                        'butAmt'],
                                                        'poNo': invoiceFormData[
                                                        'poNumber'],
                                                        'userName': widget.data[
                                                        'company_name'],
                                                        'anchor': anchor,
                                                        'cacAddress':
                                                        invoiceFormData[
                                                        'anchorAddress'],
                                                        'invNo':
                                                        invoiceFormData[
                                                        'invoiceNo'],
                                                        'invDate': DateFormat(
                                                            'yyyy-MM-dd')
                                                            .format(
                                                            _selectedDate),
                                                        'terms':
                                                        invoiceFormData[
                                                        'tenure'],
                                                        'invDueDate': DateFormat(
                                                            'yyyy-MM-dd')
                                                            .format(
                                                            _selectedDueDate),
                                                        'details':
                                                        invoiceFormData[
                                                        'details'],
                                                        'invAmount':
                                                        invoiceFormData[
                                                        "invAmt"],
                                                        'tenureDaysDiff':
                                                        tenureDaysDiff,
                                                        'fileType': file == null
                                                            ? ''
                                                            : file.extension,
                                                        'bvnNo': widget.data[
                                                        'company_pan'],
                                                        'cuGst': _cuGst
                                                      };

                                                      _body = {
                                                        'bvnNo': userData[
                                                        'panNumber'],
                                                        'company_pan':
                                                        widget.data[
                                                        'company_pan'],
                                                        'previous_invoice_number':
                                                        widget.data[
                                                        'invoice_number'],
                                                        'invNo':
                                                        invoiceFormData[
                                                        'invoiceNo'],
                                                        'invoice_number': invoiceFormData[
                                                        'invoiceNo'],
                                                        'invoice_due_date':
                                                        DateFormat(
                                                            'yyyy-MM-dd')
                                                            .format(
                                                            _selectedDueDate),
                                                        'invoice_date': DateFormat(
                                                            'yyyy-MM-dd')
                                                            .format(
                                                            _selectedDate),
                                                        'extDueDate': showExtendedDate
                                                            ? DateFormat(
                                                            'yyyy-MM-dd')
                                                            .format(
                                                            _extendedDueDate)
                                                            : DateFormat(
                                                            'yyyy-MM-dd')
                                                            .format(
                                                            _selectedDueDate),
                                                        'description':
                                                        invoiceFormData[
                                                        'details'],
                                                        'invoice_quantity': '1',
                                                        'invoice_value':
                                                        invoiceFormData[
                                                        "invAmt"],
                                                        'payment_terms':
                                                        invoiceFormData[
                                                        "tenureDaysDiff"],
                                                        'rate': invoiceFormData[
                                                        'rate'],
                                                        'buyNowPrice':
                                                        invoiceFormData[
                                                        'butAmt'],
                                                        'poNo': invoiceFormData[
                                                        'poNumber'],
                                                        // 'userName': widget.data[
                                                        // 'company_name'],
                                                        'cuGst': _cuGst,
                                                        'anchor': anchor
                                                      };

                                                      capsaPrint(
                                                          'Pass 2 edti invoice \n$_body');

                                                      dynamic response =
                                                      await invoiceProvider.updateInvoice(_body, file);
                                                      if (response['res'] ==
                                                          'success') {
                                                        showToast(
                                                            'Invoice Update Successful',
                                                            context);
                                                        Navigator.pop(this.context, invoiceNoController.text);
                                                        //Navigator.pop(context);
                                                      } else {
                                                        showToast(
                                                            'Some error occurred',
                                                            context,
                                                            type: 'error');
                                                      }
                                                      setState(() {
                                                        saving = false;
                                                      });
                                                      //Navigator.pop(context);

                                                      // Beamer.of(context)
                                                      //     .beamToNamed('/confirmInvoice');

                                                      // showToast('Confirm invoice Details',
                                                      //     context,
                                                      //     type: "info");
                                                    }
                                                  },
                                                  child: Container(
                                                    width: !Responsive.isMobile(
                                                        context)
                                                        ? 230
                                                        : 130,
                                                    height:
                                                    !Responsive.isMobile(
                                                        context)
                                                        ? 59
                                                        : 48,
                                                    decoration:
                                                    const BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(15),
                                                        topRight:
                                                        Radius.circular(15),
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
                                                        EdgeInsets
                                                            .all(8.0),
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: Color
                                                              .fromRGBO(
                                                              242,
                                                              242,
                                                              242,
                                                              1),
                                                        ),
                                                      ),
                                                    )
                                                        : Center(
                                                      child: Text(
                                                        'Update Invoice',
                                                        textAlign:
                                                        TextAlign
                                                            .center,
                                                        style: TextStyle(
                                                          color: Color
                                                              .fromRGBO(
                                                              242,
                                                              242,
                                                              242,
                                                              1),
                                                          fontSize: 24,
                                                          letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                        ),
                                                      ),
                                                    ),

                                                    // Stack(children: <Widget>[
                                                    //   Positioned(
                                                    //       top: 0,
                                                    //       left: 0,
                                                    //       child: Container(
                                                    //         decoration: BoxDecoration(
                                                    //           borderRadius:
                                                    //               BorderRadius.only(
                                                    //             topLeft:
                                                    //                 Radius.circular(15),
                                                    //             topRight:
                                                    //                 Radius.circular(15),
                                                    //             bottomLeft:
                                                    //                 Radius.circular(15),
                                                    //             bottomRight:
                                                    //                 Radius.circular(15),
                                                    //           ),
                                                    //           color: Color.fromRGBO(
                                                    //               0, 152, 219, 1),
                                                    //         ),
                                                    //         padding: EdgeInsets.symmetric(
                                                    //             horizontal: 16,
                                                    //             vertical: 16),
                                                    //         child: saving?Center(child: Padding(
                                                    //           padding: const EdgeInsets.all(8.0),
                                                    //           child: CircularProgressIndicator(),
                                                    //         ),):Row(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize.min,
                                                    //           children: <Widget>[
                                                    //             Text(
                                                    //               'Preview',
                                                    //               textAlign:
                                                    //                   TextAlign.center,
                                                    //               style: TextStyle(
                                                    //                   color:
                                                    //                       Color.fromRGBO(
                                                    //                           242,
                                                    //                           242,
                                                    //                           242,
                                                    //                           1),
                                                    //                   fontSize: 18,
                                                    //                   letterSpacing:
                                                    //                       0 /*percentages not used in flutter. defaulting to zero*/,
                                                    //                   fontWeight:
                                                    //                       FontWeight
                                                    //                           .normal,
                                                    //                   height: 1),
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       )),
                                                    // ])),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 25, height: 25,
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          // width: MediaQuery.of(context).size.width * 0.6,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(50),
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                            color:
                                            Color.fromRGBO(0, 152, 219, 1),
                                          ),
                                          child: Container(
                                              child: file != null
                                                  ? file.extension == 'pdf'
                                                  ? SfPdfViewer.memory(
                                                  file.bytes)
                                                  : Image.memory(file.bytes)
                                                  : SfPdfViewer.network(
                                                  invoiceFileResponse[
                                                  'data']['url'])

                                            // Center(
                                            //     child: Text(
                                            //       'Uploaded Invoice will appear here',
                                            //       textAlign: TextAlign.left,
                                            //       style: TextStyle(
                                            //           color: Color.fromRGBO(
                                            //               255, 255, 255, 1),
                                            //           // fontFamily: 'Poppins',
                                            //           fontSize: 14,
                                            //           letterSpacing:
                                            //           0 /*percentages not used in flutter. defaulting to zero*/,
                                            //           fontWeight: FontWeight.normal,
                                            //           height: 1),
                                            //     )),
                                          ),
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
            ),
          ),
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




// import 'package:beamer/beamer.dart';
// import 'package:capsa/common/responsive.dart';
// import 'package:capsa/functions/hexcolor.dart';
// import 'package:capsa/functions/show_toast.dart';
// import 'package:capsa/vendor-new/model/invoice_model.dart';
// import 'package:capsa/vendor-new/pages/add_invoice/confirm_invoice.dart';
// import 'package:capsa/vendor-new/pages/confirm_invoice_page.dart';
//
// import 'package:capsa/vendor-new/provider/invoice_providers.dart';
// import 'package:capsa/providers/profile_provider.dart';
// import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
// import 'package:capsa/widgets/TopBarWidget.dart';
// import 'package:capsa/widgets/orientation_switcher.dart';
// import 'package:capsa/widgets/popup_action_info.dart';
// import 'package:capsa/widgets/user_input.dart';
// import 'package:file_picker/file_picker.dart';
//
// import 'package:flutter/material.dart';
// import 'package:capsa/functions/custom_print.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
//
// class EditInvoice extends StatefulWidget {
//   dynamic data;
//   EditInvoice({Key key, @required this.data}) : super(key: key);
//
//   @override
//   State<EditInvoice> createState() => _EditInvoiceState();
// }
//
// class _EditInvoiceState extends State<EditInvoice> {
//   final _formKey = GlobalKey<FormState>();
//
//   final Box box = Hive.box('capsaBox');
//   final dueDateCont = TextEditingController();
//   final dateCont = TextEditingController();
//   final fileCont = TextEditingController(text: '');
//   bool dataLoaded = false;
//   DateTime _selectedDate;
//   DateTime _selectedDueDate;
//   var _cuGst;
//
//   bool saving = false;
//
//   final rateController2 = TextEditingController(text: '');
//
//   dynamic companyDetails = null;
//
//   Future<dynamic> getCompanyNames(BuildContext context) async {
//     print('company called');
//     if (companyDetails == null) {
//       dynamic data =
//           await Provider.of<VendorActionProvider>(context, listen: false)
//               .getCompanyName();
//       companyDetails = data;
//       if (data['res'] == 'success') {
//         anchorNameList = data['data'];
//         term = [];
//         anchorNameList.forEach((element) {
//           term.add(element['name']);
//         });
//       }
//
//
//     }
//
//     return companyDetails;
//   }
//
//   Future<Object> getData() async{
//     dynamic response = await Provider.of<VendorActionProvider>(context, listen: false)
//         .queryInvoiceData(widget.data['invoice_number']);
//     print('Company Details: \n\n$response\n\n');
//     invoiceNoController.text = response['data']['invoicelist'][0]['invoice_number'].toString();
//     poController.text = response['data']['invoicelist'][0]['invoice_number'];
//     tenureController.text = response['data']['invoicelist'][0]['invoice_line_items'].toString();
//     invoiceAmtController.text = response['data']['invoicelist'][0]['invoice_value'].toString();
//     buyAmtController.text = response['data']['invoicelist'][0]['ask_amt'].toString();
//     detailsController.text = response['data']['invoicelist'][0]['idescription'];
//     anchor = response['data']['invoicelist'][0]['customer_name'];
//     anchorController.text = response['data']['invoicelist'][0]['customer_name'];
//     //_cugst = response['data']['invoicelist'][0]['customer_gst'];
//     dateCont.text = response['data']['invoicelist'][0]['invoice_number'].toString();
//     tenureDaysDiff = 0;
//     rateController2.text = response['data']['invoicelist'][0]['invoice_number'].toString();
//     dueDateCont.text = response['data']['invoicelist'][0]['invoice_number'].toString();
//     fileCont.text = '';
//     _selectedDate = invoiceFormData["_selectedDate"];
//     _selectedDueDate = invoiceFormData["_selectedDueDate"];
//     _cuGst = response['data']['invoicelist'][0]['invoice_number'].toString();
//     setState(() {
//       dataLoaded= true;
//     });
//     return response;
//   }
//
//   int navigate() {
//     Beamer.of(context).beamToNamed('/confirmInvoice');
//     return 1;
//   }
//
//   void calculateRate() {
//     rateController2.text = '';
//     var invAmt = invoiceAmtController.text;
//     var invSell = buyAmtController.text;
//     if (invAmt == null) return;
//     // if(invSell == null) invSell = 0;
//     if (_selectedDate == null) return;
//     if (_selectedDueDate == null) return;
//
//     if (invSell == null || invSell == '') invSell = '0';
//
//     tenureDaysDiff = _selectedDueDate.difference(_selectedDate).inDays;
//
//     // num rate = (((num.tryParse(invAmt) - num.tryParse(invSell)) / (num.tryParse(invAmt) * 1) * 100) / 360) * tenureDaysDiff;
//     num rate = 0;
//     if (num.tryParse(invSell) > 0) {
//       rate = ((num.tryParse(invAmt) / num.tryParse(invSell)) - 1) *
//           (1 / tenureDaysDiff) *
//           365;
//     }
//     //  (INVOICE AMOUNT/SELL NOW PRICE - 1) * (1-TENURE) * 365 DAYS
//
//     // setState(() {
//     if (rate == 'Infinity') {
//       rateController2.text = '0';
//     }
//     rateController2.text = rate.toStringAsFixed(2);
//     if (rateController2.text == 'Infinity') {
//       rateController2.text = '0';
//     }
//
//     // });
//   }
//
//   var term = ["Select One"];
//
//   _selectDueDate(BuildContext context) async {
//     // capsaPrint("_selectDueDate");
//
//     DateTime newSelectedDate = await showDatePicker(
//         context: context,
//         initialDate: _selectedDueDate != null
//             ? _selectedDueDate.difference(DateTime(2000)).inMicroseconds < 0
//                 ? DateTime.now()
//                 : _selectedDueDate
//             : DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2040),
//         builder: (BuildContext context, Widget child) {
//           return Theme(
//             data: ThemeData.light().copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: Theme.of(context).primaryColor,
//                 onPrimary: Colors.white,
//                 surface: Theme.of(context).primaryColor,
//                 // onSurface: Colors.yellow,
//               ),
//               // dialogBackgroundColor: Colors.blue[500],
//             ),
//             child: child,
//           );
//         });
//
//     if (newSelectedDate != null) {
//       _selectedDueDate = newSelectedDate;
//       dueDateCont
//         ..text = DateFormat.yMMMd().format(_selectedDueDate)
//         ..selection = TextSelection.fromPosition(TextPosition(
//             offset: dueDateCont.text.length, affinity: TextAffinity.upstream));
//       calculateRate();
//     }
//   }
//
//   _selectDate(BuildContext context) async {
//     DateTime newSelectedDate = await showDatePicker(
//         context: context,
//         initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2040),
//         builder: (BuildContext context, Widget child) {
//           return Theme(
//             data: ThemeData.light().copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: Theme.of(context).primaryColor,
//                 onPrimary: Colors.white,
//                 surface: Theme.of(context).primaryColor,
//                 // onSurface: Colors.yellow,
//               ),
//               // dialogBackgroundColor: Colors.blue[500],
//             ),
//             child: child,
//           );
//         });
//
//     if (newSelectedDate != null) {
//       _selectedDate = newSelectedDate;
//       dateCont
//         ..text = DateFormat.yMMMd().format(_selectedDate)
//         ..selection = TextSelection.fromPosition(TextPosition(
//             offset: dateCont.text.length, affinity: TextAffinity.upstream));
//       calculateRate();
//     }
//   }
//
//   final anchorController = TextEditingController(text: '');
//   final invoiceNoController = TextEditingController(text: '');
//   final poController = TextEditingController(text: '');
//   final tenureController = TextEditingController(text: '');
//   final invoiceAmtController = TextEditingController(text: '');
//   final buyAmtController = TextEditingController(text: '');
//   final detailsController = TextEditingController(text: '');
//   var anchor;
//
//   // var anchor, cacAddress, invNo, po, terms;
//
//   // var invAmt, details, rate, invDueDate;
//   // var invSell = '0';
//
//   var tenureDaysDiff = 0;
//
//   var anchorNameList = [];
//
//   PlatformFile file;
//
//   bool loadingCall = false;
//   bool loadingConfirm = false;
//
//   bool nextMobileType = false;
//   bool nextEnable = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final invoiceProvider =
//         Provider.of<InvoiceProvider>(context, listen: false);
//
//     if (invoiceProvider.invoiceFormWorking) {
//       final invoiceFormData = invoiceProvider.invoiceFormData;
//
//       //print('Invoice Form Data : $invoiceFormData');
//
//       capsaPrint('invoice data \n\n ${widget.data}');
//
//       invoiceNoController.text = widget.data['invoice_number'].toString();
//       poController.text = widget.data['invoice_number'];
//       tenureController.text = invoiceFormData["tenure"].toString();
//       invoiceAmtController.text = invoiceFormData["invAmt"].toString();
//       buyAmtController.text = invoiceFormData["butAmt"].toString();
//       detailsController.text = invoiceFormData["details"];
//       anchor = invoiceFormData["anchor"];
//       anchorController.text = invoiceFormData["anchorAddress"];
//       dateCont.text = invoiceFormData["dateCont"].toString();
//       tenureDaysDiff = 0;
//       rateController2.text = invoiceFormData["rate"].toString();
//       dueDateCont.text = invoiceFormData["dueDateCont"].toString();
//       fileCont.text = '';
//       _selectedDate = invoiceFormData["_selectedDate"];
//       _selectedDueDate = invoiceFormData["_selectedDueDate"];
//       _cuGst = invoiceFormData["cuGst"].toString();
//     }
//
//     //invoiceProvider.splitInvoice('DH001', '50000000');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final invoiceProvider =
//         Provider.of<InvoiceProvider>(context, listen: false);
//
//     if (Responsive.isMobile(context)) {
//       nextMobileType = true;
//       nextEnable = false;
//     }
//
//     return Scaffold(
//       appBar: Responsive.isMobile(context)?AppBar(
//         title: Text('Edit Invoice'),
//         automaticallyImplyLeading: false,
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             )),
//       ):null,
//       body: dataLoaded?Container(
//         height: MediaQuery.of(context).size.height,
//         padding: const EdgeInsets.all(25.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (!Responsive.isMobile(context))
//                 SizedBox(
//                   height: 22,
//                 ),
//               if (!Responsive.isMobile(context))
//               TopBarWidget("Edit Invoice", ""),
//               SizedBox(
//                 height: (!Responsive.isMobile(context)) ? 8 : 15,
//               ),
//               if (Responsive.isMobile(context)) mobileFormSteper(),
//               FutureBuilder<Object>(
//                   future: getCompanyNames(context),
//                   builder: (context, snapshot) {
//                     if (companyDetails == null) {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     int i = 0;
//                     if (snapshot.hasError) {
//                       return Center(
//                         child: Text(
//                           'There was an error :(\n' + snapshot.error.toString(),
//                           style: Theme.of(context).textTheme.bodyText2,
//                         ),
//                       );
//                     } else if (snapshot.hasData) {
//                       dynamic _data = snapshot.data;
//                       //print('snapshot data $_data');
//
//                       var _items = _data['data'];
//
//                       var anchorNameList = [];
//
//                       if (_data['res'] == 'success') {
//                         anchorNameList = _items;
//                         term = [];
//                         _items.forEach((element) {
//                           term.add(element['name']);
//                         });
//                       } else {
//                         return Center(
//                           child: Text(
//                             'There was an error :(\n' +
//                                 _data['messg'].toString(),
//                             style: Theme.of(context).textTheme.bodyText2,
//                           ),
//                         );
//                       }
//
//                       // ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
//
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: Form(
//                           // onChanged: ,
//                           key: _formKey,
//                           child: OrientationSwitcher(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             // orientation: Responsive.isMobile(context) ? "Column" : "Row" ,
//                             children: [
//                               Flexible(
//                                   flex: 1,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       OrientationSwitcher(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "Anchor Name",
//                                               hintText: "Select Anchor",
//                                               textFormField:
//                                                   DropdownButtonFormField(
//                                                 isExpanded: true,
//                                                 validator: (v) {
//                                                   if (anchorController.text ==
//                                                       '') {
//                                                     return "Can't be empty";
//                                                   }
//                                                   return null;
//                                                 },
//                                                 items:
//                                                     term.map((String category) {
//                                                   return DropdownMenuItem(
//                                                     value: category,
//                                                     child: Text(
//                                                         category.toString()),
//                                                   );
//                                                 }).toList(),
//                                                 onChanged: (v) {
//                                                   // capsaPrint(anchorNameList);
//                                                   anchor = v;
//                                                   anchorNameList
//                                                       .forEach((element1) {
//                                                     if (element1['name'] == v) {
//                                                       // cacAddress = element1['name_address'];
//                                                       anchorController.text =
//                                                           element1[
//                                                               'name_address'];
//                                                       _cuGst =
//                                                           element1['cu_gst'];
//
//                                                       // capsaPrint(cacAddress);
//
//                                                     }
//                                                   });
//                                                 },
//                                                 value: anchor,
//                                                 decoration: InputDecoration(
//                                                   border: InputBorder.none,
//                                                   filled: true,
//                                                   fillColor: Colors.white,
//                                                   hintText: "Select Anchor",
//                                                   hintStyle: TextStyle(
//                                                       color: Color.fromRGBO(
//                                                           130, 130, 130, 1),
//                                                       fontSize: 14,
//                                                       letterSpacing:
//                                                           0 /*percentages not used in flutter. defaulting to zero*/,
//                                                       fontWeight:
//                                                           FontWeight.normal,
//                                                       height: 1),
//                                                   contentPadding:
//                                                       const EdgeInsets.only(
//                                                           left: 8.0,
//                                                           bottom: 12.0,
//                                                           top: 12.0),
//                                                   focusedBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                         color: Colors.white),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15.7),
//                                                   ),
//                                                   enabledBorder:
//                                                       UnderlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                         color: Colors.white),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15.7),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "CAC/Address",
//                                               hintText: "",
//                                               controller: anchorController,
//                                               readOnly: true,
//                                             ),
//                                           ),
//
//                                         ],
//                                       ),
//                                       OrientationSwitcher(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "Invoice No",
//                                               hintText: "Invoice Number",
//                                               controller: invoiceNoController,
//                                             ),
//                                           ),
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "PO Number",
//                                               controller: poController,
//                                               hintText: "Purchase order Number",
//                                             ),
//                                           ),
//
//                                         ],
//                                       ),
//                                       OrientationSwitcher(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "Tenure",
//                                               hintText: "30 or 60 Days?",
//                                               controller: tenureController,
//                                             ),
//                                           ),
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "Invoice Amount",
//                                               hintText: "Enter invoice amount",
//                                               prefixIcon: Image.asset(
//                                                   "assets/images/currency.png"),
//                                               controller: invoiceAmtController,
//                                               onChanged: (v) {
//                                                 calculateRate();
//                                               },
//                                               keyboardType: TextInputType
//                                                   .numberWithOptions(
//                                                   decimal: true),
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .allow(RegExp(r"[0-9.]")),
//                                                 TextInputFormatter.withFunction(
//                                                         (oldValue, newValue) {
//                                                       try {
//                                                         final text = newValue.text;
//                                                         if (text.isNotEmpty) {
//                                                           double.parse(text);
//                                                         }
//                                                         return newValue;
//                                                       } catch (e) {}
//                                                       return oldValue;
//                                                     }),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       OrientationSwitcher(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "Issue Date",
//                                               readOnly: true,
//                                               controller: dateCont,
//                                               suffixIcon: Icon(
//                                                   Icons.date_range_outlined),
//                                               hintText: "Invoice Issue date",
//                                               onTap: () => _selectDate(context),
//                                               keyboardType:
//                                                   TextInputType.number,
//                                             ),
//                                           ),
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "Due Date",
//                                               suffixIcon: Icon(
//                                                   Icons.date_range_outlined),
//                                               readOnly: true,
//                                               controller: dueDateCont,
//                                               hintText: "Invoice Due Date",
//                                               onTap: () =>
//                                                   _selectDueDate(context),
//                                               keyboardType:
//                                                   TextInputType.number,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//
//
//                                       OrientationSwitcher(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "Sell Now Price",
//                                               hintText:
//                                                   "Amount to sell invoice",
//                                               prefixIcon: Image.asset(
//                                                   "assets/images/currency.png"),
//                                               validator: (v) {
//                                                 return null;
//                                               },
//                                               onChanged: (v) {
//                                                 if (num.parse(v) >=
//                                                     num.parse(
//                                                         invoiceAmtController
//                                                             .text)) {
//                                                   buyAmtController.text = "";
//                                                   showToast(
//                                                       'Sell Now Price cann\'t be greater then invoice amount',
//                                                       context);
//                                                 }
//                                                 calculateRate();
//                                               },
//                                               controller: buyAmtController,
//                                               keyboardType: TextInputType
//                                                   .numberWithOptions(
//                                                       decimal: true),
//                                               inputFormatters: [
//                                                 // CurrencyTextInputFormatter(locale: "en_US",decimalDigits: 2),
//                                                 FilteringTextInputFormatter
//                                                     .allow(RegExp(r"[0-9.]")),
//                                                 TextInputFormatter.withFunction(
//                                                     (oldValue, newValue) {
//                                                   try {
//                                                     final text = newValue.text;
//                                                     if (text.isNotEmpty) {
//                                                       double.parse(text);
//                                                     }
//                                                     return newValue;
//                                                   } catch (e) {}
//                                                   return oldValue;
//                                                 }),
//                                               ],
//                                               // prefixIcon : Text()
//                                             ),
//                                           ),
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               label: "Discount rate",
//                                               hintText: "",
//                                               readOnly: true,
//                                               controller: rateController2,
//                                               suffixIcon: Image.asset(
//                                                   "assets/images/%.png"),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       OrientationSwitcher(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
//                                               label:
//                                                   "Details (e.g items or quantity)",
//                                               hintText: "48 packs of goods",
//                                               controller: detailsController,
//                                               minLines: 1,
//                                               maxLines: 5,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       OrientationSwitcher(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Flexible(
//                                             child: UserTextFormField(
//                                               controller: fileCont,
//                                               // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
//                                               label: "Upload invoice",
//                                               hintText:
//                                                   "PDF(Single/Multiple page) or Image File",
//                                               minLines: 1,
//                                               onTap: () async {
//                                                 FilePickerResult result =
//                                                     await FilePicker.platform
//                                                         .pickFiles(
//                                                   withData: true,
//                                                   onFileLoading:
//                                                       (FilePickerStatus p) {},
//                                                   type: FileType.custom,
//                                                   allowedExtensions: [
//                                                     'jpg',
//                                                     'jpeg',
//                                                     'pdf',
//                                                     'png'
//                                                   ],
//                                                 );
//
//                                                 if (result != null) {
//                                                   if (result.files.first
//                                                               .extension ==
//                                                           'jpg' ||
//                                                       result.files.first
//                                                               .extension ==
//                                                           'png') {
//                                                     setState(() {
//                                                       file = result.files.first;
//                                                       fileCont.text = file.name;
//                                                       capsaPrint('ok');
//                                                     });
//                                                   } else if (result.files.first
//                                                           .extension ==
//                                                       'pdf') {
//                                                     setState(() {
//                                                       file = result.files.first;
//                                                       fileCont.text = file.name;
//                                                     });
//                                                     // generateTn(file);
//
//                                                   } else {
//                                                     showDialog<void>(
//                                                         context: context,
//                                                         builder: (BuildContext
//                                                             context) {
//                                                           return AlertDialog(
//                                                             content: const Text(
//                                                                 'Invalid Format Selected. Please Select Another File'),
//                                                             actions: <Widget>[
//                                                               FlatButton(
//                                                                   child: Text(
//                                                                     'OK',
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Theme.of(
//                                                                               context)
//                                                                           .primaryColor,
//                                                                     ),
//                                                                   ),
//                                                                   onPressed: () =>
//                                                                       Navigator.pop(
//                                                                           context)),
//                                                             ],
//                                                           );
//                                                         });
//                                                   }
//                                                 } else {
//                                                   showDialog<void>(
//                                                       context: context,
//                                                       builder: (BuildContext
//                                                           context) {
//                                                         return AlertDialog(
//                                                           content: const Text(
//                                                               'No File Selected!'),
//                                                           actions: <Widget>[
//                                                             FlatButton(
//                                                                 child: Text(
//                                                                   'OK',
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: Theme.of(
//                                                                             context)
//                                                                         .primaryColor,
//                                                                   ),
//                                                                 ),
//                                                                 onPressed: () =>
//                                                                     Navigator.pop(
//                                                                         context)),
//                                                           ],
//                                                         );
//                                                       });
//                                                 }
//                                               },
//                                               readOnly: true,
//                                               suffixIcon:
//                                                   Icon(Icons.upload_file),
//                                               maxLines: 5,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 16),
//
//                                       if (!Responsive.isMobile(context))
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           InkWell(
//                                             onTap: () async {
//                                               // Beamer.of(context).beamToNamed('/confirmInvoice');
//                                               // showPopupActionInfo(
//                                               //   context,
//                                               //   heading: "Congratulations! Your invoice has been saved and presented. ",
//                                               //   info: "When your Anchor approves the invoice, you will start receiving bids from Investors.",
//                                               //   buttonText: "View Pending Invoice",
//                                               //   onTap: () {
//                                               //     Navigator.of(context, rootNavigator: true).pop();
//                                               //     invoiceProvider.resetInvoiceFormData();
//                                               //     Beamer.of(context).beamToNamed('/pending-invoices');
//                                               //   },
//                                               // ); return;
//
//                                               setState(() {
//                                                 saving = true;
//                                               });
//
//                                               if (_formKey.currentState
//                                                   .validate()) {
//                                                 dynamic invoiceFormData = {
//                                                   "invoiceNo":
//                                                       invoiceNoController.text,
//                                                   "poNumber": poController.text,
//                                                   "tenure":
//                                                       tenureController.text,
//                                                   "invAmt":
//                                                       invoiceAmtController.text,
//                                                   "butAmt":
//                                                       buyAmtController.text,
//                                                   "details":
//                                                       detailsController.text,
//                                                   "anchor": anchor,
//                                                   "anchorAddress":
//                                                       anchorController.text,
//                                                   "dateCont": dateCont.text,
//                                                   "tenureDaysDiff":
//                                                       tenureDaysDiff.toString(),
//                                                   "rate": rateController2.text,
//                                                   "dueDateCont":
//                                                       dueDateCont.text,
//                                                   "fileCont": fileCont.text,
//                                                   "_selectedDate":
//                                                       _selectedDate,
//                                                   "_selectedDueDate":
//                                                       _selectedDueDate,
//                                                   "file": file,
//                                                   "cuGst": _cuGst,
//                                                 };
//
//                                                 // capsaPrint(invoiceFormData);
//
//                                                 invoiceProvider
//                                                     .setInvoiceFormData(
//                                                         invoiceFormData);
//
//                                                 // dynamic invoiceData = invoiceProvider.invoiceFormData;
//
//                                                 var _body = {
//                                                   'company_pan': widget
//                                                       .data['company_pan'],
//                                                   'previous_invoice_number':
//                                                       widget.data[
//                                                           'invoice_number'],
//                                                   'invoice_number':
//                                                       invoiceFormData[
//                                                           'invoiceNo'],
//                                                   'invoice_due_data':
//                                                       DateFormat('yyyy-MM-dd')
//                                                           .format(
//                                                               _selectedDueDate),
//                                                   'description':
//                                                       invoiceFormData[
//                                                           'details'],
//                                                   'invoice_quantity': '1',
//                                                   'invoice_value':
//                                                       invoiceFormData["invAmt"],
//                                                   'payment_terms':
//                                                       invoiceFormData[
//                                                           "tenureDaysDiff"],
//                                                   'rate':
//                                                       invoiceFormData['rate'],
//                                                   'buyNowPrice':
//                                                       invoiceFormData['butAmt'],
//                                                   'poNo': invoiceFormData[
//                                                       'poNumber'],
//                                                 };
//
//                                                 dynamic splitData =
//                                                     await invoiceProvider
//                                                         .splitInvoice(
//                                                             invoiceNoController
//                                                                 .text,
//                                                             invoiceAmtController
//                                                                 .text);
//                                                 print('body: $_body');
//
//                                                 if (splitData['isSplit'] == 1) {
//                                                   setState(() {
//                                                     saving = false;
//                                                   });
//                                                   print('split warning');
//                                                   showDialog(
//                                                       // barrierColor: Colors.transparent,
//                                                       context: context,
//                                                       builder: (BuildContext
//                                                           context) {
//                                                         functionBack() {
//                                                           Navigator.pop(
//                                                               context);
//                                                         }
//
//                                                         return AlertDialog(
//                                                             backgroundColor:
//                                                                 Colors
//                                                                     .transparent,
//                                                             shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             32.0))),
//                                                             content:
//                                                                 SplitInvoiceWarning(
//                                                               invNo:
//                                                                   invoiceNoController
//                                                                       .text,
//                                                               nav: navigate,
//                                                             ));
//                                                       }).then((value) async {
//                                                     setState(() {
//                                                       saving = true;
//                                                     });
//                                                     await invoiceProvider
//                                                         .updateInvoice(
//                                                             _body, file);
//                                                     Navigator.pop(context);
//                                                   });
//                                                 } else {
//                                                   await invoiceProvider.updateInvoice(_body, file);
//                                                   Navigator.pop(context);
//                                                 }
//
//                                                 // Beamer.of(context)
//                                                 //     .beamToNamed('/confirmInvoice');
//
//                                                 // showToast('Confirm invoice Details',
//                                                 //     context,
//                                                 //     type: "info");
//                                               }
//                                             },
//                                             child: Container(
//                                               width: 230,
//                                               height: 59,
//                                               decoration: const BoxDecoration(
//                                                 borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(15),
//                                                   topRight: Radius.circular(15),
//                                                   bottomLeft:
//                                                       Radius.circular(15),
//                                                   bottomRight:
//                                                       Radius.circular(15),
//                                                 ),
//                                                 color: Color.fromRGBO(
//                                                     0, 152, 219, 1),
//                                               ),
//                                               child: saving
//                                                   ? const Center(
//                                                       child: Padding(
//                                                         padding:
//                                                             EdgeInsets.all(8.0),
//                                                         child:
//                                                             CircularProgressIndicator(
//                                                           color: Color.fromRGBO(
//                                                               242, 242, 242, 1),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : Center(
//                                                       child: Text(
//                                                         'Update Invoice',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: TextStyle(
//                                                           color: Color.fromRGBO(
//                                                               242, 242, 242, 1),
//                                                           fontSize: 24,
//                                                           letterSpacing:
//                                                               0 /*percentages not used in flutter. defaulting to zero*/,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                       ),
//                                                     ),
//
//                                               // Stack(children: <Widget>[
//                                               //   Positioned(
//                                               //       top: 0,
//                                               //       left: 0,
//                                               //       child: Container(
//                                               //         decoration: BoxDecoration(
//                                               //           borderRadius:
//                                               //               BorderRadius.only(
//                                               //             topLeft:
//                                               //                 Radius.circular(15),
//                                               //             topRight:
//                                               //                 Radius.circular(15),
//                                               //             bottomLeft:
//                                               //                 Radius.circular(15),
//                                               //             bottomRight:
//                                               //                 Radius.circular(15),
//                                               //           ),
//                                               //           color: Color.fromRGBO(
//                                               //               0, 152, 219, 1),
//                                               //         ),
//                                               //         padding: EdgeInsets.symmetric(
//                                               //             horizontal: 16,
//                                               //             vertical: 16),
//                                               //         child: saving?Center(child: Padding(
//                                               //           padding: const EdgeInsets.all(8.0),
//                                               //           child: CircularProgressIndicator(),
//                                               //         ),):Row(
//                                               //           mainAxisSize:
//                                               //               MainAxisSize.min,
//                                               //           children: <Widget>[
//                                               //             Text(
//                                               //               'Preview',
//                                               //               textAlign:
//                                               //                   TextAlign.center,
//                                               //               style: TextStyle(
//                                               //                   color:
//                                               //                       Color.fromRGBO(
//                                               //                           242,
//                                               //                           242,
//                                               //                           242,
//                                               //                           1),
//                                               //                   fontSize: 18,
//                                               //                   letterSpacing:
//                                               //                       0 /*percentages not used in flutter. defaulting to zero*/,
//                                               //                   fontWeight:
//                                               //                       FontWeight
//                                               //                           .normal,
//                                               //                   height: 1),
//                                               //             ),
//                                               //           ],
//                                               //         ),
//                                               //       )),
//                                               // ])),
//                                             ),
//                                           ),
//                                           InkWell(
//                                             onTap: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Container(
//                                               width: 230,
//                                               height: 59,
//                                               decoration: const BoxDecoration(
//                                                 borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(15),
//                                                   topRight: Radius.circular(15),
//                                                   bottomLeft:
//                                                       Radius.circular(15),
//                                                   bottomRight:
//                                                       Radius.circular(15),
//                                                 ),
//                                                 color: Colors.red,
//                                               ),
//                                               child: saving
//                                                   ? const Center(
//                                                       child: Padding(
//                                                         padding:
//                                                             EdgeInsets.all(8.0),
//                                                         child:
//                                                             CircularProgressIndicator(
//                                                           color: Color.fromRGBO(
//                                                               242, 242, 242, 1),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : Center(
//                                                       child: Text(
//                                                         'Back',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: TextStyle(
//                                                           color: Color.fromRGBO(
//                                                               242, 242, 242, 1),
//                                                           fontSize: 24,
//                                                           letterSpacing:
//                                                               0 /*percentages not used in flutter. defaulting to zero*/,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                       ),
//                                                     ),
//
//                                               // Stack(children: <Widget>[
//                                               //   Positioned(
//                                               //       top: 0,
//                                               //       left: 0,
//                                               //       child: Container(
//                                               //         decoration: BoxDecoration(
//                                               //           borderRadius:
//                                               //               BorderRadius.only(
//                                               //             topLeft:
//                                               //                 Radius.circular(15),
//                                               //             topRight:
//                                               //                 Radius.circular(15),
//                                               //             bottomLeft:
//                                               //                 Radius.circular(15),
//                                               //             bottomRight:
//                                               //                 Radius.circular(15),
//                                               //           ),
//                                               //           color: Color.fromRGBO(
//                                               //               0, 152, 219, 1),
//                                               //         ),
//                                               //         padding: EdgeInsets.symmetric(
//                                               //             horizontal: 16,
//                                               //             vertical: 16),
//                                               //         child: saving?Center(child: Padding(
//                                               //           padding: const EdgeInsets.all(8.0),
//                                               //           child: CircularProgressIndicator(),
//                                               //         ),):Row(
//                                               //           mainAxisSize:
//                                               //               MainAxisSize.min,
//                                               //           children: <Widget>[
//                                               //             Text(
//                                               //               'Preview',
//                                               //               textAlign:
//                                               //                   TextAlign.center,
//                                               //               style: TextStyle(
//                                               //                   color:
//                                               //                       Color.fromRGBO(
//                                               //                           242,
//                                               //                           242,
//                                               //                           242,
//                                               //                           1),
//                                               //                   fontSize: 18,
//                                               //                   letterSpacing:
//                                               //                       0 /*percentages not used in flutter. defaulting to zero*/,
//                                               //                   fontWeight:
//                                               //                       FontWeight
//                                               //                           .normal,
//                                               //                   height: 1),
//                                               //             ),
//                                               //           ],
//                                               //         ),
//                                               //       )),
//                                               // ])),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//
//                                       SizedBox(height: 16),
//
//                                       if (Responsive.isMobile(context))
//                                       InkWell(
//                                         onTap: () async {
//                                           // Beamer.of(context).beamToNamed('/confirmInvoice');
//                                           // showPopupActionInfo(
//                                           //   context,
//                                           //   heading: "Congratulations! Your invoice has been saved and presented. ",
//                                           //   info: "When your Anchor approves the invoice, you will start receiving bids from Investors.",
//                                           //   buttonText: "View Pending Invoice",
//                                           //   onTap: () {
//                                           //     Navigator.of(context, rootNavigator: true).pop();
//                                           //     invoiceProvider.resetInvoiceFormData();
//                                           //     Beamer.of(context).beamToNamed('/pending-invoices');
//                                           //   },
//                                           // ); return;
//
//                                           setState(() {
//                                             saving = true;
//                                           });
//
//                                           if (_formKey.currentState
//                                               .validate()) {
//                                             dynamic invoiceFormData = {
//                                               "invoiceNo":
//                                               invoiceNoController.text,
//                                               "poNumber": poController.text,
//                                               "tenure":
//                                               tenureController.text,
//                                               "invAmt":
//                                               invoiceAmtController.text,
//                                               "butAmt":
//                                               buyAmtController.text,
//                                               "details":
//                                               detailsController.text,
//                                               "anchor": anchor,
//                                               "anchorAddress":
//                                               anchorController.text,
//                                               "dateCont": dateCont.text,
//                                               "tenureDaysDiff":
//                                               tenureDaysDiff.toString(),
//                                               "rate": rateController2.text,
//                                               "dueDateCont":
//                                               dueDateCont.text,
//                                               "fileCont": fileCont.text,
//                                               "_selectedDate":
//                                               _selectedDate,
//                                               "_selectedDueDate":
//                                               _selectedDueDate,
//                                               "file": file,
//                                               "cuGst": _cuGst,
//                                             };
//
//                                             // capsaPrint(invoiceFormData);
//
//                                             invoiceProvider
//                                                 .setInvoiceFormData(
//                                                 invoiceFormData);
//
//                                             // dynamic invoiceData = invoiceProvider.invoiceFormData;
//
//                                             var _body = {
//                                               'company_pan': widget
//                                                   .data['company_pan'],
//                                               'previous_invoice_number':
//                                               widget.data[
//                                               'invoice_number'],
//                                               'invoice_number':
//                                               invoiceFormData[
//                                               'invoiceNo'],
//                                               'invoice_due_date':
//                                               DateFormat('yyyy-MM-dd')
//                                                   .format(
//                                                   _selectedDueDate),
//                                               'description':
//                                               invoiceFormData[
//                                               'details'],
//                                               'invoice_quantity': '1',
//                                               'invoice_value':
//                                               invoiceFormData["invAmt"],
//                                               'payment_terms':
//                                               invoiceFormData[
//                                               "tenureDaysDiff"],
//                                               'rate':
//                                               invoiceFormData['rate'],
//                                               'buyNowPrice':
//                                               invoiceFormData['butAmt'],
//                                               'poNo': invoiceFormData[
//                                               'poNumber'],
//                                             };
//
//                                             dynamic splitData =
//                                             await invoiceProvider
//                                                 .splitInvoice(
//                                                 invoiceNoController
//                                                     .text,
//                                                 invoiceAmtController
//                                                     .text);
//                                             print('body: $_body');
//
//                                             if(splitData['result']['res'] != 'failed'){
//
//                                             if (splitData['isSplit'] == 1) {
//                                               setState(() {
//                                                 saving = false;
//                                               });
//                                               print('split warning');
//                                               showDialog(
//                                                 // barrierColor: Colors.transparent,
//                                                   context: context,
//                                                   builder: (BuildContext
//                                                   context) {
//                                                     functionBack() {
//                                                       Navigator.pop(
//                                                           context);
//                                                     }
//
//                                                     return AlertDialog(
//                                                         backgroundColor:
//                                                         Colors
//                                                             .transparent,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .all(Radius
//                                                                 .circular(
//                                                                 32.0))),
//                                                         content:
//                                                         SplitInvoiceWarning(
//                                                           invNo:
//                                                           invoiceNoController
//                                                               .text,
//                                                           nav: navigate,
//                                                         ));
//                                                   }).then((value) async {
//                                                 setState(() {
//                                                   saving = true;
//                                                 });
//                                                 dynamic response = await invoiceProvider
//                                                     .updateInvoice(
//                                                     _body, file);
//                                                 if(response['res'] == 'success'){
//                                                   showToast('Invoice Updated', context);
//                                                   Navigator.pop(context, invoiceNoController.text);
//                                                 }else{
//                                                   showToast(response['messg'], context, type: 'error');
//                                                   Navigator.pop(context, invoiceNoController.text);
//                                                 }
//
//                                               });
//                                             } else {
//                                               capsaPrint('pass 1');
//                                               dynamic response = await invoiceProvider.updateInvoice(_body, file);
//                                               capsaPrint('pass 2 $response');
//                                               if(response['res'] == 'success'){
//                                                 capsaPrint('pass 3');
//                                                 showToast('Invoice Updated', context);
//                                                 Navigator.pop(context, invoiceNoController.text);
//                                               }else{
//                                                 capsaPrint('pass 4');
//                                                 showToast(response['messg'], context, type: 'error');
//                                                 Navigator.pop(context, invoiceNoController.text);
//                                               }
//                                             }}else{
//                                               showToast(splitData['result']['messg'], context, type: 'error');
//                                               setState(() {
//                                                 saving = false;
//                                               });
//                                             }
//
//                                             // Beamer.of(context)
//                                             //     .beamToNamed('/confirmInvoice');
//
//                                             // showToast('Confirm invoice Details',
//                                             //     context,
//                                             //     type: "info");
//                                           }
//                                         },
//                                         child: Container(
//                                           width: 180,
//                                           height: 49,
//                                           decoration: const BoxDecoration(
//                                             borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(15),
//                                               topRight: Radius.circular(15),
//                                               bottomLeft:
//                                               Radius.circular(15),
//                                               bottomRight:
//                                               Radius.circular(15),
//                                             ),
//                                             color: Color.fromRGBO(
//                                                 0, 152, 219, 1),
//                                           ),
//                                           child: saving
//                                               ? const Center(
//                                             child: Padding(
//                                               padding:
//                                               EdgeInsets.all(8.0),
//                                               child:
//                                               CircularProgressIndicator(
//                                                 color: Color.fromRGBO(
//                                                     242, 242, 242, 1),
//                                               ),
//                                             ),
//                                           )
//                                               : Center(
//                                             child: Text(
//                                               'Update Invoice',
//                                               textAlign:
//                                               TextAlign.center,
//                                               style: TextStyle(
//                                                 color: Color.fromRGBO(
//                                                     242, 242, 242, 1),
//                                                 fontSize: 16,
//                                                 letterSpacing:
//                                                 0 /*percentages not used in flutter. defaulting to zero*/,
//                                                 fontWeight:
//                                                 FontWeight.w500,
//                                               ),
//                                             ),
//                                           ),
//
//                                           // Stack(children: <Widget>[
//                                           //   Positioned(
//                                           //       top: 0,
//                                           //       left: 0,
//                                           //       child: Container(
//                                           //         decoration: BoxDecoration(
//                                           //           borderRadius:
//                                           //               BorderRadius.only(
//                                           //             topLeft:
//                                           //                 Radius.circular(15),
//                                           //             topRight:
//                                           //                 Radius.circular(15),
//                                           //             bottomLeft:
//                                           //                 Radius.circular(15),
//                                           //             bottomRight:
//                                           //                 Radius.circular(15),
//                                           //           ),
//                                           //           color: Color.fromRGBO(
//                                           //               0, 152, 219, 1),
//                                           //         ),
//                                           //         padding: EdgeInsets.symmetric(
//                                           //             horizontal: 16,
//                                           //             vertical: 16),
//                                           //         child: saving?Center(child: Padding(
//                                           //           padding: const EdgeInsets.all(8.0),
//                                           //           child: CircularProgressIndicator(),
//                                           //         ),):Row(
//                                           //           mainAxisSize:
//                                           //               MainAxisSize.min,
//                                           //           children: <Widget>[
//                                           //             Text(
//                                           //               'Preview',
//                                           //               textAlign:
//                                           //                   TextAlign.center,
//                                           //               style: TextStyle(
//                                           //                   color:
//                                           //                       Color.fromRGBO(
//                                           //                           242,
//                                           //                           242,
//                                           //                           242,
//                                           //                           1),
//                                           //                   fontSize: 18,
//                                           //                   letterSpacing:
//                                           //                       0 /*percentages not used in flutter. defaulting to zero*/,
//                                           //                   fontWeight:
//                                           //                       FontWeight
//                                           //                           .normal,
//                                           //                   height: 1),
//                                           //             ),
//                                           //           ],
//                                           //         ),
//                                           //       )),
//                                           // ])),
//                                         ),
//                                       ),
//
//
//                                     ],
//                                   )),
//                               SizedBox(
//                                 width: 25,
//                               ),
//                               Flexible(
//                                   flex: 1,
//                                   child: Container(
//                                     // width: MediaQuery.of(context).size.width * 0.6,
//                                     height: MediaQuery.of(context).size.height,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(50),
//                                         topRight: Radius.circular(50),
//                                         bottomLeft: Radius.circular(50),
//                                         bottomRight: Radius.circular(50),
//                                       ),
//                                       color: Color.fromRGBO(0, 152, 219, 1),
//                                     ),
//                                     child: Container(
//                                       child: file != null
//                                           ? file.extension == 'pdf'
//                                               ? SfPdfViewer.memory(file.bytes)
//                                               : Image.memory(file.bytes)
//                                           : Center(
//                                               child: Text(
//                                               'Uploaded Invoice will appear here',
//                                               textAlign: TextAlign.left,
//                                               style: TextStyle(
//                                                   color: Color.fromRGBO(
//                                                       255, 255, 255, 1),
//                                                   // fontFamily: 'Poppins',
//                                                   fontSize: 14,
//                                                   letterSpacing:
//                                                       0 /*percentages not used in flutter. defaulting to zero*/,
//                                                   fontWeight: FontWeight.normal,
//                                                   height: 1),
//                                             )),
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       );
//                     } else if (!snapshot.hasData) {
//                       return Center(child: Text("No history found."));
//                     } else {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                   }),
//             ],
//           ),
//         ),
//       )
//       :Center(child: CircularProgressIndicator(),),
//     );
//   }
//
//   Widget mobileFormSteper() {
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         height: 60,
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(255, 255, 255, 1),
//         ),
//         child: Center(
//           child: Stack(children: <Widget>[
//             Positioned(
//                 top: 14,
//                 left: 104,
//                 child: Container(
//                     width: 80,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(130, 130, 130, 1),
//                     ))),
//             Positioned(
//                 top: 0,
//                 left: 67,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(50),
//                       topRight: Radius.circular(50),
//                       bottomLeft: Radius.circular(50),
//                       bottomRight: Radius.circular(50),
//                     ),
//                     color: Color.fromRGBO(245, 251, 255, 1),
//                     border: Border.all(
//                       color: Color.fromRGBO(0, 152, 219, 1),
//                       width: 2,
//                     ),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Text(
//                         '1',
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: Color.fromRGBO(0, 152, 219, 1),
//                             fontFamily: 'Poppins',
//                             fontSize: 16,
//                             letterSpacing:
//                                 0 /*percentages not used in flutter. defaulting to zero*/,
//                             fontWeight: FontWeight.normal,
//                             height: 1),
//                       ),
//                     ],
//                   ),
//                 )),
//             Positioned(
//                 top: 0,
//                 left: 184,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(50),
//                       topRight: Radius.circular(50),
//                       bottomLeft: Radius.circular(50),
//                       bottomRight: Radius.circular(50),
//                     ),
//                     color: Color.fromRGBO(245, 251, 255, 1),
//                     border: Border.all(
//                       color: Color.fromRGBO(130, 130, 130, 1),
//                       width: 2,
//                     ),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Text(
//                         '2',
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: Color.fromRGBO(130, 130, 130, 1),
//                             fontFamily: 'Poppins',
//                             fontSize: 16,
//                             letterSpacing:
//                                 0 /*percentages not used in flutter. defaulting to zero*/,
//                             fontWeight: FontWeight.normal,
//                             height: 1),
//                       ),
//                     ],
//                   ),
//                 )),
//           ]),
//         ));
//   }
// }
//
// class SplitInvoiceWarning extends StatelessWidget {
//   String invNo;
//   Function nav;
//   SplitInvoiceWarning({Key key, @required this.invNo, @required this.nav})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 584,
//       height: 579,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20), color: HexColor('#F5FBFF')),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/icons/warning.png',
//             width: 80,
//             height: 80,
//           ),
//           Text(
//             'Invoice Splitting',
//             style:
//                 GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
//           ),
//           Text(
//             'Please note that your invoice will be split into smaller invoices. This will allow for faster trading of your invoice.\n\n This does not affect the invoice value. A breakdown of the split can be seen on the next page.',
//             style:
//                 GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
//             textAlign: TextAlign.center,
//           ),
//           InkWell(
//             onTap: () {
//               // nav;
//               // Beamer.of(context).beamToNamed('/confirmInvoice');
//               Navigator.pop(context);
//             },
//             child: Container(
//               height: 60,
//               width: 342,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: HexColor('#0098DB')),
//               child: Center(
//                 child: Text(
//                   'Continue',
//                   style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
