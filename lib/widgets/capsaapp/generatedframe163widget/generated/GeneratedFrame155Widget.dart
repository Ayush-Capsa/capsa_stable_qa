import 'package:capsa/investor/data/DonutPieChart.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GeneratedFrame155Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context);

    var upPmt = _profileProvider.portfolioData.up_pymt;

    double value = 0.0;

    if (upPmt != null && upPmt.length > 0 && upPmt[0] != null && upPmt[0]['payment_status'] == 0) value+=double.parse(upPmt[0]['invoice_value'].toString());
    if (upPmt != null && upPmt.length > 1 && upPmt[1] != null && upPmt[1]['payment_status'] == 0) value+=double.parse(upPmt[1]['invoice_value'].toString());
    if (upPmt != null && upPmt.length > 2 && upPmt[2] != null && upPmt[2]['payment_status'] == 0) value+=double.parse(upPmt[2]['invoice_value'].toString());
    if (upPmt != null && upPmt.length > 3 && upPmt[3] != null && upPmt[3]['payment_status'] == 0) value+=double.parse(upPmt[3]['invoice_value'].toString());




    String _text = ((value /  _profileProvider.portfolioData.totalUpcomingPayments) * 100).toStringAsFixed(0) ;

    final data = [
      new LinearSales(2021, 100 - int.parse(_text)),
      new LinearSales(2021, int.parse(_text)),
      
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
      width: 200.0,
      height: 200.0,
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        Positioned(
          left: 0.0,
          top: 0.0,
          right: null,
          bottom: null,
          width: 200.0,
          height: 200.0,
          child: DonutPieChart(seriesList,animate: true,text : _text),
        ),

        // Positioned(
        //   left: 0.0,
        //   top: 0.0,
        //   right: null,
        //   bottom: null,
        //   width: 150.0,
        //   height: 150.0,
        //   child: GeneratedEllipse5Widget(),
        // ),
        // Positioned(
        //   left: 0.0,
        //   top: 0.0,
        //   right: null,
        //   bottom: null,
        //   width: 150.0,
        //   height: 150.0,
        //   child: GeneratedEllipse4Widget(),
        // ),
        //
        //
        //
        //
        //
        //
        // Positioned(
        //   left: 30.0,
        //   top: 56.0,
        //   right: null,
        //   bottom: null,
        //   width: 86.0,
        //   height: 38.0,
        //   child: GeneratedFrame162Widget(),
        // )
      ]),
    );
  }
}
