import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

/* Text CAC: RC-1661142
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedCACRC1661142Widget extends StatelessWidget {
  final BidsModel bidsModel;
  const GeneratedCACRC1661142Widget(this.bidsModel,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'CAC:  '+bidsModel.customer_rc,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.left,
      style: TextStyle(
        height: 1.171875,
        fontSize: 12.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: Color.fromARGB(255, 51, 51, 51),

        /* letterSpacing: 0.0, */
      ),
    );
  }
}
