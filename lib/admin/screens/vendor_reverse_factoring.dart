import 'dart:convert';

import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/anchor_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/widgets/anchor_list_card.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../functions/show_toast.dart';
import '../../widgets/datatable_dynamic.dart';
import '../data/anchor_invoice_data.dart';
import 'package:http/http.dart' as http;

import '../data/anchor_rf_data.dart';

class VendorReverseFactoring extends StatefulWidget {
  final String title;

  const VendorReverseFactoring({Key key, this.title}) : super(key: key);

  @override
  _VendorReverseFactoringState createState() => _VendorReverseFactoringState();
}

class _VendorReverseFactoringState extends State<VendorReverseFactoring> {

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


  Future<Object> approve(AnchorInvoiceData invoiceData) async{

    dynamic _body = {};

    var userData = Map<String, dynamic>.from(box.get('userData'));

    _body['panNumber'] = invoiceData.vendorPan;
    _body['role'] = 'VENDOR';
    _body['userName'] = invoiceData.vendorName;
    _body['invNum'] = invoiceData.invNo;
    _body['isSplit'] = '0';
    // _body['invNum'] = invoice.invNo;

    dynamic _data = await submitForApproval(

        _body

    );

    return _data;
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

  Future<Object> updateRF(_body,) async {
    // capsaPrint('userData');
    // capsaPrint(userData);

    dynamic _uri;
    String _url = apiUrl;

    _uri = _url + 'admin/updateRF';
    capsaPrint('request update RF 3');
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);

    return data;
  }


  Future<Object> update(AnchorRFData invoiceData) async{

    dynamic _body = {};

    var userData = Map<String, dynamic>.from(box.get('userData'));

    _body['panNumber'] = invoiceData.PAN;
    _body['RF'] = invoiceData.RF ==  '1' ? '0' : '1';
    // _body['invNum'] = invoice.invNo;

    dynamic _data = await updateRF(

      _body,

    );

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
              .queryAnchorRFList(),
          builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
            if (snapshot.hasData) {
              dynamic _data = snapshot.data;
              capsaPrint('\n\nanchor RF : $_data');

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
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            color: Colors.white,
            child: FutureBuilder<Object>(
                future: Provider.of<ActionModel>(context, listen: false)
                    .queryVendorRFList(),
                builder: (BuildContext context,
                    AsyncSnapshot<Object> snapshot) {
                  if (snapshot.hasData) {
                    dynamic _data = snapshot.data;
                    //capsaPrint('\n\nanchor invoice list : $_data');
                    // capsaPrint(_data);
                    capsaPrint('\n\nanchor RF : $_data');

                    List<AnchorRFData> _enquiryData = <AnchorRFData>[];

                    if (_data['res'] == 'success') {
                      var _results = _data['data'];



                      // _results.forEach((element) {
                      //   _enquiryData.add(AnchorRFData(
                      //     element['company_name'].toString(),
                      //     element['RF'].toString(),
                      //     element['email'].toString(),
                      //     element['founded'].toString() == '0000-00-00' ?  '2001-01-01THH:00:00.000Z' : element['founded'].toString(),
                      //     element['PAN'].toString(),
                      //
                      //   ));
                      // });
                    } else {
                      return Center(
                        child: Text('Error Loading Data.'),
                      );
                    }

                    int i = 1;

                    // final VendorReverseFactoringDataSource _anchorListDataSource =
                    // VendorReverseFactoringDataSource(
                    //     context, _enquiryData, widget.title);
                    return Theme(
                      data: tableTheme,
                      child: DataTable(
                        columns: dataTableColumn([
                          "S/N",
                          "Anchor",
                          "Pan",
                          "Email",
                          "Founded",
                          "RF",
                          '',
                        ]),
                        rows: <DataRow>[
                          for (var element in _enquiryData)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  (i++).toString(),
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  element.companyName ??  '',
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  element.PAN ?? '',
                                  style: dataTableBodyTextStyle,
                                )),

                                DataCell(Text(
                                  element.email ?? '',
                                  style: dataTableBodyTextStyle,
                                )),

                                DataCell(Text(
                                  DateFormat('d MMM, y').format(
                                      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                          .parse(element.founded)).toString(),
                                  style: dataTableBodyTextStyle,
                                )),

                                DataCell(Text(
                                  element.RF == '1' ? 'Enabled' : 'Disabled',
                                  style: dataTableBodyTextStyle,
                                )),

                                DataCell(PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  itemBuilder: (context) => [



                                    PopupMenuItem(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);

                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => AlertDialog(
                                                // title: Text(
                                                //   '',
                                                //   style: TextStyle(
                                                //     fontSize: 24,
                                                //     fontWeight: FontWeight.bold,
                                                //     color: Theme.of(context).primaryColor,
                                                //   ),
                                                // ),
                                                content: Container(
                                                  // width: 800,
                                                    height: Responsive.isMobile(context)?340:300,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children:  [

                                                          SizedBox(height: 12,),

                                                          Text(
                                                            element.RF == '1' ? 'Disable Reverse Factoring' : 'Enable Reverse Factoring',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),

                                                          SizedBox(height: 12,),

                                                          Text(
                                                            element.RF == '1' ? 'Do you want to disable Reverse Factoring for this anchor' : 'Do you want to enable Reverse Factoring for this anchor',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.black,
                                                            ),
                                                          ),

                                                          SizedBox(height: 12,),

                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () async{
                                                                  showToast('Please Wait!', context, type: 'warning');
                                                                  dynamic res = await update(element);
                                                                  if(res['res'] == 'success'){

                                                                    Navigator.pop(context);
                                                                    showToast('Updated Successfully', context);
                                                                  }else{
                                                                    Navigator.pop(context);
                                                                    showToast('Something Went Wrong', context, type: 'warning');

                                                                  }

                                                                },
                                                                child: Container(
                                                                  width: Responsive.isMobile(context)?140 : 220,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.transparent,
                                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                                  ),
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
                                                                onTap: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  width: Responsive.isMobile(context)?140 : 220,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.transparent,
                                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                                  ),
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
                                                    )
                                                ),
                                                //actions: <Widget>[],
                                              )).then((value){
                                            setState(() {

                                            });
                                          });

                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ));
                                        },
                                        child: Row(
                                          children: [
                                            //const Icon(Icons.check),
                                            RichText(
                                              text: TextSpan(
                                                text: element.RF == '1' ? 'Disable Reverse Factoring' : 'Enable Reverse Factoring',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color:
                                                    Color.fromRGBO(
                                                        51,
                                                        51,
                                                        51,
                                                        1)),
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
