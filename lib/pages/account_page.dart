import 'dart:typed_data';

import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/pages/withdraw-amt/withdraw_amt_page.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generatedcardwidget.dart';
import 'package:capsa/widgets/capsaapp/generatedwidgettemplatewidget/GeneratedWidgetTemplateWidget.dart';
import 'package:capsa/models/bid_history_model.dart';
import 'package:capsa/widgets/capsaapp/generatedframe96widget/GeneratedFrame96Widget.dart';
import 'package:capsa/providers/bid_history_provider.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/add_bene.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:capsa/widgets/withdraw_amt.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:beamer/beamer.dart';
import 'package:printing/printing.dart' as pr;
import 'package:pdf/widgets.dart' as pw;

import 'package:clipboard/clipboard.dart';

import 'dialog_box/account_statement_dialog_box.dart';
import 'package:capsa/pages/dialog_box/transaction_details_pdf_builder.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool withdrawConditionsVerifying = false;

  void _checkWithdrawConditions(
    BuildContext context,
  ) async {
    showDialog(
        //barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              content:
                  Container(height: 60, child: CircularProgressIndicator()),
            )).then((val) {});
    final Box box = Hive.box('capsaBox');

    var userData = Map<String, dynamic>.from(box.get('userData'));
    var _body = {};
    _body['panNumber'] = userData['panNumber'];
    _body['email'] = userData['email'];

    var response =
        await callApi('/signin/checkTransactionPINisPresent', body: _body);
    if (response['isPresent'] == 'false') {
      showToast('Transaction Pin not set!', context, type: 'warning');
      Navigator.of(context).pop(true);
      Beamer.of(context).beamToNamed('/change-transaction-pin');
    } else {
      Navigator.of(context).pop(true);
      Beamer.of(context).beamToNamed('/account/withdraw-amt');
    }
    Navigator.of(context).pop(true);
  }

  transactionType(TransactionDetails transactionDetails) {
    if (num.parse(transactionDetails.deposit_amt) > 0) {
      return "Deposit";
    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      return "Withdrawal";
    } else if (num.parse(transactionDetails.blocked_amt) > 0) {
      if (transactionDetails.narration == 'DPST') return "Deposit";
    }
    return "";
  }

  final dateCont = TextEditingController();
  final dateCont2 = TextEditingController();

  transactionIcon(TransactionDetails transactionDetails) {
    if (num.parse(transactionDetails.deposit_amt) > 0) {
      return Image.asset("assets/images/deposite_img.png", width: 38);
    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      return Image.asset(
        "assets/images/withdrawImg.png",
        width: 38,
      );
    } else if (num.parse(transactionDetails.blocked_amt) > 0) {
      if (transactionDetails.narration == "DPST")
        return Image.asset("assets/images/deposite_img.png", width: 38);
    }
    return Container(
      width: 0,
    );
  }

  bool showForVendor = false;

  transactionAmount(TransactionDetails transactionDetails) {
    num amt = 0;
    if (num.parse(transactionDetails.deposit_amt) > 0) {
      amt = num.parse(transactionDetails.deposit_amt);
    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      amt = num.parse(transactionDetails.withdrawl_amt);
    } else if (num.parse(transactionDetails.blocked_amt) > 0) {
      amt = num.parse(transactionDetails.blocked_amt);
    }
    return (amt);
  }

  Widget transactionTextWidget(TransactionDetails transactionDetails) {
    TextStyle dataTableBodyTextStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: HexColor("#333333"));

    if (num.parse(transactionDetails.deposit_amt) > 0) {
      dataTableBodyTextStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#219653"));
    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      dataTableBodyTextStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#EB5757"));
    }

    var _text = Text(
      formatCurrency(transactionAmount(transactionDetails)),
      style: dataTableBodyTextStyle,
    );

    return _text;
  }

  Widget transactionTextWidget2(TransactionDetails transactionDetails) {
    var color = Color.fromRGBO(33, 150, 83, 1);
    if (num.parse(transactionDetails.deposit_amt) > 0) {
      // if

    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      color = HexColor("#EB5757");
    }

    var _text = Text(
      formatCurrency(transactionAmount(transactionDetails)),
      textAlign: TextAlign.right,
      style: TextStyle(
          color: color,
          fontFamily: 'Poppins',
          fontSize: 14,
          letterSpacing:
              0 /*percentages not used in flutter. defaulting to zero*/,
          fontWeight: FontWeight.normal,
          height: 1),
    );

    return _text;
  }

  DateTime _selectedDate;
  DateTime _selectedDate2;

  String _type = "All transactions";
  var term = ["All transactions", "Deposit", "Withdrawal"];

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
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
      dateCont
        ..text = DateFormat(' d / M / y').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateCont.text.length, affinity: TextAffinity.upstream));

      if (_selectedDate2 != null) setState(() {});
    }
  }

  _selectDate2(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate2 != null ? _selectedDate2 : DateTime.now(),
        firstDate: DateTime(2000),
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
      _selectedDate2 = newSelectedDate;
      dateCont2
        ..text = DateFormat(' d / M / y').format(_selectedDate2)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateCont2.text.length, affinity: TextAffinity.upstream));
      setState(() {});
    }
  }

  final box = Hive.box('capsaBox');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var _role = "";
    Map<String, dynamic> userData;


    if (box.get('isAuthenticated', defaultValue: false)) {
      userData = Map<String, dynamic>.from(box.get('userData'));

      _role = userData['role'];

      if (_role == 'COMPANY') {
        showForVendor = true;
      }
    }
    ProfileProvider _profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    _profileProvider.queryFewData();
  }

  Widget buttonSection(addnewbene, _getBankDetails, _profileProvider) {
    return Column(
      children: [
        if (addnewbene)
          InkWell(
            onTap: () async {

              showDialog(
                // barrierColor: Colors.transparent,
                  context: context,
                  builder:
                      (BuildContext context) {
                    functionBack() {
                      Navigator.pop(context);
                    }

                    return AlertDialog(
                        backgroundColor:
                        Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    32.0))),
                        content: Container(
                          width: !Responsive.isMobile(context)?MediaQuery.of(context).size.width * 0.55:MediaQuery.of(context).size.width * 0.6,
                          height: !Responsive.isMobile(context)?MediaQuery.of(context).size.height * 0.6:MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), color: HexColor('#F5FBFF')),
                          child: Padding(
                            padding: EdgeInsets.all(!Responsive.isMobile(context)?16:8,),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Image.asset(
                                  'assets/icons/warning.png',
                                ),

                                Text(
                                  'Account name should not contain special characters',
                                  style: GoogleFonts.poppins(
                                      fontSize: !Responsive.isMobile(context)?22:16, fontWeight: FontWeight.w600, color: Colors.black),
                                ),
                                Text(
                                    ' Special Characters such as: ` ~! @ # \$ % ^ & * ( ) _ + | } { “ : ? > < [ ] \\ ; \' , . / - = should not be included in the Company Name. For example: replace "&" with AND or "-" with a blank space',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: !Responsive.isMobile(context)?18:12,
                                        fontWeight: FontWeight.w400,
                                        color: HexColor('#333333'))),

                                InkWell(
                                  onTap: () {
                                      Navigator.pop(context);
                                    },
                                  child: Container(
                                    height: !Responsive.isMobile(context)?49:38,
                                    width: !Responsive.isMobile(context)?134:MediaQuery.of(context).size.width * 0.25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: HexColor('#0098DB')),
                                    child: Center(
                                      child: Text(
                                        'Okay',
                                        style: GoogleFonts.poppins(
                                            fontSize: !Responsive.isMobile(context)?14:10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }).then((value) {
                showAddBeneficiaryDialog(
                  context,
                  _getBankDetails,
                  _profileProvider.bankList,
                  _profileProvider,
                );
              });


            },
            child: Container(
                width: Responsive.isMobile(context) ? 260 : 260,
                height: Responsive.isMobile(context) ? 60 : 40,
                child: Stack(children: <Widget>[
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromRGBO(0, 152, 219, 1),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Responsive.isMobile(context) ? 16 : 12,
                            vertical: Responsive.isMobile(context) ? 16 : 12),
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Add Beneficiary',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(242, 242, 242, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                          ],
                        ),
                      )),
                ])),
          ),
        if (Responsive.isMobile(context))
          SizedBox(
            height: 10,
          )
        else
          SizedBox(
            width: 20,
          ),
        if (!addnewbene)
          InkWell(
            onTap: () async {
              // _checkWithdrawConditions(context,);
              // var userData = Map<String, dynamic>.from(box.get('userData'));
              // var _body = {};
              // _body['panNumber'] = userData['panNumber'];
              // _body['email'] = userData['email'];
              //
              // var response = await callApi('/signin/checkTransactionPINisPresent', body:_body);
              // if(response['isPresent'] == 'false'){
              //   showToast('Transaction Pin not set!', context,type: 'warning');
              //   //Navigator.of(context).pop(true);
              //   Beamer.of(context).beamToNamed('/change-transaction-pin');
              // }else{
              //   //Navigator.of(context).pop(true);
              //   Beamer.of(context).beamToNamed('/account/withdraw-amt');
              // }
              Beamer.of(context).beamToNamed('/account/withdraw-amt');
            },

            //     Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => WithdrawPage(),
            //   ),
            // ),

            // {
            //   // showWithdrawalDialog(
            //   //   context,
            //   //   _getBankDetails,
            //   //   _profileProvider,
            //   //   isBarrierDismissible: false,
            //   // );
            //   // showDialog(
            //   //   barrierDismissible: false,
            //   //   context: context,
            //   //   builder: (context) => AlertDialog(
            //   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            //   //     backgroundColor: Color.fromRGBO(245, 251, 255, 1),
            //   //
            //   //     content: WidthDrawClass(_getBankDetails, _profileProvider),
            //   //   ),
            //   // ).then((value) async{
            //   //   // await _profileProvider.queryBankTransaction();
            //   //   setState(() {
            //   //
            //   // });});
            //
            //
            //
            // },
            child: Container(
                width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.9 : 200,
                height: Responsive.isMobile(context) ? 60 : 40,
                child: Stack(children: <Widget>[
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.9 : 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromRGBO(58, 192, 201, 1),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Responsive.isMobile(context) ? 16 : 12,
                            vertical: Responsive.isMobile(context) ? 16 : 12),
                        child: withdrawConditionsVerifying
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Row(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Withdraw',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(242, 242, 242, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ],
                              ),
                      )),
                ])),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!Responsive.isMobile(context))
                SizedBox(
                  height: 22,
                ),
              TopBarWidget("Account", "Transaction History"),
              SizedBox(
                height: (Responsive.isMobile(context)) ? 2 : 15,
              ),
             FutureBuilder<Object>(
                  future: Provider.of<ProfileProvider>(context, listen: false)
                      .queryBankTransaction(date: _selectedDate,),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    int i = 0;
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'There was an error :(\n' + snapshot.error.toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      );
                    }
                    else if (snapshot.hasData) {
                      bool addnewbene = false;
                      ProfileProvider _profileProvider =
                          Provider.of<ProfileProvider>(context, listen: false);
                      final _getBankDetails = _profileProvider.getBankDetails;
                      final _tmpTransactionDetails =
                          _profileProvider.transactionDetails;
                      List _pendingTransactionDetails =
                          _profileProvider.pendingTransactionDetails;
                      List _transactionDetails =
                          _tmpTransactionDetails.where((element) {
                        var isDate = false;
                        var isType = false;
                        // if (_selectedDate != null) {
                        //   DateTime createdOn =
                        //       DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                        //           .parse(element.created_on);
                        //   isDate = createdOn.isSameDate(DateTime.now());
                        // }

                        if (_type != "All transactions") {
                          isType = false;
                          if (_type == "Deposit") {
                            if (num.parse(element.deposit_amt) > 0  || ((element.status == 'PENDING' && element.reference != '' && num.parse(element.blocked_amt)>0))) {
                              isType = true;
                            }
                            if (num.parse(element.blocked_amt) > 0) {
                              if (element.narration == "DPST")
                                isType = true;
                            }
                          } else if (_type == "Withdrawal") {
                            if ((element.status == 'FAILED' ||
                                element.status == 'PENDING') && !((element.status == 'PENDING' && element.reference != '' && num.parse(element.blocked_amt)>0))) {
                              isType = true;
                            } else if (num.parse(element.withdrawl_amt) >
                                0) {
                              isType = true;
                            }
                          }
                        } else {
                          isType = true;
                        }
                        // if(isDate){
                        //   return true;
                        // }
                        return isType;
                      }).toList();

                      if (_selectedDate != null && _selectedDate2 != null) {
                        capsaPrint('pAss 1');
                        _transactionDetails =
                            _transactionDetails.where((element) {
                              var isDate = false;
                              if (_selectedDate2 != null) {
                                DateTime createdOn =
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    .parse(element.created_on);
                                // isDate = createdOn.isSameDate(_selectedDate);
                                if ((_selectedDate.isBefore(createdOn) || _selectedDate.isSameDate(createdOn)) &&
                                    (_selectedDate2.isAfter(createdOn) || _selectedDate2.isSameDate(createdOn))) {
                                  capsaPrint('created on : ${DateFormat('yyyy MM dd').format(createdOn)}');
                                  isDate = true;
                                }
                              }

                              return isDate;
                            }).toList();
                      }

                      //capsaPrint('\n\npAss 2 transaction details : ${_transactionDetails.length}');

                      // _tmpTransactionDetails.forEach((element) {
                      //   transactionDetails.add(value)
                      // });
                      final _bankList = _profileProvider.bankList;
                      if (_getBankDetails.bene_account_no.trim() == '') {
                        addnewbene = true;
                      }

                      Map<String, bool> _isBlackListed = {};

                      var currencyList = [];

                      // if (currenciesData['msg'] == 'success') {
                      //   currencyList = _items;
                      //   currencyTerm = [];
                      //   _items.forEach((element) {
                      //     currencyTerm.add(element['currency_code'].toString());
                      //     currencyAvailability[element['currency_code']] = element['is_active'].toString();
                      //   });
                      // } else {
                      //   return Center(
                      //     child: Text(
                      //       'There was an error :(\n' + currenciesData['messg'].toString(),
                      //       style: Theme.of(context).textTheme.bodyText2,
                      //     ),
                      //   );
                      // }
                      return Container(
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            OrientationSwitcher(
                              orientation: Responsive.isMobile(context)
                                  ? "Column"
                                  : "Row",
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                GeneratedCardWidget(
                                    title: "Total Balance",
                                    icon: "assets/images/account.png",
                                    width: MediaQuery.of(context).size.width,
                                    helpText:
                                        "Payment made from Anchors will be in total balance until verified by Capsa.",
                                    currency: true,
                                    subText: formatCurrency(
                                        _profileProvider.totalBalance)),
                                if (showForVendor)
                                  if (!Responsive.isMobile(context))
                                    SizedBox(
                                      width: 20,
                                    ),
                                // if (showForVendor)
                                  if (!Responsive.isMobile(context))
                                    GeneratedCardWidget(
                                        title: "Available to Withdraw",
                                        icon: "assets/images/account.png",
                                        width:
                                            MediaQuery.of(context).size.width,
                                        currency: true,
                                        isWithDrawCard: true,
                                        helpText:
                                            "Verified payment from Anchors will be in available balance. This is the money you can withdraw from your Capsa Account.",
                                        withdrawSection: buttonSection(
                                            addnewbene,
                                            _getBankDetails,
                                            _profileProvider),
                                        addNewBene:addnewbene,
                                        subText: formatCurrency(_profileProvider
                                            .totalBalanceToWithDraw)),
                                if (showForVendor)
                                  if (Responsive.isMobile(context))
                                    SizedBox(
                                      height: 10,
                                    ),
                                if (showForVendor)
                                  if (Responsive.isMobile(context))
                                    GeneratedCardWidget(
                                        title: "Available to Withdraw",
                                        icon: "assets/images/account.png",
                                        width:
                                            MediaQuery.of(context).size.width,
                                        currency: true,
                                        helpText:
                                            "Verified payment from Anchors will be in available balance. This is the money you can withdraw from your Capsa Account.",
                                        subText: formatCurrency(_profileProvider
                                            .totalBalanceToWithDraw)),
                                if (Responsive.isMobile(context))
                                  SizedBox(
                                    height: 10,
                                  ),
                                // else
                                //   SizedBox(
                                //     width: 20,
                                //   ),
                                if (Responsive.isMobile(context))
                                  SizedBox(
                                    height: 10,
                                  ),
                                // else
                                //   SizedBox(
                                //     width: 30,
                                //   ),
                                if (Responsive.isMobile(context))
                                  buttonSection(addnewbene, _getBankDetails,
                                      _profileProvider),
                                // if (!showForVendor)
                                //   if (!Responsive.isMobile(context))
                                //     buttonSection(addnewbene, _getBankDetails,
                                //         _profileProvider),
                                if (Responsive.isMobile(context))
                                  SizedBox(height: 10),
                                if (!Responsive.isMobile(context))
                                  GeneratedWidgetTemplateWidget(
                                    bankName: _getBankDetails?.bank_name ?? "",
                                    accountNo:
                                        _getBankDetails?.account_number ?? "",
                                  )
                                else
                                  Text(
                                    'Capsa Bank Account',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(130, 130, 130, 1),
                                        // fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                if (Responsive.isMobile(context))
                                  SizedBox(
                                    height: 8,
                                  ),
                                if (Responsive.isMobile(context))
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                0, 0, 0, 0.15000000596046448),
                                            offset: Offset(0, 2),
                                            blurRadius: 4)
                                      ],
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 6),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            color: Color.fromRGBO(
                                                245, 251, 255, 1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Text(
                                                              _getBankDetails
                                                                      ?.account_number ??
                                                                  "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          152,
                                                                          219,
                                                                          1),
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 16,
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
                                                      SizedBox(height: 6),
                                                      Text(
                                                        _getBankDetails
                                                                ?.bank_name ??
                                                            "",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    51,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            // fontFamily: 'Poppins',
                                                            fontSize: 14,
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
                                              ),
                                              SizedBox(width: 18),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      // _getBankDetails?.account_number ?? "",

                                                      FlutterClipboard.copy(
                                                        _getBankDetails
                                                                ?.account_number ??
                                                            "",
                                                      ).then((value) =>
                                                          showToast('Copied to Clipboard', context));

                                                    },
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const <Widget>[
                                                        Icon(
                                                          Icons.content_paste,
                                                          size: 16,
                                                          color: Color
                                                              .fromRGBO(
                                                              0,
                                                              152,
                                                              219,
                                                              1),
                                                        ),
                                                        SizedBox(height: 6),
                                                        Text(
                                                          'Click to copy',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      152,
                                                                      219,
                                                                      1),
                                                              // fontFamily: 'Poppins',
                                                              fontSize: 10,
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
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          //width: MediaQuery.of(context).size.width * 0.8,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            color: Color.fromRGBO(
                                                245, 251, 255, 1),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: const <Widget>[
                                                Text(
                                                  'Make a transfer to the above account to fund your wallet',
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          51, 51, 51, 1),
                                                      // fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height:
                              (!Responsive.isMobile(context)) ? 40 : 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async{
                                    Uint8List bytes = (await rootBundle.load('capsa_logo_blue.png')).buffer.asUint8List();
                                    dynamic leadImage = await pr.networkImage('https://storage.googleapis.com/download/storage/v1/b/fir-anchor-creditassessment.appspot.com/o/2022-12-16_capsa_logo_blue.jpg?generation=1671182470802288&alt=media');
                                    //dynamic leadImage = pw.MemoryImage(bytes);
                                    dynamic sealImage = await pr.networkImage('https://storage.googleapis.com/download/storage/v1/b/fir-anchor-creditassessment.appspot.com/o/2022-12-15_seal.jpg?generation=1671114082119590&alt=media');
                                    transactionDetailsPdfBuilder.transactionPrintDoc(_profileProvider,_transactionDetails, leadImage, sealImage);
                                    // !Responsive.isMobile(context)?showDialog(
                                    //   // barrierColor: Colors.transparent,
                                    //     context: context,
                                    //     //barrierDismissible: false,
                                    //     builder: (BuildContext context1) {
                                    //       return AlertDialog(
                                    //           backgroundColor: Colors
                                    //               .transparent,
                                    //           contentPadding:
                                    //           const EdgeInsets
                                    //               .fromLTRB(12.0,
                                    //               12.0, 12.0, 12.0),
                                    //           // shape: RoundedRectangleBorder(
                                    //           //     borderRadius:
                                    //           //     BorderRadius.all(
                                    //           //         Radius.circular(
                                    //           //             32.0))),
                                    //           elevation: 0,
                                    //           content: AccountStatementViewer(profileProvider: _profileProvider, transactionDetails: _transactionDetails,));
                                    //     }):
                                  },
                                  child: Container(
                                    width: !Responsive.isMobile(context)?320:MediaQuery.of(context).size.width * 0.9,
                                    height: !Responsive.isMobile(context)?73:45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)),
                                      border: Border.all(
                                          color: HexColor('#0098DB'),
                                          width: 3),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.download,
                                            size: !Responsive.isMobile(context)?20:12,
                                            color: HexColor('#0098DB'),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Download Account Statement',
                                            style: GoogleFonts.poppins(
                                                fontWeight:
                                                FontWeight.w700,
                                                color:
                                                HexColor('#0098DB'),
                                                fontSize: !Responsive.isMobile(context)?18:12),
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height:
                              (!Responsive.isMobile(context)) ? 20 : 10,
                            ),
                            if (!Responsive.isMobile(context))
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Filter by:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'From',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  // fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          SizedBox(
                                            width: 220,
                                            child: UserTextFormField(
                                              label: "",
                                              readOnly: true,
                                              controller: dateCont,
                                              prefixIcon: (_selectedDate !=
                                                      null)
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedDate = null;
                                                          dateCont.text =
                                                              "DD/MM/YYYY";
                                                        });
                                                      },
                                                      child: Icon(Icons.close))
                                                  : null,
                                              suffixIcon: Icon(
                                                  Icons.date_range_outlined),
                                              hintText: "DD/MM/YYYY",
                                              onTap: () => _selectDate(context),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 6),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'To',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  // fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          SizedBox(
                                            width: 220,
                                            child: UserTextFormField(
                                              label: "",
                                              readOnly: true,
                                              controller: dateCont2,
                                              prefixIcon: (_selectedDate2 !=
                                                      null)
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedDate2 = null;
                                                          dateCont2.text =
                                                              "DD/MM/YYYY";
                                                        });
                                                      },
                                                      child: Icon(Icons.close))
                                                  : null,
                                              suffixIcon: Icon(
                                                  Icons.date_range_outlined),
                                              hintText: "DD/MM/YYYY",
                                              onTap: () =>
                                                  _selectDate2(context),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 6),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Transaction type',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  // fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          SizedBox(
                                            width: 220,
                                            child: UserTextFormField(
                                              label: "",
                                              hintText: "All transactions",
                                              textFormField:
                                                  DropdownButtonFormField(
                                                isExpanded: true,
                                                items:
                                                    term.map((String category) {
                                                  return DropdownMenuItem(
                                                    value: category,
                                                    child: Text(
                                                        category.toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (v) {
                                                  setState(() {
                                                    _type = v;
                                                  });
                                                },
                                                value: _type,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText: "Select Anchor",
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
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 6),
                                      InkWell(
                                        onTap: () {
                                          final find = ',';
                                          final replaceWith = '';
                                          List<List<dynamic>> rows = [];
                                          rows.add([
                                            "Date",
                                            "Ref No",
                                            "Type",
                                            "Amount  (N)",
                                            "Status",
                                            "Remarks"
                                          ]);
                                          for (int i = 0;
                                              i < _transactionDetails.length;
                                              i++) {
                                            List<dynamic> row = [];
                                            row.add(DateFormat('d MMM, y')
                                                .format(DateFormat(
                                                        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                    .parse(
                                                        _transactionDetails[i]
                                                            .created_on))
                                                .toString());
                                            row.add(_transactionDetails[i]
                                                .order_number
                                                .replaceAll(find, replaceWith));
                                            row.add(transactionType(
                                                _transactionDetails[i]));

                                            row.add(formatCurrency(
                                                transactionAmount(
                                                    _transactionDetails[i])));
                                            row.add("Successful");
                                            row.add(_transactionDetails[i]
                                                .stat_txt
                                                .replaceAll(find, replaceWith));
                                            rows.add(row);
                                          }

                                          String dataAsCSV =
                                              const ListToCsvConverter()
                                                  .convert(
                                            rows,
                                          );
                                          exportToCSV(dataAsCSV,
                                              fName: "Transaction History");
                                        },
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                'Export',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    // fontFamily: 'Poppins',
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Image.asset(
                                              "assets/images/download.png",
                                              height: 20,
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            if (!Responsive.isMobile(context))
                              Container(
                                width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(20.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(25, 0, 0, 0),
                                      offset: Offset(5.0, 5.0),
                                      blurRadius: 20.0,
                                    ),
                                    BoxShadow(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      offset: Offset(-5.0, -5.0),
                                      blurRadius: 0.0,
                                    )
                                  ],
                                ),
                                child: DataTable(
                                  columns: dataTableColumn([
                                    "Date",
                                    "Transaction Details",
                                    "Opening Balance (N)",
                                    "Amount (N)",
                                    "Closing Balance (N)",
                                    "Reference Number"
                                  ]),
                                  rows: <DataRow>[
                                    // for (PendingTransactionDetails transaction
                                    //     in _profileProvider
                                    //         .pendingTransactionDetails)
                                    //   DataRow(
                                    //     cells: <DataCell>[
                                    //       DataCell(Text(
                                    //         // transaction.created_on,
                                    //         DateFormat('d MMM, y')
                                    //             .format(DateFormat(
                                    //                     "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    //                 .parse(
                                    //                     transaction.created_on))
                                    //             .toString(),
                                    //         style: dataTableBodyTextStyle,
                                    //       )),
                                    //       DataCell(Text(
                                    //         transaction.ref_no,
                                    //         style: dataTableBodyTextStyle,
                                    //       )),
                                    //       DataCell(Text(
                                    //         'Withdrawal',
                                    //         style: dataTableBodyTextStyle,
                                    //       )),
                                    //       DataCell(Text(
                                    //         formatCurrency(
                                    //             transaction.trans_amt),
                                    //         style: dataTableBodyTextStyle,
                                    //       )),
                                    //       DataCell(Text(
                                    //         'NA',
                                    //         style: dataTableBodyTextStyle,
                                    //       )),
                                    //       DataCell(Text(
                                    //         'Pending',
                                    //         style: TextStyle(
                                    //             fontSize: 14,
                                    //             fontWeight: FontWeight.normal,
                                    //             color: Colors.yellow),
                                    //       )),
                                    //     ],
                                    //   ),
                                    for (TransactionDetails transaction
                                        in _transactionDetails)
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Container(
                                            width: 120,
                                            child: Text(
                                              // transaction.created_on,
                                              DateFormat('d MMM, y')
                                                  .format(DateFormat(
                                                          "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                      .parse(
                                                          transaction.created_on))
                                                  .toString(),
                                              style: dataTableBodyTextStyle,
                                            ),
                                          )),
                                          DataCell(Text(
                                            transaction.narration,
                                            style: dataTableBodyTextStyle,
                                          )),
                                          DataCell(Text(
                                            formatCurrency(transaction.opening_balance),
                                            style: dataTableBodyTextStyle,
                                          )),
                                          DataCell(transactionTextWidget(
                                              transaction)),
                                          DataCell(Text(
                                            formatCurrency(transaction.closing_balance),
                                            style: dataTableBodyTextStyle,
                                          )),
                                          DataCell(Text(
                                            transaction.order_number,
                                            style: dataTableBodyTextStyle,
                                          )),
                                        ],
                                      ),
                                  ],
                                ),
                              )
                            else
                              transactionHistory(context,
                                  _transactionDetails.take(6).toList()),
                            SizedBox(
                              height: 22,
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(child: Text("No history found."));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget transactionHistory(BuildContext context, List transactionDetails) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Color.fromRGBO(245, 251, 255, 1),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Transaction history',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var transaction in transactionDetails)
                  if (transactionAmount(transaction) > 0)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(),
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              color: Color.fromRGBO(245, 251, 255, 1),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      // Icon(Icons.copy,size: 25,),
                                      transactionIcon(transaction),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.48,
                                                child: Text(
                                                  transaction.narration,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          51, 51, 51, 1),
                                                      // fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                transaction.order_number,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        51, 51, 51, 1),
                                                    // fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    height: 1),
                                              ),
                                              // Container(
                                              //   decoration: BoxDecoration(),
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: 0, vertical: 0),
                                              //   child: Row(
                                              //     mainAxisSize:
                                              //         MainAxisSize.min,
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .spaceBetween,
                                              //     crossAxisAlignment:
                                              //         CrossAxisAlignment.center,
                                              //     children: <Widget>[
                                              //       Text(
                                              //         transaction.order_number,
                                              //         textAlign: TextAlign.left,
                                              //         style: TextStyle(
                                              //             color: Color.fromRGBO(
                                              //                 51, 51, 51, 1),
                                              //             // fontFamily: 'Poppins',
                                              //             fontSize: 12,
                                              //             letterSpacing:
                                              //                 0 /*percentages not used in flutter. defaulting to zero*/,
                                              //             fontWeight:
                                              //                 FontWeight.normal,
                                              //             height: 1),
                                              //       ),
                                              //       // SizedBox(width: 16),
                                              //       // Text(
                                              //       //   (num.parse(transaction
                                              //       //               .blocked_amt) >
                                              //       //           0)
                                              //       //       ? "Blocked"
                                              //       //       : 'Successful',
                                              //       //   textAlign: TextAlign.left,
                                              //       //   style: TextStyle(
                                              //       //       color: (num.parse(
                                              //       //                   transaction
                                              //       //                       .blocked_amt) >
                                              //       //               0)
                                              //       //           ? Colors.red
                                              //       //           : Color.fromRGBO(
                                              //       //               33,
                                              //       //               150,
                                              //       //               83,
                                              //       //               1),
                                              //       //       // fontFamily: 'Poppins',
                                              //       //       fontSize: 12,
                                              //       //       letterSpacing:
                                              //       //           0 /*percentages not used in flutter. defaulting to zero*/,
                                              //       //       fontWeight:
                                              //       //           FontWeight.normal,
                                              //       //       height: 1),
                                              //       // ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              transactionTextWidget2(
                                                  transaction),
                                              SizedBox(height: 3),
                                              Text(
                                                DateFormat('d MMM, y')
                                                    .format(DateFormat(
                                                            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                        .parse(transaction
                                                            .created_on))
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        51, 51, 51, 1),
                                                    // fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        context.beamToNamed('/all-transaction-history');
                      },
                      child: Text(
                        'View all transactions',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class CreateAccountWarning extends StatelessWidget {
//   String currency;
//
//   CreateAccountWarning({Key key,@required this.currency}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 584,
//       height: 579,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20), color: HexColor('#F5FBFF')),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/icons/warning.png',
//             width: 80,
//             height: 80,
//           ),
//           Text(
//             '$currency account required',
//             style:
//             GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
//           ),
//           Text(
//             'To view your account details in $currency, you would need to create a $currency account with LeatherbackTM.',
//             style:
//             GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
//             textAlign: TextAlign.center,
//           ),
//           InkWell(
//             onTap: (){
//               // nav;
//               //Beamer.of(context).beamToNamed('/confirmInvoice');
//               Navigator.pop(context);
//             },
//             child: Container(
//               height: 60,
//               width: 342,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20), color: HexColor('#0098DB')),
//               child: Center(child: Text('Okay',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.center,),),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }