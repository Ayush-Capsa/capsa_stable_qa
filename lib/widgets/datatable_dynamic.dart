import 'package:capsa/functions/hexcolor.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
  final TextStyle dataTableBodyTextStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.normal,color: HexColor("#333333"));

List<DataColumn> dataTableColumn(List listData) {
  final TextStyle headTextStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: HexColor("#0098DB"));

  List<DataColumn> list = [];
  for (var i = 0; i < listData.length; i++) {
    list.add(new DataColumn(
      label: Text(
        listData[i],
        style: headTextStyle,
      ),
    ));
  }
  return list;
}


// List<DataRow> dataTableRow(List listData) {
//   final TextStyle bodyTextStyle = TextStyle(fontWeight: FontWeight.normal,color: HexColor("#333333"));
//
//   List<DataRow> list = [];
//   for (var i = 0; i < listData.length; i++) {
//     list.add( DataRow(
//       cells: <DataCell>[
//         DataCell(Text((++i).toString(),style: bodyTextStyle, ),),
//         DataCell(Text('19')),
//         DataCell(Text('Student')),
//         DataCell(Text('Student')),
//         DataCell(Text('Student')),
//       ],
//     ));
//   }
//   return list;
// }