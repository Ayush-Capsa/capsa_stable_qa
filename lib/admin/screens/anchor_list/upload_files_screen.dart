import 'dart:convert';
import 'dart:async';
import 'dart:html' as html;

import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'package:capsa/admin/data/anchor_data.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:http/http.dart' as http;

class UploadAnchorFilesPage extends StatefulWidget {
  AnchorData data;
  UploadAnchorFilesPage({Key key, @required this.data}) : super(key: key);

  @override
  State<UploadAnchorFilesPage> createState() => _UploadAnchorFilesPageState();
}

class _UploadAnchorFilesPageState extends State<UploadAnchorFilesPage> {
  var urlDownload = "";
  bool filesUploading = false;
  bool dataVerified = true;

  String incomeStatementSample =
      'https://storage.googleapis.com/download/storage/v1/b/fir-anchor-creditassessment.appspot.com/o/RC12345_2022-06-16_incomeStatement.xlsx?generation=1655358062549210&alt=media';
  String balanceSheetSample =
      'https://storage.googleapis.com/download/storage/v1/b/fir-anchor-creditassessment.appspot.com/o/RC12345_2022-06-16_balanceSheet.xlsx?generation=1655358113617688&alt=media';

  int creditScore = -5;

  DateTime date;
  TextEditingController incomeStatementFile = TextEditingController(text: "");
  TextEditingController balanceSheetFile = TextEditingController(text: "");
  TextEditingController companyDetails = TextEditingController(text: "");
  TextEditingController payableAmountCont;

  bool amountReadOnly = true;

  PlatformFile incomeStatement;

  PlatformFile balanceSheet;

  final String _url = apiUrl + '';

  bool incomeStatementAvailable = false;
  bool balanceSheetAvailable = false;
  bool companyDetailsAvailable = false;

  List<dynamic> yearsPresent = [];
  String years = " ";

  bool dataLoaded = false;

  void initData() async {
    print('pass 1');
    await fetchYearsPresent(widget.data.bvnNum);
    print('pass 2');
    await fetchCompanyDetails(widget.data.bvnNum);
    print('pass 3');
    setState(() {
      dataLoaded = true;
    });
  }

  void fetchCompanyDetails(String panNumber) async {
    var _body = {};
    _body['panNumber'] = panNumber;
    var data = await callApi('/credit/fetchCompanyDetails', body: _body);
    capsaPrint('companyDetailsData: $data');
    companyDetails.text = data['about'];
  }

  downloadFile(url, String fileName) async {
    // final file = await File(url);
    // final byteData = await rootBundle.load('assets/$url');
    //
    // final file = File('${(await getTemporaryDirectory()).path}/$url');
    // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = fileName + '.xlsx';
    anchorElement.click();
    // final rawData = File('assets/$url').readAsBytesSync();
    // final content = base64Encode(rawData);
    // final anchor = html.AnchorElement(
    //     href: "data:application/octet-stream;charset=utf-16le;base64,$content")
    //   ..setAttribute(fileName, "file.xlsx")
    //   ..click();
  }

  void fetchYearsPresent(String panNumber) async {

    //var data = await callApi3('/credit/yearsPresent', body: _body);

    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = panNumber;
      var data = await callApi('/credit/yearsPresent', body: _body);
      capsaPrint('years present: $data');
      yearsPresent = data;
      //yearsPresent = [];
      for (var element in yearsPresent) {
        years = years + element.toString() + ',  ';
      }
    }


