import 'package:beamer/src/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/logout.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ResubmitDocumentSuccessPage extends StatefulWidget {
  const ResubmitDocumentSuccessPage({Key key}) : super(key: key);

  @override
  State<ResubmitDocumentSuccessPage> createState() => _ResubmitDocumentSuccessPageState();
}

class _ResubmitDocumentSuccessPageState extends State<ResubmitDocumentSuccessPage> {
  final box = Hive.box('capsaBox');

  var signUpData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // signUpData = box.get('signUpData');

    var _body = {};
    //
    // _body = {};
    //
    // _body['email'] = signUpData['email'];
    // _body['panNumber'] = signUpData['bvnNumber'];
    // _body['contact'] = signUpData['phoneNo'];
    // _body['aContact'] = signUpData['phoneNo'];
    //
    // Provider.of<SignUpActionProvider>(context, listen: false)
    //     .setActiveUser(_body);
  }

  @override
  Widget build(BuildContext context) {
    // final role = signUpData['role'];

    return Container(
      child: Padding(
        padding: !Responsive.isMobile(context)
            ? EdgeInsets.all(8)
            : EdgeInsets.fromLTRB(30, 8, 30, 5),
        child: Padding(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.2, 8, 30, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 540,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Document Upload Successful",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          // fontFamily: 'Poppins',
                          fontSize: 36,
                          letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.w600,
                          height: 1.3),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    //if (role != "COMPANY")
                    Text(
                      "You have successfully uploaded your information on Capsa.\n\nYour account is currently pending approval. Our team will review your information and get back to you via email within 24 hours.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          // fontFamily: 'Poppins',
                          fontSize: 18,
                          letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1.3),
                    ),
                    // if (role == "COMPANY")
                    //   RichText(
                    //     textAlign: TextAlign.left,
                    //     text: TextSpan(
                    //       text:
                    //       'To activate your account for invoice factoring on Capsa, kindly upload the',
                    //       style: TextStyle(
                    //           color: Color.fromRGBO(51, 51, 51, 1),
                    //           // fontFamily: 'Poppins',
                    //           fontSize: 16,
                    //           letterSpacing:
                    //           0 /*percentages not used in flutter. defaulting to zero*/,
                    //           fontWeight: FontWeight.normal,
                    //           height: 1.3),
                    //       children: <TextSpan>[
                    //         TextSpan(
                    //           text: " change of account letter ",
                    //           style: TextStyle(
                    //               color: HexColor("#0098DB"),
                    //               fontFamily: 'Poppins',
                    //               fontSize: 16,
                    //               letterSpacing:
                    //               0 /*percentages not used in flutter. defaulting to zero*/,
                    //               fontWeight: FontWeight.normal,
                    //               height: 1.3),
                    //         ),
                    //         TextSpan(
                    //           text: "signed by your Anchor(s)",
                    //           style: TextStyle(
                    //               color: Color.fromRGBO(51, 51, 51, 1),
                    //               // fontFamily: 'Poppins',
                    //               fontSize: 16,
                    //               letterSpacing:
                    //               0 /*percentages not used in flutter. defaulting to zero*/,
                    //               fontWeight: FontWeight.normal,
                    //               height: 1.3),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () async{
                        logout(context);
                      },
                      child: Container(
                        width: Responsive.isMobile(context)
                            ? 100 : 180 ,
                        height: Responsive.isMobile(context)
                            ? 42 : 58 ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15 )),
                          border: Border.all(color: Colors.red, width: 3 ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout, color: Colors.red,),
                              Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: Responsive.isMobile(context)
                                        ? 14  : 20 ,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //if (role == "COMPANY")
                    // RichText(
                    //   textAlign: TextAlign.left,
                    //   text: TextSpan(
                    //     text: 'Your account is currently pending approval. Our team will review your information and get back to you',
                    //     style: TextStyle(
                    //         color: Color.fromRGBO(51, 51, 51, 1),
                    //         // fontFamily: 'Poppins',
                    //         fontSize: 16,
                    //         letterSpacing:
                    //         0 /*percentages not used in flutter. defaulting to zero*/,
                    //         fontWeight: FontWeight.normal,
                    //         height: 1.3),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text: " via email within 24 hours.",
                    //         style: TextStyle(
                    //             color: HexColor("#0098DB"),
                    //             fontFamily: 'Poppins',
                    //             fontSize: 16,
                    //             letterSpacing:
                    //             0 /*percentages not used in flutter. defaulting to zero*/,
                    //             fontWeight: FontWeight.normal,
                    //             height: 1.3),
                    //       ),
                    //       // TextSpan(
                    //       //    text: "in your profile.",
                    //       //    style: TextStyle(
                    //       //        color: Color.fromRGBO(51, 51, 51, 1),
                    //       //        // fontFamily: 'Poppins',
                    //       //        fontSize: 16,
                    //       //        letterSpacing:
                    //       //        0 /*percentages not used in flutter. defaulting to zero*/,
                    //       //        fontWeight: FontWeight.normal,
                    //       //        height: 1.3),
                    //       //  ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 25,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: SizedBox(
                    //     width: 330,
                    //     child: InkWell(
                    //       onTap: () {
                    //         capsaPrint("Proceed to Dashboard");
                    //         final authProvider =
                    //         Provider.of<AuthProvider>(context, listen: false);
                    //
                    //         try {
                    //           // Map<String, dynamic>
                    //           var tmpUserData = box.get('tmpUserData') ?? {};
                    //           //
                    //           // authProvider.authChange(true,tmpUserData['role']);
                    //           // authProvider.setUserdata(tmpUserData);
                    //           // box.put('userData', tmpUserData);
                    //           // box.put('isAuthenticated', true);
                    //           //
                    //           //
                    //           // capsaPrint(tmpUserData);
                    //           authProvider.authChange(true, tmpUserData['role']);
                    //           // authProvider.setUserdata(tmpUserData);
                    //           box.put('userData', tmpUserData);
                    //           box.put('isAuthenticated', true);
                    //
                    //           Beamer.of(context).beamToNamed('/');
                    //           Future.delayed(const Duration(milliseconds: 800),
                    //                   () {
                    //                 html.window.location.reload();
                    //               });
                    //         } catch (e) {
                    //           capsaPrint(e);
                    //         }
                    //       },
                    //       child: Container(
                    //         width: double.infinity,
                    //         height: 55,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(15),
                    //             topRight: Radius.circular(15),
                    //             bottomLeft: Radius.circular(15),
                    //             bottomRight: Radius.circular(15),
                    //           ),
                    //           color: Color.fromRGBO(0, 152, 219, 1),
                    //         ),
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 10, vertical: 10),
                    //         child: Center(
                    //           child: Text(
                    //             'Proceed to Dashboard',
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //                 color: Color.fromRGBO(242, 242, 242, 1),
                    //                 fontFamily: 'Poppins',
                    //                 fontSize: 15,
                    //                 letterSpacing:
                    //                 0 /*percentages not used in flutter. defaulting to zero*/,
                    //                 fontWeight: FontWeight.normal,
                    //                 height: 1),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}