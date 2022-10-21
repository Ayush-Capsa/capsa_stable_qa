import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

ButtonStyle selectedButton () {
  return TextButton.styleFrom(
    shadowColor: Color.fromRGBO(255, 255, 255, 1),
    backgroundColor: Color.fromRGBO(16, 16, 16, 1),
    primary: Color.fromRGBO(58, 192, 201, 1),
    elevation: 10,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)),
    )
  );
}

ButtonStyle normalButton () {
  return TextButton.styleFrom(
    onSurface: Color.fromRGBO(16, 16, 16, 1),
    primary: Color.fromRGBO(130, 130, 130, 1)
  );
}