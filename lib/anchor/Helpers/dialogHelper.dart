import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/DialogBoxes/approvedDialog.dart';
import 'package:capsa/anchor/DialogBoxes/invoiceDialogWindow.dart';
import 'package:capsa/anchor/DialogBoxes/paymentDialogWindow.dart';
import 'package:capsa/anchor/DialogBoxes/pdf_dialog_window.dart';
import 'package:capsa/anchor/DialogBoxes/rejectedDialog.dart';
import 'package:capsa/anchor/DialogBoxes/vettedDialog.dart';
import 'package:capsa/anchor/Profile/delete_admin.dart';
import 'package:provider/provider.dart';

class dialogHelper {
  static show(context,_acctTable) => showDialog(context: context, builder: (context) => dialogBox(acctTable: _acctTable,));
  static showPdf(context, anchorsActions, fileName) => showDialog(context: context, builder: (context) => pdfDialogBox(invoiceProvider: anchorsActions,fileName: fileName,));
  static showVetted(context) => showDialog(context: context, builder: (context) => vettedDialog());
  static showApproved(context) => showDialog(context: context, builder: (context) => approvedDialog());
  static showRejected(context) => showDialog(context: context, builder: (context) => rejectedDialog());
  static showPayment(context) => showDialog(context: context, builder: (context) => paymentDialog());
  // static showDelete(context,name,id) => showDialog(context: context, builder: (context) =>ChangeNotifierProvider(
  //   create: (BuildContext context) => AnchorActionProvider(),
  //   child: deleteAdmin(name,id),
  // ));
}