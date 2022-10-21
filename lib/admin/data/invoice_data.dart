import 'dart:convert';

import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvoiceData {
  final String invNum;
  final String seller;
  final String companyPan;
  final String anchor;
  final String invAmt;
  final String buyNow;
  final String invDate;
  final String dueDate;
  final String discountedOn;
  final String presented;
  final String proposalStatus;
  final String bidBy;
  final String bidType;
  final String bidAmt;
  final String bidRate;
  final String platformFree;
  final String newAmount;
  final String fileName;
  final String status;
  final dynamic extra;

  InvoiceData({
    this.invNum,
    this.seller,
    this.companyPan,
    this.anchor,
    this.invAmt,
    this.buyNow,
    this.invDate,
    this.dueDate,
    this.discountedOn,
    this.presented,
    this.proposalStatus,
    this.bidBy,
    this.bidType,
    this.bidAmt,
    this.bidRate,
    this.platformFree,
    this.newAmount,
    this.fileName,
    this.status,
    this.extra,
  });
}

class InvoiceDataSource extends DataTableSource {
  List<InvoiceData> data = <InvoiceData>[];

  bool pendingScreen = false;
  bool revenueScreen = false;
  TabBarModel tabBarModel ;

  InvoiceDataSource(this.data, {this.pendingScreen, this.revenueScreen ,this.tabBarModel});

  // void _sort<T>(Comparable<T> getField(InvoiceData d), bool ascending) {
  //   data.sort((InvoiceData a, InvoiceData b) {
  //     if (!ascending) {
  //       final InvoiceData c = a;
  //       a = b;
  //       b = c;
  //     }
  //     final Comparable<T> aValue = getField(a);
  //     final Comparable<T> bValue = getField(b);
  //     return Comparable.compare(aValue, bValue);
  //   });
  //   notifyListeners();
  // }

