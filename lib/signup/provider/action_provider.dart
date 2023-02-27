import 'dart:convert';

import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
// import 'package:capsa/signup/providers/verification_provider.dart';
// import 'package:capsa/signup/screens/mobile/m_activate_acct_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:universal_html/html.dart' as html;

class SignUpActionProvider extends ChangeNotifier {
  String _url = apiUrl;

  Map<String, dynamic> loginUser;

  List<dynamic> _anchorsNameList = [];

  Map<String, dynamic> _cinList = {};

  dynamic _fewDataResponse;

  dynamic _accountResponse;

  bool _accountResponseBool = false;

  dynamic get fewDataResponse => _fewDataResponse;

  List<dynamic> get anchorsNameList => _anchorsNameList;

  Map<String, dynamic> get cinList => _cinList;

  bool get accountResponseBool => _accountResponseBool;

  dynamic get accountResponse => _accountResponse;

  void setUser(user) {
    loginUser = user;
    notifyListeners();
  }

  Future saveDetails1(body, PlatformFile file1, PlatformFile file2) async {
    var _body = body;

    dynamic _uri = apiUrl + 'signup/savedetails1';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');
    if (file1 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file1.bytes,
        filename: _body['bvnNo'] +
            '_kyc1' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file1.extension,
        contentType: MediaType('multipart', 'form-data'),
      ));

