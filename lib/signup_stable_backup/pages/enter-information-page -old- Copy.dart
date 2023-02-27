import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';

import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EnterInformationPage extends StatefulWidget {
  const EnterInformationPage({Key key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<EnterInformationPage> {
  final formKey = GlobalKey<FormState>();

  final directorNameController0 = TextEditingController();
  final phoneController = TextEditingController();

  final idFileController0 = TextEditingController();

  final bvnController0 = TextEditingController();
  final emailController0 = TextEditingController();

  final accountController0 = TextEditingController();
  final nnNumberController0 = TextEditingController();

  String _errorMsg1 = '';
  String _errorMsg2 = '';
  String _errorMsg3 = '';
  String _errorMsg4 = '';
  String _errorMsg5 = '';
  String _errorMsg6 = '';
  String _errorMsg7 = '';

  bool processing = false;
  bool isDone = false;

  String text1 = "Get started on";
  String text2 = "Capsa";
  String text3 = "Capsa";

  String role = "";
  String role2 = "";

  String type = "";
  String type2 = "";

  final box = Hive.box('capsaBox');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var _body = box.get('signUpData') ?? {};

    bvnController0.text = _body['panNumber'];
    emailController0.text = _body['email'];

    role = _body['role'];
    role2 = _body['ROLE'] ?? '';

    if (role2 == '') {
      text1 = "Director Information";
      text2 = "";
    } else {
      text1 = "Personal Information";
      text2 = "";
    }

    initCall();
  }

  List<BankList> bankList = [];
  var bankName;
  BankList bank;
  var bankID;
  var accountNo;
  bool isloaded = false;

  void initCall() async {
    if (role == "COMPANY") {
      final _actionProvider =
          Provider.of<SignUpActionProvider>(context, listen: false);
      dynamic _data = await _actionProvider.getBank();

      // capsaPrint(_data);

      if (_data['res'] == 'success') {
        _data['data']
            .sort((a, b) => a.name.compareTo(b.name))
            .forEach((element) {
          BankList _bb =
              BankList(element['id'].toString(), element['name'].toString());
          bankList.add(_bb);
        });
        bankList.sort((a, b) => a.name.compareTo(b.name));
        setState(() {
          isloaded = true;
        });
      }
    } else {
      setState(() {
        isloaded = true;
      });
    }
  }

  PlatformFile idFile;

  pickFile(TextEditingController controller, String type) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png'],
    );

    if (result != null) {
      if (result.files.first.extension == 'jpg' ||
          result.files.first.extension == 'png' ||
          result.files.first.extension == 'jpeg' ||
          result.files.first.extension == 'pdf') {
        setState(() {
          if (type == 'id') {
            idFile = result.files.first;
            idFileController0.text = idFile.name;
          }
        });
      } else {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                    'Invalid Format Selected. Please Select Another File'),
                actions: <Widget>[
                  TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context)),
                ],
              );
            });
      }
    } else {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('No File selected'),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context)),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (!Responsive.isMobile(context))
          ? null
          : AppBar(
              toolbarHeight: 75,
              title: Text(text1),
            ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: formKey,
            child: Padding(
              padding: Responsive.isMobile(context)
                  ? EdgeInsets.zero
                  : EdgeInsets.fromLTRB(45, 20, 45, 10),
              child: Padding(
                padding: Responsive.isMobile(context)
                    ? EdgeInsets.fromLTRB(8, 0, 8, 0)
                    : EdgeInsets.only(left: 28.0, right: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    if (!Responsive.isMobile(context)) topHeading(),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!Responsive.isMobile(context))
                            Image.asset(
                              (role != "COMPANY")
                                  ? "assets/images/Progress2.png"
                                  : "assets/images/Progress3-2.png",
                              height: 35,
                            ),
                          if (Responsive.isMobile(context))
                            Image.asset(
                              (role != "COMPANY")
                                  ? "assets/images/Progress m -2.png"
                                  : "assets/images/Progress m3-1.png",
                              height: 40,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    if (!isloaded)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    else
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!Responsive.isMobile(context))
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                    "Which of the Directors is getting onboarded on Capsa?"),
                              ),
                            SizedBox(
                              height: 22,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: OrientationSwitcher(
                                children: [
                                  Flexible(
                                    child: UserTextFormField(
                                      padding:
                                          EdgeInsets.only(bottom: 2, top: 2),
                                      label: (type2 == '')
                                          ? 'Director’s Name'
                                          : 'Name',
                                      // prefixIcon: Image.asset("assets/images/currency.png"),
                                      hintText: 'Capsa Technology',
                                      controller: directorNameController0,
                                      // initialValue: '',
                                      errorText: _errorMsg2,
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return 'Director\'s Name is required';
                                        }

                                        return null;
                                      },
                                      onChanged: (v) {},
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Flexible(
                                    child: UserTextFormField(
                                      padding:
                                          EdgeInsets.only(bottom: 2, top: 2),
                                      label: "Phone Number",
                                      // prefixIcon: Image.asset("assets/images/currency.png"),
                                      hintText: "801234567",
                                      controller: phoneController,
                                      // initialValue: '',
                                      errorText: _errorMsg3,
                                      validator: (value) {
                                        // if (value.trim().isEmpty) {
                                        //   return 'Phone Number is required';
                                        // }
                                        if (value.length < 10) {
                                          return 'Kindly check the phone number again';
                                        }

                                        return null;
                                      },
                                      onChanged: (v) {},
                                      keyboardType: TextInputType.number,

                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (role == "COMPANY")
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: OrientationSwitcher(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          UserTextFormField(
                                            padding: EdgeInsets.only(
                                                bottom: 2, top: 2),
                                            label: "Bank Name",
                                            // prefixIcon: Image.asset("assets/images/currency.png"),
                                            hintText: '',
                                            textFormField:
                                                DropdownButtonFormField<
                                                    BankList>(
                                              isExpanded: true,
                                              dropdownColor: Colors.white,
                                              validator: (BankList val) {
                                                capsaPrint('$val');
                                                if (val == null ||
                                                    val.id.isEmpty) {
                                                  return 'Cannot be empty';
                                                }
                                                return null;
                                              },
                                              // value: _tmpBankDetails,
                                              items: bankList
                                                  .map<
                                                      DropdownMenuItem<
                                                          BankList>>((data) =>
                                                      new DropdownMenuItem<
                                                          BankList>(
                                                        value: data,
                                                        child: Text(data.name),
                                                      ))
                                                  .toList(),
                                              onChanged: (BankList newValue) {
                                                bank = newValue;
                                                bankName = newValue.name;
                                                bankID = newValue.id;
                                              },

                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText:
                                                    "Select Bank Name from Dropdown",
                                                hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        130, 130, 130, 1),
                                                    fontSize: 14,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 8.0,
                                                        bottom: 12.0,
                                                        top: 12.0),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.7),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.7),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          UserTextFormField(
                                            padding: EdgeInsets.only(
                                                bottom: 2, top: 2),
                                            label: "Bank Account Number",
                                            // prefixIcon: Image.asset("assets/images/currency.png"),
                                            hintText: '0022334455',
                                            controller: accountController0,
                                            // initialValue: '',
                                            // readOnly: true,
                                            errorText: _errorMsg6,
                                            validator: (value) {
                                              if (value.trim().isEmpty) {
                                                return 'Account Number is required';
                                              }

                                              return null;
                                            },
                                            onChanged: (v) {},
                                            keyboardType: TextInputType.number,
                                            maxLengthEnforcement:
                                                MaxLengthEnforcement.enforced,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: OrientationSwitcher(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: UserTextFormField(
                                      padding:
                                          EdgeInsets.only(bottom: 2, top: 2),
                                      label: "Bank Verification Number (BVN)",
                                      // prefixIcon: Image.asset("assets/images/currency.png"),
                                      hintText: '',
                                      controller: bvnController0,
                                      // initialValue: '',
                                      readOnly: true,
                                      errorText: _errorMsg6,
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return '  Number is required';
                                        }

                                        return null;
                                      },
                                      onChanged: (v) {},
                                      keyboardType: TextInputType.number,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height:
                                        Responsive.isMobile(context) ? 20 : 0,
                                  ),
                                  // Flexible(
                                  //   child: UserTextFormField(
                                  //     padding: EdgeInsets.only(bottom: 2, top: 2),
                                  //     label: "NIN / Voters or Passport Number",
                                  //     // prefixIcon: Image.asset("assets/images/currency.png"),
                                  //     hintText: 'Enter the number on your ID',
                                  //     controller: nnNumberController0,
                                  //     // initialValue: '',
                                  //     // readOnly: true,
                                  //     errorText: _errorMsg5,
                                  //     validator: (value) {
                                  //       if (value.trim().isEmpty) {
                                  //         return 'NIN / Voters or Passport Number is required';
                                  //       }

                                  //       return null;
                                  //     },
                                  //     onChanged: (v) {},
                                  //     keyboardType: TextInputType.text,
                                  //     // keyboardType: TextInputType.number,
                                  //     // maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                  //     // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(10),],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: OrientationSwitcher(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        UserTextFormField(
                                          padding: EdgeInsets.only(
                                              bottom: 0, top: 2),
                                          label: 'Upload Valid ID',
                                          // prefixIcon: Image.asset("assets/images/currency.png"),
                                          hintText: 'PDF or Image file',
                                          controller: idFileController0,
                                          // initialValue: '',
                                          onTap: () =>
                                              pickFile(idFileController0, 'id'),
                                          readOnly: true,
                                          errorText: _errorMsg4,
                                          validator: (value) {
                                            if (value.trim().isEmpty) {
                                              return 'ID is required';
                                            }

                                            return null;
                                          },
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              "assets/images/upload-Icons.png",
                                              height: 14,
                                            ),
                                          ),
                                          onChanged: (v) {},
                                          keyboardType: TextInputType.text,
                                        ),
                                        Text(
                                          "Accepted Valid ID: National ID Card, Voter’s Card,  Driver’s licence, or Passport.",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(),
                                  )
                                ],
                              ),
                            ),

                            if (!isDone)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 22.0, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        child: InkWell(
                                          onTap: () {
                                            context.beamBack();
                                          },
                                          child: Text(
                                            'Previous',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    51, 51, 51, 1),
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
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: processing
                                            ? CircularProgressIndicator()
                                            : InkWell(
                                                onTap: () async {
                                                  if (formKey.currentState
                                                      .validate()) {
                                                    setState(() {
                                                      processing = true;
                                                    });
                                                    var _body = {};

                                                    _body['bvnNumber'] =
                                                        bvnController0.text;
                                                    _body['panNumber'] =
                                                        bvnController0.text;
                                                    _body['bvnNo'] =
                                                        bvnController0.text;
                                                    _body['email'] =
                                                        emailController0.text;

                                                    _body['phone'] = '0' +
                                                        phoneController.text;
                                                    _body['idFile'] =
                                                        idFileController0.text;
                                                    _body['directorName'] =
                                                        directorNameController0
                                                            .text;

                                                    _body['role'] = role;

                                                    _body['acctType'] = type2;
                                                    _body['userType'] = type;
                                                    var _dataSend = {};
                                                    final _actionProvider = Provider
                                                        .of<SignUpActionProvider>(
                                                            context,
                                                            listen: false);

                                                    if (role == "COMPANY") {
                                                      var _body1 = {};

                                                      if (bankName != null)
                                                        _body1['bankName'] =
                                                            bankName;

                                                      if (bankID != null)
                                                        _body1['bankID'] =
                                                            bankID;

                                                      if (accountController0
                                                              .text !=
                                                          '')
                                                        _body1['accountNum'] =
                                                            accountController0
                                                                .text;

                                                      var _response1 =
                                                          await _actionProvider
                                                              .verifyAccountBVN(
                                                                  _body1);

                                                      if (_response1['res'] !=
                                                          'success') {
                                                        showToast(
                                                            _response1['messg'],
                                                            context,
                                                            type: 'warning');

                                                        setState(() {
                                                          processing = false;
                                                        });
                                                        return;
                                                      }
                                                      _dataSend =
                                                          _response1['data'];
                                                      capsaPrint('$_dataSend');

                                                      // setState(() {
                                                      //   processing = false;
                                                      // });

                                                      if (_dataSend['name'] !=
                                                          directorNameController0
                                                              .text) {
                                                        String text11 =
                                                            "The name link to this account does not match the Director’s Name";
                                                      }
                                                      // return;

                                                      // setState(() {
                                                      //   processing = true;
                                                      // });

                                                      var _response =
                                                          await _actionProvider
                                                              .saveDetails2(
                                                                  _body,
                                                                  idFile);
                                                      _body['pas'] = '';
                                                      _body['cPas'] = '';

                                                      if (_response != null) {
                                                        if (_response['res'] ==
                                                            'failed') {
                                                          setState(() {
                                                            processing = false;
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  _response[
                                                                      'messg']),
                                                              action:
                                                                  SnackBarAction(
                                                                label: 'Ok',
                                                                onPressed: () {
                                                                  // Code to execute.
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        } else if (_response[
                                                                'res'] ==
                                                            'success') {
                                                          var _body01 = box.get(
                                                                  'signUpData') ??
                                                              {};
                                                          _body01['phoneNo'] =
                                                              phoneController
                                                                  .text;
                                                          _body01['aPhoneNo'] =
                                                              _dataSend['num'];
                                                          box.put('signUpData',
                                                              _body01);
                                                          setState(() {
                                                            processing = false;
                                                          });
                                                          Beamer.of(context)
                                                              .beamToNamed(
                                                                  '/mobile-otp');
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
                                                        processing = true;
                                                      });

                                                      var _response =
                                                          await _actionProvider
                                                              .saveDetails2(
                                                                  _body,
                                                                  idFile);
                                                      _body['pas'] = '';
                                                      _body['cPas'] = '';

                                                      if (_response != null) {
                                                        if (_response['res'] ==
                                                            'failed') {
                                                          setState(() {
                                                            processing = false;
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  _response[
                                                                      'messg']),
                                                              action:
                                                                  SnackBarAction(
                                                                label: 'Ok',
                                                                onPressed: () {
                                                                  // Code to execute.
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        } else if (_response[
                                                                'res'] ==
                                                            'success') {
                                                          var _body1 = box.get(
                                                                  'signUpData') ??
                                                              {};
                                                          _body1['phoneNo'] =
                                                              phoneController
                                                                  .text;
                                                          box.put('signUpData',
                                                              _body1);
                                                          setState(() {
                                                            processing = false;
                                                          });
                                                          Beamer.of(context)
                                                              .beamToNamed(
                                                                  '/mobile-otp');
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
                                                  }
                                                },
                                                child: Text(
                                                  'Next',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 152, 219, 1),
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // if(!isDone)
                            //   Container(
                            //     width: double.maxFinite,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.all(Radius.circular(22)),
                            //       color: Color(0xFFf2f8fb),
                            //     ),
                            //     padding: EdgeInsets.all(8),
                            //     child: Row(
                            //       children: [
                            //         Text("Already have an account?"),
                            //         SizedBox(
                            //           width: 3,
                            //         ),
                            //         InkWell(
                            //           onTap: () {
                            //             // sign_in
                            //             Beamer.of(context).beamToNamed('/sign_in');
                            //           },
                            //           child: Text(
                            //             'Sign in',
                            //             style: TextStyle(color: Theme
                            //                 .of(context)
                            //                 .primaryColor),
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
                fontSize: 22,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          if (text2 != '')
            SizedBox(
              height: 10,
            ),
          if (text2 != '')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text2,
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
                SizedBox(
                  width: 10,
                ),
                Text(
                  text3,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: HexColor("#0098DB"),
                      fontFamily: 'Poppins',
                      fontSize: 20,
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

class BankList {
  final String name;
  final String id;

  const BankList(this.id, this.name);

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}
