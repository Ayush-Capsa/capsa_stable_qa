import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/home_page.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../investor_new.dart';

Widget bidDetailsFrameStatus(BuildContext context, data, {isDetails: false}) {
  var paymentRec = data['paymentRec'];
  var payDone = data['payDone'];
  var isAccepted = data['isAccepted'];
  var ispending = data['ispending'];
  var _text = "Pending";
  var color = Color.fromRGBO(242, 153, 74, 1);

  String _text2 = '';

  //void navigateTo

  if (isDetails) {
    if (ispending) {
      _text = "Pending";
      color = Color.fromRGBO(242, 153, 74, 1);
    } else {
      if (isAccepted) {
        _text = "Accepted";
        color = Colors.green;
      } else {
        _text = "Rejected";
        color = HexColor('#EB5757');
      }
    }
  } else {
    _text = "Pending";
    color = HexColor('#EB5757');
    _text2 = "Payment Received";

    if (paymentRec) {
      _text = "Closed";
      color = HexColor('#EB5757');
      _text2 = "Payment Received";
    } else {
      if (!payDone) {
        _text = "Pending";
        color = Color.fromRGBO(242, 153, 74, 1);
        _text2 = "Vendor awaits your payment";
      } else {
        _text = "Open";
        color = Colors.green;
        _text2 = "Awaiting anchor’s payment";
      }
    }
  }

  return Row(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 2 : 8,
                  vertical: Responsive.isMobile(context) ? 8 : 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _text,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        // fontFamily: 'Poppins',
                        fontSize: Responsive.isMobile(context) ? 15 : 18,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: Responsive.isMobile(context) ? 10 : 24),
      Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!isDetails)
              Text(
                _text2,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    // fontFamily: 'Poppins',
                    fontSize: Responsive.isMobile(context) ? 15 : 18,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            if (isDetails)
              if (ispending)
                Text(
                  'Vendor is yet to take action',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      // fontFamily: 'Poppins',
                      fontSize: Responsive.isMobile(context) ? 15 : 18,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
            SizedBox(width: Responsive.isMobile(context) ? 1 : 24),
            if (isDetails)
              if (!ispending)
                if (!isAccepted)
                  Text(
                    'Bid was rejected',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        // fontFamily: 'Poppins',
                        fontSize: Responsive.isMobile(context) ? 15 : 18,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
            SizedBox(width: Responsive.isMobile(context) ? 1 : 24),
            if (isDetails)
              if (!ispending)
                if (isAccepted)
                  Text(
                    'Bid was accepted',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        // fontFamily: 'Poppins',
                        fontSize: Responsive.isMobile(context) ? 15 : 18,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
          ],
        ),
      ),
      SizedBox(width: Responsive.isMobile(context) ? 1 : 24),
      // Text(
      //   'Edit Bid',
      //   textAlign: TextAlign.left,
      //   style: TextStyle(
      //       color: Color.fromRGBO(242, 153, 74, 1),
      //       fontFamily: 'Poppins',
      //       fontSize: 24,
      //       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
      //       fontWeight: FontWeight.normal,
      //       height: 1),
      // ),
    ],
  );
}

Widget bidDetailsFrameTopInfo(BuildContext context, OpenDealModel openInvoices,
    {isDetails: false}) {
  return Container(
    // width: MediaQuery.of(context).size.width * 0.65,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(0),
      ),
      boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
            offset: Offset(5, 5),
            blurRadius: 20)
      ],
      color: Color.fromRGBO(245, 251, 255, 1),
      image: DecorationImage(
          image: AssetImage('assets/images/Frame93.png'), fit: BoxFit.fitWidth),
    ),
    padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 10 : 24,
        vertical: Responsive.isMobile(context) ? 25 : 29),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Invoice Value',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: Responsive.isMobile(context) ? 15 : 14,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '₦',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 152, 219, 1),
                          fontFamily: 'Poppins',
                          fontSize: Responsive.isMobile(context) ? 15 : 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                    SizedBox(width: 4),
                    Text(
                      openInvoices!=null?formatCurrency(openInvoices.invoice_value):'0',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 152, 219, 1),
                          fontFamily: 'Poppins',
                          fontSize: Responsive.isMobile(context) ? 15 : 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 15),
        if (!isDetails)
          Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Responsive.isMobile(context)
                      ? 'Amount Payable'
                      : 'Amount Payable to Vendor',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: Responsive.isMobile(context) ? 12 : 14,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '₦',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: Responsive.isMobile(context) ? 15 : 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(width: 4),
                      Text(
                        formatCurrency(openInvoices.ask_amt),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: Responsive.isMobile(context) ? 15 : 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (isDetails)
          Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Purchase Price',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: Responsive.isMobile(context) ? 12 : 14,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '₦',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: Responsive.isMobile(context) ? 15 : 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(width: 4),
                      Text(
                        formatCurrency(openInvoices.ask_amt),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: Responsive.isMobile(context) ? 15 : 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        SizedBox(width: 15),
        if (!isDetails)
          Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Responsive.isMobile(context) ? 'Date' : 'Transaction Date',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: Responsive.isMobile(context) ? 12 : 14,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        //openInvoices.eff_due_date,
                        DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(openInvoices.eff_due_date)).toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: Responsive.isMobile(context) ? 15 : 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (isDetails)
          Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Tenure',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: Responsive.isMobile(context) ? 12 : 14,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                SizedBox(height: 16),
                //if (num.parse(openInvoices.companySafePercentage) > 0)
                  Container(
                    decoration: BoxDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          openInvoices.companySafePercentage + ' Days',
                          // DateFormat("yyyy-MM-dd").parse(openInvoices.due_date).difference(DateFormat("yyyy-MM-dd").parse(openInvoices.start_date)).inDays.toString() + " Days",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 152, 219, 1),
                              fontFamily: 'Poppins',
                              fontSize: Responsive.isMobile(context) ? 15 : 18,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ],
                    ),
                  )
                // else
                //   Container(
                //     decoration: BoxDecoration(),
                //     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                //     child: Row(
                //       children: <Widget>[
                //         Text(
                //           "Over",
                //           textAlign: TextAlign.left,
                //           style: TextStyle(
                //               color: Color.fromRGBO(0, 152, 219, 1),
                //               fontFamily: 'Poppins',
                //               fontSize: Responsive.isMobile(context) ? 15 : 18,
                //               letterSpacing:
                //                   0 /*percentages not used in flutter. defaulting to zero*/,
                //               fontWeight: FontWeight.normal,
                //               height: 1),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
      ],
    ),
  );
}

Widget drawSplitInvoicesInformationPanel(
    String information1, String information2, BuildContext context) {
  return Container(
    height: Responsive.isMobile(context)?115:146,
    width: double.infinity,
    decoration: BoxDecoration(
        color: HexColor('#DAFDFF'),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Responsive.isMobile(context)?142:224,
            height: Responsive.isMobile(context)?40:43,
            decoration: BoxDecoration(
                color: HexColor('#3AC0C9'),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Center(
              child: Text(
                information1,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.isMobile(context)?10:18,
                    color: Colors.white),
              ),
            ),
          ),
          Text(
            information2,
            style: GoogleFonts.poppins(
                fontWeight: Responsive.isMobile(context)?FontWeight.w500:FontWeight.w600, fontSize: Responsive.isMobile(context)?12:18, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

Widget drawSplitInvoicesInfo(
    String invoiceValue, String buyNowPrice, String tenure, String invNo,String isSplit, BuildContext context,{bool showButton = false,void ontap}) {
  return !Responsive.isMobile(context)?Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Material(
        elevation: 5,
        child: Container(
          height: 124,
          width: MediaQuery.of(context).size.width * 0.65,
          decoration: BoxDecoration(
              color: HexColor('#F5FBFF'),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice Value',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    Text(
                      '₦ ' + invoiceValue,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: HexColor('#0098DB')),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buy Now Price',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    Text(
                      '₦ ' + buyNowPrice,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: HexColor('#0098DB')),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tenure',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    Text(
                      tenure + ' Days',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: HexColor('#0098DB')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        width: 24,
      ),
      showButton?InkWell(
        onTap: (){context.beamToNamed(
          '/live-deals/bid-details/' + invNo + '/' + isSplit,
        );},
        child: Container(
          width: 180,
          height: 49,
          decoration: BoxDecoration(
              color: HexColor('#0098DB'),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Center(
            child: Text('View Deal',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                    color: Colors.white)),
          ),
        ),
      ):Container()
    ],
  ):Material(
    elevation: 5,
  borderRadius: BorderRadius.all(Radius.circular(10)),
  child: Container(

    width: MediaQuery.of(context).size.width * 0.9,
    height: 154,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('Invoice Value',style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black),),
                SizedBox(height: 4,),
                Text('₦ $invoiceValue',style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w600,color:HexColor('#0098DB')),),
              ],
            ),
            Container(
              height: 55,
              width: 2,
              color: HexColor('#828282'),
            ),
            Column(
              children: [
                Text('Buy Now Price',style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black),),
                SizedBox(height: 4,),
                Text('₦ $buyNowPrice',style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w600,color: HexColor('#0098DB')),),
              ],
            )
          ],
  // formatCurrency(buyNowPrice,withIcon: true)
        ),
        showButton?InkWell(
          onTap: (){context.beamToNamed(
            '/live-deals/bid-details/' + invNo + '/' + isSplit,
          );},
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 42,
            decoration: BoxDecoration(
                color: HexColor('#0098DB'),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Center(
              child: Text('View Deal',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white)),
            ),
          ),
        ):null
      ],
    ),

  ),
  );
}

