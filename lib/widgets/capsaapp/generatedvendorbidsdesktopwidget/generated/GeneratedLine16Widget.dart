import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/helpers/transform/transform.dart';
import 'package:capsa/widgets/capsaapp/helpers/svg/svg.dart';

/* Line Line 16
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedLine16Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TransformHelper.rotate(
        a: -0.00,
        b: -1.00,
        c: 1.00,
        d: -0.00,
        child: Container(
          width: 55.0,
          height: 1.0,
          child: SvgWidget(painters: [
            SvgPathPainter.stroke(
              1.0,
              strokeJoin: StrokeJoin.miter,
            )
              ..addPath('M0 0L55 0L55 -1L0 -1L0 0Z')
              ..color = Color.fromARGB(255, 130, 130, 130),
          ]),
        ));
  }
}
