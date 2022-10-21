import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/accts_data.dart';
import 'package:capsa/admin/data/buyer_vendor_list_data.dart';
import 'package:capsa/admin/providers/edit_table_data_provider.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class AccountTable extends StatefulWidget {
  //BuyerVendorListDataSource historyDataSource;

  // AccountTable({Key key, this.historyDataSource}) : super(key: key);
  @override
  _AccountTableState createState() => _AccountTableState();
}

class _AccountTableState extends State<AccountTable> {
  int _rowsPerPage = 15;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    capsaPrint('here');
    final tab = Provider.of<TabBarModel>(context);
    final editTableDataProvider = Provider.of<EditTableDataProvider>(context);
    final BuyerVendorListDataSource _historyDataSource =
        BuyerVendorListDataSource();
    final AcctTableDataSource _acctTableDataSource =
        AcctTableDataSource(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            color: Colors.white,
            child: Theme(
              data: tableTheme,
              child: PaginatedDataTable(
                  dataRowHeight: 60,
                  columnSpacing: 42,
                  onPageChanged: (value) {
                    capsaPrint('$value');
                  },
                  // columnSpacing: 110,
                  availableRowsPerPage: [15],
                  rowsPerPage: _rowsPerPage,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('Name', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('BVN No', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Phone No', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Email', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Address', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('City', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('State', style: tableHeadlineStyle),
                    ),
                    DataColumn(
                      label: Text('Action', style: tableHeadlineStyle),
                    ),
                  ],
                  source: editTableDataProvider.listData != null
                      ? editTableDataProvider.listData
                      : tab.index == 1 || tab.index == 2
                          ? _historyDataSource
                          : _acctTableDataSource),
            ),
          )
        ],
      ),
    );
  }
}
