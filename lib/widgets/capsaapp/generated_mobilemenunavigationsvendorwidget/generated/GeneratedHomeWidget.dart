import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generated_mobilemenunavigationsvendorwidget/generated/GeneratedMenuTextWidget.dart';
import 'package:capsa/widgets/capsaapp/generated_mobilemenunavigationsvendorwidget/generated/GeneratedIconsWidget.dart';
import 'package:capsa/widgets/capsaapp/generated_mobilemenunavigationsvendorwidget/generated/GeneratedRectangle71Widget.dart';

/* Instance Home
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedHomeWidget extends StatelessWidget {
  final Map menu;

  GeneratedHomeWidget(this.menu, {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 53.0,
      decoration:  (menu['active']) ?  BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 0, 0, 0),
            offset: Offset(2.0, 2.0),
            blurRadius: 10.0,
          ),
          BoxShadow(
            color: Color.fromARGB(25, 255, 255, 255),
            offset: Offset(-2.0, -2.0),
            blurRadius: 1.0,
          )
        ],
      ) :  BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                color: Color.fromARGB(255, 15, 15, 15),
              ),
            ),
            Positioned(
              left: 20.0,
              top: 8.0,
              right: null,
              bottom: null,
              width: 18.0,
              height: 18.0,
              child: GeneratedIconsWidget(menu),
            ),
            Positioned(
              left: 0.0,
              top: 30.0,
              right: null,
              bottom: null,
              width: 60.0,
              height: 20.0,
              child: GeneratedMenuTextWidget(menu),
            ),
            Positioned(
              left: 23.5,
              top: 41.0,
              right: null,
              bottom: null,
              width: 5.0,
              height: 5.0,
              child: GeneratedRectangle71Widget(menu),
            )
          ]),
    );
  }
}
