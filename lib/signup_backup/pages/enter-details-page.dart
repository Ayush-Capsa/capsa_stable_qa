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

class EnterDetailsPage extends StatefulWidget {
  const EnterDetailsPage({Key key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<EnterDetailsPage> {
  final formKey = GlobalKey<FormState>();

  final rcController0 = TextEditingController();
  final firstController0 = TextEditingController();
  final nameController0 = TextEditingController();
  final addressController0 = TextEditingController();
  final industryController0 = TextEditingController();
  final dateController0 = TextEditingController();
  final cacCertificateController0 = TextEditingController();
  final cacForm7Controller0 = TextEditingController();
  final idFileController0 = TextEditingController();
  final bvnController0 = TextEditingController();
  final emailController0 = TextEditingController();
  final ninController = TextEditingController();

  final phoneController = TextEditingController();
  final codePhoneController = TextEditingController(text: '(+234)');

  String _errorMsg1 = '';
  String _errorMsg2 = '';
  String _errorMsg3 = '';
  String _errorMsg4 = '';
  String _errorMsg5 = '';
  String _errorMsg6 = '';
  String _errorMsg7 = '';
  String _errorMsg8 = '';
  String _errorMsg9 = '';

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

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        callRCDetails();
      }
    });
    var _body = box.get('signUpData') ?? {};

    nameController0.text = _body['name'];
    bvnController0.text = _body['panNumber'];
    emailController0.text = _body['email'];
    // phoneNoController0.text = _body['phoneNo'] ?? '';
    role = _body['role'];
    role2 = _body['ROLE2'];

    // capsaPrint('_body');
    // capsaPrint(_body);

    text1 = "Company Information";
    text2 = "";

