import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe96widget/generated/GeneratedAnchornameWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe96widget/generated/GeneratedAmountWidget.dart';

class GeneratedFrame96Widget extends StatelessWidget {
  String title, subtitle;

    GeneratedFrame96Widget(this.title, this.subtitle, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: Responsive.isMobile(context) ? double.infinity : 250.0,
      height: 70.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: Color.fromARGB(255, 245, 251, 255),
          ),
        ),
        Positioned(
          left: 16.0,
          top: 8.0,
          right: null,
          bottom: null,
          width: 111.0,
          height: 26.0,
          child: GeneratedAnchornameWidget(title,subtitle),
        ),
        Positioned(
          left: 16.0,
          top: 36.0,
          right: null,
          bottom: null,
          width: 292.0,
          height: 36.0,
          child: GeneratedAmountWidget(title,subtitle),
        )
      ]),
    ));
  }
}
