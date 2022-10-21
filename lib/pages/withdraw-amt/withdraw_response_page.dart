import 'dart:async';
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WithdrawResponse extends StatefulWidget {
  dynamic response;
  WithdrawResponse({Key key, this.response}) : super(key: key);

  @override
  State<WithdrawResponse> createState() => _WithdrawResponseState();
}

class _WithdrawResponseState extends State<WithdrawResponse> {
  ProfileProvider profileProvider;

  var response;
  bool responseReceived = false;

  void waitForRequest(){
    Timer.periodic(Duration(seconds: 5), (timer) {
      responseReceived = profileProvider.withdrawResponseReceived == false?true:profileProvider.withdrawResponseReceived;
      var response1 = {
        'res': 'failed',
        'messg':
        'Failed to receive update from bank server. Check account for transaction status!'
      };
      http.Response(jsonEncode(response1),
          408); // Re
      setState(() {
        response = profileProvider.withdrawResponseReceived == false? http.Response(jsonEncode(response1),400): profileProvider.withdrawResponse;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    waitForRequest();
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    response = widget.response == null
        ? profileProvider.withdrawResponse
        : widget.response;
    responseReceived = widget.response == null
        ? profileProvider.withdrawResponseReceived
        : true;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ProfileProvider(),
            child: WithdrawResponse()),
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
                      ? Responsive.isMobile(context)?Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      response['res'] == 'success'
                          ? Icon(
                        Icons.check,
                        color: Colors.green,
                        size: Responsive.isMobile(context)?28:34,
                      )
                          : Icon(
                        Icons.error,
                        color: Colors.red,
                        size: Responsive.isMobile(context)?28:34,
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
                                fontSize: Responsive.isMobile(context)?14:22, fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ):Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      response['res'] == 'success'
                          ? Icon(
                        Icons.check,
                        color: Colors.green,
                        size: Responsive.isMobile(context)?24:34,
                      )
                          : Icon(
                        Icons.error,
                        color: Colors.red,
                        size: Responsive.isMobile(context)?24:34,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        height: 60,
                        child: Text(
                          response['messg'],
                          style: GoogleFonts.poppins(
                              fontSize: Responsive.isMobile(context)?14:22, fontWeight: FontWeight.w500),
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
                      profileProvider.resetWithdrawData();
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (context) => ChangeNotifierProvider(
                      //         create: (context) => ProfileProvider(),
                      //         child: CapsaHome()),
                      //   ),
                      // );
                      Beamer.of(context).beamToReplacementNamed('/home');
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
                                    ? MediaQuery.of(context).size.width * 0.8
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
                                            fontSize: Responsive.isMobile(context)?14:18,
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
                              fontSize: Responsive.isMobile(context) ? 16 : 24),
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
