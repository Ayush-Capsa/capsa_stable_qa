import 'dart:async';
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WithdrawResponse extends StatefulWidget {
  dynamic response;
  dynamic amount;
  dynamic desc;
  dynamic accountNo;
  dynamic orderNumber;
  WithdrawResponse(
      {Key key,
      this.response,
      this.amount,
      this.desc,
      this.accountNo,
      this.orderNumber})
      : super(key: key);

  @override
  State<WithdrawResponse> createState() => _WithdrawResponseState();
}

class _WithdrawResponseState extends State<WithdrawResponse> {
  ProfileProvider profileProvider;

  var response;
  bool responseReceived = false;

  void withDrawAmt(amount, desc, accountNo, orderNumber) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      // _body['userName'] = userData['userName'];
      _body['trf_amt'] = amount;
      if (desc != null) _body['desc'] = desc;
      _body['bene_account_no'] = accountNo;
      _body['order_number'] = orderNumber;


      _body['step'] = 'withdraw';
      dynamic _uri;
      _uri = apiUrl + 'dashboard/r/withDrawAmt';
      _uri = Uri.parse(_uri);

      capsaPrint(_body);

      var url_response = await http
          .post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body)
          .timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          var response1 = {
            'res': 'failed',
            'messg':
            'Failed to receive update from bank server. Check account for transaction status!'
          };
          responseReceived = true;
          return http.Response(jsonEncode(response1),
              408);
          // Request Timeout response status code
        },
      );

      var data = jsonDecode(url_response.body);
      // capsaPrint('Response withdraw : $data');
      // if (data['res'] == 'success') {
      //
      //
      // }

        //print('pass 2.1 $data');
        response = data;
        responseReceived = true;
        //print('pass 2.1');
        setState(() {});


    }
  }

  // void withDrawAmt(amount, desc, accountNo, orderNumber) async {
  //   await Future.delayed(const Duration(seconds: 2), () {
  //     var response1 = {
  //       'res': 'failed',
  //       'messg':
  //           'Failed to receive update from bank server. Check account for transaction status!'
  //     };
  //     response = jsonDecode(http.Response(jsonEncode(response1), 408).body);
  //     responseReceived = true;
  //     setState(() {});
  //   });
  // }

  @override
  void initState() {
    super.initState();
    response = widget.response == null ? null : widget.response;
    responseReceived = widget.response == null ? false : true;
    widget.response == null
        ? withDrawAmt(
            widget.amount, widget.desc, widget.accountNo, widget.orderNumber)
        : null;
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ProfileProvider(), child: WithdrawResponse()),
      ],
      child: Scaffold(
        body: Row(
          children: [
            Container(
              width: Responsive.isMobile(context) ? 0 : 185,
              height: MediaQuery.of(context).size.height * 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0.0),
                ),
                color: Color.fromARGB(255, 15, 15, 15),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  responseReceived
                      ? Responsive.isMobile(context)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                response['res'] == 'success'
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: Responsive.isMobile(context)
                                            ? 28
                                            : 34,
                                      )
                                    : Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: Responsive.isMobile(context)
                                            ? 28
                                            : 34,
                                      ),
                                SizedBox(
                                  width: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 60,
                                    child: Text(
                                      response['messg'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: Responsive.isMobile(context)
                                              ? 14
                                              : 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                response['res'] == 'success'
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: Responsive.isMobile(context)
                                            ? 24
                                            : 34,
                                      )
                                    : Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: Responsive.isMobile(context)
                                            ? 24
                                            : 34,
                                      ),
                                SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  height: 60,
                                  child: Text(
                                    response['messg'],
                                    style: GoogleFonts.poppins(
                                        fontSize: Responsive.isMobile(context)
                                            ? 14
                                            : 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            )
                      : Center(
                          child: Image.asset(
                            'assets/icons/loading.gif',
                            height: Responsive.isMobile(context) ? 60 : 185,
                          ),
                        ),
                  SizedBox(
                    height: 60,
                  ),
                  responseReceived
                      ? InkWell(
                          onTap: () async {
                            //profileProvider.resetWithdrawData();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                    create: (context) => ProfileProvider(),
                                    child: CapsaHome()),
                              ),
                            );
                            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CapsaHome()));
                          },
                          child: Container(
                              width: Responsive.isMobile(context)
                                  ? MediaQuery.of(context).size.width * 0.8
                                  : MediaQuery.of(context).size.width * 0.32,
                              height: 59,
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                        color: Color.fromRGBO(0, 152, 219, 1),
                                      ),
                                      width: Responsive.isMobile(context)
                                          ? MediaQuery.of(context).size.width *
                                              0.8
                                          : MediaQuery.of(context).size.width *
                                              0.32,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Go Home',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      242, 242, 242, 1),
                                                  fontFamily: 'Poppins',
                                                  fontSize: Responsive.isMobile(
                                                          context)
                                                      ? 14
                                                      : 18,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ])),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              child: Text(
                                'Checking payment status. Do not refresh or close the browser!',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        Responsive.isMobile(context) ? 16 : 24),
                              ),
                            )
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
