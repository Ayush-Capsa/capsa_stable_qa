import 'package:capsa/admin/screens/withdraw-amt/withdraw_response_page.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
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

import '../../../main.dart';


class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key key}) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  TextEditingController pinController = TextEditingController(text: '');
  TextEditingController bankController = TextEditingController(text: '');
  TextEditingController accountNumberController =
      TextEditingController(text: '');
  TextEditingController withdrawalAmountController =
      TextEditingController(text: '');
  TextEditingController narrationController = TextEditingController(text: '');

  var term = ['Option 1', 'Option 2'];

  final _formKey = GlobalKey<FormState>();

  String _password = '';
  String _pin = '';
  String _reEnterPin = '';
  String passwordErrorText = '';
  var userData;
  String bank;
  List<dynamic> bankNameList;
  bool dataVerified = true;



  void initiateTransaction(ProfileProvider _profileProvider) async {
    setState(() {
      saving = true;
    });
    /// comment out this part
    var _body = {};

    _body['panNumber'] = userData['panNumber'];
    _body['email'] = userData['email'];
    _body['trf_amt'] = withdrawalAmountController.text;
    narrationController.text != null
        ? _body['desc'] = narrationController.text
        : _body['desc'] = '';
    _body['bene_account_no'] = accountNumberController.text;
    // _body['transaction_pin'] = pinController.text;

    var response = await callApi('/dashboard/r/checkWithDrawAmt', body: _body);
    capsaPrint('response $response');
    if (response['res'] == 'failed') {
      if (response['messg'] ==
              'Already a payment has been processed in 10 min. Try after some time' ||
          response['messg'] ==
              'Already a payment has been processed in 5 min. Try after some time') {
        response['messg'] =
            'Your last withdrawal is still being processed. Please try again in 10 mins time.';
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => ProfileProvider(),
              child: WithdrawResponse(response: response,)),
            ),
          );

      } else {
        showToast(response['messg'], context, type: 'error');
        pinController = TextEditingController(text: '');
        bankController = TextEditingController(text: '');
        withdrawalAmountController = TextEditingController(text: '');
        narrationController = TextEditingController(text: '');
        setState(() {
          saving = false;
        });
      }
    }
    if (response['res'] == 'success') {
      // capsaPrint('pass success ${response['data'][0]['order_number']}');
      // _profileProvider.resetWithdrawData();
      // _body['step'] = 'withdraw';
      // var response1 = await callApi('/dashboard/r/withDrawAmt', body: _body);
      // print('response $response1');
      // _profileProvider.withDrawAmt(
      //     withdrawalAmountController.text,
      //     narrationController.text,
      //     accountNumberController.text,
      //     response['data'][0]['order_number']);
      // showToast('Withdrawal request is being processed. Kindly Check after some time for status update', context);
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(
    builder: (context) => ChangeNotifierProvider(
    create: (context) => ProfileProvider(),
    child: WithdrawResponse(
      amount: withdrawalAmountController.text,
      desc: narrationController.text,
      accountNo: accountNumberController.text,
      orderNumber: response['data'][0]['order_number'],
    )),
    ),
    );
      // Navigator.pop(context);
    }


  }

  // Future<Object> withdrawAmount(
  //     dynamic amt, dynamic note, ProfileProvider profileProvider) {
  //   profileProvider.withDrawAmt(
  //       amt, note, profileProvider.getBankDetails.bene_account_no);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).queryProfile();
    Provider.of<ProfileProvider>(context, listen: false).queryFewData();
    final Box box = Hive.box('capsaBox');

    userData = Map<String, dynamic>.from(box.get('userData'));
    accountNumberController =
        TextEditingController(text: userData['panNumber'].toString());
    String _role = userData['role'];
  }

  bool saving = false;

  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    // UserData userDetails = profileProvider.userDetails;
    accountNumberController = TextEditingController(
        text: profileProvider.getBankDetails!=null?profileProvider.getBankDetails.bene_account_no:'');

    if (!saving) {
      isSet = true;
    }
    final Box box = Hive.box('capsaBox');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: Scaffold(
        body: Row(
          children: [
            Container(
              width: Responsive.isMobile(context) ? 0 : 185,
              height: MediaQuery.of(context).size.height * 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0.0),
                ),
                color: Color.fromARGB(255, 15, 15, 15),
              ),
            ),
            Expanded(
              child: dataVerified
                  ? Container(
                      // height: MediaQuery.of(context).size.height,
                      padding:
                          EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 22,
                              ),
                              TopBarWidget("Withdraw Funds", ''),
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
                                //width: MediaQuery.of(context).size.width * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add a bank account',
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Enter the bank account details where your earnings will be deposited.',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: HexColor('#828282')),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    OrientationSwitcher(
                                      children: [
                                        Flexible(
                                          child: UserTextFormField(
                                            label: "Account Number",
                                            hintText: "Enter Account Number",
                                            readOnly: true,
                                            keyboardType: TextInputType.number,
                                            autovalidateMode:
                                                AutovalidateMode.onUserInteraction,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            controller: accountNumberController,
                                            // errorText: passwordErrorText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    OrientationSwitcher(
                                      children: [
                                        Flexible(
                                          child: UserTextFormField(
                                            label: "Withdrawal Amount",
                                            hintText: "0",
                                            keyboardType: TextInputType.number,
                                            controller: withdrawalAmountController,
                                            autovalidateMode:
                                                AutovalidateMode.onUserInteraction,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            prefixIcon: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '₦',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w400,
                                                      color: HexColor('#828282')),
                                                ),
                                              ],
                                            ),
                                            onChanged: (v) {
                                              if (double.parse(v) >
                                                  double.parse(profileProvider
                                                      .totalBalanceToWithDraw
                                                      .toString())) {
                                                showToast(
                                                    'Withdrawal amount cannot be greater than available amount',
                                                    context,
                                                    type: 'warning');
                                                withdrawalAmountController.text =
                                                    '';
                                              }
                                            },
                                            // validator: (v) {
                                            //   return null;
                                            // },
                                          ),
                                        )
                                      ],
                                    ),
                                    OrientationSwitcher(
                                      children: [
                                        Flexible(
                                          child: UserTextFormField(
                                            label: "Narration",
                                            hintText: "Add a narration",
                                            controller: narrationController,
                                            onChanged: (v) {},
                                            validator: (v) {
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
                                      Responsive.isMobile(context)
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      initiateTransaction(
                                                          profileProvider);
                                                    }
                                                  },
                                                  child: Container(
                                                      width: Responsive.isMobile(
                                                              context)
                                                          ? MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8
                                                          : MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.32,
                                                      height: 59,
                                                      child:
                                                          Stack(children: <Widget>[
                                                        Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(15),
                                                                  topRight: Radius
                                                                      .circular(15),
                                                                  bottomLeft: Radius
                                                                      .circular(15),
                                                                  bottomRight:
                                                                      Radius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                color:
                                                                    Color.fromRGBO(
                                                                        0,
                                                                        152,
                                                                        219,
                                                                        1),
                                                              ),
                                                              width: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.32,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical: 16),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      'Proceed with withdrawal',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              242,
                                                                              242,
                                                                              242,
                                                                              1),
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              18,
                                                                          letterSpacing:
                                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .normal,
                                                                          height:
                                                                              1),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                      ])),
                                                ),
                                                SizedBox(height: 10,),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Beamer.of(context)
                                                        .canBeamBack) {
                                                      Beamer.of(context).beamBack();
                                                    } else {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CapsaHome(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                      width: Responsive.isMobile(
                                                              context)
                                                          ? MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8
                                                          : MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.32,
                                                      height: 59,
                                                      child:
                                                          Stack(children: <Widget>[
                                                        Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(15),
                                                                  topRight: Radius
                                                                      .circular(15),
                                                                  bottomLeft: Radius
                                                                      .circular(15),
                                                                  bottomRight:
                                                                      Radius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                color:
                                                                    Color.fromRGBO(
                                                                        219,
                                                                        0,
                                                                        0,
                                                                        1.0),
                                                              ),
                                                              width: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.32,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical: 16),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      'Cancel',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              242,
                                                                              242,
                                                                              242,
                                                                              1),
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              18,
                                                                          letterSpacing:
                                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .normal,
                                                                          height:
                                                                              1),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                      ])),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      initiateTransaction(
                                                          profileProvider);
                                                    }
                                                  },
                                                  child: Container(
                                                      width: Responsive.isMobile(
                                                              context)
                                                          ? MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8
                                                          : MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.32,
                                                      height: 59,
                                                      child:
                                                          Stack(children: <Widget>[
                                                        Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(15),
                                                                  topRight: Radius
                                                                      .circular(15),
                                                                  bottomLeft: Radius
                                                                      .circular(15),
                                                                  bottomRight:
                                                                      Radius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                color:
                                                                    Color.fromRGBO(
                                                                        0,
                                                                        152,
                                                                        219,
                                                                        1),
                                                              ),
                                                              width: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.32,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical: 16),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      'Proceed with withdrawal',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              242,
                                                                              242,
                                                                              242,
                                                                              1),
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              18,
                                                                          letterSpacing:
                                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .normal,
                                                                          height:
                                                                              1),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                      ])),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Beamer.of(context)
                                                        .canBeamBack) {
                                                      Beamer.of(context).beamBack();
                                                    } else {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CapsaHome(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                      width: Responsive.isMobile(
                                                              context)
                                                          ? MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8
                                                          : MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.32,
                                                      height: 59,
                                                      child:
                                                          Stack(children: <Widget>[
                                                        Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(15),
                                                                  topRight: Radius
                                                                      .circular(15),
                                                                  bottomLeft: Radius
                                                                      .circular(15),
                                                                  bottomRight:
                                                                      Radius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                color:
                                                                    Color.fromRGBO(
                                                                        219,
                                                                        0,
                                                                        0,
                                                                        1.0),
                                                              ),
                                                              width: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.32,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical: 16),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      'Cancel',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              242,
                                                                              242,
                                                                              242,
                                                                              1),
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              18,
                                                                          letterSpacing:
                                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .normal,
                                                                          height:
                                                                              1),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                      ])),
                                                ),
                                              ],
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
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
