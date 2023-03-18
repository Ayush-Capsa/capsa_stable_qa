import 'dart:convert' show json, base64, ascii;

import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/signup/widgets/StackColumnSwitch.dart';
import 'package:capsa/signup/widgets/capsalogo.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class PasswordSetPage extends StatefulWidget {
  final bool isReset;
  final String token;

  PasswordSetPage({this.isReset: false, this.token, Key key}) : super(key: key);

  @override
  State<PasswordSetPage> createState() => _PasswordSetPageState();
}

class _PasswordSetPageState extends State<PasswordSetPage> {
  String jwt;
  dynamic payload;
  final box = Hive.box('capsaBox');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isReset = widget.isReset;

    // _currentStep = box.get('currentStep') ?? 0;

    // final _uri = Uri.parse(html.window.location.href);
    String token = '';

    token = widget.token;
    // capsaPrint(token);

    if (token == null) {
      if (box.get('activateToken') != null) {
        token = box.get('activateToken');
        // capsaPrint(token);
      } else {}
    } else {
      box.put('activateToken', token);
    }

    var jwt = token.split(".");

    var payload =
        json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));

    var exp = payload['exp'];

    //  String dateWithT = exp.substring(0, 8) + 'T' + exp.substring(8);
    //  DateTime dateTime = DateTime.parse(dateWithT);
    //   capsaPrint(dateTime);
    // exp variable date time
    //
    //
    // capsaPrint(token);

    Provider.of<SignUpActionProvider>(context, listen: false).setUser(payload);
  }

  final formKey = GlobalKey<FormState>();
  final newController = TextEditingController(text: '');
  final conController = TextEditingController(text: '');
  String _errorMsg1 = '';
  String _errorMsg2 = '';

  bool processing = false;
  bool isDone = false;
  bool obscureText1 = true;
  bool obscureText2 = true;

  String _newPassword = "";
  String _conPassword = "";

  bool isReset;

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isAllTrue() {
    bool hasUppercase = _newPassword.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = _newPassword.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = _newPassword.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        _newPassword.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return (hasUppercase && hasDigits && hasLowercase && hasSpecialCharacters)
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<SignUpActionProvider>(context);

    return Container(
      decoration: Responsive.isMobile(context)
          ? BoxDecoration(
              color: HexColor("#0098DB"),
            )
          : BoxDecoration(),
      child: Form(
        key: formKey,
        child: Padding(
          padding: Responsive.isMobile(context)
              ? EdgeInsets.zero
              : EdgeInsets.all(45.0),
          child: StackColumnSwitch(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              if (Responsive.isMobile(context))
                Positioned(top: 33, child: CapsaLogoImage()),
              if (Responsive.isMobile(context))
                Positioned(
                  bottom: 0,
                  child: MobileBGWhiteContainer(
                    child: _myWid(actionProvider),
                    height: MediaQuery.of(context).size.height * 0.7,
                  ),
                )
              else
                _myWid(actionProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myWid(actionProvider) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isMobile(context))
            SizedBox(
              height: 25,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Forgot Password',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1),
                  fontFamily: 'Poppins',
                  fontSize: Responsive.isMobile(context) ? 20 : 30,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ),
          if (isDone) SizedBox(height: 16),
          if (isDone)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your password has been set successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 14,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
          if (isDone) SizedBox(height: 16),
          if (isDone)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kindly proceed to login',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 14,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
          SizedBox(
            height: 24,
          ),
          if (!isDone)
            SizedBox(
              width: 400,
              child: UserTextFormField(
                padding: EdgeInsets.only(
                    left: 8, bottom: (Responsive.isMobile(context)) ? 0 : 4),
                label: "New Password",
                hintText: "********",
                obscureText: obscureText1,
                onChanged: (v) {
                  _newPassword = v.trim();
                  setState(() {});
                },
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        obscureText1 = !obscureText1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/eye-Icons.png",
                        height: 14,
                      ),
                    )),
                controller: newController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (!validateStructure(value)) {
                    return 'Your password must be more than 8 characters long, should contain at least\n1 Uppercase, 1 Lowercase, 1 Numeric, 1 Special Character.';
                  }
                  if (value.length < 8) {
                    return 'Password length needs to be at least 8 characters long';
                  }
                  return null;
                },
              ),
            ),
          if (!isAllTrue())
            if (Responsive.isMobile(context))
              if (!isDone)
                Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                  ),
                  child: passwordGuide(),
                ),
          if (!isAllTrue())
            if (Responsive.isMobile(context))
              SizedBox(
                height: 30,
              ),
          if (!isDone)
            SizedBox(
              width: 400,
              child: UserTextFormField(
                padding: EdgeInsets.only(left: 8, bottom: 4),
                label: "Confirm New Password",
                hintText: "********",
                controller: conController,
                obscureText: obscureText2,
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
                onChanged: (v) {
                  _conPassword = v;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != newController.text) {
                    return 'Password does not match';
                  }
                  if (value.isEmpty) {
                    return 'Password cannot be empty';
                  }

                  if (!validateStructure(value)) {
                    return 'Your password must be more than 8 characters long, should contain at least\n1 Uppercase, 1 Lowercase, 1 Numeric, 1 Special Character.';
                  }

                  if (value.length < 8) {
                    return 'Password length needs to be at least 8 characters long';
                  }
                  return null;
                },
              ),
            ),
          if (!Responsive.isMobile(context))
            if (!isDone)
              Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: passwordGuide(),
              ),
          if (!isDone)
            SizedBox(
              height: 10,
            ),
          if (!isDone)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: processing
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: 400,
                      child: InkWell(
                        onTap: () async {
                          if (formKey.currentState.validate()) {
                            setState(() {
                              // isDone = false;
                              processing = true;
                            });
                            if (isReset) {
                              Map<String, dynamic> _body_2 = {};
                              _body_2['token'] = widget.token;
                              var _data_2 =
                                  await actionProvider.forgetPassword2(_body_2);
                              // capsaPrint(_data_2);

                              Map<String, dynamic> _body = {};

                              _body['pan'] = _data_2['panNumber'];
                              _body['pas'] = newController.text;
                              _body['cPas'] = conController.text;
                              _body['nPassword'] = newController.text;

                              dynamic response1 = await callApi(
                                  'signin/checkBlockedPassword',
                                  body: _body);

                              if (response1['msg'] == 'failed') {
                                showToast(response1['data'], context,
                                    type: 'error');

                                setState(() {
                                  isDone = false;
                                  processing = false;
                                  _errorMsg2 = response1['data'];
                                });
                              } else {
                                var _data = await actionProvider
                                    .setResetPasswordCall(_body);

                                if (_data['res'] == 'success') {
                                  // showToast('Password Successfully Reset! Login to continue', context);
                                  setState(() {
                                    isDone = true;
                                    processing = false;
                                  });
                                  // context.beamToNamed('/sign_in');
                                  return;
                                } else {
                                  setState(() {
                                    isDone = false;
                                    processing = false;
                                    _errorMsg2 = _data['messg'];
                                  });
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(_data['messg']),
                                  //     action: SnackBarAction(
                                  //       label: 'Ok',
                                  //       onPressed: () {
                                  //         // Code to execute.
                                  //       },
                                  //     ),
                                  //   ),
                                  // );
                                  return;
                                }
                              }
                            } else {
                              // actionProvider.setPassword(widget, context, passCont, passCont2, _btnController, verificationDataProvider: verificationDataProvider, isReset: isReset);
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 59,
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
                              horizontal: 16, vertical: 16),
                          child: Center(
                            child: Text(
                              'Submit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: processing
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: 400,
                      child: InkWell(
                        onTap: () async {
                          Beamer.of(context).beamToNamed('/sign_in');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 59,
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
                              horizontal: 16, vertical: 16),
                          child: Center(
                            child: Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          if (!isDone)
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                color: Color(0xFFf2f8fb),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text("Already on capsa?"),
                  SizedBox(
                    width: 3,
                  ),
                  InkWell(
                    onTap: () {
                      // sign_in
                      Beamer.of(context).beamToNamed('/sign_in');
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  passwordGuide() {
    bool hasUppercase = _newPassword.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = _newPassword.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = _newPassword.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        _newPassword.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Text(
        //   'Password Setting Guide',
        //   textAlign: TextAlign.left,
        //   style: TextStyle(
        //       color: Color.fromRGBO(51, 51, 51, 1),
        //       fontFamily: 'Poppins',
        //       fontSize: 20,
        //       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
        //       fontWeight: FontWeight.normal,
        //       height: 1),
        // ),
        // SizedBox(height: 20),
        // Text(
        //   'Password should contain at least:',
        //   textAlign: TextAlign.left,
        //   style: TextStyle(
        //       color: Color.fromRGBO(51, 51, 51, 1),
        //       // fontFamily: 'Poppins',
        //       fontSize: 16,
        //       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
        //       fontWeight: FontWeight.normal,
        //       height: 1),
        // ),
        SizedBox(height: 15),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  checkBox(checked: hasUppercase),
                  SizedBox(width: 8),
                  Text(
                    '1 Uppercase Letter',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        // fontFamily: 'Poppins',
                        fontSize: 14,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ],
              ),
            ),
            SizedBox(width: Responsive.isMobile(context) ? 25 : 18),
            Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  checkBox(checked: hasLowercase),
                  SizedBox(width: 8),
                  Text(
                    '1 Lowercase Letter',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        // fontFamily: 'Poppins',
                        fontSize: 14,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ],
              ),
            ),
            if (!Responsive.isMobile(context)) SizedBox(width: 18),
            if (!Responsive.isMobile(context))
              Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    checkBox(checked: hasDigits),
                    SizedBox(width: 8),
                    Text(
                      '1 Number',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          // fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 15),

        Row(
          children: [
            if (Responsive.isMobile(context))
              Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    checkBox(checked: hasDigits),
                    SizedBox(width: 8),
                    Text(
                      '1 Number',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          // fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ],
                ),
              ),
            if (Responsive.isMobile(context))
              SizedBox(width: Responsive.isMobile(context) ? 85 : 0),
            Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  checkBox(checked: hasSpecialCharacters),
                  SizedBox(width: 8),
                  Text(
                    '1 Special Character',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        // fontFamily: 'Poppins',
                        fontSize: 14,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ],
              ),
            ),
            if (!Responsive.isMobile(context)) SizedBox(width: 18),
            if (!Responsive.isMobile(context))
              Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    checkBox(checked: _newPassword.length > 8 ? true : false),
                    SizedBox(width: 8),
                    Text(
                      'Minimum of 8 Characters',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          // fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 15),

        Row(
          children: [
            Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  checkBox(checked: _newPassword.length > 8 ? true : false),
                  SizedBox(width: 8),
                  Text(
                    'Minimum of 8 Characters',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        // fontFamily: 'Poppins',
                        fontSize: 14,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget checkBox({checked: false}) {
    if (checked) {
      return // Figma Flutter Generator CheckboxWidget - INSTANCE
          Container(
              width: 15,
              height: 15,
              child: Stack(children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          border: Border.all(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            width: 2,
                          ),
                        ))),
                Positioned(
                    top: 3,
                    left: 3,
                    child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          color: Color.fromRGBO(0, 152, 219, 1),
                          border: Border.all(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            width: 2,
                          ),
                        ))),
              ]));
    }

    return Container(
        width: 15,
        height: 15,
        child: Stack(children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(0, 152, 219, 1),
                      width: 2,
                    ),
                  ))),
        ]));
  }
}
