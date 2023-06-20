// revenue_amount_data

import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../vendor-new/pages/history_page.dart';
import '../../models/bid_history_model.dart';
import '../../widgets/datatable_dynamic.dart';
import '../functions/hexcolor.dart';
import '../models/profile_model.dart';


class AccountPageDataSource extends DataTableSource {
  List<TransactionDetails> data = <TransactionDetails>[];
  TabBarModel tabBarModel;

  AccountPageDataSource(this.data, {this.tabBarModel});

  int _selectedCount = 0;
  final cellStyle = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  final cellStyle2 = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  num total = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index > data.length) return null;


    final TransactionDetails transaction = data[index];

    //var intDate = DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd").parse(d.created_at)).toString();

    return DataRow.byIndex(index: index, selected: false, onSelectChanged: null, cells: <DataCell>[
      DataCell(Container(
        width: 115,
        child: Text(
          // transaction.created_on,
          DateFormat('d MMM, y')
              .format(DateFormat(
              "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .parse(
              transaction.created_on))
              .toString(),
          style: dataTableBodyTextStyle,
        ),
      )),
      DataCell(Text(
        transaction.narration,
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        formatCurrency(transaction.opening_balance),
        style: dataTableBodyTextStyle,
      )),
      DataCell(transactionTextWidget(
          transaction)),
      DataCell(Text(
        formatCurrency(transaction.closing_balance),
        style: dataTableBodyTextStyle,
      )),
      // DataCell(Text(
      //   transaction.status,
      //   style: dataTableBodyTextStyle,
      // )),
      DataCell(Text(
        transaction.order_number,
        style: dataTableBodyTextStyle,
      )),
    ]);
  }

  @override
  int get rowCount => data.length + 1;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

Widget transactionTextWidget(TransactionDetails transactionDetails) {
  TextStyle dataTableBodyTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: HexColor("#333333"));

  if (num.parse(transactionDetails.deposit_amt) > 0) {
    dataTableBodyTextStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: HexColor("#219653"));
  } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
    dataTableBodyTextStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: HexColor("#EB5757"));
  }

  var _text = Text(
    formatCurrency(transactionAmount(transactionDetails)),
    style: dataTableBodyTextStyle,
  );

  return _text;
}

transactionAmount(TransactionDetails transactionDetails) {
  num amt = 0;
  if (num.parse(transactionDetails.deposit_amt) > 0) {
    amt = num.parse(transactionDetails.deposit_amt);
  } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
    amt = num.parse(transactionDetails.withdrawl_amt);
  } else if (num.parse(transactionDetails.blocked_amt) > 0) {
    amt = num.parse(transactionDetails.blocked_amt);
  }
  return (amt);
}
