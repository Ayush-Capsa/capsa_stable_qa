import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class OrientationSwitcher extends StatelessWidget {
  final List<Widget> children;
  final  orientation ;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  const OrientationSwitcher({Key key,  this.orientation  , this.mainAxisAlignment :  MainAxisAlignment.start, this.crossAxisAlignment : CrossAxisAlignment.start,  this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String _orientation =  Responsive.isMobile(context) ? "Column" : "Row" ;
    if(orientation != null) _orientation = orientation;

    return _orientation == 'Column'
        ? Column( mainAxisSize: MainAxisSize.min, mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment, children: children)
        : Row(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment,children: children);
  }

}
