import 'dart:convert';

import 'package:capsa/anchor/DialogBoxes/invoiceDialogWindow.dart';
import 'package:capsa/anchor/Invoice%20Builder/add_invoice_anchor.dart';
import 'package:capsa/anchor/Invoice%20Builder/select_invoice_upload_type.dart';
import 'package:capsa/anchor/Invoice/invoices.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/main.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:csv/csv.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Helpers/dialogHelper.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:intl/intl.dart';

import '../../widgets/TopBarWidget.dart';
import '../anchor_home.dart';
import '../provider/anchor_invoice_provider.dart';
import 'edit_invoice_anchor.dart';
import 'package:http/http.dart' as http;

class UploadedInvoiceScreen extends StatefulWidget {
  const UploadedInvoiceScreen({Key key}) : super(key: key);

  @override
  _UploadedInvoiceScreenState createState() => _UploadedInvoiceScreenState();
}

class _UploadedInvoiceScreenState extends State<UploadedInvoiceScreen> {
  void functionStateChange() {
    capsaPrint('functionStateChange call');
    setState(() {
      getData(context);
    });
  }

  bool stringToBool(String s) {
    return s == '1' ? true : false;
  }

  List<TableRow> rows = [];
  bool _dataLoaded = false;
  bool _dataEmpty = false;
  bool isSuperAdmin = false;
  bool hasEditPermission = false;
  bool hasARPermission = false;
  var _numberOfPages;
  var _currentIndex;
  var anchorsActions;
  List<UploadedInvoiceData> _acctTable = [];
  List<UploadedInvoiceData> _fetchedAcctTable = [];
  String selectedType = 'pending';

  var userData;
  String search = "";

  String plan = '';

  // void createCSV(){
  //   // final find = ',';
  //   // final replaceWith = '';
  //   List<List<dynamic>> csv_rows = [];
  //   csv_rows.add(["S/N", "Invoice No.", "Vendor Name", "Issue Date", "Invoice Amount (in Naira)", "Due Date","Tenure"]);
  //   for (int i = 0; i < _acctTable.length; i++) {
  //     List<dynamic> row = [];
  //     row.add((i + 1).toString());
  //     row.add(_acctTable[i].invNo.toString());
  //     row.add(_acctTable[i].vendor.toString());
  //     row.add(_acctTable[i].invDate.toString());
  //     row.add(formatCurrency(_acctTable[i].invAmt));
  //     row.add(_acctTable[i].invDueDate.toString());
  //     row.add(_acctTable[i].tenure.toString());
  //     csv_rows.add(row);
  //   }
  //   String dataAsCSV = const ListToCsvConverter().convert(
  //     csv_rows,
  //   );
  //   exportToCSV(dataAsCSV, fName: "Pending Invoice");
  // }

  Future<Object> delete(UploadedInvoiceData invoiceData) async {
    dynamic _body = {};

    var userData = Map<String, dynamic>.from(box.get('userData'));

    dynamic _uri;
    String _url = apiUrl + 'dashboard/a/';

    _body = {

      'invoice_number' : invoiceData.invNo

    };

    _uri = _url + 'invoiceDeleteAnchor';
    capsaPrint('request approval 3');
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);

    // _uri = apiUrl + 'dashboard/a/' + 'approve';
    // capsaPrint('request approval 3');
    // _uri = Uri.parse(_uri);
    // response = await http.post(_uri,
    //     headers: <String, String>{
    //       'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
    //     },
    //     body: approveBody);
    data = jsonDecode(response.body);

