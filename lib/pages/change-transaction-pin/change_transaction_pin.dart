import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/main.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:http/http.dart' as http;
import 'package:capsa/functions/call_api.dart';

class ChangeTransactionPinPage extends StatefulWidget {
  const ChangeTransactionPinPage({Key key}) : super(key: key);

  @override
  State<ChangeTransactionPinPage> createState() =>
      _ChangeTransactionPinPageState();
}

class _ChangeTransactionPinPageState extends State<ChangeTransactionPinPage> {
  final passwordController = TextEditingController(text: '');
  final pinController = TextEditingController(text: '');
  final reEnterPinController = TextEditingController(text: '');
  bool obscureText = true;

  final _formKey = GlobalKey<FormState>();

  String _password = '';
  String _pin = '';
  String _reEnterPin = '';
  String passwordErrorText = '';
  var userData;

  Future signIn(_body) async {
    var data = '';
    try {
      var response = await http.get(Uri.parse("https://ipwhois.app/json/"));
      // capsaPrint(response);
      data = response.body;
    } catch (e) {
      capsaPrint(e);
    }
    _body['location'] = data;
    var response = await callApi('signin/submit', body: _body);
    // capsaPrint('Sign in Data: ${response[0]}');
    return response;
    // dynamic _uri = _url + 'signin/submit';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  Future updateTransactionPin(_body) async {
    var data = '';
    var response = await callApi('/signin/checkTransactionPINisPresent', body:_body);
    print('check response: $response');
    if(response['isPresent'] == 'false'){
      response = await callApi('/signin/createTransactinPIN', body: _body);
      capsaPrint('updateTransactionPin1: $response');
    }else{
      response = await callApi('/signin/updateTransactionPIN', body: _body);
      capsaPrint('updateTransactionPin2: $response');
    }


    return response;
    // dynamic _uri = _url + 'signin/submit';
    // _uri = Uri.parse(_uri);
    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).queryProfile();
    Provider.of<ProfileProvider>(context, listen: false).queryFewData();
    final Box box = Hive.box('capsaBox');

