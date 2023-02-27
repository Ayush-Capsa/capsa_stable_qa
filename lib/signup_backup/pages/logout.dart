import 'package:capsa/functions/logout.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import '../../main.dart';

class LogOutPage extends StatefulWidget {
  const LogOutPage({Key key}) : super(key: key);

  @override
  State<LogOutPage> createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {

  @override
  void initState(){
    super.initState();
    capsaPrint('logOut page called');
    //logout(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final box = Hive.box('capsaBox');

    box.put('isAuthenticated', false);
    box.delete('userData');
    box.delete('loginUserData');
    box.delete('loginTime');
    // Navigator.of(context).pop();
    authProvider.authChange(false,'');
    box.close();
    //Beamer.of(context).beamToNamed('/sign_in',
      // replaceCurrent: true

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CapsaHome()
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      html.window.location.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 10,),
            Text('Logging Out...')
          ],
        ),
      ),
    );
  }
}
