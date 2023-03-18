import 'package:capsa/providers/auth_provider.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:beamer/beamer.dart';
import 'package:hive/hive.dart';
import 'package:capsa/signup/extensions/encrypt.js.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

loginToRole(context, var _rawData) {

  Future.delayed(const Duration(milliseconds: 800), () {
    //html.window.location.reload();
  });

  if (_rawData['role'] == 'ADMIN') {
    Beamer.of(context).beamToNamed('/');

    //html.window.location.reload();
  } else if (_rawData['role'] == 'BUYER') {
    Beamer.of(context).beamToNamed('/');
  } else if (_rawData['role'] == 'INVESTOR') {
    Beamer.of(context).beamToNamed('/');
  } else if (_rawData['role'] == 'COMPANY') {
    Beamer.of(context).beamToNamed('/');
  }
  else{
    context.beamToNamed('/');
  }
  //context.beamToNamed('/');
  if(!kDebugMode){
    Future.delayed(const Duration(milliseconds: 800), () {
      html.window.location.reload();
    });
  }


  return;
}

active_0kyc_1(context, _rawData, edata, role, alUpload) {
  if (role == 'COMPANY') {
    if (alUpload == 0 || alUpload == 1) {
      final box = Hive.box('capsaBox');
      // box.put('currentStep', 4);

      // Provider.of<ActionProvider>(context, listen: false).setUserVariable(_rawData);
      box.put('loginUserData', _rawData);
      Provider.of<SignUpActionProvider>(context, listen: false)
          .setUser(_rawData);

      Beamer.of(context).beamToNamed('/activate?token=' + edata);
    } else {
      Beamer.of(context).beamToNamed('/unactivated');
    }
  } else if (role == 'INVESTOR') {
    Beamer.of(context).beamToNamed('/unactivated');
  }
}

active_1kyc_1(
    context, _rawData, edata, role, alUpload, AuthProvider authProvider) {
  // capsaPrint('active_1kyc_1');
  final box = Hive.box('capsaBox');
  // capsaPrint('alUpload');

  // capsaPrint(alUpload);

  if (role == 'COMPANY') {
    // if (alUpload == 0 || alUpload == 1) {KYC_STATUS
    //   box.put('currentStep', 4);
    //   box.put('loginUserData', _rawData);
    //   Provider.of<SignUpActionProvider>(context, listen: false).setUser(_rawData);
    //   Beamer.of(context).beamToNamed('/activate?token=' + edata);
    // } else if (alUpload == 2) {
    authProvider.authChange(true, _rawData['role']);
    authProvider.setUserdata(_rawData);
    box.put('userData', _rawData);
    box.put('isAuthenticated', true);
    loginToRole(context, _rawData);
    // } else {
    //   Beamer.of(context).beamToNamed('/unactivated');
    // }
  } else {
    authProvider.authChange(true, _rawData['role']);
    authProvider.setUserdata(_rawData);
    box.put('userData', _rawData);
    box.put('isAuthenticated', true);
    loginToRole(context, _rawData);
  }
}

afterSuccess(context, response, AuthProvider authProvider, myController0) {
  var _data = response['data']['data'];
  var _token = response['data']['token'];
  // capsaPrint('_token');
  // capsaPrint(_token);
  final box = Hive.box('capsaBox');

  box.put('token', _token);
  DateTime now = new DateTime.now();
  DateTime _j = now.add(new Duration(hours: 3));
  box.put('loginTime', _j);

  var _active = response['data']['active'];
  var _rawData = convertStringToJSON(
      decryptAESCryptoJS(convertJWTtoJSONForAES(_data), myController0.text));

  var active = _rawData['active'];
  var kyc = _rawData['kyc'];

  // capsaPrint(kyc);
  var role = _rawData['role'];
  var alUpload = _rawData['al_upload'];

  // capsaPrint('active' + active.toString() );
  // capsaPrint('kyc' + kyc.toString());
  // capsaPrint('alUpload' + alUpload.toString());
  // capsaPrint('role' + role );

  // box.get('loginUserData');
  box.put('activateToken', _active);
  //box.put('rawData', _rawData);
  // if(role == 'BUYER'){
  //   authProvider.authChange(true);
  //   authProvider.setUserdata(_rawData);
  //   box.put('userData', _rawData);
  //   box.put('isAuthenticated', true);
  //   loginToRole(_rawData);
  //   return;
  // }
  var _body = {};
  _body = _rawData;
  _body['bvnNumber'] = _rawData['panNumber'];
  _body['email'] = _rawData['email'];
  _body['EMAIL_STATUS'] = _rawData['EMAIL_STATUS'];
  _body['CONTACT_STATUS'] = _rawData['CONTACT_STATUS'];
  _body['phoneNo'] = _rawData['contact'] ?? '';
  _body['usercac'] = _rawData['usercac'] ?? '';

  capsaPrint('_rawData');
  capsaPrint(_rawData);

  box.put('tmpUserData', _rawData);

  box.put('signUpData', _body);
  //return Beamer.of(context).beamToNamed('/terms-and-condition');
  //return Beamer.of(context).beamToNamed('/account-letter-upload-success');

  // if(true){
  //   return Beamer.of(context).beamToNamed('/resubmit-document-success-page');
  // }
  if (active == 1 && kyc == 1) {
    // if(role != 'ADMIN' && role != 'INVESTOR' && role!='BUYER'){
    if (role != 'ADMIN' && role != 'BUYER' && role!='INVESTOR') {
      if (alUpload.toString() == '0') {
        return Beamer.of(context).beamToNamed('/account-letter-download');
      }
      if (alUpload.toString() == '1') {
        return Beamer.of(context).beamToNamed('/account-letter-upload-success');
      }
    }

    return active_1kyc_1(
        context, _rawData, _active, role, alUpload, authProvider);
  } else if ((active == null || active == 0) && (kyc == null || kyc == 0)) {
    //

    if (_rawData['isApproved'].toString() == '2') {
      return Beamer.of(context).beamToNamed('/verification-unsuccessful');
      //return Beamer.of(context).beamToNamed('/resubmit-document-success-page');
    }
    if (_rawData['isApproved'].toString() == '0') {
      return Beamer.of(context).beamToNamed('/registration-complete');
    }

    if (_rawData['KYC_DATA_VALID'] == 1) {
      return Beamer.of(context).beamToNamed('/account-generation');
    }

    // return;

    if (_rawData['EMAIL_STATUS'] == 0) {
      return Beamer.of(context).beamToNamed('/email-otp');
    } else if (_rawData['CONTACT_STATUS'] == 0) {
      if (_body['usercac'] == '') {
        if (role == 'COMPANY') {
          return Beamer.of(context).beamToNamed('/home/company/details');
        }

        return Beamer.of(context).beamToNamed('/home/personal/details');
      }

      if (_body['phoneNo'] == '') {
        if (role == 'COMPANY') {
          return Beamer.of(context).beamToNamed('/home/director/information');
        }

        return Beamer.of(context).beamToNamed('/home/personal/information');
      }

      return Beamer.of(context).beamToNamed('/mobile-otp');
    } else {
      return Beamer.of(context).beamToNamed('/terms-and-condition');
    }
  } else if ((active == null || active == 0) && (kyc == 1)) {
    return active_0kyc_1(context, _rawData, _active, role, alUpload);
  } else if ((active == 1) && (kyc == 0 || kyc == null)) {
    // box.put('currentStep', 1);
    //
    // return context.beamToNamed('/activate?token=' + _active);

  }
}
