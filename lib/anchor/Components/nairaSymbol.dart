import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart';

currency(context) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
  return format;
}