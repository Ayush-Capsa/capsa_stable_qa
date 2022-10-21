import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';


class SplineSeriesChart extends StatelessWidget {
  final List<TimeSeriesSales2> seriesList;

  const SplineSeriesChart(this.seriesList,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[

          SplineSeries<TimeSeriesSales2, String>(
              dataSource: seriesList,
              xValueMapper: (TimeSeriesSales2 sales, _) => sales.time,
              yValueMapper: (TimeSeriesSales2 sales, _) => sales.sales
          )
        ]
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales2 {
  final String time;
  final num sales;

  TimeSeriesSales2(this.time, this.sales);
}
