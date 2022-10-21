import 'package:beamer/beamer.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

logout(context) {
  // capsaPrint('logout');
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final box = Hive.box('capsaBox');

  box.put('isAuthenticated', false);
  box.delete('userData');
  box.delete('loginUserData');
  box.delete('loginTime');
  // Navigator.of(context).pop();
  authProvider.authChange(false,'');
  Beamer.of(context).beamToNamed('/sign_in',
      // replaceCurrent: true
  );

  Future.delayed(const Duration(milliseconds: 300), () {
    html.window.location.reload();
  });
}