  int _selectedCount = 0;
  final cellStyle = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= data.length) return null;
    final InvoiceData d = data[index];

    dynamic extra;

    if (d.extra != null) {
      extra = d.extra;
    }

    if (revenueScreen == null) revenueScreen = false;

    var intDate = '';
    var dueDate = '';
    var discountedOn = '';

    // '${d.dueDate}',
    final _fName = d.fileName;
    // d.invDate

    //   '${d.discountedOn}',
    //
    // capsaPrint(d.bidBy +"  "+ d.bidType);

    intDate = DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(d.invDate)).toString();

    dueDate = DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(d.dueDate)).toString();

    // capsaPrint(d.discountedOn);

    if (d.discountedOn != null) discountedOn = DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd").parse(d.discountedOn)).toString();

    return DataRow.byIndex(index: index, selected: false, onSelectChanged: null, cells: <DataCell>[
      DataCell(Text(
        (index + 1).toString(),
        style: cellStyle,
      )),
      DataCell(Text(
        '${d.invNum}',
        style: cellStyle,
      )),
      DataCell(ShowInvoice(fName: _fName)),
      if (!revenueScreen)
        DataCell(Text(
          d.seller ?? '',
          style: cellStyle,
        )),
      if (!revenueScreen)
        DataCell(Text(
          d.anchor ?? '',
          style: cellStyle,
        )),
      DataCell(Text(
        '₦ ' + formatCurrency(d.invAmt),
        style: cellStyle,
      )),
      // DataCell(Text(
      //   '₦ '+ formatCurrency(d.buyNow) ,
      //   style: cellStyle,
      // )),
      DataCell(Text(
        intDate,
        style: cellStyle,
      )),
      DataCell(Text(
        dueDate,
        style: cellStyle,
      )),
      if (!pendingScreen)
        DataCell(Text(
          discountedOn,
          style: cellStyle,
        )),
      if (!pendingScreen)
        DataCell(Text(
          '${d.presented}',
          style: cellStyle,
        )),
      if (!pendingScreen)
        DataCell(Text(
          '${d.proposalStatus}',
          style: cellStyle,
        )),
      if (!pendingScreen)
        DataCell(Text(
          d.bidBy ?? '',
          style: cellStyle,
        )),
      if (!pendingScreen)
        DataCell(Text(
          '${d.bidType}',
          style: cellStyle,
        )),
      if (!pendingScreen)
        DataCell(Text(
          (d.bidAmt != null && d.bidAmt != '') ? '₦ ' + formatCurrency(d.bidAmt) : '',
          style: cellStyle,
        )),
      if (!pendingScreen)
        DataCell(Text(
          '${d.bidRate}',
          style: cellStyle,
        )),
      if (!pendingScreen)
        DataCell(Text(
          '₦ ' + formatCurrency(d.platformFree),
          style: cellStyle,
        )),
      if (!pendingScreen)
        DataCell(Text(
          '₦ ' + formatCurrency(d.newAmount),
          style: cellStyle,
        )),

      if (revenueScreen) DataCell(BSAText(data: extra,tabBarModel : tabBarModel)),
      if (revenueScreen) DataCell(CreditScoreColumn(data: extra, tabBarModel : tabBarModel)),

      if (pendingScreen && revenueScreen) DataCell(ApproveRevenue(d)),
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

class CreditScoreColumn extends StatelessWidget {
  final data;
  final TabBarModel tabBarModel;

  const CreditScoreColumn({Key key, this.data, this.tabBarModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cellStyle = TextStyle(
      color: Colors.blueGrey[800],
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );
    // capsaPrint('data creditScoreData');
    // capsaPrint(data['creditScoreData']);
    //

    if (data == null)
      return Container();
    else
      return InkWell(
        onTap: (){
          tabBarModel.changeTab(13);
          tabBarModel.rcDataPass(data['rcNumber'].toString());
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (data['creditScore'])
              Text(
                'RC No.: ' + data['rcNumber'].toString(),
                style: cellStyle,
              ),
            if (data['creditScore'])
              Text(
                'Score: ' + data['totalCreditScore'].toString(),
                style: cellStyle,
              ),
            if (data['creditScore'] && data['last_update'] != null)
              Text(
                'Last updated: ' + DateFormat('d MMM,y HH:mm a').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(data['last_update'])).toString(),
                style: cellStyle,
              ),
            if (!data['creditScore'])
              Text(
                data['messg1'],
                style: cellStyle,
              ),
          ],
        ),
      );
  }
}

class BSAText extends StatelessWidget {
  final data;
  final TabBarModel tabBarModel;
  const BSAText({Key key, this.data,this.tabBarModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cellStyle = TextStyle(
      color: Colors.blueGrey[800],
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );

    if (data == null)
      return Container();
    else
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data['bsa'])
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(data['bsaValue'] == null)
                  Text("Account Found\nNo Transaction found"),
                if(data['bsaValue'] != null)
                Text("Score: " + data['bsaValue'].toString()),
                if(data['bsa_last_update'] != null)
                Text(
                  'Last updated: ' +
                      DateFormat('d MMM,y HH:mm a').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(data['bsa_last_update'])).toString(),
                  style: cellStyle,
                ),
              ],
            )
          else
            Text(data['messg1']),
        ],
      );
  }
}

class ApproveRevenue extends StatefulWidget {
  InvoiceData revenue;

  ApproveRevenue(this.revenue, {Key key}) : super(key: key);

  @override
  _ApproveRevenueState createState() => _ApproveRevenueState();
}

class _ApproveRevenueState extends State<ApproveRevenue> {
  final box = Hive.box('capsaBox');

