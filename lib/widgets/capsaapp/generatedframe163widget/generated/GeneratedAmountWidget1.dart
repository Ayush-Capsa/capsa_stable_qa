import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/Generated100000000000Widget1.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/GeneratedWidget1.dart';

/* Frame Amount
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedAmountWidget1 extends StatelessWidget {


  final data;

  GeneratedAmountWidget1(this.data, {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 232.0,
      height: 24.0,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: 0.0,
              top: 0.0,
              right: null,
              bottom: null,
              width: 15.0,
              height: 29.0,
              child: GeneratedWidget1(),
            ),
            Positioned(
              left: 14.0,
              top: 0.0,
              right: null,
              bottom: null,
              width: 223.0,
              height: 29.0,
              child: Generated100000000000Widget1(data),
            )
          ]),
    );
  }
}