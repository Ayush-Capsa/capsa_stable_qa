import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class HistoryData {
  final String lender;
  final String invNo;
  final String contact;
  final String date;
  final String dueIn;
  final String payable;
  final String status;

  HistoryData(this.lender, this.invNo, this.contact, this.date, this.dueIn,
      this.payable, this.status);
}

class HistoryDataSource extends DataTableSource {
  final List<HistoryData> data = <HistoryData>[
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Closed'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Closed'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Closed'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
    HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
        '10,000', 'Open'),
  ];
  // void _sort<T>(Comparable<T> getField(HistoryData d), bool ascending) {
  //   data.sort((HistoryData a, HistoryData b) {
  //     if (!ascending) {
  //       final HistoryData c = a;
  //       a = b;
  //       b = c;
  //     }
  //     final Comparable<T> aValue = getField(a);
  //     final Comparable<T> bValue = getField(b);
  //     return Comparable.compare(aValue, bValue);
  //   });
  //   notifyListeners();
  // }

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
    final HistoryData d = data[index];
    return DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: null,
        cells: <DataCell>[
          DataCell(Text(
            '${d.lender}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.invNo}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.contact}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.date}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.dueIn}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.payable}',
            style: cellStyle,
          )),
          DataCell(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  color:
                      d.status == 'Open' ? Colors.green[400] : Colors.red[400],
                  onPressed: () {},
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      d.status,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
          ),
        ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
