import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/signup/widgets/StackColumnSwitch.dart';
import 'package:capsa/signup/widgets/capsalogo.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class OTPVerifyPage extends StatefulWidget {
  final bool isEmail;

  OTPVerifyPage({this.isEmail: false, Key key}) : super(key: key);

  @override
  State<OTPVerifyPage> createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  final box = Hive.box('capsaBox');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendOTP();
    // isDone = true;
  }

  var email = '';
  var newEmail = '';
  var bvnNumber = '';
  var contact = '';
  var aContact = '';
  var role = '';
  var role2 = '';

  bool resendOtp = false;

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        // capsaPrint(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          setState(() {
            resendOtp = false;
          });
        }
      });
    });
  }

  sendOTP() async {
    if (isDone) return;
    var _dataSend = box.get('signUpData');
    // {bvnNumber: 23555999900, email: gibitid982@veb65.com, country: Nigeria, phoneNo: , cCOde: 234, name: Name, pas: , cPas: , acctType: Individual, userType: Investor}

    email = _dataSend['email'];
    newEmail = box.get('newEmail') ?? '';
    bvnNumber = _dataSend['bvnNumber'];
    contact = _dataSend['phoneNo'];
    role = _dataSend['role'];
    // if(_dataSend['phoneNo'] != )
    role2 = _dataSend['ROLE2'];
    aContact = _dataSend['aPhoneNo'] ?? '';

   if(aContact == ''){
     aContact = _dataSend['phoneNo'];
   }

    if (_dataSend != null) {
      var _body = {};

      _body['isEmail'] = widget.isEmail.toString();
      _body['email'] = _dataSend['email'];
      _body['newEmail'] = box.get('newEmail') ?? '';
      _body['panNumber'] = _dataSend['bvnNumber'];
      _body['contact'] = _dataSend['phoneNo'];

      if (role2 != 'individual'){

        _body['aContact'] = _dataSend['aPhoneNo'] ?? '';

      }else{
        _body['aContact'] = _dataSend['phoneNo'];

      }
      // capsaPrint('_body');
      // capsaPrint(_body);

      await Provider.of<SignUpActionProvider>(context, listen: false).sendOtp(_body);
    }
  }

  final formKey = GlobalKey<FormState>();
  final myController0 = TextEditingController();
  String _errorMsg1 = '';

  bool processing = false;
  bool isDone = false;

  submitData() async {
    if (formKey.currentState.validate()) {
      var _body = {};
      isDone = false;
      setState(() {
        processing = true;
      });
      _body['isEmail'] = widget.isEmail.toString();

      _body['email'] = email;
      _body['panNumber'] = bvnNumber;
      _body['contact'] = contact.length > 0 ? contact : '';
      _body['otp'] = myController0.text;
      var response = await Provider.of<SignUpActionProvider>(context, listen: false).verifyEmailOTP(_body);

      if (response['res'] == 'success') {
        if (!widget.isEmail) {
          if (role == "COMPANY") {
            context.beamToNamed('/terms-and-condition');
          } else {
            if (role2 != 'individual')
              context.beamToNamed('/terms-and-condition');
            else
              Beamer.of(context).beamToNamed('/home/personal/address');
          }

          return;
        }

        isDone = true;
        // context.beamToNamed('/sign_in');
        // showToast(response['messg'], context,type: 'success');

        setState(() {
          processing = false;
          _errorMsg1 = '';
        });
      } else {
        // showToast(response['messg'], context,type: 'info');
        setState(() {
          processing = false;
          if (response['messg'] == "Sorry!  Invalid OTP ") {
            response['messg'] = "Wrong OTP";
          }
          _errorMsg1 = response['messg'];
        });
      }
    } else {
      setState(() {
        processing = false;
        _errorMsg1 = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _contact = aContact;
    if(_contact.length > 10 && _contact[0] == '0')
      _contact = _contact.substring(1);
    // isDone = true;
    return Container(
      decoration: Responsive.isMobile(context)
          ? BoxDecoration(
        color: HexColor("#0098DB"),
      )    : BoxDecoration(),
      child: Form(
        key: formKey,
        child: Padding(
          padding: Responsive.isMobile(context) ? EdgeInsets.zero : EdgeInsets.all(45.0),
          child: Padding(
            padding: Responsive.isMobile(context) ? EdgeInsets.zero :EdgeInsets.only(left: (isDone) ? 0 : 80),
            child: StackColumnSwitch(
              mainAxisAlignment: !widget.isEmail ? MainAxisAlignment.start :  MainAxisAlignment.center,
              crossAxisAlignment: (!isDone) ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                ),
                if (!isDone)  if (Responsive.isMobile(context)) Positioned(top:33,child: CapsaLogoImage()),

                if (isDone) SizedBox(height: 16),
                if (Responsive.isMobile(context))
                  Positioned(
                    bottom: (!isDone)  ?  0 : null,
                    top: (isDone)  ?  -30 : null,
                    child: MobileBGWhiteContainer(
                      child: _myWid(_contact),
                      height:    (isDone)  ? MediaQuery.of(context).size.height +50  :   MediaQuery.of(context).size.height * 0.4,
                    ),
                  )
                else
                  _myWid(_contact),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myWid(_contact){
    return Padding(
      padding:  Responsive.isMobile(context) ? EdgeInsets.all(15) : EdgeInsets.zero,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: !widget.isEmail ? MainAxisAlignment.start :  MainAxisAlignment.center,
        crossAxisAlignment: (!isDone) ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (!isDone)
            SizedBox(
              height:   Responsive.isMobile(context) ? 20:   50,
            ),
          if (!widget.isEmail)
            Text(
              'Verification',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1),
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          if(!widget.isEmail)
            SizedBox(
              height:  Responsive.isMobile(context) ? 20:   70,
            ),
          if (!isDone)
            SizedBox(
              width: 400,
              child: UserTextFormField(
                padding: EdgeInsets.zero,
                label: 'Enter OTP',
                //  + (!widget.isEmail ? contact : email)
                // prefixIcon: Image.asset("assets/images/currency.png"),
                hintText: 'Enter 6-Digit OTP',
                controller: myController0,
                // initialValue: '',
                // errorText: _errorMsg1,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'OTP is required';
                  }
                  if (value.length != 6) {
                    return 'Enter 6-Digit valid OTP';
                  }
                  return null;
                },
                onChanged: (v) {
                  if (v.length == 6) {
                    // capsaPrint(v);
                    submitData();
                  }
                },
                keyboardType: TextInputType.number,
                // maxLength: 6,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
              ),
            ),
          if (!isDone)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMsg1 != '')
                  Text(
                    _errorMsg1 + '. ',

                    style: TextStyle(color: HexColor("#EB5757"),fontSize:  Responsive.isMobile(context) ? 12: 15,),
                  ),
                Text("Enter OTP sent to ",style: TextStyle(fontSize:  Responsive.isMobile(context) ? 12: 15,),),
                SizedBox(width: 1),
                Builder(
                  builder: (context) {
                    var tt = (!widget.isEmail ? "(+234)"+ _contact : email) ;
                    if(newEmail != '') tt = tt + ' and '+ newEmail;
                    return Text(
                      tt,
                      style: TextStyle(
                        fontSize:  Responsive.isMobile(context) ? 12: 15,
                        color: HexColor("#0098DB"),
                      ),
                    );
                  }
                ),
              ],
            ),
          if (!isDone)
          SizedBox(
            height:  Responsive.isMobile(context) ? 20: 50,
          ),
          if (processing) CircularProgressIndicator(),
          SizedBox(
            height:  Responsive.isMobile(context) ? 4: 15,
          ),
          if (!isDone)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  !resendOtp ? "Didn’t get OTP? " : "Resend OTP in",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 1),
                if (!isDone)
                  if (!resendOtp)
                    InkWell(
                      onTap: () {
                        sendOTP();
                        startTimeout();
                        setState(() {
                          resendOtp = true;
                        });
                      },
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          fontSize: 16,
                          color: HexColor("#0098DB"),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Text(
                      " " + timerText,
                      style: TextStyle(
                        fontSize: 16,
                        color: HexColor("#0098DB"),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
              ],
            ),
          if (false)
            if (!isDone)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: processing
                    ? CircularProgressIndicator()
                    : SizedBox(
                  width: 400,
                  child: InkWell(
                    onTap: () async {},
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
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Center(
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(242, 242, 242, 1),
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          if (isDone)
            Container(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Colorediconeps1.png',
                          height: 90,
                        ),
                        SizedBox(width: 50,),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Text(
                    "Capsa Technology,",
                    style: TextStyle(
                      // color: Color.fromRGBO(242, 242, 242, 1),

                        fontSize: 16,
                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Container(
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to",
                          style: TextStyle(
                            // color: Color.fromRGBO(242, 242, 242, 1),
                              fontFamily: 'Poppins',
                              fontSize: Responsive.isMobile(context) ? 24: 26,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          'Capsa',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Poppins',
                              fontSize:  Responsive.isMobile(context) ? 24: 26,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )
                      ],
                    ),
                  ),

                  Container(
                      width: 400,
                      padding: EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kindly proceed to setup your Capsa account.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontSize:  Responsive.isMobile(context) ? 13: 15,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ],
                      )),

                  Container(
                      width: 400,
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'It will take you',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontSize:  Responsive.isMobile(context) ? 13:  15,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          Text(
                            ' 3 minutes ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize:  Responsive.isMobile(context) ? 13:  15,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          Text(
                            'or less to do so.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontSize:  Responsive.isMobile(context) ? 13:  15,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ],
                      )),

                  SizedBox(
                    height: 25,
                  ),

                  SizedBox(
                    width: 330,
                    child: InkWell(
                      onTap: () {
                        if (role == "COMPANY") {
                          context.beamToNamed('/home/company/details');
                        } else {
                          context.beamToNamed('/home/personal/details');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromRGBO(0, 152, 219, 1),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Center(
                          child: Text(
                            'Setup My Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],),
            )
        ],
      ),
    );
  }
}
