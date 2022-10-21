import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/helpers/transform/transform.dart';
import 'package:capsa/widgets/capsaapp/generatedwidgettemplatewidget/generated/GeneratedFrame32Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedwidgettemplatewidget/generated/GeneratedPiechartWidget.dart';

class GeneratedWidgetTemplateWidget extends StatelessWidget {
  final String bankName, accountNo;

  GeneratedWidgetTemplateWidget({this.bankName, this.accountNo, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: 330.0,
      height: 165.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            offset: Offset(10.0, 10.0),
            blurRadius: 20.0,
          ),
          BoxShadow(
            color: Color.fromARGB(255, 255, 255, 255),
            offset: Offset(-10.0, -10.0),
            blurRadius: 0.0,
          )
        ],
      ),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomRight: Radius.circular(0.0),
            bottomLeft: Radius.circular(30.0),
          ),
          child: Container(
            color: Color.fromARGB(255, 58, 192, 201),
          ),
        ),
        Positioned(
          left: 24.0,
          top: 22.0,
          right: null,
          bottom: null,
          width: 330.0,
          height: 150.0,
          child: GeneratedFrame32Widget(bankName,accountNo),
        ),
        // Positioned(
        //   left: 0.0,
        //   top: 0.0,
        //   right: 0.0,
        //   bottom: 0.0,
        //   width: null,
        //   height: null,
        //   child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        //     final double width = constraints.maxWidth * 0.09651474530831099;
        //
        //     final double height = constraints.maxHeight * 0.17307692307692307;
        //
        //     return Stack(children: [
        //       TransformHelper.translate(
        //           x: constraints.maxWidth * 0.5656836461126006,
        //           y: constraints.maxHeight * 0.10576923076923077,
        //           z: 0,
        //           child: Container(
        //             width: width,
        //             height: height,
        //             child: GeneratedShow_chartWidget(),
        //           ))
        //     ]);
        //   }),
        // ),
        // Positioned(
        //   left: 240.0,
        //   top: 15.0,
        //   right: null,
        //   bottom: null,
        //   width: 36.0,
        //   height: 36.0,
        //   child: GeneratedLayersWidget(),
        // ),
        // Positioned(
        //   left: 0.0,
        //   top: 0.0,
        //   right: 0.0,
        //   bottom: 0.0,
        //   width: null,
        //   height: null,
        //   child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        //     final double width = constraints.maxWidth * 0.09651474530831099;
        //
        //     final double height = constraints.maxHeight * 0.17307692307692307;
        //
        //     return Stack(children: [
        //       TransformHelper.translate(
        //           x: constraints.maxWidth * 0.8445040214477212,
        //           y: constraints.maxHeight * 0.10576923076923077,
        //           z: 0,
        //           child: Container(
        //             width: width,
        //             height: height,
        //             child: GeneratedPiechartWidget(),
        //           ))
        //     ]);
        //   }),
        // )
      ]),
    ));
  }
}
