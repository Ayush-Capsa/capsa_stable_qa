import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../functions/currency_format.dart';
import '../../functions/custom_print.dart';
import '../../functions/export_to_csv.dart';
import '../../functions/hexcolor.dart';
import '../../models/bid_history_model.dart';

String gainPer(BidHistoryModel model) {
  double result =
      ((double.parse(gains(model)) / double.parse(model.discountVal))) * 100;
  return result.toStringAsFixed(2);
}

String gains(BidHistoryModel model) {
  double result =
      (double.parse(model.invoiceValue) - double.parse(model.discountVal)) *
          0.9;
  return result.toString();
}

String netReturn(BidHistoryModel model) {
  double pltfee = 0.1 *
      double.parse(
          (double.parse(model.invoiceValue) - double.parse(model.discountVal))
              .toString());
  double result = double.parse(model.invoiceValue) - pltfee;
  return result.toString();
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

void exportCSV(List<BidHistoryModel> bids) {
  {
    final find = ',';
    final replaceWith = '';
    List<List<dynamic>> rows = [];
    //capsaPrint('Length : ${bids.length}');
    rows.add([
      "S/N",
      "Anchor Name",
      "Invoice Amount",
      "Bid Amount",
      "% Gain",
      "Gain",
      "Net Returns",
      "Due Date",
      "Tenure",
      "Status"
    ]);
    int i = 0;
    for (var bid in bids) {
      List<dynamic> row = [];
      row.add(
        (++i).toString(),
      );
      row.add(
        bid.customerName,
      );
      row.add(
        formatCurrency(
          bid.invoiceValue,
          withIcon: false,
        ),
      );
      row.add(
        formatCurrency(
          bid.discountVal,
          withIcon: false,
        ),
      );
      row.add(
        gainPer(bid),
      );
      row.add(
        formatCurrency(
          gains(bid),
          withIcon: false,
        ),
      );
      row.add(
        formatCurrency(
          netReturn(bid),
          withIcon: false,
        ),
      );

      row.add(
        DateFormat('d MMM, y').format(
            DateFormat(
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .parse(bid
                .effectiveDueDate)),
      );
      row.add(
        daysBetween(
          bid.discountedDate,
          DateFormat(
              "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .parse(bid
              .effectiveDueDate),

        ).toString(),
      );
      row.add(statusString(bid));
      rows.add(row);
    }

    String dataAsCSV = const ListToCsvConverter().convert(
      rows,
    );
    exportToCSV(dataAsCSV, fName: "Bids Analysis");
  }
}

String statusString(BidHistoryModel bids) {
  String _text = 'Open';
  dynamic clr = HexColor('#F2994A');
  if (bids.paymentStatus == '1') {
    _text = 'Closed';
    clr = HexColor("#EB5757");
  } else {
    if (bids.discount_status == 'true') {
      if (DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(bids.effectiveDueDate)
          .isBefore(DateTime.now())) {
        _text = 'Overdue';
        clr = HexColor('#F2994A');
      } else {
        _text = 'Open';
        clr = Colors.green;
      }
    } else {
      _text = 'Pending';
    }
  }

  return _text;
}

Widget bidsAnalysisStatus(BidHistoryModel bids) {
  String _text = 'Open';
  dynamic clr = HexColor('#F2994A');
  if (bids.paymentStatus == '1') {
    _text = 'Closed';
    clr = HexColor("#EB5757");
  } else {
    if (bids.discount_status == 'true') {
      if (DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(bids.effectiveDueDate)
          .isBefore(DateTime.now())) {
        _text = 'Overdue';
        clr = HexColor('#F2994A');
      } else {
        _text = 'Open';
        clr = Colors.green;
      }
    } else {
      _text = 'Pending';
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
