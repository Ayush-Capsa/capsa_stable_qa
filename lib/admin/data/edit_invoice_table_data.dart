// import 'package:capsa/admin/screens/edit_transaction.dart';
// import 'package:capsa/functions/currency_format.dart';
// import 'package:capsa/models/profile_model.dart';
// import 'package:flutter/material.dart';
// import 'package:capsa/functions/custom_print.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import 'package:capsa/admin/providers/profile_provider.dart';
//
// import 'package:capsa/admin/models/invoice_model.dart';
// import '../../widgets/datatable_dynamic.dart';
// import '../screens/edit_account/edit_invoice_admin.dart';
//
// class InvoiceTableDataSource extends DataTableSource {
//   List<InvoiceModel> invoices;
//   String title;
//   dynamic anchorGrade;
//
//   InvoiceTableDataSource(this.invoices, this.anchorGrade, {title});
//
//   int _selectedCount = 0;
//   final cellStyle = TextStyle(
//     color: Colors.blueGrey[800],
//     fontSize: 14,
//     fontWeight: FontWeight.normal,
//   );
//   @override
//   DataRow getRow(int index) {
//     assert(index >= 0);
//     if (index >= invoices.length) return null;
//     final InvoiceModel d = invoices[index];
//     return DataRow.byIndex(
//         index: index,
//         selected: false,
//         onSelectChanged: null,
//         cells: <DataCell>[
//           DataCell(Text(
//             // transaction.created_on,
//             d.anchorName ,
//             style: dataTableBodyTextStyle,
//           )),
//           DataCell(Text(
//             (' ${anchorGrade[d
//                 .anchorName] ?? 'NA'}'),
//             style: dataTableBodyTextStyle,
//           )),
//           DataCell(Text(
//             // transaction.created_on,
//             d.invoiceNumber,
//             style: dataTableBodyTextStyle,
//           )),
//           DataCell(Text(
//             // transaction.created_on,
//             d.customerName,
//             style: dataTableBodyTextStyle,
//           )),
//           DataCell(Text(
//
//             DateFormat('d MMM, y')
//                 .format(DateFormat("yyyy-MM-dd")
//                 .parse(d.invoiceDate))
//                 .toString(),
//             style: dataTableBodyTextStyle,
//           )),
//           DataCell(Text(
//             // transaction.created_on,
//             formatCurrency(d.invoiceValue),
//             style: dataTableBodyTextStyle,
//           )),
//           DataCell(Text(
//             d.invoiceDueDate != ''?DateFormat('d MMM, y')
//                 .format(DateFormat("yyyy-MM-dd")
//                 .parse(d.invoiceDueDate))
//                 .toString() : 'NA',
//             style: dataTableBodyTextStyle,
//           )),
//           DataCell(Text(
//             d.extendedDueDate != ''?DateFormat('d MMM, y')
//                 .format(DateFormat("yyyy-MM-dd")
//                 .parse(d.extendedDueDate))
//                 .toString() : 'NA',
//             style: dataTableBodyTextStyle,
//           )),
//           DataCell(PopupMenuButton(
//             icon: const Icon(Icons.more_vert),
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 onTap: (){
//
//                 },
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.of(context).push(
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 EditInvoiceAdmin(
//                                     invoice: d))).then((value) => getData(searchInvoiceText));
//                   },
//                   child: Row(
//                     children: [
//                       const Icon(Icons.edit),
//                       RichText(
//                         text: const TextSpan(
//                           text: 'Edit Invoice',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w400,
//                               color: Color.fromRGBO(
//                                   51, 51, 51, 1)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // PopupMenuItem(
//               //
//               //   child: InkWell(
//               //     onTap: (){
//               //       Navigator.pop(context);
//               //       Navigator.of(context).push(
//               //           MaterialPageRoute(
//               //               builder: (context) =>
//               //                   EditBenDetails(
//               //                       invoice: d)));
//               //     },
//               //     child: Row(
//               //       children: [
//               //         const Icon(Icons.edit),
//               //         RichText(
//               //           text: const TextSpan(
//               //             text: 'Update Account',
//               //             style: TextStyle(
//               //                 fontSize: 18,
//               //                 fontWeight: FontWeight.w400,
//               //                 color: Color.fromRGBO(
//               //                     51, 51, 51, 1)),
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//             ],
//           )),
//         ]);
//   }
//
//   @override
//   int get rowCount => data.length;
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get selectedRowCount => _selectedCount;
// }
