import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/GeneratedOct13Widget.dart';

/* Frame Date
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedDateWidget1 extends StatelessWidget {


  final data;

  GeneratedDateWidget1(this.data, {Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 24.0,
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
              width: 100.0,
              height: 26.0,
              child: GeneratedOct13Widget(data),
            )
          ]),
    );
  }
}
