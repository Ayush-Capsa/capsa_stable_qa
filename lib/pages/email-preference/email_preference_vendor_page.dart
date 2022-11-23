import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
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

class EmailPreferenceVendorPage extends StatefulWidget {
  const EmailPreferenceVendorPage({Key key}) : super(key: key);

  @override
  State<EmailPreferenceVendorPage> createState() => _EmailPreferenceVendorPageState();
}

class _EmailPreferenceVendorPageState extends State<EmailPreferenceVendorPage> {
  final emailController = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _pin = '';
  String _reEnterPin = '';
  String passwordErrorText = '';
  var userData;
  bool invoiceApproved = false;
  bool invoiceRejected = false;
  bool bidOffer = false;
  bool saleOfInvoice = false;
  bool creditOnInvoiceSale = false;
  bool paymentOfFactoredInvoice = false;
  bool overdueInvoice = false;
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
      // "invoiceApproved": stringInterpretation(invoiceApproved),
      // "invoiceRejected": stringInterpretation(invoiceRejected),
      // "bidOffer": stringInterpretation(bidOffer),
      "saleOfInvoice": stringInterpretation(saleOfInvoice),
      "creditInvoiceSale": stringInterpretation(creditOnInvoiceSale ),
      "overdueInvoices": stringInterpretation(overdueInvoice),
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
            width: Responsive.isMobile(context)?14:33,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: Responsive.isMobile(context)?14:20,
                    fontWeight: FontWeight.w600,
                    color: HexColor('#333333')),
              ),
              SizedBox(
                height: Responsive.isMobile(context)?6:10,
              ),
              Text(
                subText,
                maxLines: 2,
                style: GoogleFonts.poppins(
                    fontSize: Responsive.isMobile(context)?12:18,
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
    //final profileProvider = Provider.of<ProfileProvider>(context);



  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final Box box = Hive.box('capsaBox');
    var userData = Map<String, dynamic>.from(box.get('userData'));
    if(!valuesSet) {
      _asyncmethodCall(profileProvider);
    }

    capsaPrint("\n\nUserdata $userData");

    emailController.text = userData['email'];


    if (!saving) {
      isSet = true;
    }


    return valuesSet ? Container(
      // height: MediaQuery.of(context).size.height,
      padding:
      EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
      child: Form(
          key: _formKey,
          child:
          //SingleChildScrollView(
          ListView(
            children: [Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Responsive.isMobile(context)?14:22,
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
                    crossAxisAlignment: Responsive.isMobile(context)?CrossAxisAlignment.center:CrossAxisAlignment.start,
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
                      // preferenceCheck(
                      //     Checkbox(
                      //       value: invoiceApproved,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           invoiceApproved = value;
                      //         });
                      //         //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                      //       },
                      //     ),
                      //     'Invoice Approved',
                      //     'Get notified when your invoice has been approved by the Anchor and is now live'),
                      // preferenceCheck(
                      //     Checkbox(
                      //       value: invoiceRejected,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           invoiceRejected = value;
                      //         });
                      //         //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                      //       },
                      //     ),
                      //     'Invoice Rejected',
                      //     'Get notified when your invoice has been rejected by the Anchor'),
                      // preferenceCheck(
                      //     Checkbox(
                      //       value: bidOffer,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           bidOffer = value;
                      //         });
                      //         //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                      //       },
                      //     ),
                      //     'Bid Offer',
                      //     'Get notified whenever there is  a new bid placed on your invoice'),
                      preferenceCheck(
                          Checkbox(
                            value: saleOfInvoice,
                            onChanged: (bool value) {
                              setState(() {
                                saleOfInvoice = value;
                              });
                            },
                          ),
                          'Sale of Invoice',
                          Responsive.isMobile(context)?'Get notified when the sale of an invoice has\nbeen completed successfully':'Get notified when the sale of an invoice has been completed successfully'),
                      preferenceCheck(
                          Checkbox(
                            value: creditOnInvoiceSale,
                            onChanged: (bool value) {
                              setState(() {
                                creditOnInvoiceSale = value;
                              });
                            },
                          ),
                          'Credit on Invoice Sale',
                          'Get notified on credit from an Invoice Sale'),
                      // preferenceCheck(
                      //     Checkbox(
                      //       value: paymentOfFactoredInvoice,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           paymentOfFactoredInvoice = value;
                      //         });
                      //         //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                      //       },
                      //     ),
                      //     'Payment of Factored Invoice',
                      //     'Get notified when the Anchor has repaid the investor of your invoice'),
                      preferenceCheck(
                          Checkbox(
                            value: overdueInvoice,
                            onChanged: (bool value) {
                              setState(() {
                                overdueInvoice = value;
                              });
                              //capsaPrint('$newDeals $bidAccepted $bidRejected $purchaseOnInvoice $debitOnInvoicePurchased $signInNotification');
                            },
                          ),
                          'Overdue Invoice',
                          'Get notified on Invoices due for repayment'),
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
                        OrientationSwitcher(
                          orientation: Responsive.isMobile(context)?'Column':'Row',
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {

                                setState(() {
                                  valuesSet = false;
                                });

                                _body = body();

                                dynamic response = await profileProvider.setUserEmailPreference(_body);

                                capsaPrint('Set preferences response : $response');



                                if(response['status'] == 'success'){
                                  showToast('Saved Successfully', context);
                                  context.beamBack();
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
                                              children: const <Widget>[
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
                            SizedBox(height: 18,),
                            InkWell(
                                onTap: (){
                                  context.beamBack();
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
            )],
          )),
    ):Center(child: CircularProgressIndicator(),);

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
    capsaPrint('Pass 2');
    //final profileProvider = Provider.of<ProfileProvider>(context);
    capsaPrint('Pass 3');
    dynamic data = await profileProvider.getUserEmailPreference();
    capsaPrint('Pass 4');
    capsaPrint('\n\nResponse : $data');
    invoiceApproved = value(data['data']['invoiceApproved']);
    invoiceRejected = value(data['data']['invoiceRejected']);
    bidOffer = value(data['data']['bidOffer']);
    saleOfInvoice = value(data['data']['saleOfInvoice']);
    creditOnInvoiceSale = value(data['data']['creditInvoiceSale']);
    paymentOfFactoredInvoice =
        value(data['data']['debitInvoicePurchase']);
    overdueInvoice = value(data['data']['overdueInvoices']);
    signInNotification = value(data['data']['signin']);



    setState(() {
      valuesSet = true;
    });
  }
}

