import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants.dart';
import '../../common/responsive.dart';
import '../../functions/custom_print.dart';
import '../../functions/hexcolor.dart';
import '../../functions/show_toast.dart';
import '../../widgets/user_input.dart';

showTopupWalletDialog(
    BuildContext context,
    String amt,
    ) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: HexColor("#F5FBFF"),
        content: ShowTopupWalletContentMyClass(amt, context),
      );
    },
  ).then((value) {
    // if (bidDeleted) {
    //   bidDeleted = false;
    //   context.beamBack();
    // }
  });
}

class ShowTopupWalletContentMyClass extends StatefulWidget {
  String amt;
  BuildContext context1;

  ShowTopupWalletContentMyClass(this.amt, this.context1);

  @override
  _ShowTopupWalletContentMyClassState createState() =>
      _ShowTopupWalletContentMyClassState();
}

class _ShowTopupWalletContentMyClassState
    extends State<ShowTopupWalletContentMyClass> {
  bool _loading = false;
  bool bidDeletedSuccessfully = false;

  TextEditingController amountController = TextEditingController();

  Future<Object> topUpWallet(
      {String rate, String amt, String tRate}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['amount'] = amountController.text;
      // _body['role'] = userData['role'];
      // _body['new_prop_amt'] = amt.toString();
      // _body['discount_per'] = rate.toString();
      //
      // _body['pay_amt'] = '';
      // _body['plt_fee'] = '';
      // _body['pay_amt'] = '';
      // _body['from_popup'] = '1';


      String _url = apiUrl;

      dynamic _uri;
      var _role = userData['role'];
      if (_role == 'INVESTOR')
        _uri = 'dashboard/i/apiWalletTopup';
      else
        _uri = 'dashboard/r/apiWalletTopup';
     // _uri = _url + 'dashboard/i/deleteBid';
      //_uri = Uri.parse(_uri);
      var response = await callApi(_uri, body: _body);
      capsaPrint('update response : ${response}');

      return response;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //OpenDealProvider openDealProvider = Provider.of<OpenDealProvider>(context, listen: false);
    return Container(
      constraints: BoxConstraints(
        minWidth: Responsive.isMobile(context) ? 280 : 360,
        maxHeight: 350
      ),
      child: !bidDeletedSuccessfully
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Responsive.isMobile(context) ? 12 : 20,
          ),
          //Image.asset('assets/icons/warning.png'),
          // SizedBox(
          //   height: Responsive.isMobile(context) ? 12 : 20,
          // ),
          Text(
            'Top Up API Wallet',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: Responsive.isMobile(context) ? 18 : 24,
                color: HexColor('#333333'),
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 12 : 20,
          ),
          Text(
            'Fund your API wallet with your Capsa Balance',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: Responsive.isMobile(context) ? 12 : 16,
                color: HexColor('#333333'),
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 12 : 20,
          ),
          Flexible(
            child: UserTextFormField(
              controller: amountController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Value cannot be empty';
                }
                return null;
              },
              onChanged: (v) {},
              keyboardType: TextInputType.number,
              fillColor: Colors.grey[100],
              label: "Amount",
              prefixIcon: Image.asset("assets/images/currency.png"),
              hintText: "Enter Amount",
              info: 'Available balance : ' + formatCurrency(widget.amt, withIcon: true),
              infoFontSize: 14,
            ),
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 14 : 20,
          ),
          if (!_loading)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: !Responsive.isMobile(context) ? 150 : 100,
                    height: 49,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        border: Border.all(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            width: 2),
                        color: Colors.white),
                    padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Center(
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
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
                InkWell(
                  onTap: () async {
                    setState(() {
                      _loading = true;
                    });

                    dynamic response = await topUpWallet(

                    );
                    capsaPrint('Top up Response : $response');

                    setState(() {
                      _loading = false;
                    });

                    if (response['status'] == 'success') {
                      showToast('Wallet Updated Successfully', context);
                      // bidDeleted = true;
                      // bidDeletedSuccessfully = true;

                      //widget.context1.beamBack();
                    }else{
                      showToast('Something went wrong', context, type: 'warning');
                    }

                    //context.beamToNamed('/account');

                    Navigator.pop(context);


                    //Navigator.pop(context);
                  },
                  child: Container(
                    width: !Responsive.isMobile(context) ? 150 : 100,
                    height: 49,
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
                        horizontal: 10, vertical: 10),
                    child: Center(
                      child: Text(
                        'Update',
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
                  ),
                ),
              ],
            )
          else
            const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator()),
        ],
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Image.asset('assets/icons/check.png'),
          SizedBox(
            height: Responsive.isMobile(context) ? 12 : 20,
          ),
          Text(
            'Bid Cancelled',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: HexColor('#333333'),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 12 : 20,
          ),
          Text(
            'Your bid has been cancelled.\nYou can still place a fresh bid on\nthis invoice or check out other\ninvoices.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: HexColor('#333333'),
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 12 : 20,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              height: 49,
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
                  'Back To My Bids',
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
            ),
          ),
        ],
      ),
    );
  }
}