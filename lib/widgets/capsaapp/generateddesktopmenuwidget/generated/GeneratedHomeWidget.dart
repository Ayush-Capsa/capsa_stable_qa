import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/generated/GeneratedIconsWidget.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/generated/GeneratedHomeWidget1.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/generated/GeneratedRectangle71Widget.dart';

class GeneratedHomeWidget extends StatelessWidget {
  final Map menu;

  GeneratedHomeWidget(this.menu, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155.0,
      height: 48.0,
      decoration: (menu['active'])
          ? BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  offset: Offset(4.0, 4.0),
                  blurRadius: 20.0,
                ),
                BoxShadow(
                  color: Color.fromARGB(25, 255, 255, 255),
                  offset: Offset(-8.0, -8.0),
                  blurRadius: 20.0,
                )
              ],
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
            ),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
          child: Container(
            color: Color.fromARGB(255, 15, 15, 15),
          ),
        ),
        Positioned(
          left: 16.0,
          top: 12.6,
          right: null,
          bottom: null,
          width: 20.0,
          height: 20.0,
          child: GeneratedIconsWidget(menu),
        ),
        Positioned(
          left: 48.0,
          top: 15.5,
          right: null,
          bottom: null,
          width: 110.0,
          height: 32.0,
          child: GeneratedHomeWidget1(menu),
        ),
        Positioned(
          left: 129.0,
          top: 22.5,
          right: null,
          bottom: null,
          width: 20.0,
          height: 5.0,
          child: GeneratedRectangle71Widget(),
        )
      ]),
    );
  }
}
