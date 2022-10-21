import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/show_toast.dart';

import 'package:capsa/common/responsive.dart';
import 'package:capsa/providers/creditscore_providers.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/admin/common/constants.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CheckCreditScore extends StatefulWidget {
  final String title;

  const CheckCreditScore({Key key, this.title}) : super(key: key);

  @override
  _CheckCreditScoreState createState() => _CheckCreditScoreState();
}

class _CheckCreditScoreState extends State<CheckCreditScore> {
  final cellStyle = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  var rcNumber;
  var tmpRcNumber;

  var cinID;
  var totalBureauCredit;
  var term = [];
  var dataList = [];
  bool loadingData = false;
  bool loadedData = false;
  var lastUpdate;
  dynamic COMMERCIALDETAILS;

  dynamic SUMMARY_OF_PERFORMANCE;

  dynamic REPORTDETAILS;

  String panNo = '';

  void loadBSAData() async {
    final _creditScoreProvider = Provider.of<CreditScoreProvider>(context, listen: false);

    setState(() {
      _creditScoreProvider.setCreditExits(false);
      loadingData = true;
    });
    await _creditScoreProvider.getAccountLinked(getByPan: panNo);
    // if(_creditScoreProvider.exits && _creditScoreProvider.)
    await _creditScoreProvider.checkCreditScore(context, getByPan: panNo);
    setState(() {
      loadingData = false;
    });
  }

