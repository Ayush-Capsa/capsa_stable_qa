import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/invoice_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/widgets/card_widget.dart';
import 'package:capsa/admin/widgets/invoices_screen_card.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  final String title;

  const InvoiceScreen({Key key, this.title}) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<String> _options = ['All', 'Invoice Entered', 'Invoice Pending on Anchor','Invoice on Live deals', 'Invoice Bid Accepted', 'Invoice Bid Rejected','Open Invoices for Repayment','Closed Invoices Repayment Done','Expired Invoice without Bidding'];
  List<String> _values = ['all', 'inv_entered', 'inv_pending', 'live_deal', 'bid_accepted', 'bid_rejected','inv_open_repayment','inv_close_repayment','expire_invoice'];
  String _selectedOption, _selectedValue;

  int _rowsPerPage = 5;
  int _sortColumnIndex;
  bool _sortAscending = true;

  var searchInvoiceText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isMobile(context)
          ? Column(
              children: [
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Container(
                //     height: 180,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         CardFragment(
                //           title: 'Total Discounted Value',
                //           subtitle: '33 Discounts',
                //           no: '54,000,000',
                //           width: 320,
                //           icon: LineAwesomeIcons.pie_chart,
                //         ),
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         CardFragment(
                //           title: 'Total Transactions',
                //           subtitle: '103 Accepted',
                //           no: '345',
                //           width: 320,
                //           icon: LineAwesomeIcons.line_chart,
                //         ),
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         CardFragment(
                //           title: 'Total Active Bids',
                //           subtitle: '16 Bids',
                //           no: '20',
                //           width: 320,
                //           icon: LineAwesomeIcons.credit_card,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: const SizedBox(),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            isExpanded: false,
                            hint: Text('Select Filter'),
                            value: _selectedOption,
                            onChanged: (newValue) {
                              setState(() {
                                int index = _options.indexOf(newValue);
                                _selectedOption = newValue;
                                _selectedValue = _values[index];
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
                      flex: Responsive.isDesktop(context) ? 2 : 1,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        isExpanded: false,
                        hint: Text('Select Filter'),
                        value: _selectedOption,
                        onChanged: (newValue) {
                          setState(() {
                            int index = _options.indexOf(newValue);
                            _selectedOption = newValue;
                            _selectedValue = _values[index];
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
                        future: Provider.of<ActionModel>(context, listen: false)
                            .queryInvoiceList(filter: _selectedValue, filterInvoiceNo: searchInvoiceText),
                        builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
                          List<InvoiceData> _enquiryDataList = <InvoiceData>[];

                          if (snapshot.connectionState != ConnectionState.done) {
                            return Center(
                              child: Text('Loading...'),
                            );
                          }

                          if (snapshot.hasData) {
                            dynamic _data = snapshot.data;

                            if (_data['res'] == 'success') {
                              var _results = _data['data']['results'];
                              // capsaPrint(_results);

                              //
                              // 1001status: 1001
                              // ADDED_FOR: ""
                              // ADD_LINE: "Bhilai"
                              // CITY: "Bhilai"
                              // CONTACT: ""
                              // CONTACT_STATUS: 0
                              // COUNTRY: null
                              // COUNTRY_CODE: null
                              // EMAIL: ""
                              // EMAIL_STATUS: 0
                              // LANDING_LICENSE: 0
                              // LANDING_LICENSE_URL: ""
                              // NAME: "Kamesk"
                              // OTP: null
                              // PAN_IMAGE: 0
                              // PAN_IMAGE_URL: null
                              // PAN_NO: "22297342551"
                              // PASSWORD: ""
                              // PROFILE_PIC: null
                              // STATE: "Andaman and Nicobar"
                              // UID: "RC22297342551"
                              // UID_IMAGE: 0
                              // UID_IMAGE_URL: null
                              // about_company: ""
                              // ask_amt: 90300
                              // ask_rate: 1
                              // child_address: "ConAdd3xwi6u532kiu52rii"
                              // colour: "H"
                              // company_invoice_url: "http://18.224.61.114/"
                              // company_name: "Midas Touche"
                              // company_pan: "22151153491"
                              // cust_pan: "22141733973"
                              // customer_gst: "X22141733973XXX"
                              // customer_name: "Stanbic IBTC Bank Plc"
                              // description: ""
                              // digital_name: "RABIAT SUBERU"
                              // digital_name_accept_time: "Fri Dec 18 2020"
                              // digital_name_buyer: ""
                              // digital_name_buyer_accept_time: ""
                              // diigital_signature: "CHUKWUKA NWAGBARA"
                              // discount_hash: "DisTxHash3xwi6u532kiu53dlk"
                              // discount_percentage: 6.23
                              // discount_status: "true"
                              // discount_val: 90300
                              // discounted_date: "2020-12-17T18:30:00.000Z"
                              // docID: "0"
                              // effective_due_date: "2021-01-12T18:30:00.000Z"
                              // id: 65
                              // int_rate: 6.23
                              // inv_no: "EVM14521"
                              // inv_pan: "22297342551"
                              // investor_name: "Kamesk"
                              // investor_pan: "22297342551"
                              // invoice_date: "2020-11-11T18:30:00.000Z"
                              // invoice_discount_hash: "DisBillTxHash3xwi6u532kiu52rij"
                              // invoice_discount_hash_date: "2020-12-18T06:07:56.000Z"
                              // invoice_due_date: "2021-01-12T18:30:00.000Z"
                              // invoice_file: "22151153491_invoice_file-1608287832958.jpeg"
                              // invoice_line_items: null
                              // invoice_number: "EVM14521"
                              // invoice_quantity: 1
                              // invoice_value: 96300
                              // lender_priority: null
                              // minimum_investment: 77040
                              // p_type: 1
                              // payment_status: 1
                              // payment_terms: "TEr"
                              // prop_amt: 90300
                              // prop_datetime: "2020-12-18T10:38:04.000Z"
                              // prop_stat: 1
                              // secret_key: ""
                              // sign_stat: 1
                              // status: 2
                              // trans_hash: "TxHashSC3xwi6u532kiu51xkj"
                              // trans_hash_date: "2020-12-18T06:07:17.000Z"
                              // trans_his: ""
                              // transaction_id: ""
                              // user_id: 168
                              // wallet_address: ""

                              _results.forEach((element) {
                                var ohStatus = '';
                                // var now = new Date();
                                var ohDueIn = '';

                                var curr_date = '';
                                var due_date = '';

                                if (element['payment_status'] != null) if (element['payment_status'].toString() == '1') {
                                  ohStatus = 'Closed';
                                  ohDueIn = '';
                                } else if (element['payment_status'].toString() == '0') {
                                  if (true) {
                                    // if(curr_date > due_date){
                                    ohStatus = 'Overdue';
                                    ohDueIn = 'Immediately';
                                  } else {
                                    ohStatus = 'Open';
                                    ohDueIn = ' Days';
                                    // console.log(ohDueIn);
                                  }
                                }

                                num borr_dp = 0.00;
                                num newAmount = 0.00;
                                var prop_amt = '';
                                var int_rate = '';
                                var ask_amt = '';

                                num propAmt = 0;
                                if (element['prop_amt'] != null) propAmt = element['prop_amt'];

                                num invoiceValue = element['invoice_value'];

                                num pltfee = (((invoiceValue * 0.85) / 100) + 200);
                                if (pltfee < 0) pltfee = 0;
                                if (element['prop_datetime'] == null) pltfee = 0;

                                borr_dp = (propAmt - ((invoiceValue * 0.85) / 100) - 200);
                                if (borr_dp < 0) borr_dp = 0;

                                newAmount = borr_dp;

                                var invoice_value = '';

                                if (element['prop_amt'] != null) {
                                  prop_amt = element['prop_amt'].toString();
                                }

                                if (element['int_rate'] != null) {
                                  int_rate = element['int_rate'].toString() + ' %';
                                }

                                if (element['ask_amt'] != null) {
                                  ask_amt = element['ask_amt'].toString();
                                }

                                if (element['invoice_value'] != null) {
                                  invoice_value = element['invoice_value'].toString();
                                }

                                // t_borr_dp = +t_borr_dp + +borr_dp;
                                // t_pltfee = +t_pltfee + +pltfee;
                                // t_invAmt = +t_invAmt + +invoiceData.invoice_value;
                                //
                                // t_prop_amt = +t_prop_amt + +invoiceData.prop_amt;
                                //

                                _enquiryDataList.add(InvoiceData(
                                    invNum: element['invoice_number'],
                                    seller: element['company_name'],
                                    anchor: element['customer_name'],
                                    companyPan: element['company_pan'],
                                    status: element['status'].toString(),
                                    invAmt: invoice_value,
                                    buyNow: ask_amt,
                                    invDate: element['invoice_date'],
                                    dueDate: element['invoice_due_date'],
                                    discountedOn: element['discounted_date'],
                                    presented: element['status'] == 2 ? 'Yes' : 'No',
                                    proposalStatus: ohStatus + '\n' + ohDueIn,
                                    bidBy: element['investor_name'],
                                    bidType: ( element['p_type'] != null ) ? ( element['p_type'] == 0 ? 'Bid' : 'Pay') : '',
                                    bidAmt: prop_amt,
                                    bidRate: int_rate + '',
                                    platformFree: pltfee.toStringAsFixed(2),
                                    fileName: element['invoice_file'],
                                    newAmount: newAmount.toStringAsFixed(2)));
                              });

                              final InvoiceDataSource _historyDataSource = InvoiceDataSource(_enquiryDataList, pendingScreen: false);

                              return PaginatedDataTable(
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
                                            "Invoice Number",
                                            "Seller",
                                            "Anchor",
                                            "Inv Amount" + ' (₦) ',
                                            "Inv Date",
                                            "Due Date",
                                            "Discounted On",
                                            "presented",
                                            "Proposal Status",
                                            "Bid By",
                                            "Bid Type",
                                            "Bid Amount",
                                            "Bid Rate(Monthly)",
                                            "Platform Fee",
                                            "Net Amount",
                                          ]);
                                          for (int i = 0; i < _enquiryDataList.length; i++) {
                                            List<dynamic> row = [];
                                            var intDate = DateFormat('yMMMd')
                                                .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(_enquiryDataList[i].invDate))
                                                .toString();

                                            var dueDate = DateFormat('yMMMd')
                                                .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(_enquiryDataList[i].dueDate))
                                                .toString();
                                            var discountedOn = "";

                                            if (_enquiryDataList[i].discountedOn != null)
                                              discountedOn = DateFormat('yMMMd')
                                                  .format(DateFormat("yyyy-MM-dd").parse(_enquiryDataList[i].discountedOn))
                                                  .toString();

                                            row.add(_enquiryDataList[i].invNum);
                                            row.add(_enquiryDataList[i].seller != null ? _enquiryDataList[i].seller : "");
                                            row.add(_enquiryDataList[i].anchor);
                                            // row.add(_transactionDetails[i].order_number);
                                            row.add('₦ ' + formatCurrency(_enquiryDataList[i].invAmt));
                                            row.add(intDate);
                                            row.add(dueDate);

                                            row.add(discountedOn);
                                            row.add(_enquiryDataList[i].presented);
                                            row.add(_enquiryDataList[i].proposalStatus);
                                            row.add(_enquiryDataList[i].bidBy ?? "");
                                            row.add(_enquiryDataList[i].bidType);
                                            row.add(
                                              (_enquiryDataList[i].bidAmt != null && _enquiryDataList[i].bidAmt != '')
                                                  ? '₦ ' + formatCurrency(_enquiryDataList[i].bidAmt)
                                                  : '',
                                            );
                                            row.add(_enquiryDataList[i].bidRate);
                                            row.add('₦ ' + formatCurrency(_enquiryDataList[i].platformFree));
                                            // row.add(_enquiryDataList[i].fileName);
                                            row.add('₦ ' + formatCurrency(_enquiryDataList[i].newAmount));

                                            rows.add(row);
                                          }

                                          String dataAsCSV = const ListToCsvConverter().convert(
                                            rows,
                                          );
                                          var now = new DateTime.now();
                                          exportToCSV(dataAsCSV, fName: "Invoice List" + new DateFormat("yyyy-MM-dd-hh-mm").format(now) + ".csv");
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
                                      label: Text('Invoice No.', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('View', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('Seller', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      label: Text('Anchor', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      label: Text('Inv Amount', style: tableHeadlineStyle),
                                    ),
                                    // DataColumn(
                                    //   label: Text('Buy Now\nAmount', style: tableHeadlineStyle),
                                    // ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('Invoice Date', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('Due Date', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('Discounted On', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('Presented', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('Proposal\nStatus', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('BID BY', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('BID TYPE', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('BID Amount', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('BID Rate\n(Monthly)', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('Platform Fee', style: tableHeadlineStyle),
                                    ),
                                    DataColumn(
                                      // numeric: true,
                                      label: Text('Net Amount', style: tableHeadlineStyle),
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
