import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedwidgettemplatewidget/generated/GeneratedFrame42Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedwidgettemplatewidget/generated/GeneratedIconsWidget.dart';

class GeneratedFrame147Widget extends StatelessWidget {
  final String bankName, accountNo;

  GeneratedFrame147Widget(this.bankName, this.accountNo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 329.0,
      height: 65.0,
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        Positioned(
          left: 0.0,
          top: 0.0,
          right: null,
          bottom: null,
          width: 279.0,
          height: 65.0,
          child: GeneratedFrame42Widget(bankName, accountNo),
        ),
        Positioned(
          left: 270,
          top: 30.0,
          right: null,
          bottom: null,
          width: 24.0,
          height: 24.0,
          child: InkWell(
              onTap: () {

              },
              child: GeneratedIconsWidget()),
        )
      ]),
    );
  }
}

