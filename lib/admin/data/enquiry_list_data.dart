import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class EnquiryData {
  String bvnName;
  String compName;
  String bvnNum;
  String email;
  String remark;
  String contactNumber;
  String role;
  String role2;
  String address;
  String city;
  String state;
  String status;
  String modifiedAt;
  String industry;
  String keyPerson;
  String founded;
  String cac;

  EnquiryData(
    this.bvnName,
    this.compName,
    this.bvnNum,
    this.email,
    this.remark,
    this.contactNumber,
    this.role,
    this.role2,
    this.address,
    this.city,
    this.state,
    this.status,
    this.modifiedAt,
    this.industry,
    this.keyPerson,
    this.founded,
    this.cac,
  );
}

class EnquiryDataSource extends DataTableSource {
  final BuildContext context;
  final String title;

  List<EnquiryData> data = <EnquiryData>[
    // HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
    //     '10,000', 'Open'),
  ];

  EnquiryDataSource(this.context, this.data, this.title);

  // void _sort<T>(Comparable<T> getField(EnquiryData d), bool ascending) {
  //   data.sort((EnquiryData a, EnquiryData b) {
  //     if (!ascending) {
  //       final EnquiryData c = a;
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
    final EnquiryData d = data[index];
    return DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: null,
        cells: <DataCell>[
          DataCell(Text(
            '${d.bvnName}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.compName}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.email}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.remark}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.bvnNum}',
            style: cellStyle,
          )),
          if (title == 'Buyer On-boarding')
            DataCell(Text(
              '${d.role2}',
              style: cellStyle,
            )),
          DataCell(Text(
            '${d.contactNumber}',
            style: cellStyle,
          )),
          DataCell(
            TestWidget(status: d.status, d: d, index: index, title: title),
          ),
        ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

class TestWidget extends StatefulWidget {
  final String status;
  final String title;
  final int index;
  final EnquiryData d;

  TestWidget({Key key, this.status, this.d, this.index, this.title})
      : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: widget.d.status == 'Onboarded'
            ? Colors.green[400]
            : Colors.grey[400],
      ),
      onPressed: () async {
        tab.changeTab2(0, widget.index, widget.d, 'EnquiryEdit', widget.title);

        // if(widget.d.status != 'Onboarded'){
        // await Provider.of<ActionModel>(context,listen: false).setOnBoardData(d.status,d.bvnNum);

        // }
      },
      child:
          // trailing: IconButton(
          //     onPressed: () {
          //
          //       tab.changeTab2(0, widget.index, widget.d,);
          //       return;
          //
          //     },
          //     icon: Icon(Icons.edit,size: 0,)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
        widget.d.status,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
          ),
    );
  }
}
