import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/generated/GeneratedIconsWidget5.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/generated/GeneratedRectangle71Widget5.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/generated/GeneratedHomeWidget6.dart';

/* Instance FAQ
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedFAQWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 141.0,
      height: 59.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: 16.0,
              top: 17.5,
              right: null,
              bottom: null,
              width: 24.0,
              height: 24.0,
              child: GeneratedIconsWidget5(),
            ),
            Positioned(
              left: 48.0,
              top: 16.0,
              right: null,
              bottom: null,
              width: 42.0,
              height: 32.0,
              child: GeneratedHomeWidget6(),
            ),
            Positioned(
              left: 129.0,
              top: 25.5,
              right: null,
              bottom: null,
              width: 20.0,
              height: 5.0,
              child: GeneratedRectangle71Widget5(),
            )
          ]),
    );
  }
}
