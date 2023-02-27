// import 'package:capsa/anchor/provider/anchor_action_providers.dart';
// import 'package:capsa/functions/currency_format.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
// import 'package:capsa/anchor/Helpers/dialogHelper.dart';
// import 'package:provider/provider.dart';
//
// import 'Pending.dart';
//
// class vettedScreen extends StatefulWidget {
//   const vettedScreen({Key key}) : super(key: key);
//
//   @override
//   _vettedScreenState createState() => _vettedScreenState();
// }
//
// class _vettedScreenState extends State<vettedScreen> {
//   List<TableRow> rows = [];
//   bool _dataLoaded = false;
//   var _numberOfPages;
//   var _currentIndex;
//   List<AcctTableData> _acctTable = [];
//
//   void functionStateChange(){
//     capsaPrint('functionStateChange call');
//     setState(() {
//
//
//     });
//   }
//
//   void getData(BuildContext context) async {
//     rows.add(TableRow(children: [
//       Container(
//         padding: const EdgeInsets.only(top: 8, bottom: 8),
//         child: Text('S/N',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       ),
//       Container(
//         padding: const EdgeInsets.only(top: 8, bottom: 8),
//         child: Text('Invoice No',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       ),
//       Container(
//         padding: const EdgeInsets.only(top: 8, bottom: 8),
//         child: Text('Vendor Name',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       ),
//       Container(
//         padding: const EdgeInsets.only(top: 8, bottom: 8),
//         child: Text('Issue Date',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       ),
//       Container(
//         padding: const EdgeInsets.only(top: 8, bottom: 8),
//         child: Text('Invoice Amount',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       ),
//       Container(
//         padding: const EdgeInsets.only(top: 8, bottom: 8),
//         child: Text('Due Date',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       ),
//       Container(
//         padding: const EdgeInsets.only(top: 8, bottom: 8),
//         child: Text('Tenure',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       ),
//       Container(
//         padding: const EdgeInsets.only(top: 5, bottom: 16),
//         child: Text('Vetted By',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       ),
//       Container(
//         padding: const EdgeInsets.only(top: 8, bottom: 8),
//         child: Text(' ',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color.fromRGBO(0, 152, 217, 1),
//             )),
//       )
//     ]));
//
//     var anchorsActions =
//         Provider.of<AnchorActionProvider>(context, listen: false);
//     _acctTable = await anchorsActions.queryInvoiceList(3);
//
//     for (int i = 0; i < 10; i++) {
//       rows.add(TableRow(children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text((i + 1).toString(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromRGBO(51, 51, 51, 1),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text(_acctTable[i].invNo.toString(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromRGBO(51, 51, 51, 1),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text(_acctTable[i].vendor.toString(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromRGBO(51, 51, 51, 1),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text(_acctTable[i].invDate.toString(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromRGBO(51, 51, 51, 1),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text("₦ " + formatCurrency(_acctTable[i].invAmt),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromRGBO(51, 51, 51, 1),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text(_acctTable[i].invDueDate.toString(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromRGBO(51, 51, 51, 1),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text(_acctTable[i].tenure.toString(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromRGBO(51, 51, 51, 1),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text(_acctTable[i].approvedBy,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromRGBO(51, 51, 51, 1),
//               )),
//         ),
//         Padding(
//             padding: const EdgeInsets.only(right: 16,top: 8),
//             child: PopupMenuButton(
//               icon: Icon(Icons.more_vert),
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   child: InkWell(
//                     onTap: (){
//                       showDialog(
//                         // barrierColor: Colors.transparent,
//                           context: context,
//                           builder: (BuildContext context) {
//
//
//                             functionBack(){
//
//                               Navigator.pop(context);
//
//                             }
//
//
//                             return new AlertDialog(
//                               // backgroundColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
//                               title: Text(
//                                 _acctTable[i].vendor,
//                                 textAlign: TextAlign.left,
//                                 style: TextStyle(
//                                     color: Color.fromRGBO(0, 0, 0, 1),
//                                     fontFamily: 'Poppins',
//                                     fontSize: 28,
//                                     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
//                                     fontWeight: FontWeight.normal,
//                                     height: 1),
//                               ),
//                               content:ContainerView(_acctTable[i],anchorsActions,functionStateChange),
//                             );
//                           });
//                     },
//                     child: Row(
//                       children: [
//                         Icon(Icons.edit),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Edit',
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color.fromRGBO(51, 51, 51, 1)
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 PopupMenuItem(
//                     child: InkWell(
//                       onTap: () {
//                         capsaPrint('view Tapped');
//                         setState(() {
//                           dialogHelper.showPdf(context);
//                         });
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Icons.remove_red_eye),
//                           RichText(
//                             text: TextSpan(
//                               text: 'View Invoice',
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w400,
//                                   color: Color.fromRGBO(51, 51, 51, 1)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                 ),
//               ],
//             )
//         )
//       ]));
//     }
//
//     if (_acctTable.length % 10 == 0) {
//       _numberOfPages = (_acctTable.length / 10).toInt();
//     } else {
//       _numberOfPages = (_acctTable.length / 10 + 1).floor();
//     }
//
//     _currentIndex = 1;
//
//     setState(() {
//       _dataLoaded = true;
//     });
//   }
//
//   void _nextPage() {
//     if (_currentIndex < _numberOfPages) {
//       setState(() {
//         _dataLoaded = false;
//       });
//       rows = [];
//       rows.add(TableRow(children: [
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('S/N',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Invoice No',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Vendor Name',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Issue Date',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Invoice Amount',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Due Date',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Tenure',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 5, bottom: 16),
//           child: Text('Vetted By',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text(' ',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         )
//       ]));
//       _currentIndex++;
//       int limit = 10 < (_acctTable.length - (_currentIndex - 1) * 10)
//           ? 10
//           : (_acctTable.length - (_currentIndex - 1) * 10);
//
//       for (int i = (_currentIndex - 1) * 10;
//           i < ((_currentIndex - 1) * 10) + limit;
//           i++) {
//         rows.add(TableRow(children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text((i + 1).toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].invNo.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].vendor.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].invDate.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].invAmt.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].invDueDate.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].tenure.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8, bottom: 8),
//             child: Text(_acctTable[i].approvedBy,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(right: 16,top: 8),
//               child: PopupMenuButton(
//                 icon: Icon(Icons.more_vert),
//                 itemBuilder: (context) => [
//                   PopupMenuItem(
//                       child: InkWell(
//                         onTap: () {
//                           capsaPrint('view Tapped');
//                           setState(() {
//                             dialogHelper.showPdf(context);
//                           });
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.remove_red_eye),
//                             RichText(
//                               text: TextSpan(
//                                 text: 'View Invoice',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w400,
//                                     color: Color.fromRGBO(51, 51, 51, 1)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                   ),
//                 ],
//               )
//           )
//         ]));
//       }
//       setState(() {
//         _dataLoaded = true;
//       });
//     }
//   }
//
//   void _previousPage() {
//     if (_currentIndex > 1) {
//       setState(() {
//         _dataLoaded = false;
//       });
//       rows = [];
//       rows.add(TableRow(children: [
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('S/N',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Invoice No',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Vendor Name',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Issue Date',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Invoice Amount',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Due Date',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text('Tenure',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 5, bottom: 16),
//           child: Text('Vetted By',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 8, bottom: 8),
//           child: Text(' ',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromRGBO(0, 152, 217, 1),
//               )),
//         )
//       ]));
//       _currentIndex--;
//       for (int i = (_currentIndex - 1) * 10;
//           i < ((_currentIndex - 1) * 10) + 10;
//           i++) {
//         rows.add(TableRow(children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text((i + 1).toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].invNo.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].vendor.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].invDate.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].invAmt.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].invDueDate.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(_acctTable[i].tenure.toString(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8, bottom: 8),
//             child: Text(_acctTable[i].approvedBy,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(51, 51, 51, 1),
//                 )),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(right: 16,top: 8),
//               child: PopupMenuButton(
//                 icon: Icon(Icons.more_vert),
//                 itemBuilder: (context) => [
//                   PopupMenuItem(
//                       child: InkWell(
//                         onTap: () {
//                           capsaPrint('view Tapped');
//                           setState(() {
//                             dialogHelper.showPdf(context);
//                           });
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.remove_red_eye),
//                             RichText(
//                               text: TextSpan(
//                                 text: 'View Invoice',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w400,
//                                     color: Color.fromRGBO(51, 51, 51, 1)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                   ),
//                 ],
//               )
//           )
//         ]));
//       }
//       setState(() {
//         _dataLoaded = true;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getData(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 1.8,
//       height: MediaQuery.of(context).size.height * 0.9,
//       child: _dataLoaded
//           ? Card(
//               margin: EdgeInsets.fromLTRB(29, 24, 36, 33),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15)),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Table(
//                         columnWidths: {
//                           0: FlexColumnWidth(1),
//                           1: FlexColumnWidth(4.2),
//                           2: FlexColumnWidth(3.2),
//                           3: FlexColumnWidth(3.2),
//                           4: FlexColumnWidth(3.2),
//                           5: FlexColumnWidth(3.2),
//                           6: FlexColumnWidth(2.8),
//                           7: FlexColumnWidth(4.3)
//                         },
//                         border: TableBorder(verticalInside: BorderSide.none),
//                         children: rows),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(900, 10, 15, 16),
//                     child: Card(
//                       color: Color.fromRGBO(245, 251, 255, 1),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Container(
//                         width: 290,
//                         height: 56,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.fromLTRB(24, 17.5, 24, 17.5),
//                               child: Text(
//                                 'Page',
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color.fromRGBO(51, 51, 51, 1)),
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.fromLTRB(0, 17.5, 30, 17.5),
//                               child: Text(
//                                 '$_currentIndex of $_numberOfPages',
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color.fromRGBO(51, 51, 51, 1)),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 22, 30, 22),
//                               child: IconButton(
//                                   onPressed: () {
//                                     _previousPage();
//                                   },
//                                   icon: Icon(Icons.arrow_back_ios),
//                                   iconSize: 14,
//                                   color: Color.fromRGBO(130, 130, 130, 1),
//                                   padding: EdgeInsets.all(0)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 22, 14, 22),
//                               child: IconButton(
//                                   onPressed: () {
//                                     _nextPage();
//                                   },
//                                   icon: Icon(Icons.arrow_forward_ios),
//                                   iconSize: 14,
//                                   color: Color.fromRGBO(130, 130, 130, 1),
//                                   padding: EdgeInsets.all(0)),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           : Center(
//               child: Padding(
//                 padding: EdgeInsets.all(24),
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//     );
//   }
// }
