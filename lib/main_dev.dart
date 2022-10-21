import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:capsa/main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //capsaPrint = (String message, {int wrapWidth}) {};
  await Hive.initFlutter();
  const String _appTitle = 'Capsa Quality';
  const String _buildFlavour = 'dev';
  const String _ip = 'https://getcapsadev.com/api/';
  // const String _ip = 'http://127.0.0.1:3012/';
  runMain(appTitle: _appTitle, buildFlavour: _buildFlavour, ip: _ip);
}
