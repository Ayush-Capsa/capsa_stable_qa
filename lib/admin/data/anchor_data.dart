

import 'package:capsa/admin/screens/anchor_list/upload_files_screen.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:universal_html/html.dart' as html;



class AnchorData {
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

  AnchorData(
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


      );
}

class AnchorListDataSource extends DataTableSource {

  final BuildContext context;
  final String title;

  List<AnchorData> data = <AnchorData>[
    // HistoryData('SBI', 'IJK45AGHJI', '1234567890', '22 Feb, 2021', '2 Days',
    //     '10,000', 'Open'),
  ];


  AnchorListDataSource(this.context, this.data , this.title);

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
    final AnchorData d = data[index];

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
            '${d.bvnNum}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.compName}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.cac}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.address}',
            style: cellStyle,
          )),
          DataCell(Text(
            '${d.industry}',
            style: cellStyle,
          )),
          DataCell(InkWell(
            onTap: (){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadAnchorFilesPage(data: d,),
                ),
              );

              // showDialog(
              //   // barrierColor: Colors.transparent,
              //     context: context,
              //     builder: (BuildContext context) {
              //       functionBack() {
              //         Navigator.pop(context);
              //       }
              //
              //       return AlertDialog(
              //         // backgroundColor: Colors.transparent,
              //         shape: const RoundedRectangleBorder(
              //             borderRadius: BorderRadius.all(
              //                 Radius.circular(32.0))),
              //         title: const Text(
              //          'Upload Files',
              //           textAlign: TextAlign.left,
              //           style: TextStyle(
              //               color: Color.fromRGBO(0, 0, 0, 1),
              //               fontFamily: 'Poppins',
              //               fontSize: 28,
              //               letterSpacing:
              //               0 /*percentages not used in flutter. defaulting to zero*/,
              //               fontWeight: FontWeight.normal,
              //               height: 1),
              //         ),
              //         content: UploadFilesContainerView(d.cac),
              //       );
              //     });
            },
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: Color.fromRGBO(0, 152, 219, 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 12),
              child: Text(
                'Credit Assesment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(
                        242, 242, 242, 1),
                    fontSize: 14,
                    letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
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

// class TestWidget extends StatefulWidget {
//   String status;
//   String title;
//   int index;
//   AnchorData d;
//
//   TestWidget({Key key, this.status,this.d,this.index,this.title}) : super(key: key);
//
//   @override
//   _TestWidgetState createState() => _TestWidgetState();
// }
//
// class _TestWidgetState extends State<TestWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final tab = Provider.of<TabBarModel>(context);
//     return  TextButton(
//       style: TextButton.styleFrom(
//         backgroundColor:  Colors.green[400],
//       ),
//       onPressed: () async {
//
//         tab.changeTab2(0, widget.index, widget.d,'AnchorEdit','AnchorEdit');
//
//
//
//       },
//       child: ListTile(
//         // trailing: IconButton(
//         //     onPressed: () {
//         //
//         //       tab.changeTab2(0, widget.index, widget.d,);
//         //       return;
//         //
//         //     },
//         //     icon: Icon(Icons.edit,size: 0,)),
//         title: Text(
//           'View',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),);
//   }
// }

class UploadFilesContainerView extends StatefulWidget {
  String rcNumber;
  UploadFilesContainerView(
      @required this.rcNumber,
      {Key key})
      : super(key: key);

  @override
  State<UploadFilesContainerView> createState() =>
      _UploadFilesContainerViewState();
}