    // setState(() {
    //   dataLoaded = true;
    // });
    //return data['result'].floor();
  }

  Future<int> fetchCreditScore(String panNumber, String year) async {
    var _body = {};
    _body['panNumber'] = panNumber;
    _body['year'] = year;
    var data = await callApi('/credit/fetchCreditScore', body: _body);
    capsaPrint('creditScoreData: $data');
    double result;
    if(data['yearsPresent'].length>0){
      result = data['creditScoreData'][data['yearsPresent'][data['yearsPresent'].length-1]]['result'];
    }else{
      result = 0.0;
    }
    return result.floor();
  }

  Future<Object> anchorUploadIncomeStatement(
      String rcNumber, PlatformFile file) async {
    var _body = {};
    _body['rcNumber'] = rcNumber;
    _body['year'] = '2022';
    //capsaPrint('Upload Function Called ${_body} ${file.path}');

    dynamic _uri;
    _uri = _url + 'credit/InsertIncomeData';
    capsaPrint('URL: $_uri');
    capsaPrint('Income File $_body');
    //_uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', Uri.parse(_uri));
    //request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');
    request.fields['web'] = kIsWeb.toString();

    //request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file.bytes,
      filename: 'income_statement' + file.extension,
      contentType: MediaType('multipart', 'form-data'),
    ));
    request.headers.addAll({'Content-type': 'multipart/form-data','Authorization': 'Basic ' + box.get('token', defaultValue: '0')});
    var res = await request.send();
    //print('Response: ${res.statusCode}');
    var response = await http.Response.fromStream(res);
    capsaPrint('Income Statement Uploaded File: ${response.body}');

    if (res.statusCode == 400) {
      var json = jsonDecode(response.body);
      dataVerified = false;
      showToast(json['msg'], context, type: 'warning');
    } else {
      print('Ratios body : $_body');
      var data = await callApi('credit/addKeyRatios', body: _body);
      var data2 = await callApi('/credit/addCreditScore', body: _body);
      // print('DATA 1 $data2');
    }
    return res.reasonPhrase;
  }

  Future<Object> anchorUploadBalanceSheet(
      String rcNumber, PlatformFile file) async {
    var _body = {};
    _body['rcNumber'] = rcNumber;
    _body['year'] = '2022';
    dynamic _uri;
    _uri = _url + 'credit/insertBalanceData';
    _uri = Uri.parse(_uri);

    capsaPrint('Balance File $_body');

    var request = http.MultipartRequest(
      'POST',
      _uri,
    );
    request.fields['web'] = kIsWeb.toString();
    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file.bytes,
      filename: 'balance_sheet' + file.extension,
      contentType: MediaType('multipart', 'form-data'),
    ));
    request.headers.addAll({'Content-type': 'multipart/form-data','Authorization': 'Basic ' + box.get('token', defaultValue: '0')});
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    capsaPrint('Balance Statement Uploaded File: ${response.body}');
    // var json = jsonDecode(response.body);

    if (res.statusCode == 400) {
      dataVerified = false;
      var json = jsonDecode(response.body);
      json['msg'] == 'income sheet format is not valid'
          ? showToast('Balance sheet format is not valid', context,
              type: 'warning')
          : showToast(json['msg'], context, type: 'warning');
    } else {
      var data = await callApi('credit/addKeyRatios', body: _body);
      var data2 = await callApi('/credit/addCreditScore', body: _body);
      // print('DATA 1 $data2');
    }

    return res.reasonPhrase;
  }

  Future<Object> anchorUploadCompanyDetails(
      String rcNumber, String details) async {
    var _body = {};
    _body['rcNumber'] = rcNumber;
    _body['about'] = details;
    var data = await callApi('/credit/addCompanyDetails', body: _body);
    return data;
  }

  pickFile(TextEditingController controller, bool isProfit) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        'xlsx',
      ],
    );

    if (result != null) {
      if (result.files.first.extension == 'xlsx') {
        setState(() {
          isProfit
              ? incomeStatement = result.files.first
              : balanceSheet = result.files.first;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: dataLoaded == true
            ? SingleChildScrollView(
                child: Container(
                  // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(32))),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.8 ,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
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
                                SizedBox(
                                  height: 22,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: InkWell(
                                                onTap: () =>
                                                    Navigator.pop(context),
                                                child: Icon(
                                                  Icons.arrow_back_rounded,
                                                  color: Colors.blue,
                                                  size: 32,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            child: Text(
                                              'Update Anchor Details',
                                              style: TextStyle(
                                                color: Color(
                                                  0xff333333,
                                                ),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            "assets/images/Ellipse 3.png",
                                            width: 35,
                                            height: 35,
                                          ),
                                        ],
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                    ),
                                  ],
                                  mainAxisSize: MainAxisSize.min,
                                ),
                                Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                // SizedBox(
                                //   height: 15,
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     Image(
                                //       image: AssetImage(
                                //           "assets/images/Ellipse 3.png"),
                                //       height: 70,
                                //       width: 70,
                                //     ),
                                //   ],
                                // ),
                                const SizedBox(
                                  height: 40,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Data avaialable for : $years',
                                      style: TextStyle(
                                        color: Color(
                                          0xff333333,
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Poppins",
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 95,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value.isNotEmpty) {}
                                          return null;
                                        },
                                        onTap: () async {
                                          return pickFile(
                                              incomeStatementFile, true);
                                        },
                                        readOnly: true,
                                        controller: incomeStatementFile,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.white,
                                          //errorText : errorText,
                                          labelText:
                                              'Upload Latest Income Statement',
                                          suffixIcon: Icon(
                                            Icons.file_upload,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 28,
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              left: 8.0,
                                              bottom: 12.0,
                                              top: 12.0),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(15.7),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(15.7),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                            onTap: () {
                                              downloadFile(
                                                  incomeStatementSample,
                                                  'IncomeStatement - IFRS');
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '*Download here the format in which you have to upload Income Statement',
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.blue),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.download_rounded,
                                                  size: 20,
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 95,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'This field is required';
                                          }
                                          return null;
                                        },
                                        onTap: () async {
                                          return pickFile(
                                              balanceSheetFile, false);
                                        },
                                        readOnly: true,
                                        controller: balanceSheetFile,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.white,
                                          //errorText : errorText,
                                          labelText:
                                              'Upload Latest Balance Sheet',
                                          suffixIcon: Icon(
                                            Icons.file_upload,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 28,
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              left: 8.0,
                                              bottom: 12.0,
                                              top: 12.0),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(15.7),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(15.7),
                                          ),
                                        ),
                                        // decoration: InputDecoration(
                                        //     helperText: '',
                                        //     labelText: 'Upload Latest Balance Sheet',
                                        //     suffixIcon: Icon(
                                        //       Icons.file_upload,
                                        //       color: Theme.of(context).primaryColor,
                                        //       size: 28,
                                        //     )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                            onTap: () {
                                              downloadFile(balanceSheetSample,
                                                  'BalanceSheet - IFRS');
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '*Download here the format in which you have to upload Balance Sheet',
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.blue),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.download_rounded,
                                                  size: 20,
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  height: 120,
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    readOnly: false,
                                    maxLines: 4,
                                    controller: companyDetails,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xff525252)),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      //errorText : errorText,
                                      label: Text('Company Details'),
                                      hintText: 'Enter your company details',
                                      hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(130, 130, 130, 1),
                                          fontSize: 15,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1.2),
                                      contentPadding: const EdgeInsets.only(
                                          left: 8.0, bottom: 12.0, top: 12.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(15.7),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(15.7),
                                      ),
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
                                        creditScore = await fetchCreditScore(
                                            widget.data.bvnNum,
                                            yearsPresent[
                                                yearsPresent.length - 1]);
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 240,
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
                                          creditScore < 0
                                              ? 'Calculate Credit Score'
                                              : 'Calculate Credit Score : $creditScore',
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
                                    ),
                                    // SizedBox(width: 60,),
                                    // InkWell(
                                    //   onTap: () async {
                                    //     Navigator.pop(context);
                                    //   },
                                    //   child: Container(
                                    //     width: 140,
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.only(
                                    //         topLeft: Radius.circular(15),
                                    //         topRight: Radius.circular(15),
                                    //         bottomLeft: Radius.circular(15),
                                    //         bottomRight: Radius.circular(15),
                                    //       ),
                                    //       color: Colors.red,
                                    //     ),
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 16, vertical: 16),
                                    //     child: Text(
                                    //       'Cancel',
                                    //       textAlign: TextAlign.center,
                                    //       style: TextStyle(
                                    //           color: Color.fromRGBO(242, 242, 242, 1),
                                    //           fontSize: 18,
                                    //           letterSpacing:
                                    //           0 /*percentages not used in flutter. defaulting to zero*/,
                                    //           fontWeight: FontWeight.normal,
                                    //           height: 1),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                filesUploading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator()
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                filesUploading = true;
                                                dataVerified = true;
                                              });
                                              //capsaPrint('balance sheet file : ${balanceSheetFile.text}');
                                              if (incomeStatementFile.text !=
                                                  "") {
                                                await anchorUploadIncomeStatement(
                                                    widget.data.cac,
                                                    incomeStatement);
                                                capsaPrint('pass 1 ${balanceSheetFile.text} ${dataVerified}');
                                              }
                                              if (balanceSheetFile.text != "" &&
                                                  dataVerified) {
                                                capsaPrint('pass 2');
                                                await anchorUploadBalanceSheet(
                                                    widget.data.cac,
                                                    balanceSheet);
                                                capsaPrint('pass 2.1');
                                              }
                                              if (companyDetails.text != "" &&
                                                  dataVerified) {
                                                await anchorUploadCompanyDetails(
                                                    widget.data.cac,
                                                    companyDetails.text);
                                              }
                                              if (dataVerified) {
                                                showToast(
                                                    'File Uploaded', context);
                                                Navigator.pop(context);
                                              }
                                              setState(() {
                                                filesUploading = false;
                                              });
                                            },
                                            child: Container(
                                              width: 140,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                color: Color.fromRGBO(
                                                    0, 152, 219, 1),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 16),
                                              child: Text(
                                                'Save',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 242, 1),
                                                    fontSize: 18,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 140,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                color: Colors.red,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 16),
                                              child: Text(
                                                'Cancel',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 242, 1),
                                                    fontSize: 18,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
