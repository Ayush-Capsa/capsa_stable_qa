import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/enquiry_list_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/widgets/enquiry_card.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EnquiryList extends StatefulWidget {
  final String title;

  const EnquiryList({Key key, this.title}) : super(key: key);

  @override
  _EnquiryListState createState() => _EnquiryListState();
}

class _EnquiryListState extends State<EnquiryList> {
  var searchInvoiceText = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Responsive.isMobile(context)
                ? AccountTable(
                    title: widget.title,
                  )
                : Padding(
                    padding:
                        MediaQuery.of(context).size.width < 800 ? const EdgeInsets.fromLTRB(5, 0, 5, 0) : const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '${widget.title}',
                                    style: TextStyle(fontSize: 22, color: Colors.grey[700], fontWeight: FontWeight.bold, letterSpacing: 1),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: <Widget>[
                                    TextFormField(
                                      // onFieldSubmitted: (value) {
                                      //   // after pressing enter
                                      //   capsaPrint(value);
                                      // },
                                      onChanged: (value) {
                                        searchInvoiceText = value;
                                        if (value == "") setState(() {});
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Search by name, bvn, rc number & mobile',
                                        // suffixIcon: Icon(
                                        //   Icons.search,
                                        //   color: Colors.blueGrey.withOpacity(0.9),
                                        //
                                        // ),
                                      ),
                                      // onTap: () {

                                      // capsaPrint("Invoice");

                                      // },
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.blueGrey.withOpacity(0.9),
                                      ),
                                      onPressed: () {
                                        // do something

                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                        Expanded(
                            child: AccountTable(
                          title: widget.title,
                          filter: searchInvoiceText,
                        )),
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
  final String filter;

  const AccountTable({Key key, this.title, this.filter}) : super(key: key);

  @override
  _AccountTableState createState() => _AccountTableState();
}

class _AccountTableState extends State<AccountTable> {
  int _rowsPerPage = 10;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // capsaPrint('widget.title');
    // capsaPrint(widget.title);
    return Scaffold(
        body: MediaQuery.of(context).size.width < 800
            ? FutureBuilder<Object>(
                future: Provider.of<ActionModel>(context, listen: false).queryEnquiry(widget.title, widget.filter),
                builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: Text('Loading...'),
                    );
                  }
                  if (snapshot.hasData) {
                    dynamic _data = snapshot.data;

                    List<EnquiryData> _enquiryData = <EnquiryData>[];

                    if (_data['res'] == 'success') {
                      var _results = _data['data']['results'];

                      _results.forEach((element) {
                        _enquiryData.add(EnquiryData(
                          element['req_name'],
                          element['comp_name'],
                          element['bvn_num'],
                          element['email'],
                          element['remarks'],
                          element['contact_number'],
                          element['role'],
                          element['role2'],
                          element['address'],
                          element['city'],
                          element['state'],
                          element['status'],
                          element['modified_at'],
                          element['industry'],
                          element['keyPerson'],
                          element['founded'],
                          element['cac'],
                        ));
                      });
                      return EnquiryCard(
                        enquiryData: _enquiryData,
                        title: widget.title,
                      );
                    } else {
                      return Center(
                        child: Text('Error Loading Data.'),
                      );
                    }
                  }
                  return Center(
                    child: Text('Loading...'),
                  );
                })
            : ListView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    color: Colors.white,
                    child: FutureBuilder<Object>(
                        future: Provider.of<ActionModel>(context, listen: false).queryEnquiry(widget.title, widget.filter),
                        builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return Center(
                              child: Text('Loading...'),
                            );
                          }
                          if (snapshot.hasData) {
                            dynamic _data = snapshot.data;
                            // capsaPrint('_data');
                            // capsaPrint(_data);

                            List<EnquiryData> _enquiryData = <EnquiryData>[];

                            if (_data['res'] == 'success') {
                              var _results = _data['data']['results'];

                              _results.forEach((element) {
                                _enquiryData.add(EnquiryData(
                                  element['req_name'],
                                  element['comp_name'],
                                  element['bvn_num'],
                                  element['email'],
                                  element['remarks'],
                                  element['contact_number'],
                                  element['role'],
                                  element['role2'],
                                  element['address'],
                                  element['city'],
                                  element['state'],
                                  element['status'],
                                  element['modified_at'],
                                  element['industry'],
                                  element['keyPerson'],
                                  element['founded'],
                                  element['cac'],
                                ));
                              });
                            } else {
                              return Center(
                                child: Text('Error Loading Data.'),
                              );
                            }

                            final EnquiryDataSource _enquiryDataSource = EnquiryDataSource(context, _enquiryData, widget.title);

                            return Theme(
                              data: tableTheme,
                              child: PaginatedDataTable(
                                  header: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.download_rounded),
                                        onPressed: () {
                                          final find = ',';
                                          final replaceWith = '';
                                          List<List<dynamic>> rows = [];
                                          rows.add([
                                            // "Requestor Name",
                                            "Company name",
                                            "Email",
                                            "Remark",
                                            "BVN ",
                                            "Role ",
                                            "Mobile no.",
                                            "Status",
                                          ]);
                                          for (int i = 0; i < _enquiryData.length; i++) {
                                            List<dynamic> row = [];

                                            var _role = (_enquiryData[i].role == "requestor") ? "Vendor" : "Buyer";

                                            if (_enquiryData[i].role == "investor") if (_enquiryData[i].role2 != null && _enquiryData[i].role2 != '')
                                              _role = _role + '\n' + _enquiryData[i].role2;

                                            // row.add(_enquiryData[i].bvnName != null ? _enquiryData[i].bvnName : "");
                                            row.add(_enquiryData[i].compName != null ? _enquiryData[i].compName : "");
                                            row.add(_enquiryData[i].email);
                                            row.add(_enquiryData[i].remark);
                                            row.add(_enquiryData[i].bvnNum);
                                            row.add(_role);
                                            row.add(_enquiryData[i].contactNumber);
                                            row.add(_enquiryData[i].status);

                                            rows.add(row);
                                          }

                                          String dataAsCSV = const ListToCsvConverter().convert(
                                            rows,
                                          );
                                          var now = new DateTime.now();
                                          exportToCSV(dataAsCSV, fName: widget.title + " " + new DateFormat("yyyy-MM-dd-hh-mm").format(now) + ".csv");
                                        },
                                      ),
                                    ],
                                  ),
                                  dataRowHeight: 60,
                                  columnSpacing: 42,
                                  onPageChanged: (value) {
                                    // capsaPrint('$value');
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
                                      label: Text('Requestor Name', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      label: Text('Company Name', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      label: Text('Email', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      label: Text('Remarks', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      label: Text('BVN', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      label: Text('Mobile Number', style: tableHeadlineStyle),
                                    ),
                                    if (widget.title == 'Buyer On-boarding')
                                      DataColumn(
                                        label: Text('Type', style: tableHeadlineStyle),
                                      ),
                                    DataColumn(
                                      label: Text('Status', style: tableHeadlineStyle),
                                    ),
                                  ],
                                  source: _enquiryDataSource),
                            );
                          } else {
                            return Center(
                              child: Text('Loading...'),
                            );
                          }
                        }),
                  )
                ],
              ));
  }
}