    userData = Map<String, dynamic>.from(box.get('userData'));
    String _role = userData['role'];
  }

  bool saving = false;

  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    UserData userDetails = profileProvider.userDetails;

    if (!saving) {
      isSet = true;
    }
    final Box box = Hive.box('capsaBox');

    return Container(
      // height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
      child: Form(
        key: _formKey,
        child: Responsive.isMobile(context)?SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 22,
              ),
              TopBarWidget("Create/Change Transaction Pin", ''),
              Text(
                "",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              // SizedBox(
              //   height: 15,
              // ),
              Container(
                // height: MediaQuery.of(context).size.height * 0.8,
                width: Responsive.isMobile(context) ?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter a 4 digit pin to be used for all your transactions',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OrientationSwitcher(
                      children: [
                        Flexible(
                          child: UserTextFormField(
                            label: "Password",
                            hintText: "Enter your login password",
                            controller: passwordController,
                            obscureText: obscureText,
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
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
                              _password = v;
                            },
                            errorText: passwordErrorText,
                          ),
                        ),
                      ],
                    ),
                    OrientationSwitcher(
                      children: [
                        Flexible(
                          child: UserTextFormField(
                            label: "Enter 4 Digit Transaction Pin",
                            hintText: "X X X X",
                            controller: pinController,
                            keyboardType: TextInputType.number,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (v) {
                              if (v.length > 4) {
                                v = v.substring(0, 4);
                                pinController.text = v.substring(0, 4);
                                pinController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: pinController.text.length));

                                showToast('Pin Cannot be greater than 4 digits',
                                    context,
                                    type: 'warning');
                              }
                              _pin = v;
                            },
                            validator: (v) {
                              if (v.isEmpty) {
                                return "This field is required.";
                              } else if (v.length < 4) {
                                return 'Pin should be of 4 digit';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                    OrientationSwitcher(
                      children: [
                        Flexible(
                          child: UserTextFormField(
                            label: "Re-Enter 4 Digit Transaction Pin",
                            hintText: "X X X X",
                            controller: reEnterPinController,
                            keyboardType: TextInputType.number,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (v) {
                              if (v.length > 4) {
                                v = v.substring(0, 4);
                                pinController.text = v.substring(0, 4);
                                pinController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: pinController.text.length));

                                showToast('Pin Cannot be greater than 4 digits',
                                    context,
                                    type: 'warning');
                              }
                              _reEnterPin = v;
                            },
                            validator: (v) {
                              if (v.isEmpty) {
                                return "This field is required.";
                              } else if (v != pinController.text) {
                                return 'Pins Do Not Match';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    if (saving)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              saving = true;
                            });

                            var _body = {};

                            _body['emailid'] = userData['email'];
                            _body['password'] = passwordController.text;
                            _body['device'] = '';
                            var _response = await signIn(_body);

                            if (_response['res'] == 'failed') {
                              // if (_response['messg'] ==
                              //     "Sorry! Incorrect password") {
                              //   _response['messg'] =
                              //   "Password incorrect. Kindly check again.";
                              // }
                              passwordController.text = "";
                              passwordErrorText =
                              "Password incorrect. Kindly check again.";
                              setState(() {
                                saving = false;
                              });
                            } else {
                              _body = {};
                              _body['panNumber'] = userData['panNumber'];
                              _body['email'] = userData['email'];
                              _body['transaction_pin'] = _reEnterPin;
                              print('Body : $_body');
                              _response = await updateTransactionPin(_body);
                              //capsaPrint('passs 1 $_response ${_response[0]}');
                              if (_response['res'] == 'success') {
                                showToast('Pin Updated Successfully', context);
                              } else {
                                showToast(_response, context,
                                    type: 'warning');
                              }
                              if(Beamer.of(context).canBeamBack) {
                                Beamer.of(context).beamBack();
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CapsaHome(),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Container(
                            width: Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width * 0.8
                                : MediaQuery.of(context).size.width * 0.2,
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
                                        0.2,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center ,
                                        children: <Widget>[
                                          Text(
                                            'Generate Pin',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    242, 242, 242, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 18,
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
                      ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
        ):Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 22,
            ),
            TopBarWidget("Create/Change Transaction Pin", ''),
            Text(
              "",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            // SizedBox(
            //   height: 15,
            // ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.8,
              width: Responsive.isMobile(context) ?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter a 4 digit pin to be used for all your transactions',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OrientationSwitcher(
                    children: [
                      Flexible(
                        child: UserTextFormField(
                          label: "Password",
                          hintText: "Enter your login password",
                          controller: passwordController,
                          obscureText: obscureText,
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
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
                            _password = v;
                          },
                          errorText: passwordErrorText,
                        ),
                      ),
                    ],
                  ),
                  OrientationSwitcher(
                    children: [
                      Flexible(
                        child: UserTextFormField(
                          label: "Enter 4 Digit Transaction Pin",
                          hintText: "X X X X",
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (v) {
                            if (v.length > 4) {
                              v = v.substring(0, 4);
                              pinController.text = v.substring(0, 4);
                              pinController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: pinController.text.length));

                              showToast('Pin Cannot be greater than 4 digits',
                                  context,
                                  type: 'warning');
                            }
                            _pin = v;
                          },
                          validator: (v) {
                            if (v.isEmpty) {
                              return "This field is required.";
                            } else if (v.length < 4) {
                              return 'Pin should be of 4 digit';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  OrientationSwitcher(
                    children: [
                      Flexible(
                        child: UserTextFormField(
                          label: "Re-Enter 4 Digit Transaction Pin",
                          hintText: "X X X X",
                          controller: reEnterPinController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (v) {
                            if (v.length > 4) {
                              v = v.substring(0, 4);
                              pinController.text = v.substring(0, 4);
                              pinController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: pinController.text.length));

                              showToast('Pin Cannot be greater than 4 digits',
                                  context,
                                  type: 'warning');
                            }
                            _reEnterPin = v;
                          },
                          validator: (v) {
                            if (v.isEmpty) {
                              return "This field is required.";
                            } else if (v != pinController.text) {
                              return 'Pins Do Not Match';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  if (saving)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            saving = true;
                          });

                          var _body = {};

                          _body['emailid'] = userData['email'];
                          _body['password'] = passwordController.text;
                          _body['device'] = '';
                          var _response = await signIn(_body);

                          if (_response['res'] == 'failed') {
                            // if (_response['messg'] ==
                            //     "Sorry! Incorrect password") {
                            //   _response['messg'] =
                            //   "Password incorrect. Kindly check again.";
                            // }
                            passwordController.text = "";
                            passwordErrorText =
                                "Password incorrect. Kindly check again.";
                            setState(() {
                              saving = false;
                            });
                          } else {
                            _body = {};
                            _body['panNumber'] = userData['panNumber'];
                            _body['email'] = userData['email'];
                            _body['transaction_pin'] = _reEnterPin;
                            print('Body : $_body');
                            _response = await updateTransactionPin(_body);
                            //capsaPrint('passs 1 $_response ${_response[0]}');
                            if (_response['res'] == 'success') {
                              showToast('Pin Updated Successfully', context);
                            } else {
                              showToast(_response, context,
                                  type: 'warning');
                            }
                            if(Beamer.of(context).canBeamBack) {
                              Beamer.of(context).beamBack();
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CapsaHome(),
                                ),
                              );
                            }
                            // Beamer.of(context).beamBack();
                          }
                        }
                      },
                      child: Container(
                          width: Responsive.isMobile(context)
                              ? MediaQuery.of(context).size.width * 0.8
                              : MediaQuery.of(context).size.width * 0.2,
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
                                          0.2,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Generate Pin',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  242, 242, 242, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 18,
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
                    ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
