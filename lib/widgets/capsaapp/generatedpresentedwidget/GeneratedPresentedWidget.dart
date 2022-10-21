import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedpresentedwidget/generated/GeneratedFrame153Widget.dart';

class GeneratedPresentedWidget extends StatelessWidget {
  final data;
  final double width;
  final double height;

  GeneratedPresentedWidget(this.data, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    double _width = Responsive.isMobile(context) ? 160.0 : 220.0;

    if (width != null) {
      _width = width;
    }
    double _height = Responsive.isMobile(context) ? 200.0 : 240.0;

    if (height != null) {
      _height = height;
    }
    return Material(
        child: Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
          bottomRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(25.0),
        ),
        boxShadow: [
          // BoxShadow(
          //   color: Color.fromARGB(25, 0, 0, 0),
          //   offset: Offset(5.0, 5.0),
          //   blurRadius: 6.0,
          // ),
          // BoxShadow(
          //   color: Color.fromARGB(255, 255, 255, 255),
          //   offset: Offset(-5.0, -5.0),
          //   blurRadius: 6.0,
          // )
        ],
      ),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
            bottomRight: Radius.circular(0.0),
            bottomLeft: Radius.circular(25.0),
          ),
          child: Container(
            color: data['color'],
          ),
        ),
        Positioned(
          left: 15.0,
          top: 22.0,
          right: null,
          bottom: null,
          width: 219.0,
          height: 256.0,
          child: GeneratedFrame153Widget(data),
        ),
        if (data['img1'] != null)
          Positioned(
            left: null,
            top: Responsive.isMobile(context) ? 25 : 5.0,
            right: Responsive.isMobile(context) ? 15 : 20,
            bottom: null,
            width: Responsive.isMobile(context) ? 160 : 219.0,
            height: Responsive.isMobile(context) ? 180 : 256.0,
            child: Image.asset(data['img1']),
          )
      ]),
    ));
  }
}
