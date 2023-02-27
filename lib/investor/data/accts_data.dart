import 'package:capsa/admin/dialogs/investor_dialogs.dart';
import 'package:capsa/common/app_theme.dart';

import 'package:capsa/functions/to_upper_case.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AcctTableData {
  final String invDetails;
  final String invAmt;
  final String invDueDate;
  final String bidAmt;
  final String bidRate;
  final String status;

  AcctTableData(this.invDetails, this.invAmt, this.invDueDate, this.bidAmt,
      this.bidRate, this.status);
}

class AcctTableDataSource extends DataTableSource {
  final List<AcctTableData> data = <AcctTableData>[

  ];
  void _sort<T>(Comparable<T> getField(AcctTableData d), bool ascending) {
    data.sort((AcctTableData a, AcctTableData b) {
      if (!ascending) {
        final AcctTableData c = a;
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
    if (index >= data.length) return null;
    final AcctTableData d = data[index];
    return DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: null,
        cells: <DataCell>[
          DataCell(Text(
            (index + 1).toString(),
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.invDetails}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.invAmt}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.invDueDate}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.bidRate}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.bidAmt}',
            style: cellStyle,
          )),
          DataCell(Theme(
            data: appTheme,
            child: ListTile(
              trailing: IconButton(
                  icon: Builder(builder: (context) {
                    if (d.status == 'Approved') {
                      return IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.file_download),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Sale Agreement",
                                  style: titleStyle,
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    constraints: BoxConstraints(minWidth: 750),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: SfPdfViewer.network(
                                            'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Digital Signature',
                                            style: lableStyle.copyWith(
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: TextFormField(
                                                inputFormatters: [
                                                  UpperCaseTextFormatter(),
                                                ],
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                keyboardType:
                                                    TextInputType.text,
                                                validator: (String value) {
                                                  if (value.trim().isEmpty) {
                                                    return 'Cannot be empty';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Enter First Name & Last Name'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Expanded(
                                                child: MaterialButton(
                                              height: 50,
                                              color: Colors.green,
                                              child: Text(
                                                'Download',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () async {},
                                            ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (d.status == 'Pending') {
                      return Icon(Icons.edit);
                    }
                    return Container();
                  }),
                  onPressed: () {}),
              title: TextButton(
                onPressed: () {},
                child: Text(
                  '${d.status}',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: d.status == 'Approved'
                        ? Colors.green
                        : d.status == 'Pending'
                            ? Colors.orange
                            : Colors.red),
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
