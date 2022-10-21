import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class LineChartLegend extends StatelessWidget {
  Color color;
  double scale;
  LineChartLegend({Key key,@required this.color,this.scale = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 29 * scale,
      height: 10 * scale,
      child: Stack(children: [
        Center(
          child: Container(
            height: 2,
            color: color,
          ),
        ),
        Center(
          child: Container(
            height: 10 * scale,
            width: 10 * scale,
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
