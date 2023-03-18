import 'dart:convert';

import 'package:capsa/vendor-new/dialog_boxes/pdf_dialog_box.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/vendor-new/pages/edit_invoice.dart';
import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'edit_pending_invoice.dart';
import 'invoice_details.dart';

class InvoiceListPage extends StatefulWidget {
  final String type;

  const InvoiceListPage(this.type, {Key key}) : super(key: key);

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  var _search = "";

  void navigate() {
    Beamer.of(context).beamToNamed('/upload-account-letter');
  }

  InvoiceProvider invoiceProvider;

  List<TableRow> rows = [];
  bool dataLoaded = false;
  String search = "";
  dynamic data = null;
  dynamic fetchedData = null;
  int current_index = 1;
  int total_pages = 1;
  bool presentingInvoice = false;
  String _url = apiUrl + 'dashboard/r/';
  List<Widget> mobileCards = [];
  String title = "";

  List<bool> expand = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Map<String, String> noInvoiceMessage = {
    'live': 'Invoices you have live\nwill appear here.',
    'pending': 'Invoices you have pending\nwill appear here.',
    'sold': 'Invoices you have sold\nwill appear here.',
    'notPresented': 'Invoices you have sold\nwill appear here.',
    'all': '',
  };

  Text status(int status, String discountStatus) {
    String s = status == 1
        ? 'Not Presented'
        : status == 2
            ? 'Pending'
            : status == 3
                ? 'Live'
                : 'Rejected';
    Color c = status == 1
        ? HexColor('#828282')
        : status == 2
            ? !Responsive.isMobile(context)
                ? Colors.yellow
                : HexColor('#F2994A')
            : status == 3
                ? HexColor('#219653')
                : HexColor('#EB5757');

    if (discountStatus == 'true') {
      s = 'Sold';
      c = HexColor('#EB5757');
    }

    return Text(
      s,
      style: GoogleFonts.poppins(
          fontSize: Responsive.isMobile(context) ? 14 : 18,
          fontWeight: FontWeight.w400,
          color: c),
    );
  }

