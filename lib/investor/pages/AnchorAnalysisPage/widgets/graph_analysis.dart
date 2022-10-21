import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/charts/bar_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import 'charts/line_chart.dart';
import 'charts/chart_legend/line_chart_legend.dart';

class GraphWidget extends StatefulWidget {
  String title;
  bool isOnlyBarChart = true;
  double scale;
  String barChartHexColor;
  String note;
  Map<String, String> data = {};
  dynamic yearsPresent;
  GraphWidget(
      {Key key,
      @required this.isOnlyBarChart,
      @required this.title,
      this.scale = 1,
      @required this.data,
      @required this.barChartHexColor,
      @required this.yearsPresent,
      this.note = ''})
      : super(key: key);

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  String getIncrement(double a, double b) {
    if(a == b)
      return '0%';
    String s = ((a - b) / (b * 1.0) * 100).abs().toStringAsFixed(2);
    return (s + "%");
  }

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
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      elevation: 2,
      child: Container(
        width: widget.scale == 1 ? 504 : 328,
        height: widget.scale == 1 ? 481 : 314,
        decoration: BoxDecoration(
          color: Color.fromRGBO(245, 251, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0 * widget.scale),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(130, 130, 130, 1),
                          fontSize: widget.scale == 1 ? 15 : 14),
                    ),
                    SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(widget.note,style: GoogleFonts.poppins(
                          color: Color.fromRGBO(130, 130, 130, 1),
                          fontSize: widget.scale == 1 ? 9 : 6,
                          fontWeight: FontWeight.w400),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '₦ ' + formatCurrency(widget.data[
                  widget.yearsPresent[widget.yearsPresent.length - 1]])
                      ,
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: widget.scale == 1 ? 20 : 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    double.parse(widget.data[widget.yearsPresent[
                                widget.yearsPresent.length - 1]]) >
                            double.parse(widget.data[widget
                                .yearsPresent[widget.yearsPresent.length - 2]])
                        ? Icon(
                            Icons.arrow_drop_up_sharp,
                            color: Colors.green,
                            size: widget.scale == 1 ? 24 : 22,
                          )
                        : Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.red,
                            size: widget.scale == 1 ? 24 : 22,
                          ),
                    Text(
                      getIncrement(
                          double.parse(widget.data[widget
                              .yearsPresent[widget.yearsPresent.length - 1]]),
                          double.parse(widget.data[widget
                              .yearsPresent[widget.yearsPresent.length - 2]])),
                      style: GoogleFonts.poppins(
                          color: double.parse(widget.data[widget.yearsPresent[
                          widget.yearsPresent.length - 1]]) >
                              double.parse(widget.data[widget
                                  .yearsPresent[widget.yearsPresent.length - 2]])
                              ?Colors.green:Colors.red,
                          fontSize: widget.scale == 1 ? 20 : 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              widget.isOnlyBarChart
                  ? Container()
                  : Expanded(
                      child: Padding(
                      padding: EdgeInsets.only(
                          left: 50 * widget.scale, right: 42 * widget.scale),
                      child: LineChart(
                        color: Colors.blue,
                        scale: widget.scale,
                        yearsPresent: widget.yearsPresent,
                        data: widget.data,
                      ),
                    )),
              SizedBox(
                height: 22 * widget.scale,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(
                    left: 50 * widget.scale, right: 42 * widget.scale),
                child: BarChart(
                  data: widget.data,
                  hexColor: widget.barChartHexColor,
                  yearsPresent: widget.yearsPresent,
                ),
              )),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: widget.isOnlyBarChart ? 10 : 31 * widget.scale,
                        height: 10,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 9 * widget.scale,
                      ),
                      Text(
                        widget.isOnlyBarChart
                            ? widget.title + ' (in thousands of naira)'
                            : widget.title,
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: widget.scale == 1 ? 12 : 8,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  widget.isOnlyBarChart
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(left: 53 * widget.scale),
                          child: Row(
                            children: [
                              LineChartLegend(
                                color: Colors.blue,
                                scale: widget.scale + 0.2,
                              ),
                              SizedBox(
                                width: 9 * widget.scale,
                              ),
                              Text(
                                'CoS & Operating Costs (in thousands of naira)',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: widget.scale == 1 ? 12 : 8,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                ],
              ),
              // SizedBox(height: 10,),
              // Text(widget.note,style: GoogleFonts.poppins(
              //     color: Colors.black,
              //     fontSize: widget.scale == 1 ? 10 : 6,
              //     fontWeight: FontWeight.w400),),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
