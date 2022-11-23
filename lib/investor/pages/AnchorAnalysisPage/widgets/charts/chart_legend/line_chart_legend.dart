import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class LineChartLegend extends StatelessWidget {
  Color color;
  double scale;
  LineChartLegend({Key key,@required this.color,this.scale = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isMobile(context)? 16:29 * scale,
      height: Responsive.isMobile(context)? 5:10 * scale,
      child: Stack(children: [
        Center(
          child: Container(
            height: 2,
            color: color,
          ),
        ),
        Center(
          child: Container(
            height: Responsive.isMobile(context)? 7:10 * scale,
            width: Responsive.isMobile(context)? 5:10 * scale,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],)
    );
  }
}
