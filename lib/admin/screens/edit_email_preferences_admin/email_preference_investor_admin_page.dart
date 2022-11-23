import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/main.dart';
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

class EmailPreferenceInvestorAdminPage extends StatefulWidget {
  AccountData data;
  EmailPreferenceInvestorAdminPage({Key key, this.data}) : super(key: key);

  @override
  State<EmailPreferenceInvestorAdminPage> createState() => _EmailPreferenceInvestorAdminPageState();
}

class _EmailPreferenceInvestorAdminPageState extends State<EmailPreferenceInvestorAdminPage> {
  final emailController = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _pin = '';
  String _reEnterPin = '';
  String passwordErrorText = '';
  var userData;
  bool newDeals = false;
  bool bidAccepted = false;
  bool bidRejected = false;
  bool purchaseOnInvoice = false;
  bool debitOnInvoicePurchased = false;
  bool signInNotification = false;

  bool value(dynamic x){
    if(x.toString() == '1') {
      return true;
    } else {
      return false;
    }
  }

  String stringInterpretation(bool x){
    return x ? '1':'0';
  }

  dynamic body(){
    dynamic _body = {
      "newDeals": stringInterpretation(newDeals),
      // "bidAccepted": stringInterpretation(bidAccepted),
      // "bidRejected": stringInterpretation(bidRejected),
      "purchaseOfInvoice": stringInterpretation(purchaseOnInvoice ),
      "debitInvoicePurchase": stringInterpretation(debitOnInvoicePurchased),
      // "signin": stringInterpretation(signInNotification),
    };

    return _body;
  }

