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

class RevenueAmountData {
  final String sysID;
  final String invoice_no;
  final String investor_pan;
  final String investor_name;
  final String requestor_pan;
  final String requestor_name;
  final String requestor_fee;
  final String investor_fee;
  final String ohDueIn;
  final String ohStatus;
  final String created_at;

  RevenueAmountData({
    this.sysID,
    this.created_at,
    this.invoice_no,
    this.investor_pan,
    this.investor_name,
    this.requestor_pan,
    this.requestor_name,
    this.requestor_fee,
    this.investor_fee,
    this.ohDueIn,
    this.ohStatus,
  });
}

class RevenueAmountDataSource extends DataTableSource {
  List<RevenueAmountData> data = <RevenueAmountData>[];
  String gTotal = '0';
  TabBarModel tabBarModel;

  RevenueAmountDataSource(this.data, this.gTotal, {this.tabBarModel});

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

    if (index == data.length) {
      return DataRow.byIndex(index: index, selected: false, onSelectChanged: null, cells: <DataCell>[
        DataCell(Text(
          '',
          style: cellStyle,
        )),
        DataCell(Text(
          '',
          style: cellStyle,
        )),
        DataCell(Text(
          '',
          style: cellStyle,
        )),
        DataCell(Text(
          '',
          style: cellStyle,
        )),
        DataCell(Text(
          '',
          style: cellStyle,
        )),
        DataCell(Text(
          '',
          style: cellStyle,
        )),
        DataCell(Text(
          '',
          style: cellStyle,
        )),
        DataCell(Text(
          'Grand Total',
          style: cellStyle2,
        )),
        DataCell(Text(
          formatCurrency(gTotal.toString(), withIcon: true),
          style: cellStyle2,
        )),
      ]);
    }

    final RevenueAmountData d = data[index];

    var intDate = DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd").parse(d.created_at)).toString();

    return DataRow.byIndex(index: index, selected: false, onSelectChanged: null, cells: <DataCell>[
      DataCell(Text(
        (index + 1).toString(),
        style: cellStyle,
      )),
      DataCell(Text(
        intDate,
        style: cellStyle,
      )),
      DataCell(Text(
        '${d.invoice_no}',
        style: cellStyle,
      )),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${d.ohStatus}',
            style: cellStyle,
          ),
          Text('${d.ohDueIn}', style: cellStyle, overflow: TextOverflow.ellipsis),
        ],
      )),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${d.requestor_pan}',
            style: cellStyle,
          ),
          Text('${d.requestor_name}', style: cellStyle, overflow: TextOverflow.ellipsis),
        ],
      )),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${d.investor_pan}',
            style: cellStyle,
          ),
          Text('${d.investor_name}', style: cellStyle, overflow: TextOverflow.ellipsis),
        ],
      )),
      DataCell(Text(
        formatCurrency('${d.requestor_fee}', withIcon: true),
        style: cellStyle,
      )),
      DataCell(Text(
        formatCurrency('${d.investor_fee}', withIcon: true),
        style: cellStyle,
      )),
      DataCell(Text(
        formatCurrency((num.parse(d.requestor_fee) + num.parse(d.investor_fee)).toString(), withIcon: true),
        style: cellStyle,
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