  bool loading = false;
  var status = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = widget.revenue.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          if (status == '3') Text("Approved"),
          if (status == '4') Text("Rejected"),
          if (loading) CircularProgressIndicator(),
          if (!loading)
            if (status == '2')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  if (box.get('isAuthenticated', defaultValue: false)) {
                    var userData = Map<String, dynamic>.from(box.get('userData'));
                    //
                    // capsaPrint('userData');
                    // capsaPrint(userData);
                    var _body = {};

                    _body['userName'] = userData['name'];
                    _body['panNumber'] = userData['panNumber'];
                    _body['role'] = userData['role'];
                    _body['role'] = userData['role'];
                    _body['i_amount'] = widget.revenue.invAmt;
                    _body['i_date'] = widget.revenue.dueDate;
                    _body['inv_num'] = widget.revenue.invNum;
                    _body['inv_date'] = widget.revenue.invDate;
                    // _body['inv_date'] = invoice.invDate;
                    _body['inv_val'] = widget.revenue.invAmt;
                    _body['cust_name'] = '';
                    _body['invoice_num_'] = widget.revenue.invNum;

                    // _body['invoice_num_'] = invoice.invNo;

                    // capsaPrint('_body');
                    // capsaPrint(_body);
                    setState(() {
                      loading = true;
                    });
                    var _data = await callApi('dashboard/a/approve', body: _body);
                    setState(() {
                      loading = false;
                    });
                    if (_data['res'] == 'success') {
                      setState(() {
                        status = '3';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Successfully Approved.'),
                          action: SnackBarAction(
                            label: 'Ok',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                        ),
                      );

                      // Navigator.of(context, rootNavigator: true).pop();

                    } else {
                      showToast('Unable to proceed', context);
                    }
                    // dynamic _uri;
                    // _uri = _url + 'dashboard/a/approve';
                    // _uri = Uri.parse(_uri);
                    // var response = await http.post(_uri, headers: <String, String>{
                    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
                    // }, body: _body);
                    // var data = jsonDecode(response.body);
                    //
                    // // capsaPrint(data);
                    // return data;
                  }
                },
                child: Text('Approve'),
              ),
          SizedBox(
            width: 10,
          ),
          if (!loading)
            if (status == '2')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  capsaPrint("Reject Click");
                  if (box.get('isAuthenticated', defaultValue: false)) {
                    var userData = Map<String, dynamic>.from(box.get('userData'));

                    var _body = {};

                    _body['userName'] = userData['name'];
                    _body['panNumber'] = userData['panNumber'];
                    _body['role'] = userData['role'];
                    _body['ino'] = widget.revenue.invNum;
                    _body['comppan'] = widget.revenue.companyPan;

                    setState(() {
                      loading = true;
                    });

                    // capsaPrint('_body');
                    // capsaPrint(_body);
                    var _data = await callApi('dashboard/a/reject', body: _body);
                    setState(() {
                      loading = false;
                    });

                    if (_data['res'] == 'success') {
                      setState(() {
                        status = '4';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Successfully Rejected.'),
                          action: SnackBarAction(
                            label: 'Ok',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                        ),
                      );

                      // Navigator.of(context, rootNavigator: true).pop();

                    } else {
                      showToast('Unable to proceed', context);
                    }
                  }
                },
                child: Text('Reject'),
              ),
        ],
      ),
    );
  }
}

class ShowInvoice extends StatelessWidget {
  final fName;

  ShowInvoice({Key key, this.fName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actionModel = Provider.of<ActionModel>(context);
    return IconButton(
        onPressed: () async {
          var _body = {'fName': fName};
          final split = fName.split('.');

          if ((split[split.length - 1]) == "csv") {
            dynamic _data = await actionModel.getInvFile(_body);
            if (_data['res'] == 'success') {
              var url = _data['data']['url'];
              capsaPrint(url);
              actionModel.downloadFile(url, isCsv: true);
            }
            return;
          }
          // return;

          // capsaPrint('fName');
          // capsaPrint(fName);

          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      'Invoice File',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    content: Container(
                      width: 800,
                      child: FutureBuilder<Object>(
                          future: actionModel.getInvFile(_body),
                          builder: (context, snapshot) {
                            // capsaPrint(snapshot.data);
                            dynamic _data = snapshot.data;
                            if (snapshot.hasData) {
                              if (_data['res'] == 'success') {
                                var url = _data['data']['url'];
                                // capsaPrint(url);
                                return Column(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: SfPdfViewer.network(url),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            actionModel.downloadFile(url);
                                            Navigator.of(context, rootNavigator: true).pop(); // dismisses only the dialog and returns nothing
                                          },
                                          child: new Text('Download'),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context, rootNavigator: true).pop(); // dismisses only the dialog and returns nothing
                                          },
                                          child: new Text('Close'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    actions: <Widget>[],
                  ));
        },
        icon: Icon(
          LineAwesomeIcons.file_pdf_o,
          size: 30,
          color: Colors.green,
        ));
  }
}
