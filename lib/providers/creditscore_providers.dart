import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/auth_provider.dart';
// import 'package:capsa/vendor/models/invoice_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class CreditScoreProvider extends ChangeNotifier {
  final box = Hive.box('capsaBox');

  String _bankName = '';
  String _lastUpdate = '';
  String _bankID = '';
  String _accountNo = '';
  String _accountName = '';
  String _isLinked = 'No';
  bool _loading = false;
  bool _startLoaded = false;
  bool _exits = false;
  bool _creditExits = false;
  String _openUrl = '';
  dynamic _creditData;

  String get bankName => _bankName;

  bool get startLoaded => _startLoaded;

  String get lastUpdate => _lastUpdate;

  String get bankID => _bankID;

  String get accountNo => _accountNo;

  String get isLinked => _isLinked;

  String get accountName => _accountName;

  bool get loading => _loading;

  bool get exits => _exits;

  bool get creditExits => _creditExits;

  dynamic get creditData => _creditData;

  void setIsLinked(value) {
    _isLinked = value;
    notifyListeners();
  }

  void setAccountName(value) {
    _accountName = value;
    notifyListeners();
  }

  void setAccountNo(value) {
    _accountNo = value;
    notifyListeners();
  }

  void setBankID(value) {
    _bankID = value;
    notifyListeners();
  }

  void setBankName(value) {
    _bankName = value;
    notifyListeners();
  }

  void setExits(value) {
    _exits = value;
    notifyListeners();
  }

  void setLoading(value) {
    _loading = value;
    notifyListeners();
  }

  void setCreditExits(value) {
    _creditExits = value;
    notifyListeners();
  }

  Future getAccountLinked({getByPan}) async {
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('userData'));
    if (getByPan == null)
      _body['panNumber'] = userData['panNumber'];
    else
      _body['panNumber'] = getByPan;

    _body['role'] = userData['role'];

    dynamic _uri = apiUrl + 'okra/islinked';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var _data = jsonDecode(response.body);


    _bankName = "";
    _accountNo = "";
    _bankID = "";
    _accountName = "";
    _isLinked = "No";
    _exits = false;

    try {
      if (_data['res'] == 'success') {
        if (_data['data']['exits'] == 'yes') {
          _exits = true;
          _bankName = _data['data']['data']['bankName'];
          _bankID = _data['data']['data']['bankId'];
          _accountNo = _data['data']['data']['account_number'];
          _accountName = _data['data']['data']['name'];
          _isLinked = _data['data']['data']['isLinked'];
          _openUrl = _data['data']['url'];

        }
      }


    } catch (e) {
      capsaPrint(e);
    }
    _startLoaded = true;
    notifyListeners();
    return _data;
  }

  Future addLinkAccount(context) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['bankName'] = bankName;
      _body['bankID'] = bankID;
      _body['accName'] = accountName;
      _body['accNum'] = accountNo;

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];

      dynamic _uri;
      _uri = apiUrl + 'okra/addAccount';
      _uri = Uri.parse(_uri);
      var response2 = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      var response = jsonDecode(response2.body);

      if (response['res'] == "success") {
        showToast(response['messg'], context);
        var url = response['data']['url'];
        _loading = false;
        _exits = true;

        html.window.open(url, 'Okra Bank Link');
      } else {
        showToast(response['messg'], context);
      }
      notifyListeners();

      return response;
    }
    return null;
  }


  openLinkAccount(context){


    html.window.open(_openUrl, 'Okra Bank Link');


  }

  Future checkCreditScore(context,{getByPan}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['bankName'] = _bankName;
      // _body['bankID'] = bankID;
      _body['accName'] = _accountName;
      _body['accNum'] = _accountNo;
      _body['accountNo'] = _accountNo;

      _body['role'] = userData['role'];

      if(getByPan == null){
        _body['bvn'] = userData['panNumber'];
        // _body['panNumber'] = userData['panNumber'];

      }else{
        _body['bvn'] = getByPan;
        _body['panNumber'] = userData['panNumber'];
      //
      }

      dynamic _uri;
      _uri = apiUrl + 'okra/calculateScore';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
      dynamic data = jsonDecode(response.body);

      if (data['res'] == "success") {
        // showToast("Successfully Received", context);

        _loading = false;
        _creditExits = true;
        _creditData = data['data'];
        _lastUpdate = _creditData['last_update'];
      } else {
        showToast(data['messg'], context);
      }

      notifyListeners();

      return data;
    }
    return null;
  }
}
