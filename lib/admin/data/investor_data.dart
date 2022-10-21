import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class InvestorData {
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
  String account;

  String kyc1;
  String kyc2;
  String kyc3;

  String kyc1File;
  String kyc2File;
  String kyc3File;

  InvestorData(
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
    this.account,
    this.kyc1,
    this.kyc2,
    this.kyc3,
    this.kyc1File,
    this.kyc2File,
    this.kyc3File,
  );
}

class InvestorListDataSource extends DataTableSource {
  final BuildContext context;
  final String title;

  List<InvestorData> data = <InvestorData>[
    // HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
    //     '10,000', 'Open'),
  ];

  InvestorListDataSource(this.context, this.data, this.title);

  // void _sort<T>(Comparable<T> getField(InvestorData d), bool ascending) {
  //   data.sort((InvestorData a, InvestorData b) {
  //     if (!ascending) {
  //       final InvestorData c = a;
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
    final InvestorData d = data[index];

    String _statusText = 'Pending';

    var statusCellStyle = TextStyle(
      color: Colors.blueGrey[800],
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );

    if (d.status == '0') {
      _statusText = 'Pending';
      statusCellStyle = TextStyle(
        color: Colors.blue[800],
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
    } else if (d.status == '1') {
      _statusText = 'Approved';
      statusCellStyle = TextStyle(
        color: Colors.green[800],
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
    } else if (d.status == '2') {
      _statusText = 'Rejected';
      statusCellStyle = TextStyle(
        color: Colors.red[800],
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
    }

    TextStyle statusCellStyle3;
    var text_2 = '';

    capsaPrint('d.role2');
    capsaPrint(d.role2);

    if (d.role2 == "individual") {
      if (d.kyc1File != null) {
        // if (d.alUpload == '1') {
        text_2 = 'KYC uploaded';
        statusCellStyle3 = TextStyle(
          color: Colors.blueAccent,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        );
        if (d.kyc1 == '2') {
          // if (d.alUpload == '1') {
          text_2 = 'KYC Verified';
          statusCellStyle3 = TextStyle(
            color: Colors.green,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          );
        }
      }
    } else {
      // if (d.kyc1File != null || d.kyc2File != null || d.kyc3File != null)
      if (d.kyc1File != null || d.kyc2File != null) {
        // if (d.alUpload == '1') {
        text_2 = 'KYC uploaded';
        statusCellStyle3 = TextStyle(
          color: Colors.blueAccent,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        );
        if (d.kyc1 == '2' && d.kyc2 == '2' && d.kyc3 == '2') {
          // if (d.alUpload == '1') {
          text_2 = 'KYC Verified';
          statusCellStyle3 = TextStyle(
            color: Colors.green,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          );
        }
      }
    }

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
          '${d.bvnNum}',
          style: cellStyle,
        )),
        DataCell(Text(
          '${d.compName}',
          style: cellStyle,
        )),
        DataCell(Text(
          '${d.address}',
          style: cellStyle,
        )),
        DataCell(
          Text(
            (d.account == null || d.account == '') ? 'Pending' : 'Approved',
            style: TextStyle(
              color: (d.account == null || d.account == '')
                  ? Colors.blue[400]
                  : Colors.green[800],
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _statusText,
              style: statusCellStyle,
            ),
            Text(
              text_2,
              style: statusCellStyle3,
            ),
          ],
        )),
        DataCell(
          TestWidget(status: d.status, d: d, index: index, title: title),
        ),
      ],
    );
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
  final InvestorData d;

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
        backgroundColor: Colors.green[400],
      ),
      onPressed: () async {
        tab.changeTab2(
            0, widget.index, widget.d, 'InvestorEdit', 'InvestorEdit');
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
          Text(
        'View',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
