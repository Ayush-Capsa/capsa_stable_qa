
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class AcctTableData {
  final String name;
  final String bvnNo;
  final String phoneNo;
  final String email;
  final String address;
  final String city;
  final String state;
  final String action;

  AcctTableData(this.name, this.bvnNo, this.phoneNo, this.email, this.address,
      this.city, this.state, this.action);
}

class AcctTableDataSource extends DataTableSource {
  final BuildContext context;
  final List<AcctTableData> data = <AcctTableData>[
    AcctTableData('SBIA', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
    AcctTableData('SBI', '86570807622', '1234567890', 'useremail@gmail.com',
        'Plot No 99, XYZ Road', 'Mumbai', 'Maharashtra', 'Accept'),
  ];

  AcctTableDataSource(this.context);

  // void _sort<T>(Comparable<T> getField(AcctTableData d), bool ascending) {
  //   data.sort((AcctTableData a, AcctTableData b) {
  //     if (!ascending) {
  //       final AcctTableData c = a;
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
    final AcctTableData d = data[index];

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
          DataCell(TestWidget(
            status: d.action,
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

class TestWidget extends StatefulWidget {
 final String status;

  TestWidget({Key key, this.status}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {


  String _status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _status = widget.status;
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(
          onPressed: () {
            setState(() {
              _status = 'Reject';
            });
          },
          icon: Icon(Icons.edit)),
      title: Text(
        _status,
        style: TextStyle(
            color: _status == 'Reject' ? Colors.red : Colors.green),
      ),
    );
  }
}