  void loadSaveData() async {
    if (rcNumber == '') {
      return;
    }
    setState(() {
      loadedData = false;
      loadingData = true;
    });

    var _body = {};
    _body['rcNumber'] = rcNumber;
    _body['cinID'] = cinID;
    _body['type'] = 'old';

    dynamic _data = await Provider.of<ActionModel>(context, listen: false).queryRCAPIData(_body);

    if (_data['res'] == "success") {
      setState(() {
        loadedData = true;
        loadingData = false;
        dataList = _data['data']['results'];
        lastUpdate = _data['data']['last_update'];
        totalBureauCredit = _data['data']['totalCredit'];

        COMMERCIALDETAILS = _data['data']['COMMERCIALDETAILS'];
        SUMMARY_OF_PERFORMANCE = _data['data']['SUMMARY_OF_PERFORMANCE'];
        REPORTDETAILS = _data['data']['REPORTDETAILS'];
      });
    } else {
      setState(() {
        loadedData = false;
        loadingData = false;
      });
      showAlertDialog(BuildContext context) {
        // set up the button
        Widget okButton = TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("Error"),
          content: Text(_data['messg']),
          actions: [
            okButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      showAlertDialog(context);
    }
  }

  final dropdownState = GlobalKey<FormFieldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<CreditScoreProvider>(context, listen: false).setCreditExits(false);
    final _tabBarModel = Provider.of<TabBarModel>(context, listen: false);
    if (_tabBarModel.rcNumberForPendingRevenue != null && _tabBarModel.rcNumberForPendingRevenue != '') {
      tmpRcNumber = _tabBarModel.rcNumberForPendingRevenue;
      _tabBarModel.rcDataPass("");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _creditScoreProvider = Provider.of<CreditScoreProvider>(context);

    return Scaffold(
      body: Responsive.isMobile(context)
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Padding(
                padding: Responsive.isDesktop(context) ? const EdgeInsets.fromLTRB(20, 0, 20, 0) : const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                '${widget.title}',
                                style: TextStyle(fontSize: 22, color: Colors.grey[700], fontWeight: FontWeight.bold, letterSpacing: 1),
                              ),
                            ),
                          ),
                        ),
                        Responsive.isDesktop(context)
                            ? Spacer(
                                flex: 3,
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 12 : 30,
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
                      height: Responsive.isMobile(context) ? 12 : 35,
                    ),
                    Row(
                      children: [
                        Spacer(
                          flex: Responsive.isDesktop(context) ? 4 : 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 8 : 10,
                    ),
                    FutureBuilder(
                        future: Provider.of<ActionModel>(context, listen: false).queryRCCinData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            dynamic _results = [];
                            var i = 0;

                            var _data = snapshot.data;
                            if (_data['res'] == "success") {
                              _results = _data['data']['results'];
                              var _length = _data['data']['length'];
                              if (_length == 0) {
                                return Center(child: Text("No data found for settle"));
                              }
                              // capsaPrint(_results);
                            }

                            term = [];

                            _results.forEach((element) {
                              term.add(element['cin'].toString());
                            });

                            var ii = -1;
                            if (tmpRcNumber != null && tmpRcNumber != '')
                              Future.delayed(Duration(milliseconds: 500), () {
                                // Do something
                               setState(() {
                                 dropdownState.currentState.didChange(tmpRcNumber);
                                 tmpRcNumber = null;
                                 // capsaPrint('tmpRcNumber');
                                 // capsaPrint(tmpRcNumber);
                               });
                              });

                            return Container(
                              width: 450,
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              color: Colors.white,
                              child: DropdownButtonFormField(
                                key: dropdownState,
                                isExpanded: true,
                                validator: (v) {
                                  return null;
                                },
                                items: term.map((category) {
                                  ii++;
                                  return DropdownMenuItem(
                                    value: _results[ii]['cin'].toString(),
                                    child: Text(_results[ii]['name'] + ' [ ' + _results[ii]['cin'].toString() + ' ]'),
                                  );
                                }).toList(),
                                onChanged: (v) async {
                                  var iiff = 0;

                                  term.forEach((element1) {
                                    if (element1.toString() == v.toString()) {
                                      // _creditScoreProvider.setExits(false);
                                      setState(() {
                                        rcNumber = v;
                                        cinID = _results[iiff]['cinID'].toString();
                                        panNo = _results[iiff]['PAN_NO'].toString();
                                        loadSaveData();
                                        loadBSAData();
                                        // capsaPrint(cinID);
                                        // capsaPrint(rcNumber);
                                      });
                                    }
                                    iiff++;
                                  });
                                },
                                value: rcNumber,
                                decoration: InputDecoration(
                                  labelText: 'SELECT BUSINESS REG NO',
                                ),
                              ),
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    if (!loadingData)
                      if (rcNumber != null && rcNumber != '')
                        Row(
                          children: [
                            // Container(
                            //   width: 200,
                            //   child: MaterialButton(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(18.0),
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Text(
                            //         'BSA Score',
                            //         style: TextStyle(color: Colors.white),
                            //       ),
                            //     ),
                            //     color: Colors.blue,
                            //     onPressed: () async {
                            //       loadBSAData();
                            //     },
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 20,
                            // ),
                            // Container(
                            //   width: 200,
                            //   child: MaterialButton(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(18.0),
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Text(
                            //         'Load Saved Data',
                            //         style: TextStyle(color: Colors.white),
                            //       ),
                            //     ),
                            //     color: Colors.blue,
                            //     onPressed: () async {
                            //       loadSaveData();
                            //     },
                            //   ),
                            // ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 200,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Latest BSA',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                color: Colors.blue,
                                onPressed: () async {
                                  if (rcNumber == '') {
                                    return;
                                  }
                                  setState(() {
                                    loadedData = false;
                                    loadingData = true;
                                  });

                                  var _body = {};
                                  _body['rcNumber'] = rcNumber;
                                  _body['cinID'] = cinID;
                                  _body['panNumber'] = panNo;

                                  dynamic _data = await Provider.of<ActionModel>(context, listen: false).queryLatestBSAData(_body);

                                  if (_data['res'] == "success") {
                                    setState(() {
                                      loadedData = true;
                                      loadingData = false;
                                      dataList = _data['data']['results'];
                                    });
                                    // if(dataList.length == 0)
                                  } else {
                                    setState(() {
                                      loadedData = false;
                                      loadingData = false;
                                    });

                                    showAlertDialog(BuildContext context) {
                                      // set up the button
                                      Widget okButton = TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context, rootNavigator: true).pop();
                                        },
                                      );

                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: Text("Error"),
                                        content: Text(_data['messg']),
                                        actions: [
                                          okButton,
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    }

                                    showAlertDialog(context);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              width: 200,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Latest Credit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                color: Colors.blue,
                                onPressed: () async {
                                  if (rcNumber == '') {
                                    return;
                                  }
                                  setState(() {
                                    loadedData = false;
                                    loadingData = true;
                                  });

                                  var _body = {};
                                  _body['rcNumber'] = rcNumber;
                                  _body['cinID'] = cinID;
                                  _body['type'] = 'new';

                                  dynamic _data = await Provider.of<ActionModel>(context, listen: false).queryRCAPIData(_body);

                                  if (_data['res'] == "success") {
                                    setState(() {
                                      loadedData = true;
                                      loadingData = false;
                                      dataList = _data['data']['results'];
                                    });
                                    // if(dataList.length == 0)
                                  } else {
                                    setState(() {
                                      loadedData = false;
                                      loadingData = false;
                                    });

                                    showAlertDialog(BuildContext context) {
                                      // set up the button
                                      Widget okButton = TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context, rootNavigator: true).pop();
                                        },
                                      );

                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: Text("Error"),
                                        content: Text(_data['messg']),
                                        actions: [
                                          okButton,
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    }

                                    showAlertDialog(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_creditScoreProvider.creditExits)
                      if (_creditScoreProvider.isLinked == 'Yes')
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1, 8, 8, 15),
                          child: Text(
                            'BSA ( Last updated : ' +
                                DateFormat('d MMM,y HH:mm a')
                                    .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(_creditScoreProvider.lastUpdate))
                                    .toString() +
                                ' ) ',
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    if (_creditScoreProvider.creditExits)
                      if (_creditScoreProvider.isLinked == 'Yes')
                        Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 200,
                            child: SfRadialGauge(axes: <RadialAxis>[
                              RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                                GaugeRange(startValue: 0, endValue: 25, color: Colors.red),
                                GaugeRange(startValue: 25, endValue: 50, color: Colors.orange),
                                GaugeRange(startValue: 50, endValue: 75, color: Colors.yellow[700]),
                                GaugeRange(startValue: 75, endValue: 100, color: Colors.green)
                              ], pointers: <GaugePointer>[
                                NeedlePointer(value: _creditScoreProvider.creditData['tScore'])
                              ], annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text(_creditScoreProvider.creditData['tScore'].toString(),
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal))),
                                    angle: _creditScoreProvider.creditData['tScore'],
                                    positionFactor: 0.5)
                              ])
                            ])),
                    if (loadedData)
                      if (totalBureauCredit == null)
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No data found from Credit Bureau",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                    if (loadingData)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(width: 40, height: 40, child: CircularProgressIndicator()),
                      ),
                    if (loadedData)
                      if (totalBureauCredit != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1, 8, 8, 15),
                          child: Text(
                            'Credit Score ( Last updated : ' +
                                DateFormat('d MMM,y HH:mm a').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(lastUpdate)).toString() +
                                ' ) ',
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    if (totalBureauCredit != null)
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 200,
                          child: SfRadialGauge(axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                              GaugeRange(startValue: 0, endValue: 25, color: Colors.red),
                              GaugeRange(startValue: 25, endValue: 50, color: Colors.orange),
                              GaugeRange(startValue: 50, endValue: 75, color: Colors.yellow[700]),
                              GaugeRange(startValue: 75, endValue: 100, color: Colors.green)
                            ], pointers: <GaugePointer>[
                              NeedlePointer(value: totalBureauCredit)
                            ], annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                      child: Text(totalBureauCredit.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal))),
                                  angle: totalBureauCredit,
                                  positionFactor: 0.5)
                            ])
                          ])),
                    SizedBox(height: 8),
                    if (REPORTDETAILS != null)
                      Text(
                        "Report",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    SizedBox(height: 5),
                    if (REPORTDETAILS != null)
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Report Order Number : ", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(REPORTDETAILS['REPORTORDERNUMBER'].toString()),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Report Type :", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(REPORTDETAILS['PRODUCTNAME'].toString()),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Report Order Date :", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(REPORTDETAILS['REPORTDATE'].toString()),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          )),
                    if (COMMERCIALDETAILS != null)
                      Text(
                        "Details",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    if (COMMERCIALDETAILS != null)
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name: ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(COMMERCIALDETAILS['NAME'].toString()),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "Phone Number: ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(COMMERCIALDETAILS['PHONE_NUMBER'].toString()),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "E-mail: ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(COMMERCIALDETAILS['EMAIL'].toString()),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "Registration Date: ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(DateFormat('d MMM y')
                                      .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(COMMERCIALDETAILS['REGISTRATION_DATE']))
                                      .toString()),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          )),

                    if (SUMMARY_OF_PERFORMANCE != null)
                      Text(
                        "Summary Of Performance",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                    if (SUMMARY_OF_PERFORMANCE != null)
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Institution\nName',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Facilities\nCount',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Performing\nFacilities',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Non Performing\nFacilities',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Approved\nAmount',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Account\nBalance',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Overdue\nAmount',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                          ],
                          rows: <DataRow>[
                            for (var SUMMARY in SUMMARY_OF_PERFORMANCE)
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(SUMMARY['PROVIDER_SOURCE'].toString())),
                                  DataCell(Text(SUMMARY['FACILITIES_COUNT'].toString())),
                                  DataCell(Text(SUMMARY['PERFORMING_FACILITY'].toString())),
                                  DataCell(Text(SUMMARY['NONPERFORMING_FACILITY'].toString())),
                                  DataCell(Text(SUMMARY['APPROVED_AMOUNT'].toString())),
                                  DataCell(Text(SUMMARY['ACCOUNT_BALANCE'].toString())),
                                  DataCell(Text(SUMMARY['OVERDUE_AMOUNT'].toString())),
                                ],
                              ),
                          ],
                        ),
                      ),

                    SizedBox(
                      height: 15,
                    ),
                    // if (loadedData)
                    //   if (dataList.length > 0)
                    //     for (dynamic items in dataList)
                    //       Container(
                    //         width: MediaQuery.of(context).size.width * 0.5,
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             Text("Name: " + items['NAME'].toString()),
                    //             Text("CONFIDENCESCORE: " + items['CONFIDENCESCORE'].toString()),
                    //             Text("BUREAUID: " + items['BUREAUID'].toString()),
                    //             Text("BUSINESSREGNO: " + items['BUSINESSREGNO'].toString()),
                    //             SizedBox(
                    //               height: 20,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                  ],
                ),
              ),
            ),
    );
  }
}
