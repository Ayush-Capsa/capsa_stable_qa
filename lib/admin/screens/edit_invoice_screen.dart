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

  String dropdownvalue = 'INVESTOR';

  TextEditingController invoiceNumberController = TextEditingController();

  // List of items in our dropdown menu
  var items = [
    'INVESTOR',
    'VENDOR',
    'ANCHOR',
  ];

  bool dataLoaded = false;

  List<InvoiceModel> invoices = [];

  void getData(String search) async {
    setState(() {
      dataLoaded = false;
    });
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    invoices = [];
    invoices = await profileProvider.getInvoicesByInvoiceNumber(search: search);
    print('Pass 4');

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
                invoices.length>0?DataTable(
                  columns: dataTableColumn([
                    "S/L Number",
                    "Invoice Number",
                    "Vendor Name",
                    "Issue Date",
                    "Amount (N)",
                    "Due Date",
                    //"Tenure",
                    ""
                  ]),
                  rows: <DataRow>[
                    for (int i = 0; i < invoices.length; i++)
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            // transaction.created_on,
                            '${i + 1}',
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
                            DateFormat('d MMM, y')
                                .format(DateFormat("yyyy-MM-dd")
                                    .parse(invoices[i].invoiceDueDate))
                                .toString(),
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
                ):Column(
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
