import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class EnterAddressPage extends StatefulWidget {
  const EnterAddressPage({Key key}) : super(key: key);

  @override
  _EnterAddressPageState createState() => _EnterAddressPageState();
}

class _EnterAddressPageState extends State<EnterAddressPage> {
  final formKey = GlobalKey<FormState>();
  String _errorMsg1 = '';
  String _errorMsg2 = '';
  String _errorMsg3 = '';

  final addressController0 = TextEditingController();
  final cityController0 = TextEditingController();
  final stateController0 = TextEditingController();

  final box = Hive.box('capsaBox');

  bool processing = false;
  bool isDone = false;

  String text1 = "Get started on";
  String text2 = "Capsa";
  String text3 = "Capsa";

  String role = "";
  String role2 = "";

  String type = "";
  String type2 = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var _body = box.get('signUpData') ?? {};

    // nameController0.text = _body['name'];
    // bvnController0.text = _body['panNumber'];
    // emailController0.text = _body['email'];
    // phoneNoController0.text = _body['phoneNo'] ?? '';
    role = _body['role'];
    role2 = _body['ROLE2'];

    // capsaPrint('_body');
    // capsaPrint(_body);

    text1 = "Company Information";
    text2 = "";

    if (role2 == 'individual') {
      text1 = "Contact Information";
      text2 = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:   (!Responsive.isMobile(context)) ? null : AppBar( toolbarHeight: 75,title: Text(text1),),

      body: Container(
        child: Form(
          key: formKey,
          child: Padding(
            padding: Responsive.isMobile(context) ? EdgeInsets.all(8) : EdgeInsets.fromLTRB(45, 45, 45, 5),

            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                 if(!Responsive.isMobile(context))   topHeading(),
                    SizedBox(
                      height:    (!Responsive.isMobile(context)) ?25 :   15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * (!Responsive.isMobile(context) ? 0.4 : 1),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UserTextFormField(
                              padding: EdgeInsets.only(bottom: 2, top: 2),
                              label: 'Address',
                              // prefixIcon: Image.asset("assets/images/currency.png"),
                              hintText: 'Address',
                              controller: addressController0,
                              // initialValue: '',
                              errorText: _errorMsg2,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Address   is required';
                                }

                                return null;
                              },
                              onChanged: (v) {},
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UserTextFormField(
                              padding: EdgeInsets.only(bottom: 2, top: 2),
                              label: 'City',
                              // prefixIcon: Image.asset("assets/images/currency.png"),
                              hintText: 'City',
                              controller: cityController0,
                              // initialValue: '',
                              errorText: _errorMsg2,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'City is required';
                                }

                                return null;
                              },
                              onChanged: (v) {},
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UserTextFormField(
                              padding: EdgeInsets.only(bottom: 2, top: 2),
                              label: "State",
                              // prefixIcon: Image.asset("assets/images/currency.png"),
                              hintText: 'State',
                              controller: stateController0,
                              // initialValue: '',
                              errorText: _errorMsg2,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'State is required';
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            child:
                            InkWell(
                              onTap: (){
                                context.beamToNamed('/home/personal/details');
                              },
                              child: Text('Previous', textAlign: TextAlign.left, style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1
                              ),),
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
                                      if (formKey.currentState.validate()) {
                                        var _data = box.get('signUpData') ?? {};
                                        var _body = {};

                                        _body['bvn'] = _data['bvnNumber'];
                                        _body['email'] = _data['email'];
                                        _body['panNumber'] = _data['bvnNumber'];
                                        _body['role'] = _data['role'];
                                        _body['ROLE2'] = _data['ROLE2'];


                                        _body['address'] = addressController0.text;
                                        _body['city'] = stateController0.text;
                                        _body['state'] = cityController0.text;


                                        setState(() {
                                          processing = true;
                                        });

                                        final _actionProvider = Provider.of<SignUpActionProvider>(context, listen: false);

                                        await _actionProvider.updateAddress(_body);

                                        Beamer.of(context).beamToNamed('/terms-and-condition');
                                      }
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
                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
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
                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
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
                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
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
