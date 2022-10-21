import 'package:capsa/functions/hexcolor.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final String text;
  final bool animate;

  DonutPieChart(this.seriesList, {this.text, this.animate});

  // factory DonutPieChart.withSampleData() {
  //   return new DonutPieChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        new charts.PieChart(seriesList,
            animate: animate,
            animationDuration: Duration(milliseconds: 500),
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                // changedListener: _onSelectionChanged,
              )
            ],
            defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 18,
            )),
        if (text != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text + "%",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: HexColor('#0098DB')),
                  ),
                  Text(
                     "of Total Payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0, color: HexColor('#333333')),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'TotalPayment',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