Widget drawBidPanel(
    String type, OpenDealModel openInvoices, BuildContext context) {
  bool isF = type != "vendor" ? true : false;

  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: isF ? Color.fromRGBO(217, 252, 255, 1) : HexColor("#E2F6FF"),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      isF
                          ? "assets/images/Frame 83.png"
                          : "assets/images/Frame 834.png",
                      width: 60,
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            isF
                                ? openInvoices.customer_name.truncateTo(
                                    Responsive.isMobile(context) ? 16 : 30)
                                : openInvoices.companyName.truncateTo(
                                    Responsive.isMobile(context) ? 16 : 30),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'CAC: ' +
                                (isF
                                    ? openInvoices.customerCIN
                                    : openInvoices.sel_CIN),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontSize: 14,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Responsive.isMobile(context) ? 6 : 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: isF
                      ? Color.fromRGBO(58, 192, 201, 1)
                      : HexColor("#0098DB"),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      isF ? "Anchor" : 'Vendor',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(242, 242, 242, 1),
                          // fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        // Figma Flutter Generator Frame87Widget - FRAME - VERTICAL
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(25, 0, 0, 0),
                offset: Offset(5.0, 5.0),
                blurRadius: 5.0,
              ),
              BoxShadow(
                color: Color.fromARGB(255, 255, 255, 255),
                offset: Offset(-5.0, -5.0),
                blurRadius: 5.0,
              )
            ],
            color: Color.fromRGBO(245, 251, 255, 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _textDraw("Industry",
                  isF ? openInvoices.industry : openInvoices.sel_industry),
              _textDraw(
                  "Founded",
                  isF
                      ? DateFormat('d MMM,y')
                          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                              .parse(openInvoices.founded))
                          .toString()
                      : DateFormat('d MMM,y')
                          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                              .parse(openInvoices.sel_founded))
                          .toString()),
              _textDraw("Key Promoter",
                  isF ? openInvoices.key_person : openInvoices.sel_key_person),
              // _textDraw("Credit Profile", "Not available"),
              // _textDraw("Returns", "Filed on "),
              _textDraw("Invoice Status", "Verified"),

              _textDraw("", (isF ? "View Anchor Analysis" : ""),
                  onTap: isF
                      ? () async {
                          // capsaPrint('Tapped ${openInvoices.customer_pan}');
                          // var _body = {};
                          // _body['panNumber'] = openInvoices.customer_pan;
                          // _body['year'] = '2021';
                          // var data = await callApi3('/credit/fetchCreditScore', body: _body);
                          // capsaPrint('Data $data');
                          //await Future.delayed(Duration(milliseconds: 3000));

                          /// comment out the below part to enable navigating to anchor analysis page
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InvestorMain(
                                    pageUrl:
                                    "/live-deals/bid-details/anchor-analysis",
                                    backButton: true,
                                    menuList: false,
                                    pop: true,
                                    mobileTitle: "Anchor Analysis",
                                    body: ChangeNotifierProvider(
                                      create: (BuildContext context) =>
                                          AnchorAnalysisProvider(),
                                      child: AnchorAnalysisHomePage(
                                        model: openInvoices,
                                        scale: Responsive.isMobile(context)?MediaQuery.of(context).size.width/1050.0:1,
                                      ),
                                    )),
                          ),
                        );
                          // context.beamToNamed('/live-deals/anchor-analysis',
                          //     data: openInvoices);
                        }
                      : () {}),
              // _textDraw("Audited Statements", "Balance Sheet, Profit & Loss Statements",onTap :(){} ),
              // _textDraw("Bank Statement", "Analysis Reports",onTap :(){}),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _textDraw(String text1, String text2, {Function onTap}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15, top: 5),
    decoration: BoxDecoration(),
    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (text1 != '')
          Text(
            text1 + ':',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        SizedBox(width: 8),
        InkWell(
          onTap: onTap,
          child: Text(
            text2,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: onTap != null
                    ? HexColor("#0098DB")
                    : Color.fromRGBO(51, 51, 51, 1),
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
  );
}

Widget bidDetailsInfo(OpenDealModel openInvoices, BuildContext context) {
  return OrientationSwitcher(
    children: [
      Flexible(
        flex: 1,
        child: drawBidPanel("anchor", openInvoices, context),
      ),
      SizedBox(
        width: 20,
        height: 20,
      ),
      Flexible(flex: 1, child: drawBidPanel("vendor", openInvoices, context)),
    ],
  );
}
