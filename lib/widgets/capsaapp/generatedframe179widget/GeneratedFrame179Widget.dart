import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe179widget/generated/GeneratedFrame93Widget.dart';

class GeneratedFrame179Widget extends StatelessWidget {
  final BidsModel bidsModel;

  const GeneratedFrame179Widget(this.bidsModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: MediaQuery.of(context).size.width - 200,
      height: 100.0,
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        Positioned(
          left: 0.0,
          top: 0.0,
          right: null,
          bottom: null,
          width: MediaQuery.of(context).size.width - 200,
          height: 100.0,
          child: GeneratedFrame93Widget(bidsModel),
        )
      ]),
    ));
  }
}
