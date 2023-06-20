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


class VendorHistoryDataSource extends DataTableSource {
  List<BidHistoryModel> data = <BidHistoryModel>[];
  TabBarModel tabBarModel;

  VendorHistoryDataSource(this.data, {this.tabBarModel});

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


    final BidHistoryModel d = data[index];

    //var intDate = DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd").parse(d.created_at)).toString();

    return DataRow.byIndex(index: index, selected: false, onSelectChanged: null, cells: <DataCell>[
      DataCell(Text(
        (index + 1).toString(),
        style: cellStyle,
      )),
      DataCell(Text(
        d.invoiceNumber,
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        d.customerName.toString(),
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        d.investorName.toString(),
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        DateFormat('dd/MM/yyyy')
            .format(
            d.discountedDate)
            .toString(),
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        formatCurrency(
            d.discountVal),
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        formatCurrency(
            d.platFormFee),
        style: dataTableBodyTextStyle,
      )),
      DataCell(ViewAction(d)),
    ]);
  }

  @override
  int get rowCount => data.length + 1;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
