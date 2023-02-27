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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  final codePhoneController = TextEditingController(text: '(+234)');

  // final emailController = TextEditingController();

  final idFileController0 = TextEditingController();

  final bvnController0 = TextEditingController();
  final emailController0 = TextEditingController();
  final emailControllerNew = TextEditingController();

  final accountController0 = TextEditingController();
  final nnNumberController0 = TextEditingController();

  String _errorMsg1 = '';
  String _errorMsg2 = '';
  String _errorMsg8 = '';
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
  String rcNum = "";

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
    rcNum = _body['usercac'] ?? '';

    capsaPrint(_body);

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
  List<DirectorModel> directorList = [];
  DirectorModel _directorModelSelected;
  var bankName;
  BankList bank;
  var bankID;
  var accountNo;
  bool isloaded = false;

  bool isDirectSet = false;

  void initCall() async {
    final _actionProvider =
        Provider.of<SignUpActionProvider>(context, listen: false);
    var _body = {'rcnum': rcNum};

    dynamic _data2 = await _actionProvider.getDirectorByRc(_body);

    // capsaPrint('_data2');
    // capsaPrint(_data2);

    if (_data2['res'] == 'success') {
      _data2['data']['directorList'].forEach((element) {
        DirectorModel _directorModel = DirectorModel(
          name: element['name'],
          email: element['email'],
          id_number: element['id_number'],
          id_type: element['id_type'],
          phone: element['phone'],
          role: element['role'],
        );
        directorList.add(_directorModel);
      });
      // if (role != "COMPANY")
      //   setState(() {
      //     isloaded = true;
      //   });
    }

    directorList.add(DirectorModel(name: "Not included in the list"));

    // if (role == "COMPANY") {
    dynamic _data = await _actionProvider.getBank();
    // _body[''] =

    if (_data['res'] == 'success') {
      capsaPrint(_data['data']);
      _data['data'].forEach((element) {
        BankList _bb =
            BankList(element['id'].toString(), element['name'].toString());

        bankList.add(_bb);
      });
      bankList.sort((a, b) => a.name.compareTo(b.name));
      await setUserText();
      setState(() {
        isloaded = true;
      });
    }
    // } else {
    //   await setUserText();
    //
    //   setState(() {
    //     isloaded = true;
    //   });
    // }
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

  List _widget = <Widget>[];

  Future setUserText() {
    var _tmp = [
      UserTextFormField(
        padding: EdgeInsets.only(bottom: 2, top: 2),
        label: "Director",
        // prefixIcon: Image.asset("assets/images/currency.png"),
        hintText: '',
        textFormField: DropdownButtonFormField<DirectorModel>(
          isExpanded: true,
          dropdownColor: Colors.white,
          validator: (DirectorModel val) {
            // capsaPrint(val);
            if (val == null) {
              return 'Cannot be empty';
            }
            return null;
          },
          // value: _tmpBankDetails,
          items: directorList
              .map<DropdownMenuItem<DirectorModel>>(
                  (data) => new DropdownMenuItem<DirectorModel>(
                        value: data,
                        child: Text(data.name),
                      ))
              .toList(),
          onChanged: (DirectorModel newValue) async {
            _directorModelSelected = null;
            directorNameController0.text = '';
            if (newValue.name != 'Not included in the list') {
              directorNameController0.text = newValue.name;
              newValue.phone = newValue.phone.substring(
                  (newValue.phone.length - 10).clamp(0, newValue.phone.length));
              if (newValue.phone != null && newValue.phone != '') {
                _directorModelSelected = newValue;
                var pNum = newValue.phone;
                // pNum = pNum.substring((pNum.length - 10).clamp(0, pNum.length));
                phoneController.text = pNum;
              }
              if (newValue.email != null && newValue.email != '') {
                emailControllerNew.text = newValue.email;
              }
            }
            isDirectSet = true;

            setState(() {
              isloaded = false;
            });

            await setUserText();

            setState(() {
              isloaded = true;
            });
          },

          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            hintText: "Select from list",
            hintStyle: TextStyle(
                color: Color.fromRGBO(130, 130, 130, 1),
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
            contentPadding:
                const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 12.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15.7),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15.7),
            ),
          ),
        ),
      ),
    ];

    var _tmp2 = [
      UserTextFormField(
        padding: EdgeInsets.only(bottom: 2, top: 2),
        label: (type2 == '') ? 'Director’s Name' : 'Name',
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
      Row(
        children: [
          SizedBox(
            width: 58,
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
              padding: EdgeInsets.only(bottom: 2, top: 2),
              label: "Number",
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

              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ),
        ],
      ),
      if (_directorModelSelected != null)
        UserTextFormField(
          padding: EdgeInsets.only(bottom: 2, top: 2),
          label: "Email Address",
          // prefixIcon: Image.asset("assets/images/currency.png"),
          hintText: "email address will appear here",
          controller: emailControllerNew,
          // initialValue: '',
          errorText: _errorMsg8,
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
          keyboardType: TextInputType.number,

          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
      // if (role == "COMPANY")
      if (_directorModelSelected == null)
        UserTextFormField(
          padding: EdgeInsets.only(bottom: 25, top: 2),
          label: "Bank Name",
          note: 'This should be a personal bank account',
          // prefixIcon: Image.asset("assets/images/currency.png"),
          hintText: '',
          textFormField: DropdownButtonFormField<BankList>(
            isExpanded: true,
            dropdownColor: Colors.white,
            validator: (BankList val) {
              capsaPrint('$val');
              if (val == null || val.id.isEmpty) {
                return 'Cannot be empty';
              }
              return null;
            },
            // value: _tmpBankDetails,
            items: bankList
                .map<DropdownMenuItem<BankList>>(
                    (data) => new DropdownMenuItem<BankList>(
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
              hintText: "Select Bank Name from Dropdown",
              hintStyle: TextStyle(
                  color: Color.fromRGBO(130, 130, 130, 1),
                  fontSize: 14,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
              contentPadding:
                  const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 12.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(15.7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(15.7),
              ),
            ),
          ),
        ),
      // if (role == "COMPANY")
      if (_directorModelSelected == null)
        UserTextFormField(
          padding: EdgeInsets.only(bottom: 2, top: 2),
          label: "Bank Account Number",
          note: 'This should be a personal bank account',
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
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
      UserTextFormField(
        padding: EdgeInsets.only(bottom: 2, top: 2),
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
      ),
      // UserTextFormField(
      //   padding: EdgeInsets.only(bottom: 2, top: 2),
      //   label: "NIN / Voters or Passport Number",
      //   // prefixIcon: Image.asset("assets/images/currency.png"),
      //   hintText: 'Enter the number on your ID',
      //   controller: nnNumberController0,
      //   // initialValue: '',
      //   // readOnly: true,
      //   errorText: _errorMsg5,
      //   validator: (value) {
      //     if (value.trim().isEmpty) {
      //       return 'NIN / Voters or Passport Number is required';
      //     }

      //     return null;
      //   },
      //   onChanged: (v) {},
      //   keyboardType: TextInputType.text,
      //   // keyboardType: TextInputType.number,
      //   // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      //   // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(10),],
      // ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserTextFormField(
            padding: EdgeInsets.only(bottom: 2, top: 2),
            label: 'Upload Valid ID',
            // prefixIcon: Image.asset("assets/images/currency.png"),
            hintText: 'PDF or Image file',
            controller: idFileController0,
            // initialValue: '',
            onTap: () => pickFile(idFileController0, 'id'),
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
    ];
    _widget = [];

    if (!isDirectSet) {
      _widget.addAll(_tmp);
    } else {
      _widget.addAll(_tmp2);
    }

    // return _widget;

    return Future.delayed(Duration.zero);
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Scrollbar(
          isAlwaysShown: true,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: Responsive.isMobile(context)
                    ? EdgeInsets.zero
                    : EdgeInsets.fromLTRB(45, 20, 45, 15),
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
                      if (!Responsive.isMobile(context))
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                              "Which of the Directors is getting onboarded on Capsa?"),
                        ),
                      SizedBox(
                        height: 10,
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
                          // width: 600,
                          height: MediaQuery.of(context).size.height *
                                  (!isDirectSet ? 1 : 0.9) -
                              (!isDirectSet ? 300 : 100) -
                              (_directorModelSelected != null ? 100 : 30),
                          child: StaggeredGridView.countBuilder(
                              crossAxisCount:
                                  Responsive.isMobile(context) ? 1 : 2,
                              crossAxisSpacing:
                                  Responsive.isMobile(context) ? 10 : 15,
                              mainAxisSpacing:
                                  Responsive.isMobile(context) ? 10 : 5,
                              padding: EdgeInsets.all(3),
                              staggeredTileBuilder: (int index) =>
                                  StaggeredTile.fit(1),
                              // shrinkWrap: true,
                              itemCount: _widget.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return _widget[index];
                              }),
                        ),
                      if (isloaded)
                        if (!isDone)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, bottom: 50, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    child: InkWell(
                                      onTap: () async {
                                        if (isDirectSet) {
                                          isDirectSet = false;

                                          setState(() {
                                            isloaded = false;
                                          });

                                          await setUserText();

                                          setState(() {
                                            isloaded = true;
                                          });
                                          return;
                                        }
                                        context.beamBack();
                                      },
                                      child: Text(
                                        'Previous',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1),
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
                                    padding: const EdgeInsets.only(
                                        top: 0.0, left: 10, right: 10),
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

                                                _body['phone'] =
                                                    '0' + phoneController.text;
                                                _body['idFile'] =
                                                    idFileController0.text;

                                                _body['directorName'] =
                                                    directorNameController0
                                                        .text;
                                                _body['ninId'] =
                                                    nnNumberController0.text;
                                                _body['newEmail'] =
                                                    emailControllerNew.text;

                                                _body['role'] = role;

                                                _body['acctType'] = type2;
                                                _body['userType'] = type;
                                                var _dataSend = {};
                                                final _actionProvider = Provider
                                                    .of<SignUpActionProvider>(
                                                        context,
                                                        listen: false);

                                                // if (role == "COMPANY") {
                                                var _body1 = {};

                                                if (bankName != null)
                                                  _body1['bankName'] = bankName;

                                                if (bankID != null)
                                                  _body1['bankID'] = bankID;

                                                if (rcNum != null)
                                                  _body1['rcNum'] = rcNum;

                                                if (accountController0.text !=
                                                    '')
                                                  _body1['accountNum'] =
                                                      accountController0.text;

                                                if (directorNameController0
                                                        .text !=
                                                    '')
                                                  _body1['directorName'] =
                                                      directorNameController0
                                                          .text;

                                                if (_directorModelSelected ==
                                                    null) {
                                                  var _response1 =
                                                      await _actionProvider
                                                          .verifyAccountBVN(
                                                              _body1);

                                                  if (_response1['res'] !=
                                                      'success') {
                                                    // if(_response1['messg'] == ""){
                                                    //   _errorMsg2 = "";
                                                    // }

                                                    _errorMsg2 =
                                                        _response1['messg'];
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
                                                } else {
                                                  _dataSend['num'] =
                                                      _directorModelSelected
                                                          .phone;
                                                }
                                                // capsaPrint(_dataSend);

                                                // setState(() {
                                                //   processing = false;
                                                // });

                                                // if (_dataSend['name'] != directorNameController0.text) {
                                                //   String text11 = "The name link to this account does not match the Director’s Name";
                                                // }
                                                // return;

                                                // setState(() {
                                                //   processing = true;
                                                // });

                                                var _response =
                                                    await _actionProvider
                                                        .saveDetails2(
                                                            _body, idFile);
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
                                                            _response['messg']),
                                                        action: SnackBarAction(
                                                          label: 'Ok',
                                                          onPressed: () {
                                                            // Code to execute.
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  } else if (_response['res'] ==
                                                      'success') {
                                                    var _body01 =
                                                        box.get('signUpData') ??
                                                            {};
                                                    _body01['phoneNo'] =
                                                        phoneController.text;
                                                    _body01['aPhoneNo'] =
                                                        _dataSend['num'];
                                                    box.put(
                                                        'signUpData', _body01);
                                                    box.put(
                                                        'newEmail',
                                                        emailControllerNew
                                                            .text);

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
                                                // } else {
                                                //   setState(() {
                                                //     processing = true;
                                                //   });
                                                //
                                                //   if (_directorModelSelected == null) {
                                                //     var _response1 = await _actionProvider.verifyAccountBVN(_body1);
                                                //
                                                //     if (_response1['res'] != 'success') {
                                                //       // if(_response1['messg'] == ""){
                                                //       //   _errorMsg2 = "";
                                                //       // }
                                                //
                                                //       _errorMsg2 = _response1['messg'];
                                                //       showToast(_response1['messg'], context, type: 'warning');
                                                //
                                                //       setState(() {
                                                //         processing = false;
                                                //       });
                                                //       return;
                                                //     }
                                                //     _dataSend = _response1['data'];
                                                //   } else {
                                                //     _dataSend['num'] = _directorModelSelected.phone;
                                                //   }
                                                //
                                                //
                                                //
                                                //   var _response = await _actionProvider.saveDetails2(_body, idFile);
                                                //   _body['pas'] = '';
                                                //   _body['cPas'] = '';
                                                //
                                                //   if (_response != null) {
                                                //     if (_response['res'] == 'failed') {
                                                //       setState(() {
                                                //         processing = false;
                                                //       });
                                                //       ScaffoldMessenger.of(context).showSnackBar(
                                                //         SnackBar(
                                                //           content: Text(_response['messg']),
                                                //           action: SnackBarAction(
                                                //             label: 'Ok',
                                                //             onPressed: () {
                                                //               // Code to execute.
                                                //             },
                                                //           ),
                                                //         ),
                                                //       );
                                                //     } else if (_response['res'] == 'success') {
                                                //       var _body1 = box.get('signUpData') ?? {};
                                                //       _body1['phoneNo'] = phoneController.text;
                                                //       box.put('signUpData', _body1);
                                                //       box.put('newEmail', emailControllerNew.text);
                                                //
                                                //       setState(() {
                                                //         processing = false;
                                                //       });
                                                //       Beamer.of(context).beamToNamed('/mobile-otp');
                                                //     } else {
                                                //       setState(() {
                                                //         processing = false;
                                                //       });
                                                //     }
                                                //   } else {
                                                //     setState(() {
                                                //       processing = false;
                                                //     });
                                                //   }
                                                // }
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
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
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

class DirectorModel {
  final String email;
  final String id_number;
  final String id_type;
  final String name;
  String phone;
  final String role;

  DirectorModel(
      {this.email,
      this.id_number,
      this.id_type,
      this.name,
      this.phone,
      this.role});

  Map<String, dynamic> toJson() => {
        'name': name,
        'id_number': id_number,
        'email': email,
        'id_type': id_type,
        'phone': phone,
        'role': role,
      };
}