class _UploadFilesContainerViewState
    extends State<UploadFilesContainerView> {


  var urlDownload = "";
  bool filesUploading = false;

  DateTime date;
  TextEditingController incomeStatementFile = TextEditingController();
  TextEditingController balanceSheetFile = TextEditingController();
  TextEditingController companyDetails = TextEditingController();
  TextEditingController payableAmountCont;

  bool amountReadOnly = true;

  PlatformFile incomeStatement;

  PlatformFile balanceSheet;

  final String _url = apiUrl + '';


  Future<Object> anchorUploadIncomeStatement(String rcNumber, PlatformFile file) async{

    var _body = {};
    _body['rcNumber'] = rcNumber;
    _body['year'] = '2022';
    //capsaPrint('Upload Function Called ${_body} ${file.path}');
    dynamic _uri;
    _uri = _url + 'credit/InsertIncomeData';
    capsaPrint('URL: $_url');
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri);
    //request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    request.files.add(await http.MultipartFile.fromBytes(
      'excelSheetFile',
      file.bytes,
      contentType: MediaType('application', 'octet-stream'),
    ));
    var res = await request.send();
    capsaPrint('Uploaded File: ${res.reasonPhrase}');
    return res.reasonPhrase;
  }

  Future<Object> anchorUploadBalanceSheet(String rcNumber, PlatformFile file) async{
    var _body = {};
    _body['rcNumber'] = rcNumber;
    _body['year'] = '2022';
    dynamic _uri;
    _uri = _url + 'credit/insertBalanceData';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri,);
    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    request.files.add(await http.MultipartFile.fromBytes(
      'excelSheetFile',
      file.bytes,
      contentType: MediaType('application', 'octet-stream'),
    ));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<Object> anchorUploadCompanyDetails(String rcNumber, String details) async{
    var _body = {};
    _body['rcNumber'] = rcNumber;
    _body['about'] = details;
    var data = await callApi3('/credit/addCompanyDetails', body: _body);
    return data;
  }



  pickFile(TextEditingController controller, bool isProfit) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['xlsx',],
    );

    if (result != null) {
      if (result.files.first.extension == 'xlsx') {
        setState(() {
          isProfit ? incomeStatement = result.files.first : balanceSheet = result.files.first;

          controller.text = isProfit ? incomeStatement.name : balanceSheet.name;
        });
      } else {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                    'Invalid Format Selected. Please Select Another File'),
                actions: <Widget>[
                  TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context)),
                ],
              );
            });
      }
    } else {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('Error Occured. Please Try Again!'),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context)),
              ],
            );
          });
    }
  }


  @override
  void dispose() {
    payableAmountCont.dispose();
    super.dispose();
  }

  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(32))),
      width: MediaQuery.of(context).size.width * 0.6,
      // height: MediaQuery.of(context).size.height * 0.8 ,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   decoration: const BoxDecoration(),
                    //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Container(
                    //         decoration: BoxDecoration(),
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 0, vertical: 0),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: <Widget>[
                    //
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        onTap: () async {
                          return pickFile(incomeStatementFile, true);
                        },
                        readOnly: true,
                        controller: incomeStatementFile,
                        decoration: InputDecoration(
                            helperText: '',
                            labelText: 'Upload Latest Income Statement',
                            suffixIcon: Icon(
                              Icons.file_upload,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        onTap: () async {
                          return pickFile(balanceSheetFile, false);
                        },
                        readOnly: true,
                        controller: balanceSheetFile,
                        decoration: InputDecoration(
                            helperText: '',
                            labelText: 'Upload Latest Balance Sheet',
                            suffixIcon: Icon(
                              Icons.file_upload,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        readOnly: false,
                        controller: companyDetails,
                        decoration: const InputDecoration(
                            hintText: 'Type you company details',
                            labelText: 'Company Details',
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              filesUploading = true;
                            });
                            await anchorUploadBalanceSheet(widget.rcNumber, balanceSheet);
                            await anchorUploadIncomeStatement(widget.rcNumber, incomeStatement);
                            await anchorUploadCompanyDetails(widget.rcNumber, companyDetails.text);
                            showToast('File Uploaded', context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              color: Color.fromRGBO(0, 152, 219, 1),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Text(
                              filesUploading?'Uploading...':'Save',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  fontSize: 18,
                                  letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

