import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedframe171widget/generated/GeneratedHowtouploadaninvoiceWidget.dart';

/* Frame Frame 170
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedFrame170Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 590.0,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color.fromARGB(255, 222, 222, 222),
        // gradient: RadialGradient(
        //   center: Alignment(1.0, 1.0),
        //   stops: [1.0, 1.0],
        //   colors: [
        //     Color.fromARGB(255, 222, 222, 222),
        //     Color.fromARGB(0, 217, 217, 217)
        //   ],
        // ),
      ),
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: 22.0,
              top:   Responsive.isMobile(context) ?  16 : 18.0,
              right: null,
              bottom: null,
              width: 310.0,
              height: 35.0,
              child: GeneratedHowtouploadaninvoiceWidget(),
            )
          ]),
    );
  }
}
