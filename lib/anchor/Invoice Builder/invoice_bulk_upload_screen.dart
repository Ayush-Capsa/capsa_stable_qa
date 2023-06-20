import 'package:beamer/beamer.dart';
import 'package:capsa/anchor/Invoice%20Builder/add_invoice_anchor.dart';
import 'package:capsa/anchor/Invoice%20Builder/bulk_upload_preview_Screen.dart';
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

import '../../anchor/provider/anchor_action_providers.dart';
import '../model/AnchorBulkInvoiceModel.dart';
import '../provider/anchor_invoice_provider.dart';
import 'confirm_invoice_anchor.dart';

class InvoiceBulkUpload extends StatefulWidget {
  InvoiceBulkUpload({
    Key key,
  }) : super(key: key);

  @override
  State<InvoiceBulkUpload> createState() => _InvoiceBulkUploadState();
}

class _InvoiceBulkUploadState extends State<InvoiceBulkUpload> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');
  final dueDateCont = TextEditingController();
  final dateCont = TextEditingController();
  final extendedDueDateCont = TextEditingController();
  final fileCont = TextEditingController(text: '');
  DateTime _selectedDate;
  DateTime _selectedDueDate;
  DateTime _extentedDueDate;
  var _cuGst;
  bool showExtendedDate = false;

  bool saving = false;

  final rateController2 = TextEditingController(text: '');

  dynamic companyDetails = null;

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  Future<dynamic> getCompanyNames(BuildContext context) async {
    if (companyDetails == null) {
      dynamic data =
          await Provider.of<AnchorActionProvider>(context, listen: false)
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
        _extentedDueDate =
            newSelectedDate.add(Duration(days: grade == 'C' ? 30 : 45));
        extendedDueDateCont.text = DateFormat.yMMMd().format(_extentedDueDate);
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
  final vendorController = TextEditingController(text: '');

  final invoiceNoController = TextEditingController(text: '');
  final poController = TextEditingController(text: '');
  final tenureController = TextEditingController(text: '');
  final invoiceAmtController = TextEditingController(text: '');
  final buyAmtController = TextEditingController(text: '');
  final detailsController = TextEditingController(text: '');
  final currencyController = TextEditingController(text: '');
  var anchor;
  var vendor;
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
    //invoiceProvider.splitInvoice('DH001', '50000000');
  }

  @override
  Widget build(BuildContext context) {
    final invoiceProvider =
        Provider.of<AnchorInvoiceProvider>(context, listen: false);

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
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.85,
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
                  TopBarWidget("Upload Invoice", ""),
                  SizedBox(
                    height: (!Responsive.isMobile(context)) ? 8 : 15,
                  ),
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
                          dynamic temp = snapshot.data;
                          dynamic _data = temp[0];
                          dynamic _vendorData = temp[1];

                          var _items = _data['data'];
                          Map<String, bool> _isBlackListed = {};
                          Map<String, String> anchorGrade = {};

                          List<String> vendorsList = [];
                          Map<String, String> vendorPan = {};

                          String selectedVendor = '';
                          String selectedVendorPan = '';

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

                            dynamic responseList = _vendorData['vendorList'];
                            responseList.forEach((element) {
                              vendorsList.add(element['NAME']);
                              vendorPan[element['NAME']] = element['PAN_NO'];
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
                          List<String> uploadTypes = [
                            'Single Upload',
                            'Bulk Upload'
                          ];

                          return Container(
                            //width: MediaQuery.of(context).size.width,
                            child: Form(
                              // onChanged: ,
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // orientation: Responsive.isMobile(context) ? "Column" : "Row" ,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 500,
                                        height: 150,
                                        child: UserTextFormField(
                                          controller: fileCont,
                                          info: '',
                                          infoFontSize: 14,
                                          //onInfoTap: Provider.of<AnchorActionProvider>(context, listen: false).downloadFile('https://storage.googleapis.com/download/storage/v1/b/getcapsa-ca-quality.appspot.com/o/%2Fkyc_docs%2F12123123124_2023-05-23_kycdocs1.jpg?generation=1684843926705064&alt=media'),
                                          // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                          label: "Upload invoice",
                                          hintText:
                                          "CSV file",
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
                                                'csv',
                                              ],
                                            );

                                            if (result != null) {
                                              if (result.files.first
                                                  .extension ==
                                                  'csv' ||
                                                  result.files.first
                                                      .extension ==
                                                      'csv') {
                                                setState(() {
                                                  file = result.files.first;
                                                  fileCont.text = file.name;
                                                  capsaPrint('ok');
                                                });
                                              } else if (result
                                                  .files.first.extension ==
                                                  'pdf') {
                                                setState(() {
                                                  file = result.files.first;
                                                  fileCont.text = file.name;
                                                });
                                                // generateTn(file);

                                              } else {
                                                showDialog<void>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: const Text(
                                                            'Invalid Format Selected. Please select a PDF or JPG file'),
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
                                          },
                                          readOnly: true,
                                          suffixIcon: Icon(Icons.upload_file),
                                          maxLines: 5,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => Provider.of<AnchorActionProvider>(context, listen: false).downloadFile('https://storage.googleapis.com/download/storage/v1/b/getcapsa-ca-quality.appspot.com/o/%2Ftemplates%2Fundefined_kycdocs1.csv?generation=1685958113506305&alt=media'),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            'Download CSV upload template',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 14),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  // Text(
                                  //   '                  Download Invoice Upload Template'
                                  // ),
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        saving = true;
                                      });

                                      dynamic response = await Provider.of<
                                          AnchorActionProvider>(
                                          context,
                                          listen: false)
                                          .uploadInvoiceCsv(file);

                                      List<BulkInvoiceModel> invoices = [];

                                      capsaPrint('invoice rsponse length : ${response.length} ${response[0]}');

                                      for (int i = 0;
                                      i < response.length;
                                      i++) {
                                        var element = response[i];
                                        invoices.add(BulkInvoiceModel(
                                            element['S. No.'].toString(),
                                            element['vendor_name'].toString(),
                                            element['invoice_number'].toString(),
                                            element['po_number'].toString(),
                                            element['invoice_amount'].toString(),
                                            element['buy_now_price'].toString(),
                                            element['tenure'].toString(),
                                            element['invoice_date'].toString(),
                                            element['invoice_due_date'].toString()));
                                      }

                                      setState(() {
                                        saving = false;
                                      });

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MultiProvider(
                                              providers: [
                                                ChangeNotifierProvider<AnchorActionProvider>(
                                                  create: (_) => AnchorActionProvider(),
                                                ),
                                                ChangeNotifierProvider<AnchorInvoiceProvider>(
                                                  create: (_) => AnchorInvoiceProvider(),
                                                ),

                                              ],
                                              child: BulkUploadPreviewScreen(invoices: invoices, file: file),
                                            )
                                        ),
                                      );

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
                                        color:
                                        Color.fromRGBO(0, 152, 219, 1),
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
                                          'Upload',
                                          textAlign: TextAlign.center,
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
                                  SizedBox(
                                    height: 40,
                                  ),
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
        ],
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