    return data;
  }

  void refreshList(){
    setState(() {
      _dataLoaded = false;
    });
    _fetchedAcctTable = [];
    getData(context);

  }

  void getData(BuildContext context) async {
    rows = [];
    capsaPrint('get data pass 1');
    rows.add(TableRow(children: [
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text('S/N',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text('Invoice No',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text('Vendor Name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text('Issue Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text('Invoice Amount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text('Due Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text('Tenure',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text(' ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      )
    ]));

    capsaPrint('get data pass 2');

    AnchorActionProvider anchorsActions = Provider.of<AnchorActionProvider>(context, listen: false);
    if (_fetchedAcctTable.isEmpty) {
      _fetchedAcctTable =
          await anchorsActions.queryUploadedInvoiceList(type: selectedType);
    }
    capsaPrint('get data pass 3');
    _acctTable = anchorsActions.searchDataUploadedInvoice(
        _fetchedAcctTable, search, context);

    _acctTable = _fetchedAcctTable;

    if (box.get('isAuthenticated', defaultValue: false)) {
      userData = Map<String, dynamic>.from(await box.get('userData'));
    }

    isSuperAdmin = stringToBool(userData['isSubAdmin'].toString());
    hasEditPermission = stringToBool(
        userData['sub_admin_details']['roleEditInvoice'].toString());
    hasARPermission = stringToBool(
        userData['sub_admin_details']['roleAandRInvoice'].toString());

    //anchorsActions.removeAdmin();
    // anchorsActions.getAllAdmins();
    capsaPrint('get data pass 4');
    var limit = 10 < _acctTable.length ? 10 : _acctTable.length;
    capsaPrint('get data pass 5');
    for (int i = 0; i < limit; i++) {
      rows.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text((i + 1).toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(_acctTable[i].invNo.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(_acctTable[i].vendor.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(_acctTable[i].issueDate.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text("₦ " + formatCurrency(_acctTable[i].amt),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(_acctTable[i].dueDate.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(_acctTable[i].tenure.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  EditInvoiceAnchor(invoice: _acctTable[i])))
                          .then((value) {
                            refreshList();
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        RichText(
                          text: TextSpan(
                            text: 'Edit',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      bool processing = false;

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context1) =>
                              StatefulBuilder(builder:
                                  (context1,
                                  setState) {
                                return processing
                                    ? AlertDialog(
                                  // title: Text(
                                  //   '',
                                  //   style: TextStyle(
                                  //     fontSize: 24,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Theme.of(context).primaryColor,
                                  //   ),
                                  // ),
                                  content:
                                  Padding(
                                    padding: const EdgeInsets
                                        .all(
                                        12.0),
                                    child: Container(
                                        height: 50,
                                        //width: 50,
                                        child: Container(
                                            height:
                                            50,
                                            width:
                                            50,
                                            child:
                                            CircularProgressIndicator())),
                                  ),
                                  //actions: <Widget>[],
                                )
                                    : AlertDialog(
                                  // title: Text(
                                  //   '',
                                  //   style: TextStyle(
                                  //     fontSize: 24,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Theme.of(context).primaryColor,
                                  //   ),
                                  // ),
                                  content:
                                  Container(
                                    // width: 800,
                                      height: Responsive.isMobile(context)
                                          ? 340
                                          : 300,
                                      child:
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(16.0),
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              'Delete Invoice',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              'Do you want to delete this invoice?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      processing = true;
                                                    });
                                                    // showToast(
                                                    //     'Please Wait!',
                                                    //     context,
                                                    //     type: 'warning');
                                                    dynamic res = await delete(_acctTable[i]);
                                                    capsaPrint('Response delete $res');
                                                    if (res['res'] == 'success') {
                                                      Navigator.pop(context1);
                                                      showToast('Invoice Deleted Successfully', context);
                                                      refreshList();
                                                    } else {
                                                      Navigator.pop(context1);
                                                      showToast('Something Went Wrong', context, type: 'warning');
                                                      refreshList();
                                                    }
                                                  },
                                                  child: Container(
                                                    width: Responsive.isMobile(context) ? 140 : 220,
                                                    decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context1);
                                                  },
                                                  child: Container(
                                                    width: Responsive.isMobile(context) ? 140 : 220,
                                                    decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                  //actions: <Widget>[],
                                );
                              })).then((value) {
                        setState(() {});
                      });

                      // Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             ));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.delete),
                        RichText(
                          text: const TextSpan(
                            text: 'Delete Invoice',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w400,
                                color: Color.fromRGBO(
                                    51, 51, 51, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              ],
            )),
      ]));
    }

    capsaPrint('get data pass 6');

    // if(limit<10){
    //   for(int i = 0;i<10-limit;i++)
    //     rows.add(blankRow);
    // }

    if (_acctTable.length == 0) {
      _dataEmpty = true;
    }

    if (_acctTable.length % 10 == 0) {
      _numberOfPages = (_acctTable.length / 10).toInt();
    } else {
      _numberOfPages = (_acctTable.length / 10 + 1).floor();
    }

    _currentIndex = 1;

    setState(() {
      _dataLoaded = true;
    });
  }

  void _nextPage() {
    if (_currentIndex < _numberOfPages) {
      setState(() {
        _dataLoaded = false;
      });
      rows = [];
      rows.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: const Text('S/N',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: const Text('Invoice No',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: const Text('Vendor Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: const Text('Issue Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: const Text('Invoice Amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: const Text('Due Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: const Text('Tenure',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: const Text(' ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        )
      ]));
      _currentIndex++;
      int limit = 10 < (_acctTable.length - (_currentIndex - 1) * 10)
          ? 10
          : (_acctTable.length - (_currentIndex - 1) * 10);

      for (int i = (_currentIndex - 1) * 10;
          i < ((_currentIndex - 1) * 10) + limit;
          i++) {
        rows.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text((i + 1).toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].invNo.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].vendor.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].issueDate.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].amt.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].dueDate.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].tenure.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                            builder: (context) =>
                                EditInvoiceAnchor(invoice: _acctTable[i])))
                            .then((value) {
                          refreshList();
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          RichText(
                            text: TextSpan(
                              text: 'Edit',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(51, 51, 51, 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        bool processing = false;

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context1) =>
                                StatefulBuilder(builder:
                                    (context1,
                                    setState) {
                                  return processing
                                      ? AlertDialog(
                                    // title: Text(
                                    //   '',
                                    //   style: TextStyle(
                                    //     fontSize: 24,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Theme.of(context).primaryColor,
                                    //   ),
                                    // ),
                                    content:
                                    Padding(
                                      padding: const EdgeInsets
                                          .all(
                                          12.0),
                                      child: Container(
                                          height: 50,
                                          //width: 50,
                                          child: Container(
                                              height:
                                              50,
                                              width:
                                              50,
                                              child:
                                              CircularProgressIndicator())),
                                    ),
                                    //actions: <Widget>[],
                                  )
                                      : AlertDialog(
                                    // title: Text(
                                    //   '',
                                    //   style: TextStyle(
                                    //     fontSize: 24,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Theme.of(context).primaryColor,
                                    //   ),
                                    // ),
                                    content:
                                    Container(
                                      // width: 800,
                                        height: Responsive.isMobile(context)
                                            ? 340
                                            : 300,
                                        child:
                                        Padding(
                                          padding:
                                          const EdgeInsets.all(16.0),
                                          child:
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Delete Invoice',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Do you want to delete this invoice?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        processing = true;
                                                      });
                                                      // showToast(
                                                      //     'Please Wait!',
                                                      //     context,
                                                      //     type: 'warning');
                                                      dynamic res = await delete(_acctTable[i]);
                                                      capsaPrint('Response delete $res');
                                                      if (res['res'] == 'success') {
                                                        Navigator.pop(context1);
                                                        showToast('Approved Successfully', context);
                                                        refreshList();
                                                      } else {
                                                        Navigator.pop(context1);
                                                        showToast('Something Went Wrong', context, type: 'warning');
                                                        refreshList();
                                                      }
                                                    },
                                                    child: Container(
                                                      width: Responsive.isMobile(context) ? 140 : 220,
                                                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(12.0),
                                                          child: Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context1);
                                                    },
                                                    child: Container(
                                                      width: Responsive.isMobile(context) ? 140 : 220,
                                                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(12.0),
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                    //actions: <Widget>[],
                                  );
                                })).then((value) {
                          setState(() {});
                        });

                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             ));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.delete),
                          RichText(
                            text: const TextSpan(
                              text: 'Delete Invoice',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.w400,
                                  color: Color.fromRGBO(
                                      51, 51, 51, 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              )),
        ]));
      }
      setState(() {
        _dataLoaded = true;
      });
    }
  }

  void _previousPage() {
    if (_currentIndex > 1) {
      setState(() {
        _dataLoaded = false;
      });
      rows = [];
      rows.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text('S/N',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text('Invoice No',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text('Vendor Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text('Issue Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text('Invoice Amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text('Due Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text('Tenure',
              style: TextStyle(
                fontSize: 18,
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
      _currentIndex--;
      for (int i = (_currentIndex - 1) * 10;
          i < ((_currentIndex - 1) * 10) + 10;
          i++) {
        rows.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text((i + 1).toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].invNo.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].vendor.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].issueDate.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].amt.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].dueDate.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_acctTable[i].tenure.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                            builder: (context) =>
                                EditInvoiceAnchor(invoice: _acctTable[i])))
                            .then((value) {
                          refreshList();
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          RichText(
                            text: TextSpan(
                              text: 'Edit',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(51, 51, 51, 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        bool processing = false;

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context1) =>
                                StatefulBuilder(builder:
                                    (context1,
                                    setState) {
                                  return processing
                                      ? AlertDialog(
                                    // title: Text(
                                    //   '',
                                    //   style: TextStyle(
                                    //     fontSize: 24,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Theme.of(context).primaryColor,
                                    //   ),
                                    // ),
                                    content:
                                    Padding(
                                      padding: const EdgeInsets
                                          .all(
                                          12.0),
                                      child: Container(
                                          height: 50,
                                          //width: 50,
                                          child: Container(
                                              height:
                                              50,
                                              width:
                                              50,
                                              child:
                                              CircularProgressIndicator())),
                                    ),
                                    //actions: <Widget>[],
                                  )
                                      : AlertDialog(
                                    // title: Text(
                                    //   '',
                                    //   style: TextStyle(
                                    //     fontSize: 24,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Theme.of(context).primaryColor,
                                    //   ),
                                    // ),
                                    content:
                                    Container(
                                      // width: 800,
                                        height: Responsive.isMobile(context)
                                            ? 340
                                            : 300,
                                        child:
                                        Padding(
                                          padding:
                                          const EdgeInsets.all(16.0),
                                          child:
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Delete Invoice',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Do you want to delete this invoice?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        processing = true;
                                                      });
                                                      // showToast(
                                                      //     'Please Wait!',
                                                      //     context,
                                                      //     type: 'warning');
                                                      dynamic res = await delete(_acctTable[i]);
                                                      capsaPrint('Response delete $res');
                                                      if (res['res'] == 'success') {
                                                        Navigator.pop(context1);
                                                        showToast('Approved Successfully', context);
                                                        refreshList();

                                                      } else {
                                                        Navigator.pop(context1);
                                                        showToast('Something Went Wrong', context, type: 'warning');
                                                        refreshList();
                                                      }
                                                    },
                                                    child: Container(
                                                      width: Responsive.isMobile(context) ? 140 : 220,
                                                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(12.0),
                                                          child: Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context1);
                                                    },
                                                    child: Container(
                                                      width: Responsive.isMobile(context) ? 140 : 220,
                                                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(12.0),
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                    //actions: <Widget>[],
                                  );
                                })).then((value) {
                          setState(() {});
                        });

                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             ));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.delete),
                          RichText(
                            text: const TextSpan(
                              text: 'Delete Invoice',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.w400,
                                  color: Color.fromRGBO(
                                      51, 51, 51, 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              )),
        ]));
      }
      setState(() {
        _dataLoaded = true;
      });
    }
  }

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getData(context);
  }

  @override
  Widget build(BuildContext context) {
    //capsaPrint('\n\n User Data 2: ${userData['sub_admin_details']['roleEditInvoice']} details: ${userData['sub_admin_details']} \n\n\n');
    //int selectedIndex = 0;
    return Container(
      width: MediaQuery.of(context).size.width + 130,
      height: MediaQuery.of(context).size.height * 1.2,
      child: _dataLoaded
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 22,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TopBarWidget("Uploaded Invoices", "View the details of all invoices uploaded"),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(29, 38, 24, 26),
                          child: Text(
                            'Uploaded Invoices',
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 58, 24, 58),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.notifications_none),
                            ),
                          ),
                          Image.asset(
                            'images/5982.png',
                            width: 60,
                            height: 60,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: (!Responsive.isMobile(context)) ? 8 : 15,
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       InkWell(
                  //           onTap: () {
                  //
                  //             _fetchedAcctTable = [];
                  //             selectedType = 'pending';
                  //             getData(context);
                  //
                  //             _dataLoaded = false;
                  //
                  //             setState(() {
                  //               selectedIndex = 0;
                  //
                  //             });
                  //             capsaPrint('pendong pressed');
                  //           },
                  //           child: Text(
                  //             'Pending',
                  //             style: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 24,
                  //                 color: selectedIndex == 0 ? HexColor('#0098DB') : Colors.black),
                  //           )),
                  //
                  //       InkWell(
                  //           onTap: () {
                  //
                  //             _fetchedAcctTable = [];
                  //             selectedType = 'approved';
                  //             getData(context);
                  //
                  //             capsaPrint('approved pressed');
                  //             _dataLoaded = false;
                  //             selectedIndex = 1;
                  //
                  //             setState(() {
                  //
                  //
                  //             });
                  //           },
                  //           child: Text(
                  //             'Approved',
                  //             style: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 24,
                  //                 color: selectedIndex == 1 ? HexColor('#0098DB') : Colors.black),
                  //           )),
                  //
                  //       InkWell(
                  //           onTap: () {
                  //
                  //             _fetchedAcctTable = [];
                  //             selectedType = 'closed';
                  //             getData(context);
                  //
                  //             capsaPrint('closed pressed');
                  //             _dataLoaded = false;
                  //             selectedIndex = 2;
                  //
                  //             setState(() {
                  //
                  //
                  //             });
                  //           },
                  //           child: Text(
                  //             'Rejected',
                  //             style: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 24,
                  //                 color: selectedIndex == 2 ? HexColor('#0098DB') : Colors.black),
                  //           )),
                  //       // InkWell(
                  //       //     onTap: () {
                  //       //
                  //       //       _fetchedAcctTable = [];
                  //       //       selectedType = 'cancelled';
                  //       //       getData(context);
                  //       //       _dataLoaded = false;
                  //       //       selectedIndex = 2;
                  //       //
                  //       //       setState(() {
                  //       //
                  //       //
                  //       //       });
                  //       //     },
                  //       //     child: Text(
                  //       //       'Cancelled',
                  //       //       style: GoogleFonts.poppins(
                  //       //           fontWeight: FontWeight.w600,
                  //       //           fontSize: 24,
                  //       //           color: selectedIndex == 2 ? HexColor('#0098DB') : Colors.black),
                  //       //     )),
                  //     ],
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(29, 0, 36, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.12,
                      child: Card(
                        shadowColor: Colors.black,
                        color: Color.fromRGBO(245, 251, 255, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 250.33, 16),
                              child: TextButton(
                                child: Text('Pending',
                                    style: selectedIndex == 0
                                        ? TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(0, 152, 219, 1),
                                          )
                                        : TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                130, 130, 130, 1),
                                          )),
                                onPressed: () {
                                  _fetchedAcctTable = [];
                                  selectedType = 'pending';
                                  getData(context);

                                  capsaPrint('closed pressed');
                                  _dataLoaded = false;
                                  selectedIndex = 0;

                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 16, 250.33, 16),
                              child: TextButton(
                                child: Text('Approved',
                                    style: selectedIndex == 1
                                        ? TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(0, 152, 219, 1),
                                          )
                                        : TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                130, 130, 130, 1),
                                          )),
                                onPressed: () {
                                  _fetchedAcctTable = [];
                                  selectedType = 'approved';
                                  getData(context);

                                  capsaPrint('closed pressed');
                                  _dataLoaded = false;
                                  selectedIndex = 1;

                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              child: TextButton(
                                child: Text('Closed',
                                    style: selectedIndex == 2
                                        ? TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(0, 152, 219, 1),
                                          )
                                        : TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                130, 130, 130, 1),
                                          )),
                                onPressed: () {
                                  _fetchedAcctTable = [];
                                  selectedType = 'closed';
                                  getData(context);

                                  capsaPrint('closed pressed');
                                  _dataLoaded = false;
                                  selectedIndex = 2;

                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  !_dataEmpty
                      ? Container(
                          // padding: EdgeInsets.all((!Responsive.isMobile(context)) ? 12 : 1.0),
                          // color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  // width: 200,
                                  height:
                                      (!Responsive.isMobile(context)) ? 65 : 60,
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
                                          // type
                                          capsaPrint('Search Tapped $search');
                                          getData(context);
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
                                          color:
                                              Color.fromRGBO(130, 130, 130, 1),
                                          fontFamily: 'Poppins',
                                          fontSize:
                                              (!Responsive.isMobile(context))
                                                  ? 18
                                                  : 15,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                      hintText: Responsive.isMobile(context)
                                          ? "Search by invoice number"
                                          : "Search by invoice number, Anchor name",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MultiProvider(
                                              providers: [
                                                ChangeNotifierProvider<
                                                    AnchorActionProvider>(
                                                  create: (_) =>
                                                      AnchorActionProvider(),
                                                ),
                                                ChangeNotifierProvider<
                                                    AnchorInvoiceProvider>(
                                                  create: (_) =>
                                                      AnchorInvoiceProvider(),
                                                ),
                                              ],
                                              child: SelectInvoiceUploadType(),
                                            )),
                                  ).then((value) {});

                                  _fetchedAcctTable = [];
                                  setState(() {
                                    _dataLoaded = false;
                                  });
                                  getData(context);
                                },
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Upload Invoice',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            // fontFamily: 'Poppins',
                                            fontSize: 22,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.normal,
                                            height: 1),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.upload,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Card(
                    margin: EdgeInsets.fromLTRB(29, 24, 36, 33),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: _dataEmpty
                        ? Column(
                          children: [

                            InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider<
                                              AnchorActionProvider>(
                                            create: (_) =>
                                                AnchorActionProvider(),
                                          ),
                                          ChangeNotifierProvider<
                                              AnchorInvoiceProvider>(
                                            create: (_) =>
                                                AnchorInvoiceProvider(),
                                          ),
                                        ],
                                        child: SelectInvoiceUploadType(),
                                      )),
                                ).then((value) {});

                                _fetchedAcctTable = [];
                                setState(() {
                                  _dataLoaded = false;
                                });
                                getData(context);
                              },
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Upload Invoice',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          // fontFamily: 'Poppins',
                                          fontSize: 22,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(
                                    Icons.upload,
                                  ),
                                ],
                              ),
                            ),

                            Center(
                                child: Text(
                                  'No $selectedType Invoices',
                                  style: GoogleFonts.poppins(fontSize: 28),
                                ),
                              ),
                          ],
                        )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  columnWidths: {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(5),
                                    2: FlexColumnWidth(5),
                                    3: FlexColumnWidth(3),
                                    4: FlexColumnWidth(3.5),
                                    5: FlexColumnWidth(3),
                                    6: FlexColumnWidth(1.5),
                                    7: FlexColumnWidth(1)
                                  },
                                  border: TableBorder(
                                      verticalInside: BorderSide.none),
                                  children: rows,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(900, 10, 15, 16),
                                child: Card(
                                  color: Color.fromRGBO(245, 251, 255, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    width: 290,
                                    height: 56,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              24, 17.5, 24, 17.5),
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
                                            '$_currentIndex of $_numberOfPages',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    51, 51, 51, 1)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 22, 30, 22),
                                          child: IconButton(
                                              onPressed: () {
                                                _previousPage();
                                              },
                                              icon: Icon(Icons.arrow_back_ios),
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
                                                _nextPage();
                                              },
                                              icon:
                                                  Icon(Icons.arrow_forward_ios),
                                              iconSize: 14,
                                              color: Color.fromRGBO(
                                                  130, 130, 130, 1),
                                              padding: EdgeInsets.all(0)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class SuperAdminContainerView extends StatefulWidget {
  final UploadedInvoiceData invoice;
  final AnchorActionProvider invoiceProvider;
  final Function functionStateChange;
  final String plan;

  SuperAdminContainerView(
      this.invoice, this.invoiceProvider, this.functionStateChange, this.plan,
      {Key key})
      : super(key: key);

  @override
  State<SuperAdminContainerView> createState() =>
      _SuperAdminContainerViewState();
}