  Future<Object> submitForApproval(_body) async {
    // capsaPrint('userData');
    // capsaPrint(userData);

    dynamic _uri;

    _uri = _url + 'requestApproval';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<void> presentInvoice(dynamic invoiceData) async {
    setState(() {
      presentingInvoice = true;
    });
    final Box box = Hive.box('capsaBox');

    var userData = box.get('userData');

    var _body = {};
    _body['panNumber'] = userData['panNumber'];
    _body['role'] = userData['role'];
    _body['userName'] = userData['userName'];
    _body['invNum'] = invoiceData['invoice_number'].toString();
    _body['isSplit'] = invoiceData['isSplit'] == null
        ? '0'
        : invoiceData['isSplit'].toString();
    // _body['invNum'] = invoice.invNo;

    Map<String, dynamic> _data = await submitForApproval(_body);
    // Navigator.of(context,rootNavigator: true).pop();
    print('data $_data');
    if (_data['res'] == 'success') {
      // var invNum = _data['data']['invnum'];
      setState(() {
        dataLoaded = false;
        presentingInvoice = false;
      });
      fetchedData = null;
      getData(widget.type, current_index);
      showPopupActionInfo(context,
          heading:
              "Congratulations! Your invoice \nhas been saved and presented. ",
          info:
              "When your Anchor approves the invoice, you will start receiving bids from Investors.",
          buttonText: "View Pending Invoices",
          buttonText2: "Back",
          buttonColor2: Colors.red, onTap: () {
        Navigator.of(context, rootNavigator: true).pop();
        invoiceProvider.resetInvoiceFormData();
        Beamer.of(context).beamToNamed('/pending-invoices');
      }, onTap2: () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    } else {
      showPopupActionInfo(
        context,
        heading: "Unable to present invoice",
        info: _data['messg'],
        buttonText: "Ok",
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
    }
  }

  List<dynamic> searchData(
    List<dynamic> table,
    String search,
  ) {
    capsaPrint('Search Data called');
    List<dynamic> result = [];

    if (search == "") {
      return table;
    }
    table.forEach((element) {
      // int a = element['invoice_number']
      //     .toString()
      //     .toLowerCase()
      //     .compareTo(search.toLowerCase());
      // int b = element['customer_name']
      //     .toString()
      //     .toLowerCase()
      //     .compareTo(search.toLowerCase());
      if (element['invoice_number']
          .toString()
          .toLowerCase().contains(search.toLowerCase()) || element['customer_name']
          .toString()
          .toLowerCase().contains(search.toLowerCase())) {
        result.add(element);
      }
    });
    if (result.isEmpty) {
      showToast('No Data Found', context, type: "warning");
      result = table;
    }

    if (result.isEmpty) {
      showToast('No Data Found', context, type: "warning");
      return table;
    }
    return result;
  }

  void getData(String type, int page, {bool reload = false}) async {
    capsaPrint('get data called ${widget.type}');
    rows = [];
    mobileCards = [];
    InvoiceProvider _invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    Map<dynamic, dynamic> _data = {};
    if (fetchedData == null || reload == true) {
      fetchedData = await _invoiceProvider.queryInvoiceList(type);
    }
    // fetchedData == null
    //     ?
    //     : fetchedData = fetchedData;
    //
    // // final invoiceProvider =
    // // Provider.of<InvoiceProvider>(context, listen: false);
    //
    // fetchedData == null?_data = await _invoiceProvider.getCurrencies():_data = _data;

    capsaPrint('Pass 1');
    data = searchData(
      fetchedData['data']['invoicelist'],
      search,
    );
    capsaPrint('Pass 2');
    total_pages =
        data.length % 10 == 0 ? (data.length ~/ 10) : ((data.length ~/ 10) + 1);

    //print('Data : $data');

    // data['data']['invoicelist'].forEach((_element){
    //  print('$_element \n\n') ;
    // }
    // );
    //print('Invoice Data : ${data['data']['invoicelist']}');

    // int x = 0,y = 0;
    // while(x<5 || y>=data['data']['invoiceList'].length){
    //   if(data['data']['invoiceList'][y]['isSplit'] == '1'){
    //     print('DATA $y \n${data['data']['invoiceList'][y]}\n\n');
    //     x++;
    //   }
    //   y++;
    // }
    //data = [];
    if (data.length > 0) {
      mobileCards.add(Container());
      for (var invoices in data) {
        mobileCards.add(
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              //border: Border.all(color: HexColor('#DBDBDB')),
              color: HexColor('#F5FBFF'),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => InvoiceDetails(
                      invVoiceNumber: invoices['invoice_number'],
                      data: invoices,
                      type: widget.type),
                  // VendorMain(
                  //   pageUrl: "/viewInvoice/" + invoices['invoice_number'],
                  //   menuList: false,
                  //   mobileTitle: 'Invoice Details',
                  //   body: InvoiceDetails(invVoiceNumber: invoices['invoice_number'],),
                  //   backButton: true,
                  // ),
                  // MultiProvider(
                  //   providers: [
                  //     ChangeNotifierProvider<ProfileProvider>(
                  //       create: (_) => ProfileProvider(),
                  //     ),
                  //     ChangeNotifierProvider<VendorInvoiceProvider>(
                  //       create: (_) => VendorInvoiceProvider(),
                  //     ),
                  //     ChangeNotifierProvider<VendorActionProvider>(
                  //       create: (_) => VendorActionProvider(),
                  //     ),
                  //   ],
                  //   child:   VendorMain(
                  //     pageUrl: "/viewInvoice/" + invoices.invNo,
                  //     menuList: false,
                  //     mobileTitle: 'Invoice Details',
                  //     body: ConfirmInvoice(invVoiceNumber: invoices.invNo),
                  //     backButton: true,
                  //   ),
                  // ),
                ))
                    .then((value) {
                  setState(() {
                    dataLoaded = false;
                  });
                  initialise();
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            invoices['invoice_number'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                // fontFamily: 'roboto',
                                fontSize: 14,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            invoices['customer_name'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                // fontFamily: 'roboto',
                                fontSize: 14,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            formatCurrency(
                              invoices['invoice_value'],
                              withIcon: false,
                            ),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontFamily: 'roboto',
                                fontSize: 14,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.w600,
                                height: 1),
                          ),
                          const SizedBox(height: 8),
                          invoices['status'] == null
                              ? Text('')
                              : status(
                                  int.parse(invoices['status'].toString()),
                                  invoices['discount_status'] == null
                                      ? ' '
                                      : invoices['discount_status'].toString()),
                          // Text(
                          //   // invoices.invDate,
                          //   statusShow(invoices),
                          //   textAlign: TextAlign.right,
                          //   style: TextStyle(
                          //       color: Color.fromRGBO(33, 150, 83, 1),
                          //       // fontFamily: 'roboto',
                          //       fontSize: 14,
                          //       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          //       fontWeight: FontWeight.normal,
                          //       height: 1),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      capsaPrint('pass 2.1');

      mobileCards.add(Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Container(
                child: Image.asset(
              'assets/icons/No Bids Placed.png',
              height: 229,
              width: 178,
            )),
            SizedBox(
              height: 24,
            ),
            Text(
              'No Invoices',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: HexColor('#333333')),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              noInvoiceMessage[widget.type],
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HexColor('#828282')),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ));
    }

    capsaPrint('pass 3');

    rows.add(TableRow(children: [
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(' ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('S/N',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Invoice No',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Issue Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Due Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Anchor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Invoice Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(' ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      )
    ]));

    int begin = (page - 1) * 10;
    int limit =
        ((data.length - begin) > 10) ? (begin + 9) : (data.length - begin - 1);

    for (int i = begin; i <= limit; i++) {
      //print('$i $limit ${data[i]}\n\n');
      print('pass  xx $i');

      if (i == 0) {
        print(data[i]);
      }

      rows.add(TableRow(children: [
        Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  data[i]['isSplit'] == null
                      ? expand[i - begin] = expand[i - begin]
                      : data[i]['isSplit'].toString() == '1'
                          ? expand[i - begin] = !expand[i - begin]
                          : expand[i - begin] = expand[i - begin];
                  getData(type, current_index);
                });
              },
              child: data[i]['isSplit'] == null
                  ? Text('')
                  : data[i]['isSplit'].toString() == '1'
                      ? expand[i - begin] == true
                          ? Icon(Icons.arrow_drop_down_sharp)
                          : Icon(Icons.arrow_right_sharp)
                      : Text(''),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text((i + 1).toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
              data[i]['invoice_number'] == null
                  ? ''
                  : data[i]['invoice_number'].toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: data[i]['invoice_date'] == null
              ? ''
              : Text(
                  DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
                      .parse((data[i]['invoice_date']))),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: data[i]['invoice_due_date'] == null
              ? ''
              : Text(
                  DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
                      .parse((data[i]['invoice_due_date']))),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: data[i]['customer_name'] == null
              ? ''
              : Text(data[i]['customer_name'].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: data[i]['invoice_value'] == null
              ? ''
              : Text(
                  formatCurrency(data[i]['invoice_value'].toString(),
                      withIcon: true),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: data[i]['status'] == null
                ? Text('')
                : status(
                    int.parse(data[i]['status'].toString()),
                    data[i]['discount_status'] == null
                        ? ' '
                        : data[i]['discount_status'].toString())),
        Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: (int.parse(data[i]['status'].toString()) == 1 &&
                    data[i]['discount_status'] != 'true')
                ? PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () {
                            // capsaPrint('view Tapped');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  backgroundColor: HexColor("#F5FBFF"),
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 14.0),
                                  contentPadding: EdgeInsets.all(10),
                                  title: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Present Invoice",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  content: Container(
                                    constraints: BoxConstraints(minWidth: 480),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 30),
                                        Text(
                                            "Do you want to present invoice  ${data[i]['invoice_number']} ?",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400)),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.blue,
                                              ),
                                              child: Text(
                                                "Present",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 22),
                                              ),
                                              onPressed: () async {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                await presentInvoice(data[i]);
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                              child: Text(
                                                "Cancel",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 22),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            //Beamer.of(context).beamToNamed('/viewInvoice/' +Uri.encodeComponent(data[i]['invoice_number'].toString(),));
                          },
                          child: InkWell(
                            child: Row(
                              children: [
                                Icon(Icons.present_to_all_rounded),
                                RichText(
                                  text: TextSpan(
                                    text: 'Present Invoice',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(51, 51, 51, 1)),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      PopupMenuItem(
                          child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // capsaPrint('view Tapped');
                          setState(() {
                            // dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);

                            DateTime date = DateFormat("yyyy-MM-dd")
                                .parse((data[i]['invoice_date']));
                            DateTime dueDate = DateFormat("yyyy-MM-dd")
                                .parse((data[i]['invoice_due_date']));
                            String date0 = DateFormat.yMMMd('en_US').format(
                                DateFormat("yyyy-MM-dd")
                                    .parse((data[i]['invoice_date'])));
                            String dueDate0 = DateFormat.yMMMd('en_US').format(
                                DateFormat("yyyy-MM-dd")
                                    .parse((data[i]['invoice_due_date'])));

                            dynamic invoiceFormData = {
                              "invoiceNo": data[i]['invoice_number'].toString(),
                              "poNumber": "",
                              "tenure": data[i]['payment_terms'].toString(),
                              "invAmt": data[i]['invoice_value'].toString(),
                              "butAmt": data[i]['ask_amt'].toString(),
                              "details": data[i]['description'].toString(),
                              "anchor": null,
                              "anchorAddress": null,
                              "dateCont": date0.toString(),
                              "tenureDaysDiff": '',
                              "rate": data[i]['ask_rate'].toString(),
                              "dueDateCont": dueDate0.toString(),
                              "fileCont": '',
                              "_selectedDate": date,
                              "_selectedDueDate": dueDate,
                              "file": null,
                              "cuGst": data[i]['customer_gst'].toString(),
                            };

                            invoiceProvider.setInvoiceFormData(invoiceFormData);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditInvoice(
                                        data: data[i],
                                      )),
                            ).then((value) {
                              setState(() {
                                dataLoaded = false;
                              });
                              initialise();
                            });
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(
                              width: 8,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Edit Invoice',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                          ],
                        ),
                      )),
                      PopupMenuItem(
                          child: InkWell(
                        onTap: () {
                          // capsaPrint('view Tapped');
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (context) => pdfDialogBox(
                                      invoiceProvider: _invoiceProvider,
                                      fileName: data[i]['invoice_file'],
                                    ));
                          });
                          //Beamer.of(context).beamToNamed('/viewInvoice/' +Uri.encodeComponent(data[i]['invoice_number'].toString(),));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.remove_red_eye),
                            RichText(
                              text: TextSpan(
                                text: 'View Invoice',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                          ],
                        ),
                      )),
                      PopupMenuItem(
                          child: InkWell(
                        onTap: () {
                          // capsaPrint('view Tapped');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                backgroundColor: HexColor("#F5FBFF"),
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 14.0),
                                contentPadding: EdgeInsets.all(10),
                                title: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Delete Invoice",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                content: Container(
                                  constraints: BoxConstraints(minWidth: 480),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 30),
                                      Text(
                                          "Do you want to delete invoice  ${data[i]['invoice_number']} ?",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.blue,
                                            ),
                                            child: Text(
                                              "Yes",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 22),
                                            ),
                                            onPressed: () async {
                                              await invoiceProvider
                                                  .deleteInvoice(
                                                      data[i]['invoice_number'],
                                                      data[i]['company_pan']);
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.red,
                                            ),
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 22),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).then((value) {
                            setState(() {
                              dataLoaded = false;
                            });
                            fetchedData = null;
                            getData(widget.type, current_index);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 8,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Delete',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  )
                : PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: InkWell(
                        onTap: () {
                          // capsaPrint('view Tapped');
                          Navigator.pop(
                            context,
                          );
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (context) => pdfDialogBox(
                                      invoiceProvider: _invoiceProvider,
                                      fileName: data[i]['invoice_file'],
                                    ));
                          });
                          //Beamer.of(context).beamToNamed('/viewInvoice/' +Uri.encodeComponent(data[i]['invoice_number'].toString(),));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.remove_red_eye),
                            RichText(
                              text: TextSpan(
                                text: 'View Invoice',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                          ],
                        ),
                      )),
                      if (type == 'pending')
                        PopupMenuItem(
                            child: InkWell(
                          onTap: () {
                            // capsaPrint('view Tapped');

                            // dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);
                            Navigator.pop(
                              context,
                            );

                            DateTime date = DateFormat("yyyy-MM-dd")
                                .parse((data[i]['invoice_date']));
                            DateTime dueDate = DateFormat("yyyy-MM-dd")
                                .parse((data[i]['invoice_due_date']));
                            String date0 = DateFormat.yMMMd('en_US').format(
                                DateFormat("yyyy-MM-dd")
                                    .parse((data[i]['invoice_date'])));
                            String dueDate0 = DateFormat.yMMMd('en_US').format(
                                DateFormat("yyyy-MM-dd")
                                    .parse((data[i]['invoice_due_date'])));

                            dynamic invoiceFormData = {
                              "invoiceNo": data[i]['invoice_number'].toString(),
                              "poNumber": "",
                              "tenure": data[i]['payment_terms'].toString(),
                              "invAmt": data[i]['invoice_value'].toString(),
                              "butAmt": data[i]['ask_amt'].toString(),
                              "details": data[i]['description'].toString(),
                              "anchor": null,
                              "anchorAddress": null,
                              "dateCont": date0.toString(),
                              "tenureDaysDiff": '',
                              "rate": data[i]['ask_rate'].toString(),
                              "dueDateCont": dueDate0.toString(),
                              "fileCont": '',
                              "_selectedDate": date,
                              "_selectedDueDate": dueDate,
                              "file": null,
                              "cuGst": data[i]['customer_gst'].toString(),
                            };

                            invoiceProvider.setInvoiceFormData(invoiceFormData);

                            capsaPrint(
                                'Invoice Edit Data : \n${data[i]['isSplit']}');
                            if (data[i]['isSplit'].toString() != '1') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditPendingInvoice(
                                          data: data[i],
                                        )),
                              ).then((value) {
                                setState(() {
                                  dataLoaded = false;
                                });
                                initialise();
                              });
                            } else {
                              showToast(
                                  'This Invoice Cannot be edited', context,
                                  type: 'warning', toastDuration: 2);
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(
                                width: 8,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Edit Invoice',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(51, 51, 51, 1)),
                                ),
                              ),
                            ],
                          ),
                        )),
                      if (type == 'pending')
                        PopupMenuItem(
                            child: InkWell(
                          onTap: () {
                            // capsaPrint('view Tapped');
                            Navigator.pop(
                              context,
                            );
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0))),
                                    backgroundColor:
                                        Color.fromRGBO(245, 251, 255, 1),
                                    content: Container(
                                      constraints: Responsive.isMobile(context)
                                          ? BoxConstraints(
                                              minHeight: 300,
                                            )
                                          : BoxConstraints(
                                              minHeight: 220, minWidth: 350),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(245, 251, 255, 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            6, 8, 6, 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Image.asset(
                                                'assets/icons/warning.png'),
                                            SizedBox(
                                              height: 22,
                                            ),
                                            Text(
                                                "Do you want to delete invoice\n${data[i]['invoice_number']} ? ",
                                                textAlign: TextAlign.center),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      width: 100,
                                                      height: 49,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 2,
                                                              color: HexColor(
                                                                  '#0098DB')),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Center(
                                                        child: Text(
                                                          'NO',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: HexColor(
                                                                      '#0098DB'),
                                                                  fontSize: 18),
                                                        ),
                                                      )),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    showToast(
                                                        'Please Wait', context,
                                                        type: 'warning');
                                                    dynamic response =
                                                        await invoiceProvider
                                                            .deletePendingInvoice(
                                                                data[i][
                                                                    'invoice_number']);
                                                    if (response ==
                                                            'Deleted Successfully!' ||
                                                        response['msg'] ==
                                                            'success') {
                                                      showToast(
                                                          'Invoice Deleted',
                                                          context);
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        dataLoaded = false;
                                                      });
                                                      initialise();
                                                      //Navigator.pop(context);
                                                    } else {
                                                      showToast(
                                                          'Some Error Occurred',
                                                          context,
                                                          type: 'error');
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Container(
                                                      width: 100,
                                                      height: 49,
                                                      decoration: BoxDecoration(
                                                          color: HexColor(
                                                              '#0098DB'),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Center(
                                                        child: Text(
                                                          'YES',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18),
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
                                }).then((value) {
                              setState(() {
                                dataLoaded = false;
                              });
                              initialise();
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(
                                width: 8,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Delete Invoice',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(51, 51, 51, 1)),
                                ),
                              ),
                            ],
                          ),
                        )),
                    ],
                  ))
      ]));

      if (expand[i - begin]) {
        int j = 0;
        if (data[i]['isSplit'].toString() == '1') {
          //print('CHILD INVOICE: ${data[i]['chileInvoice'][0]}');
          data[i]['chileInvoice'].forEach((_element) {
            rows.add(TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(''),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${i + 1}.${j + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_element['invoice_number'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
                        .parse((_element['invoice_date']))),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
                        .parse((_element['invoice_due_date']))),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_element['customer_name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    formatCurrency(_element['invoice_value'].toString(),
                        withIcon: true),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: status(
                    int.parse(_element['status'].toString()),
                    _element['discount_status'] == null
                        ? ''
                        : data[i]['discount_status'].toString()),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: (int.parse(data[i]['status'].toString()) == 1 &&
                          data[i]['discount_status'] != 'true')
                      ? PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () {
                                // capsaPrint('view Tapped');
                                setState(() {
                                  // dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);

                                  DateTime date = DateFormat("yyyy-MM-dd")
                                      .parse((data[i]['invoice_date']));
                                  DateTime dueDate = DateFormat("yyyy-MM-dd")
                                      .parse((data[i]['invoice_due_date']));
                                  String date0 = DateFormat.yMMMd('en_US')
                                      .format(DateFormat("yyyy-MM-dd")
                                          .parse((data[i]['invoice_date'])));
                                  String dueDate0 = DateFormat.yMMMd('en_US')
                                      .format(DateFormat("yyyy-MM-dd").parse(
                                          (data[i]['invoice_due_date'])));

                                  dynamic invoiceFormData = {
                                    "invoiceNo":
                                        data[i]['invoice_number'].toString(),
                                    "poNumber": "",
                                    "tenure":
                                        data[i]['payment_terms'].toString(),
                                    "invAmt":
                                        data[i]['invoice_value'].toString(),
                                    "butAmt": data[i]['ask_amt'].toString(),
                                    "details":
                                        data[i]['description'].toString(),
                                    "anchor": null,
                                    "anchorAddress": null,
                                    "dateCont": date0.toString(),
                                    "tenureDaysDiff": '',
                                    "rate": data[i]['ask_rate'].toString(),
                                    "dueDateCont": dueDate0.toString(),
                                    "fileCont": '',
                                    "_selectedDate": date,
                                    "_selectedDueDate": dueDate,
                                    "file": null,
                                    "cuGst": data[i]['customer_gst'].toString(),
                                  };

                                  invoiceProvider
                                      .setInvoiceFormData(invoiceFormData);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditInvoice(
                                              data: data[i],
                                            )),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Edit Invoice',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(51, 51, 51, 1)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () {
                                // capsaPrint('view Tapped');
                                setState(() {
                                  showDialog(
                                      context: context,
                                      builder: (context) => pdfDialogBox(
                                            invoiceProvider: _invoiceProvider,
                                            fileName: data[i]['invoice_file'],
                                          ));
                                });
                                //Beamer.of(context).beamToNamed('/viewInvoice/' +Uri.encodeComponent(data[i]['invoice_number'].toString(),));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.remove_red_eye),
                                  RichText(
                                    text: TextSpan(
                                      text: 'View Invoice',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(51, 51, 51, 1)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            PopupMenuItem(
                                onTap: () {
                                  // capsaPrint('view Tapped');
                                  invoiceProvider.deleteInvoice(
                                      data[i]['invoice_number'],
                                      data[i]['company_pan']);
                                  setState(() {
                                    dataLoaded = false;
                                  });
                                  fetchedData = null;
                                  getData(widget.type, current_index);
                                },
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Delete',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromRGBO(
                                                  51, 51, 51, 1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )
                      : PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () {
                                // capsaPrint('view Tapped');
                                setState(() {
                                  showDialog(
                                      context: context,
                                      builder: (context) => pdfDialogBox(
                                            invoiceProvider: _invoiceProvider,
                                            fileName: data[i]['invoice_file'],
                                          ));
                                });
                                //Beamer.of(context).beamToNamed('/viewInvoice/' +Uri.encodeComponent(data[i]['invoice_number'].toString(),));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.remove_red_eye),
                                  RichText(
                                    text: TextSpan(
                                      text: 'View Invoice',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(51, 51, 51, 1)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ))
            ]));
            j++;
          });
        }
      }
    }
    setState(() {
      dataLoaded = true;
    });
  }

  void initialise() {
    var _type = widget.type;
    capsaPrint('Type : $_type');
    if (widget.type == 'notPresented') {
      _type = 'notPresented';
    }
    getData(_type, current_index, reload: true);
  }

  @override
  void initState() {
    // TODO: implement initState
    var _type = widget.type;
    if (widget.type == 'notPresented') {
      _type = 'notPresented';
    }

    invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);

    title = _type == 'all'
        ? 'All Invoices'
        : _type == 'pending'
            ? 'Pending Invoices'
            : _type == 'notPresented'
                ? 'Not Presented Invoices'
                : _type == 'live'? 'Live Invoices'
                : 'Sold Invoices';

    super.initState();
    getData(_type, current_index);
    //widget.type == 'all'?getData(_type):getDataFromProvider();
  }

  @override
  Widget build(BuildContext context) {
    var _type = widget.type;
    if (widget.type == 'notPresented') {
      _type = 'not Presented';
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 4 : 25.0),
      child: Container(
        child: (dataLoaded && !presentingInvoice)
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: !Responsive.isMobile(context) ? 22 : 8,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(29, 0, 36, 0),
                        child: TopBarWidget(title, ""),
                      ),
                      SizedBox(
                        height: (!Responsive.isMobile(context)) ? 8 : 15,
                      ),
                      rows.length > 1
                          ? Container(
                              // padding: EdgeInsets.all((!Responsive.isMobile(context)) ? 12 : 1.0),
                              // color: Colors.white,
                              //width: MediaQuery.of(context).size.width,
                              margin: Responsive.isMobile(context)
                                  ? EdgeInsets.fromLTRB(6, 6, 6, 0)
                                  : EdgeInsets.fromLTRB(29, 24, 36, 0),
                              height: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      // width: 200,
                                      height: (!Responsive.isMobile(context))
                                          ? 65
                                          : 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                        color: Colors.white,
                                      ),
                                      padding: Responsive.isMobile(context)
                                          ? EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2)
                                          : EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                      child: Center(
                                        child: TextFormField(
                                          // autofocus: false,
                                          onChanged: (v) {
                                            search = v;
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // fillColor: Color.fromRGBO(234, 233, 233, 1.0),
                                            // filled: true,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,

                                            // contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  getData(_type, current_index);
                                                });
                                              },
                                              icon: Icon(Icons.search),
                                            ),
                                            // isDense: true,
                                            // focusedBorder: InputBorder.none,
                                            // enabledBorder: InputBorder.none,
                                            // errorBorder: InputBorder.none,
                                            // disabledBorder: InputBorder.none,
                                            // contentPadding: EdgeInsets.only(left: 15, bottom: 15, top: 15, right: 15),
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    130, 130, 130, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: (!Responsive.isMobile(
                                                        context))
                                                    ? 18
                                                    : 15,
                                                letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                            hintText: Responsive.isMobile(
                                                    context)
                                                ? "Search by invoice number"
                                                : "Search by invoice number, Anchor name",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  !Responsive.isMobile(context)
                                      ? SizedBox(
                                          width: 40,
                                        )
                                      : Container(),
                                  // InkWell(
                                  //   onTap: () {
                                  //     context.beamToNamed("/addInvoice");
                                  //   },
                                  //   child: Container(
                                  //     width: 200,
                                  //     height: 59,
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(15),
                                  //       color: HexColor('#0098DB'),
                                  //     ),
                                  //     child: Center(
                                  //       child: Text(
                                  //         'Add Invoice',
                                  //         style: GoogleFonts.poppins(
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          : Container(),
                      Responsive.isMobile(context)
                          ? Center(
                              child: mobileCards.length > 1
                                  ? Card(
                                      //margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: mobileCards,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: mobileCards,
                                    ),
                            )
                          : Card(
                              margin: EdgeInsets.fromLTRB(29, 24, 36, 33),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(1),
                                        1: FlexColumnWidth(1.2),
                                        2: FlexColumnWidth(2.4),
                                        3: FlexColumnWidth(2.4),
                                        4: FlexColumnWidth(2.4),
                                        5: FlexColumnWidth(3.4),
                                        6: FlexColumnWidth(2.8),
                                        7: FlexColumnWidth(2.8),
                                        8: FlexColumnWidth(0.9),
                                      },
                                      border: TableBorder(
                                          verticalInside: BorderSide.none),
                                      children: rows,
                                    ),
                                  ),
                                  //padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.8, 10, 15, 16),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      width: 280,
                                      height: 56,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(245, 251, 255, 1),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 17.5, 24, 17.5),
                                            child: Text(
                                              'Page',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      51, 51, 51, 1)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 17.5, 30, 17.5),
                                            child: Text(
                                              '$current_index of $total_pages',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      51, 51, 51, 1)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 22, 20, 22),
                                            child: IconButton(
                                                onPressed: () {
                                                  if (current_index > 1) {
                                                    current_index--;
                                                    expand = [
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false
                                                    ];
                                                    getData(widget.type,
                                                        current_index);
                                                  }
                                                },
                                                icon:
                                                    Icon(Icons.arrow_back_ios),
                                                iconSize: 14,
                                                color: Color.fromRGBO(
                                                    130, 130, 130, 1),
                                                padding: EdgeInsets.all(0)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 22, 14, 22),
                                            child: IconButton(
                                                onPressed: () {
                                                  if (current_index <
                                                      total_pages) {
                                                    current_index++;
                                                    expand = [
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false
                                                    ];
                                                    getData(widget.type,
                                                        current_index);
                                                  }
                                                },
                                                icon: Icon(
                                                    Icons.arrow_forward_ios),
                                                iconSize: 14,
                                                color: Color.fromRGBO(
                                                    130, 130, 130, 1),
                                                padding: EdgeInsets.all(0)),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class PageBody1 extends StatelessWidget {
  final String type, search;

  const PageBody1(this.type, this.search, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: Provider.of<InvoiceProvider>(context, listen: false)
            .queryInvoiceList(type, search: search),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
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
            final invProvider =
                Provider.of<InvoiceProvider>(context, listen: false);

            List<InvoiceModel> _invList = invProvider.getInvoicesFilter(type);
            int i = 0;
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(25, 0, 0, 0),
                    offset: Offset(5.0, 5.0),
                    blurRadius: 20.0,
                  ),
                  BoxShadow(
                    color: Color.fromARGB(255, 255, 255, 255),
                    offset: Offset(-5.0, -5.0),
                    blurRadius: 0.0,
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: (Responsive.isMobile(context))
                    ? mobileViewList(context, _invList)
                    : DataTable(
                        columns: dataTableColumn([
                          "S/N",
                          "Invoice No",
                          "Issue Date",
                          "Due Date",
                          "Anchor",
                          "Amount(₦)",
                          "Status",
                          ""
                        ]),
                        rows: <DataRow>[
                          for (var invoices in _invList)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  (++i).toString(),
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  invoices.invNo,
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  invoices.invDate,
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  invoices.invDueDate,
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  invoices.anchor,
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  formatCurrency(invoices.invAmt),
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(statusShow(invoices)),
                                DataCell(ViewAction(invoices)),
                              ],
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
        });
  }

  Widget statusShow(InvoiceModel invoices) {
    String _text = 'Pending';
    TextStyle textStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: HexColor("#333333"));

    if (invoices.invStatus == '1') {
      _text = "Not Presented";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#828282"));
    }
    if (invoices.invStatus == '2' && invoices.ilcStatus == '1') {
      _text = "Pending";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#F2994A"));
    }
    if (invoices.discount_status == 'false' &&
        invoices.payment_status == '0' &&
        invoices.ilcStatus == '2') {
      _text = "Live";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#219653"));
    }
    if (invoices.invStatus == '4') {
      _text = "Rejected";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#EB5757"));
    }
    if (invoices.discount_status == 'true') {
      _text = "Sold";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#EB5757"));
    }
    return Text(
      _text,
      style: textStyle,
    );
  }

  Widget mobileViewList(BuildContext context, List<InvoiceModel> invList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //   borderRadius : BorderRadius.only(
      //     topLeft: Radius.circular(25),
      //     topRight: Radius.circular(25),
      //     bottomLeft: Radius.circular(25),
      //     bottomRight: Radius.circular(25),
      //   ),
      //   boxShadow : [BoxShadow(
      //       color: Color.fromRGBO(0, 0, 0, 0.15000000596046448),
      //       offset: Offset(0,2),
      //       blurRadius: 4
      //   )],
      //   color : Color.fromRGBO(255, 255, 255, 1),
      // ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var invoices in invList)
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Color.fromRGBO(245, 251, 255, 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: InkWell(
                      onTap: () {
                        Beamer.of(context).beamToNamed('/viewInvoice/' +
                            Uri.encodeComponent(invoices.invNo));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    invoices.invNo,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        // fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    invoices.anchor,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        // fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    formatCurrency(invoices.invAmt),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  SizedBox(height: 8),
                                  statusShow(invoices),
                                  // Text(
                                  //   // invoices.invDate,
                                  //   statusShow(invoices),
                                  //   textAlign: TextAlign.right,
                                  //   style: TextStyle(
                                  //       color: Color.fromRGBO(33, 150, 83, 1),
                                  //       // fontFamily: 'Poppins',
                                  //       fontSize: 14,
                                  //       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  //       fontWeight: FontWeight.normal,
                                  //       height: 1),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViewAction extends StatelessWidget {
  final InvoiceModel invoices;

  const ViewAction(this.invoices, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'One';
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);

    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: HexColor("#828282"),
        ),
        onSelected: (menu) async {
          if (menu == 1) {
            Beamer.of(context).beamToNamed(
                '/viewInvoice/' + Uri.encodeComponent(invoices.invNo));
          } else if (menu == 2) {
            showToast("Please wait...", context, type: "info");
            dynamic _data = await callApi('dashboard/a/getInvFile',
                body: {'fName': invoices.fileType});
            if (_data['res'] == 'success') {
              var url = _data['data']['url'];
              invoiceProvider.downloadFile(url);
            } else {}
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("View"),
                value: 1,
              ),
              PopupMenuItem(
                child: Text("Download"),
                value: 2,
              )
            ]

        // child: Image.asset("assets/icons/dot_menu.png",width: 24,height: 24,),
        );
  }
}

// class InvoiceListMode{
//   String invNo;
//   String
// }
