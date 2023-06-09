import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generated/GeneratedAmountWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generated/GeneratedAccountBalanceWidget1.dart';



/* Frame Frame 141
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedFrame141Widget extends StatelessWidget {
  final String title, subText, icon,helpText;
  final bool currency;
  final color;
  const GeneratedFrame141Widget({this.color,this.title, this.helpText, this.subText, this.icon, this.currency, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 332.0,
      height: 83.0,
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        Positioned(
          left: 0.0,
          top: 0.0,
          right: null,
          bottom: null,
          width: 200.0,
          height: 29.0,
          child: GeneratedAccountBalanceWidget1(title: title),
        ),


        Positioned(
          left: 0.0,
          top: 35.0,
          right: null,
          bottom: null,
          width: 332.0,
          height: 48.0,
          child: GeneratedAmountWidget(
            subText: subText,
            currency: currency,
            color:   color,
          ),
        ),




      ]),
    );
  }
}


