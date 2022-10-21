import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

enum displayAxis { Column, Row }

class AutoResponsive extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final displayAxis axis;
  final CrossAxisAlignment crossAxisAlignment;

  const AutoResponsive({Key key, @required this.children, this.axis, this.mainAxisAlignment, this.crossAxisAlignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    displayAxis _axis = axis;
    if (_axis == null) if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
      _axis = displayAxis.Column;
    } else if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
      _axis = displayAxis.Row;
    }
    if (_axis == displayAxis.Column) {
      return Column(
        mainAxisAlignment: mainAxisAlignment == null ? MainAxisAlignment.center : mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment == null ? CrossAxisAlignment.center : crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    } else {
      // if (_axis == displayAxis.Row)
      return Row(
        mainAxisAlignment: mainAxisAlignment == null ? MainAxisAlignment.center : mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment == null ? CrossAxisAlignment.center : crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
  }
}
