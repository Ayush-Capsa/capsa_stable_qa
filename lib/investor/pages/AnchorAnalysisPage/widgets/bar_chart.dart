import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/src/intl/number_format.dart';

class BarChart extends StatefulWidget {
  double scale;
  BarChart({Key key, this.scale = 1}) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  List<RevenueData> _chartData;

  TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SfCartesianChart(
      isTransposed: true,
      // title: ChartTitle(text: 'Continent wise Revenue - 2021'),
      legend: Legend(isVisible: false),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        BarSeries<RevenueData, String>(
            name: 'Revenue',
            dataSource: _chartData,
            xValueMapper: (RevenueData Revenue, _) => Revenue.year,
            yValueMapper: (RevenueData Revenue, _) => Revenue.revenue,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: GoogleFonts.poppins(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 12 * widget.scale)),
            enableTooltip: true)
      ],
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        isVisible: false,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        //numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
        //title: AxisTitle(text: 'Revenue in billions of U.S. Dollars')),
      ),
    )));
  }

  List<RevenueData> getChartData() {
    final List<RevenueData> chartData = [
      RevenueData('2017', 21),
      RevenueData('2018', 27),
      RevenueData('2019', 34),
      RevenueData('2020', 23),
      RevenueData('2021', 43),
    ];
    return chartData;
  }
}

class RevenueData {
  RevenueData(this.year, this.revenue);
  final String year;
  final double revenue;
}
