import 'package:capsa/functions/currency_format.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/src/intl/number_format.dart';

class LineChart extends StatefulWidget {
  Color color;
  double scale;
  Map<String, String> data;
  dynamic yearsPresent;
  LineChart({Key key,@required this.color,this.scale = 1,@required this.data, @required this.yearsPresent}) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  List<RevenueData> _chartData;

  TooltipBehavior _tooltipBehavior;

  String inMillions(String num) {
    int n = int.parse(num);
    double result = n / 1000.0;
    // if (result < 1) {
    //   return result.toString().length<4?result.round().toString():result.round().toString().substring(0, 4);
    // } else {
    return result.round().toString();
    // }
  }

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      enableMultiSelection:false,
      plotAreaBorderWidth: 0,
      plotAreaBorderColor: Colors.transparent,
      plotAreaBackgroundColor: Colors.transparent,
      //isTransposed: true,
      // title: ChartTitle(text: 'Continent wise Revenue - 2021'),
      legend: Legend(isVisible: false),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        LineSeries<RevenueData, String>(
          color: widget.color,
            name: 'Revenue',
            dataSource: _chartData,
            xValueMapper: (RevenueData Revenue, _) => Revenue.year,
            yValueMapper: (RevenueData Revenue, _) => Revenue.revenue,
            dataLabelMapper: (RevenueData Revenue, _) => formatCurrency(inMillions(Revenue.revenue.toString())) ,
            markerSettings: MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              width: 8 * widget.scale,
              height: 8 * widget.scale,
              color: widget.color,
              borderColor: widget.color,
            ),
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: GoogleFonts.poppins(fontSize: widget.scale == 1?14:10,fontWeight: FontWeight.w400,color: Color.fromRGBO(130, 130, 130, 1)),
            ),
            enableTooltip: true)
      ],
      primaryXAxis: CategoryAxis(
        isVisible: false,
        //majorGridLines: MajorGridLines(),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        labelStyle: GoogleFonts.poppins(fontSize: widget.scale == 1?14:10,fontWeight: FontWeight.w400,color: Color.fromRGBO(130, 130, 130, 1)),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        //numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
        //title: AxisTitle(text: 'Revenue in billions of U.S. Dollars')),
      ),
    );
  }

  List<RevenueData> getChartData() {
    final List<RevenueData> chartData = [];

    widget.yearsPresent.forEach((element){
      chartData.add(RevenueData(element, double.parse(widget.data[element]).floorToDouble()));
    });

    return chartData;
  }
}

class RevenueData {
  RevenueData(this.year, this.revenue);
  final String year;
  final double revenue;
}
