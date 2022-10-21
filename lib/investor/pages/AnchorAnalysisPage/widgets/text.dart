import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

import 'package:google_fonts/google_fonts.dart';

Widget header(
    {@required String text,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
    double scale = 1}) {
  return Padding(
    padding:
        EdgeInsets.only(top: top, right: right, left: left, bottom: bottom),
    child: Text(
      text,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: scale==1?22:14),
    ),
  );
}

Widget content( {@required String text,
double left = 0,
double top = 0,
double right = 0,
double bottom = 0,
double scale = 1}){
  return Padding(
    padding:
    EdgeInsets.only(top: top, right: right, left: left, bottom: bottom),
    child: IntrinsicWidth(

      child: Align(
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: scale == 1?16:12),
        ),
      ),
    ),
  );
}