  Widget preferenceCheck(Widget w, String title, String subText) {
    bool c = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          w,
          SizedBox(
            width: 33,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: HexColor('#333333')),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                subText,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#333333')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool saving = false;

  bool isSet = false;

  dynamic _body = {};

  bool valuesSet = false;

  Future _future;

  @override
  void initState() {
    super.initState();
    //final profileProvider = Provider.of<ProfileProvider>(context);\
    //final profileProvider = Provider.of<ProfileProvider>(context);
    final Box box = Hive.box('capsaBox');
    var userData = Map<String, dynamic>.from(box.get('userData'));
    // if(!valuesSet) {
    //   _asyncmethodCall(profileProvider);
    // }

    //capsaPrint("\n\nUserdata $userData \nPanNumber ${widget.panNumber}");

    emailController.text = userData['email'];



  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    //UserData userDetails = profileProvider.userDetails;
    if(!valuesSet) {
      _asyncmethodCall(profileProvider);
    }


    if (!saving) {
      isSet = true;
    }
    final Box box = Hive.box('capsaBox');

    return Scaffold(
      body: Row(

        children: [
          Container(
            //width: 185,
            margin: EdgeInsets.all(0),
            height: double.infinity,
            width: MediaQuery.of(context).size.width*0.11,
            // color: Colors.black,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15)
              )),
              color: Colors.black,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50.5, 36, 50.5, 24),
                    child: SizedBox(
                      width: 80,
                      height: 45.42,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ChangeNotifierProvider(
                      //         create: (BuildContext
                      //         context) =>
                      //             AnchorActionProvider(),
                      //         child:
                      //        AnchorHomePage()),
                      //   ),
                      // );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: HexColor("#0098DB"),
                      size: 30,
                    ),
                  ),

                ],
              ),
            ),

          ),
          valuesSet ? Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              padding:
              EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 22,
                          ),
                          TopBarWidget("Email Preferences",
                              'Select your preferred email alerts'),
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
                            width: Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.53,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      child: UserTextFormField(
                                        label: "Email Address",
                                        hintText: "Enter your Email",
                                        controller: emailController,
                                        onChanged: (v) {
                                          _email = v;
                                        },
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                preferenceCheck(
                                    Checkbox(
                                      value: newDeals,
                                      onChanged: (bool value) {
                                        setState(() {
                                          newDeals = value;
                                        });
                                        //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                                      },
                                    ),
                                    'New Deals',
                                    'Get notified twice daily about new invoices you can place bids on'),
                                // preferenceCheck(
                                //     Checkbox(
                                //       value: bidAccepted,
                                //       onChanged: (bool value) {
                                //         setState(() {
                                //           bidAccepted = value;
                                //         });
                                //         //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                                //       },
                                //     ),
                                //     'Bid Accepted',
                                //     'Get notified when bids placed have been accepted'),
                                // preferenceCheck(
                                //     Checkbox(
                                //       value: bidRejected,
                                //       onChanged: (bool value) {
                                //         setState(() {
                                //           bidRejected = value;
                                //         });
                                //       },
                                //     ),
                                //     'Bid Rejected',
                                //     'Get notified when bids placed have been rejected'),
                                preferenceCheck(
                                    Checkbox(
                                      value: purchaseOnInvoice,
                                      onChanged: (bool value) {
                                        setState(() {
                                          purchaseOnInvoice = value;
                                        });
                                      },
                                    ),
                                    'Purchase of Invoice',
                                    'Get notified when the purchase of an invoice has been completed successfully'),
                                preferenceCheck(
                                    Checkbox(
                                      value: debitOnInvoicePurchased,
                                      onChanged: (bool value) {
                                        setState(() {
                                          debitOnInvoicePurchased = value;
                                        });
                                        //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                                      },
                                    ),
                                    'Debit on Invoice Purchase',
                                    'Get notified on debit from an Invoice Purchase'),
                                // preferenceCheck(
                                //     Checkbox(
                                //       value: signInNotification,
                                //       onChanged: (bool value) {
                                //         setState(() {
                                //           signInNotification = value;
                                //         });
                                //         //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                                //       },
                                //     ),
                                //     'Sign In Notification',
                                //     'Get notified when there is a new sign in to your account'),
                                if (saving)
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {

                                          setState(() {
                                            valuesSet = false;
                                          });

                                          _body = body();

                                          dynamic response = await profileProvider.setUserEmailPreference(_body, panNumber: widget.data.panNumber, role: 'INVESTOR');

                                          capsaPrint('Set preferences response : $response');



                                          if(response['status'] == 'success'){
                                            showToast('Email Preference Update Successful', context);
                                            Navigator.pop(context);
                                          }else{
                                            showToast(response['message'], context, type: 'error');
                                          }

                                          _asyncmethodCall(profileProvider);


                                        },
                                        child: Container(
                                            width: Responsive.isMobile(context)
                                                ? MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.8
                                                : MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.2,
                                            height: 59,
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(15),
                                                        topRight:
                                                        Radius.circular(15),
                                                        bottomLeft:
                                                        Radius.circular(15),
                                                        bottomRight:
                                                        Radius.circular(15),
                                                      ),
                                                      color: Color.fromRGBO(
                                                          0, 152, 219, 1),
                                                    ),
                                                    width:
                                                    Responsive.isMobile(context)
                                                        ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.8
                                                        : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.2,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 16),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Update Preferences',
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                                color:
                                                                Color.fromRGBO(
                                                                    242,
                                                                    242,
                                                                    242,
                                                                    1),
                                                                fontFamily:
                                                                'Poppins',
                                                                fontSize: 18,
                                                                letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                height: 1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ])),
                                      ),
                                      SizedBox(width: 51,),
                                      InkWell(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),))
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
                    ],
                  )),
            ),
          ):Center(child: CircularProgressIndicator(),),
        ],
      ),
    );




    //return
  }

  void _asyncmethodCall(ProfileProvider profileProvider) async {
    // async code here
    capsaPrint('Pass 1');
    Future.delayed(const Duration(milliseconds: 500), () {

      setState(() {
        // Here you can write your code for open new view
      });

    });
    //capsaPrint('Pass 2 ${widget.panNumber}');
    //final profileProvider = Provider.of<ProfileProvider>(context);
    capsaPrint('Pass 3');
    dynamic data = await profileProvider.getUserEmailPreference(panNumber: widget.data.panNumber, role: 'INVESTOR');
    capsaPrint('Pass 4 $data');
    emailController.text = data['data']['email'];
    newDeals = value(data['data']['newDeals']);
    bidAccepted = value(data['data']['bidAccepted']);
    bidRejected = value(data['data']['bidRejected']);
    purchaseOnInvoice = value(data['data']['purchaseOfInvoice']);
    debitOnInvoicePurchased =
        value(data['data']['debitInvoicePurchase']);
    signInNotification = value(data['data']['signin']);

    capsaPrint('\n\nResponse : $data');

    setState(() {
      valuesSet = true;
    });
  }
}
