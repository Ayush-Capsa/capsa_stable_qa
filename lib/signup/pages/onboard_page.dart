import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:capsa/signup/function/login_function.dart';
import 'package:capsa/signup/widgets/StackColumnSwitch.dart';
import 'package:capsa/signup/widgets/capsalogo.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final formKey = GlobalKey<FormState>();
  final countryController0 = TextEditingController(text: '');
  final nameController0 = TextEditingController();
  final bvnController0 = TextEditingController();
  final passController0 = TextEditingController();
  final confController0 = TextEditingController();
  final emailController0 = TextEditingController();
  final phoneNumberController = TextEditingController();
  final codePhoneController = TextEditingController(text: '+234');
  String _platformDevice = '';

  String _errorMsg1 = '';
  String _errorMsg2 = '';
  String _errorMsg3 = '';
  String _errorMsg4 = '';
  String _errorMsg5 = '';
  String _errorMsg6 = '';

  bool processing = false;
  bool isDone = false;

  String text1 = "Get started on";
  String text2 = "Capsa";
  String text3 = "Capsa";

  String type = "";
  String type2 = "";

  bool obscureText1 = true;
  bool obscureText2 = true;
  String _newPassword = "";

  final box = Hive.box('capsaBox');

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  var anchor;
  var term = ["Nigeria", "Ghana (Coming soon)", "Kenya (Coming soon)"];
  final disabledItems = ['Ghana (Coming soon)', 'Kenya (Coming soon)'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    type = box.get('onboardType') ?? '';
    type2 = box.get('onboardInvestorType') ?? '';
    if (type == "Vendor") {
      text1 = "Enjoy Invoice Discounting";
      text2 = "Sign up on";
    } else if (type == "Investor") {
      text1 = "Invest in discounted invoices.";
      text2 = "Sign up on";
    }
    // capsaPrint('type2');
    // capsaPrint(type2);
    getPlatform();
    countryController0.text = box.get('selectedCountry');
    anchor = box.get('selectedCountry');
  }

  void getPlatform() async {
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // // capsaPrint('deviceInfo');

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

  bool isAllTrue() {
    bool hasUppercase = passController0.text.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = passController0.text.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = passController0.text.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        passController0.text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return (hasUppercase && hasDigits && hasLowercase && hasSpecialCharacters)
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
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
              : EdgeInsets.fromLTRB(45, 30, 45, 1),
          child: Padding(
            padding: Responsive.isMobile(context)
                ? EdgeInsets.zero
                : EdgeInsets.only(left: 8.0, right: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isMobile(context)) CapsaLogoImage(),
                  if (Responsive.isMobile(context))
                    MobileBGWhiteContainer(
                      child: _myWid(context),
                      height: MediaQuery.of(context).size.height,
                    )
                  else
                    _myWid(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _myWid(context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            topHeading(),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OrientationSwitcher(
                      children: [
                        Flexible(
                          child: UserTextFormField(
                            padding: EdgeInsets.only(bottom: 4, top: 4),
                            label: 'Country',
                            // prefixIcon: Image.asset("assets/images/currency.png"),
                            hintText: 'Nigeria',
                            controller: countryController0,
                            // initialValue: '',
                            readOnly: true,
                            errorText: _errorMsg1,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Country is required';
                              }

                              return null;
                            },
                            onChanged: (v) {},
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Flexible(
                          child: UserTextFormField(
                            label: 'Bank Verification Number (BVN)',
                            padding: EdgeInsets.only(bottom: 4, top: 4),
                            // prefixIcon: Image.asset("assets/images/currency.png"),
                            hintText: '22*********',
                            controller: bvnController0,
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            // initialValue: '',
                            errorText: _errorMsg3,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'BVN is required';
                              }

                              if (value.length != 11) {
                                return 'Kindly check the BVN again';
                              }

                              return null;
                            },
                            onChanged: (v) {},
                            keyboardType: TextInputType.number,
                            // maxLength: 11,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OrientationSwitcher(
                      children: [
                        Flexible(
                          child: (type2 == '' || (type2 != 'Individual'))
                              ? UserTextFormField(
                                  padding: EdgeInsets.only(bottom: 4, top: 4),
                                  label: (type2 == '')
                                      ? 'Company’s Name'
                                      : 'Company’s Name',
                                  // prefixIcon: Image.asset("assets/images/currency.png"),
                                  hintText: 'Capsa Technology',
                                  controller: nameController0,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  // initialValue: '',
                                  errorText: _errorMsg2,
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return 'Company Name is required';
                                    }
                                    return null;
                                  },
                                  onChanged: (v) {},
                                  keyboardType: TextInputType.text,
                                )
                              : emailTextInput(),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Flexible(
                          child: ((type2 != 'Individual'))
                              ? emailTextInput()
                              : phoneNumberInput(),
                        ),
                      ],
                    ),
                  ),

                  if ((type2 == 'Individual'))
                    if (!isAllTrue())
                      if (Responsive.isMobile(context))
                        if (!isDone)
                          Padding(
                            padding: EdgeInsets.only(
                              left: 8,
                            ),
                            child: passwordGuide(),
                          ),
                  if ((type2 == 'Individual'))
                    if (!isAllTrue())
                      if (Responsive.isMobile(context))
                        SizedBox(
                          height: 20,
                        ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OrientationSwitcher(
                      children: [
                        Flexible(
                          child: ((type2 != 'Individual'))
                              ? phoneNumberInput()
                              : passwordInput(),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        // if (!isAllTrue())
                        //   if ((type2 == ''))
                        //     if (Responsive.isMobile(context))
                        //       if (!isDone)
                        //         Padding(
                        //           padding: EdgeInsets.only(
                        //             left: 8,
                        //           ),
                        //           child: passwordGuide(),
                        //         ),
                        // if (type2 == '')
                        //   if (!isAllTrue())
                        //     if (Responsive.isMobile(context))
                        //       if (!isDone)
                        //         SizedBox(
                        //           height: 20,
                        //         ),
                        Flexible(
                          child: ((type2 != 'Individual'))
                              ? passwordInput()
                              : conPasswordInput(),
                        ),
                      ],
                    ),
                  ),
                  if(type2 != 'Individual')Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OrientationSwitcher(
                      children: [
                        Flexible(
                          child: ((type2 != 'Individual'))
                              ? conPasswordInput()
                              : Container(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.57-185-8-45-8,
                        ),
                        if (!isAllTrue())
                          if ((type2 == ''))
                            if (Responsive.isMobile(context))
                              if (!isDone)
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 8,
                                  ),
                                  child: passwordGuide(),
                                ),
                        if (type2 == '')
                          if (!isAllTrue())
                            if (Responsive.isMobile(context))
                              if (!isDone)
                                SizedBox(
                                  height: 20,
                                ),
                        // Flexible(
                        //   child: ((type2 != 'Individual'))
                        //       ? passwordInput()
                        //       : conPasswordInput(),
                        // ),
                      ],
                    ),
                  ),
                  // if (!isDone)
                  if (!Responsive.isMobile(context))
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                      ),
                      child: passwordGuide(),
                    ),
                ],
              ),
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
                                processing = true;
                              });
                              var _body = {};

                              _body['bvnNumber'] = bvnController0.text;
                              _body['email'] = emailController0.text;
                              _body['country'] = countryController0.text;
                              _body['phoneNo'] = phoneNumberController.text;
                              _body['cCOde'] = "234";
                              _body['name'] = nameController0.text;

                              _body['pas'] = passController0.text;
                              _body['cPas'] = confController0.text;

                              _body['acctType'] = type2;
                              _body['userType'] = type;

                              final _actionProvider =
                                  Provider.of<SignUpActionProvider>(context,
                                      listen: false);

                              var _response =
                                  await _actionProvider.submitData(_body);
                              _body['pas'] = '';
                              _body['cPas'] = '';

                              if (_response != null) {
                                if (_response['res'] == 'failed') {
                                  setState(() {
                                    processing = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_response['messg']),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                    ),
                                  );
                                } else if (_response['res'] == 'success') {
                                  box.put('signUpData', _body);

                                  // Beamer.of(context).beamToNamed('/email-otp');
                                  _body = {};

                                  _body['emailid'] = emailController0.text;
                                  _body['password'] = confController0.text;
                                  _body['device'] = _platformDevice;

                                  var _response =
                                      await _actionProvider.signIn(_body);
                                  // var _response = await _actionProvider.signIn(_body);
                                  if (_response != null) {
                                    if (_response['res'] == 'failed') {
                                      if (_response['messg'] ==
                                              "No Account found" ||
                                          _response['messg'] ==
                                              "No Account found") {
                                        _errorMsg1 = _response['messg'];
                                      } else {
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
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      afterSuccess(context, _response,
                                          authProvider, emailController0);
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
                                } else {
                                  setState(() {
                                    processing = false;
                                  });
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
                            height: 48,
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
                                'Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(242, 242, 242, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
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
                    Text("Already have an account?"),
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
      ),
    );
  }

  passwordGuide() {
    bool hasUppercase = passController0.text.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = passController0.text.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = passController0.text.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        passController0.text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

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
            SizedBox(width: Responsive.isMobile(context) ? 25 : 22),
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
                    checkBox(
                        checked:
                            passController0.text.length > 8 ? true : false),
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
                  checkBox(
                      checked: passController0.text.length > 8 ? true : false),
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

  Widget conPasswordInput() {
    return UserTextFormField(
      padding: EdgeInsets.only(bottom: 4, top: 4),
      obscureText: obscureText2,
      label: 'Confirm Password',
      // prefixIcon: Image.asset("assets/images/currency.png"),
      hintText: '*********',
      controller: confController0,
      // initialValue: '',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      errorText: _errorMsg6,
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
      validator: (value) {
        if (value != passController0.text) {
          return 'Password does not match';
        }
        if (value.isEmpty) {
          return 'Confirm Password is required';
        }

        if (value.length < 8) {
          return 'Password length needs to be at least 8 characters long';
        }
        return null;
      },
      onChanged: (v) {
        // setState(() {});
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget passwordInput() {
    return UserTextFormField(
      padding: EdgeInsets.only(bottom: 4, top: 4),
      label: 'Password',
      // prefixIcon: Image.asset("assets/images/currency.png"),
      hintText: '*********',
      controller: passController0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // initialValue: '',
      errorText: _errorMsg5,
      obscureText: obscureText1,
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
        if (!validateStructure(value)) {
          return 'Your password must be more than 8 characters long, should contain at least\n1 Uppercase, 1 Lowercase, 1 Numeric, 1 Special Character.';
        }
        if (value.length < 8) {
          return 'Password length needs to be at least 8 characters long';
        }

        return null;
      },
      onChanged: (v) {
        setState(() {});
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget emailTextInput() {
    return UserTextFormField(
      label: 'Email Address',
      padding: EdgeInsets.only(bottom: 4, top: 4),
      // prefixIcon: Image.asset("assets/images/currency.png"),
      hintText: 'yourmail@example.com',
      controller: emailController0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // initialValue: '',
      errorText: _errorMsg4,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Email is required';
        }
        if (!validateEmail(value)) {
          return 'Email should be in “yourmail@example.com” format';
        }

        return null;
      },
      onChanged: (v) {
        setState(() {});
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget phoneNumberInput() {
    return Row(
      children: [
        SizedBox(
          width: 62,
          child: UserTextFormField(
            padding: EdgeInsets.only(bottom: 2, top: 2),
            label: "Phone",
            // prefixIcon: Image.asset("assets/images/currency.png"),
            hintText: "(+234)",
            readOnly: true,
            controller: codePhoneController,
            // initialValue: '',
            // errorText: _errorMsg3,
            validator: (value) {
              // if (value.trim().isEmpty) {
              //   return 'Phone Number is required';
              // }

              return null;
            },
            onChanged: (v) {},
            keyboardType: TextInputType.number,

            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
        ),
        Expanded(
          child: UserTextFormField(
            label: 'Phone Number',
            padding: EdgeInsets.only(bottom: 4, top: 4),
            // prefixIcon: Image.asset("assets/images/currency.png"),
            hintText: '8034567890',
            controller: phoneNumberController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // initialValue: '',
            errorText: _errorMsg4,
            validator: (value) {
              if (value.trim().isEmpty) {
                return 'Phone Number is required';
              }
              // if (!validateEmail(value)) {
              //   return 'Email should be in “yourmail@example.com” format';
              // }

              return null;
            },
            keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            onChanged: (v) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget topHeading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text1,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontFamily: 'Poppins',
                fontSize: Responsive.isMobile(context) ? 18 : 22,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 15 : 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text2,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    // fontFamily: 'Poppins',
                    fontSize: Responsive.isMobile(context) ? 18 : 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                text3,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: HexColor("#0098DB"),
                    // fontFamily: 'Poppins',
                    fontSize: Responsive.isMobile(context) ? 18 : 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
