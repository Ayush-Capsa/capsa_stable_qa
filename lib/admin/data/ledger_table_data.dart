import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:intl/intl.dart';



class AcctTableDataSource extends DataTableSource {


  List<TransactionDetails> data = <TransactionDetails>[];
  String title;

  AcctTableDataSource(this.data,{title});


  int _selectedCount = 0;
  final cellStyle = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= data.length) return null;
    final TransactionDetails d = data[index];
    return DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: null,
        cells: <DataCell>[
          DataCell(Text(
            '${d.name}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.account_number}',
            style: cellStyle,
          )),
          DataCell(Text(
            // '${d.created_on}',
            DateFormat('yyyy-MM-dd')
                .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(d.created_on))
                .toString(),
            style: cellStyle,
          )),
          // DataCell(Text(
          //   '${d.order_number}',
          //   style: cellStyle,
          // )),
          DataCell(Text(
            formatCurrency(d.opening_balance) ,
            style: cellStyle,
          )),
          DataCell(Text(
            formatCurrency(d.deposit_amt),
            style: cellStyle,
          )),
          DataCell(Text(
            formatCurrency(d.withdrawl_amt) ,
            style: cellStyle,
          )),
          DataCell(Text(
            formatCurrency(d.closing_balance)  ,
            style: cellStyle,
          )),
          // DataCell(Text(
          //   '${d.status}',
          //   style: cellStyle,
          // )),
          DataCell(Text(
            '${d.narration}',
            style: cellStyle,
          )),
        ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
