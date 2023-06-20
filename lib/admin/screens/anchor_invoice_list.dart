import 'dart:convert';

import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/anchor_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/screens/edit_anchor_invoice_admin.dart';
import 'package:capsa/admin/widgets/anchor_list_card.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/widgets/StatefulWrapper.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../functions/currency_format.dart';
import '../../functions/show_toast.dart';
import '../../widgets/datatable_dynamic.dart';
import '../data/anchor_invoice_data.dart';
import 'package:http/http.dart' as http;

class AnchorInvoiceList extends StatefulWidget {
  final String title;

  const AnchorInvoiceList({Key key, this.title}) : super(key: key);

  @override
  _AnchorInvoiceListState createState() => _AnchorInvoiceListState();
}

class _AnchorInvoiceListState extends State<AnchorInvoiceList> {
  Future<Object> submitForApproval(_body) async {
    // capsaPrint('userData');
    // capsaPrint(userData);

    dynamic _uri;
    String _url = apiUrl + 'dashboard/r/';

    _uri = _url + 'requestApproval';
    capsaPrint('request approval 3');
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> approve(AnchorInvoiceData invoiceData) async {
    dynamic _body = {};

    var userData = Map<String, dynamic>.from(box.get('userData'));

    _body['panNumber'] = invoiceData.vendorPan;
    _body['role'] = 'VENDOR';
    _body['userName'] = invoiceData.vendorName;
    _body['invNum'] = invoiceData.invNo;
    _body['isSplit'] = '0';
    // _body['invNum'] = invoice.invNo;

    dynamic _data = await submitForApproval(_body);

    return _data;
  }

  Future<Object> delete(AnchorInvoiceData invoiceData) async {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Responsive.isMobile(context)
                ? AccountTable()
                : Padding(
                    padding: Responsive.isMobile(context)
                        ? const EdgeInsets.fromLTRB(5, 0, 5, 0)
                        : const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '${widget.title}',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 5 : 30,
                        ),
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).primaryColor,
                            thickness: 0,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 8 : 35,
                        ),
                        Expanded(child: AccountTable()),
                      ],
                    ),
                  ),
          ),
        ));
      }),
    );
  }
}

class AccountTable extends StatefulWidget {
  final String title;

  const AccountTable({Key key, this.title}) : super(key: key);

  @override
  _AccountTableState createState() => _AccountTableState();
}

