import 'dart:convert';

import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
// import 'package:capsa/signup/providers/verification_provider.dart';
// import 'package:capsa/signup/screens/mobile/m_activate_acct_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:universal_html/html.dart' as html;

class SignUpActionProvider extends ChangeNotifier {
  String _url = apiUrl;

  Map<String, dynamic> loginUser;

  dynamic _accountResponse;

  bool _accountResponseBool = false;

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
        'ccFile',
        file1.bytes,
        filename: _body['bvnNo'] +
            '_kyc1' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file1.extension,
        contentType: MediaType('application', 'octet-stream'),
      ));

    if (file2 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'f7File',
        file2.bytes,
        filename: _body['bvnNo'] +
            '_kyc2' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file2.extension,
        contentType: MediaType('application', 'octet-stream'),
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
        'idFile',
        file1.bytes,
        filename: _body['bvnNo'] +
            '_kyc3' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file1.extension,
        contentType: MediaType('application', 'octet-stream'),
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

    _body.forEach((key, value) {
      request.fields[key] = value;
    });

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');
    if (file1 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'idFile',
        file1.bytes,
        filename: _body['bvnNo'] +
            '_kyc1' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file1.extension,
        contentType: MediaType('application', 'octet-stream'),
      ));

    var res = await request.send();
    // capsaPrint(res.reasonPhrase);
    return jsonDecode((await http.Response.fromStream(res)).body);
  }

  Future signIn(_body) async {
    var data = '';
    try {
      var response = await http.get(Uri.parse("https://ipwhois.app/json/"));
      // capsaPrint(response);
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
    capsaPrint('Pass 1');

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
      _uri = 'signup/racccreate';
    } else {
      _uri = 'signup/lacccreate';
    }

    //_uri = Uri.parse(_uri);
    capsaPrint('Pass 2 $_uri');
    try {
      // var response = await http.post(_uri, body: _body);
      // capsaPrint(response);
      capsaPrint('Pass 3');
      var data = await callApi(_uri,body: _body);
      capsaPrint('Pass 4');
      capsaPrint('Response : $data');
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

      capsaPrint('getAccountNumber response : $data');

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
}
