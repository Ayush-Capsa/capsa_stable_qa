import 'dart:convert';

import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';

import 'package:capsa/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

import 'package:universal_html/html.dart' as html;

class AnchorActionProvider extends ChangeNotifier {
  final box = Hive.box('capsaBox');

  String _url = apiUrl;

  bool _loading = false;

  bool get loading => _loading;

  void callRefresh() {
    _loading = !_loading;

    Future.delayed(const Duration(milliseconds: 500), () {
      _loading = !_loading;
      notifyListeners();
    });
  }

  Future<Object> getInvFile(_body) async {
    return await callApi('dashboard/a/getInvFile',body: _body);


  }

  Future<Object> setData(data) async {
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }
    List<AcctTableData> _acctTableData = <AcctTableData>[];
    var _data = data;
    if (_data['res'] == 'success') {
      var _results = _data['data']['invoicelist'];
      // capsaPrint(_results);
      _results.forEach((element) {
        DateTime invoiceDate = new DateFormat("yyyy-MM-dd").parse(element['invoice_date']);

        DateTime invoiceDueDate = new DateFormat("yyyy-MM-dd").parse(element['invoice_due_date']);

        // capsaPrint(element['invoice_file']);

        var d1 = DateFormat.yMMMd('en_US').format(invoiceDate);
        var d2 = DateFormat.yMMMd('en_US').format(invoiceDueDate);
        var tenure = daysBetween(invoiceDate, invoiceDueDate).toString();

        _acctTableData.add(AcctTableData(
          element['invoice_number'].toString(),
          element['NAME'],
          element['invoice_value'].toString(),
          d1,
          invoiceDate,
          d2,
          invoiceDueDate,
          element['ask_amt'].toString(),
          element['payment_terms'],
          element['ask_rate'].toString(),
          element['status'].toString(),
          element['company_pan'].toString(),
          element['invoice_file'],
            tenure
        ));
      });
    }
    return _acctTableData;
  }

  Future<Object> downloadFile(String url) async {
    dynamic _uri = Uri.parse(url);

    var response = await http.get(_uri);

    // capsaPrint(data);

    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = 'Invoice.pdf';
      anchorElement.click();
      html.Url.revokeObjectUrl(url);
    }
    return null;
  }

  Future<Object> removeFromList(AcctTableData invoice) async {
    return null;
  }

  Future<Object> queryInvoiceList() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));


      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];

      var data =  await callApi('dashboard/a/invoicelist',body: _body);
      List<AcctTableData> _acctTableData = await setData(data);
      return _acctTableData;
    }

    return null;
  }

  Future<Object> approve( date, dateText, amt, AcctTableData invoice) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));




      capsaPrint('userData');
      capsaPrint('$userData');
      var _body = {};



      _body['userName'] = userData['userName'];
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['role'] = userData['role'];
      _body['i_amount'] = amt;
      _body['i_date'] = date;
      _body['inv_num'] = invoice.invNo;
      _body['inv_date'] = invoice.invDueDate;
      _body['inv_date'] = invoice.invDate;
      _body['inv_val'] = invoice.invAmt;
      _body['cust_name'] = '';
      _body['invoice_num_'] = invoice.invNo;
      // _body['invoice_num_'] = invoice.invNo;

      // capsaPrint('_body');
      // capsaPrint(_body);
      return await callApi('dashboard/a/approve',body: _body);
      // dynamic _uri;
      // _uri = _url + 'dashboard/a/approve';
      // _uri = Uri.parse(_uri);
      // var response = await http.post(_uri, headers: <String, String>{
      //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
      // }, body: _body);
      // var data = jsonDecode(response.body);
      //
      // // capsaPrint(data);
      // return data;
    }

    return null;
  }

  Future<Object> reject(AcctTableData invoice) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['ino'] = invoice.invNo;
      _body['comppan'] = invoice.companyPan;

      // capsaPrint('_body');
      // capsaPrint(_body);
      return await callApi('dashboard/a/reject',body: _body);
      // dynamic _uri;
      // _uri = _url + 'dashboard/a/reject';
      // _uri = Uri.parse(_uri);
      // var response = await http.post(_uri, headers: <String, String>{
      //   'Authorization': 'Basic '+box.get('token',defaultValue: '0')
      // }, body: _body);
      // var data = jsonDecode(response.body);
      // // capsaPrint(data);
      // return data;
    }

    return null;
  }

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

}


class AcctTableData {
  String invNo;
  String vendor;
  String invAmt;
  String invDate;
  DateTime invDateO;
  String invDueDate;
  DateTime invDueDateO;
  String buyNowAmt;
  String payTerms;
  String bidRate;
  String status;
  String tenure;
  String companyPan;
  dynamic fileName;

  AcctTableData(this.invNo, this.vendor, this.invAmt, this.invDate, this.invDateO, this.invDueDate, this.invDueDateO, this.buyNowAmt, this.payTerms,
      this.bidRate, this.status, this.companyPan, this.fileName,this.tenure);
}