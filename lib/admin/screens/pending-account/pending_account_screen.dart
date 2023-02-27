import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/blocked_amount_data.dart';
import 'package:capsa/admin/dialogs/pdf_dialog_box.dart';

import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/admin/screens/edit_account/edit_ben_details_screen.dart';
import 'package:capsa/admin/screens/pending-account/view_account_letter_screen.dart';
import 'package:capsa/admin/screens/pending-account/view_kyc_doc_screen.dart';

import 'package:capsa/admin/widgets/invoices_screen_card.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../edit_email_preferences_admin/email_preference_investor_admin_page.dart';
import '../edit_email_preferences_admin/email_preference_vendor_admin_page.dart';

class PendingAccountScreen extends StatefulWidget {
  final String title;

  const PendingAccountScreen({Key key, this.title}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<PendingAccountScreen> {
  int _rowsPerPage = 20;
  int _sortColumnIndex;
  bool _sortAscending = true;

  TextEditingController searchController = TextEditingController(text: '');

  var searchInvoiceText = '';

  String dropdownvalue = 'INVESTOR';

  String statusDropDownValue = 'All';

  String datesDropDownValue = 'Latest First';

  // List of items in our dropdown menu
  var items = [
    'INVESTOR',
    'VENDOR',
  ];

  var statusItems = [
    'All',
    'Pending',
    'Approved',
  ];

  var datesItems = [
    'Latest First',
    'Oldest First'
  ];

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

  void restrictUser(AccountData data, BuildContext context) async {
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
                data.isRestricted
                    ? Text(
                        'Are you sure you want to unrestrict user ${data.name}?')
                    : Text(
                        'Are you sure you want to restrict user ${data.name}?'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                dynamic response = data.isRestricted
                    ? await profileProvider.unrestrictAccount(data.panNumber)
                    : await profileProvider.restrictAccount(data.panNumber);
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
  Widget build(BuildContext context) {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    capsaPrint('pending account refresh');
    return Scaffold(
      body: ListView(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.fromLTRB(20, 0, 20, 0)
            : const EdgeInsets.fromLTRB(5, 0, 5, 0),
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Pending Account Screen',
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


          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //
          //
          //   ],
          // ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
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
                        controller: searchController,
                        onChanged: (value) {
                          searchInvoiceText = value;
                          if (value == "") setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search Name, BVN',
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
                        setState(() {});

                        //profileProvider.getInvoicesByInvoiceNumber(searchInvoiceText.trim());

                        //setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 50,),
              Text('Role :  ', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),),
              Container(
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownvalue = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 30,),
              Text('Status :  ', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),),
              Container(
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: DropdownButton(
                    // Initial Value
                    value: statusDropDownValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: statusItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String newValue) {
                      setState(() {
                        statusDropDownValue = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 30,),
              Text('Dates :  ', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),),
              Container(
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: DropdownButton(
                    // Initial Value
                    value: datesDropDownValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: datesItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String newValue) {
                      setState(() {
                        datesDropDownValue = newValue;
                      });
                    },
                  ),
                ),
              ),

            ],
          ),


          SizedBox(
            height: Responsive.isMobile(context) ? 8 : 35,
          ),
          FutureBuilder(
              future: Provider.of<ProfileProvider>(context, listen: false)
                  .fetchPendingAccountList(dropdownvalue,
                      search: searchController.text.trim(), statusFilter: statusDropDownValue, datesFilter: datesDropDownValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'There was an error :(\n' + snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  );
                } else if (snapshot.hasData) {
                  List<PendingAccountData> data = snapshot.data;
                  return data.length > 0
                      ? Container(
                          child: DataTable(
                            columns: dataTableColumn([
                              "S/L No.",
                              "Name",
                              "BVN",
                              "Email",
                              "Role",
                              "Created On",
                              "Status",
                              " ",
                            ]),
                            rows: [
                              for (int i = 0; i < data.length; i++)
                                DataRow(cells: [
                                  DataCell(Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    data[i].name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    formatPanNumber(data[i].panNumber),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    data[i].email,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    data[i].role,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    data[i].createdDate,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    data[i].isApproved == '0'?'Pending':data[i].isApproved == '1'?'Approved':'Rejected',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: data[i].isApproved == '0'?Color.fromRGBO(
                                            176, 183, 2, 1.0):data[i].isApproved == '1'?Color.fromRGBO(
                                            18, 190, 0, 1.0):Colors.red,),
                                  )),
                                  DataCell( (data[i].isApproved == '0' || data[i].isApproved == '1')?PopupMenuButton(
                                          icon: const Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            // dropdownvalue!='ANCHOR'?PopupMenuItem(
                                            //
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.pop(context);
                                            //       Navigator.of(context).push(
                                            //           MaterialPageRoute(
                                            //               builder: (context) =>
                                            //                   EditBenDetails(
                                            //                     panNumber: data[i].panNumber,)));
                                            //     },
                                            //     child: Row(
                                            //       children: [
                                            //         const Icon(Icons.edit),
                                            //         RichText(
                                            //           text: const TextSpan(
                                            //             text: 'Update Beneficary Account',
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
                                            // ):null,

                                            PopupMenuItem(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);

                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>ChangeNotifierProvider(
                                                            create: (context) => ProfileProvider(),
                                                            child:ViewKycDocumentScreen(
                                                              cacCertificate:
                                                              data[i].cacCertificate,
                                                              cacForm:
                                                              data[i].cacForm,
                                                              validId:
                                                              data[i].validId,
                                                              data: data[i],
                                                            )),
                                                      )).then((value){
                                                        setState(() {

                                                        });
                                                  });

                                                  // Navigator.of(context).push(
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             ));
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.edit),
                                                    RichText(
                                                      text: const TextSpan(
                                                        text: 'View KYC Documents',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    51,
                                                                    51,
                                                                    51,
                                                                    1)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);

                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>ChangeNotifierProvider(
                                                            create: (context) => ProfileProvider(),
                                                            child:ViewAccountLetterScreen(
                                                              data: data[i],
                                                            )),
                                                      )).then((value){
                                                    setState(() {

                                                    });
                                                  });

                                                  // Navigator.of(context).push(
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             ));
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.edit),
                                                    RichText(
                                                      text: const TextSpan(
                                                        text: 'View Account Letter',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color:
                                                            Color.fromRGBO(
                                                                51,
                                                                51,
                                                                51,
                                                                1)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container())
                                ])
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ]);
                } else
                  return Container();
              })
        ],
      ),
    );
  }
}
