import 'package:capsa/common/constants.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:universal_html/html.dart' as html;

Future callApi(url, {body, method: 'POST', header: false}) async {
  if (body == null) {
    body = {};
    body['n'] = 'true';
  }
  String _url = apiUrl;
  dynamic _uri = _url + url;
  _uri = Uri.parse(_uri);
  try {
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: body);
    print('reponse : $_uri ${response.body}');
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {
    capsaPrint(e);
    var data = {'res': 'failed', 'messg': 'Unable to proceed..Try again!'};
    return data;
  }
}

Future callApi2(url, {body, method: 'GET', header: false}) async {
  if (body == null) {
    body = {};
    body['n'] = 'true';
  }
  String _url = apiUrl;
  dynamic _uri = _url + url;
  _uri = Uri.parse(_uri);
  try {
    var response = await http.get(_uri, headers: <String, String>{
      'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
    });
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {
    capsaPrint(e);
    var data = {'res': 'failed', 'messg': 'Unable to proceed..Try again!'};
    return data;
  }
}

Future callApi3(url, {body, method: 'POST', header: false}) async {
  if (body == null) {
    body = {};
    //body['n'] = 'true';
  }
  String _url = apiUrl;
  dynamic _uri = _url + url;
  _uri = Uri.parse(_uri,);
  try {
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: body);
    capsaPrint('Response ${response.body}');
    var data = jsonDecode(response.body);


    return data;
  } catch (e) {
    capsaPrint("error: $e");
    var data = {'res': 'failed', 'messg': 'Unable to proceed..Try again!'};
    return data;
  }
}