class _SuperAdminContainerViewState extends State<SuperAdminContainerView> {
  UploadedInvoiceData invoice;
  AnchorActionProvider _invoiceProvider;

  var urlDownload = "";

  DateTime date;
  TextEditingController effDueDateCont;
  TextEditingController rejectReasonCont;
  TextEditingController payableAmountCont;
  TextEditingController percentageController = TextEditingController(text: '');

  bool amountReadOnly = true;

  String checkBoxValue = 'no';
  bool checkBoxBool = false;

  _selectEffDueDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: date,
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
      date = newSelectedDate;
      effDueDateCont
        ..text = DateFormat.yMMMd().format(date)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: effDueDateCont.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
    _invoiceProvider = widget.invoiceProvider;

    // capsaPrint(
    //     'Date: ${DateFormat('yyyy-MM-dd').format(widget.invoice.invDueDateO)}  ${widget.invoice.invDueDate}');

    effDueDateCont = TextEditingController(text: widget.invoice.dueDate);
    payableAmountCont = TextEditingController(text: widget.invoice.amt);
    capsaPrint('date : ${widget.invoice.issueDate}');
    date = DateFormat('d MMM, y').parse(widget.invoice.issueDate);
  }

  @override
  void dispose() {
    payableAmountCont.dispose();
    effDueDateCont.dispose();
    super.dispose();
  }

  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(32))),
      width: MediaQuery.of(context).size.width * 0.6,
      // height: MediaQuery.of(context).size.height * 0.8 ,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Invoice',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: 14,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.invoice.invNo,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 152, 219, 1),
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 40),
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Status',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: 14,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Approved',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(242, 153, 74, 1),
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: UserTextFormField(
                        label: "Effective Due Date",
                        hintText: "",
                        action: 'Edit',
                        controller: effDueDateCont,
                        readOnly: true,
                        // onTap: () {
                        //   return _selectEffDueDate(context);
                        // },
                        onActionTap: () {
                          return _selectEffDueDate(context);
                        },
                        padding: EdgeInsets.zero,
                        fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                        errorText:
                            "Date on which you are going to pay the vendor.\nIf this is not correct, please change.",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (widget.plan == 'a')
                      Container(
                        child: UserTextFormField(
                          label: "Percentage Discount",
                          // action: 'Edit',
                          // onActionTap: () {
                          //   setState(() {
                          //     amountReadOnly = false;
                          //   });
                          // },
                          readOnly: false,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          controller: percentageController,
                          inputFormatters: [
                            //ThousandsFormatter(),
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              try {
                                final text = newValue.text;
                                if (text.isNotEmpty) double.parse(text);
                                return newValue;
                              } catch (e) {}
                              return oldValue;
                            }),
                          ],
                          prefixIcon: Icon(Icons.percent),
                          hintText: "Enter a percentage",
                          padding: EdgeInsets.zero,
                          fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                          // errorText:
                          // "Amount you are going to pay the vendor. If this is not correct, please change.",
                        ),
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    if (widget.plan == 'a')
                      Row(
                        children: [
                          Checkbox(
                            value: checkBoxBool,
                            onChanged: (bool value) {
                              setState(() {
                                checkBoxBool = value;
                              });
                              value ? checkBoxValue = 'yes' : 'no';
                            },
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text('Save this option for this vendor')
                        ],
                      ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: UserTextFormField(
                        label: "Payable Amount",
                        action: 'Edit',
                        onActionTap: () {
                          setState(() {
                            amountReadOnly = false;
                          });
                        },
                        readOnly: amountReadOnly,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: payableAmountCont,
                        inputFormatters: [
                          //ThousandsFormatter(),
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            try {
                              final text = newValue.text;
                              if (text.isNotEmpty) double.parse(text);
                              return newValue;
                            } catch (e) {}
                            return oldValue;
                          }),
                        ],
                        hintText: "",
                        padding: EdgeInsets.zero,
                        fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                        errorText:
                            "Amount you are going to pay the vendor. If this is not correct, please change.",
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    if (!_loading)
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  capsaPrint('Approve Call22');

                                  setState(() {
                                    _loading = true;
                                  });

                                  // return;

                                  capsaPrint(
                                      'update ivoice values -  ${widget.invoice.invNo}  ${widget.plan} ${checkBoxValue} ');

                                  var userData = Map<String, dynamic>.from(
                                      box.get('tmpUserData'));

                                  // dynamic _body = {
                                  //   "vendorPAN": widget.invoice.companyPan,
                                  //   "anchorPAN": userData['panNumber'],
                                  //   'plan': widget.plan
                                  // };
                                  //
                                  // dynamic savePlan = await callApi(
                                  //     'dashboard/a/updatePlan',
                                  //     body: _body);
                                  //
                                  // dynamic _data =
                                  //     await _invoiceProvider.updateInvoice(
                                  //         widget.invoice.invNo,
                                  //         DateFormat('yyyy-MM-dd').format(date),
                                  //         payableAmountCont.text,
                                  //         widget.plan,
                                  //         checkBoxValue,
                                  //         percentageController.text ?? '');
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => CapsaApp(),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color.fromRGBO(0, 152, 219, 1),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Text(
                                    'Save',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(242, 242, 242, 1),
                                        fontSize: 18,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  capsaPrint('Approve Call12');

                                  setState(() {
                                    _loading = true;
                                  });

                                  // return;
                                  // var userData = Map<String, dynamic>.from(
                                  //     box.get('tmpUserData'));
                                  //
                                  // dynamic _body = {
                                  //   "vendorPAN": widget.invoice.companyPan,
                                  //   "anchorPAN": userData['panNumber'],
                                  //   'plan': widget.plan
                                  // };
                                  //
                                  // dynamic savePlan = await callApi(
                                  //     'dashboard/a/updatePlan',
                                  //     body: _body);
                                  //
                                  // dynamic _data =
                                  //     await _invoiceProvider.approve(
                                  //         date.toString(),
                                  //         effDueDateCont.text,
                                  //         payableAmountCont.text,
                                  //         widget.invoice,
                                  //         widget.plan,
                                  //         checkBoxValue,
                                  //         percentageController.text ?? '');
                                  //
                                  // if (_data['res'] == 'success') {
                                  //   // setState(() {
                                  //   //
                                  //   // });
                                  //
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //       content: Text('Successfully Approved.'),
                                  //       action: SnackBarAction(
                                  //         label: 'Ok',
                                  //         onPressed: () {
                                  //           // Code to execute.
                                  //         },
                                  //       ),
                                  //     ),
                                  //   );
                                  //   widget.functionStateChange();
                                  //   Navigator.of(context).pushReplacement(
                                  //       MaterialPageRoute(
                                  //           builder: (context) => CapsaHome()));
                                  //   //Navigator.pop(context);
                                  // }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: HexColor('#219653'),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: const Text(
                                    'Save and Approve',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(242, 242, 242, 1),
                                        fontSize: 18,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  capsaPrint('Reject x');
                                  setState(() {
                                    _loading = true;
                                  });
                                  // return;
                                  // var userData = Map<String, dynamic>.from(
                                  //     box.get('tmpUserData'));
                                  //
                                  // dynamic _body = {
                                  //   "vendorPAN": widget.invoice.companyPan,
                                  //   "anchorPAN": userData['panNumber'],
                                  //   'plan': widget.plan
                                  // };
                                  //
                                  // dynamic savePlan = await callApi(
                                  //     'dashboard/a/updatePlan',
                                  //     body: _body);
                                  //
                                  // dynamic _data = await _invoiceProvider.reject(
                                  //     widget.invoice,
                                  //     widget.plan,
                                  //     checkBoxValue,
                                  //     percentageController.text ?? '');
                                  //
                                  // if (_data['res'] == 'success') {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //       content: const Text(
                                  //           'Successfully Rejected.'),
                                  //       action: SnackBarAction(
                                  //         label: 'Ok',
                                  //         onPressed: () {
                                  //           // Code to execute.
                                  //         },
                                  //       ),
                                  //     ),
                                  //   );
                                  //
                                  //   // Navigator.of(context, rootNavigator: true).pop();
                                  //
                                  //   widget.functionStateChange();
                                  //   Navigator.of(context).pushReplacement(
                                  //       MaterialPageRoute(
                                  //           builder: (context) => CapsaHome()));
                                  // } else {
                                  //   showToast('Unable to proceed', context);
                                  // }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color.fromRGBO(235, 87, 87, 1),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: const Text(
                                    'Reject',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(242, 242, 242, 1),
                                        fontSize: 18,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubAdminInvoiceContainerView extends StatefulWidget {
  final AcctTableData invoice;
  final AnchorActionProvider invoiceProvider;
  final Function functionStateChange;
  var userData;
  final String plan;

  SubAdminInvoiceContainerView(this.invoice, this.invoiceProvider,
      this.functionStateChange, @required this.userData, this.plan,
      {Key key})
      : super(key: key);

  @override
  State<SubAdminInvoiceContainerView> createState() =>
      _SubAdminInvoiceContainerViewState();
}

class _SubAdminInvoiceContainerViewState
    extends State<SubAdminInvoiceContainerView> {
  AcctTableData invoice;
  AnchorActionProvider _invoiceProvider;

  var urlDownload = "";

  DateTime date;
  TextEditingController effDueDateCont;
  TextEditingController rejectReasonCont;
  TextEditingController payableAmountCont;

  TextEditingController percentageController;

  bool amountReadOnly = true;

  String checkBoxValue = 'no';
  bool checkBoxBool = false;

  _selectEffDueDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: date,
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
      date = newSelectedDate;
      effDueDateCont
        ..text = DateFormat.yMMMd().format(date)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: effDueDateCont.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
    _invoiceProvider = widget.invoiceProvider;

    effDueDateCont = TextEditingController(text: widget.invoice.invDueDate);
    payableAmountCont = TextEditingController(text: widget.invoice.invAmt);
    date = widget.invoice.invDueDateO;
  }

  @override
  void dispose() {
    payableAmountCont.dispose();
    effDueDateCont.dispose();
    super.dispose();
  }

  var _loading = false;

  @override
  Widget build(BuildContext context) {
    String editInvoice =
        widget.userData['sub_admin_details']['roleEditInvoice'].toString();
    String approveInvoice =
        widget.userData['sub_admin_details']['roleAandRInvoice'].toString();

    return Container(
      // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(32))),
      width: MediaQuery.of(context).size.width * 0.6,
      // height: MediaQuery.of(context).size.height * 0.8 ,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'Invoice',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: 14,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.invoice.invNo,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 152, 219, 1),
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 40),
                          Container(
                            decoration: BoxDecoration(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'Status',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: 14,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.invoice.status == '2'
                                      ? 'Approved'
                                      : widget.invoice.status == '1'
                                          ? 'Pending'
                                          : 'Rejected',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(242, 153, 74, 1),
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: UserTextFormField(
                        label: "Effective Due Date",
                        hintText: "",
                        action: editInvoice == '1' ? 'Edit' : '',
                        controller: effDueDateCont,
                        readOnly: true,
                        onActionTap: () {
                          return editInvoice == '1'
                              ? _selectEffDueDate(context)
                              : null;
                        },
                        padding: EdgeInsets.zero,
                        fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                        errorText: editInvoice == '1'
                            ? "Date on which you are going to pay the vendor.\nIf this is not correct, please change."
                            : "",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: UserTextFormField(
                        label: "Payable Amount",
                        action: editInvoice == '1' ? 'Edit' : '',
                        onActionTap: () {
                          setState(() {
                            amountReadOnly = false;
                          });
                        },
                        readOnly: editInvoice == '0' ? amountReadOnly : false,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: payableAmountCont,
                        inputFormatters: [
                          //ThousandsFormatter(),
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            try {
                              final text = newValue.text;
                              if (text.isNotEmpty) double.parse(text);
                              return newValue;
                            } catch (e) {}
                            return oldValue;
                          }),
                        ],
                        hintText: "",
                        padding: EdgeInsets.zero,
                        fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                        errorText: editInvoice == '1'
                            ? "Amount you are going to pay the vendor. If this is not correct, please change."
                            : "",
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    if (!_loading)
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            editInvoice == '1'
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        capsaPrint('Approve Call13');

                                        setState(() {
                                          _loading = true;
                                        });

                                        // return;

                                        dynamic _data = await _invoiceProvider
                                            .updateInvoice(
                                                widget.invoice.invNo,
                                                DateFormat('yyyy-MM-dd')
                                                    .format(date),
                                                payableAmountCont.text,
                                                widget.plan,
                                                checkBoxValue,
                                                percentageController.text);

                                        widget.functionStateChange();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CapsaHome()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          color: Color.fromRGBO(0, 152, 219, 1),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Text(
                                          'Save',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  242, 242, 242, 1),
                                              fontSize: 18,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            approveInvoice == '1'
                                ? SizedBox(
                                    width: 25,
                                  )
                                : Container(),
                            approveInvoice == '1'
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        capsaPrint('Approve Call14');

                                        setState(() {
                                          _loading = true;
                                        });

                                        // return;

                                        dynamic _data =
                                            await _invoiceProvider.approve(
                                                date.toString(),
                                                effDueDateCont.text,
                                                payableAmountCont.text,
                                                widget.invoice,
                                                widget.plan,
                                                checkBoxValue,
                                                percentageController.text ??
                                                    '');

                                        if (_data['res'] == 'success') {
                                          // setState(() {
                                          //
                                          // });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Successfully Approved.'),
                                              action: SnackBarAction(
                                                label: 'Ok',
                                                onPressed: () {
                                                  // Code to execute.
                                                },
                                              ),
                                            ),
                                          );
                                        }

                                        widget.functionStateChange();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CapsaHome()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          color: HexColor('#219653'),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Text(
                                          editInvoice == '1'
                                              ? 'Save and Approve'
                                              : 'Approve',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  242, 242, 242, 1),
                                              fontSize: 18,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            approveInvoice == '1'
                                ? SizedBox(
                                    width: 25,
                                  )
                                : Container(),
                            approveInvoice == '1'
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        capsaPrint('Reject');
                                        setState(() {
                                          _loading = true;
                                        });
                                        // return;

                                        dynamic _data =
                                            await _invoiceProvider.reject(
                                                widget.invoice,
                                                widget.plan,
                                                checkBoxValue,
                                                percentageController.text ??
                                                    '');

                                        if (_data['res'] == 'success') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Successfully Rejected.'),
                                              action: SnackBarAction(
                                                label: 'Ok',
                                                onPressed: () {
                                                  // Code to execute.
                                                },
                                              ),
                                            ),
                                          );

                                          // Navigator.of(context, rootNavigator: true).pop();

                                          widget.functionStateChange();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CapsaHome()));
                                        } else {
                                          showToast(
                                              'Unable to proceed', context);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          color: Color.fromRGBO(235, 87, 87, 1),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Text(
                                          'Reject',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  242, 242, 242, 1),
                                              fontSize: 18,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    else
                      Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
