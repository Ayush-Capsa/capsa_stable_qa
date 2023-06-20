// import 'dart:typed_data';

import 'package:capsa/admin/data/investor_data.dart';
import 'package:capsa/admin/data/vendor_data.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:universal_html/html.dart' as html;

class ActionModel extends ChangeNotifier {
  String _url = apiUrl + '';

  Future<Object> getVendorAccountList(bvnNum) async {
    var _body = {};
    dynamic _uri;
    _body['bvnNum'] = bvnNum;
    return await callApi('admin/requestor-acletter', body: _body);
    // _uri = _url + 'admin/requestor-acletter';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri,  headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // },body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryRCCinData() async {
    return await callApi('admin/getrclist');
  }

  Future<Object> queryAdminDashboard() async {
    return await callApi('admin/getAdminDashboard');
  }

  Future<Object> queryRCAPIData(body) async {
    return await callApi('admin/getCreditData', body: body);
  }

  Future<Object> queryLatestBSAData(body) async {
    return await callApi('okra/LatestBSAData', body: body);
  }

  Future<Object> queryInvoiceList({filter,filterInvoiceNo}) async {
    var _body = {};
    if (filter != null) _body['filter'] = filter;
    if (filterInvoiceNo != null) _body['filterInvoiceNo'] = filterInvoiceNo;
    return await callApi('admin/invoice-list', body: _body);
    // dynamic _uri;
    // _uri = _url + 'admin/invoice-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri,  headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // },body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> getInvFile(_body) async {
    return await callApi('dashboard/a/getInvFile', body: _body);
    // dynamic _uri;
    // _uri = _url + 'dashboard/a/getInvFile';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }
  Future<Object> getKYCFiles(_body) async {
    return await callApi('dashboard/r/getKYCFiles',body: _body);


  }




  Future<Object> approveRejectKYC(type,kycNo,bvnNum) async {

    var _body = {};

    _body['bvnNum'] = bvnNum.toString();
    _body['kycNo'] = kycNo.toString();
    _body['type'] = type.toString();

    return await callApi('admin/requestor-kyc-approve',body: _body);

  }

  Future<Object> downloadFile(String url, {isCsv: false, name: ''}) async {
    dynamic _uri = Uri.parse(url);

    var response = await http.get(_uri);

    // capsaPrint(data);

    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement anchorElement = html.AnchorElement(href: url);

      if (isCsv) {
        anchorElement.download = 'Revenue.csv';
        anchorElement.click();
        html.Url.revokeObjectUrl(url);
        return null;
      } else {
        if (name == '')
          anchorElement.download = 'Invoice.pdf';
        else
          anchorElement.download = name + '.pdf';

        anchorElement.click();
        html.Url.revokeObjectUrl(url);
      }
    }
    return null;
  }

  Future<Object> queryPendingInvoiceList({filterInvoiceNo }) async {
    var _body = {};
    if (filterInvoiceNo != null) _body['filterInvoiceNo'] = filterInvoiceNo;
    return await callApi('admin/pending-invoice-list',body:_body);
    // var _body = {};
    // dynamic _uri;
    // _uri = _url + 'admin/pending-invoice-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryRevenueRecognition({filterInvoiceNo }) async {
    var _body = {};
    if (filterInvoiceNo != null) _body['filterInvoiceNo'] = filterInvoiceNo;
    return await callApi('admin/revenue-recognition-list',body:_body);

  }


  Future<Object> queryBlockedAmount({ search:'' }) async {
    var _body = {};
  _body['search'] = search;
    return await callApi('admin/blocked-amount-accounts',body:_body);

  }


  Future<Object> moveBlockedAmount(body) async {
    var _body = {};
    _body = body;
    return await callApi('admin/blocked-amount-move',body:_body);

  }

  Future<Object> queryInvoiceForSettlement() async {
    return await callApi('admin/invoiceForSettlement');
  }

  Future<Object> invoiceSettlementApply(body) async {
    return await callApi('admin/invoiceSettlementApply', body: body);
  }

