import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CreditScore extends StatelessWidget {
  double score;
  double scale = 1;
  CreditScore({Key key, @required this.score, this.scale = 1})
      : super(key: key);

  String verdict(int n){
    if(n>80) {
      return 'Excellent';
    } else if(n<=80 && n>60) {
      return 'Good';
    } else if(n<=60 && n>40) {
      return 'Fair';
    } else if(n<=40 && n>20) {
      return 'Poor';
    } else {
      return 'Very Poor';
    }

  }

  Widget legend(Color c, String text) {
    return Padding(
      padding: scale == 1?const EdgeInsets.all(12.0):const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: scale == 1?20:15,
            height: scale == 1?20:15,
            color: c,
          ),
          SizedBox(
            width: scale == 1?20:5,
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
                fontSize: scale == 1?12:10, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double meterWidth = scale == 1 ? 50 : 24;
    double startValue = 0;
    return Container(
      width: scale == 1 ? 640 : MediaQuery.of(context).size.width,
      height: scale == 1 ? 380 : 206,
      child: scale == 1
          ? Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Positioned(
                  top: 20,
                  left: 20,
                  child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        showFirstLabel: false,
                        showLastLabel: false,
                        radiusFactor: 1,
                        startAngle: 135,
                        endAngle: 495,
                        minimum: 0,
                        maximum: 360,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: startValue,
                              endValue: startValue + (72 * 1),
                              color: Colors.red,
                              startWidth: meterWidth,
                              endWidth: meterWidth),
                          GaugeRange(
                              startValue: startValue + (72 * 1),
                              endValue: startValue + (72 * 2),
                              color: Colors.orange,
                              startWidth: meterWidth,
                              endWidth: meterWidth),
                          GaugeRange(
                              startValue: startValue + (72 * 2),
                              endValue: startValue + (72 * 3),
                              color: Colors.yellow,
                              startWidth: meterWidth,
                              endWidth: meterWidth),
                          GaugeRange(
                              startValue: startValue + (72 * 3),
                              endValue: startValue + (72 * 4),
                              color: Colors.lightGreen,
                              startWidth: meterWidth,
                              endWidth: meterWidth),
                          GaugeRange(
                              startValue: startValue + (72 * 4),
                              endValue: startValue + (72 * 5),
                              color: Colors.green,
                              startWidth: meterWidth,
                              endWidth: meterWidth)
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: score,
                            needleLength: 0.4,
                            needleStartWidth: 1 * scale,
                            needleEndWidth: 10 * scale,
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: IntrinsicHeight(
                                  child: IntrinsicWidth(
                                child: Column(
                                  children: [
                                    Text((score/3.6).floor().toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: scale == 1 ? 32 : 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue)),
                                    Text(verdict((score/3.6).floor()),
                                        style: GoogleFonts.poppins(
                                            fontSize: scale == 1 ? 32 : 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green)),
                                  ],
                                ),
                              )),
                              angle: 90,
                              positionFactor: 0.35)
                        ])
                  ]),
                ),
                // SizedBox(width: 60,),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        legend(Colors.green, 'Excellent(81 - 100)'),
                        legend(Colors.lightGreen, 'Good(61 - 80)'),
                        legend(Colors.yellow, 'Fair(41 - 60)'),
                        legend(Colors.orange, 'Poor(21 - 40)'),
                        legend(Colors.red, 'Very Poor(0 - 21)'),
                      ],
                    ),
                  ),
                )
              ],
            )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 20,),
              Expanded(
                child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        showFirstLabel: false,
                        showLastLabel: false,
                        radiusFactor: 1,
                        startAngle: 135,
                        endAngle: 495,
                        minimum: 0,
                        maximum: 360,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: startValue,
                              endValue: startValue + (72 * 1),
                              color: Colors.green,
                              startWidth: meterWidth,
                              endWidth: meterWidth),
                          GaugeRange(
                              startValue: startValue + (72 * 1),
                              endValue: startValue + (72 * 2),
                              color: Colors.lightGreen,
                              startWidth: meterWidth,
                              endWidth: meterWidth),
                          GaugeRange(
                              startValue: startValue + (72 * 2),
                              endValue: startValue + (72 * 3),
                              color: Colors.yellow,
                              startWidth: meterWidth,
                              endWidth: meterWidth),
                          GaugeRange(
                              startValue: startValue + (72 * 3),
                              endValue: startValue + (72 * 4),
                              color: Colors.orange,
                              startWidth: meterWidth,
                              endWidth: meterWidth),
                          GaugeRange(
                              startValue: startValue + (72 * 4),
                              endValue: startValue + (72 * 5),
                              color: Colors.red,
                              startWidth: meterWidth,
                              endWidth: meterWidth)
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: score,
                            needleLength: 0.4,
                            needleStartWidth: 1 * scale,
                            needleEndWidth: 10 * scale,
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: IntrinsicHeight(
                                  child: IntrinsicWidth(
                                child: Column(
                                  children: [
                                    Text(score.floor().toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: scale == 1 ? 32 : 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue)),
                                    Text(verdict(score.floor()),
                                        style: GoogleFonts.poppins(
                                            fontSize: scale == 1 ? 24 : 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green)),
                                  ],
                                ),
                              )),
                              angle: 90,
                              positionFactor: 0.35)
                        ])
                  ]),
              ),
              SizedBox(width: 10,),
              IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    legend(Colors.transparent, ''),
                    legend(Colors.green, 'Excellent(81 - 100)'),
                    legend(Colors.lightGreen, 'Good(61 - 80)'),
                    legend(Colors.yellow, 'Fair(41 - 60)'),
                    legend(Colors.orange, 'Poor(21 - 40)'),
                    legend(Colors.red, 'Very Poor(0 - 20)'),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
