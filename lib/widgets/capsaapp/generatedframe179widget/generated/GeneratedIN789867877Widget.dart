import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

/* Text IN789867877
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedIN789867877Widget extends StatelessWidget {
  final BidsModel bidsModel;

  const GeneratedIN789867877Widget(this.bidsModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      bidsModel.invoice_number,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.left,
      style: TextStyle(
        height: 1.171875,
        fontSize: 20.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 0, 152, 219),

        /* letterSpacing: 0.0, */
      ),
    );
  }
}
