import 'dart:js';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:intl/intl.dart';

import '../../common/responsive.dart';
import '../../functions/currency_format.dart';
import '../../functions/hexcolor.dart';
import '../../models/bid_history_model.dart';
import '../../widgets/datatable_dynamic.dart';

class Dessert {
  final String invParticulars;
  final String invAmount;
  final String dates;
  final String bidBy;
  final String bidAmt;
  final String bidType;
  final String bidRate;
  final String platFee;
  final String netAmount;
  final MaterialButton button;

  bool selected = false;

  Dessert(
      this.invParticulars,
      this.invAmount,
      this.dates,
      this.bidBy,
      this.bidType,
      this.bidAmt,
      this.bidRate,
      this.platFee,
      this.netAmount,
      this.button);
}

class DessertDataSource extends DataTableSource {
  final List<Dessert> desserts = <Dessert>[
    Dessert(
        'KKINBN002 \n\nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \n\nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \n\nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \n\nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \n\nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \n\nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \n\nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \n\nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \n\nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \n\nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \n\nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \n\nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \ Stanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
    Dessert(
        'KKINBN002 \n\nStanbic IBTC Bank Pic',
        '6000',
        'Due Date: 07 JAN 21 \n\nInvoice Date: 01 OCT 20',
        'Kamesk',
        'Bid',
        '5500',
        '0.69',
        '251',
        '5249',
        FlatButton(
            color: Colors.red,
            onPressed: () {},
            child: ListTile(
                title: Text('Rejected'),
                trailing: Icon(Icons.panorama_fish_eye)))),
  ];

  void sort<T>(Comparable<T> getField(Dessert d), bool ascending) {
    desserts.sort((Dessert a, Dessert b) {
      if (!ascending) {
        final Dessert c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;
  final cellStyle = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= desserts.length) return null;
    final Dessert dessert = desserts[index];
    return DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: null,
        cells: <DataCell>[
          DataCell(Text(
            '${dessert.invParticulars}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${dessert.invAmount}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${dessert.dates}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${dessert.bidBy}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${dessert.bidType}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${dessert.bidAmt}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${dessert.bidRate}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${dessert.platFee}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${dessert.netAmount}',
            style: cellStyle,
          )),
          DataCell(InkWell(
              onTap: () {
                // capsaPrint(dessert.invParticulars);
              },
              child: MaterialButton(
                color: Colors.red,
                onPressed: () {},
                child: Text(
                  'Rejected',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ))),
        ]);
  }

  @override
  int get rowCount => desserts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}


class MyBidsDataSource extends DataTableSource {
  BuildContext context;
  List<BidHistoryModel> data = <BidHistoryModel>[];
  //TabBarModel tabBarModel;

  MyBidsDataSource(this.data, this.context);

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

    return DataRow.byIndex(index: index, selected: false, onSelectChanged: null, cells: <DataCell>[
      DataCell(Text(
        (index + 1).toString(),
        style: dataTableBodyTextStyle,
      )),
      // DataCell(SizedBox(
      //   width: 150,
      //   child: Text(
      //     bids.companyName,
      //     maxLines: 3,
      //     overflow: TextOverflow.ellipsis,
      //     style: dataTableBodyTextStyle,
      //   ),
      // )),
      DataCell(SizedBox(
        width: 150,
        child: Text(
          bids.customerName,
          style: dataTableBodyTextStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      )),
      DataCell(Text(
        formatCurrency(
          bids.invoiceValue,
        ),
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        formatCurrency(
          bids.discountVal,
        ),
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        bids.currency,
        style: dataTableBodyTextStyle,
      )),
      DataCell(Text(
        DateFormat.yMMMd().format(DateFormat(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            .parse(bids.endDate)),
        style: dataTableBodyTextStyle,
      )),
      DataCell(_status(bids, context)),
      DataCell(
        // Figma Flutter Generator Data1Widget - TEXT
          InkWell(
            onTap: () {
              Beamer.of(context).beamToNamed(
                  '/bid-details/' +
                      bids.invoiceNumber +
                      '/' +
                      bids.discountVal);
            },
            child: Padding(
              padding:
              const EdgeInsets.all(8.0),
              child: Text(
                'View',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(
                        0, 152, 219, 1),
                    // fontFamily: 'Poppins',
                    fontSize: 15,
                    letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight:
                    FontWeight.normal,
                    height: 1),
              ),
            ),
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

Widget _status(BidHistoryModel bids, BuildContext context) {
  // return Text(bids.historyStatus);
  String _text = 'Pending';
  var clr = Color.fromRGBO(235, 87, 87, 1);
  if (bids.historyStatus == '0') {
    _text = 'Pending';
    clr = HexColor('#F2994A');
  } else if (bids.historyStatus == '1') {
    _text = 'Accepted';
    clr = HexColor("#219653");
  } else if (bids.historyStatus == '2') {
    _text = 'Rejected';
    clr = Color.fromRGBO(235, 87, 87, 1);
  }

  return Text(
    _text,
    textAlign: TextAlign.left,
    style: TextStyle(
        color: clr,
        // fontFamily: 'Poppins',
        fontSize: Responsive.isMobile(context) ? 12 : 15,
        letterSpacing:
        0 /*percentages not used in flutter. defaulting to zero*/,
        fontWeight: FontWeight.normal,
        height: 1),
  );
}