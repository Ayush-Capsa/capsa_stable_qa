import 'package:capsa/common/constants.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:universal_html/html.dart' as html;

Future callApi(url, {body, method: 'POST', header: false}) async {
  //capsaPrint('Pass 2.1 check password reset');
  if (body == null) {
    body = {};
    body['n'] = 'true';
  }
  String _url = apiUrl;
  dynamic _uri = _url + url;
  _uri = Uri.parse(_uri);
  //capsaPrint(_uri);
  //capsaPrint('Pass 2.1 check password reset $_uri');
  try {
    //print('reponse : $_uri ');
    //capsaPrint('Pass 2.2 check password reset ');
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: body).timeout(
      const Duration(seconds: 90),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        var response1 = {
          'res': 'failed',
          'messg':
          'Connection Timed Out'
        };
        return http.Response(jsonEncode(response1),
            408); // Request Timeout response status code
      },
    );
    //capsaPrint('Pass 2.3 check password reset ${response.body}');
    //print('reponse : $_uri ${response.body}');
    var data = jsonDecode(response.body);
    //capsaPrint('Pass 2.4 check password reset $data');
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
    }).timeout(
      const Duration(seconds: 90),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        var response1 = {
          'res': 'failed',
          'messg':
          'Connection Timed Out'
        };
        return http.Response(jsonEncode(response1),
            408); // Request Timeout response status code
      },
    );
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
        body: body).timeout(
      const Duration(seconds: 90),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        var response1 = {
          'res': 'failed',
          'messg':
          'Connection Timed Out'
        };
        return http.Response(jsonEncode(response1),
            408); // Request Timeout response status code
      },
    );
    //capsaPrint('Response ${response.body}');
    var data = jsonDecode(response.body);


    return data;
  } catch (e) {
    capsaPrint("error: $e");
    var data = {'res': 'failed', 'messg': 'Unable to proceed..Try again!'};
    return data;
  }
}


// import 'package:capsa/common/constants.dart';
// import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:hive/hive.dart';
// import 'package:universal_html/html.dart' as html;
//
// Future callApi(url, {body, method: 'POST', header: false}) async {
//   if (body == null) {
//     body = {};
//     body['n'] = 'true';
//   }
//   String _url = apiUrl;
//   dynamic _uri = _url + url;
//   _uri = Uri.parse(_uri);
//   try {
//     capsaPrint('\n\n$_uri $body');
//     var response = await http.post(_uri,
//         headers: <String, String>{
//           'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
//         },
//         body: body).timeout(
//       const Duration(seconds: 90),
//       onTimeout: () {
//         // Time has run out, do what you wanted to do.
//         var response1 = {
//           'res': 'failed',
//           'messg':
//           'Connection Timed Out'
//         };
//         return http.Response(jsonEncode(response1),
//             408); // Request Timeout response status code
//       },
//     );
//     print('reponse : $_uri ${response.body}');
//     //capsaPrint('\nfetched url pass 1 ${response.body}\n');
//     var data = jsonDecode(response.body);
//     return data;
//   } catch (e) {
//     capsaPrint(e);
//     var data = {'res': 'failed', 'messg': 'Unable to proceed..Try again!'};
//     return data;
//   }
// }
//
// Future callApi2(url, {body, method: 'GET', header: false}) async {
//   if (body == null) {
//     body = {};
//     body['n'] = 'true';
//   }
//   String _url = apiUrl;
//   dynamic _uri = _url + url;
//   _uri = Uri.parse(_uri);
//   try {
//     var response = await http.get(_uri, headers: <String, String>{
//       'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
//     }).timeout(
//       const Duration(seconds: 90),
//       onTimeout: () {
//         // Time has run out, do what you wanted to do.
//         var response1 = {
//           'res': 'failed',
//           'messg':
//           'Connection Timed Out'
//         };
//         return http.Response(jsonEncode(response1),
//             408); // Request Timeout response status code
//       },
//     );
//     var data = jsonDecode(response.body);
//     return data;
//   } catch (e) {
//     capsaPrint(e);
//     var data = {'res': 'failed', 'messg': 'Unable to proceed..Try again!'};
//     return data;
//   }
// }
//
// Future callApi3(url, {body, method: 'POST', header: false}) async {
//   if (body == null) {
//     body = {};
//     //body['n'] = 'true';
//   }
//   String _url = apiUrl;
//   dynamic _uri = _url + url;
//   _uri = Uri.parse(_uri,);
//   try {
//     var response = await http.post(_uri,
//         headers: <String, String>{
//           'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
//         },
//         body: body).timeout(
//       const Duration(seconds: 90),
//       onTimeout: () {
//         // Time has run out, do what you wanted to do.
//         var response1 = {
//           'res': 'failed',
//           'messg':
//           'Connection Timed Out'
//         };
//         return http.Response(jsonEncode(response1),
//             408); // Request Timeout response status code
//       },
//     );
//     //capsaPrint('Response ${response.body}');
//     var data = jsonDecode(response.body);
//
//
//     return data;
//   } catch (e) {
//     capsaPrint("error: $e");
//     var data = {'res': 'failed', 'messg': 'Unable to proceed..Try again!'};
//     return data;
//   }
// }