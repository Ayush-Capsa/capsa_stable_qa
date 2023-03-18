import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String content, BuildContext context, { toastDuration,  type  }) {
  if (Responsive.isMobile(context)) {
    capsaPrint('mob');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$content'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Code to execute.
          },
        ),

      ),
    );
    return;
  }
  FToast fToast = FToast();
  fToast.init(context);
  var _color = Colors.green[300];
  var _icon = Icons.check;
  if(type != null){
    if(type == 'error')
      _color =  Colors.red[500];
    _icon = Icons.error;
    if(type == 'warning')
      _color =  Colors.orange[600];
    _icon = Icons.warning;
    if(type == 'info')
      _color =  Colors.blue[400];
    _icon = Icons.info;
  }

  if(toastDuration == null) toastDuration = 2;

  return fToast.showToast(
    gravity: ToastGravity.BOTTOM,


    toastDuration: Duration(seconds: toastDuration),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: _color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: Colors.white),
          SizedBox(
            width: 12.0,
          ),
          Text(
            "$content",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
