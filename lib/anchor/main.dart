import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'Mobile_Home_Page.dart';
import 'Responsive_Layout.dart';
import 'anchor_home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme
        )
      ),
      home: Scaffold(
        body: responsiveLayout(
          mobileBody: mobileHomePage(),
          desktopBody: anchorHomePage()
        ),
      ),
    );
  }
}