  Future<Object> queryPendingRevenueList() async {
    return await callApi('admin/pending-invoice-list', body: {'revenue': 'true'});
    // var _body = {};
    // dynamic _uri;
    // _uri = _url + 'admin/pending-invoice-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryEnquiry(title,filter) async {
    var _body = {};
    dynamic _uri;
    if (title == 'Vendor On-boarding') {
      _uri = 'admin/requestor-list-onboard';
    } else {
      _uri = 'admin/investor-list-onboard';
    }
   if(filter != null && filter != "")
     _body = {'filter':filter};
    return await callApi(_uri, body: _body);

    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryInvestorList({filter}) async {
    var _body = {};
    if(filter != null) _body['filter'] = filter;

    return await callApi('admin/investor-list', body: _body);

    //
    // dynamic _uri;
    // _uri = _url + 'admin/investor-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryVendorList({filter }) async {
    var _body = {};
    if(filter != null) _body['filter'] = filter;
    return await callApi('admin/requestor-list', body: _body);

    //
    // dynamic _uri;
    // _uri = _url + 'admin/requestor-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryAnchorList() async {
    var _body = {};
    return await callApi('admin/anchor-list', body: _body);

    // var _body = {};
    // dynamic _uri;
    // _uri = _url + 'admin/anchor-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryAnchorInvoiceList() async {
    var _body = {};
    return await callApi('admin/anchorInvoiceList', body: _body);

    // var _body = {};
    // dynamic _uri;
    // _uri = _url + 'admin/anchor-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryAnchorRFList() async {
    var _body = {};
    return await callApi('admin/anchorRFList',);

    // var _body = {};
    // dynamic _uri;
    // _uri = _url + 'admin/anchor-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryVendorRFList() async {
    var _body = {};
    return await callApi('admin/vendorsRFList',);

    // var _body = {};
    // dynamic _uri;
    // _uri = _url + 'admin/anchor-list';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryInvestorView(bvnNumber) async {
    var _body = {};
    _body['panNo'] = bvnNumber;
    return await callApi('admin/investor-view', body: _body);
    // dynamic _uri;
    // _uri = _url + 'admin/investor-view';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{
    //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
    // }, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future<Object> queryVendorView(bvnNumber) async {
    var _body = {};
    _body['panNo'] = bvnNumber;
    dynamic _uri;
    _uri = _url + 'admin/requestor-view';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> setOnBoardData(body) async {
    var _body = body;
    dynamic _uri;
    if (_body['role'] == 'investor') {
      _uri = _url + 'admin/investor-list/setOnBoard';
    } else {
      _uri = _url + 'admin/requestor-list/setOnBoard';
    }
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> anchorOnBoardData(Map<String, dynamic> body, filename1, filename2) async {
    var _body = body;
    dynamic _uri;
    _uri = _url + 'admin/anchor-list-onboard';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> anchorOnBoardDataWithFile(Map<dynamic, dynamic> body, PlatformFile filename1, PlatformFile filename2) async {
    var _body = body;
    dynamic _uri;
    _uri = _url + 'admin/anchor-list-onboard';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri);

    request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    if (kIsWeb) {
      capsaPrint('web');
      request.files.add(http.MultipartFile.fromBytes(
        'lpls_file',
        filename1.bytes,
        contentType: MediaType('application', 'octet-stream'),
      ));
      request.files.add(http.MultipartFile.fromBytes(
        'lbs_file',
        filename2.bytes,
        contentType: MediaType('application', 'octet-stream'),
      ));
    } else {
      capsaPrint('mob');
      request.files.add(await http.MultipartFile.fromPath(
        'lpls_file',
        filename1.path,
        contentType: MediaType('application', 'octet-stream'),
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'lbs_file',
        filename2.path,
        contentType: MediaType('application', 'octet-stream'),
      ));
    }

    var res = await request.send();
    // capsaPrint(res.reasonPhrase);
    return res.reasonPhrase;
  }

  Future<Object> anchorUploadIncomeStatement(String rcNumber, PlatformFile file) async{
    var _body;
    _body['rcNumber'] = rcNumber;
    _body['year'] = '2021';
    dynamic _uri;
    _uri = _url + 'credit/InsertIncomeData';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri,);
    request.fields['rcNumber'] = rcNumber;
    request.fields['year'] = '2021';
    request.files.add(await http.MultipartFile.fromPath(
      'excelSheetFile',
      file.path,
      contentType: MediaType('application', 'octet-stream'),
    ));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<Object> anchorUploadBalanceSheet(String rcNumber, PlatformFile file) async{
    var _body;
    _body['rcNumber'] = rcNumber;
    _body['year'] = '2021';
    dynamic _uri;
    _uri = _url + 'credit/insertBalanceData';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri,);
    request.fields['rcNumber'] = rcNumber;
    request.fields['year'] = '2021';
    request.files.add(await http.MultipartFile.fromPath(
      'excelSheetFile',
      file.path,
      contentType: MediaType('application', 'octet-stream'),
    ));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<Object> createVendorAccount(VendorData vdata) async {
    var _body = {};
    _body['email'] = vdata.email;
    _body['companyPan'] = vdata.bvnNum;
    _body['name'] = vdata.compName;
    _body['btn_type'] = "APPROVE";

    dynamic _uri;
    _uri = _url + 'admin/rcreateaccount';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> createLendorAccount(InvestorData vdata) async {
    var _body = {};
    _body['email'] = vdata.email;
    _body['companyPan'] = vdata.bvnNum;
    _body['name'] = vdata.compName;
    _body['btn_type'] = "APPROVE";

    dynamic _uri;
    _uri = _url + 'admin/lcreateaccount';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> vendorAction(VendorData vData, String btnType) async {
    var _body = {};
    _body['email'] = vData.email;
    _body['companyPan'] = vData.bvnNum;
    _body['name'] = vData.compName;
    // _body['btn_type'] = "APPROVE";
    _body['btn_type'] = btnType;

    dynamic _uri;
    _uri = _url + 'admin/actionar';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> vendorAccountLetter(VendorData vData, String approve) async {
    var _body = {};
    _body['email'] = vData.email;
    _body['companyPan'] = vData.bvnNum;
    _body['pan'] = vData.bvnNum;
    _body['name'] = vData.compName;
    _body['companyName'] = vData.compName;
    _body['approve'] = approve;

    dynamic _uri;
    _uri = _url + 'admin/accountletter';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    return data;
  }
}
