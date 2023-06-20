import 'dart:convert';

import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/anchor_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/widgets/anchor_list_card.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../functions/call_api.dart';
import '../../functions/hexcolor.dart';
import '../../functions/show_toast.dart';
import '../../widgets/datatable_dynamic.dart';
import '../../widgets/user_input.dart';
import '../data/anchor_invoice_data.dart';
import 'package:http/http.dart' as http;

import '../data/anchor_rf_data.dart';

class AnchorReverseFactoring extends StatefulWidget {
  final String title;

  const AnchorReverseFactoring({Key key, this.title}) : super(key: key);

  @override
  _AnchorReverseFactoringState createState() => _AnchorReverseFactoringState();
}

class _AnchorReverseFactoringState extends State<AnchorReverseFactoring> {
  bool saving = true;

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
  bool processing = false;

  Future<Object> updateRF(
    _body,
  ) async {
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

  Future<Object> update(AnchorRFData invoiceData) async {
    dynamic _body = {};

    var userData = Map<String, dynamic>.from(box.get('userData'));

    _body['panNumber'] = invoiceData.PAN;
    _body['RF'] = invoiceData.RF == '1' ? '0' : '1';
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
                          .queryAnchorRFList(),
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

                            _results.forEach((element) {
                              _enquiryData.add(AnchorRFData(
                                  element['company_name'].toString(),
                                  element['RF'].toString(),
                                  element['email'].toString(),
                                  element['founded'].toString() == '0000-00-00'
                                      ? '2001-01-01THH:00:00.000Z'
                                      : element['founded'].toString(),
                                  element['PAN'].toString(),
                                  element['capsa_rate'].toString()));
                            });
                          } else {
                            return Center(
                              child: Text('Error Loading Data.'),
                            );
                          }

                          int i = 1;

                          // final AnchorReverseFactoringDataSource _anchorListDataSource =
                          // AnchorReverseFactoringDataSource(
                          //     context, _enquiryData, widget.title);
                          return Theme(
                            data: tableTheme,
                            child: DataTable(
                              columns: dataTableColumn([
                                "S/N",
                                "Anchor",
                                "BVN",
                                "Email",
                                "Founded",
                                "Rate",
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
                                        element.companyName ?? '',
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
                                        DateFormat('d MMM, y')
                                            .format(DateFormat(
                                                    "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                .parse(element.founded))
                                            .toString(),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        element.rate ?? '',
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        element.RF == '1'
                                            ? 'Enabled'
                                            : 'Disabled',
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
                                                                        child: Container(height: 50, width: 50, child: CircularProgressIndicator())),
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
                                                                                  element.RF == '1' ? 'Disable Reverse Factoring' : 'Enable Reverse Factoring',
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
                                                                                  element.RF == '1' ? 'Do you want to disable Reverse Factoring for this anchor' : 'Do you want to enable Reverse Factoring for this anchor',
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
                                                                                        //showToast('Please Wait!', context, type: 'warning');
                                                                                        dynamic res = await update(element);
                                                                                        if (res['res'] == 'success') {
                                                                                          Navigator.pop(context);
                                                                                          showToast('Updated Successfully', context);
                                                                                        } else {
                                                                                          Navigator.pop(context);
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
                                                                                        Navigator.pop(context);
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

                                                // showDialog(
                                                //     context: context,
                                                //     barrierDismissible: false,
                                                //     builder: (context) => AlertDialog(
                                                //       // title: Text(
                                                //       //   '',
                                                //       //   style: TextStyle(
                                                //       //     fontSize: 24,
                                                //       //     fontWeight: FontWeight.bold,
                                                //       //     color: Theme.of(context).primaryColor,
                                                //       //   ),
                                                //       // ),
                                                //       content: Container(
                                                //         // width: 800,
                                                //           height: Responsive.isMobile(context)?340:300,
                                                //           child: Padding(
                                                //             padding: const EdgeInsets.all(16.0),
                                                //             child: Column(
                                                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                //               crossAxisAlignment: CrossAxisAlignment.center,
                                                //               children:  [
                                                //
                                                //                 SizedBox(height: 12,),
                                                //
                                                //                 Text(
                                                //                   element.RF == '1' ? 'Disable Reverse Factoring' : 'Enable Reverse Factoring',
                                                //                   textAlign: TextAlign.center,
                                                //                   style: TextStyle(
                                                //                     fontSize: 16,
                                                //                     fontWeight: FontWeight.bold,
                                                //                     color: Colors.black,
                                                //                   ),
                                                //                 ),
                                                //
                                                //                 SizedBox(height: 12,),
                                                //
                                                //                 Text(
                                                //                   element.RF == '1' ? 'Do you want to disable Reverse Factoring for this anchor' : 'Do you want to enable Reverse Factoring for this anchor',
                                                //                   textAlign: TextAlign.center,
                                                //                   style: TextStyle(
                                                //                     fontSize: 14,
                                                //                     fontWeight: FontWeight.w400,
                                                //                     color: Colors.black,
                                                //                   ),
                                                //                 ),
                                                //
                                                //                 SizedBox(height: 12,),
                                                //
                                                //                 Row(
                                                //                   children: [
                                                //                     InkWell(
                                                //                       onTap: () async{
                                                //                         showToast('Please Wait!', context, type: 'warning');
                                                //                         dynamic res = await update(element);
                                                //                         if(res['res'] == 'success'){
                                                //
                                                //                           Navigator.pop(context);
                                                //                           showToast('Updated Successfully', context);
                                                //                         }else{
                                                //                           Navigator.pop(context);
                                                //                           showToast('Something Went Wrong', context, type: 'warning');
                                                //
                                                //                         }
                                                //
                                                //                       },
                                                //                       child: Container(
                                                //                         width: Responsive.isMobile(context)?140 : 220,
                                                //                         decoration: BoxDecoration(
                                                //                             color: Colors.transparent,
                                                //                             borderRadius: BorderRadius.all(Radius.circular(10))
                                                //                         ),
                                                //                         child: Center(
                                                //                           child: Padding(
                                                //                             padding: const EdgeInsets.all(12.0),
                                                //                             child: Text(
                                                //                               'Yes',
                                                //                               style: TextStyle(
                                                //                                 fontSize: 16,
                                                //                                 fontWeight: FontWeight.w400,
                                                //                                 color: Colors.green,
                                                //                               ),
                                                //                             ),
                                                //                           ),
                                                //                         ),
                                                //                       ),
                                                //                     ),
                                                //
                                                //                     InkWell(
                                                //                       onTap: (){
                                                //                         Navigator.pop(context);
                                                //                       },
                                                //                       child: Container(
                                                //                         width: Responsive.isMobile(context)?140 : 220,
                                                //                         decoration: BoxDecoration(
                                                //                             color: Colors.transparent,
                                                //                             borderRadius: BorderRadius.all(Radius.circular(10))
                                                //                         ),
                                                //                         child: Center(
                                                //                           child: Padding(
                                                //                             padding: const EdgeInsets.all(12.0),
                                                //                             child: Text(
                                                //                               'No',
                                                //                               style: TextStyle(
                                                //                                 fontSize: 16,
                                                //                                 fontWeight: FontWeight.w400,
                                                //                                 color: Colors.red,
                                                //                               ),
                                                //                             ),
                                                //                           ),
                                                //                         ),
                                                //                       ),
                                                //                     ),
                                                //                   ],
                                                //                 ),
                                                //
                                                //               ],
                                                //             ),
                                                //           )
                                                //       ),
                                                //       //actions: <Widget>[],
                                                //     )).then((value){
                                                //   setState(() {
                                                //
                                                //   });
                                                // });

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
                                                      text: element.RF == '1'
                                                          ? 'Disable Reverse Factoring'
                                                          : 'Enable Reverse Factoring',
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
                                          PopupMenuItem(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);

                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    //OpenDealModel openInvoice = openDealProvider.openInvoices[index];
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      32.0))),
                                                      backgroundColor:
                                                          HexColor("#F5FBFF"),
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Change Anchor Rate',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        33,
                                                                        150,
                                                                        83,
                                                                        1),
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 24,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height: 1),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      content:
                                                          ChangeRateContent(
                                                        data: element,
                                                      ),
                                                    );
                                                  },
                                                ).then((value) {
                                                  setState(() {});
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
                                                      text:
                                                          'Change Anchor Rate',
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

class ChangeRateContent extends StatefulWidget {
  AnchorRFData data;

  ChangeRateContent({Key key, this.data}) : super(key: key);

  @override
  _ChangeRateContentState createState() => _ChangeRateContentState();
}

class _ChangeRateContentState extends State<ChangeRateContent> {
  String amount, rate, tRate = '';
  final myController = TextEditingController(text: '');
  final myController2 = TextEditingController(text: '');
  final myController3 = TextEditingController(text: '');
  final myController0 = TextEditingController(text: '');
  final myController4 = TextEditingController(text: '');
  final myController5 = TextEditingController(text: '');
  String _message =
      '\nYour Excepted Return Calculated ad follow\n\nBid Amount : ₦ 0\nPlatform Fee : ₦ 0\n,Excepted Return : ₦ 0\n';

  bool _loading = false;

  final ButtonStyle raisedButtonStyle2 = ElevatedButton.styleFrom(
    onPrimary: Colors.white70,
    primary: Colors.red[400],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 420,
        constraints: BoxConstraints(maxWidth: 500, minWidth: 450),
        child: Column(
          children: [
            UserTextFormField(
              label: 'Enter Rate',
              //prefixIcon: Image.asset("assets/images/currency.png"),
              hintText: '0',
              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: myController0,
              //readOnly: widget.buyNow,
              // initialValue: '',
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Value cannot be empty';
                }
                return null;
              },
              //keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 15,
            ),
            if (!_loading)
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _loading = true;
                      });

                      var _body = {
                        'panNumber': widget.data.PAN,
                        'rate': myController0.text,
                      };

                      dynamic response =
                          await callApi('admin/updateAnchorRate', body: _body);
                      capsaPrint('response $response');

                      if (response['res'] == 'success') {
                        showToast('Rate Changed', context);
                      } else {
                        showToast('Something went wrong', context,
                            type: 'warning');
                      }

                      Navigator.pop(context);

                      setState(() {
                        _loading = false;
                      });
                    },
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromRGBO(0, 152, 219, 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Center(
                          child: Text(
                            'Update Rate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        )),
                  ),

                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Colors.red,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Center(
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        )),
                  ),
                  // ElevatedButton(
                  //   style: raisedButtonStyle2,
                  //   onPressed: () {
                  //     Navigator.of(context, rootNavigator: true).pop();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Text('Cancel'),
                  //   ),
                  // ),
                ],
              )
            else
              Align(
                  alignment: Alignment.centerRight,
                  child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
