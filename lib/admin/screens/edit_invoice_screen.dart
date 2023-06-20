import 'dart:convert';

import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/blocked_amount_data.dart';
import 'package:capsa/admin/models/invoice_model.dart';

import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/admin/screens/edit_account/edit_ben_details_screen.dart';
import 'package:capsa/admin/screens/edit_account/edit_invoice_admin.dart';

import 'package:capsa/admin/widgets/invoices_screen_card.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../common/constants.dart';
import 'package:http/http.dart' as http;

class EditInvoiceScreen extends StatefulWidget {
  final String title;

  const EditInvoiceScreen({Key key, this.title}) : super(key: key);

  @override
  _EditInvoiceState createState() => _EditInvoiceState();
}

class _EditInvoiceState extends State<EditInvoiceScreen> {
  int _rowsPerPage = 20;
  int _sortColumnIndex;
  bool _sortAscending = true;

  var searchInvoiceText = '';
  var searchBvnNumber = '';
  Map<String, String> anchorGrade = {};

  String dropdownvalue = 'INVESTOR';

  TextEditingController invoiceNumberController = TextEditingController();

  // List of items in our dropdown menu
  var items = [
    'INVESTOR',
    'VENDOR',
    'ANCHOR',
  ];

  bool dataLoaded = false;

  bool companyLoaded = false;

  List<InvoiceModel> invoices = [];

  Future getCompanyName() async {
    String _url = apiUrl + 'dashboard/r/';
    dynamic _uri = _url + 'getCompanyName';
    _uri = Uri.parse(_uri);
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    //_body['panNumber'] = userData['panNumber'];
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    //capsaPrint("Bank Data $data");
    return data;
  }

  void getData(String search) async {
    setState(() {
      dataLoaded = false;
    });
   // capsaPrint('Pass 1 invoice data');
    if(!companyLoaded){
      dynamic _data = await getCompanyName();
     // capsaPrint('Pass 2 invoice data $_data');
      var _items = _data['data'];
      Map<String, bool> _isBlackListed = {};


      var anchorNameList = [];

      if (_data['res'] == 'success') {
        anchorNameList = _items;
        _items.forEach((element) {
          _isBlackListed[element['name'].toString()] =
          element['isBlacklisted'] != null
              ? element['isBlacklisted'] == '1'
              ? true
              : false
              : false;
          anchorGrade[element['name'].toString()] =
              element['grade'] ?? '';
        });
        companyLoaded = true;
      }
     // capsaPrint('Pass 3 invoice data');
    }
    //capsaPrint('Pass 4 invoice data');
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    invoices = [];
    invoices = await profileProvider.getInvoicesByInvoiceNumber(search: search);
   // capsaPrint('Pass 4');

    setState(() {
      dataLoaded = true;
    });
  }

