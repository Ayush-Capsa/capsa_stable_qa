import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/GeneratedArdovaPlcWidget1.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/GeneratedFrame74Widget1.dart';

class GeneratedFrame156Widget extends StatelessWidget {
  final data;

  GeneratedFrame156Widget(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: RadialGradient(
          center: Alignment(-1.0, -1.0),
          stops: [0.0, 1.0],
          colors: [Color.fromARGB(193, 200, 248, 255), Color.fromARGB(0, 196, 196, 196)],
        ),
      ),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        Positioned(
          left: 16.0,
          top: 8.0,
          right: null,
          bottom: null,
          width: 290.0,
          height: 29.0,
          child: GeneratedArdovaPlcWidget1(data),
        ),
        Positioned(
          left: 16.0,
          top: 39.0,
          right: null,
          bottom: null,
          width: 288.0,
          height: 24.0,
          child: GeneratedFrame74Widget1(data),
        )
      ]),
    );
  }
}
