import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

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