import 'package:capsa/models/profile_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

showTopUpAct(context,getBankDetails) async {
  BankDetails _getBankDetails = getBankDetails;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Capsa Account No is',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _getBankDetails?.account_number ?? "",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Account Bank',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _getBankDetails?.bank_name ?? "",
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Please make transfer to capsa account to top up! Transfers reflect within a few minutes',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
