import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedvendorbidsdesktopwidget/generated/GeneratedFrame90Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedvendorbidsdesktopwidget/generated/GeneratedLine16Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedvendorbidsdesktopwidget/generated/GeneratedFrame91Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedvendorbidsdesktopwidget/generated/GeneratedLine15Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedvendorbidsdesktopwidget/generated/GeneratedFrame92Widget.dart';

/* Frame Frame 93
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedFrame93Widget extends StatelessWidget {
  final BidsModel bidsModel;
  const GeneratedFrame93Widget(this.bidsModel,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312.0,
      height: 63.0,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: 12.0,
              top: 7.0,
              right: null,
              bottom: null,
              width: 125.0,
              height: 49.0,
              child: GeneratedFrame90Widget(bidsModel),
            ),
            Positioned(
              left: 155.5,
              top: 4.0,
              right: null,
              bottom: null,
              width: 55.0,
              height: 1.0,
              child: GeneratedLine16Widget(),
            ),
            Positioned(
              left: 174.0,
              top: 7.0,
              right: null,
              bottom: null,
              width: 126.0,
              height: 49.0,
              child: GeneratedFrame91Widget(bidsModel),
            ),
            Positioned(
              left: 300.0,
              top: 4.0,
              right: null,
              bottom: null,
              width: 55.0,
              height: 1.0,
              child: GeneratedLine15Widget(),
            ),
            Positioned(
              left: 216.0,
              top: 10.0,
              right: null,
              bottom: null,
              width: 84.0,
              height: 43.0,
              child: GeneratedFrame92Widget(bidsModel),
            )
          ]),
    );
  }
}