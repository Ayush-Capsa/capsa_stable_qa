import 'dart:js';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:intl/intl.dart';

import '../../common/responsive.dart';
import '../../functions/currency_format.dart';
import '../../functions/hexcolor.dart';
import '../../models/bid_history_model.dart';
import '../../widgets/datatable_dynamic.dart';
import '../functions/BidsAnalysisFunctions.dart';

class BidsAnalysisDataSource extends DataTableSource {
  BuildContext context;
  List<BidHistoryModel> data = <BidHistoryModel>[];
  //TabBarModel tabBarModel;

  BidsAnalysisDataSource(this.data, this.context);

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

    final BidHistoryModel bids = data[index];

    //var intDate = DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd").parse(d.created_at)).toString();

    return DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: null,
        cells: <DataCell>[
          DataCell(Text(
            (index + 1).toString(),
            style: dataTableBodyTextStyle,
          )),
          DataCell(Text(
            bids.customerName,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: dataTableBodyTextStyle,
          )),
          DataCell(Text(
            formatCurrency(
              bids.invoiceValue,
              withIcon: true,
            ),
            style: dataTableBodyTextStyle,
          )),
          DataCell(Text(
            formatCurrency(
              bids.discountVal,
              withIcon: true,
            ),
            style: dataTableBodyTextStyle,
          )),
          DataCell(Text(
            gainPer(bids),
            style: dataTableBodyTextStyle,
          )),
          DataCell(Text(
            formatCurrency(
              gains(bids),
              withIcon: true,
            ),
            style: dataTableBodyTextStyle,
          )),
          DataCell(Text(
            formatCurrency(
              netReturn(bids),
              withIcon: true,
            ),
            style: dataTableBodyTextStyle,
          )),
          DataCell(Text(
            DateFormat('d MMM, y').format(
                DateFormat(
                    "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                    .parse(bids
                    .effectiveDueDate)),

            // DateFormat('d MMM, y')
            //     .format(bids.discountedDate)
            //     .toString(),
            style: dataTableBodyTextStyle,
          )),
          DataCell(Text(
            daysBetween(
              bids.discountedDate,
              DateFormat(
                  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                  .parse(bids
                  .effectiveDueDate),

            ).toString(),
            style: dataTableBodyTextStyle,
          )),
          DataCell(_status(bids, context)),
        ]);
  }

  @override
  int get rowCount => data.length + 1;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

Widget _status(BidHistoryModel bids, BuildContext context) {
  // return Text(bids.historyStatus);
  String _text = 'Pending';
  dynamic clr = HexColor('#F2994A');
  if (bids.paymentStatus == '1') {
    _text = 'Closed';
    clr = HexColor("#EB5757");
  } else {
    if (bids.discount_status == 'true') {
      _text = 'Open';
      clr = Colors.green;
    } else {
      _text = 'Pending';
      clr = HexColor('#F2994A');
    }
  }

  return Text(
    _text,
    textAlign: TextAlign.left,
    style: TextStyle(
        color: clr,
        // fontFamily: 'Poppins',
        fontSize: 15,
        letterSpacing:
        0 /*percentages not used in flutter. defaulting to zero*/,
        fontWeight: FontWeight.normal,
        height: 1),
  );
}
