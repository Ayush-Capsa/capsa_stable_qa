import 'dart:convert';

import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/investor/models/invoice_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class InvoiceProvider extends ChangeNotifier {
  // List<InvoiceModel> _invoices = [];
  //
  // List<InvoiceModel> get invoices => _invoices;

  final box = Hive.box('capsaBox');

  Future<Object> loadInVData(String invNum, String amt) async {
    String _url = apiUrl;

    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['invNum'] = invNum;
      if (amt != null && amt != 'null') _body['Amt'] = amt;

      dynamic _uri;
      _uri = _url + 'dashboard/i/bid-status';
      _uri = Uri.parse(_uri);
      capsaPrint('calling : $_uri $_body');
      var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      var data = jsonDecode(response.body);

      print('Response $data');

      return data;
    }

    return null;
  }

  // Future<Object> getCurrencies() async {
  //   if (box.get('isAuthenticated', defaultValue: false)) {
  //     var userData = Map<String, dynamic>.from(box.get('userData'));
  //
  //     var _body = {};
  //
  //     dynamic _uri = 'dashboard/r/getCurrenciesAvailable';
  //
  //     return callApi(_uri, body: _body);
  //   }
  //   return null;
  // }
  //
  // Future<Object> checkCurrency({String currency = 'NGN'}){
  //   if (box.get('isAuthenticated', defaultValue: false)) {
  //     var userData = Map<String, dynamic>.from(box.get('userData'));
  //
  //     var _body = {};
  //     _body['currency'] = currency;
  //     _body['panNumber'] = userData['panNumber'];
  //
  //     dynamic _uri = 'dashboard/r/checkCurrencyAccount';
  //
  //     return callApi(_uri, body: _body);
  //   }
  //   return null;
  // }

}
