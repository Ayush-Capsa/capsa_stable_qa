import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:csv/csv.dart';

import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/rendering.dart';

class Dessert {
  final int no;
  final String transactionDate;
  final String amount;
  final String status;
  final String type;

  bool selected = false;

  Dessert(this.no, this.transactionDate, this.amount, this.status, this.type);
}

class DessertDataSource extends DataTableSource {
  final List<Dessert> desserts = <Dessert>[
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
    Dessert(
      1,
      'Sat 13, July 2021',
      '346,000',
      'Succesful',
      'Deposit',
    ),
  ];

  // void _sort<T>(Comparable<T> getField(Dessert d), bool ascending) {
  //   desserts.sort((Dessert a, Dessert b) {
  //     if (!ascending) {
  //       final Dessert c = a;
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
          DataCell(Text('${dessert.no}')),
          DataCell(Text('${dessert.transactionDate}')),
          DataCell(Text('${dessert.amount}')),
          DataCell(Text('${dessert.status}')),
          DataCell(Text('${dessert.type}')),
        ]);
  }

  @override
  int get rowCount => desserts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

class DataTableDemo extends StatefulWidget {
  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  int _rowsPerPage = 5;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final DessertDataSource _dessertsDataSource = DessertDataSource();

  // void _sort<T>(
  //     Comparable<T> getField(Dessert d), int columnIndex, bool ascending) {
  //   _dessertsDataSource._sort<T>(getField, ascending);
  //   setState(() {
  //     _sortColumnIndex = columnIndex;
  //     _sortAscending = ascending;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            padding: Responsive.isDesktop(context)
                ? const EdgeInsets.fromLTRB(100, 0, 00, 0)
                : const EdgeInsets.all(0),
            children: <Widget>[
          Container(
            margin: Responsive.isDesktop(context)
                ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                : const EdgeInsets.all(0),
            color: Colors.white,
            child: Theme(
              data: tableTheme,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PaginatedDataTable(
                  header: Row(
                    children: [
                      Text(
                        'Last 5 transactions',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.download_rounded),
                        onPressed: () {
                          final find = ',';
                          final replaceWith = '';
                          List<List<dynamic>> rows = [];
                          rows.add([
                            "No",
                            "Transaction Date",
                            "Amount",
                            "Status",
                            "Type",
                          ]);
                          for (int i = 0;
                              i < _dessertsDataSource.desserts.length;
                              i++) {
                            List<dynamic> row = [];
                            row.add(_dessertsDataSource.desserts[i].no);
                            row.add(_dessertsDataSource
                                .desserts[i].transactionDate);
                            row.add(_dessertsDataSource.desserts[i].amount
                                .replaceAll(find, replaceWith));
                            row.add(_dessertsDataSource.desserts[i].status
                                .replaceAll(find, replaceWith));
                            row.add(_dessertsDataSource.desserts[i].type
                                .replaceAll(find, replaceWith));
                            rows.add(row);
                          }

                          String dataAsCSV = const ListToCsvConverter().convert(
                            rows,
                          );
                          exportToCSV(dataAsCSV);
                        },
                      ),
                    ],
                  ),
                  dataRowHeight: 60,
                  columnSpacing: 20,
                  onPageChanged: (value) {
                    capsaPrint('$value');
                  },
                  // columnSpacing: 110,
                  availableRowsPerPage: [
                    5,
                  ],
                  rowsPerPage: _rowsPerPage,
                  onRowsPerPageChanged: (int value) {
                    setState(() {
                      _rowsPerPage = value;
                    });
                  },
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('No.', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label:
                          Text('Transaction Date', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Amount', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Status', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Type', style: tableHeadlineStyle),
                    ),
                  ],
                  source: _dessertsDataSource,
                ),
              ),
            ),
          )
        ]));
  }
}
