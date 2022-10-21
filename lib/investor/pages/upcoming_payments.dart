import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/investor/data/DonutPieChart.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:capsa/common/constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AllUpcomingPaymentsPage extends StatefulWidget {
  const AllUpcomingPaymentsPage({Key key}) : super(key: key);

  @override
  State<AllUpcomingPaymentsPage> createState() =>
      _AllUpcomingPaymentsPageState();
}

class _AllUpcomingPaymentsPageState extends State<AllUpcomingPaymentsPage> {
  int _state = 1;

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ProfileProvider _profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    _profileProvider.queryPortfolioData2();
    _profileProvider.queryFewData();
    _profileProvider.queryBankTransaction();
  }

  List _upPmtList = [];
  List _payDoneList = [];

  @override
  Widget build(BuildContext context) {
    ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context);
    var upPmt = _profileProvider.portfolioData.up_pymt;
    var _text2 = '';
    var _text3 = '';
    var _text5 = '';
    var _text4 = 'You do not have any payment';
    DateTime today = DateTime.now();
    _upPmtList = [];
    List _tmpUpPmtList = [];

    String _text = '0';

    print('Length : ${upPmt.length}');

    if (upPmt != null && upPmt.length > 0) {
      print('Pass 1');
      _tmpUpPmtList = upPmt;
      if (_state == 1) {
        // _text2 = "Payment due this week";
        // _text3 = "of your Total Payment is\n paid this week";
        // _text4 = "You do not have any payment\n due this week";
        //
        // var fDate = findFirstDateOfTheWeek(today);
        // var lDate = findLastDateOfTheWeek(today);
        //
        // num totalReceived = 0;
        // num totalDiscount = 0;
        //
        // for (var i = 0; i < _tmpUpPmtList.length; i++) {
        //   var upMt = _tmpUpPmtList[i];
        //   var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(upMt['due_dt']);
        //
        //   if (fDate.isBefore(dueDt) && lDate.isAfter(dueDt)) {
        //     totalDiscount = totalDiscount + num.parse(upMt['discount_val'].toString());
        //
        //     if (upMt['payment_status'] == 1) {
        //       _payDoneList.add(upPmt);
        //       totalReceived = totalReceived + num.parse(upMt['discount_val'].toString());
        //     } else {
        //       _upPmtList.add(upPmt);
        //     }
        //   }
        // }
        //
        // if (totalDiscount > 0) _text = ((totalReceived / totalDiscount) * 100).toStringAsFixed(0);
        _text2 = "Payments due between 0 and 7 days";
        _text3 =
            "of your Total Payment is due \nto be paid between 0 and 7 days";
        _text4 = "You do not have any payment due between 0 and 7 days";

        print('Pass 2');

        var fDate = findFirstDateOfTheWeek(today);
        var lDate = findLastDateOfTheWeek(today);

        num totalReceived = 0;
        num totalDiscount = 0;

        // for (var i = 0; i < _tmpUpPmtList.length; i++) {
        //   var upMt = _tmpUpPmtList[i];
        //   print('Due Date:');
        //   var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        //       .parse(upMt['due_dt']);
        //   //print('\nDue Date: ${dueDt}');
        //
        //   //if (fDate.isBefore(dueDt) && lDate.isAfter(dueDt))
        //   print('\nDifference in date : ${DateTime.now().difference(dueDt).inDays}');
        //   if(DateTime.now().difference(dueDt).inDays.abs()<=7){
        //     totalDiscount = totalDiscount +
        //         num.parse(upMt['discount_val'].toString());
        //
        //     if (upMt['payment_status'] == 1) {
        //       _payDoneList.add(upPmt);
        //       totalReceived = totalReceived +
        //           num.parse(upMt['discount_val'].toString());
        //     } else {
        //       _upPmtList.add(upPmt);
        //     }
        //   }
        // }
        //
        // if (totalDiscount > 0) {
        //   _text = ((_upPmtList.length /
        //       _tmpUpPmtList.length) *
        //       100)
        //       .toStringAsFixed(0);
        // }
        print('Pass 3');

        if (_profileProvider.portfolioData.invIn1Week != null) {
          for (var i = 0;
              i < _profileProvider.portfolioData.invIn1Week.length;
              i++) {
            var upMt = _profileProvider.portfolioData.invIn1Week[i];

            print(
                'Date : ${_profileProvider.portfolioData.invIn1Week[i]['due_dt']} ${DateFormat('MMMd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(_profileProvider.portfolioData.invIn1Week[i]['due_dt'])).toString()}');

            //print('Upcoming payment: ${_profileProvider.portfolioData.invIn1Week[1]} $upMt');

            var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .parse(upMt['due_dt']);

            //print('Pass 1');

            //print('\nDifference in date : ${dueDt.difference(DateTime.now()).inDays}');

            if (true) {
              totalDiscount = totalDiscount + upMt['discount_val'];

              //print('Pass 2');

              if (upMt['payment_status'].toString() == '1') {
                _payDoneList.add(upMt);
                totalReceived = totalReceived + upMt['discount_val'];
                //print('Pass 3');
              } else {
                _upPmtList.add(upMt);
                //print('Pass 4');
              }
            }
            //print('Pass 5');
          }
        }
        print('Pass 4');

        _text = double.parse(_profileProvider.portfolioData.perIn1Week != null
                ? _profileProvider.portfolioData.perIn1Week.toString()
                : '0.0')
            .toStringAsFixed(0);
      } else if (_state == 2) {
        _text2 = "Payments due between 8 and 30 days";
        _text3 =
            "of your Total Payment is due\nto be paid between 8 and 30 days";
        _text4 = "You do not have any payment due between 8 and 30 days";
        var beginningNextMonth = (today.month < 12)
            ? DateTime(today.year, today.month + 1, 1)
            : DateTime(today.year + 1, 1, 1);
        var lastDay = beginningNextMonth.subtract(const Duration(days: 1));
        num totalReceived = 0;
        num totalDiscount = 0;

        // for (var i = 0; i < _tmpUpPmtList.length; i++) {
        //   var upMt = _tmpUpPmtList[i];
        //   var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        //       .parse(upMt['due_dt']);
        //
        //   //print('\nDifference in date : ${dueDt.difference(DateTime.now()).inDays}');
        //
        //   if (DateTime.now().difference(dueDt).inDays.abs()>7 && DateTime.now().difference(dueDt).inDays.abs()<=30) {
        //     totalDiscount = totalDiscount + upMt['discount_val'];
        //
        //     if (upMt['payment_status'] == 1) {
        //       _payDoneList.add(upPmt);
        //       totalReceived = totalReceived + upMt['discount_val'];
        //     } else {
        //       _upPmtList.add(upPmt);
        //     }
        //   }
        // }
        if (_profileProvider.portfolioData.invIn1Month != null) {
          for (var i = 0;
              i < _profileProvider.portfolioData.invIn1Month.length;
              i++) {
            var upMt = _profileProvider.portfolioData.invIn1Month[i];
            var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .parse(upMt['due_dt']);

            //print('\nDifference in date : ${dueDt.difference(DateTime.now()).inDays}');

            if (true) {
              totalDiscount = totalDiscount + upMt['discount_val'];

              // if (upMt['payment_status'] == 1) {
              //   _payDoneList.add(upPmt);
              //   totalReceived = totalReceived + upMt['discount_val'];
              // } else {
              //   _upPmtList.add(upPmt);
              // }
              if (upMt['payment_status'].toString() == '1') {
                _payDoneList.add(upMt);
                totalReceived = totalReceived + upMt['discount_val'];
                //print('Pass 3');
              } else {
                _upPmtList.add(upMt);
                //print('Pass 4');
              }
            }
          }
        }

        _text = double.parse(_profileProvider.portfolioData.perIn1Month != null
                ? _profileProvider.portfolioData.perIn1Month.toString()
                : '0.0')
            .toStringAsFixed(0);

        // if (totalDiscount > 0) {
        //   _text = ((_upPmtList.length /
        //       _tmpUpPmtList.length) *
        //           100)
        //       .toStringAsFixed(0);
        // }
      } else if (_state == 3) {
        _text2 = "Payments due between 31 and 60 days";
        _text3 =
            "of your Total Payment is due \nto be paid between 31 and 60 days";
        _text4 = "You do not have any payment due between 31 and 60 days";
        num totalReceived = 0;
        num totalDiscount = 0;

        var newDate = DateTime(today.year, today.month + 2, today.day);

        // for (var i = 0; i < _tmpUpPmtList.length; i++) {
        //   var upMt = _tmpUpPmtList[i];
        //   var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        //       .parse(upMt['due_dt']);
        //
        //   if ((DateTime.now().difference(dueDt).inDays.abs()>30 && DateTime.now().difference(dueDt).inDays.abs()<=60)) {
        //     totalDiscount = totalDiscount + upMt['discount_val'];
        //
        //     if (upMt['payment_status'] == 1) {
        //       _payDoneList.add(upPmt);
        //       totalReceived = totalReceived + upMt['discount_val'];
        //     } else {
        //       _upPmtList.add(upPmt);
        //     }
        //   }
        // }
        // if (totalDiscount > 0) {
        //   _text = ((_upPmtList.length /
        //       _tmpUpPmtList.length) *
        //       100)
        //       .toStringAsFixed(0);
        // }

        if (_profileProvider.portfolioData.invIn2Month != null) {
          for (var i = 0;
              i < _profileProvider.portfolioData.invIn2Month.length;
              i++) {
            var upMt = _profileProvider.portfolioData.invIn2Month[i];
            var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .parse(upMt['due_dt']);

            //print('\nDifference in date : ${dueDt.difference(DateTime.now()).inDays}');

            if (true) {
              totalDiscount = totalDiscount + upMt['discount_val'];

              if (upMt['payment_status'].toString() == '1') {
                _payDoneList.add(upMt);
                totalReceived = totalReceived + upMt['discount_val'];
                //print('Pass 3');
              } else {
                _upPmtList.add(upMt);
                //print('Pass 4');
              }
            }
          }
        }

        _text = double.parse(_profileProvider.portfolioData.perIn2Month != null
                ? _profileProvider.portfolioData.perIn2Month.toString()
                : '0.0')
            .toStringAsFixed(0);
      } else if (_state == 4) {
        _text2 = "Payments due after 60 days";
        _text3 = "of your Total Payment is due \nto be paid after 60 days";
        _text4 = "You do not have any payment due after 60 days";
        num totalReceived = 0;
        num totalDiscount = 0;

        var newDate = DateTime(today.year, today.month + 6, today.day);

        // for (var i = 0; i < _tmpUpPmtList.length; i++) {
        //   var upMt = _tmpUpPmtList[i];
        //   var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        //       .parse(upMt['due_dt']);
        //
        //   if (DateTime.now().difference(dueDt).inDays.abs()>60 && DateTime.now().difference(dueDt).inDays.abs()<=90) {
        //     totalDiscount = totalDiscount + upMt['discount_val'];
        //
        //     if (upMt['payment_status'] == 1) {
        //       _payDoneList.add(upPmt);
        //       totalReceived = totalReceived + upMt['discount_val'];
        //     } else {
        //       _upPmtList.add(upPmt);
        //     }
        //   }
        // }
        // if (totalDiscount > 0) {
        //   _text = ((_upPmtList.length /
        //       _tmpUpPmtList.length) *
        //       100)
        //       .toStringAsFixed(0);
        // }
        if (_profileProvider.portfolioData.invIn6Month != null) {
          for (var i = 0;
              i < _profileProvider.portfolioData.invIn6Month.length;
              i++) {
            var upMt = _profileProvider.portfolioData.invIn6Month[i];

            var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .parse(upMt['due_dt']);

            //print('\nDifference in date : ${dueDt.difference(DateTime.now()).inDays}');

            if (true) {
              totalDiscount = totalDiscount + upMt['discount_val'];

              if (upMt['payment_status'].toString() == '1') {
                _payDoneList.add(upMt);
                totalReceived = totalReceived + upMt['discount_val'];
                //print('Pass 3');
              } else {
                _upPmtList.add(upMt);
                //print('Pass 4');
              }
            }
          }
        }
        _text = double.parse(_profileProvider.portfolioData.perIn6Month != null
                ? _profileProvider.portfolioData.perIn6Month.toString()
                : '0.0')
            .toStringAsFixed(0);
      }

      // else if (_state == 2) {
      //   _text2 = "Payment due this month";
      //   _text3 = "of your Total Payment is \npaid this month";
      //   _text4 = "You do not have any payment \ndue this months";
      //   var beginningNextMonth = (today.month < 12) ? new DateTime(today.year, today.month + 1, 1) : new DateTime(today.year + 1, 1, 1);
      //   var lastDay = beginningNextMonth.subtract(new Duration(days: 1));
      //   num totalReceived = 0;
      //   num totalDiscount = 0;
      //
      //   for (var i = 0; i < _tmpUpPmtList.length; i++) {
      //     var upMt = _tmpUpPmtList[i];
      //     var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(upMt['due_dt']);
      //
      //     if (beginningNextMonth.isBefore(dueDt) && lastDay.isAfter(dueDt)) {
      //       totalDiscount = totalDiscount + upMt['discount_val'];
      //
      //       if (upMt['payment_status'] == 1) {
      //         _payDoneList.add(upPmt);
      //         totalReceived = totalReceived + upMt['discount_val'];
      //       } else {
      //         _upPmtList.add(upPmt);
      //       }
      //     }
      //   }
      //   if (totalDiscount > 0) _text = ((totalReceived / num.parse(totalDiscount.toStringAsFixed(2))) * 100).toStringAsFixed(0);
      // } else if (_state == 3) {
      //   _text2 = "Payment due in 2 months";
      //   _text3 = "of your Total Payment is \npaid in 2 month";
      //   _text4 = "You do not have any payment \ndue in 2 months";
      //   num totalReceived = 0;
      //   num totalDiscount = 0;
      //
      //   var newDate = new DateTime(today.year, today.month + 2, today.day);
      //
      //   for (var i = 0; i < _tmpUpPmtList.length; i++) {
      //     var upMt = _tmpUpPmtList[i];
      //     var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(upMt['due_dt']);
      //
      //     if (today.isBefore(dueDt) && newDate.isAfter(dueDt)) {
      //       totalDiscount = totalDiscount + upMt['discount_val'];
      //
      //       if (upMt['payment_status'] == 1) {
      //         _payDoneList.add(upPmt);
      //         totalReceived = totalReceived + upMt['discount_val'];
      //       } else {
      //         _upPmtList.add(upPmt);
      //       }
      //     }
      //   }
      //   if (totalDiscount > 0) _text = ((totalReceived / num.parse(totalDiscount.toStringAsFixed(2))) * 100).toStringAsFixed(0);
      // } else if (_state == 4) {
      //   _text2 = "Payment due in 6 months";
      //   _text3 = "of your Total Payment is \npaid in 6 month";
      //   _text4 = "You do not have any payment\n due in 6 months";
      //   num totalReceived = 0;
      //   num totalDiscount = 0;
      //
      //   var newDate = new DateTime(today.year, today.month + 6, today.day);
      //
      //   for (var i = 0; i < _tmpUpPmtList.length; i++) {
      //     var upMt = _tmpUpPmtList[i];
      //     var dueDt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(upMt['due_dt']);
      //
      //     if (today.isBefore(dueDt) && newDate.isAfter(dueDt)) {
      //       totalDiscount = totalDiscount + upMt['discount_val'];
      //
      //       if (upMt['payment_status'] == 1) {
      //         _payDoneList.add(upPmt);
      //         totalReceived = totalReceived + upMt['discount_val'];
      //       } else {
      //         _upPmtList.add(upPmt);
      //       }
      //     }
      //   }
      //   if (totalDiscount > 0) _text = ((totalReceived / num.parse(totalDiscount.toStringAsFixed(2))) * 100).toStringAsFixed(0);
      // }
      // _upPmtList = _tmpUpPmtList;

    }

    final data = [
      new LinearSales(2021, 100 - int.parse(_text)),
      new LinearSales(2021, int.parse(_text)),
      // new LinearSales(0, int.parse(_text )),
    ];
    List<charts.Series> seriesList = [
      charts.Series<LinearSales, int>(
        id: 'TotalPayment',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!Responsive.isMobile(context))
              SizedBox(
                height: 22,
              ),
            TopBarWidget("Upcoming Payments", ""),
            if (!Responsive.isMobile(context))
              SizedBox(
                height: 15,
              ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15000000596046448),
                      offset: Offset(0, -2),
                      blurRadius: 4)
                ],
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 251, 255, 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _textWidget1(state: 1, text: "Due in 0-7 Days"),
                          SizedBox(
                              width: Responsive.isMobile(context) ? 10 : 45),
                          _textWidget1(state: 2, text: "Due in 8-30 Days"),
                          SizedBox(
                              width: Responsive.isMobile(context) ? 10 : 45),
                          _textWidget1(state: 3, text: "Due in 31-60 Days"),
                          SizedBox(
                              width: Responsive.isMobile(context) ? 10 : 45),
                          _textWidget1(state: 4, text: "Due in 61+ Days"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            OrientationSwitcher(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(0),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.10000000149011612),
                                offset: Offset(10, 10),
                                blurRadius: 20)
                          ],
                          color: Color.fromRGBO(245, 251, 255, 1),
                          // image: DecorationImage(image: AssetImage('assets/images/Frame164.png'), fit: BoxFit.fitWidth),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_text != '0')
                              SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: DonutPieChart(seriesList,
                                      animate: true, text: _text)),
                            if (_text != '0')
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      _text + '%',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 152, 219, 1),
                                          // fontFamily: 'Poppins',
                                          fontSize: 14,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      _text3,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          fontSize: 14,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Text(_text4,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      // fontFamily: 'Poppins',
                                      fontSize: 14,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1)),
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.10000000149011612),
                                  offset: Offset(10, 10),
                                  blurRadius: 20)
                            ],
                            color: Color.fromRGBO(245, 251, 255, 1),
                            // image: DecorationImage(image: AssetImage('assets/images/Frame164.png'), fit: BoxFit.fitWidth),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 36),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(
                                            0, 0, 0, 0.10000000149011612),
                                        offset: Offset(10, 10),
                                        blurRadius: 20)
                                  ],
                                  color: Color.fromRGBO(245, 251, 255, 1),
                                  // image: DecorationImage(image: AssetImage('assets/images/Frame160.png'), fit: BoxFit.fitWidth),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                child: Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      _text2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: Responsive.isMobile(context)
                                              ? 14
                                              : 18,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 32),
                              Container(
                                decoration: BoxDecoration(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    if (_upPmtList.length == 0)
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(_text4,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    51, 51, 51, 1),
                                                // fontFamily: 'Poppins',
                                                fontSize: 14,
                                                letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1)),
                                      ),
                                    if (_upPmtList.length > 0)
                                      for (var i = 0;
                                          i < _upPmtList.length;
                                          i++)
                                        Builder(builder: (context) {
                                          var payment = _upPmtList[i];
                                          String cnmae =
                                              payment['company_name'];
                                          return Container(
                                            height: Responsive.isMobile(context)
                                                ? 100
                                                : 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/Frame 156.png'),
                                                  fit: BoxFit.cover),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical:
                                                    Responsive.isMobile(context)
                                                        ? 14
                                                        : 16),
                                            margin: EdgeInsets.only(
                                                bottom: 10, top: 2),
                                            child: OrientationSwitcher(
                                              mainAxisAlignment:
                                                  Responsive.isMobile(context)
                                                      ? MainAxisAlignment.start
                                                      : MainAxisAlignment
                                                          .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  cnmae.truncateTo(35),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          51, 51, 51, 1),
                                                      fontSize: 16,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                                SizedBox(width: 4),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            '₦',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        51,
                                                                        51,
                                                                        51,
                                                                        1),
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height: 1),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            formatCurrency(payment[
                                                                'invoice_value']),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        51,
                                                                        51,
                                                                        51,
                                                                        1),
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height: 1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            Responsive.isMobile(
                                                                    context)
                                                                ? 15
                                                                : 20),
                                                    SizedBox(height: 8),
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            (DateFormat('MMMd')
                                                                .format(DateFormat(
                                                                        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                                    .parse(payment[
                                                                        'due_dt']))
                                                                .toString()),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        51,
                                                                        51,
                                                                        51,
                                                                        1),
                                                                fontSize: 16,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height: 1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _textWidget1({state: 1, text: ''}) {
    var active = (state == _state) ? true : false;

    return InkWell(
      onTap: () {
        setState(() {
          _state = state;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[],
              ),
            ),
            SizedBox(width: 4),
            Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: !active
                      ? Color.fromRGBO(130, 130, 130, 1)
                      : Color.fromRGBO(0, 152, 219, 1),
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget invBottomMenu(context) {
    List menus = [
      {
        'title': 'This Week',
      },
      {
        'title': 'This months',
      },
      {
        'title': '2 months',
      },
      {
        'title': '6 months',
      },
    ];

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 68,
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 251, 255, 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (var i = 0; i < menus.length; i++)
            Builder(builder: (context) {
              var menu = menus[i];

              if ((++i) != _state) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Color.fromRGBO(245, 251, 255, 1),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Image.asset(
                              //   menu['icon'],
                              //   height: 20,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(0, 152, 219, 1),
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Image.asset(
                              //   menu['activeIcon'],
                              //   height: 20,
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          menu['title'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
          // SizedBox(width: 25,),
        ],
      ),
    );
  }
}
