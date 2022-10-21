import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    Key key,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 850 && MediaQuery.of(context).size.width <= 1280;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width > 1281;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // capsaPrint(constraints.maxWidth);
      if (constraints.maxWidth >= 1100) {
        return desktop;
      }
      // If width it less then 1100 and more then 650 we consider it as tablet
      else if (constraints.maxWidth >= 650) {
        return tablet ?? desktop;
      }
      // Or less then that we called it mobile
      else {
        return mobile;
      }
      // if (constraints.maxWidth > 1281) {
      //   return desktop;
      // } else if (constraints.maxWidth < 1281 && constraints.maxWidth >= 850) {
      //   return tablet ?? desktop;
      // } else {
      //   return mobile ?? desktop;
      // }
    });
  }
}