    if (role2 == 'individual') {
      text1 = "Personal Information";
      text2 = "";
    }
  }

  DateTime _selectedDate;

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                surface: Theme.of(context).primaryColor,
                // onSurface: Colors.yellow,
              ),
              // dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      dateController0
        ..text = DateFormat('dd/MM/y').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateController0.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  PlatformFile ccFile, f7File, idFile;

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
          if (type == 'cc') {
            ccFile = result.files.first;
            cacCertificateController0.text = ccFile.name;
          } else if (type == 'f7') {
            f7File = result.files.first;
            cacForm7Controller0.text = f7File.name;
          } else if (type == 'id') {
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

  var focusNode = FocusNode();

  bool isRcOk = false;

  callRCDetails() async {
    if (rcController0.text.length < 5) return;

    final _actionProvider =
        Provider.of<SignUpActionProvider>(context, listen: false);
    var _body = {
      'rcnum': rcController0.text.trim(),
      'checkExits': 'checkExits'
    };
    focusNode.nextFocus();

    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('Loading...'),
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20,
            ),
            Text('Loading ...'),
          ],
        ),
        actions: <Widget>[],
      ),
    );

    addressController0.text = '';
    dateController0.text = '';
    _selectedDate = null;

    dynamic _data2 = await _actionProvider.getDirectorByRc(_body);

    Navigator.of(context, rootNavigator: true).pop();

    // capsaPrint('_data2');
    // capsaPrint(_data2);

    if (_data2['res'] == 'success') {
      isRcOk = true;
      _errorMsg1 = "";
      addressController0.text = _data2['data']['address'];
      var fdate = _data2['data']['fdate'];
      _selectedDate = new DateFormat("yyyy-MM-dd").parse(fdate);
      dateController0.text = DateFormat('dd/MM/y').format(_selectedDate);
      setState(() {});
    } else {
      isRcOk = false;
      _errorMsg1 =
          "Not able to fetch Company details. Please proceed by\nmanually entering company information.";
      if (_data2['messg'] == "RCNumber already exits") {
        _errorMsg1 =
            "RC Number (" + rcController0.text + ") already registered";
        rcController0.text = '';
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    capsaPrint(role);
    return Scaffold(
      appBar: (!Responsive.isMobile(context))
          ? null
          : AppBar(
              toolbarHeight: 75,
              title: Text(text1),
            ),
      body: Container(
        child: Form(
          key: formKey,
          child: Padding(
            padding: Responsive.isMobile(context)
                ? EdgeInsets.zero
                : EdgeInsets.fromLTRB(45, 45, 45, 5),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: (!Responsive.isMobile(context)) ? 10 : 10,
                    ),
                    if (!Responsive.isMobile(context)) topHeading(),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!Responsive.isMobile(context))
                            Image.asset(
                              (role != "COMPANY")
                                  ? "assets/images/Progress.png"
                                  : "assets/images/Progress3-1.png",
                              height: 35,
                            ),
                          if (Responsive.isMobile(context))
                            Image.asset(
                              (role != "COMPANY")
                                  ? "assets/images/Progress m -1.png"
                                  : "assets/images/Progress m3-1.png",
                              height: 40,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: OrientationSwitcher(
                        children: [
                          if (role2 != 'individual')
                            Flexible(
                              child: UserTextFormField(
                                focusNode: focusNode,
                                padding: EdgeInsets.only(bottom: 2, top: 2),
                                label: "RC/BN Number",
                                // prefixIcon: Image.asset("assets/images/currency.png"),
                                hintText: 'RC1234567',
                                controller: rcController0,
                                // initialValue: '',
                                errorText: _errorMsg1,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'RC Number is required';
                                  }

                                  return null;
                                },

                                keyboardType: TextInputType.text,
                              ),
                            )
                          else
                            Flexible(
                              child: UserTextFormField(
                                padding: EdgeInsets.only(bottom: 2, top: 2),
                                label: "First Name",
                                // prefixIcon: Image.asset("assets/images/currency.png"),
                                hintText: 'Capsa',
                                controller: firstController0,
                                // initialValue: '',
                                errorText: _errorMsg1,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'First Name is required';
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
                              padding: EdgeInsets.only(bottom: 2, top: 2),
                              label: (role2 != 'individual')
                                  ? 'Company’s Name'
                                  : 'Last Name',
                              // prefixIcon: Image.asset("assets/images/currency.png"),
                              hintText: 'Technology',
                              controller: nameController0,
                              // initialValue: '',
                              errorText: _errorMsg2,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return (role2 != 'individual')
                                      ? 'Company Name is required'
                                      : 'Last Name is required';
                                }

                                return null;
                              },
                              onChanged: (v) {},
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (role2 != 'individual')
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: OrientationSwitcher(
                          children: [
                            Flexible(
                              child: UserTextFormField(
                                padding: EdgeInsets.only(bottom: 2, top: 2),
                                label: "Address",
                                // prefixIcon: Image.asset("assets/images/currency.png"),
                                hintText:
                                    "7, Mulliner Towers, Ikoyi, Lagos, Nigeria",
                                controller: addressController0,
                                // initialValue: '',
                                errorText: _errorMsg3,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Address is required';
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
                                padding: EdgeInsets.only(bottom: 2, top: 2),
                                label: 'Industry',
                                // prefixIcon: Image.asset("assets/images/currency.png"),
                                hintText: 'Financial Technology Services',
                                controller: industryController0,
                                // initialValue: '',
                                errorText: _errorMsg4,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Industry is required';
                                  }

                                  return null;
                                },
                                onChanged: (v) {},
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (role2 != 'individual')
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: OrientationSwitcher(
                          children: [
                            Flexible(
                              child: UserTextFormField(
                                padding: EdgeInsets.only(bottom: 2, top: 2),
                                label: "Date Founded",
                                // prefixIcon: Image.asset("assets/images/currency.png"),
                                hintText: "02/24/2019",
                                controller: dateController0,
                                // initialValue: '',
                                errorText: _errorMsg5,
                                onTap: () {
                                  _selectDate(context);
                                },
                                readOnly: true,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Date is required';
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
                                padding: EdgeInsets.only(bottom: 2, top: 2),
                                label: 'Upload CAC Certificate',
                                // prefixIcon: Image.asset("assets/images/currency.png"),
                                hintText: 'PDF or Image file',
                                controller: cacCertificateController0,
                                // initialValue: '',
                                onTap: () =>
                                    pickFile(cacCertificateController0, 'cc'),
                                readOnly: true,
                                errorText: _errorMsg6,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/upload-Icons.png",
                                    height: 14,
                                  ),
                                ),

                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'CAC Certificate is required';
                                  }

                                  return null;
                                },
                                onChanged: (v) {},
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (role2 == 'individual')
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: OrientationSwitcher(
                          children: [
                            Flexible(
                              child: UserTextFormField(
                                padding: EdgeInsets.only(bottom: 2, top: 2),
                                label: "Bank Verification Number (BVN)",
                                // prefixIcon: Image.asset("assets/images/currency.png"),
                                hintText: '',
                                controller: bvnController0,
                                // initialValue: '',
                                readOnly: true,
                                errorText: _errorMsg1,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'BVN is required';
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
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 58,
                                    child: UserTextFormField(
                                      padding:
                                          EdgeInsets.only(bottom: 2, top: 2),
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

                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: UserTextFormField(
                                      padding:
                                          EdgeInsets.only(bottom: 2, top: 2),
                                      label: "Number",
                                      // prefixIcon: Image.asset("assets/images/currency.png"),
                                      hintText: "801234567",
                                      controller: phoneController,
                                      // initialValue: '',
                                      errorText: _errorMsg8,
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return 'Phone Number is required';
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
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: OrientationSwitcher(
                        children: [
                          if (role2 != 'individual')
                            Flexible(
                              child: UserTextFormField(
                                padding: EdgeInsets.only(bottom: 4, top: 4),
                                label: "Upload CAC Form 7",
                                // prefixIcon: Image.asset("assets/images/currency.png"),
                                hintText: "PDF or Image file",
                                controller: cacForm7Controller0,
                                readOnly: true,
                                // initialValue: '',
                                errorText: _errorMsg7,
                                onTap: () =>
                                    pickFile(cacForm7Controller0, 'f7'),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/upload-Icons.png",
                                    height: 14,
                                  ),
                                ),

                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'CAC Form 7 is required';
                                  }

                                  return null;
                                },
                                onChanged: (v) {},
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          if (role2 == 'individual')
                            Flexible(
                              child: Column(
                                children: [
                                  UserTextFormField(
                                    padding: EdgeInsets.only(bottom: 0, top: 4),
                                    label: "Upload Valid ID",
                                    // prefixIcon: Image.asset("assets/images/currency.png"),
                                    hintText: "PDF or Image file",
                                    controller: idFileController0,
                                    readOnly: true,
                                    // initialValue: '',
                                    errorText: _errorMsg7,
                                    onTap: () =>
                                        pickFile(idFileController0, 'id'),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "assets/images/upload-Icons.png",
                                        height: 14,
                                      ),
                                    ),

                                    validator: (value) {
                                      if (value.trim().isEmpty) {
                                        return 'CAC Form 7 is required';
                                      }

                                      return null;
                                    },
                                    onChanged: (v) {},
                                    keyboardType: TextInputType.text,
                                  ),
                                  Text(
                                      "Accepted Valid ID: National ID Card, Voter’s Card,  Driver’s licence, or Passport"),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            width: 50,
                          ),
                          // if (role2 == 'individual')
                          //   Flexible(
                          //     child: UserTextFormField(
                          //       padding: EdgeInsets.only(bottom: 2, top: 2),
                          //       label: "NIN / Voters or Passport Number",
                          //       // prefixIcon: Image.asset("assets/images/currency.png"),
                          //       hintText: "Enter the number on your ID",
                          //       controller: ninController,
                          //       // initialValue: '',
                          //       errorText: _errorMsg9,
                          //       validator: (value) {
                          //         if (value.trim().isEmpty) {
                          //           return 'NIN / Voters or Passport Number is required';
                          //         }

                          //         return null;
                          //       },
                          //       onChanged: (v) {},
                          //       keyboardType: TextInputType.text,
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    if (!isDone)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                  // child:
                                  // InkWell(
                                  //   onTap: (){
                                  //     context.beamBack();
                                  //   },
                                  //   child: Text('Previous', textAlign: TextAlign.left, style: TextStyle(
                                  //       color: Color.fromRGBO(51, 51, 51, 1),
                                  //       fontFamily: 'Poppins',
                                  //       fontSize: 16,
                                  //       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  //       fontWeight: FontWeight.normal,
                                  //       height: 1
                                  //   ),),
                                  // ),
                                  ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: processing
                                    ? CircularProgressIndicator()
                                    : InkWell(
                                        onTap: () async {
                                          // if (role2 != 'individual'){
                                          //
                                          //   if(!isRcOk) {
                                          //     showToast("Cannot find company with the RC Number on CAC.", context);
                                          //     return ;
                                          //   }
                                          // }

                                          if (formKey.currentState.validate()) {
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

                                            _body['address'] =
                                                addressController0.text;
                                            _body['industry'] =
                                                industryController0.text;
                                            _body['rcNumber'] =
                                                rcController0.text;
                                            // _body['ninId'] = ninController.text;

                                            if (_selectedDate != null)
                                              _body['founded'] =
                                                  _selectedDate.toString();
                                            else
                                              _body['founded'] = '';

                                            if (role2 != 'individual')
                                              _body['name'] =
                                                  nameController0.text;
                                            else
                                              _body['name'] =
                                                  firstController0.text +
                                                      ' ' +
                                                      nameController0.text;

                                            // if(phoneController.text )
                                            _body['phone'] =
                                                '0' + phoneController.text;

                                            _body['role'] = role;
                                            _body['role2'] = role2 ?? '';

                                            _body['acctType'] = type2;
                                            _body['userType'] = type;

                                            // capsaPrint('_body');
                                            // capsaPrint(_body);

                                            final _actionProvider = Provider.of<
                                                    SignUpActionProvider>(
                                                context,
                                                listen: false);
                                            var _response;
                                            if (role2 != 'individual')
                                              _response = await _actionProvider
                                                  .saveDetails1(
                                                      _body, ccFile, f7File);
                                            else
                                              _response = await _actionProvider
                                                  .saveDetails3(_body, idFile);

                                            _body['pas'] = '';
                                            _body['cPas'] = '';

                                            if (_response != null) {
                                              if (_response['res'] ==
                                                  'failed') {
                                                setState(() {
                                                  processing = false;
                                                });

                                                if (_response['messg'] ==
                                                    'Incorrect ID number. Kindly confirm and try again') {
                                                  _errorMsg9 =
                                                      _response['messg'];
                                                }

                                                ScaffoldMessenger.of(context)
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
                                                var _body1 =
                                                    box.get('signUpData') ?? {};
                                                _body1['rcNumber'] =
                                                    rcController0.text;
                                                _body1['usercac'] =
                                                    rcController0.text;
                                                box.put('signUpData', _body1);
                                                setState(() {
                                                  processing = false;
                                                });

                                                if (role2 != 'individual') {
                                                  Beamer.of(context).beamToNamed(
                                                      '/home/director/information');
                                                } else {
                                                  var _body1 =
                                                      box.get('signUpData') ??
                                                          {};
                                                  _body1['phoneNo'] =
                                                      phoneController.text;
                                                  box.put('signUpData', _body1);
                                                  Beamer.of(context)
                                                      .beamToNamed(
                                                          '/mobile-otp');
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
                            if (Responsive.isMobile(context))
                              SizedBox(
                                height: 25,
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
