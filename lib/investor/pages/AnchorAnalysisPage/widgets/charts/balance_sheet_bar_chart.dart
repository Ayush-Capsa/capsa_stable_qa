import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/src/intl/number_format.dart';

class BalanceSheetBarChart extends StatefulWidget {
  Color color;
  double scale;
  BalanceSheetModel balance;
  dynamic yearsPresent;
  BalanceSheetBarChart(
      {Key key, @required this.color, this.scale = 1, @required this.balance,@required this.yearsPresent})
      : super(key: key);

  @override
  State<BalanceSheetBarChart> createState() => _BalanceSheetBarChartState();
}

class _BalanceSheetBarChartState extends State<BalanceSheetBarChart> {
  List<RevenueData> _chartData = [];

  List<ChartData> chartData = <ChartData>[];

  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  double truncateNumber(double num) {
    double result = int.parse(num.toString()) / 1000;
    return double.parse(result.round().toString());
    return double.parse(result.toString().length<5?result.toString():result.toString().substring(0, 4));
  }

  void initialiseData() {
    // capsaPrint(
    //     'Bar Chart Initialised ${double.parse(widget.balance.totalAssets['2020'])} ${double.parse(widget.balance.totalNonCurrentAssets['2021'])} ${double.parse(widget.balance.totalCurrentAssets['2022'])}');
    // _chartData = [
    //   RevenueData(
    //       '2020', double.parse(widget.balance.totalLiabilities['2020'])),
    //   RevenueData(
    //       '2021', double.parse(widget.balance.totalLiabilities['2021'])),
    //   RevenueData(
    //       '2022', double.parse(widget.balance.totalLiabilities['2022'])),
    // ];

    chartData = <ChartData>[
      // ChartData(
      //     '2020',
      //     //21,32,43
      //     truncateNumber(
      //       double.parse(widget.balance.totalAssets['2020']),
      //     ),
      //     truncateNumber(
      //         double.parse(widget.balance.totalNonCurrentAssets['2020'])),
      //     truncateNumber(
      //         double.parse(widget.balance.totalCurrentAssets['2020']))),
      // ChartData(
      //     '2021',
      //     truncateNumber(
      //       double.parse(widget.balance.totalAssets['2021']),
      //     ),
      //     truncateNumber(
      //         double.parse(widget.balance.totalNonCurrentAssets['2021'])),
      //     truncateNumber(
      //         double.parse(widget.balance.totalCurrentAssets['2021']))),
      // ChartData(
      //     '2022',
      //     truncateNumber(
      //       double.parse(widget.balance.totalAssets['2022']),
      //     ),
      //     truncateNumber(
      //         double.parse(widget.balance.totalNonCurrentAssets['2022'])),
      //     truncateNumber(
      //         double.parse(widget.balance.totalCurrentAssets['2022']))),
    ];

    widget.yearsPresent.forEach((element){
      chartData.add(ChartData(
          element.toString(),
          truncateNumber(
            double.parse(widget.balance.totalAssets[element.toString()]),
          ),
          truncateNumber(
              double.parse(widget.balance.totalNonCurrentAssets[element.toString()])),
          truncateNumber(
              double.parse(widget.balance.totalCurrentAssets[element.toString()]))),);
      _chartData.add(RevenueData(element.toString(), truncateNumber(
        double.parse(widget.balance.financialDebt[element.toString()]),
      ),));

    });

    capsaPrint('Bar Chart Initialisation Finished');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialiseData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
            backgroundColor: Colors.transparent,
            enableMultiSelection: false,
            plotAreaBorderWidth: 0,
            plotAreaBorderColor: Colors.transparent,
            plotAreaBackgroundColor: Colors.transparent,
            isTransposed: false,
            // title: ChartTitle(text: 'Continent wise Revenue - 2021'),
            legend: Legend(isVisible: false),
            tooltipBehavior: _tooltipBehavior,
            primaryXAxis: CategoryAxis(
              majorGridLines: MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              //interval: 50,
              isVisible: true,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
                //title: AxisTitle(text: 'in thousands of Naira')
              //numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
              //title: AxisTitle(text: 'Revenue in billions of U.S. Dollars')),
            ),
            series: <CartesianSeries>[
              // LineSeries<RevenueData, String>(
              //     color: Colors.red,
              //     dataSource: _chartData,
              //     xValueMapper: (RevenueData Revenue, _) => Revenue.year,
              //     yValueMapper: (RevenueData Revenue, _) => Revenue.revenue,
              //   // opacity: 0.4
              // ),
              ColumnSeries<ChartData, String>(
                name: 'Total Assets',
                  dataSource: chartData,
                  width:0.6,
                  spacing:0.3,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: Color.fromRGBO(0, 152, 219, 1)),
              ColumnSeries<ChartData, String>(
                name: 'Total Liabilities',
                  dataSource: chartData,
                  width:0.6,
                  spacing:0.3,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  color: Color.fromRGBO(242, 153, 74, 1)),
              ColumnSeries<ChartData, String>(
                name: 'Equity',
                  dataSource: chartData,
                  width:0.6,
                  spacing:0.3,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  color: Color.fromRGBO(58, 192, 201, 1)),
              LineSeries<RevenueData, String>(
                  color: Colors.red,
                  name: 'Financial Debt',
                  dataSource: _chartData,
                  xValueMapper: (RevenueData Revenue, _) => Revenue.year,
                  yValueMapper: (RevenueData Revenue, _) => Revenue.revenue,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    width: 8 * widget.scale,
                    height: 8 * widget.scale,
                    color: widget.color,
                    borderColor: widget.color,
                  ),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: false,
                    textStyle: GoogleFonts.poppins(
                        fontSize: 14 * widget.scale,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(130, 130, 130, 1)),
                  ),
                  enableTooltip: true)
            ]),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2);
  final String x;
  final double y;
  final double y1;
  final double y2;
}

class RevenueData {
  RevenueData(this.year, this.revenue);
  final String year;
  final double revenue;
}
