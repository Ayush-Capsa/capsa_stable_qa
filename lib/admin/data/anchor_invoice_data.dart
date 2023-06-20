import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnchorInvoiceData {
  String invNo;
  String lineItems;
  String invDate;
  String invDueDate;
  String description;
  String invVal;
  String tenure;
  String vendorName;
  String anchorName;
  String status;
  String vendorPan;
  String sellPrice;
  String anchorPan;
  String rate;
  String companyPan;
  String poNumber;
  String actualValue;



  AnchorInvoiceData(
    this.invNo,
    this.lineItems,
    this.invDate,
    this.invDueDate,
    this.description,
    this.invVal,
    this.tenure,
    this.vendorName,
      this.anchorName,
      this.status,
       this.vendorPan,
      this.sellPrice,
      this.anchorPan,
      this.rate,
      this.companyPan,
      this.poNumber,
       this.actualValue
  );
}

class AnchorInvoiceListDataSource extends DataTableSource {

  final BuildContext context;
  final String title;

  List<AnchorInvoiceData> data = <AnchorInvoiceData>[
    // HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
    //     '10,000', 'Open'),
  ];


  AnchorInvoiceListDataSource(this.context, this.data , this.title);

  //
  // void _sort<T>(Comparable<T> getField(AnchorData d), bool ascending) {
  //   data.sort((AnchorData a, AnchorData b) {
  //     if (!ascending) {
  //       final AnchorData c = a;
  //       a = b;
  //       b = c;
  //     }
  //     final Comparable<T> aValue = getField(a);
  //     final Comparable<T> bValue = getField(b);
  //     return Comparable.compare(aValue, bValue);
  //   });
  //   notifyListeners();
  // }

  int _selectedCount = 0;
  final cellStyle = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= data.length) return null;
    final AnchorInvoiceData d = data[index];

    // String _statusText = 'Pending';
    //
    // var  statusCellStyle = TextStyle(
    //   color: Colors.blueGrey[800],
    //   fontSize: 14,
    //   fontWeight: FontWeight.normal,
    // );
    //
    // if(d.status == '0' ) {
    //   _statusText = 'Pending';
    //   statusCellStyle = TextStyle(
    //     color: Colors.blue[800],
    //     fontSize: 14,
    //     fontWeight: FontWeight.normal,
    //   );
    // }else   if(d.status == '1' ) {
    //   _statusText = 'Approved';
    //   statusCellStyle = TextStyle(
    //     color: Colors.green[800],
    //     fontSize: 14,
    //     fontWeight: FontWeight.normal,
    //   );
    //
    // }else   if(d.status == '2' ) {
    //   _statusText = 'Rejected';
    //   statusCellStyle = TextStyle(
    //     color: Colors.red[800],
    //     fontSize: 14,
    //     fontWeight: FontWeight.normal,
    //   );
    //
    // }


    return DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: null,
        cells: <DataCell>[
          DataCell(Text(
            (index + 1).toString(),
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.invNo}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.vendorName}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.anchorName}',
            style: cellStyle,
          )),
          DataCell(Text(
    DateFormat('d MMM, y').format(
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .parse(d.invDate.toString())),
            style: cellStyle,
          )),
          DataCell(Text(
            DateFormat('d MMM, y').format(
                DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                    .parse(d.invDueDate.toString())),
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.tenure}',
            style: cellStyle,
          )),
          DataCell(InkWell(
            child: Container()
          )),
        ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

}