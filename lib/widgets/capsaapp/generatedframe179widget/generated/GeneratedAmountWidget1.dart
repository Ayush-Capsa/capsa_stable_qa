import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe179widget/generated/Generated298900000Widget1.dart';
import 'package:capsa/widgets/capsaapp/generatedframe179widget/generated/GeneratedWidget1.dart';

/* Frame Amount
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedAmountWidget1 extends StatelessWidget {
  final BidsModel bidsModel;

  const GeneratedAmountWidget1(this.bidsModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168.0,
      height: 36.0,
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
              width: 19.0,
              height: 41.0,
              child: GeneratedWidget1(),
            ),
            Positioned(
              left: 18.0,
              top: 0.0,
              right: null,
              bottom: null,
              width: 155.0,
              height: 41.0,
              child: Generated298900000Widget1(bidsModel),
            )
          ]),
    );
  }
}