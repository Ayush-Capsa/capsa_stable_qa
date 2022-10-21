import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/blocked_amount_data.dart';

import 'package:capsa/admin/providers/action_model.dart';

import 'package:capsa/admin/widgets/invoices_screen_card.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BlockedAmountScreen extends StatefulWidget {
  final String title;

  const BlockedAmountScreen({Key key, this.title}) : super(key: key);

  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<BlockedAmountScreen> {
  int _rowsPerPage = 20;
  int _sortColumnIndex;
  bool _sortAscending = true;

  var searchInvoiceText = '';


  callsetstate (){

    setState(() {

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isMobile(context)
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
          Expanded(
            child: InvoiceScreenCard(
              enquiryData: [],
              title: widget.title,
            ),
          ),
        ],
      )
          : ListView(
        padding: Responsive.isDesktop(context) ? const EdgeInsets.fromLTRB(20, 0, 20, 0) : const EdgeInsets.fromLTRB(5, 0, 5, 0),
        children: <Widget>[
          Row(
            children: [
              Expanded(
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
              Responsive.isDesktop(context)
                  ? Spacer(
                flex: 3,
              )
                  : Container(),
              Expanded(
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
                        hintText: 'Search by BVN',
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
            ],
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 12 : 30,
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
            height: Responsive.isMobile(context) ? 12 : 35,
          ),
          Row(
            children: [
              Spacer(
                flex: Responsive.isDesktop(context) ? 4 : 1,
              ),
            ],
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 8 : 35,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            color: Colors.white,
            child: Theme(
              data: tableTheme,
              child: FutureBuilder<Object>(
                  future: Provider.of<ActionModel>(context, listen: false).queryBlockedAmount(search: searchInvoiceText),
                  builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
                    List<BlockedAmountData> _enquiryDataList = <BlockedAmountData>[];

                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: Text('Loading...'),
                      );
                    }
                    if (snapshot.hasData) {
                      dynamic _data = snapshot.data;

                      if (_data['res'] == 'success') {
                        num gTotal = 0;
                        var _results = _data['data'];
                        _results.forEach((element) {
                          // capsaPrint('total Start');

                          num total = 0;
                          // total = (element['requestor_fee']) + (element['investor_fee']);
                          // capsaPrint('total Start2');

                          // capsaPrint(total);
                          gTotal = gTotal + total;

                          _enquiryDataList.add(BlockedAmountData(
                            account_number: element['account_number'].toString(),
                            order_number: element['order_number'].toString(),
                            stat_txt: element['stat_txt'].toString(),
                            status: element['status'].toString(),
                            blocked_amt: element['blocked_amt'].toString(),
                            closing_balance: element['closing_balance'].toString(),
                            opening_balance: element['opening_balance'].toString(),
                            created_on: element['created_on'].toString(),
                            PAN_NO: element['PAN_NO'].toString(),
                            NAME: element['NAME'].toString(),
                            nadId: element['nadId'].toString(),
                          ));
                        });

                        final BlockedAmountDataSource _historyDataSource = BlockedAmountDataSource(context,_enquiryDataList, gTotal.toString(),Provider.of<ActionModel>(context, listen: false),callsetstate);

                        return PaginatedDataTable(
                            header: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.download_rounded),
                                //   onPressed: () {
                                //     final find = ',';
                                //     final replaceWith = '';
                                //     List<List<dynamic>> rows = [];
                                //     rows.add([
                                //       "#",
                                //       "Date",
                                //       "invoiceNo",
                                //       "Status",
                                //       "RequestorBVN",
                                //       "InvestorBVN",
                                //       "RequestorFee(₦)",
                                //       "investorFee(₦)",
                                //       "Totalfee(₦)",
                                //     ]);
                                //
                                //     num gTotal = 0;
                                //     for (int i = 0; i < _enquiryDataList.length; i++) {
                                //       List<dynamic> row = [];
                                //
                                //       num total = 0;
                                //       var intDate =
                                //       DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd").parse(_enquiryDataList[i].created_at)).toString();
                                //       total = (num.parse(_enquiryDataList[i].requestor_fee) + num.parse(_enquiryDataList[i].investor_fee));
                                //       row.add((i + 1));
                                //       row.add(intDate);
                                //       row.add(_enquiryDataList[i].invoice_no);
                                //       row.add(_enquiryDataList[i].ohDueIn + '\n' + _enquiryDataList[i].ohStatus);
                                //       row.add(_enquiryDataList[i].requestor_pan + '\n' + _enquiryDataList[i].requestor_name);
                                //       row.add(_enquiryDataList[i].investor_pan + '\n' + _enquiryDataList[i].investor_name);
                                //
                                //       row.add(_enquiryDataList[i].requestor_fee);
                                //       row.add(_enquiryDataList[i].investor_fee);
                                //       row.add(total);
                                //       gTotal = gTotal + total;
                                //       rows.add(row);
                                //     }
                                //
                                //     List<dynamic> row = [];
                                //     row.add('');
                                //     row.add('');
                                //     row.add('');
                                //     row.add('');
                                //     row.add('');
                                //     row.add('');
                                //     row.add('Grand Total');
                                //     row.add(gTotal.toString());
                                //     rows.add(row);
                                //
                                //     String dataAsCSV = const ListToCsvConverter().convert(
                                //       rows,
                                //     );
                                //     var now = new DateTime.now();
                                //     exportToCSV(dataAsCSV, fName: "Revenue Amount " + new DateFormat("yyyy-MM-dd-hh-mm").format(now) + ".csv");
                                //   },
                                // ),
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
                              setState(() {
                                _rowsPerPage = value;
                              });
                            },
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text('#', style: tableHeadlineStyle),
                              ),
                              DataColumn(
                                // numeric: true,
                                label: Text(' BVN', style: tableHeadlineStyle),
                              ),
                              DataColumn(
                                // numeric: true,
                                label: Text(' Account', style: tableHeadlineStyle),
                              ),
                              DataColumn(
                                // numeric: true,
                                label: Text('Date', style: tableHeadlineStyle),
                              ),

                              DataColumn(
                                label: Text('Status', style: tableHeadlineStyle),
                              ),


                              DataColumn(
                                label: Text('Blocked Amount', style: tableHeadlineStyle),
                              ),

                              DataColumn(
                                label: Text('Action', style: tableHeadlineStyle),
                              ),

                            ],
                            source: _historyDataSource);
                      } else {
                        return Center(
                          child: Text('Error Loading Data.'),
                        );
                      }
                    } else {
                      return Center(
                        child: Text('Loading...'),
                      );
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
