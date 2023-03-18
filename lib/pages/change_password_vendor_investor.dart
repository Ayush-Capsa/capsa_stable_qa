import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class ChangePasswordPageVI extends StatefulWidget {
  bool canGoBack;
  ChangePasswordPageVI({Key key, this.canGoBack = true}) : super(key: key);

  @override
  State<ChangePasswordPageVI> createState() => _ChangePasswordPageVIState();
}

class _ChangePasswordPageVIState extends State<ChangePasswordPageVI> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');

  bool saving = false;

  final oldController = TextEditingController(text: '');
  final newController = TextEditingController(text: '');
  final conController = TextEditingController(text: '');
  bool oldPasswordObscure = true;
  bool newPasswordObscure = true;
  bool conPasswordObscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).queryProfile();
    Provider.of<ProfileProvider>(context, listen: false).queryFewData();
  }

  String _oldPassword = "";
  String _newPassword = "";
  String _conPassword = "";

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    // UserData userDetails = profileProvider.userDetails;

    return Scaffold(
      body: Row(
        children: [
          if (widget.canGoBack)
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
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: [
                  Positioned(
                      left: 42.5,
                      top: 38.0,
                      right: null,
                      bottom: null,
                      width: 34,
                      height: 34,
                      child: Container(
                        width: 80.0,
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.zero,
                            child: Image.asset(
                              "assets/images/arrow-left.png",
                              color: null,
                              fit: BoxFit.cover,
                              width: 34.0,
                              height: 34,
                              colorBlendMode: BlendMode.dstATop,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          Container(
            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width - 185,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                padding:
                    EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 22,
                      ),
                      TopBarWidget("Change Password", ""),
                      SizedBox(
                        height: 15,
                      ),

                      if (Responsive.isMobile(context))
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: Color(
                              0xff333333,
                            ),
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins",
                          ),
                        ),

                      SizedBox(
                        height: 15,
                      ),

                      if (!Responsive.isMobile(context))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: inputSection(context, profileProvider),
                          ),
                          //if (!Responsive.isMobile(context))
                            SizedBox(width: 28),
                          //if (!Responsive.isMobile(context))
                            Expanded(
                              child: passwordGuide(),
                            )
                        ],
                      ),

                      if (Responsive.isMobile(context))
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            inputSection(context, profileProvider),
                            //if (!Responsive.isMobile(context))
                            //SizedBox(width: 28),
                            //if (!Responsive.isMobile(context))
                            passwordGuide()
                          ],
                        )

                      //     :
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     inputSection(context, profileProvider),
                      //     SizedBox(height: 28),
                      //     passwordGuide()
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  inputSection(BuildContext context, profileProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: UserTextFormField(
                label: "Old Password",
                hintText: "Old Password",
                controller: oldController,
                obscureText: oldPasswordObscure,
                onChanged: (v) {
                  _oldPassword = v;
                },
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        oldPasswordObscure = !oldPasswordObscure;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/eye-Icons.png",
                        height: 14,
                      ),
                    )),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: UserTextFormField(
                label: "New Password",
                hintText: "New Password",
                onChanged: (v) {
                  _newPassword = v.trim();
                  setState(() {});
                },
                controller: newController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (!validateStructure(value)) {
                    return 'Your password must be more than 8 characters long, should contain at least\n1 Uppercase, 1 Lowercase, 1 Numeric, 1 special character.';
                  }
                  if (value.length < 8) {
                    return 'Password length needs to be at least 8 characters long';
                  }
                  return null;
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: UserTextFormField(
                label: "Confirm New Password",
                hintText: "Confirm New Password",
                controller: conController,
                obscureText: conPasswordObscure,
                onChanged: (v) {
                  _conPassword = v;
                },
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        conPasswordObscure = !conPasswordObscure;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/eye-Icons.png",
                        height: 14,
                      ),
                    )),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != newController.text) {
                    return 'Password does not match';
                  }
                  if (value.isEmpty) {
                    return 'Password cannot be empty';
                  }

                  if (!validateStructure(value)) {
                    return 'Your password must be more than 8 characters long, should contain at least\n1 Uppercase, 1 Lowercase, 1 Numeric, 1 special character.';
                  }

                  if (value.length < 8) {
                    return 'Password length needs to be at least 8 characters long';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        if (saving)
          Center(
            child: CircularProgressIndicator(),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {

                if (_formKey.currentState.validate()) {
                  if (_newPassword != _conPassword) {
                    showToast('Confirm Password not matched.', context);
                    return;
                  }

                  setState(() {
                    saving = true;
                  });
                  var userData = Map<String, dynamic>.from(box.get('userData'));
                  var _body = {};

                  _body['panNumber'] = userData['panNumber'];
                  _body['nPassword'] = _newPassword;
                  _body['cPassword'] = _conPassword;
                  _body['oPassword'] = _oldPassword;

                  dynamic response1 =
                      await callApi('signin/checkBlockedPassword', body: _body);

                  if (response1['msg'] == 'failed') {
                    showToast(response1['data'], context, type: 'error');

                    _oldPassword = "";
                    oldController.text = "";

                    _newPassword = "";
                    newController.text = "";

                    _conPassword = "";
                    conController.text = "";
                    setState(() {
                      saving = false;
                    });
                  } else {
                    dynamic response =
                        await callApi('signin/userResetPassword', body: _body);
                    _oldPassword = "";
                    oldController.text = "";
                    setState(() {
                      saving = false;
                    });
                    if (response['res'] == 'success') {
                      _oldPassword = "";
                      oldController.text = "";

                      _newPassword = "";
                      newController.text = "";

                      _conPassword = "";
                      conController.text = "";

                      //await profileProvider.queryFewData();
                      //showToast('Password was successfully changed. Login with new password!', context);

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            // title: Text(
                            //   '',
                            //   style: TextStyle(
                            //     fontSize: 24,
                            //     fontWeight: FontWeight.bold,
                            //     color: Theme.of(context).primaryColor,
                            //   ),
                            // ),
                            content: Container(
                              // width: 800,
                                height: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [

                                      SizedBox(height: 12,),

                                      Image.asset('assets/icons/check.png'),

                                      SizedBox(height: 12,),

                                      Text(
                                        'Password Changed',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        'Password Changed Successfully!\nKindly Login to continue.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          logout(context);
                                        },
                                        child:Container(
                                          width: 160,
                                          decoration: BoxDecoration(
                                              color: HexColor('#0098DB'),
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Text(
                                                'Okay',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            //actions: <Widget>[],
                          ));

                      //showToast('Login with new password', context);
                      // Future.delayed(const Duration(milliseconds: 1200), () {
                      //   logout(context);
                      // });

                      // context.beamBack();
                    } else {
                      showToast('Error ! ' + response['messg'], context,
                          toastDuration: 15, type: 'error');
                    }
                  }
                }
              },
              child: Responsive.isMobile(context)?Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Color.fromRGBO(0, 152, 219, 1),
                ),
                child: Center(
                  child: Text(
                    'Save',
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
              ):Container(
                  width: 200,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 26, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Save',
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
                            ],
                          ),
                        )),
                  ])),
            ),
          ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  passwordGuide() {
    bool hasUppercase = _newPassword.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = _newPassword.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = _newPassword.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        _newPassword.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return
      !Responsive.isMobile(context)?
      Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Password Setting Guide',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromRGBO(51, 51, 51, 1),
              fontFamily: 'Poppins',
              fontSize: 20,
              letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
              fontWeight: FontWeight.normal,
              height: 1),
        ),
        SizedBox(height: 28),
        Text(
          'Password should contain at least:',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromRGBO(51, 51, 51, 1),
              // fontFamily: 'Poppins',
              fontSize: 16,
              letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
              fontWeight: FontWeight.normal,
              height: 1),
        ),
        SizedBox(height: 28),
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
                    fontSize: 18,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 28),
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
                    fontSize: 18,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 28),
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
                    fontSize: 18,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              checkBox(checked: hasSpecialCharacters),
              SizedBox(width: 8),
              Text(
                '1 Special case character (@!#\$&...)',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    // fontFamily: 'Poppins',
                    fontSize: 18,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 28),
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
                    fontSize: 18,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ],
          ),
        ),
      ],
    ):
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.46,
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
              SizedBox(height: 18),
              Container(
                width: MediaQuery.of(context).size.width * 0.46,
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
              SizedBox(height: 18),
              Container(
                width: MediaQuery.of(context).size.width * 0.46,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.46,
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
              SizedBox(height: 18),
              Container(
                width: MediaQuery.of(context).size.width * 0.46,
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    checkBox(checked: _newPassword.length > 8 ? true : false),
                    SizedBox(width: 8),
                    Text(
                      'Minimum of 8\nCharacters',
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
          )
        ],
      );
  }

  Widget checkBox({checked: false}) {
    if (checked) {
      return // Figma Flutter Generator CheckboxWidget - INSTANCE
          Container(
              width: 20,
              height: 20,
              child: Stack(children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 20,
                        height: 20,
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
                    top: 4,
                    left: 4,
                    child: Container(
                        width: 12,
                        height: 12,
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
        width: 20,
        height: 20,
        child: Stack(children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 20,
                  height: 20,
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
