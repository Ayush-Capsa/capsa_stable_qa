import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



final appTheme = ThemeData(
  accentColor: Color(0xFF3AC0C9),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFf8fcfd),
  accentTextTheme: const TextTheme(),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: const Color(0xFF0090ce),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder:
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400])),
    border: InputBorder.none,
    focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: const Color(0xFF0090ce),
        )),
    errorBorder: InputBorder.none,

    disabledBorder: InputBorder.none,
    hintStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
    // filled: true,
    fillColor: const Color(0xFFf8fcfd),
  ),
  primaryTextTheme: const TextTheme(
    headline2: TextStyle(color: Colors.blueGrey),
  ),
  primaryColor: const Color(0xFF0090ce),
);




final appThemeOld = ThemeData(
  accentColor: const Color(0xFF3AC0C9),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFf8fcfd),
    titleTextStyle: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFf8fcfd),
  accentTextTheme: const TextTheme(),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: const Color(0xFF0090ce),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(height: 1),
    enabledBorder: InputBorder.none,
    filled: true,
    focusedBorder: InputBorder.none,
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    hintStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
    fillColor: const Color(0xFFecf8fb),
  ),
  primaryTextTheme: const TextTheme(
    headline2: TextStyle(color: Colors.blueGrey),
  ),
  primaryColor: const Color(0xFF0090ce),
);



final tableTheme = ThemeData(
  textTheme: GoogleFonts.ibmPlexSansTextTheme(),
  dividerTheme: DividerThemeData(
    thickness: 113,
    color: Colors.white,
  ),
  cardTheme: CardTheme(
    elevation: 0,
    margin: EdgeInsets.all(4),
    color: Colors.white,
  ),
);
