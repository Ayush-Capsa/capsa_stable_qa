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

class AddInvoice extends StatefulWidget {
  AddInvoice({
    Key key,
  }) : super(key: key);

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
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

  bool saving = false;

  final rateController2 = TextEditingController(text: '');

  dynamic companyDetails = null;

  dynamic _future;

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  Future<dynamic> getCompanyNames(BuildContext context) async {
    if (companyDetails == null) {
      dynamic data =
          await Provider.of<VendorActionProvider>(context, listen: false)
              .getCompanyName();
      companyDetails = data;
    }

    return companyDetails;
  }

  int navigate() {
    Beamer.of(context).beamToNamed('/confirmInvoice');
    return 1;
  }

  void resetAnchor() {
    Future.delayed(const Duration(milliseconds: 500), () {
      anchor = null;
      anchorController.text = '';
      _cuGst = '';

      setState(() {
        showExtendedDate = true;
      });
      setState(() {
        showExtendedDate = false;
      });
    });
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
    if (num.tryParse(invSell) > 0)
      rate = ((num.tryParse(invAmt) / num.tryParse(invSell)) - 1) *
          (1 / tenureDaysDiff) *
          365;
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
  final currencyController = TextEditingController(text: '');
  var anchor;
  dynamic grade;

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

  Widget getCurrencyIcon(String currency) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        currency == 'NGN'
            ? '₦'
            : currency == 'USD'
                ? '\$'
                : currency == 'GBP'
                    ? '£'
                    : '€',
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);

    _future = getCompanyNames(context);

    if (invoiceProvider.invoiceFormWorking) {
      final invoiceFormData = invoiceProvider.invoiceFormData;

      invoiceNoController.text = invoiceFormData["invoiceNo"];
      poController.text = invoiceFormData["poNumber"];
      tenureController.text = invoiceFormData["tenure"];
      invoiceAmtController.text = invoiceFormData["invAmt"];
      buyAmtController.text = invoiceFormData["butAmt"];
      detailsController.text = invoiceFormData["details"];
      anchor = invoiceFormData["anchor"];
      anchorController.text = invoiceFormData["anchorAddress"];
      dateCont.text = invoiceFormData["dateCont"];
      tenureDaysDiff = num.parse(invoiceFormData["tenureDaysDiff"]);
      rateController2.text = invoiceFormData["rate"];
      dueDateCont.text = invoiceFormData["dueDateCont"];
      fileCont.text = invoiceFormData["fileCont"];
      _selectedDate = invoiceFormData["_selectedDate"];
      _selectedDueDate = invoiceFormData["_selectedDueDate"];
      file = invoiceFormData["file"];
      _cuGst = invoiceFormData["cuGst"];
      showExtendedDate = invoiceFormData["showExtendedDueDate"];
      grade = invoiceFormData["grade"];
      if(showExtendedDate){
        _extendedDueDate =
            _selectedDueDate.add(Duration(days: grade == 'C' ? 30 : 45));
        extendedDueDateCont.text = DateFormat.yMMMd().format(_extendedDueDate);
      }
    }

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

