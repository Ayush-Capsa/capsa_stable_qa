import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class responsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  responsiveLayout({@required this.mobileBody, @required this.desktopBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth<600) {
          return mobileBody;
        }
        else {
          return desktopBody;
        }
      },
    );
  }
}
