import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/signup/widgets/StackColumnSwitch.dart';
import 'package:capsa/signup/widgets/capsalogo.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:beamer/beamer.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  final myController0 = TextEditingController();
  String _errorMsg1 = '';

  bool processing = false;
  bool isDone = false;

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
          padding: Responsive.isMobile(context) ? EdgeInsets.zero : EdgeInsets.all(45.0),
          child: StackColumnSwitch(

            children: [
              SizedBox(
                height: 70,
              ),
              if (Responsive.isMobile(context)) Positioned(top:33,child: CapsaLogoImage()),
              if (!Responsive.isMobile(context))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Forgot Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
              if (isDone) SizedBox(height: 16),
              if (Responsive.isMobile(context))
                Positioned(
                  bottom: 0,
                  child: MobileBGWhiteContainer(
                    child: _mywid(),
                    height: MediaQuery.of(context).size.height * 0.6,
                  ),
                )
              else
                _mywid(),
            ],
          ),
        ),
      ),
    );
  }



  Widget _mywid() {


    // prefixMomoNum = myController0.text.getString("0267268224");

    String _email  = '';

    if(myController0.text != '' && myController0.text.length > 5) {
      // _email = myController0.text.replaceRange(3, 8, "****");
      var email = myController0.text;
      var atSign = email.split("@") ;
      // capsaPrint(atSign[0].split('').());
      var _star = atSign[0].split('').map((e) => '*');
      _email = atSign[0].replaceRange(1, atSign[0].length -1, _star.join());

      _email = _email + '@' + atSign[1];





    }
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.fromLTRB(8,28,8,8),
              child: Text(
                'Forgot Password',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),

          SizedBox(
            height: Responsive.isMobile(context) ? 30 : 0,
          ),
          if (isDone)
            Padding(
              padding:   EdgeInsets.all(Responsive.isMobile(context) ? 4 : 8.0),
              child: Text(
                'We just sent a link to reset your password to ' + _email + '.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: Responsive.isMobile(context) ? 16 : 14,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
          if (isDone) SizedBox(height: 16),
          if (isDone)
            Padding(
              padding:   EdgeInsets.all( Responsive.isMobile(context) ? 4 : 8.0),
              child: Text(
                'Click on the link  to set your new password',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: Responsive.isMobile(context) ? 16 : 14,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
          SizedBox(
            height: 25,
          ),
          if (!isDone)
            SizedBox(
              width: 400,
              child: UserTextFormField(
                label: 'Email Address',
                // prefixIcon: Image.asset("assets/images/currency.png"),
                hintText: 'name@example.com',
                controller: myController0,
                // initialValue: '',
                errorText: _errorMsg1,
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
                keyboardType: TextInputType.emailAddress,
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
                            var _body = {};
                            isDone = false;
                            setState(() {
                              processing = true;
                            });
                            _body['email'] = myController0.text;
                            var response = await Provider.of<SignUpActionProvider>(context, listen: false).forgetPassword(_body);

                            if (response['res'] == 'success') {
                              isDone = true;
                              // context.beamToNamed('/sign_in');
                              // showToast(response['messg'], context,type: 'success');

                              setState(() {
                                processing = false;
                                _errorMsg1 = '';
                              });
                            } else {
                              // showToast(response['messg'], context,type: 'info');
                              if (response['messg'] == "No Record Found" || response['messg'] == "No Account found") {
                                response['messg'] = "Account does not exist";
                              }
                              setState(() {
                                processing = false;
                                _errorMsg1 = response['messg'];
                              });
                            }
                          } else {
                            setState(() {
                              processing = false;
                              _errorMsg1 = '';
                            });
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
    );
  }
}
