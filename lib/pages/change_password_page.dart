import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');

  bool saving = false;

  final oldController = TextEditingController(text: '');
  final newController = TextEditingController(text: '');
  final conController = TextEditingController(text: '');

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

    return SingleChildScrollView(
      child: Container(
        // height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputSection(context, profileProvider),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: passwordGuide(),
                    ),
                    SizedBox(height: 15),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: inputSection(context, profileProvider),
                    ),
                    SizedBox(width: 28),
                    Expanded(
                      child: passwordGuide(),
                    )
                  ],
                )
            ],
          ),
        ),
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
                obscureText: true,
                onChanged: (v) {
                  _oldPassword = v;
                },
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
                obscureText: true,
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

                      await profileProvider.queryFewData();
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
                                    height: 180,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Password Changed',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Password Changed Successfully!\nLogin to continue.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
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
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                //actions: <Widget>[],
                              ));
                      // showToast('Password was successfully changed.', context);
                      // showToast('Login with new password', context);
                      // logout(context);

                      // context.beamBack();
                    } else {
                      showToast('Error ! ' + response['messg'], context,
                          toastDuration: 3, type: 'error');
                    }
                  }
                }
              },
              child: Container(
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
                              horizontal: 16, vertical: 16),
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

    return Column(
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
