import 'dart:convert';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';

import 'package:capsa/models/bid_history_model.dart';
import 'package:capsa/vendor-new/model/bids_model.dart';

// import 'package:capsa/vendor/data/bids_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

// import 'package:capsa/vendor/models/invoice_model.dart';
// import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:universal_html/html.dart' as html;

class VendorActionProvider extends ChangeNotifier {
  String _url = apiUrl + 'dashboard/r/';

  final box = Hive.box('capsaBox');


  num _bidProposalCount = 0;

  dynamic get bidProposalCount => _bidProposalCount;


  Future getCompanyName() async {
    dynamic _uri = _url + 'getCompanyName';
    _uri = Uri.parse(_uri);
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    _body['panNumber'] = userData['panNumber'];
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    capsaPrint(data);
    return data;
  }

  Future<Object> queryInvoiceData(String invoiceNumber) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      // capsaPrint('userData');
      // capsaPrint(userData);
      _body['panNumber'] = userData['panNumber'];

      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];
      _body['invoiceNumber'] = (invoiceNumber != null) ? invoiceNumber : '';

      dynamic _uri = 'dashboard/r/invoiceByNumber';

      return callApi(_uri, body: _body);
    }
    return null;
  }

  Future uploadRevenue(invoice, file) async {
    var _body = invoice.toJson();
    dynamic _uri = _url + 'revenueupload';
    _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;

    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');

    request.files.add(http.MultipartFile.fromBytes(
      'revenue_file',
      file.bytes,
      filename: _body['bvnNo'] + '_' + _body['invNo'] + '_' + DateTime.now().millisecondsSinceEpoch.toString() + '.' + file.extension,
      contentType: MediaType('application', 'octet-stream'),
    ));

    var res = await request.send();
    // capsaPrint(res.reasonPhrase);
    return jsonDecode((await http.Response.fromStream(res)).body);
  }

  Future uploadInvoice(invoice, PlatformFile file,) async {
    // capsaPrint(DateTime.now().millisecondsSinceEpoch.toString());

    var _body = invoice.toJson();
    //_body['currency'] = currency;

    dynamic _uri = _url + 'invoiceupload';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');

    request.files.add(http.MultipartFile.fromBytes(
      'invoice_file',
      file.bytes,
      filename: _body['bvnNo'] + '_' + _body['invNo'] + '_' + DateTime.now().millisecondsSinceEpoch.toString() + '.' + file.extension,
      contentType: MediaType('application', 'octet-stream'),
    ));

    var res = await request.send();
    capsaPrint(res.reasonPhrase);

    var data = jsonDecode((await http.Response.fromStream(res)).body);
    capsaPrint(data);
    return data;

    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future bidProposal() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      // capsaPrint('userData');
      // capsaPrint(userData);

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];
       var result = await callApi("dashboard/r/getbidProposal", body: _body);
      if (result['res'] == 'success') {

        List proposalsList = result['data']['Proposalslist'];
        _bidProposalCount = proposalsList.length;
        notifyListeners();

      }

      return result ;

    }
    return null;
  }

  Future bidProposalDetails(invoiceNum) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];
      _body['invoiceNum'] = invoiceNum;
      return await callApi("dashboard/r/getProposalDetails", body: _body);
    }
    return null;
  }

  Future actionRejectProposal( BidsModel  invoice, String step) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];

      _body['invoice'] = invoice.invoice_number;
      _body['step'] = step;

      _body['company_pan'] = userData['panNumber'];
      _body['comp_pan'] = userData['panNumber'];
      _body['cust_pan'] = invoice.cust_pan;
      _body['inv_pan'] = invoice.lender_pan;

      // capsaPrint(_body);
      dynamic _uri;
      _uri = _url + 'acceptProposal';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      var data = jsonDecode(response.body);
      return data;
    }
    return null;
  }

  Future getBank() async {
    // return await callApi('signin/getBankList');
    dynamic _uri = apiUrl + 'signin/getBankList';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },body: {});
    var data = jsonDecode(response.body);
    // capsaPrint(data);
    return data;
  }

  Future actionOnProposal(BidsModel invoice, String step, String digitalName) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      // capsaPrint('userData');

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];

      _body['invoice'] = invoice.invoice_number;
      _body['step'] = step;
      _body['digital_name'] = digitalName;

      _body['company_pan'] = userData['panNumber'];
      _body['cust_pan'] = invoice.cust_pan;
      _body['inv_pan'] = invoice.lender_pan;
      _body['inv_no'] = invoice.invoice_number;
      _body['dis_amt'] = invoice.prop_amt;
      _body['rate'] = invoice.int_rate;
      _body['hidden_step'] = 'ACCEPT';
      _body['hidden_comp_pan'] = userData['panNumber'];
      _body['hidden_cust_pan'] = invoice.cust_pan;
      _body['hidden_inv_pan'] = invoice.lender_pan;
      _body['hidden_inv_no'] = invoice.invoice_number;
      _body['hidden_prop_amt'] = invoice.prop_amt;
      _body['hidden_int_rate'] = invoice.int_rate;
      _body['hidden_due_dt'] = invoice.due_date;
      _body['hidden_invc_dt'] = invoice.start_date;
      _body['hidden_datapass'] = jsonEncode(invoice.toJson());

      // capsaPrint(_body);
      dynamic _uri;
      _uri = _url + 'digitalsignature';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      var data = jsonDecode(response.body);
      return data;
    }
    return null;
  }

  Future loadPurchaseAgreement(BidsModel invoice) async {

    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      // capsaPrint('invoice');
      // capsaPrint(invoice);
      var _body = {};
      // capsaPrint('loadPurchaseAgreement');
      // capsaPrint('userData');
      // capsaPrint( invoice.cust_pan);

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];

      _body['hidden_step'] = 'ACCEPT';
      _body['hidden_comp_pan'] = userData['panNumber'];
      _body['hidden_cust_pan'] = invoice.cust_pan;
      _body['hidden_inv_pan'] = invoice.lender_pan;
      _body['hidden_inv_no'] = invoice.invoice_number;
      _body['hidden_prop_amt'] = invoice.prop_amt;
      _body['hidden_int_rate'] = invoice.int_rate;
      _body['hidden_due_dt'] = invoice.due_date;
      _body['hidden_invc_dt'] = invoice.start_date;
      _body['hidden_datapass'] = jsonEncode(invoice.toJson());

      // capsaPrint('_body');
      // capsaPrint(_body);

      dynamic _uri;
      _uri = _url + 'loadPurchaseAgreement';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      var data = jsonDecode(response.body);
      return data;
    }
    return null;
  }



  Future loadPurchaseAgreement2(BidHistoryModel invoice) async {

    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};


      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];

      _body['hidden_download'] = "true";
      _body['hidden_comp_pan'] = invoice.companyPan;
      _body['hidden_cust_pan'] = invoice.cust_pan;
      _body['hidden_inv_pan'] = invoice.investor_pan;
      _body['hidden_inv_no'] = invoice.invoiceNumber;
      _body['hidden_adata'] = jsonEncode(invoice.toLoadPurchaseAggJson());

      var dName ;
      if (dName != null) _body['hidden_digisign'] = dName;

      // capsaPrint('_body');
      // capsaPrint(_body);

      dynamic _uri;
      _uri =  apiUrl + 'dashboard/i/' + 'loadPurchaseAgreement2';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      var data = jsonDecode(response.body);
      return data;
    }
    return null;
  }

  Future downloadRevenueSample() async {
    capsaPrint('downloadRevenueSample');

    dynamic _uri = apiUrl + 'signin/revenueSampleDownload';
    _uri = Uri.parse(_uri);
    var _body = {};

    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },body: _body);
    // capsaPrint(response);

    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes], "application/csv");
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = 'Sample_Revenue_Streams.csv';
      anchorElement.click();
      html.Url.revokeObjectUrl(url);
    }
  }
}
