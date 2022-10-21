import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedpresentedwidget/generated/GeneratedFrame151Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedpresentedwidget/generated/GeneratedFrame152Widget.dart';

/* Frame Frame 153
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedFrame153Widget extends StatelessWidget {
  final   data;

  GeneratedFrame153Widget(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 219.0,
      height: 256.0,
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
              width:  (data['sTabWidth'] != null) ? data['sTabWidth'] : 140.0,
              height: 44.0,
              child: GeneratedFrame151Widget(data),
            ),
            Positioned(
              left: 0.0,
              top:  Responsive.isMobile(context) ?  95.0 : 128.0,
              right: null,
              bottom: null,
              width: 219.0,
              height: 92.0,
              child: GeneratedFrame152Widget(data),
            )
          ]),
    );
  }
}
