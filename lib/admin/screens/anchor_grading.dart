import 'package:capsa/admin/common/constants.dart';
import 'package:capsa/admin/data/blocked_amount_data.dart';
import 'package:capsa/admin/models/anchor_model.dart';

import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/admin/screens/edit_account/edit_ben_details_screen.dart';

import 'package:capsa/admin/widgets/invoices_screen_card.dart';
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

import 'edit_email_preferences_admin/email_preference_investor_admin_page.dart';
import 'edit_email_preferences_admin/email_preference_vendor_admin_page.dart';

class AnchorGrading extends StatefulWidget {
  final String title;

  const AnchorGrading({Key key, this.title}) : super(key: key);

  @override
  _AnchorGradingState createState() => _AnchorGradingState();
}

class _AnchorGradingState extends State<AnchorGrading> {
  int _rowsPerPage = 20;
  int _sortColumnIndex;
  bool _sortAscending = true;

  TextEditingController searchController = TextEditingController(text: '');

  var searchInvoiceText = '';

  String dropdownvalue = 'INVESTOR';

  // List of items in our dropdown menu
  var items = [
    'INVESTOR',
    'VENDOR',
    'ANCHOR',
  ];

  bool stringContains(String parent, String child) {
    return parent
        .toString()
        .toLowerCase()
        .contains(child.toString().toLowerCase());
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
                      'Anchor Grading',
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
          //     Container(
          //       width: Responsive.isMobile(context)
          //           ? MediaQuery.of(context).size.width * 0.8
          //           : MediaQuery.of(context).size.width * 0.3,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(20))),
          //       child: Padding(
          //         padding: const EdgeInsets.all(18.0),
          //         child: DropdownButton(
          //           // Initial Value
          //           value: dropdownvalue,
          //
          //           // Down Arrow Icon
          //           icon: const Icon(Icons.keyboard_arrow_down),
          //
          //           // Array list of items
          //           items: items.map((String items) {
          //             return DropdownMenuItem(
          //               value: items,
          //               child: Text(items),
          //             );
          //           }).toList(),
          //           // After selecting the desired option,it will
          //           // change button value to selected value
          //           onChanged: (String newValue) {
          //             setState(() {
          //               dropdownvalue = newValue;
          //             });
          //           },
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: Stack(
          //         alignment: Alignment.centerRight,
          //         children: <Widget>[
          //           Padding(
          //             padding: const EdgeInsets.all(24.0),
          //             child: TextFormField(
          //               // onFieldSubmitted: (value) {
          //               //   // after pressing enter
          //               //   capsaPrint(value);
          //               // },
          //               controller: searchController,
          //               onChanged: (value) {
          //                 searchInvoiceText = value;
          //                 if (value == "") setState(() {});
          //               },
          //               decoration: const InputDecoration(
          //                 hintText: 'Search Name, BVN',
          //                 // suffixIcon: Icon(
          //                 //   Icons.search,
          //                 //   color: Colors.blueGrey.withOpacity(0.9),
          //                 //
          //                 // ),
          //               ),
          //               // onTap: () {
          //
          //               // capsaPrint("Invoice");
          //
          //               // },
          //               style: TextStyle(
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //           IconButton(
          //             icon: Icon(
          //               Icons.search,
          //               color: Colors.blueGrey.withOpacity(0.9),
          //             ),
          //             onPressed: () {
          //               // do something
          //               setState(() {
          //
          //               });
          //
          //               //profileProvider.getInvoicesByInvoiceNumber(searchInvoiceText.trim());
          //
          //               //setState(() {});
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(
            height: Responsive.isMobile(context) ? 8 : 35,
          ),
          FutureBuilder(
              future: Provider.of<ProfileProvider>(context, listen: false)
                  .getCompanyName(),
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
                  dynamic data = snapshot.data;
                  capsaPrint('\nCompany Data : $data');
                  List<AnchorModel> anchors = [];
                  List<AnchorModel> tempAnchors = [];

                  if (data['res'] == 'success') {
                    for (int i = 0; i < data['data'].length; i++) {
                      tempAnchors.add(AnchorModel(
                        name: data['data'][i]['name'],
                        email: data['data'][i]['EMAIL'],
                        cin: data['data'][i]['CIN'],
                        pan: data['data'][i]['cu_pan'],
                        grade: data['data'][i]['grade'],
                      ));

                      if (searchInvoiceText != '') {
                        if (stringContains(
                                data['data'][i]['name'], searchInvoiceText) ||
                            stringContains(
                                data['data'][i]['cu_pan'], searchInvoiceText) ||
                            stringContains(
                                data['data'][i]['CIN'], searchInvoiceText)) {
                          anchors.add(AnchorModel(
                            name: data['data'][i]['name'],
                            email: data['data'][i]['EMAIL'],
                            cin: data['data'][i]['CIN'],
                            pan: data['data'][i]['cu_pan'],
                            grade: data['data'][i]['grade'],
                          ));
                        }
                      }else{
                        anchors.add(AnchorModel(
                          name: data['data'][i]['name'],
                          email: data['data'][i]['EMAIL'],
                          cin: data['data'][i]['CIN'],
                          pan: data['data'][i]['cu_pan'],
                          grade: data['data'][i]['grade'],
                        ));
                      }
                    }

                    if(anchors.isEmpty){
                      anchors = tempAnchors;
                      showToast('No Data Found!', context, type: 'warning');
                    }

                    return anchors.isNotEmpty
                        ? Column(
                            children: [
                              Container(
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
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Search by name, bvn & rc number',
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
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DataTable(
                                  columns: dataTableColumn([
                                    "S/L No.",
                                    "Name",
                                    "RC Number",
                                    "BVN",
                                    "Grade",
                                    "Extended Tenure",
                                  ]),
                                  rows: [
                                    for (int i = 0; i < anchors.length; i++)
                                      DataRow(cells: [
                                        DataCell(Text(
                                          '${i + 1}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: HexColor("#333333")),
                                        )),
                                        DataCell(Text(
                                          anchors[i].name ?? '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: HexColor("#333333")),
                                        )),
                                        DataCell(Text(
                                          anchors[i].cin ?? '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: HexColor("#333333")),
                                        )),
                                        DataCell(Text(
                                          anchors[i].pan ?? '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: HexColor("#333333")),
                                        )),
                                        DataCell(Text(
                                          anchors[i].grade ?? 'NA',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: HexColor("#333333")),
                                        )),
                                        DataCell(Text(
                                          anchors[i].grade == 'C'
                                              ? '30 Days'
                                              : anchors[i].grade == 'D'
                                                  ? '45 Days'
                                                  : '0 Days',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: HexColor("#333333")),
                                        )),
                                      ])
                                  ],
                                ),
                              ),
                            ],
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
                  }

                  return Column(
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
                              'There was some error',
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
