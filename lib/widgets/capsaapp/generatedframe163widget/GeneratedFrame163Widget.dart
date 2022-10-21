import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/GeneratedFrame159Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/GeneratedViewallUpcomingPaymentsWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/GeneratedFrame155Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/generated/GeneratedFrame160Widget.dart';
import 'package:beamer/beamer.dart';

class GeneratedFrame163Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: Responsive.isMobile(context) ?  MediaQuery.of(context).size.width - 35 : 414,
      height: 800.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
          bottomRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(50.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            offset: Offset(10.0, 10.0),
            blurRadius: 2.0,
          ),
          BoxShadow(
            color: Color.fromARGB(255, 255, 255, 255),
            offset: Offset(-2.0, -2.0),
            blurRadius: 0,
          )
        ],
      ),
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(50.0),
              ),
              child: Container(
                color: Color.fromARGB(255, 245, 251, 255),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(50.0),
              ),
              // child: Image.asset(
              //   "assets/images/6aa12eea9b80620ebca85da47ee3f9835a242774.png",
              //   color: null,
              //   fit: BoxFit.none,
              //   width: 414.0,
              //   height: 728.0,
              //   colorBlendMode: BlendMode.dstATop,
              // ),
            ),
            // Positioned(
            //   left: 119.5,
            //   top: 36.0,
            //   right: null,
            //   bottom: null,
            //   width: 175.0,
            //   height: 43.0,
            //   child: GeneratedFrame159Widget(),
            // ),
            Positioned(
              left: Responsive.isMobile(context) ? 82:  132.0,
              top:  Responsive.isMobile(context) ? 35: 40.0,
              right: null,
              bottom: null,
              width: 150.0,
              height: 150.0,
              child: GeneratedFrame155Widget(),
            ),
            Positioned(
              left: Responsive.isMobile(context) ? 0: 27.0,
              top:  Responsive.isMobile(context) ? 250 : 293.0,
              right: null,
              bottom: null,
              width: MediaQuery.of(context).size.width * 0.9,

              child: GeneratedFrame160Widget(),
            ),
            Positioned(

              bottom: 0,
              width: 269.0,
              height: 29.0,
              child: InkWell( onTap: (){

                context.beamToNamed('/all-upcoming-payments');
              }, child: GeneratedViewallUpcomingPaymentsWidget()),
            )
          ]),
    ));
  }
}