class _AccountTableState extends State<AccountTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex;
  bool _sortAscending = true;

  TextEditingController searchController = TextEditingController();
  String searchInvoiceText = '';

  Future<Object> submitForApproval(_body, approveBody) async {
    // capsaPrint('userData');
    // capsaPrint(userData);

    dynamic _uri;
    String _url = apiUrl + 'dashboard/r/';

    _uri = _url + 'requestApproval';
    capsaPrint('request approval 3');
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);

    _uri = apiUrl + 'dashboard/a/' + 'approve';
    capsaPrint('request approval 3');
    _uri = Uri.parse(_uri);
    response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: approveBody);
    data = jsonDecode(response.body);

    return data;
  }

  Future<Object> delete(AnchorInvoiceData invoiceData) async {
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

  Future<Object> approve(AnchorInvoiceData invoiceData) async {
    dynamic _body = {};

    var userData = Map<String, dynamic>.from(box.get('userData'));

    _body['panNumber'] = invoiceData.vendorPan;
    _body['role'] = 'VENDOR';
    _body['userName'] = invoiceData.vendorName;
    _body['invNum'] = invoiceData.invNo;
    _body['isSplit'] = '0';
    // _body['invNum'] = invoice.invNo;
    dynamic approveBody = {
      'userName': invoiceData.anchorName,
      'plan': 'v',
      'checked': '',
      'discount_per': '',
      'panNumber': invoiceData.anchorPan,
      'role': 'BUYER',
      'i_amount': invoiceData.invVal,
      'i_date': DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .parse(invoiceData.invDueDate)),
      'inv_num': invoiceData.invNo,
      'inv_date': DateFormat('d MMM, y').format(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .parse(invoiceData.invDate.toString())),
      'inv_val': invoiceData.invVal,
      'cust_name': '',
      'invoice_num_': invoiceData.invNo
    };

    dynamic _data = await submitForApproval(_body, approveBody);

    capsaPrint('$_data');

    return _data;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).size.width < 800
          ? FutureBuilder<Object>(
              future: Provider.of<ActionModel>(context, listen: false)
                  .queryAnchorInvoiceList(),
              builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
                if (snapshot.hasData) {
                  dynamic _data = snapshot.data;
                  capsaPrint('\n\nanchor invoice list : $_data');

                  List<AnchorData> _enquiryData = <AnchorData>[];

                  if (_data['res'] == 'success') {
                    var _results = _data['data']['results'];

                    _results.forEach((element) {

                      _enquiryData.add(AnchorData(
                        element['company_name'],
                        element['company_name'],
                        element['PAN'],
                        element['email'],
                        element['remarks'],
                        element['contact_num'],
                        element['role'],
                        element['role2'],
                        element['address'],
                        element['city'],
                        element['state'],
                        element['ACTIVE'].toString(),
                        element['modified_at'],
                        element['industry'],
                        element['keyPerson'],
                        element['founded'],
                        element['CIN'],
                        element['account_number'],
                      ));
                    });
                  } else {
                    return Center(
                      child: Text('Error Loading Data.'),
                    );
                  }
                  return AnchorListCard(
                    enquiryData: _enquiryData,
                    title: widget.title,
                  );
                } else {
                  return Center(
                    child: Text('Loading...'),
                  );
                }
              })
          : ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              children: <Widget>[
                Container(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      TextFormField(
                        // onFieldSubmitted: (value) {
                        //   // after pressing enter
                        //   capsaPrint(value);
                        // },
                        onChanged: (value) {
                          searchInvoiceText = value;
                          if (value == "") setState(() {});
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText:
                          'Search by invoice number, anchor name, vendor name',
                          // suffixIcon: Icon(
                          //   Icons.search,
                          //   color: Colors.blueGrey.withOpacity(0.9),
                          //
                          // ),
                        ),
                        // onTap: () {

                        // capsaPrint("Invoice");

                        // },
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.blueGrey.withOpacity(0.9),
                        ),
                        onPressed: () {
                          // do something

                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  color: Colors.white,
                  child: FutureBuilder<Object>(
                      future: Provider.of<ActionModel>(context, listen: false)
                          .queryAnchorInvoiceList(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Object> snapshot) {
                        if (snapshot.hasData) {
                          dynamic _data = snapshot.data;
                          //capsaPrint('\n\nanchor invoice list : $_data');
                          // capsaPrint(_data);

                          List<AnchorInvoiceData> _enquiryData =
                              <AnchorInvoiceData>[];

                          if (_data['res'] == 'success') {
                            var _results = _data['data'];

                            _results.forEach((element) {
                              // capsaPrint(
                              //     '\n\n\nelemenmt : $element\n${element['invoice_date']} ${element['invoice_due_date']}');
                              if(searchInvoiceText == '' || element['invoice_number'].toString().toLowerCase().contains(searchInvoiceText.toLowerCase()) || element['customer_name'].toString().toLowerCase().contains(searchInvoiceText.toLowerCase()) || element['NAME'].toString().toLowerCase().contains(searchInvoiceText.toLowerCase())) {
                                _enquiryData.add(AnchorInvoiceData(
                                element['invoice_number'].toString(),
                                element['invoice_line_items'].toString(),
                                element['invoice_date'] == '0000-00-00'
                                    ? '2001-01-01T00:00:00.000Z'
                                    : element['invoice_date'].toString(),
                                element['invoice_due_date'] == '0000-00-00'
                                    ? '2001-01-01T00:00:00.000Z'
                                    : element['invoice_due_date'].toString(),
                                element['description'].toString(),
                                element['invoice_value'].toString(),
                                element['payment_terms'].toString(),
                                element['NAME'].toString(),
                                element['customer_name'].toString(),
                                element['status'].toString(),
                                element['PAN_NO'].toString(),
                                element['ask_amt'].toString(),
                                extractPanNumber(
                                    element['customer_gst'].toString()),
                                  element['ask_rate'].toString(),
                                  element['company_pan'].toString(),
                                element['invoice_line_items'].toString(),
                                  element['actual_value'].toString(),



                                // element['address'],
                                // element['city'],
                                // element['state'],
                                // element['ACTIVE'].toString(),
                                // element['modified_at'],
                                // element['industry'],
                                // element['keyPerson'],
                                // element['founded'],
                                // element['CIN'],
                                // element['account_number'],
                              ));
                              }
                            });
                          } else {
                            return Center(
                              child: Text('Error Loading Data.'),
                            );
                          }

                          // final AnchorInvoiceListDataSource _anchorListDataSource =
                          // AnchorInvoiceListDataSource(
                          //     context, _enquiryData, widget.title);
                          return Theme(
                            data: tableTheme,
                            child: DataTable(
                              columns: dataTableColumn([
                                "Invoice Number",
                                "Vendor Name",
                                "Anchor Name",
                                "Invoice Value",
                                "Sell Price",
                                "Invoice Date",
                                "Due Date",
                                "Tenure",
                                "Status",
                                ""
                              ]),
                              rows: <DataRow>[
                                for (var element in _enquiryData)
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                        element.invNo,
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        element.vendorName,
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        element.anchorName,
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        formatCurrency(element.invVal),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        formatCurrency(element.sellPrice),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        DateFormat('d MMM, y').format(DateFormat(
                                                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                            .parse(element.invDate.toString())),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        DateFormat('d MMM, y').format(DateFormat(
                                                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                            .parse(
                                                element.invDueDate.toString())),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        element.tenure,
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        element.status == '1'
                                            ? 'Pending'
                                            : 'Approved',
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(
                                          PopupMenuButton(
                                        icon: const Icon(Icons.more_vert),
                                        itemBuilder: (context) => [
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
                                                                                  'Approve Invoice',
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
                                                                                  'Do you want to approve this invoice?',
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
                                                                                        dynamic res = await approve(element);
                                                                                        if (res['res'] == 'success') {
                                                                                          Navigator.pop(context1);
                                                                                          showToast('Approved Successfully', context);
                                                                                        } else {
                                                                                          Navigator.pop(context1);
                                                                                          showToast('Something Went Wrong', context, type: 'warning');
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
                                                  const Icon(Icons.check),
                                                  RichText(
                                                    text: const TextSpan(
                                                      text: 'Approve Invoice',
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
                                          ),

                                          if(element.status == '1')
                                          PopupMenuItem(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditAnchorInvoiceAdmin(invoice: element)))
                                                    .then((value) {
                                                  setState(() {

                                                  });
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

                                          if(element.status == '1')
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
                                                                              dynamic res = await delete(element);
                                                                              capsaPrint('Response delete $res');
                                                                              if (res['res'] == 'success') {
                                                                                Navigator.pop(context1);
                                                                                showToast('Invoice Deleted Successfully', context);
                                                                                setState(() {
                                                                                  processing = false;
                                                                                });
                                                                              } else {
                                                                                Navigator.pop(context1);
                                                                                showToast('Something Went Wrong', context, type: 'warning');
                                                                                setState(() {
                                                                                  processing = false;
                                                                                });
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
                                    ],
                                  ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Text('Loading...'),
                          );
                        }
                      }),
                )
              ],
            ),
    );
  }
}
