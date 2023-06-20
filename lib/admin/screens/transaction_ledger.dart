import 'package:capsa/admin/data/ledger_table_data.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';
import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/common/app_theme.dart';

class TransactionLedger extends StatefulWidget {
  const TransactionLedger({Key key}) : super(key: key);

  @override
  _TransactionLedgerState createState() => _TransactionLedgerState();
}

class _TransactionLedgerState extends State<TransactionLedger> {
  int _rowsPerPage = 20;
  int _sortColumnIndex;
  bool _sortAscending = true;

  List<String> _options = [];
  List ledgerAccNamesList = [];
  String _selectedOption;
  bool loading = false;
  String searchInvoiceText = '';

  num _tBal = 0;

  var _selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).getAllAccountTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    // final _getBankDetails = profileProvider.getBankDetails;
    final _transactionDetails = profileProvider.ledgerTransactionDetails;

    _options = profileProvider.ledgerAccNames;
    ledgerAccNamesList = profileProvider.ledgerAccNamesList;

    final AcctTableDataSource _historyDataSource = AcctTableDataSource(_transactionDetails, title: 'Transaction\'s Ledger');
    _tBal = 0;
    num  depositAmt = 0;
    num withdrawAmt  = 0;
    if (_selectedValue != null) {
      _transactionDetails.forEach((element) {
        depositAmt = depositAmt + num.parse(element.deposit_amt);
        withdrawAmt = withdrawAmt + num.parse(element.withdrawl_amt);
      });
      _tBal = (depositAmt) - (withdrawAmt);
    }

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
                // Expanded(
                //   child: InvoiceScreenCard(
                //     enquiryData: [],
                //     title: widget.title,
                //   ),
                // ),
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
                            'Transaction\'s Ledger',
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
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          isExpanded: false,
                          hint: Text('Select Filter'),
                          value: _selectedOption,
                          onChanged: (newValue) async {
                            setState(() {
                              int index = _options.indexOf(newValue);

                              _selectedOption = newValue;
                              if (index > 0)
                                _selectedValue = ledgerAccNamesList[index - 1];
                              else
                                _selectedValue = null;
                              loading = true;

                              // capsaPrint(_selectedValue);
                            });
                            await Provider.of<ProfileProvider>(context, listen: false).getAllAccountTransactions(filter: _selectedValue);
                            setState(() {
                              loading = false;
                            });
                          },
                          items: _options.map((option) {
                            return DropdownMenuItem(
                              child: Text(option),
                              value: option,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Responsive.isMobile(context) ? 12 : 20,
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
                  height: Responsive.isMobile(context) ? 8 : 8,
                ),
                if (loading)
                  Center(child: CircularProgressIndicator())
                else
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    color: Colors.white,
                    child: Theme(
                      data: tableTheme,
                      child: PaginatedDataTable(
                          header: Row(
                            children: [
                              if (_selectedValue != null) Text('Total balance : ' + formatCurrency(_tBal.toStringAsFixed(2))),
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
                                          hintText: 'Search by name',
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

                                          Provider.of<ProfileProvider>(context, listen: false).getAllAccountTransactions(search: searchInvoiceText);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.download_rounded),
                                onPressed: () {
                                  final find = ',';
                                  final replaceWith = '';
                                  List<List<dynamic>> rows = [];
                                  rows.add([
                                    "Name",
                                    "Account",
                                    "Date",
                                    "Opening Balance",
                                    "Deposit",
                                    "Withdrawal",
                                    "Closing Balance",
                                    "Narration",
                                  ]);
                                  for (int i = 0; i < _transactionDetails.length; i++) {
                                    List<dynamic> row = [];
                                    row.add(_transactionDetails[i].name.replaceAll(find, replaceWith));
                                    row.add(_transactionDetails[i].account_number.replaceAll(find, replaceWith));
                                    row.add(_transactionDetails[i].created_on.replaceAll(find, replaceWith));
                                    // row.add(_transactionDetails[i].order_number.replaceAll(find, replaceWith));
                                    row.add(_transactionDetails[i].opening_balance.replaceAll(find, replaceWith));
                                    row.add(_transactionDetails[i].deposit_amt.replaceAll(find, replaceWith));
                                    row.add(_transactionDetails[i].withdrawl_amt.replaceAll(find, replaceWith));
                                    row.add(_transactionDetails[i].closing_balance.replaceAll(find, replaceWith));
                                    row.add(_transactionDetails[i].narration.replaceAll(find, replaceWith));
                                    rows.add(row);
                                  }

                                  String dataAsCSV = const ListToCsvConverter().convert(
                                    rows,
                                  );
                                  exportToCSV(dataAsCSV,fName: "Transaction Ledger.csv");
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
                              // numeric: true,
                              label: Text('Name', style: tableHeadlineStyle),
                            ),
                            DataColumn(
                              // numeric: true,
                              label: Text('Account No.', style: tableHeadlineStyle),
                            ),
                            DataColumn(
                              label: Text('Date', style: tableHeadlineStyle),
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
                              //numeric: true,
                              label: Text('Status', style: tableHeadlineStyle),
                            ),
                            // DataColumn(
                            //   label: Text('Status', style: tableHeadlineStyle),
                            // ),
                            DataColumn(
                              label: Text('Narration', style: tableHeadlineStyle),
                            ),
                            DataColumn(
                              label: Text('', style: tableHeadlineStyle),
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
