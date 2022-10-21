

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:capsa/main.dart';






Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //capsaPrint = (String message, {int wrapWidth}) {};
  await Hive.initFlutter();
  const String _appTitle = 'Capsa';
  const String _buildFlavour = 'prod';
  const String _ip = "https://getcapsa.com/api/";
  runMain(appTitle : _appTitle,buildFlavour : _buildFlavour,ip : _ip);

}