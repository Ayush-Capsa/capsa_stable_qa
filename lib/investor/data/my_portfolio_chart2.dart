import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SplineSeriesChart extends StatelessWidget {
  final List<TimeSeriesSales2> seriesList;

  SplineSeriesChart(this.seriesList, {Key key}) : super(key: key);

  double min = 0, max = -20;

  double interval;

  void calculateMinimumMaximum() {
    capsaPrint('\n\nCalculate\n\n');
    for (int i = 0; i < seriesList.length; i++) {
      if (seriesList[i].sales > max) {
        max = seriesList[i].sales;
      }
    }

    // if((max-min)>1000){
    //
    // }

    //max = 500;

    max = ((max) / 250).ceil() * 250.0;
    if (max < 5000)
      max = max + 250;
    else
      max = max + 1000;

    //max = 500;

    interval = (max / 80) * 10;

    interval = ((interval / 10).floor()) * 10.0;

    capsaPrint('$min $max $interval');
  }

  Map<String, String> months = {
    '1': 'Jan',
    '2': 'Feb',
    '3': 'Mar',
    '4': 'Apr',
    '5': 'May',
    '6': 'June',
    '7': 'July',
    '8': 'Aug',
    '9': 'Sept',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec',
  };

  String label(String mon) {
    var now = DateTime.now();
    return '${months[mon]}\'${now.year % 2000}';
  }

  @override
  Widget build(BuildContext context) {
    calculateMinimumMaximum();
    return Stack(
      children: [
        SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(
              //isVisible: Responsive.isMobile(context) ? false : true,
              majorGridLines: MajorGridLines(width: 0),
              //labelRotation: Responsive.isMobile(context) ? 24 : 0,
            ),
            primaryYAxis: CategoryAxis(
              name: 'yAxis2',
              isVisible: false,
              // majorGridLines: MajorGridLines(width: 0),
              title: Responsive.isMobile(context)
                  ? null
                  : AxisTitle(text: 'Net Gains (in thousands)'),
              // maximum: max,
              // minimum: 0,
              // interval: interval,
              // axisLabelFormatter: (value){
              //     return ChartAxisLabel('${value.text}k',TextStyle(
              //         fontFamily: 'Roboto',
              //         fontStyle: FontStyle.normal,
              //         fontWeight: FontWeight.normal,
              //         fontSize: 12));
              // },
            ),
            axes: <ChartAxis>[
              NumericAxis(
                  name: 'xAxis',
                  opposedPosition: true,
                  title: AxisTitle(text: 'Secondary X Axis')),
              NumericAxis(
                  name: 'yAxis',
                  isVisible: Responsive.isMobile(context) ? false : true,
                  majorGridLines: MajorGridLines(width: 0),
                  opposedPosition: true,
                  title: AxisTitle(text: 'Percentage Gain')),
              NumericAxis(
                name: 'yAxis1',
                //isVisible: Responsive.isMobile(context) ? false : true,
                opposedPosition: false,
                maximum: max,
                minimum: 0,
                interval: interval,
                majorGridLines: MajorGridLines(width: 0),
                axisLabelFormatter: (value) {
                  return ChartAxisLabel(
                      '${value.text}k',
                      TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 12));
                },
                title: Responsive.isMobile(context)
                    ? null
                    : AxisTitle(text: 'Net Gains (in thousands)'),
              )
            ],
            series: <ChartSeries>[
              // SplineSeries<TimeSeriesSales2, String>(
              //     name: 'Net Gains',
              //     dataSource: seriesList,
              //     xValueMapper: (TimeSeriesSales2 sales, _) =>
              //         label(sales.time),
              //     color: HexColor('#0E9CFF'),
              //     yValueMapper: (TimeSeriesSales2 sales, _) => sales.sales,
              //     dataLabelMapper: (TimeSeriesSales2 sales, _) =>
              //         formatCurrency(sales.sales),
              //     enableTooltip: true,
              //     dataLabelSettings: const DataLabelSettings(
              //       isVisible: false,
              //     ),
              //     markerSettings: MarkerSettings(isVisible: true)),
              SplineSeries<TimeSeriesSales2, String>(
                name: 'Net Gain',
                dataSource: seriesList,
                xValueMapper: (TimeSeriesSales2 sales, _) => label(sales.time),
                color: HexColor('#0E9CFF'),
                yValueMapper: (TimeSeriesSales2 sales, _) => sales.sales,
                dataLabelMapper: (TimeSeriesSales2 sales, _) =>
                    formatCurrency(sales.sales),
                enableTooltip: true,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                ),
                yAxisName: 'yAxis1',
                markerSettings: const MarkerSettings(isVisible: true),
              ),
              SplineSeries<TimeSeriesSales2, String>(
                  name: 'Percentage Gain',
                  dataSource: seriesList,
                  xValueMapper: (TimeSeriesSales2 sales, _) =>
                      label(sales.time),
                  color: HexColor('#EB5757'),
                  yValueMapper: (TimeSeriesSales2 sales, _) => sales.per,
                  dataLabelMapper: (TimeSeriesSales2 sales, _) =>
                      sales.per.toString(),
                  enableTooltip: true,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: false,
                  ),
                  markerSettings: const MarkerSettings(isVisible: true),
                  yAxisName: 'yAxis'),
            ]),
        // SfCartesianChart(
        //     primaryXAxis: CategoryAxis(
        //       isVisible: Responsive.isMobile(context)?false:true,
        //       majorGridLines: MajorGridLines(width: 0),
        //     ),
        //     primaryYAxis: CategoryAxis(
        //       isVisible: Responsive.isMobile(context)?false:true,
        //       majorGridLines: MajorGridLines(width: 0),
        //     ),
        //     axes: <ChartAxis>[
        //       NumericAxis(
        //           name: 'xAxis',
        //           opposedPosition: true,
        //           title: AxisTitle(
        //               text: 'Secondary X Axis'
        //           )
        //       ),
        //       NumericAxis(
        //           name: 'yAxis',
        //           opposedPosition: true,
        //           title: AxisTitle(
        //               text: 'Secondary Y Axis'
        //           )
        //       )
        //     ],
        //     series: <ChartSeries>[
        //       SplineSeries<TimeSeriesSales2, String>(
        //           dataSource: seriesList,
        //           xValueMapper: (TimeSeriesSales2 sales, _) =>
        //               label(sales.time),
        //           color: HexColor('#0E9CFF'),
        //           yValueMapper: (TimeSeriesSales2 sales, _) => sales.sales,
        //           dataLabelMapper: (TimeSeriesSales2 sales, _) =>
        //               formatCurrency(sales.sales),
        //           dataLabelSettings: const DataLabelSettings(
        //             isVisible: true,
        //           ),
        //           markerSettings: MarkerSettings(isVisible: true)),
        //       // SplineSeries<TimeSeriesSales2, String>(
        //       //   dataSource: seriesList,
        //       //   xValueMapper: (TimeSeriesSales2 sales, _) => label(sales.time),
        //       //   color: HexColor('#EB5757'),
        //       //   yValueMapper: (TimeSeriesSales2 sales, _) => sales.per,
        //       //   dataLabelMapper: (TimeSeriesSales2 sales, _) =>
        //       //       sales.per.toString(),
        //       //   dataLabelSettings: const DataLabelSettings(
        //       //     isVisible: true,
        //       //   ),
        //       // )
        //     ]),
        //
        // SfCartesianChart(
        //     primaryXAxis: CategoryAxis(
        //         isVisible: Responsive.isMobile(context)?false:true,
        //         majorGridLines: MajorGridLines(width: 0),
        //         labelStyle: TextStyle(color: Colors.transparent)
        //     ),
        //     primaryYAxis: CategoryAxis(
        //       isVisible: Responsive.isMobile(context)?false:true,
        //       majorGridLines: MajorGridLines(width: 0),
        //       opposedPosition: true,
        //     ),
        //     axes: [
        //       NumericAxis(
        //           name:'xAxis',
        //           isVisible: false,
        //           opposedPosition: true
        //       ),
        //       NumericAxis(
        //           name:'yAxis',
        //           //title: AxisTitle(text:'Secondary y-axis'),
        //           opposedPosition: true
        //       )
        //     ],
        //     series: <ChartSeries>[
        //       SplineSeries<TimeSeriesSales2, String>(
        //           dataSource: seriesList,
        //           xValueMapper: (TimeSeriesSales2 sales, _) => label(sales.time),
        //           color: HexColor('#EB5757'),
        //
        //           yValueMapper: (TimeSeriesSales2 sales, _) => sales.per,
        //           dataLabelMapper: (TimeSeriesSales2 sales, _) => sales.per.toString(),
        //           dataLabelSettings: const DataLabelSettings(
        //             isVisible: true,
        //
        //           ),
        //
        //           markerSettings: MarkerSettings(isVisible: true)
        //       )
        //       // SplineSeries<TimeSeriesSales2, String>(
        //       //     dataSource: seriesList,
        //       //     xValueMapper: (TimeSeriesSales2 sales, _) => label(sales.time),
        //       //     color: HexColor('#EB5757'),
        //       //
        //       //     yValueMapper: (TimeSeriesSales2 sales, _) => double.parse(sales.per.toString()),
        //       //     dataLabelMapper: (TimeSeriesSales2 sales, _) => sales.per.toString(),
        //       //     dataLabelSettings: const DataLabelSettings(
        //       //       isVisible: true,
        //       //
        //       //     ),
        //       //     // xAxisName: 'xAxis',
        //       //     //
        //       //     // //Bind the y-axis to secondary y-axis.
        //       //     // yAxisName: 'yAxis',
        //       //
        //       //     markerSettings: MarkerSettings(isVisible: true)
        //       // )
        //       // SplineSeries<TimeSeriesSales2, String>(
        //       //     dataSource: seriesList,
        //       //     xValueMapper: (TimeSeriesSales2 sales, _) => label(sales.time),
        //       //     color: Colors.green,
        //       //
        //       //     yValueMapper: (TimeSeriesSales2 sales, _) => sales.per,
        //       //     dataLabelMapper: (TimeSeriesSales2 sales, _) => sales.per.toString(),
        //       //     dataLabelSettings: const DataLabelSettings(
        //       //       isVisible: true,
        //       //
        //       //     ),
        //       //
        //       //     markerSettings: MarkerSettings(isVisible: true)
        //       // )
        //     ]
        // ),
      ],
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales2 {
  final String time;
  final num sales;
  final num per;

  TimeSeriesSales2(this.time, this.sales, this.per);
}
