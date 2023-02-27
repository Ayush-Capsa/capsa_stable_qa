// import 'package:capsa/functions/hexcolor.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';


extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String truncateTo(int maxLength) =>
      (this.length <= maxLength) ? this : '${this.substring(0, maxLength)}...';

}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}



Box box = Hive.box('capsaBox');

// const apiUrl = "";
String apiUrl = box.get('ip');

bool isDebug = false;


Widget toast = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    color: Colors.green[300],
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check, color: Colors.white),
      SizedBox(
        width: 12.0,
      ),
      Text(
        "Account info updated!\nPlease login to continue",
        style: TextStyle(color: Colors.white),
      ),
    ],
  ),
);


bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

String formatPanNumber(String s){
  String result = '';
  for(int i = 0;i<s.length;i++){
    if(s[i]!='-'){
      result += s[i];
    }else{
      return result;
    }
  }
  return result;
}

bool notNull(String s){
  if(s == '' || s == null || s == 'null') {
    return false;
  }
  return true;
}