  void blockUser(AccountData data, BuildContext context) async {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                data.isBlackListed
                    ? Text(
                        'Are you sure you want to unblock user ${data.name}?')
                    : Text('Are you sure you want to block user ${data.name}?'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                dynamic response = data.isBlackListed
                    ? await profileProvider.unblockAccount(data.panNumber)
                    : await profileProvider.blockAccount(data.panNumber);
                showToast(response['message'], context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData('');
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      body: dataLoaded
          ? ListView(
              padding: Responsive.isDesktop(context)
                  ? const EdgeInsets.fromLTRB(20, 0, 20, 0)
                  : const EdgeInsets.fromLTRB(5, 0, 5, 0),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Edit Invoice Details',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    Responsive.isDesktop(context)
                        ? Spacer(
                            flex: 3,
                          )
                        : Container(),
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
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: TextFormField(
                              // onFieldSubmitted: (value) {
                              //   // after pressing enter
                              //   capsaPrint(value);
                              // },
                              controller: invoiceNumberController,
                              onChanged: (value) {
                                searchInvoiceText = value;
                                if (value == "") setState(() {});
                              },
                              decoration: InputDecoration(
                                hintText: 'Search Invoice Number',
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
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.blueGrey.withOpacity(0.9),
                            ),
                            onPressed: () {
                              // do something
                              getData(searchInvoiceText.trim());

                              //profileProvider.getInvoicesByInvoiceNumber(searchInvoiceText.trim());

                              //setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                invoices.isNotEmpty?
                // PaginatedDataTable(
                //     // header: Row(
                //     //   children: [
                //     //     if (_selectedValue != null) Text('Total balance : ' + formatCurrency(_tBal.toStringAsFixed(2))),
                //     //     const Spacer(),
                //     //     IconButton(
                //     //       icon: Icon(Icons.download_rounded),
                //     //       onPressed: () {
                //     //         final find = ',';
                //     //         final replaceWith = '';
                //     //         List<List<dynamic>> rows = [];
                //     //         rows.add([
                //     //           "Name",
                //     //           "Account",
                //     //           "Date",
                //     //           "Opening Balance",
                //     //           "Deposit",
                //     //           "Withdrawal",
                //     //           "Closing Balance",
                //     //           "Narration",
                //     //         ]);
                //     //         for (int i = 0; i < _transactionDetails.length; i++) {
                //     //           List<dynamic> row = [];
                //     //           row.add(_transactionDetails[i].name.replaceAll(find, replaceWith));
                //     //           row.add(_transactionDetails[i].account_number.replaceAll(find, replaceWith));
                //     //           row.add(_transactionDetails[i].created_on.replaceAll(find, replaceWith));
                //     //           // row.add(_transactionDetails[i].order_number.replaceAll(find, replaceWith));
                //     //           row.add(_transactionDetails[i].opening_balance.replaceAll(find, replaceWith));
                //     //           row.add(_transactionDetails[i].deposit_amt.replaceAll(find, replaceWith));
                //     //           row.add(_transactionDetails[i].withdrawl_amt.replaceAll(find, replaceWith));
                //     //           row.add(_transactionDetails[i].closing_balance.replaceAll(find, replaceWith));
                //     //           row.add(_transactionDetails[i].narration.replaceAll(find, replaceWith));
                //     //           rows.add(row);
                //     //         }
                //     //
                //     //         String dataAsCSV = const ListToCsvConverter().convert(
                //     //           rows,
                //     //         );
                //     //         exportToCSV(dataAsCSV,fName: "Transaction Ledger.csv");
                //     //       },
                //     //     ),
                //     //   ],
                //     // ),
                //     dataRowHeight: 65,
                //     columnSpacing: 42,
                //     onPageChanged: (value) {
                //       // capsaPrint('$value');
                //     },
                //     // columnSpacing: 110,
                //     availableRowsPerPage: [5, 10, 20],
                //     rowsPerPage: _rowsPerPage,
                //     onRowsPerPageChanged: (int value) {
                //       setState(() {
                //         _rowsPerPage = value;
                //       });
                //     },
                //     sortColumnIndex: _sortColumnIndex,
                //     sortAscending: _sortAscending,
                //     columns: <DataColumn>[
                //       DataColumn(
                //         // numeric: true,
                //         label: Text('Anchor Name', style: tableHeadlineStyle),
                //       ),
                //       DataColumn(
                //         // numeric: true,
                //         label: Text('Account No.', style: tableHeadlineStyle),
                //       ),
                //       DataColumn(
                //         label: Text('Date', style: tableHeadlineStyle),
                //       ),
                //       DataColumn(
                //         numeric: true,
                //         label: Text('Opening Balance', style: tableHeadlineStyle),
                //       ),
                //       DataColumn(
                //         numeric: true,
                //         label: Text('Deposit', style: tableHeadlineStyle),
                //       ),
                //       DataColumn(
                //         numeric: true,
                //         label: Text('Withdrawal', style: tableHeadlineStyle),
                //       ),
                //       DataColumn(
                //         numeric: true,
                //         label: Text('Closing Balance', style: tableHeadlineStyle),
                //       ),
                //       DataColumn(
                //         //numeric: true,
                //         label: Text('Status', style: tableHeadlineStyle),
                //       ),
                //       // DataColumn(
                //       //   label: Text('Status', style: tableHeadlineStyle),
                //       // ),
                //       DataColumn(
                //         label: Text('Narration', style: tableHeadlineStyle),
                //       ),
                //       DataColumn(
                //         label: Text('', style: tableHeadlineStyle),
                //       ),
                //     ],
                //     source: _historyDataSource),

                DataTable(
                  dataRowHeight: 60,
                  headingTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: HexColor("#0098DB")),
                  columns: dataTableColumn([
                    "Anchor Name",
                    "Grade",
                    "Invoice Number",
                    "Vendor",
                    "Inv Issue Date       ",
                    "Amount (N)",
                    "Inv Due Date         ",
                    "Ext Due Date",
                    //"Tenure",
                    ""
                  ]),
                  rows: <DataRow>[
                    for (int i = 0; i < invoices.length; i++)
                      DataRow(
                        cells: <DataCell>[
                          // DataCell(Text(
                          //   // transaction.created_on,
                          //   '${i + 1}',
                          //   style: dataTableBodyTextStyle,
                          // )),
                          DataCell(Text(
                            // transaction.created_on,
                            invoices[i].anchorName ,
                            style: dataTableBodyTextStyle,
                          )),
                          DataCell(Text(
                            (' ${anchorGrade[invoices[i]
                                .anchorName] ?? 'NA'}'),
                            style: dataTableBodyTextStyle,
                          )),
                          DataCell(Text(
                            // transaction.created_on,
                            invoices[i].invoiceNumber,
                            style: dataTableBodyTextStyle,
                          )),
                          DataCell(Text(
                            // transaction.created_on,
                            invoices[i].customerName,
                            style: dataTableBodyTextStyle,
                          )),
                          DataCell(Text(

                            DateFormat('d MMM, y')
                                .format(DateFormat("yyyy-MM-dd")
                                .parse(invoices[i].invoiceDate))
                                .toString(),
                            style: dataTableBodyTextStyle,
                          )),
                          DataCell(Text(
                            // transaction.created_on,
                            formatCurrency(invoices[i].invoiceValue),
                            style: dataTableBodyTextStyle,
                          )),
                          DataCell(Text(
                            invoices[i].invoiceDueDate != ''?DateFormat('d MMM, y')
                                .format(DateFormat("yyyy-MM-dd")
                                    .parse(invoices[i].invoiceDueDate))
                                .toString() : 'NA',
                            style: dataTableBodyTextStyle,
                          )),
                          DataCell(Text(
                            invoices[i].extendedDueDate != ''?DateFormat('d MMM, y')
                                .format(DateFormat("yyyy-MM-dd")
                                .parse(invoices[i].extendedDueDate))
                                .toString() : 'NA',
                            style: dataTableBodyTextStyle,
                          )),
                          DataCell(PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: (){

                                },
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditInvoiceAdmin(
                                                    invoice: invoices[i]))).then((value) => getData(searchInvoiceText));
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit),
                                      RichText(
                                        text: const TextSpan(
                                          text: 'Edit Invoice',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromRGBO(
                                                  51, 51, 51, 1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // PopupMenuItem(
                              //
                              //   child: InkWell(
                              //     onTap: (){
                              //       Navigator.pop(context);
                              //       Navigator.of(context).push(
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   EditBenDetails(
                              //                       invoice: invoices[i])));
                              //     },
                              //     child: Row(
                              //       children: [
                              //         const Icon(Icons.edit),
                              //         RichText(
                              //           text: const TextSpan(
                              //             text: 'Update Account',
                              //             style: TextStyle(
                              //                 fontSize: 18,
                              //                 fontWeight: FontWeight.w400,
                              //                 color: Color.fromRGBO(
                              //                     51, 51, 51, 1)),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          )),
                        ],
                      ),
                  ],
                )

                    :Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_outlined,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Sorry, No Results Found!',
                            style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight:
                                FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ]),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
