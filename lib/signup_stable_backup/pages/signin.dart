import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:capsa/signup/function/login_function.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/signup/widgets/capsalogo.dart';
import 'package:capsa/widgets/user_input.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:beamer/beamer.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final myController0 = TextEditingController();

  final myController1 = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool obscureText2 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlatform();
    final box = Hive.box('capsaBox');
    box.delete('loginTime');
    box.delete('signUpData');
    box.put('isAuthenticated', false);
    box.delete('userData');
    box.delete('loginUserData');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.authChange(false, '');
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool processing = false;

  String _platformDevice = '';
  String _errorMsg1 = '';
  String _errorMsg2 = '';

  void getPlatform() async {
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // capsaPrint('deviceInfo');

    // try {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   capsaPrint('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
    //   _platformDevice = androidInfo.model;
    // } catch (e) {
    //   capsaPrint(e);
    // }

    // try {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   capsaPrint('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
    //   _platformDevice = iosInfo.utsname.machine;
    // } catch (e) {
    //   capsaPrint(e);
    // }

    // try {
    //   WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    //   capsaPrint('Running on ${webBrowserInfo.userAgent}'); // e.g. "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
    //   _platformDevice = webBrowserInfo.userAgent;
    // } catch (e) {
    //   capsaPrint(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final _actionProvider =
        Provider.of<SignUpActionProvider>(context, listen: false);

    return Container(
      decoration: Responsive.isMobile(context)
          ? BoxDecoration(
              color: HexColor("#0098DB"),
            )
          : BoxDecoration(),
      child: Form(
        key: formKey,
        child: Stack(
          children: [
            if (!Responsive.isMobile(context))
              Positioned(
                left: 588,
                top: 20,
                child: Container(
                  child: Image.asset(
                    'assets/images/Frame 128.png',
                    width: 480,
                    height: 400,
                  ),
                ),
              )
            else
              Positioned(
                top: 15,
                child: CapsaLogoImage(),
              ),
            // Positioned(
            //   bottom: 0,
            //   child: Container(
            //     child: Image.asset(
            //       'assets/images/Frame 133.png',
            //       color: Colors.white60,
            //       width: MediaQuery.of(context).size.width,
            //       height: MediaQuery.of(context).size.height * 0.7,
            //     ),
            //   ),
            // ),
            if (Responsive.isMobile(context))
              Positioned(bottom: 0, child: MobileBGWhiteContainer()),
            if (!Responsive.isMobile(context))
              Positioned(
                top: 250,
                left: 60,
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          width: 170,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(0),
                            ),
                            color: Color.fromRGBO(0, 152, 219, 1),
                          )),
                      SizedBox(height: 40),
                      Container(
                          width: 170,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(0),
                            ),
                            color: Color.fromRGBO(0, 152, 219, 1),
                          )),
                    ],
                  ),
                ),
              ),
            if (!Responsive.isMobile(context))
              Positioned(
                  top: 95,
                  left: 230,
                  child: // Figma Flutter Generator Frame125Widget - FRAME - VERTICAL
                      Container(
                    height: 450,
                    width: 520,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(100),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(100),
                      ),
                      boxShadow: const  [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(-4, -4),
                          blurRadius: 4,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(4, 4),
                          blurRadius: 4,
                        ),
                      ],
                      color: HexColor("#F5FBFF"),
                      // image: DecorationImage(image: AssetImage('assets/images/Frame125.png'), fit: BoxFit.fitWidth),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: inputSection(_actionProvider),
                  ))
            else
              Positioned(
                  bottom: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: inputSection(_actionProvider))),
            if (!Responsive.isMobile(context))
              Positioned(
                bottom: 22,
                left: 190,
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Speed.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(width: 24),
                      Text(
                        'Convenience.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(width: 24),
                      Text(
                        'Access.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(width: 24),
                      Text(
                        'Possiblities.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(width: 24),
                      Text(
                        'For SMEs in Africa',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget inputSection(_actionProvider) {
    return Padding(
      padding: EdgeInsets.all(!Responsive.isMobile(context) ? 10 : 10.0),
      child: Padding(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.fromLTRB(12, 0, 12, 0)
            : EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: (!Responsive.isMobile(context))
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: <Widget>[
            if (Responsive.isMobile(context))
              SizedBox(
                height: Responsive.isMobile(context) ? 50 : 20,
              ),
            if (Responsive.isMobile(context))
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Text(
                      'Welcome back to',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          fontSize: 14,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Capsa',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 152, 219, 1),
                          fontSize: 16,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: Responsive.isMobile(context) ? 25 : 0,
            ),
            UserTextFormField(
              padding: Responsive.isMobile(context)
                  ? EdgeInsets.zero
                  : EdgeInsets.all(8),
              label: 'Email Address',
              // prefixIcon: Image.asset("assets/images/currency.png"),
              hintText: 'name@example.com',
              controller: myController0,
              // initialValue: '',
              errorText: _errorMsg1,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!validateEmail(value)) {
                  return 'Enter Valid Email address';
                }

                return null;
              },
              onChanged: (v) {},
              keyboardType: TextInputType.emailAddress,
            ),
            UserTextFormField(
              padding: Responsive.isMobile(context)
                  ? EdgeInsets.zero
                  : EdgeInsets.all(8),

              label: 'Password',
              // prefixIcon: Image.asset("assets/images/currency.png"),
              hintText: '*************',
              controller: myController1,
              // note: 'Enter Password',
              obscureText: obscureText2,
              errorText: _errorMsg2,
              suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      obscureText2 = !obscureText2;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/eye-Icons.png",
                      height: 14,
                    ),
                  )),
              // initialValue: '',
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Password is required';
                }
                if (!validateStructure(value)) {
                  return 'Your password must be more than 8 characters long, should \ncontain at least 1 Uppercase, 1 Lowercase, 1 Numeric, 1 Special Character';
                }
                if (value.length < 8) {
                  return 'Password length needs to be at least 8 characters long';
                }
                return null;
              },
              onChanged: (v) {},
              keyboardType: TextInputType.text,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    context.beamToNamed('/forgot-password');
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.all(Responsive.isMobile(context) ? 0 : 8.0),
                    child: Text(
                      'Forgot password?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 152, 219, 1),
                          fontFamily: 'Poppins',
                          fontSize: Responsive.isMobile(context) ? 12 : 15,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: processing
                  ? CircularProgressIndicator()
                  : InkWell(
                      onTap: () async {
                        if (formKey.currentState.validate()) {
                          _errorMsg1 = '';
                          _errorMsg2 = '';
                          setState(() {
                            processing = true;
                          });

                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);

                          var _body = {};

                          _body['emailid'] = myController0.text;
                          _body['password'] = myController1.text;
                          _body['device'] = _platformDevice;
                          var _response = await _actionProvider.signIn(_body);
                          // var _response = await _actionProvider.signIn(_body);
                          if (_response != null) {
                            if (_response['res'] == 'failed') {
                              if (_response['messg'] == "No Account found" ||
                                  _response['messg'] == "No Account found") {
                                _response['messg'] =
                                    "Wrong email or account does not exist";

                                _errorMsg1 = _response['messg'];
                              } else {
                                if (_response['messg'] ==
                                    "Sorry! Incorrect password") {
                                  _response['messg'] =
                                      "Password incorrect. Kindly check again.";
                                }
                                _errorMsg2 = _response['messg'];
                              }
                              setState(() {
                                processing = false;
                              });
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(_response['messg']),
                              //     action: SnackBarAction(
                              //       label: 'Ok',
                              //       onPressed: () {
                              //         // Code to execute.
                              //       },
                              //     ),
                              //   ),
                              // );
                            } else if (_response['res'] == 'success') {
                              // _btnController.success();
                              // final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              print('Sign in response $_response');
                              afterSuccess(context, _response, authProvider,
                                  myController0);
                              SnackBar(
                                content: Text('Successfully Login '),
                                action: SnackBarAction(
                                  label: 'Ok',
                                  onPressed: () {
                                    // Code to execute.
                                  },
                                ),
                              );
                            }
                          } else {
                            setState(() {
                              processing = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: Responsive.isMobile(context) ? 48 : 59,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromRGBO(0, 152, 219, 1),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Responsive.isMobile(context) ? 13 : 16,
                            vertical: Responsive.isMobile(context) ? 13 : 16),
                        child: Center(
                          child: Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                fontFamily: 'Poppins',
                                fontSize:
                                    Responsive.isMobile(context) ? 16 : 18,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ),
                      ),
                    ),
            ),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                color: Color(0xFFf2f8fb),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: Responsive.isMobile(context)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: [
                  Text("New to Capsa?"),
                  SizedBox(
                    width: 3,
                  ),
                  InkWell(
                    onTap: () {
                      // sign_in
                      Beamer.of(context).beamToNamed('/signup');
                    },
                    child: Text(
                      'Sign Up for free',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
