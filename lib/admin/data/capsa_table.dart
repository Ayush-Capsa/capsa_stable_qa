import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/investor/data/capsa_table_data.dart';
import 'package:provider/provider.dart';

class CapsaTable extends StatefulWidget {

  final String title ;
  CapsaTable({this.title});

  @override
  _CapsaTableState createState() => _CapsaTableState();
}

class _CapsaTableState extends State<CapsaTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {


    final profileProvider = Provider.of<ProfileProvider>(context);
    // final _getBankDetails = profileProvider.getBankDetails;
    final _transactionDetails = profileProvider.transactionDetails;


    final AcctTableDataSource _historyDataSource = AcctTableDataSource(_transactionDetails, title :  widget.title);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 00, 0),
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            color: Colors.white,
            child: Theme(
              data: tableTheme,
              child: PaginatedDataTable(
                  header: Row(
                    children: [
                      Text(
                        widget?.title  ??  'Account Data',
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
                            "Date",
                            "Ref No",
                            "Opening Balance",
                            "Deposit",
                            "Withdrawal",
                            "Closing Balance",
                            "Status",
                            "Remarks"
                          ]);
                          for (int i = 0;
                          i < _transactionDetails.length;
                          i++) {
                            List<dynamic> row = [];
                            row.add(_transactionDetails[i].created_on
                                .replaceAll(find, replaceWith));
                            row.add(_transactionDetails[i].order_number
                                .replaceAll(find, replaceWith));
                            row.add(_transactionDetails[i].opening_balance
                                .replaceAll(find, replaceWith));
                            row.add(_transactionDetails[i].deposit_amt
                                .replaceAll(find, replaceWith));
                            row.add(_transactionDetails[i].withdrawl_amt
                                .replaceAll(find, replaceWith));
                            row.add(_transactionDetails[i].closing_balance
                                .replaceAll(find, replaceWith));
                            row.add(_transactionDetails[i].status
                                .replaceAll(find, replaceWith));
                            row.add(_transactionDetails[i].stat_txt
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
                  dataRowHeight: 65,
                  columnSpacing: 42,
                  onPageChanged: (value) {
                    // capsaPrint('$value');
                  },
                  // columnSpacing: 110,
                  availableRowsPerPage: [5, 10, 20],
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
                      label: Text('Date', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      // numeric: true,
                      label: Text('Reference No', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text('Opening Balance', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text('Deposit', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text('Withdrawal', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text('Closing Balance', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Status', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Remarks', style: tableHeadlineStyle),
                    ),
                  ],
                  source: _historyDataSource),
            ),
          )
        ],
      ),
    );
  }
}
