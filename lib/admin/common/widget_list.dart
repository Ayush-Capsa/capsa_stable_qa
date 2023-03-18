
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/admin/screens/BlockedAmountScreen.dart';
import 'package:capsa/admin/screens/CheckCreditScore.dart';
import 'package:capsa/admin/screens/DashboardPage.dart';
import 'package:capsa/admin/screens/ManualSettleInvoiceScreen.dart';
import 'package:capsa/admin/screens/PendingRevenueScreen.dart';
import 'package:capsa/admin/screens/RevenueScreen.dart';
import 'package:capsa/admin/screens/TransferAmount.dart';
import 'package:capsa/admin/screens/account_screen.dart';
import 'package:capsa/admin/screens/anchor_grading.dart';
import 'package:capsa/admin/screens/anchor_list/anchor_list.dart';
import 'package:capsa/admin/screens/anchor_onboarding.dart';
import 'package:capsa/admin/screens/block_account_screen.dart';
import 'package:capsa/admin/screens/edit_account_screen.dart';
import 'package:capsa/admin/screens/edit_invoice_screen.dart';
import 'package:capsa/admin/screens/enquiry_edit.dart';
import 'package:capsa/admin/screens/enquiry_list.dart';
import 'package:capsa/admin/screens/investor_edit.dart';
import 'package:capsa/admin/screens/investor_list.dart';
import 'package:capsa/admin/screens/invoices_screen.dart';
import 'package:capsa/admin/screens/pending-account/pending_account_screen.dart';
import 'package:capsa/admin/screens/pending_invoice_screen.dart';
import 'package:capsa/admin/screens/reconcilation/reconciliation_screen.dart';
import 'package:capsa/admin/screens/revenue_tracker.dart';
import 'package:capsa/admin/screens/transaction_ledger.dart';
import 'package:capsa/admin/screens/transaction_tracker.dart';
import 'package:capsa/admin/screens/vendor_edit.dart';
import 'package:capsa/admin/screens/vendor_list.dart';
import 'package:capsa/functions/logout.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

final desktopWidgetList = <Widget>[
  //EditTabCall(),
  // HomeScreen(),

  DashboardPage(title: 'Dashboard'),

  InvestorList(title: 'Buyers List'),
  VendorList(title: 'Vendors List'),
  AnchorList(title: 'Anchor List'),

  RevenueTracker(title: 'Revenue'),

  TransactionTracker(title: 'Transaction Volume',),

  PendingInvoiceScreen(title: 'Pending Invoices'),

  // PendingRevenueScreen(title: 'Pending Revenue'),

  EnquiryList(title: 'Vendor On-boarding'),
  EnquiryList(title: 'Buyer On-boarding'),

  AnchorOnboarding(),

  AnchorGrading(),

  InvoiceScreen(title: 'Invoice List'),

  CapsaAccountFragment(),

  ManualSettleInvoiceScreen(title: 'Manual Settlement'),

  // CheckCreditScore(title: 'Check Credit Score'),

  TransactionLedger(),

  ReconciliationScreen(),

  TransferAmount(),

  RevenueScreen(title: "Revenue Amount",),
  BlockedAmountScreen(title: "Blocked Amount",),

  EditAccountScreen(),

  PendingAccountScreen(),

  BlockAccountScreen(),

  EditInvoiceScreen(),

  // EditAccountScreen(),

  // LogOut(),
];

class EditTabCall extends StatefulWidget {
  @override
  _EditTabCallState createState() => _EditTabCallState();
}

class _EditTabCallState extends State<EditTabCall> {
  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);

    if (tab.editType == 'EnquiryEdit') {
      return EnquiryEdit();
    }
    if (tab.editType == 'InvestorEdit') {
      return InvestorEdit();
    }
    if (tab.editType == 'VendorEdit') {
      return VendorEdit();
    }
    return Container();
  }
}

class LogOut extends StatefulWidget {
  @override
  _LogOutState createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    logout(context);
    return GestureDetector(
      onTap: () {
        logout(context);
      },
      child: Container(
        child: Center(child: Text('Click here to logout')),
      ),
    );
  }
}
