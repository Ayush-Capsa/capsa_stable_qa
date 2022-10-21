import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/anchor_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/widgets/anchor_list_card.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class AnchorList extends StatefulWidget {
  final String title;

  const AnchorList({Key key, this.title}) : super(key: key);

  @override
  _AnchorListState createState() => _AnchorListState();
}

class _AnchorListState extends State<AnchorList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Responsive.isMobile(context)
                ? AccountTable()
                : Padding(
                    padding: Responsive.isMobile(context)
                        ? const EdgeInsets.fromLTRB(5, 0, 5, 0)
                        : const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '${widget.title}',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 5 : 30,
                        ),
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).primaryColor,
                            thickness: 0,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 8 : 35,
                        ),
                        Expanded(child: AccountTable()),
                      ],
                    ),
                  ),
          ),
        ));
      }),
    );
  }
}

class AccountTable extends StatefulWidget {
  final String title;

  const AccountTable({Key key, this.title}) : super(key: key);

  @override
  _AccountTableState createState() => _AccountTableState();
}

class _AccountTableState extends State<AccountTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).size.width < 800
          ? FutureBuilder<Object>(
              future: Provider.of<ActionModel>(context, listen: false)
                  .queryAnchorList(),
              builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
                if (snapshot.hasData) {
                  dynamic _data = snapshot.data;
                  // capsaPrint(_data);

                  List<AnchorData> _enquiryData = <AnchorData>[];

                  if (_data['res'] == 'success') {
                    var _results = _data['data']['results'];

                    _results.forEach((element) {
                      _enquiryData.add(AnchorData(
                        element['company_name'],
                        element['company_name'],
                        element['PAN'],
                        element['email'],
                        element['remarks'],
                        element['contact_num'],
                        element['role'],
                        element['role2'],
                        element['address'],
                        element['city'],
                        element['state'],
                        element['ACTIVE'].toString(),
                        element['modified_at'],
                        element['industry'],
                        element['keyPerson'],
                        element['founded'],
                        element['CIN'],
                        element['account_number'],
                      ));
                    });
                  } else {
                    return Center(
                      child: Text('Error Loading Data.'),
                    );
                  }
                  return AnchorListCard(
                    enquiryData: _enquiryData,
                    title: widget.title,
                  );
                } else {
                  return Center(
                    child: Text('Loading...'),
                  );
                }
              })
          : ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  color: Colors.white,
                  child: FutureBuilder<Object>(
                      future: Provider.of<ActionModel>(context, listen: false)
                          .queryAnchorList(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Object> snapshot) {
                        if (snapshot.hasData) {
                          dynamic _data = snapshot.data;
                          // capsaPrint(_data);

                          List<AnchorData> _enquiryData = <AnchorData>[];

                          if (_data['res'] == 'success') {
                            var _results = _data['data']['results'];

                            _results.forEach((element) {
                              _enquiryData.add(AnchorData(
                                element['company_name'],
                                element['company_name'],
                                element['PAN'],
                                element['email'],
                                element['remarks'],
                                element['contact_num'],
                                element['role'],
                                element['role2'],
                                element['address'],
                                element['city'],
                                element['state'],
                                element['ACTIVE'].toString(),
                                element['modified_at'],
                                element['industry'],
                                element['keyPerson'],
                                element['founded'],
                                element['CIN'],
                                element['account_number'],
                              ));
                            });
                          } else {
                            return Center(
                              child: Text('Error Loading Data.'),
                            );
                          }

                          final AnchorListDataSource _anchorListDataSource =
                              AnchorListDataSource(
                                  context, _enquiryData, widget.title);
                          return Theme(
                            data: tableTheme,
                            child: PaginatedDataTable(
                                dataRowHeight: 60,
                                columnSpacing: 42,
                                onPageChanged: (value) {
                                  capsaPrint('$value');
                                },
                                // columnSpacing: 110,
                                availableRowsPerPage: [5, 10, 20],
                                rowsPerPage: _rowsPerPage,
                                onRowsPerPageChanged: (int value) {
                                  _rowsPerPage = value;
                                },
                                sortColumnIndex: _sortColumnIndex,
                                sortAscending: _sortAscending,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Text('S.No.',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('BVN No.',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('Company Name',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label:
                                        Text('CAC', style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('Address',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('Industry',
                                        style: tableHeadlineStyle),
                                  ),
                                ],
                                source: _anchorListDataSource),
                          );
                        } else {
                          return Center(
                            child: Text('Loading...'),
                          );
                        }
                      }),
                )
              ],
            ),
    );
  }
}
