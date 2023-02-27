import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/widgets/input_preview.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class CapsaAccountGeneration extends StatefulWidget {
  const CapsaAccountGeneration({Key key}) : super(key: key);

  @override
  _CapsaAccountGenerationState createState() => _CapsaAccountGenerationState();
}

class _CapsaAccountGenerationState extends State<CapsaAccountGeneration> {
  final box = Hive.box('capsaBox');
  final formKey = GlobalKey<FormState>();
  final myController0 = TextEditingController();

  bool isCreating = true;
  bool isSuccess = false;

  bool isDownloadDone = false;
  String _errorText1 = '';
  String _accNum = '';
  String role = '';
  String role2 = '';

  dynamic _accountResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // isCreating = false;
    // isSuccess = true;

    var signUpData = box.get('signUpData');
    role = signUpData['role'];
    role2 = signUpData['ROLE2'];
    // capsaPrint('signUpData');
    // capsaPrint(signUpData);

    createAccountCall();
  }

  final accountFileController0 = TextEditingController();

  PlatformFile accountFile;

  pickFile(TextEditingController controller, String type) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['docx'],
    );

    if (result != null) {
      if (result.files.first.extension == 'jpg' ||
          result.files.first.extension == 'png' ||
          result.files.first.extension == 'jpeg' ||
          result.files.first.extension == 'docx' ||
          result.files.first.extension == 'pdf') {
        setState(() {
          if (type == 'account') {
            accountFile = result.files.first;
            accountFileController0.text = accountFile.name;
          }
        });
      } else {
        accountFileController0.text = "";
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Invalid Format Selected. Please Select Another File'),
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
      accountFileController0.text = "";
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

  createAccountCall() async {
    var _body = box.get('signUpData') ?? {};
    var role = _body['role'];

    final _actionProvider = Provider.of<SignUpActionProvider>(context, listen: false);

    _accountResponse = await _actionProvider.createAccount(role);
    await Future.delayed(Duration(seconds: 1));

    if (_accountResponse != null) {
      if (_accountResponse['res'] == 'success') {
        var _tmpRes = await _actionProvider.getAccount(role);

        if (_tmpRes != null) {
          if (_tmpRes['res'] == 'success') {
            _accNum  = _tmpRes['data']['acc'];
            isSuccess = true;
          }
        }



      } else {
        isSuccess = false;
      }
    }

    setState(() {
      isCreating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _newLine = "\n";
    if(!Responsive.isMobile(context)){
      _newLine = "";
    }
    return Scaffold(
      appBar:   (!Responsive.isMobile(context)) ? null : AppBar( toolbarHeight: 75,title: Text(   "Capsa Account Generation",),),

      body: Container(
        child: Form(
          key: formKey,
          child: Padding(
            padding: Responsive.isMobile(context) ? EdgeInsets.all(8) : EdgeInsets.fromLTRB(50, 50, 50, 5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height:  Responsive.isMobile(context) ? 10 : 50,
                  ),
                  if(!Responsive.isMobile(context)) Text(
                    "Capsa Account Generation",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                  if(role == "COMPANY")
                    SizedBox(
                      height: 20,
                    ),
                  if(role == "COMPANY")
                    Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(! Responsive.isMobile(context) )      Image.asset(   "assets/images/Progress3-3.png",height: 35,),
                        if( Responsive.isMobile(context) )     Image.asset(   "assets/images/Progress m3-3.png",height: 40,),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: isSuccess ? MainAxisAlignment.start : MainAxisAlignment.center,
                      crossAxisAlignment: isSuccess ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isCreating)
                          SizedBox(
                            height: 100,
                          ),
                        if (isCreating)
                          Row(
                            // mainAxisAlignment: ,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                ' Please wait while we'+_newLine+' create your Capsa account.',
                                textAlign:  Responsive.isMobile(context) ? TextAlign.left :TextAlign.center,
                              ),
                            ],
                          ),
                        if (!isCreating)
                          if (isSuccess)
                            Container(
                              width: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "Capsa Bank Account",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          // fontFamily: 'Poppins',
                                          fontSize: 16,
                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                  InputPreview('Stanbic IBTC', _accNum),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  if(role == "COMPANY")
                                  if (!isDownloadDone)
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        "Download change of account letters ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color.fromRGBO(51, 51, 51, 1),
                                            // fontFamily: 'Poppins',
                                            fontSize: 16,
                                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.normal,
                                            height: 1),
                                      ),
                                    ),
                                  if(role == "COMPANY")
                                  if (isDownloadDone)
                                    UserTextFormField(
                                      padding: EdgeInsets.only(bottom: 2, top: 2),
                                      label: 'Upload Document ',
                                      // prefixIcon: Image.asset("assets/images/currency.png"),
                                      hintText: 'docx file',
                                      controller: accountFileController0,
                                      // initialValue: '',
                                      onTap: () => pickFile(accountFileController0, 'account'),
                                      readOnly: true,
                                      errorText: _errorText1,

                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return 'ID is required';
                                        }

                                        return null;
                                      },
                                      onChanged: (v) {},
                                      keyboardType: TextInputType.text,
                                    ),
                                  if(role == "COMPANY")
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _errorText1 = '';
                                        });
                                        if (!isDownloadDone) {
                                          setState(() {
                                            // isDownloadDone = true;
                                          });

                                          await Provider.of<SignUpActionProvider>(context, listen: false).downloadLetter();
                                          return;
                                        } else {
                                          if (accountFileController0.text.isEmpty) {
                                            setState(() {
                                              _errorText1 = 'Document is required';
                                            });

                                            return;
                                          } else {
                                            final _actionProvider = Provider.of<SignUpActionProvider>(context, listen: false);
                                            var _body = {};
                                            var signUpData = box.get('signUpData');
                                            _body['bvn'] = signUpData['panNumber'];
                                            _body['panNumber'] = signUpData['panNumber'];
                                            _body['role'] = signUpData['role'];

                                            await _actionProvider.setActive(_body, accountFile);
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
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        child: Center(
                                          child: Text(
                                            isDownloadDone ? 'Upload' : 'Download',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(242, 242, 242, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        if (!isCreating)
                          if (!isSuccess)
                            Container(
                              width: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 90,
                                  ),
                                  Image.asset(
                                    "assets/images/error1.png",
                                    height: 150,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "We encountered an error while generating account number for you. Kindly note that this error is not from you.\n\n\Click on the button below to refresh this page.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        // fontFamily: 'Poppins',
                                        fontSize: 16,
                                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      html.window.location.reload();
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
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      child: Center(
                                        child: Text(
                                          'Refresh Page',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(242, 242, 242, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        if (!isCreating)
                          if (isSuccess)
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Container(),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          Beamer.of(context).beamToNamed('/success');
                                        },
                                        child: Text(
                                          'Finish',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 152, 219, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
