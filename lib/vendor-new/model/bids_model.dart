import 'package:capsa/admin/data/accts_data.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BidsModel {
  String cust_pan;

  String customer_name;

  String description;

  String docID;

  String due_date;

  String eff_due_date;

  String int_rate;
  String invoice_number;

  String invoice_value;
  String lender_name;

  String lender_pan;

  String p_type;

  String prop_amt;

  String prop_stat;

  String sign_stat;

  String start_date;

  String nofBids;
  String highBid;
  String customer_rc;


  bool selected = false;

  BidsModel(
    this.cust_pan,
    this.customer_name,
    this.description,
    this.docID,
    this.due_date,
    this.eff_due_date,
    this.int_rate,
    this.invoice_number,
    this.invoice_value,
    this.lender_name,
    this.lender_pan,
    this.p_type,
    this.prop_amt,
    this.prop_stat,
    this.sign_stat,
    this.start_date,
    this.nofBids,
    this.highBid,
    this.customer_rc,
  );

  Map<String, dynamic> toJson() => {
        'cust_pan': cust_pan,
        'customer_name': customer_name,
        'description': description,
        'docID': docID,
        'due_date': due_date,
        'eff_due_date': eff_due_date,
        'int_rate': int_rate,
        'invoice_number': invoice_number,
        'invoice_value': invoice_value,
        'lender_name': lender_name,
        'lender_pan': lender_pan,
        'p_type': p_type,
        'prop_amt': prop_amt,
        'prop_stat': prop_stat,
        'sign_stat': sign_stat,
        'start_date': start_date,
        'nofBids': nofBids,
      };
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
