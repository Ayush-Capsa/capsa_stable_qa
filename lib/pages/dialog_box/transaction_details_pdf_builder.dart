import 'dart:typed_data';

import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:flutter/cupertino.dart' as ct;
import 'package:flutter/material.dart' as mt;
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import 'package:intl/intl.dart';

class transactionDetailsPdfBuilder {
  static transactionAmount(TransactionDetails transactionDetails) {
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

  static List<Widget> pdfView(
      ProfileProvider profileProvider,
      List<dynamic> transactionDetails,
      dynamic image,
      dynamic sealImage,
      dynamic font,
      dynamic boldFont,
      dynamic robotoBold) {
    final _getBankDetails = profileProvider.getStatementBankDetails;
    var userData = Map<String, dynamic>.from(box.get('userData'));

    capsaPrint('pass 4.1');

    List<Widget> pages = [];

    pages.add(Container(
      //color: Colors.white,
      child: Stack(children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 47,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //NetworkImage(),
                      Image(
                        image,
                        fit: BoxFit.contain,
                        width: 180,
                        height: 80,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        userData['name'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          font: font,
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        userData['email'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          font: font,
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Capsa Technology Limited\n7th floor Mulliner Towers,\n39 Alfred Rewane Rd,\n 101233, Lagos\n\n\n0704-627-2950\nhello@getcapsa.com',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      font: font,
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 42,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Account Statement',
                    style: TextStyle(
                      font: boldFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 24,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Account Number',
                        style: TextStyle(
                          font: font,
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        _getBankDetails.account_number,
                        style: TextStyle(
                          font: robotoBold,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          font: font,
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        formatCurrency(
                          profileProvider.totalBalance,
                          withIcon: true,
                        ),
                        style: TextStyle(
                          font: robotoBold,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Available To Withdraw',
                        style: TextStyle(
                          font: font,
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        formatCurrency(
                          profileProvider.totalBalanceToWithDraw,
                          withIcon: true,
                        ),
                        style: TextStyle(
                          font: robotoBold,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 42,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Account Summary',
                    style: TextStyle(
                      font: boldFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 24,
              ),
              //itemDescription(),

              Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(
                    style: BorderStyle.solid, width: 1, color: PdfColors.blue),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Account Name',
                          style: TextStyle(
                              font: boldFont,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Opening Balance',
                          style: TextStyle(
                              font: boldFont,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Inflows',
                          style: TextStyle(
                              font: boldFont,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Outflows',
                          style: TextStyle(
                              font: boldFont,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Closing Balance',
                          style: TextStyle(
                              font: boldFont,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold))
                    ]),
                  ]),
                ],
              ),
              SizedBox(height: 10),
              Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                        color: PdfColors.lightBlue50,
                      ),
                      children: [
                        Column(children: [
                          Text(_getBankDetails.bene_account_holdername,
                              style: TextStyle(font: font, fontSize: 8))
                        ]),
                        Column(children: [
                          Text(
                              formatCurrency(
                                  transactionDetails[
                                          transactionDetails.length - 1]
                                      .opening_balance,
                                  withIcon: true),
                              style: TextStyle(font: font, fontSize: 8))
                        ]),
                        Column(children: [
                          Text(
                              formatCurrency(_getBankDetails.inflow,
                                  withIcon: true),
                              style: TextStyle(font: font, fontSize: 8))
                        ]),
                        Column(children: [
                          Text(
                              formatCurrency(_getBankDetails.outflow,
                                  withIcon: true),
                              style: TextStyle(font: font, fontSize: 8))
                        ]),
                        Column(children: [
                          Text(
                              formatCurrency(
                                  transactionDetails[0].closing_balance,
                                  withIcon: true),
                              style: TextStyle(font: font, fontSize: 8))
                        ]),
                      ]),
                ],
              ),

              SizedBox(
                height: 42,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Account Statement',
                    style: TextStyle(
                      font: boldFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 24,
              ),
              //itemDescription(),

              Row(children: [
                Container(
                    width: 35,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColors.blue)),
                    child: Center(
                        child: Text('Date',
                            style: TextStyle(font: boldFont, fontSize: 10.0)))),
                Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColors.blue)),
                    child: Center(
                        child: Text('Amount',
                            style: TextStyle(font: boldFont, fontSize: 10.0)))),
                Container(
                    width: 140,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColors.blue)),
                    child: Center(
                        child: Text('Transaction Details',
                            style: TextStyle(font: boldFont, fontSize: 10.0)))),
                Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColors.blue)),
                    child: Center(
                        child: Text('Opening Balance',
                            style: TextStyle(font: boldFont, fontSize: 10.0)))),
                Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColors.blue)),
                    child: Center(
                        child: Text('Closing Balance',
                            style: TextStyle(font: boldFont, fontSize: 10.0)))),
                Container(
                    //color: (i%2 == 0)?PdfColors.lightBlue50:PdfColors.white,
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColors.blue)),
                    child: Center(
                        child: Text('Reference Number',
                            style: TextStyle(font: boldFont, fontSize: 10.0)))),
                Container(
                  width: 20,
                  height: 30,
                  // child: Text(transactionDetails[i].order_number + '\n',
                  //     style: TextStyle( font: font,fontSize: 8.0))
                ),
              ]),

              // Table(
              //     defaultColumnWidth: FixedColumnWidth(110.0),
              //     border: TableBorder.all(style: BorderStyle.solid, width: 2, color: PdfColors.blue),
              //
              //     children: [
              //       TableRow(children: [
              //         Column(children: [
              //           Text('Date',
              //               style: TextStyle( font: boldFont,
              //                   fontSize: 12.0, fontWeight: FontWeight.bold))
              //         ]),
              //         Column(children: [
              //           Text('Amount',
              //               style: TextStyle( font: boldFont,
              //                   fontSize: 12.0, fontWeight: FontWeight.bold))
              //         ]),
              //         Column(children: [
              //           Text('Transaction Details',
              //               style: TextStyle( font: boldFont,
              //                   fontSize: 12.0, fontWeight: FontWeight.bold))
              //         ]),
              //         Column(children: [
              //           Text('Opening Balance',
              //               style: TextStyle( font: boldFont,
              //                   fontSize: 12.0, fontWeight: FontWeight.bold))
              //         ]),
              //         Column(children: [
              //           Text('Closing Balance',
              //               style: TextStyle( font: boldFont,
              //                   fontSize: 12.0, fontWeight: FontWeight.bold))
              //         ]),
              //         Column(children: [
              //           Text('Reference Number',
              //               style: TextStyle( font: boldFont,
              //                   fontSize: 12.0, fontWeight: FontWeight.bold))
              //         ]),
              //       ]),]),
              SizedBox(height: 15),
              for (int i = 0;
                  i <
                      (transactionDetails.length <= 4
                          ? transactionDetails.length
                          : 4);
                  i++)
                Container(
                  color: (i % 2 == 0) ? PdfColors.lightBlue50 : PdfColors.white,
                  child: Row(children: [
                    Container(
                        width: 35,
                        height: 30,
                        child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(
                                DateFormat('d MMM, y')
                                    .format(DateFormat(
                                    "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    .parse(transactionDetails[i].created_on))
                                    .toString(),
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                        width: 80,
                        height: 30,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(
                                formatCurrency(
                                    transactionAmount(transactionDetails[i]),
                                    withIcon: true),
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                        width: 140,
                        height: 30,
                        child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ Text(transactionDetails[i].narration,
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                        width: 80,
                        height: 30,
                        child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ Text(
                                formatCurrency(
                                    transactionDetails[i].opening_balance,
                                    withIcon: true),
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                        width: 80,
                        height: 30,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ Text(
                                formatCurrency(
                                    transactionDetails[i].closing_balance,
                                    withIcon: true),
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                      //color: (i%2 == 0)?PdfColors.lightBlue50:PdfColors.white,
                        width: 50,
                        height: 30,
                        child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ Text(transactionDetails[i].order_number,
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                      width: 20,
                      height: 30,
                      // child: Text(transactionDetails[i].order_number + '\n',
                      //     style: TextStyle( font: font,fontSize: 8.0))
                    ),
                  ]),
                ),
            ],
          ),
        ),

        if (transactionDetails.length <= 4)
          Positioned(
            bottom: 30,
            left: 40,
            child: Image(
              sealImage,
              fit: BoxFit.contain,
              width: 98,
              height: 98,
            ),
          ),
        //
        if (transactionDetails.length <= 4)
          Positioned(
            bottom: 2,
            left: 40,
            child: Text(
              'The GetCapsa platform is a property of Capsa Technology Limited, a Company registered with\nthe Corporate Affairs Commission of Nigeria with RC Number: 1630431.',
              style: TextStyle(font: font, fontSize: 8.0),
              textAlign: TextAlign.center,
            ),
          ),
      ]),
    ));

    int counter = 0;

    if (transactionDetails.length > 4) {
      int currentLength = 4;
      bool pageSplitDone = false;
      while (!pageSplitDone && counter < 1) {
        //counter++;
        int len = (transactionDetails.length - currentLength) > 18
            ? 18 + currentLength
            : transactionDetails.length;

        pages.add(Container(
          //color: Colors.white,
          child: Column(
            children: [
              // SizedBox(
              //   height: 47,
              // ),
              for (int i = currentLength; i < len; i++)
                Container(
                  color: (i % 2 == 0) ? PdfColors.lightBlue50 : PdfColors.white,
                  child: Row(children: [
                    Container(
                        width: 35,
                        height: 30,
                        child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(
                            DateFormat('d MMM, y')
                                .format(DateFormat(
                                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                .parse(transactionDetails[i].created_on))
                                .toString(),
                            style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                        width: 80,
                        height: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(
                                formatCurrency(
                                    transactionAmount(transactionDetails[i]),
                                    withIcon: true),
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                        width: 140,
                        height: 30,
                        child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ Text(transactionDetails[i].narration,
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                        width: 80,
                        height: 30,
                        child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ Text(
                                formatCurrency(
                                    transactionDetails[i].opening_balance,
                                    withIcon: true),
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                        width: 80,
                        height: 30,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ Text(
                                formatCurrency(
                                    transactionDetails[i].closing_balance,
                                    withIcon: true),
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                      //color: (i%2 == 0)?PdfColors.lightBlue50:PdfColors.white,
                        width: 50,
                        height: 30,
                        child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ Text(transactionDetails[i].order_number,
                                style: TextStyle(font: font, fontSize: 8.0))])),
                    Container(
                      width: 20,
                      height: 30,
                      // child: Text(transactionDetails[i].order_number + '\n',
                      //     style: TextStyle( font: font,fontSize: 8.0))
                    ),
                  ]),
                ),

              if ((len + 1) >= transactionDetails.length)
                SizedBox(
                  height: 10,
                ),
              if ((len + 1) >= transactionDetails.length)
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image(
                        sealImage,
                        fit: BoxFit.contain,
                        width: 98,
                        height: 98,
                      ))
                ]),

              if ((len + 1) >= transactionDetails.length)
                SizedBox(
                  height: 10,
                ),

              if ((len + 1) >= transactionDetails.length)
                Text(
                  'The GetCapsa platform is a property of Capsa Technology Limited, a Company registered with\nthe Corporate Affairs Commission of Nigeria with RC Number: 1630431.',
                  style: TextStyle(font: font, fontSize: 8.0),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ));
        currentLength = len;
        capsaPrint('Page : ${pages.length}');

        if ((currentLength + 1) >= transactionDetails.length) {
          pageSplitDone = true;
        }
      }
    }

    return pages;
  }

  static Future<void> transactionPrintDoc(
      ProfileProvider profileProvider,
      List<dynamic> transactionDetails,
      dynamic leadImage,
      dynamic sealImage) async {
    final doc = Document();
    capsaPrint('pass 1');

    final font = await PdfGoogleFonts.robotoRegular();
    final robotoBold = await PdfGoogleFonts.robotoBold();
    final boldFont = await PdfGoogleFonts.poppinsSemiBold();
    doc.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return pdfView(profileProvider, transactionDetails, leadImage,
              sealImage, font, boldFont, robotoBold);
          ;
        }));
    capsaPrint('pass 4');
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    // await doc.save();
  }
}
