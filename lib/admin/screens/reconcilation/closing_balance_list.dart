// import 'package:capsa/common/responsive.dart';
// import 'package:capsa/functions/currency_format.dart';
// import 'package:capsa/functions/export_to_csv.dart';
// import 'package:capsa/functions/hexcolor.dart';
// import 'package:capsa/models/profile_model.dart';
// import 'package:capsa/widgets/datatable_dynamic.dart';
// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ClosingBalanceList extends StatefulWidget {
//   List<ClosingBalanceModel> model;
//   ClosingBalanceList({Key key, this.model}) : super(key: key);
//
//   @override
//   State<ClosingBalanceList> createState() => _ClosingBalanceListState();
// }
//
// class _ClosingBalanceListState extends State<ClosingBalanceList> {
//
//   void exportCSV() {
//     {
//       final find = ',';
//       final replaceWith = '';
//       List<List<dynamic>> rows = [];
//       //capsaPrint('Length : ${bids.length}');
//       rows.add([
//         "S/N",
//         "Name",
//         "Account Number",
//         "BVN",
//         "Closing Balance",
//       ]);
//       int i = 0;
//       for (var element in widget.model) {
//         List<dynamic> row = [];
//         row.add(
//           (++i).toString(),
//         );
//         row.add(
//           element.name,
//         );
//         row.add(
//           element.accountNumber,
//         );
//         row.add(
//          element.panNumber,
//         );
//         row.add(
//           formatCurrency(
//             element.closingBalance,
//             withIcon: false,
//           ),
//         );
//         rows.add(row);
//       }
//
//       String dataAsCSV = const ListToCsvConverter().convert(
//         rows,
//       );
//       exportToCSV(dataAsCSV, fName: "Balance History");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: Container(
//               //width: 185,
//               margin: EdgeInsets.all(0),
//               height: double.infinity,
//               width: MediaQuery.of(context).size.width * 0.11,
//               // color: Colors.black,
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(15),
//                         bottomRight: Radius.circular(15))),
//                 color: Colors.black,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(50.5, 36, 50.5, 24),
//                       child: SizedBox(
//                         width: 80,
//                         height: 45.42,
//                         child: Image.asset(
//                           'assets/images/logo.png',
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                         // Navigator.pushReplacement(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => ChangeNotifierProvider(
//                         //         create: (BuildContext
//                         //         context) =>
//                         //             AnchorActionProvider(),
//                         //         child:
//                         //        AnchorHomePage()),
//                         //   ),
//                         // );
//                       },
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: HexColor("#0098DB"),
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child:  widget.model.isNotEmpty
//                 ? SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: Responsive.isMobile(context) ? 12 : 30,
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ListTile(
//                               contentPadding: EdgeInsets.zero,
//                               subtitle: Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Text(
//                                   'Balance History',
//                                   style: TextStyle(
//                                       fontSize: 22,
//                                       color: Colors.grey[700],
//                                       fontWeight: FontWeight.bold,
//                                       letterSpacing: 1),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Responsive.isDesktop(context)
//                           //     ? Spacer(
//                           //   flex: 3,
//                           // )
//                           //     : Container(),
//                           Container(
//                             width: 120,
//                             height: 40,
//                             child: InkWell(
//                               onTap: () => exportCSV(),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.upload, size: 24,),
//                                   SizedBox(width: 4,),
//                                   Text('Export', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: Responsive.isMobile(context) ? 12 : 30,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 16.0),
//                         child: Container(
//                           color: Theme.of(context).primaryColor,
//                           child: Divider(
//                             height: 1,
//                             color: Theme.of(context).primaryColor,
//                             thickness: 0,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: Responsive.isMobile(context) ? 12 : 35,
//                       ),
//                       Row(
//                         children: [
//                           Spacer(
//                             flex: Responsive.isDesktop(context) ? 4 : 1,
//                           ),
//                         ],
//                       ),
//                       DataTable(
//               columns: dataTableColumn([
//                       "S/L No.",
//                       "Name",
//                       "Account Number",
//                       "BVN",
//                       "CLosing Balance"
//               ]),
//               rows: [
//                       for (int i = 0; i < widget.model.length; i++)
//                         DataRow(cells: [
//                           DataCell(Text(
//                             '${i + 1}',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal,
//                                 color: HexColor("#333333")),
//                           )),
//                           DataCell(Text(
//                             widget.model[i].name ?? '',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal,
//                                 color: HexColor("#333333")),
//                           )),
//                           DataCell(Text(
//                             widget.model[i].accountNumber  ?? '',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal,
//                                 color: HexColor("#333333")),
//                           )),
//                           DataCell(Text(
//                             widget.model[i].panNumber  ?? '',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal,
//                                 color: HexColor("#333333")),
//                           )),
//                           DataCell(Text(
//                             formatCurrency(widget.model[i].closingBalance  ?? '0',
//                                 withIcon: true),
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal,
//                                 color: HexColor("#333333")),
//                           )),
//                         ])
//               ],
//             ),
//                     ],
//                   ),
//                 )
//                 : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.error_outline_outlined,
//                     color: Colors.red,
//                     size: 30,
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Text(
//                     'Sorry, No Results Found!',
//                     style: GoogleFonts.poppins(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black),
//                   ),
//                 ],
//               ),
//             ]),
//           )
//
//         ],
//       ),
//     );
//   }
// }

import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClosingBalanceList extends StatefulWidget {
  List<ClosingBalanceModel> model;
  ClosingBalanceList({Key key, this.model}) : super(key: key);

  @override
  State<ClosingBalanceList> createState() => _ClosingBalanceListState();
}

class _ClosingBalanceListState extends State<ClosingBalanceList> {
  dynamic balancesToShow = 'All Balances';
  dynamic bts = 'All Balances';

  List<String> balances = [
    'All Balances',
    'Non-Zero Balances',
    'Zero Balances'
  ];

  List<ClosingBalanceModel> sortList() {
    List<ClosingBalanceModel> result = [];
    widget.model.sort((a, b) {
      double aClosingBalance = double.parse(a.closingBalance);
      double bClosingBalance = double.parse(b.closingBalance);
      return bClosingBalance.compareTo(aClosingBalance);
    });

    if (balancesToShow == null || balancesToShow == 'All Balances') {
      result = widget.model;
    } else if (balancesToShow == 'Non-Zero Balances') {
      for (int i = 0; i < widget.model.length; i++) {
        if (double.parse(widget.model[i].closingBalance) > 0) {
          result.add(widget.model[i]);
        }
      }
    } else if (balancesToShow == 'Zero Balances') {
      for (int i = 0; i < widget.model.length; i++) {
        if (double.parse(widget.model[i].closingBalance) == 0) {
          result.add(widget.model[i]);
        }
      }
    }

    return result;
  }

  void exportCSV() {
    {
      final find = ',';
      final replaceWith = '';
      List<List<dynamic>> rows = [];
      //capsaPrint('Length : ${bids.length}');
      rows.add([
        "S/N",
        "Name",
        "Account Number",
        "BVN",
        "Closing Balance",
      ]);
      int i = 0;
      List<ClosingBalanceModel> finalList = sortList();
      for (var element in finalList) {
        List<dynamic> row = [];
        row.add(
          (++i).toString(),
        );
        row.add(
          element.name,
        );
        row.add(
          element.accountNumber,
        );
        row.add(
          element.panNumber,
        );
        row.add(
          formatCurrency(
            element.closingBalance,
            withIcon: false,
          ),
        );
        rows.add(row);
      }

      String dataAsCSV = const ListToCsvConverter().convert(
        rows,
      );
      exportToCSV(dataAsCSV, fName: "Balance History");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ClosingBalanceModel> showList = sortList();
    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              //width: 185,
              margin: EdgeInsets.all(0),
              height: double.infinity,
              width: MediaQuery.of(context).size.width * 0.11,
              // color: Colors.black,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                color: Colors.black,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50.5, 36, 50.5, 24),
                      child: SizedBox(
                        width: 80,
                        height: 45.42,
                        child: Image.asset(
                          'assets/images/logo.png',
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ChangeNotifierProvider(
                        //         create: (BuildContext
                        //         context) =>
                        //             AnchorActionProvider(),
                        //         child:
                        //        AnchorHomePage()),
                        //   ),
                        // );
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: HexColor("#0098DB"),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: widget.model.isNotEmpty
                ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Responsive.isMobile(context) ? 12 : 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          subtitle: Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Balance History',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                      // Responsive.isDesktop(context)
                      //     ? Spacer(
                      //   flex: 3,
                      // )
                      //     : Container(),
                      Container(
                        width: 120,
                        height: 40,
                        child: InkWell(
                          onTap: () => exportCSV(),
                          child: Row(
                            children: [
                              Icon(
                                Icons.download,
                                size: 24,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Export',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 12 : 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).primaryColor,
                        thickness: 0,
                      ),
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
                      Text(
                        'Show Accounts with : ',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: !Responsive.isMobile(context)
                            ? 260
                            : MediaQuery.of(context).size.width * 0.8,
                        child: UserTextFormField(
                          label: !Responsive.isMobile(context)
                              ? ""
                              : "Account Balance",
                          hintText: "Account Balance",
                          textFormField: DropdownButtonFormField(
                            isExpanded: true,
                            items: balances.map((String category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category.toString()),
                              );
                            }).toList(),
                            onChanged: (v) async {
                              balancesToShow = v;
                              bts = v;
                              setState(() {});
                            },
                            value: bts,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Status",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(130, 130, 130, 1),
                                  fontSize: 14,
                                  letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                              contentPadding: const EdgeInsets.only(
                                  left: 8.0, bottom: 12.0, top: 12.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 12 : 35,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: DataTable(
                            columns: dataTableColumn([
                              "S/L No.",
                              "Name",
                              "Account Number",
                              "BVN",
                              "CLosing Balance"
                            ]),
                            rows: [
                              for (int i = 0; i < showList.length; i++)
                                DataRow(cells: [
                                  DataCell(Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    showList[i].name ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    showList[i].accountNumber ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    showList[i].panNumber ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                  DataCell(Text(
                                    formatCurrency(
                                        showList[i].closingBalance ?? '0',
                                        withIcon: true),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: HexColor("#333333")),
                                  )),
                                ])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                ]),
          )
        ],
      ),
    );
  }
}
