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

class BlockedAmountData {
  final String account_number;
  final String order_number;
  final String stat_txt;
  final String status;
  final String blocked_amt;
  final String closing_balance;
  final String opening_balance;
  final String created_on;
  final String NAME;
  final String PAN_NO;
  final String nadId;

  BlockedAmountData({
    this.account_number,
    this.order_number,
    this.stat_txt,
    this.status,
    this.blocked_amt,
    this.closing_balance,
    this.opening_balance,
    this.created_on,
    this.PAN_NO,
    this.NAME,
    this.nadId,
  });
}

class BlockedAmountDataSource extends DataTableSource {
  List<BlockedAmountData> data = <BlockedAmountData>[];
  String gTotal = '0';
  TabBarModel tabBarModel;

  ActionModel actionModel;
  BuildContext context;
  Function callsetstate;

  BlockedAmountDataSource(this.context, this.data, this.gTotal, this.actionModel, this.callsetstate, {this.tabBarModel});

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

    final BlockedAmountData d = data[index];

    var intDate = DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd").parse(d.created_on)).toString();

    return DataRow.byIndex(index: index, selected: false, onSelectChanged: null, cells: <DataCell>[
      DataCell(Text(
        d.order_number,
        style: cellStyle,
      )),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${d.PAN_NO}',
            style: cellStyle,
          ),
          Text('${d.NAME}', style: cellStyle, overflow: TextOverflow.ellipsis),
        ],
      )),
      DataCell(Text('${d.account_number}', style: cellStyle, overflow: TextOverflow.ellipsis)),
      DataCell(Text(
        intDate,
        style: cellStyle,
      )),
      DataCell(Text('${d.status}', style: cellStyle, overflow: TextOverflow.ellipsis)),
      DataCell(Text(
        formatCurrency('${d.blocked_amt}', withIcon: true),
        style: cellStyle,
      )),
      DataCell(Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            var _body = {};

            _body['account'] = d.account_number;
            _body['order_number'] = d.order_number;
            _body['nadId'] = d.nadId;
            await showDialog(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('Are you sure?'),
                        // Text('Would you like to approve of this message?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () async {


                        await actionModel.moveBlockedAmount(_body);
                        Navigator.of(context).pop();
                        callsetstate();

                      },
                    ),
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text(
            "Unblock",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
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