    return Container(
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
            TopBarWidget("Add Invoice", ""),
            SizedBox(
              height: (!Responsive.isMobile(context)) ? 8 : 15,
            ),
            if (Responsive.isMobile(context)) mobileFormSteper(),
            FutureBuilder<Object>(
                future: _future,
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
                        'There was an error :(\n' + snapshot.error.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    dynamic _data = snapshot.data;

                    var _items = _data['data'];
                    Map<String, bool> _isBlackListed = {};
                    Map<String, String> anchorGrade = {};

                    var anchorNameList = [];

                    if (_data['res'] == 'success') {
                      anchorNameList = _items;
                      term = [];
                      _items.forEach((element) {
                        term.add(element['name'].toString());
                        _isBlackListed[element['name'].toString()] =
                            element['isBlacklisted'] != null
                                ? element['isBlacklisted'] == '1'
                                    ? true
                                    : false
                                : false;
                        anchorGrade[element['name'].toString()] =
                            element['grade'] ?? '';
                      });
                    } else {
                      return Center(
                        child: Text(
                          'There was an error :(\n' + _data['messg'].toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      );
                    }

                    // ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                    final GlobalKey<FormFieldState> _key =
                        GlobalKey<FormFieldState>();

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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                if (anchorController.text ==
                                                    '') {
                                                  return "Can't be empty";
                                                }
                                                return null;
                                              },
                                              items:
                                                  term.map((String category) {
                                                return DropdownMenuItem(
                                                  //key: _key,
                                                  value: category,
                                                  child:
                                                      Text(category.toString()),
                                                );
                                              }).toList(),
                                              onChanged: (v) {
                                                // capsaPrint(anchorNameList);
                                                if (_isBlackListed[v]) {
                                                  showToast(
                                                      'Functionalities for this anchor is temporarily suspended',
                                                      context,
                                                      type: 'warning');
                                                  _formKey.currentState.reset();
                                                } else {
                                                  anchor = v;
                                                  anchorNameList
                                                      .forEach((element1) {
                                                    if (element1['name'] == v) {
                                                      // cacAddress = element1['name_address'];
                                                      anchorController.text =
                                                          element1[
                                                              'name_address'];
                                                      grade =
                                                          anchorGrade[anchor];
                                                      capsaPrint(
                                                          'Grade initiated : ${anchor} $grade');
                                                      _cuGst =
                                                          element1['cu_gst'];

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

                                                      // capsaPrint(cacAddress);

                                                    }
                                                  });
                                                }
                                              },
                                              value: anchor,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white,
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
                                        Flexible(
                                          child: UserTextFormField(
                                            label: "CAC/Address",
                                            hintText: "",
                                            controller: anchorController,
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
                                            controller: invoiceNoController,
                                            onChanged: (v) {
                                              String s = v;
                                              if (v.contains('/') ||
                                                  v.contains(r'\')) {
                                                showToast(
                                                    'Invoice Number Cannot Contain  /  or  '
                                                    r'\',
                                                    context,
                                                    type: 'warning');
                                                s = s.replaceAll(r'\', '-');
                                                s = s.replaceAll('/', '-');
                                              }
                                              invoiceNoController.text = s;
                                              invoiceNoController.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              invoiceNoController
                                                                  .text
                                                                  .length));
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: UserTextFormField(
                                            label: "PO Number",
                                            controller: poController,
                                            hintText: "Purchase order Number",
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
                                            hintText: "Enter invoice amount",
                                            prefixIcon: getCurrencyIcon('NGN'),
                                            note:
                                                'Invoice amount should not include\nVAT fee',
                                            // Image.asset(
                                            //     "assets/images/currency.png"),
                                            controller: invoiceAmtController,
                                            onChanged: (v) {
                                              calculateRate();
                                            },
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"[0-9.]")),
                                              TextInputFormatter.withFunction(
                                                  (oldValue, newValue) {
                                                try {
                                                  final text = newValue.text;
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
                                            suffixIcon:
                                                Icon(Icons.date_range_outlined),
                                            hintText: "Invoice Issue date",
                                            onTap: () => _selectDate(context),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        Flexible(
                                          child: UserTextFormField(
                                            label: "Due Date",
                                            suffixIcon:
                                                Icon(Icons.date_range_outlined),
                                            readOnly: true,
                                            controller: dueDateCont,
                                            hintText: "Invoice Due Date",
                                            onTap: () =>
                                                _selectDueDate(context),
                                            keyboardType: TextInputType.number,
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
                                              label: "Extended Due Date",
                                              suffixIcon: Icon(
                                                  Icons.date_range_outlined),
                                              readOnly: true,
                                              controller: extendedDueDateCont,
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
                                            hintText: "Amount to sell invoice",
                                            prefixIcon: getCurrencyIcon('NGN'),
                                            validator: (v) {
                                              return null;
                                            },
                                            onChanged: (v) {
                                              if (num.parse(v) >=
                                                  num.parse(invoiceAmtController
                                                      .text)) {
                                                buyAmtController.text = "";
                                                showToast(
                                                    'Sell Now Price cann\'t be greater then invoice amount',
                                                    context);
                                              }
                                              calculateRate();
                                            },
                                            controller: buyAmtController,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            inputFormatters: [
                                              // CurrencyTextInputFormatter(locale: "en_US",decimalDigits: 2),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"[0-9.]")),
                                              TextInputFormatter.withFunction(
                                                  (oldValue, newValue) {
                                                try {
                                                  final text = newValue.text;
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
                                            hintText:
                                                "PDF(Single/Multiple page) or Image File",
                                            minLines: 1,
                                            onTap: () async {
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
                                                        'png') {
                                                  setState(() {
                                                    file = result.files.first;
                                                    fileCont.text = file.name;
                                                    capsaPrint('ok');
                                                  });
                                                } else if (result.files.first
                                                        .extension ==
                                                    'pdf') {
                                                  setState(() {
                                                    file = result.files.first;
                                                    fileCont.text = file.name;
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
                                                    builder:
                                                        (BuildContext context) {
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
                                            },
                                            readOnly: true,
                                            suffixIcon: Icon(Icons.upload_file),
                                            maxLines: 5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          saving = true;
                                        });

                                        if (_formKey.currentState.validate()) {
                                          {
                                            dynamic invoiceFormData = {
                                              "invoiceNo":
                                                  invoiceNoController.text,
                                              "poNumber": poController.text,
                                              "tenure": tenureController.text,
                                              "invAmt":
                                                  invoiceAmtController.text,
                                              "butAmt": buyAmtController.text,
                                              "details": detailsController.text,
                                              "anchor": anchor,
                                              "anchorAddress":
                                                  anchorController.text,
                                              "dateCont": dateCont.text,
                                              "tenureDaysDiff":
                                                  tenureDaysDiff.toString(),
                                              "rate": rateController2.text,
                                              "dueDateCont": dueDateCont.text,
                                              "extendedDueDateString": showExtendedDate ? extendedDueDateCont.text : '',
                                              "fileCont": fileCont.text,
                                              "_selectedDate": _selectedDate,
                                              "_selectedDueDate":
                                                  _selectedDueDate,
                                              "_extendedDueDate": _extendedDueDate,
                                              "file": file,
                                              "cuGst": _cuGst,
                                              "showExtendedDueDate": showExtendedDate,
                                              "grade": grade,
                                            };

                                            // capsaPrint(invoiceFormData);

                                            invoiceProvider.setInvoiceFormData(
                                                invoiceFormData);

                                            dynamic splitData =
                                                await invoiceProvider
                                                    .splitInvoice(
                                                        invoiceNoController
                                                            .text,
                                                        invoiceAmtController
                                                            .text);

                                            if (splitData['isSplit'] == 1) {
                                              setState(() {
                                                saving = false;
                                              });
                                              print('split warning');
                                              showDialog(
                                                  // barrierColor: Colors.transparent,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    functionBack() {
                                                      Navigator.pop(context);
                                                    }

                                                    return AlertDialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0))),
                                                        content:
                                                            SplitInvoiceWarning(
                                                          invNo:
                                                              invoiceNoController
                                                                  .text,
                                                          nav: navigate,
                                                        ));
                                                  }).then((value) => Beamer.of(
                                                      context)
                                                  .beamToNamed(
                                                      '/confirmInvoice'));
                                            } else {
                                              Beamer.of(context).beamToNamed(
                                                  '/confirmInvoice');
                                            }

                                            // Beamer.of(context)
                                            //     .beamToNamed('/confirmInvoice');

                                            // showToast('Confirm invoice Details',
                                            //     context,
                                            //     type: "info");
                                          }
                                        }

                                        setState(() {
                                          saving = false;
                                        });
                                      },
                                      child: Container(
                                        width: 230,
                                        height: 59,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          color: Color.fromRGBO(0, 152, 219, 1),
                                        ),
                                        child: saving
                                            ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Color.fromRGBO(
                                                        242, 242, 242, 1),
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  'Preview',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 242, 1),
                                                    fontSize: 24,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.w500,
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
                                )),
                            SizedBox(
                              height: 40,
                            ),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * 0.6,
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                    ),
                                    color: Color.fromRGBO(0, 152, 219, 1),
                                  ),
                                  child: Container(
                                    child: file != null
                                        ? file.extension == 'pdf'
                                            ? SfPdfViewer.memory(file.bytes)
                                            : Image.memory(file.bytes)
                                        : Center(
                                            child: Text(
                                            'Uploaded Invoice will appear here',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                // fontFamily: 'Poppins',
                                                fontSize: 14,
                                                letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          )),
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
    );
  }

  Widget mobileFormSteper() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            //color: Color.fromRGBO(255, 255, 255, 1),
            ),
        child: Center(
          child: Stack(children: <Widget>[
            Positioned(
                top: 14,
                left: 104,
                child: Container(
                    width: 180,
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
                left: 264,
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
