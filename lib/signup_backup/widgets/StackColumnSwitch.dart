import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class StackColumnSwitch extends StatelessWidget {

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;


    StackColumnSwitch({this.children,this.mainAxisAlignment,this.crossAxisAlignment,this.mainAxisSize,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


      return Container(
          child : Responsive.isMobile(context) ?   Stack(children: children): Column(
            mainAxisSize: mainAxisSize ?? MainAxisSize.min,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,children: children,)
      );


  }
}
