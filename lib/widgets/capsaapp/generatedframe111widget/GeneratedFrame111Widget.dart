import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe111widget/generated/GeneratedPresentedWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe111widget/generated/GeneratedFrame116Widget.dart';

/* Frame Frame 111
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedFrame111Widget extends StatelessWidget {
  final BidsModel bidsModel;

  const GeneratedFrame111Widget(this.bidsModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: 976.0,
      height: 43.0,
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
              width: 105.0,
              height: 43.0,
              child: GeneratedPresentedWidget(bidsModel),
            ),
            Positioned(
              left: 129.0,
              top: 8.0,
              right: null,
              bottom: null,
              width: 163.0,
              height: 27.0,
              child: GeneratedFrame116Widget(),
            )
          ]),
    ));
  }
}