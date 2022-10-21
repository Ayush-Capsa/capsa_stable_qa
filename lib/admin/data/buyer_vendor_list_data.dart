

import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class BuyerVendorListData {
  String name;
  String bvnNo;
  String phoneNo;
  String email;
  String address;
  String city;
  String state;
  String action;

  BuyerVendorListData(this.name, this.bvnNo, this.phoneNo, this.email,
      this.address, this.city, this.state, this.action);
}

class BuyerVendorListDataSource extends DataTableSource {
  List<BuyerVendorListData> data = <BuyerVendorListData>[
    BuyerVendorListData(
        'SBIA',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
    BuyerVendorListData(
        'SBI',
        '86570807622',
        '1234567890',
        'useremail@gmail.com',
        'Plot No 99, XYZ Road',
        'Mumbai',
        'Maharashtra',
        'Accept'),
  ];

  // void _sort<T>(Comparable<T> getField(BuyerVendorListData d), bool ascending) {
  //   data.sort((BuyerVendorListData a, BuyerVendorListData b) {
  //     if (!ascending) {
  //       final BuyerVendorListData c = a;
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
    final BuyerVendorListData d = data[index];

    return DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: null,
        cells: <DataCell>[
          DataCell(Text(
            '${d.name}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.bvnNo}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.phoneNo}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.email}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.address}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.city}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.state}',
            style: cellStyle,
          )),
          DataCell(
            TestWidget(status: d.action, d: d, index: index,),
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
 final int index;
 final BuyerVendorListData d;

  TestWidget({Key key, this.status,this.d,this.index}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    return ListTile(
      trailing: IconButton(
          onPressed: () {

            tab.changeTab2(0, widget.index, widget.d,'EnquiryEdit','');
            return;

          },
          icon: Icon(Icons.edit)),
      title: Text(
        widget.status,
        style: TextStyle(color: widget.status == 'Reject' ? Colors.red : Colors.green),
      ),
    );
  }
}
