import 'package:capsa/common/constants.dart';
import 'package:capsa/models/bid_history_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}

class BidHistoryProvider extends ChangeNotifier {
  List<BidHistoryModel> _bidHistoryDataList = [];

  List<BidHistoryModel> get bidHistoryDataList => _bidHistoryDataList;
  final box = Hive.box('capsaBox');

  Future<Object> queryBidHistoryList({String search, date, date2, bool isInv: false, String currency = 'All'}) async {
    _bidHistoryDataList = [];
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};

      _body['panNumber'] = userData['panNumber'];

      _body['userName'] = userData['userName'];
      if (!isInv) _body['isCompany'] = 'true';
      if (search != null) _body['search'] = search;
      // if (date != null) _body['date'] = date;

      dynamic _uri;
      if (isInv)
        _uri = apiUrl + 'dashboard/i/bid-history';
      else
        _uri = apiUrl + 'dashboard/r/bid-history';

      _uri = Uri.parse(_uri);

      var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      var data = jsonDecode(response.body);
      // capsaPrint('History Response $data');
      if (data['res'] == 'success') {
        var _data = data['data'];
        // List userMaster = _data['userMaster'];

        var bidsHistoryList = _data['history'];
        var historyStatus = _data['historyStatus'];
        int yy = 0;
        List<BidHistoryModel> _bidHistoryList = [];
        int i = 0;

        bidsHistoryList.forEach((element) {

          if(i == 0){
            capsaPrint('History bid : ${element}');
          }
          i++;

          var hStatus = historyStatus[yy];


          var _platForm = ((element['invoice_value'] - element['discount_val']) / 100) * 8.5;

          BidHistoryModel _bidHistoryModel = BidHistoryModel(
              discountedDate: DateTime.parse(element['discounted_date']),
              invoiceNumber: element['invoice_number'].toString(),
              paymentStatus: element['payment_status'].toString(),
              discountVal: element['discount_val'].toString(),
              companyPan: element['company_pan'].toString(),
              investor_pan: element['investor_pan'].toString(),
              cust_pan: element['customer_gst'].toString().replaceAll('X', ''),
              companyName: element['company_name'].toString(),
              effectiveDueDate: element['edd'].toString(),
              transactionsStatus: element['transactionStatus'].toString(),
              address: element['ADD_LINE'].toString() + " " + element['CITY'].toString()  + " " + element['STATE'].toString() ,
              customerName: element['customer_name'],
              investorName: element['NAME'],
              startDate: element['start_date'].toString(),
              endDate: element['due_date'].toString(),
              tenure: hStatus[0],
              email: "",
              historyStatus: hStatus[0],
              invoiceValue: element['invoice_value'].toString(),
              fileName: element['invoice_file'],
              netReturn: (element['invoice_value'] + _platForm).toString(),
              askRate: element['ask_rate'].toStringAsFixed(2),
              currency: element['currency'],
              platFormFee: _platForm.toString());

          // capsaPrint('_bidHistoryModel');
          // capsaPrint('$_bidHistoryModel');

          _bidHistoryList.add(_bidHistoryModel);
          yy++;
        });
        capsaPrint('Pass 1');
        if (date != null && date2 != null) {
          _bidHistoryList = _bidHistoryList.where((element) {
            var isDate = false;
            if (date != null && date2 != null) {
              DateTime createdOn = element.discountedDate;
              if (date.isBefore(createdOn) && date2.isAfter(createdOn)) {
                isDate = true;
              }
              // capsaPrint("createdOn"+createdOn.toString());
            }

            return isDate;

            return true;
          }).toList();
        }
        _bidHistoryList = _bidHistoryList.where((element) {
          var isCurrency = false;
          if(currency!='All'){
            if(currency == element.currency){
              isCurrency = true;
            }
          }else{
            isCurrency = true;
          }

          return isCurrency;

          return true;
        }).toList();
        capsaPrint('Pass 2 ${_bidHistoryList.length} $currency');
        _bidHistoryDataList.addAll(_bidHistoryList);
        notifyListeners();
      }
      return data;
    }

    return null;
  }

  Future<Object> myBidHistoryList({String search, date, date2, bool isonlyAccept: false, String currency = 'All'}) async {
    _bidHistoryDataList = [];

    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};

      _body['panNumber'] = userData['panNumber'];

      _body['userName'] = userData['userName'];

      if (search != null) _body['search'] = search;

      if (isonlyAccept) _body['isOnlyAccept'] = isonlyAccept.toString();

      dynamic _uri;

      _uri = apiUrl + 'dashboard/i/bid-history';

      _uri = Uri.parse(_uri);

      var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      var data = jsonDecode(response.body);
      if (data['res'] == 'success') {
        var _data = data['data'];
        // List userMaster = _data['userMaster'];

        var bidsHistoryList = _data['history'];

        List<BidHistoryModel> _bidHistoryList = [];
        bidsHistoryList.forEach((element) {
          BidHistoryModel _bidHistoryModel = BidHistoryModel(
            discountedDate: DateTime.parse(element['prop_datetime']),
            invoiceNumber: element['inv_no'].toString(),
            paymentStatus: element['payment_status'].toString(),
            discount_status: element['discount_status'].toString(),
            discountVal: element['prop_amt'].toString(),
            companyPan: element['company_pan'].toString(),
            investor_pan: element['inv_pan'].toString(),
            cust_pan: element['cust_pan'].toString(),
            companyName: element['reqName'].toString(),
            effectiveDueDate: element['edd'].toString(),
            transactionsStatus: element['transactionStatus'].toString(),
            address: '',
            customerName: element['buyName'],
            investorName: '',
            startDate: element['invoice_date'].toString(),
            endDate: element['invoice_due_date'].toString(),
            tenure: "",
            email: "",
            historyStatus: element['prop_stat'].toString(),
            invoiceValue: element['invoice_value'].toString(),
            fileName: '',
            netReturn: '',
            askRate: element['ask_rate'].toStringAsFixed(2),
            platFormFee: '',
            currency: element['currency']!=null?element['currency']:'NA',
          );

          _bidHistoryList.add(_bidHistoryModel);
        });
        if (date != null && date2 != null) {
          _bidHistoryList = _bidHistoryList.where((element) {
            var isDate = false;
            if (date != null && date2 != null) {
              DateTime createdOn = element.discountedDate;
              if (date.isBefore(createdOn) && date2.isAfter(createdOn)) {
                isDate = true;
              }
            }

            return isDate;

            return true;
          }).toList();
        }
        _bidHistoryList = _bidHistoryList.where((element) {
          var isCurrency = false;
          if(currency!='All'){
            if(currency == element.currency){
              isCurrency = true;
            }
          }else{
            isCurrency = true;
          }

          return isCurrency;

          return true;
        }).toList();
        _bidHistoryDataList.addAll(_bidHistoryList);
        notifyListeners();
      }
      return data;
    }

    return null;
  }
}