    if (file2 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file2.bytes,
        filename: _body['bvnNo'] +
            '_kyc2' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file2.extension,
        contentType: MediaType('multipart', 'form-data'),
      ));

    var res = await request.send();
    // capsaPrint(res.reasonPhrase);
    return jsonDecode((await http.Response.fromStream(res)).body);
  }

  Future saveDetails2(body, PlatformFile file1) async {
    var _body = body;

    dynamic _uri = apiUrl + 'signup/savedetails2';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');
    if (file1 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file1.bytes,
        filename: _body['bvnNo'] +
            '_kyc3' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file1.extension,
        contentType: MediaType('multipart', 'form-data'),
      ));

    var res = await request.send();
    // capsaPrint(res.reasonPhrase);
    return jsonDecode((await http.Response.fromStream(res)).body);
  }

  Future saveDetails3(body, PlatformFile file1) async {
    var _body = body;

    dynamic _uri = apiUrl + 'signup/saveDetails3';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');

    capsaPrint('save details pass 1');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });

    capsaPrint('save details pass 2');

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');
    if (file1 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file1.bytes,
        filename: _body['bvnNo'] +
            '_kyc1' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file1.extension,
        contentType: MediaType('multipart', 'form-data'),
      ));
    capsaPrint('save details pass 3');

    var res = await request.send();
    capsaPrint('save details pass 4');
    // capsaPrint(res.reasonPhrase);
    return jsonDecode((await http.Response.fromStream(res)).body);
  }

  Future<Object> reUploadDocument(
      body, PlatformFile file1, PlatformFile file2, PlatformFile file3) async {
    var _body = body;

    capsaPrint('Pass 1');

    dynamic _uri = apiUrl + 'signup/documentsReupload';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');

    capsaPrint('Pass 2');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });

    capsaPrint('Pass 3');

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file1 != null
          ? file1.bytes
          : file2 != null
              ? file2.bytes
              : file3.bytes,
      filename: _body['panNumber'] +
          'cacCertificate' +
          DateTime.now().millisecondsSinceEpoch.toString()
      // +
      // '.' +
      // file1 !=
      // null
      // ? file1.extension
      // : file2 != null
      // ? file2.extension
      // : file3.extension
      ,
      contentType: MediaType('multipart', 'form-data'),
    ));

    capsaPrint('Pass 4');

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file2 != null
          ? file2.bytes
          : file1 != null
              ? file1.bytes
              : file3.bytes,
      filename: _body['panNumber'] +
          'cacForm' +
          DateTime.now().millisecondsSinceEpoch.toString(),
      contentType: MediaType('multipart', 'form-data'),
    ));

    capsaPrint('Pass 5');

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file3 != null
          ? file3.bytes
          : file2 != null
              ? file2.bytes
              : file1.bytes,
      filename: _body['panNumber'] +
          'validId' +
          DateTime.now().millisecondsSinceEpoch.toString(),
      contentType: MediaType('multipart', 'form-data'),
    ));

    capsaPrint('Pass 6');

    var res = await request.send();
    // capsaPrint(res.reasonPhrase);
    capsaPrint('Pass 7');
    return jsonDecode((await http.Response.fromStream(res)).body);
  }

  Future signIn(_body) async {
    var data = '';
    try {
      capsaPrint('sign in pass 1');
      var response = await http.get(Uri.parse("https://ipwhois.app/json/"));
      capsaPrint('sign in pass 2');
      capsaPrint(response);
      data = response.body;
    } catch (e) {
      capsaPrint(e);
    }
    _body['location'] = data;
    var response = await callApi('signin/submit', body: _body);
    capsaPrint('Sign in Data: $response');
    return response;
    // dynamic _uri = _url + 'signin/submit';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future checkData(_body) async {
    return await callApi('signup/checkData', body: _body);
    // dynamic _uri = _url + 'signup/checkData';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future submitData(_body) async {
    return await callApi('signup/submitData', body: _body);
    // dynamic _uri = _url + 'signup/submitData';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future setPasswordCall(Object _body) async {
    return await callApi('signup/setPassword', body: _body);
    // dynamic _uri = _url + 'signup/setPassword';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future forgetPassword(Object _body) async {
    return await callApi('signin/forgetPassword', body: _body);
    // dynamic _uri = _url + 'signin/forgetPassword';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future forgetPassword2(Map<String, dynamic> _body) async {
    return await callApi2('signin/forgot-password/' + _body['token']);
    // dynamic _uri = _url + 'signin/forgetPassword';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future setResetPasswordCall(Object _body) async {
    return await callApi('signin/resetPassword', body: _body);
    // dynamic _uri = _url + 'signin/resetPassword';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future verifyAccountBVN(Object _body) async {
    return await callApi('signup/verifyAccountBVN', body: _body);
    // dynamic _uri = _url + 'signup/verifyAccountBVN';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future sendOtp(Object _body) async {
    return await callApi('signup/sendOTP', body: _body);
  }

  Future verifyEmailOTP(Object _body) async {
    capsaPrint('Otp body : $_body');
    return await callApi('signup/verifyOtp', body: _body);
  }

  Future getDirectorByRc(Object _body) async {
    return await callApi('signup/get_directorByRc', body: _body);
  }

  Future getBank() async {
    return await callApi('signin/getBankList');
    // dynamic _uri = _url + 'signin/getBankList';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: {});
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future verifyOtp(Object _body) async {
    return await callApi('signup/verifyOtp', body: _body);
    // dynamic _uri = _url + 'signup/verifyOtp';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future setActiveUser(Object _body) async {
    return await callApi('signup/setActiveUser', body: _body);
  }

  void setUserVariable(user) {
    loginUser.addAll(user);
    notifyListeners();
  }

  void setPassword(widget, context, passCont, passCont2,
      RoundedLoadingButtonController btnCont,
      {mobile: false, isReset: false}) async {
    Map<String, dynamic> _body = {};

    _body['pan'] = loginUser['panNumber'];
    _body['pas'] = passCont.text;
    _body['cPas'] = passCont2.text;
    if (!isReset) _body['role'] = loginUser['role'];
    // _body['email'] = actionProvider.loginUser['email'];
    // capsaPrint(isReset);

    var _data = await setPasswordCall(_body);
    // capsaPrint(_data);
    if (_data['res'] == 'success') {
      Box box = Hive.box('capsaBox');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Successfully saved.'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );

      // verificationDataProvider
      // if (verificationDataProvider != null) {
      //   verificationDataProvider.setUserPassword(passCont.text);
      // }

      // verificationDataProvider.setPass(passCont.text);
      if (_data['data']['cCOde'] == null || _data['data']['cCOde'] == '') {
        _data['data']['cCOde'] = '234';
      }
      setUserVariable(_data['data']);
      box.put('loginUserData', loginUser);
      setUser(loginUser);
      if (mobile) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MActivateAccountForm(),
        //   ),
        // );
      } else {
        btnCont.reset();
        return widget.onPressed();
      }
    } else {
      btnCont.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_data['messg']),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
  }

  Future createAccount(String role) async {
    capsaPrint('createAccount Call');

    Box box = Hive.box('capsaBox');

    var signUpData = box.get('signUpData');

    if (signUpData['al_upload'].toString() == '1') {
      _accountResponseBool = true;
      notifyListeners();
      return;
    }

    // capsaPrint(loginUserData);

    var _body = {};

    _body['panNumber'] = signUpData['panNumber'];
    _body['role'] = signUpData['role'];
    _body['contact'] = signUpData['phoneNo'];
    _body['name'] = signUpData['userName'];
    _body['email'] = signUpData['email'];

    // capsaPrint(_body);

    dynamic _uri;

    if (role == 'COMPANY') {
      _uri = _url + 'signup/racccreate';
    } else {
      _uri = _url + 'signup/lacccreate';
    }

    _uri = Uri.parse(_uri);

    try {
      var response = await http.post(_uri, body: _body);
      // capsaPrint(response);
      var data = jsonDecode(response.body);
      // return null;
      _accountResponseBool = true;
      _accountResponse = data;
      await Future.delayed(Duration(seconds: 1));
      notifyListeners();
      return data;
    } catch (e) {
      capsaPrint(e);
      _accountResponseBool = true;
      await Future.delayed(Duration(seconds: 1));
      notifyListeners();
      return null;
    }

    return null;
  }

  Future getAccount(String role) async {
    capsaPrint('getAccount Call');

    Box box = Hive.box('capsaBox');

    var signUpData = box.get('signUpData');

    if (signUpData['al_upload'].toString() == '1') {
      _accountResponseBool = true;
      notifyListeners();
      return;
    }

    // capsaPrint(loginUserData);

    var _body = {};

    _body['panNumber'] = signUpData['panNumber'];
    _body['role'] = signUpData['role'];
    _body['contact'] = signUpData['phoneNo'];
    _body['name'] = signUpData['userName'];
    _body['email'] = signUpData['email'];

    // capsaPrint(_body);

    dynamic _uri;

    if (role == 'COMPANY') {
      _uri = _url + 'signup/getAccountNumber';
    } else {
      _uri = _url + 'signup/getAccountNumber';
    }

    _uri = Uri.parse(_uri);

    try {
      var response = await http.post(_uri, body: _body);

      var data = jsonDecode(response.body);

      return data;
    } catch (e) {
      capsaPrint(e);

      return null;
    }

    return null;
  }

  Future updateDigitalSign(Object _body) async {
    return await callApi('signup/updateDigitalSign', body: _body);
    // dynamic _uri = _url + 'signup/updateDigitalSign';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future updateAddress(Object _body) async {
    return await callApi('signup/updateAddress', body: _body);
  }

  Future setActive(Map<dynamic, dynamic> _body, PlatformFile file) async {
    if (file == null) return null;

    dynamic _uri = _url + 'signup/setActive';
    _uri = Uri.parse(_uri);

    capsaPrint('setActive Call!!!!');

    // _body['accountLetter'] =  filename1.bytes.toString();

    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // capsaPrint(file.extension);
    var extension = file.extension;
    // return data;

    var request = http.MultipartRequest('POST', _uri);

    // capsaPrint('_body');
    // capsaPrint(_body);

    _body.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.fields['web'] = kIsWeb.toString();

    // if (kIsWeb) {
    //   capsaPrint('web');
    // request.fields['account_letter'] = filename1.bytes.toString();
    request.files.add(http.MultipartFile.fromBytes(
      'account_letter',
      file.bytes,
      filename: _body['bvn'] + '_accLetter.' + extension,
      contentType: MediaType('application', 'octet-stream'),
    ));
    // } else {
    //   capsaPrint('mob');
    //   request.files.add(await http.MultipartFile.fromPath(
    //     'account_letter',
    //     file.path,
    //     filename: _body['panNumber'] + '.' + file.extension,
    //     contentType: MediaType('application', 'octet-stream'),
    //   ));
    // }

    // return null;

    var res = await request.send();
    // capsaPrint(res.reasonPhrase);
    return res.reasonPhrase;

    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // capsaPrint(data);
    // return data;
  }

  Future downloadLetter() async {
    dynamic _uri = _url + 'signin/accountletterdownload';
    _uri = Uri.parse(_uri);
    var _body = {};
    Box box = Hive.box('capsaBox');

    var signUpData = box.get('signUpData');
    _body['panNumber'] = signUpData['panNumber'];
    _body['role'] = signUpData['role'];

    var response = await http.post(_uri, body: _body);
    // var response = await callApi('signin/accountletterdownload', body: _body);
    // capsaPrint(response);

    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes], "application/octet-stream");
      final url = html.Url.createObjectUrlFromBlob(blob);

      // final anchor = html.document.createElement('a') as html.AnchorElement
      //   ..href = url
      //   ..style.display = 'none'
      //   ..download = 'Account Letter.pdf';
      // html.document.body.children.add(anchor);
      //
      // anchor.click();
      //
      // html.document.body.children.remove(anchor);
      // html.Url.revokeObjectUrl(url);

      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = 'Account Letter.docx';
      anchorElement.click();
      html.Url.revokeObjectUrl(url);
    }

    return null;
  }

  Future<Object> queryFewData() async {
    //capsaPrint('few data called $currency');
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    var _body = {};
    _body['panNumber'] = userData['panNumber'];
    // _body['panNumber'] = userData['panNumber'];
    _body['userName'] = userData['userName'];
    //capsaPrint('Body : $_body');
    //_body['currency'] = currency;
    dynamic _uri;

    var _role = userData['role'];
    if (_role == 'INVESTOR')
      _uri = apiUrl + 'dashboard/i/fewacc';
    else
      _uri = apiUrl + 'dashboard/r/fewacc';

    _uri = Uri.parse(_uri);
    //capsaPrint('Uri : ${_uri} \n Authorization: ${'Basic ' + box.get('token', defaultValue: '0')}\nbody: $_body');
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
   //capsaPrint('Few Data $data');
    // if (data['res'] == 'success') {
    //   var _data = data['data'];
    //   // capsaPrint('_data');
    //   // capsaPrint(_data);
    //
    //   List<BankDetails> _bankDetails = [];
    //
    //   var tmpBankDetails = _data['bankDetails'];
    //
    //   _data['toBal'] = _data['toBal'].toStringAsFixed(2);
    //
    //   _totalBalance = double.parse(_data['toBal']);
    //
    //   try {
    //     _totalBalanceToWithDraw =
    //         double.parse(_data['toWithdrawBal'].toString());
    //   } catch (e) {}
    //   _totalDeposits = _data['totDeposit'];
    //   _totalWithdraw = _data['totwithdrawl'];
    //
    //   // capsaPrint(_data);
    //   // capsaPrint('_totalBalance');
    //   // capsaPrint(_totalBalance);
    //
    //   tmpBankDetails.forEach((element) {
    //     BankDetails _tmpBankDetails = BankDetails(
    //       PAN_NO: element['PAN_NO'],
    //       bank_name: element['bank_name'],
    //       IBTC: element['IBTC'].toString(),
    //       ifsc: element['ifsc'].toString(),
    //       account_number: element['account_number'].toString(),
    //       bene_account_no: element['bene_account_no'].toString(),
    //       bene_ifsc: element['bene_ifsc'],
    //       bene_bank: element['bene_bank'],
    //       bene_account_holdername: element['bene_account_holdername'],
    //       bene_bvn: element['bene_bvn'],
    //       trf_typ_ft: element['trf_typ_ft'].toString(),
    //       pan_copy: element['pan_copy'],
    //       chq_copy: element['chq_copy'],
    //     );
    //     _bankDetails.add(_tmpBankDetails);
    //   });
    //
    //   bankDetails.addAll(_bankDetails);
    //
    //   var tmpUser = _data['user'];
    //   tmpUser.forEach((element) {
    //     UserData _user = UserData(
    //       element['ADD_LINE'],
    //       element['CITY'],
    //       element['COUNTRY'],
    //       element['STATE'],
    //       element['cc'],
    //       element['contact'],
    //       element['email'],
    //       element['nm'],
    //     );
    //     _userDetails.add(_user);
    //   });
    //
    //   notifyListeners();
    // }
    _fewDataResponse = data;
    return data;
  }

  Future getCompanyName() async {
    dynamic _uri = _url + 'dashboard/r/' + 'getCompanyName';
    _uri = Uri.parse(_uri);
    capsaPrint('company name pass 1');
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    _body['panNumber'] = userData['panNumber'];
    var response = await http.post(_uri, headers: <String, String>{
      'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
    }, body: _body);
    capsaPrint('company name pass 2');
    capsaPrint(response.body);
    var data = jsonDecode(response.body);

    if (data['res'] == 'success') {
      for (int i = 0; i < data['data'].length; i++) {
        _anchorsNameList.add(data['data'][i]['name']);
        _cinList[data['data'][i]['name']] = data['data'][i]['cu_pan'];
      }
    }

    return data;
  }

  Future getAnchorsList() async {
    dynamic _uri = _url + 'signup/getAllAnchors';
    _uri = Uri.parse(_uri);
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    _body['panNumber'] = userData['panNumber'];
    capsaPrint('company name pass 1 anchors list');
    var response = await http.post(_uri, headers: <String, String>{
      'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
    }, body: _body);
    capsaPrint('company name pass 2');
    capsaPrint(response.body);
    var data = jsonDecode(response.body);

    if (data['res'] == 'success') {
      for (int i = 0; i < data['data'].length; i++) {
        _anchorsNameList.add(data['data'][i]['name']);
        _cinList[data['data'][i]['name']] = data['data'][i]['cu_pan'];
      }
    }

    return data;
  }

  Future<Object> saveAnchorList(List<dynamic> cuGst) async {
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    dynamic _uri;
    var _role = userData['role'];

    _uri = apiUrl + 'signup/saveAnchors';

    String anchorPan = '';
    for(int i = 0;i<cuGst.length;i++){
      if(i == 0){
        anchorPan += cuGst[i];
      }else{
        anchorPan += ' ' + cuGst[i];
      }
    }

    _uri = Uri.parse(_uri);
    _body['vendorPan'] = userData['panNumber'];
    _body['anchorPan'] = anchorPan;

    _body['bvnNo'] = userData['panNumber'];
    _body['bvn'] = userData['panNumber'];
    var response = await http.post(_uri, headers: <String, String>{
      'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
    }, body: _body);
    capsaPrint('save anchor $_uri $_body');
    capsaPrint(response.body);
    var data = jsonDecode(response.body);
    return data;

    return null;
  }

  Future<Object> uploadAccountLetterFile(dynamic body, PlatformFile file1) async {
    var _body = body;
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    dynamic _uri;
    var _role = userData['role'];

    _uri = apiUrl + 'signup/setActive';

    _uri = Uri.parse(_uri);
    _body['vendorPan'] = userData['panNumber'];
    // _body['bvnNo'] = userData['panNumber'];
    // _body['bvn'] = userData['panNumber'];
    //
    // _body['userName'] = userData['userName'];
    // _body['role'] = userData['role'];
    capsaPrint('Url: $_uri\n BODY : $_body');
    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    var extension = file1.extension;
    if (file1 != null) {
      capsaPrint('Uploading file');
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file1.bytes,
        filename: _body['vendorPan'] + '_accLetter.' + extension,
        contentType: MediaType('multipart', 'form-data'),
      ));
    }

    var res = await request.send();
    return jsonDecode((await http.Response.fromStream(res)).body);

    return null;
  }

}
