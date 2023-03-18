import 'dart:convert';

import 'package:capsa/common/constants.dart';
import 'package:capsa/investor/provider/proposal_provider.dart';
import 'package:capsa/admin/charts.dart';
import 'package:capsa/admin/currency_icon_icons.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/to_upper_case.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/investor/models/proposal_model.dart';
import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/investor/provider/opendeal_provider.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:intl/intl.dart';
import 'package:capsa/functions/show_toast.dart';

import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

const titleStyle = TextStyle(
  color: Colors.green,
  fontWeight: FontWeight.bold,
  fontSize: 22,
);

final lableStyle = TextStyle(
  color: Colors.grey[600],
);

bool bidDeleted = false;

// showBidBottomSheet(context, int index, OpenDealProvider openDealProvider) {
//   return showModalBottomSheet(
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Bid",
//                 style: titleStyle,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               ShowBidContentMyClass(index, openDealProvider),
//             ],
//           ),
//         );
//       });
// }

// showEditBidDialog(
//     BuildContext context, int index, OpenDealProvider openDealProvider,
//     {buyNow = false}) {
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       OpenDealModel openInvoice = openDealProvider.openInvoices[index];
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(32.0))),
//         backgroundColor: HexColor("#F5FBFF"),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               buyNow ? "Buy Now" : 'Place Bid',
//               textAlign: TextAlign.left,
//               style: TextStyle(
//                   color: Color.fromRGBO(33, 150, 83, 1),
//                   fontFamily: 'Poppins',
//                   fontSize: 24,
//                   letterSpacing:
//                   0 /*percentages not used in flutter. defaulting to zero*/,
//                   fontWeight: FontWeight.normal,
//                   height: 1),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Invoice Value',
//                   textAlign: TextAlign.left,
//                   style: TextStyle(
//                       color: Color.fromRGBO(51, 51, 51, 1),
//                       // fontFamily: 'Poppins',
//                       fontSize: 14,
//                       letterSpacing:
//                       0 /*percentages not used in flutter. defaulting to zero*/,
//                       fontWeight: FontWeight.normal,
//                       height: 1),
//                 ),
//
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Figma Flutter Generator AmountWidget - FRAME - HORIZONTAL
//                 Container(
//                   decoration: BoxDecoration(),
//                   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Text(
//                         '₦',
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: Color.fromRGBO(0, 152, 219, 1),
//                             fontFamily: 'Poppins',
//                             fontSize: 18,
//                             letterSpacing:
//                             0 /*percentages not used in flutter. defaulting to zero*/,
//                             fontWeight: FontWeight.normal,
//                             height: 1),
//                       ),
//                       SizedBox(width: 4),
//                       Text(
//                         formatCurrency(openInvoice.invoice_value),
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: Color.fromRGBO(0, 152, 219, 1),
//                             fontFamily: 'Poppins',
//                             fontSize: 18,
//                             letterSpacing:
//                             0 /*percentages not used in flutter. defaulting to zero*/,
//                             fontWeight: FontWeight.normal,
//                             height: 1),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//         content: ShowBidContentMyClass(index, buyNow, openDealProvider),
//       );
//     },
//   );
// }

showBidDialog(
    BuildContext context, int index, OpenDealProvider openDealProvider,
    {buyNow = false}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      OpenDealModel openInvoice = openDealProvider.openInvoices[index];
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: HexColor("#F5FBFF"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              buyNow ? "Buy Now" : 'Place Bid',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color.fromRGBO(33, 150, 83, 1),
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Invoice Value',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      // fontFamily: 'Poppins',
                      fontSize: 14,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),

                SizedBox(
                  height: 10,
                ),
                // Figma Flutter Generator AmountWidget - FRAME - HORIZONTAL
                Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '₦',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(width: 4),
                      Text(
                        formatCurrency(openInvoice.invoice_value),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        content: ShowBidContentMyClass(index, buyNow, openDealProvider),
      );
    },
  );
}

showEditInvoiceDialog(
    BuildContext context, int index, OpenDealProvider openDealProvider,
    {buyNow = false}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      OpenDealModel openInvoice = openDealProvider.openInvoices[index];
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: HexColor("#F5FBFF"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              buyNow ? "Buy Now" : 'Place Bid',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color.fromRGBO(33, 150, 83, 1),
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Invoice Value',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      // fontFamily: 'Poppins',
                      fontSize: 14,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),

                SizedBox(
                  height: 10,
                ),
                // Figma Flutter Generator AmountWidget - FRAME - HORIZONTAL
                Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '₦',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(width: 4),
                      Text(
                        formatCurrency(openInvoice.invoice_value),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        content: ShowBidContentMyClass(index, buyNow, openDealProvider),
      );
    },
  );
}

class ShowBidContentMyClass extends StatefulWidget {
  final int index;
  final bool buyNow;

  final OpenDealProvider openDealProvider;

  ShowBidContentMyClass(this.index, this.buyNow, this.openDealProvider);

  @override
  _ShowBidContentMyClassState createState() => _ShowBidContentMyClassState();
}

class _ShowBidContentMyClassState extends State<ShowBidContentMyClass> {
  String amount, rate, tRate = '';
  final myController = TextEditingController(text: '');
  final myController2 = TextEditingController(text: '');
  final myController3 = TextEditingController(text: '');
  final myController0 = TextEditingController(text: '');
  final myController4 = TextEditingController(text: '');
  final myController5 = TextEditingController(text: '');
  String _message =
      '\nYour Excepted Return Calculated ad follow\n\nBid Amount : ₦ 0\nPlatform Fee : ₦ 0\n,Excepted Return : ₦ 0\n';

  bool _loading = false;

  final ButtonStyle raisedButtonStyle2 = ElevatedButton.styleFrom(
    onPrimary: Colors.white70,
    primary: Colors.red[400],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );

  calCul() {
    OpenDealModel openInvoice =
        widget.openDealProvider.openInvoices[widget.index];
    var invoicedays = 0;

    var payableamount = double.parse(openInvoice.invoice_value);
    var purchaseprice;

    double _amt = double.parse(amount);
    purchaseprice = _amt;
    if (purchaseprice == 0) {
      myController.text = '';
      myController0.text = '';
      myController2.text = '';
      myController3.text = '';
      myController4.text = '';
      myController5.text = '';
      return;
    }

    DateTime invoiceDate =
        new DateFormat("yyyy-MM-dd").parse(openInvoice.start_date);

    DateTime invoiceDueDate =
        new DateFormat("yyyy-MM-dd").parse(openInvoice.due_date);

    // invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
    // invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);
    invoicedays = invoiceDueDate.difference(invoiceDate).inDays;

    if (purchaseprice > payableamount) {
      myController.text = '';
      myController2.text = '';
      myController3.text = '';
      myController0.text = '';
      myController4.text = '';
      myController5.text = '';
      setState(() {
        _message = 'Amount cannot be exceed';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Amount can't be greater than invoice amount"),
        ),
      );
      amount = '0';
      calCul();
      return;
    }

    var termRate =
        (1 / invoicedays) * (payableamount / purchaseprice - 1) * invoicedays;
    termRate = termRate * 100;

    // var rate = (1 / invoicedays) * (payableamount / purchaseprice - 1) * 360;
    var rate = ((payableamount - purchaseprice) / purchaseprice) *
        0.9 *
        100 *
        (365 / invoicedays);
    capsaPrint('$payableamount $purchaseprice $invoicedays');
    //rate = rate * 100;

    myController.text = rate.toStringAsFixed(2);
    myController2.text = termRate.toStringAsFixed(2);

    // Gross Return = Invocie value
    // Net Return = Gross - Platform

    // (INVOICE AMOUNT/SELL NOW PRICE - 1) * (1-TENURE) * 365 DAYS

    num pfee = ((payableamount - _amt) / 100) * 10;
    num rValue = payableamount;
    myController4.text = pfee.toStringAsFixed(2);
    myController3.text = rValue.toStringAsFixed(2);
    var netreturn = rValue - pfee;
    myController5.text = netreturn.toStringAsFixed(2);
    setState(() {
      _message =
          '\nYour Excepted Return Calculated ad follow\n\nBid Amount : ₦ ' +
              _amt.toStringAsFixed(2) +
              '\nPlatform Fee : ₦ ' +
              pfee.toStringAsFixed(2) +
              '\nExcepted Return : ₦ ' +
              rValue.toStringAsFixed(2) +
              '\n';
    });
  }

  @override
  void initState() {
    super.initState();
    OpenDealModel openInvoice =
        widget.openDealProvider.openInvoices[widget.index];

    if (widget.buyNow &&
        (openInvoice.ask_amt != null && num.parse(openInvoice.ask_amt) > 0)) {
      myController0.text = openInvoice.ask_amt;
      amount = openInvoice.ask_amt;
      calCul();
    }
  }

  @override
  Widget build(BuildContext context) {
    OpenDealModel openInvoice =
        widget.openDealProvider.openInvoices[widget.index];
    return SingleChildScrollView(
      child: Container(
        width: 420,
        constraints: BoxConstraints(maxWidth: 500, minWidth: 450),
        child: Column(
          children: [
            UserTextFormField(
              label: 'Enter Amount',
              prefixIcon: Image.asset("assets/images/currency.png"),
              hintText: '0',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: myController0,
              readOnly: widget.buyNow,
              // initialValue: '',
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Value cannot be empty';
                }
                return null;
              },
              onChanged: (v) {
                amount = v;
                calCul();
              },
              keyboardType: TextInputType.number,
            ),
            OrientationSwitcher(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: UserTextFormField(
                    label: "Discount Rate p.a.",
                    suffixIcon: Image.asset("assets/images/%.png"),
                    hintText: "Rate p.a.",
                    controller: myController,
                    readOnly: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Value cannot be empty';
                      }
                      return null;
                    },
                    onChanged: (v) {
                      rate = v;
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                // Flexible(
                //   child: UserTextFormField(
                //     readOnly: true,
                //     suffixIcon: Image.asset("assets/images/%.png"),
                //     label: "Term Rate",
                //     hintText: "Term Interest",
                //     controller: myController2,
                //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //     validator: (value) {
                //       if (value.trim().isEmpty) {
                //         return 'Value cannot be empty';
                //       }
                //       return null;
                //     },
                //     onChanged: (v) {
                //       tRate = v;
                //     },
                //     keyboardType: TextInputType.number,
                //   ),
                // ),
              ],
            ),
            UserTextFormField(
              controller: myController3,
              // initialValue: myController3.text,
              readOnly: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Value cannot be empty';
                }
                return null;
              },
              onChanged: (v) {},
              keyboardType: TextInputType.number,
              label: "Gross Returns",
              prefixIcon: Image.asset("assets/images/currency.png"),
              hintText: "0",
            ),
            OrientationSwitcher(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: UserTextFormField(
                    readOnly: true,
                    controller: myController4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Value cannot be empty';
                      }
                      return null;
                    },
                    onChanged: (v) {},
                    keyboardType: TextInputType.number,
                    label: "Platform charges",
                    hintText: "0",
                  ),
                ),
                Flexible(
                  child: UserTextFormField(
                    controller: myController5,
                    readOnly: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Value cannot be empty';
                      }
                      return null;
                    },
                    onChanged: (v) {},
                    keyboardType: TextInputType.number,
                    label: "Net Returns",
                    prefixIcon: Image.asset("assets/images/currency.png"),
                    hintText: "0",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            if (!_loading)
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (amount.trim() == '') {
                        showToast("Amount is required", context);
                        return;
                      }
                      setState(() {
                        _loading = true;
                      });
                      // return;
                      if (widget.buyNow)
                        await widget.openDealProvider.bidActionCall(
                            context, openInvoice, 1, widget.index,
                            buyNow: widget.buyNow);
                      else
                        await widget.openDealProvider.bidActionCall(
                            context, openInvoice, 0, widget.index,
                            tRate: tRate, rate: rate, amt: amount);
                    },
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromRGBO(0, 152, 219, 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Center(
                          child: Text(
                            (widget.buyNow ? 'Buy now at ' : 'Place Bid at ') +
                                formatCurrency(myController0.text,
                                    withIcon: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        )),
                  ),

                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Colors.red,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Center(
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        )),
                  ),
                  // ElevatedButton(
                  //   style: raisedButtonStyle2,
                  //   onPressed: () {
                  //     Navigator.of(context, rootNavigator: true).pop();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Text('Cancel'),
                  //   ),
                  // ),
                ],
              )
            else
              Align(
                  alignment: Alignment.centerRight,
                  child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

showEditBidDialog(
  BuildContext context,
  OpenDealModel data,
  String amt,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: HexColor("#F5FBFF"),
        content: ShowEditBidContentMyClass(
          data,
          amt,
        ),
      );
    },
  ).then((value) {});
}

class ShowEditBidContentMyClass extends StatefulWidget {
  final OpenDealModel data;
  String amt;

  ShowEditBidContentMyClass(
    this.data,
    this.amt,
  );

  @override
  _ShowEditBidContentMyClassState createState() =>
      _ShowEditBidContentMyClassState();
}

class _ShowEditBidContentMyClassState extends State<ShowEditBidContentMyClass> {
  String amount, rate, tRate = '';
  final myController = TextEditingController(text: '');
  final myController2 = TextEditingController(text: '');
  final myController3 = TextEditingController(text: '');
  final myController0 = TextEditingController(text: '');
  final myController4 = TextEditingController(text: '');
  final myController5 = TextEditingController(text: '');
  String _message =
      '\nYour Excepted Return Calculated ad follow\n\nBid Amount : ₦ 0\nPlatform Fee : ₦ 0\n,Excepted Return : ₦ 0\n';

  bool _loading = false;
  bool bidUpdated = false;

  @override
  void initState() {
    super.initState();
    amount = widget.amt;
    myController0.text = amount;
    // amount = widget.data.prop_amt;

    calCul();
  }

  calCul() {
    //return;
    // OpenDealModel openInvoice = widget.openDealProvider.openInvoices[widget.index];
    var invoicedays = 0;

    var payableamount = double.parse(widget.data.invoice_value);
    var purchaseprice;

    double _amt = double.parse(amount);
    purchaseprice = _amt;
    if (purchaseprice == 0) {
      myController.text = '';
      myController0.text = '';
      myController2.text = '';
      myController3.text = '';
      return;
    }

    DateTime invoiceDate =
        new DateFormat("yyyy-MM-dd").parse(widget.data.start_date);

    DateTime invoiceDueDate =
        new DateFormat("yyyy-MM-dd").parse(widget.data.due_date);

    // invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
    // invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);
    invoicedays = invoiceDueDate.difference(invoiceDate).inDays;

    if (purchaseprice > payableamount) {
      myController.text = '';
      myController2.text = '';
      myController3.text = '';
      myController0.text = '';
      setState(() {
        _message = 'Amount cannot be exceed';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Amount can't be greater than invoice amount"),
        ),
      );
      amount = '0';
      calCul();
      return;
    }

    var termRate =
        (1 / invoicedays) * (payableamount / purchaseprice - 1) * invoicedays;
    termRate = termRate * 100;

    var rate = (1 / invoicedays) * (payableamount / purchaseprice - 1) * 360;
    rate = rate * 100;

    myController.text = rate.toStringAsFixed(2);
    myController2.text = termRate.toStringAsFixed(2);

    num pfee = ((payableamount - _amt) / 100) * 5;
    num rValue = payableamount;
    var netreturn = rValue - pfee;
    myController3.text = rValue.toStringAsFixed(2);
    myController4.text = pfee.toStringAsFixed(2);
    myController5.text = netreturn.toStringAsFixed(2);

    setState(() {
      _message =
          '\nYour Excepted Return Calculated ad follow\n\nBid Amount : ₦ ' +
              _amt.toStringAsFixed(2) +
              '\nPlatform Fee : ₦ ' +
              pfee.toStringAsFixed(2) +
              '\nExcepted Return : ₦ ' +
              rValue.toStringAsFixed(2) +
              '\n';
    });
  }

  Future<Object> bidEdit(OpenDealModel invoice,
      {String rate, String amt, String tRate}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      // var invoicedays = 0;
      //
      // var payableamount = double.parse(invoice.invoice_value);
      // var purchaseprice;
      // if (amt != null) {
      //   double _amt = double.parse(amt);
      //   purchaseprice = _amt;
      // } else {
      //   purchaseprice = double.parse(invoice.ask_amt);
      // }
      //
      // DateTime invoiceDate =
      //     new DateFormat("yyyy-MM-dd").parse(invoice.start_date);
      //
      // DateTime invoiceDueDate =
      //     new DateFormat("yyyy-MM-dd").parse(invoice.due_date);
      //
      // // invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
      // // invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);
      // invoicedays = invoiceDueDate.difference(invoiceDate).inDays;
      //
      // var termRate =
      //     (1 / invoicedays) * (payableamount / purchaseprice - 1) * invoicedays;
      // termRate = termRate * 100;
      // termRate = termRate.toPrecision(2);
      //
      // var rate = (1 / invoicedays) * (payableamount / purchaseprice - 1) * 360;
      // rate = rate * 100;
      // rate = rate.toPrecision(2);

      // return null;

      var _body = {};

      _body['investor_pan'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      _body['role'] = userData['role'];
      _body['new_prop_amt'] = amt.toString();
      _body['discount_per'] = rate.toString();

      _body['pay_amt'] = '';
      // _body['discount_val'] = openInvoice.;
      _body['plt_fee'] = '';
      _body['pay_amt'] = '';
      _body['from_popup'] = '1';
      // _body['comp_pan'] = invoice.comp_pan;
      // _body['cust_pan'] = invoice.cust_pan;
      // _body['prop_amt'] = invoice.prop_amt;
      // _body['discper1'] = openInvoice.discper;
      // _body['childcontract1'] = openInvoice.childcontract;
      _body['duedate1'] = invoice.due_date;
      _body['inv_number'] = invoice.invoice_number;
      _body['invval1'] = invoice.invoice_value;
      _body['start_date'] = invoice.start_date;
      _body['due_date'] = invoice.due_date;
      // _body['click_type'] = clickType.toString();

      //_body['diffDays'] = invoicedays.toString();

      // capsaPrint(_body);
      // return null;
      String _url = apiUrl;

      dynamic _uri;
      _uri = _url + 'dashboard/i/editbid';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      capsaPrint('Edit response : $data');

      // if (data['res'] == 'success') {
      //   var _data = data['data'];
      //
      //   notifyListeners();
      // }

      return data;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //OpenDealProvider openDealProvider = Provider.of<OpenDealProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        //width: 420,
        constraints: BoxConstraints(maxWidth: 500, minWidth: 360),
        child: !bidUpdated
            ? Column(
                children: [
                  // !Responsive.isMobile(context)
                  //     ? Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           if (!Responsive.isMobile(context))
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   'Edit Bid',
                  //                   style: GoogleFonts.poppins(
                  //                       fontSize: Responsive.isMobile(context)
                  //                           ? 14
                  //                           : 18,
                  //                       color: HexColor('#219653'),
                  //                       fontWeight: FontWeight.w400),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 4,
                  //                 ),
                  //                 Text(
                  //                   widget.data.invoice_number,
                  //                   style: GoogleFonts.poppins(
                  //                       fontSize: 24,
                  //                       color: HexColor('#219653'),
                  //                       fontWeight: FontWeight.w400),
                  //                 ),
                  //               ],
                  //             ),
                  //           if (!Responsive.isMobile(context))
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   'Invoice Value ',
                  //                   style: GoogleFonts.poppins(
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w400),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 4,
                  //                 ),
                  //                 Text(
                  //                   formatCurrency(widget.data.invoice_value,
                  //                       withIcon: true),
                  //                   style: GoogleFonts.poppins(
                  //                       fontSize: 24,
                  //                       color: HexColor('#0098DB'),
                  //                       fontWeight: FontWeight.w600),
                  //                 ),
                  //               ],
                  //             ),
                  //         ],
                  //       )
                  //     : Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             'Invoice Value ',
                  //             style: GoogleFonts.poppins(
                  //                 fontSize: 16,
                  //                 color: HexColor('#333333'),
                  //                 fontWeight: FontWeight.w400),
                  //           ),
                  //           Text(
                  //             formatCurrency(widget.data.invoice_value,
                  //                 withIcon: true),
                  //             style: GoogleFonts.roboto(
                  //                 fontSize: 18,
                  //                 color: HexColor('#0098DB'),
                  //                 fontWeight: FontWeight.w600),
                  //           ),
                  //         ],
                  //       ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Bid',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(33, 150, 83, 1),
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Invoice Value',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                // fontFamily: 'Poppins',
                                fontSize: 14,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          // Figma Flutter Generator AmountWidget - FRAME - HORIZONTAL
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '₦',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 152, 219, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  formatCurrency(widget.data.invoice_value),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 152, 219, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  UserTextFormField(
                    label: 'Enter Amount',
                    prefixIcon: Image.asset("assets/images/currency.png"),
                    hintText: '0',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: myController0,
                    fillColor: Colors.grey[100],
                    //readOnly: widget.buyNow,
                    // initialValue: '',
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Value cannot be empty';
                      }
                      return null;
                    },
                    onChanged: (v) {
                      amount = v;
                      calCul();
                    },
                    keyboardType: TextInputType.number,
                  ),
                  OrientationSwitcher(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: UserTextFormField(
                          label: "Discount Rate p.a.",
                          suffixIcon: Image.asset("assets/images/%.png"),
                          hintText: "Rate p.a.",
                          controller: myController,
                          fillColor: Colors.grey[100],
                          readOnly: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Value cannot be empty';
                            }
                            return null;
                          },
                          onChanged: (v) {
                            rate = v;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      // Flexible(
                      //   child: UserTextFormField(
                      //     readOnly: true,
                      //     suffixIcon: Image.asset("assets/images/%.png"),
                      //     label: "Term Rate",
                      //     hintText: "Term Interest",
                      //     controller: myController2,
                      //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      //     validator: (value) {
                      //       if (value.trim().isEmpty) {
                      //         return 'Value cannot be empty';
                      //       }
                      //       return null;
                      //     },
                      //     onChanged: (v) {
                      //       tRate = v;
                      //     },
                      //     keyboardType: TextInputType.number,
                      //   ),
                      // ),
                    ],
                  ),
                  UserTextFormField(
                    controller: myController3,
                    // initialValue: myController3.text,
                    readOnly: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Value cannot be empty';
                      }
                      return null;
                    },
                    onChanged: (v) {},
                    keyboardType: TextInputType.number,
                    label: "Gross Returns",
                    fillColor: Colors.grey[100],
                    prefixIcon: Image.asset("assets/images/currency.png"),
                    hintText: "0",
                  ),
                  OrientationSwitcher(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: UserTextFormField(
                          readOnly: true,
                          controller: myController4,
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
                          label: "Platform charges",
                          hintText: "0",
                        ),
                      ),
                      Flexible(
                        child: UserTextFormField(
                          controller: myController5,
                          readOnly: true,
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
                          label: "Net Returns",
                          prefixIcon: Image.asset("assets/images/currency.png"),
                          hintText: "0",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (!_loading)
                    if (!_loading)
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    // capsaPrint(rate);
                                    // capsaPrint(tRate);
                                    // capsaPrint(amount);
                                    setState(() {
                                      _loading = true;
                                    });

                                    if (amount.trim() == '') return;
                                    dynamic response = await bidEdit(widget.data,
                                        amt: amount, rate: rate);
                                    capsaPrint('Edit Invoice Response : $response');

                                    setState(() {
                                      _loading = false;
                                    });

                                    if (response['msg'] == 'success') {
                                      showToast(
                                          'Bid Editted Successfully', context);
                                      bidUpdated = true;
                                      setState(() {});
                                      //Navigator.pop(context);
                                      //context.beamBack();
                                    }

                                    // return;
                                    // await widget.openDealProvider.bidEditCall(context, widget.data, widget.proposalProvider, tRate: tRate, rate: rate, amt: amount);
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Center(
                                      child: Text(
                                        'Edit Bid',
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

                                SizedBox(height: 10),

                                InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                  child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                        color: Colors.red,
                                      ),
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(242, 242, 242, 1),
                                              fontSize: 16,
                                              letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      )),
                                ),

                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Align(
                          alignment: Alignment.centerRight,
                          child: CircularProgressIndicator()),
                ],
              )
            : Column(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: Responsive.isMobile(context)?4 : 8,
                  // ),
                  Image.asset(
                    'assets/icons/check.png',
                    height: 80,
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 14 : 20,
                  ),
                  Text(
                    'Bid Updated',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: HexColor('#333333'),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 14 : 20,
                  ),
                  Container(
                    width: Responsive.isMobile(context) ? 220 : 328,
                    child: Text(
                      'The  vendor will review your bid and take action on it. You will be notified as soon as this happens.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: HexColor('#333333'),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 14 : 20,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Center(
                        child: Text(
                          'Back To Bid Details',
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
      ),
    );
  }
}

showDeleteBidDialog(
  BuildContext context,
  OpenDealModel data,
  String amt,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: HexColor("#F5FBFF"),
        content: ShowDeleteBidContentMyClass(data, amt, context),
      );
    },
  ).then((value) {
    if (bidDeleted) {
      bidDeleted = false;
      context.beamBack();
    }
  });
}

class ShowDeleteBidContentMyClass extends StatefulWidget {
  final OpenDealModel data;
  String amt;
  BuildContext context1;

  ShowDeleteBidContentMyClass(this.data, this.amt, this.context1);

  @override
  _ShowDeleteBidContentMyClassState createState() =>
      _ShowDeleteBidContentMyClassState();
}

class _ShowDeleteBidContentMyClassState
    extends State<ShowDeleteBidContentMyClass> {
  bool _loading = false;
  bool bidDeletedSuccessfully = false;

  Future<Object> deleteBid(OpenDealModel invoice,
      {String rate, String amt, String tRate}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      // var invoicedays = 0;
      //
      // var payableamount = double.parse(invoice.invoice_value);
      // var purchaseprice;
      // if (amt != null) {
      //   double _amt = double.parse(amt);
      //   purchaseprice = _amt;
      // } else {
      //   purchaseprice = double.parse(invoice.ask_amt);
      // }
      //
      // DateTime invoiceDate =
      //     new DateFormat("yyyy-MM-dd").parse(invoice.start_date);
      //
      // DateTime invoiceDueDate =
      //     new DateFormat("yyyy-MM-dd").parse(invoice.due_date);
      //
      // // invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
      // // invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);
      // invoicedays = invoiceDueDate.difference(invoiceDate).inDays;
      //
      // var termRate =
      //     (1 / invoicedays) * (payableamount / purchaseprice - 1) * invoicedays;
      // termRate = termRate * 100;
      // termRate = termRate.toPrecision(2);
      //
      // var rate = (1 / invoicedays) * (payableamount / purchaseprice - 1) * 360;
      // rate = rate * 100;
      // rate = rate.toPrecision(2);

      // return null;

      var _body = {};

      _body['investor_pan'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      _body['role'] = userData['role'];
      _body['new_prop_amt'] = amt.toString();
      _body['discount_per'] = rate.toString();

      _body['pay_amt'] = '';
      // _body['discount_val'] = openInvoice.;
      _body['plt_fee'] = '';
      _body['pay_amt'] = '';
      _body['from_popup'] = '1';
      // _body['comp_pan'] = invoice.comp_pan;
      // _body['cust_pan'] = invoice.cust_pan;
      // _body['prop_amt'] = invoice.prop_amt;
      // _body['discper1'] = openInvoice.discper;
      // _body['childcontract1'] = openInvoice.childcontract;
      _body['duedate1'] = invoice.due_date;
      _body['inv_number'] = invoice.invoice_number;
      _body['invval1'] = invoice.invoice_value;
      _body['start_date'] = invoice.start_date;
      _body['due_date'] = invoice.due_date;
      // _body['click_type'] = clickType.toString();

      //_body['diffDays'] = invoicedays.toString();

      // capsaPrint(_body);
      // return null;
      String _url = apiUrl;

      dynamic _uri;
      _uri = _url + 'dashboard/i/deleteBid';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      capsaPrint('Delete response : $data');

      // if (data['res'] == 'success') {
      //   var _data = data['data'];
      //
      //   notifyListeners();
      // }

      return data;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //OpenDealProvider openDealProvider = Provider.of<OpenDealProvider>(context, listen: false);
    return Container(
      constraints: BoxConstraints(
        minWidth: Responsive.isMobile(context) ? 280 : 360,
      ),
      child: !bidDeletedSuccessfully
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 12 : 20,
                ),
                Image.asset('assets/icons/warning.png'),
                SizedBox(
                  height: Responsive.isMobile(context) ? 12 : 20,
                ),
                Text(
                  'Cancel Bid',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: Responsive.isMobile(context) ? 18 : 22,
                      color: HexColor('#333333'),
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: Responsive.isMobile(context) ? 12 : 20,
                ),
                Text(
                  Responsive.isMobile(context)
                      ? 'This bid will no longer be presented to the vendor for consideration. Are you sure you want to continue?'
                      : 'This bid will no longer be presented to the\nvendor for consideration. Are you sure you\nwant to continue?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: HexColor('#333333'),
                      fontWeight: FontWeight.w500),
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
                              'No',
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

                          dynamic response = await deleteBid(
                            widget.data,
                          );
                          capsaPrint('Edit Invoice Response : $response');

                          setState(() {
                            _loading = false;
                          });

                          if (response['msg'] == 'success') {
                            //showToast('Bid Deleted Successfully', context);
                            bidDeleted = true;
                            bidDeletedSuccessfully = true;
                            //Navigator.pop(context);
                            //widget.context1.beamBack();
                          }

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
                              'Yes',
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

showPayDialog(context, OpenDealModel invoice, openDealProvider) {
  num factorValue = openDealProvider.getFactorValue(invoice);
  num discountRate = openDealProvider.getDiscountRate(invoice);

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: HexColor("#F5FBFF"),
        insetPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
        contentPadding: EdgeInsets.all(10),
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Factoring Details for Invoice",
                textAlign: TextAlign.center,
                style: titleStyle.copyWith(
                  color: Colors.blue,
                ),
              ),
              Text(
                "#" + invoice.invoice_number,
                style: titleStyle.copyWith(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        content: Container(
          constraints: BoxConstraints(minWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: Text('Invoice Value :')),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      '₦ ' + invoice.invoice_value,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Text(
                    'Factor Value :',
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      '₦ ' + factorValue.toString(),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(flex: 1, child: Text('Discount Rate : ')),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      flex: 2,
                      child: Text(
                        discountRate.toString() + ' % Per Annum',
                        textAlign: TextAlign.right,
                      )),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(flex: 1, child: Text('To Company : ')),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      flex: 2,
                      child: Text(
                        invoice.companyName,
                        textAlign: TextAlign.right,
                      )),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: Text('Due In : ')),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      '' + invoice.companySafePercentage + ' Days',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              MyPayButtonClass(openDealProvider, invoice),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

// ignore: must_be_immutable
class MyPayButtonClass extends StatefulWidget {
  final openDealProvider;

  OpenDealModel invoice;

  MyPayButtonClass(this.openDealProvider, this.invoice);

  @override
  _MyPayButtonClassState createState() => _MyPayButtonClassState();
}

class _MyPayButtonClassState extends State<MyPayButtonClass> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white70,
    primary: Colors.green[600],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );
  final ButtonStyle raisedButtonStyle2 = ElevatedButton.styleFrom(
    onPrimary: Colors.white70,
    primary: Colors.red[400],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 15,
              ),
              Text('Processing please wait...'),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  dynamic _response = await widget.openDealProvider
                      .payClick(context, widget.invoice);
                  // capsaPrint(_response);
                  if (_response['res'] == 'success') {
                    showToast('Payment Success!.', context);
                  } else {
                    showToast(_response['messg'], context, type: 'warning');
                  }
                  //widget.openDealProvider.queryOpenDealList();
                  Navigator.of(context, rootNavigator: true).pop();
                  context.beamToNamed('/my-bids');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pay'),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: raisedButtonStyle2,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Cancel'),
                ),
              ),
            ],
          );
  }
}

showBuyNowDialog(
    BuildContext context, int index, OpenDealProvider openDealProvider) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      OpenDealModel openInvoice = openDealProvider.openInvoices[index];

      // capsaPrint(openInvoice);

      String title = "Buy Now";

      return AlertDialog(
        title: Text(
          title,
          style: titleStyle.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
        content: Container(
          constraints: BoxConstraints(minWidth: 450),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // pay dialog content

              Material(
                //Wrap with Material
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                elevation: 18.0,
                color: Color(0xFF801E48),
                clipBehavior: Clip.antiAlias,
                // Add This
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 35,
                  color: Color(0xFF801E48),
                  child: new Text('Confirm',
                      style:
                          new TextStyle(fontSize: 16.0, color: Colors.white)),
                  onPressed: () async {
                    openDealProvider.bidActionCall(
                        context, openInvoice, 1, index);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

showApproveLetterDialog(context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Sale Agreement",
          style: titleStyle,
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            constraints: BoxConstraints(minWidth: 550),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SfPdfViewer.network(
                    'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Digital Signature',
                    style: lableStyle.copyWith(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'Cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter First Name & Last Name'),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                        child: MaterialButton(
                      color: Colors.green,
                      child: Text(
                        'Download',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {},
                    ))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

showMoreDetailsDialog(context, OpenDealModel openInvoice) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Text(
              "More Details",
              style: titleStyle.copyWith(
                color: const Color(0xFFff9200),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(LineAwesomeIcons.remove),
            )
          ],
        ),
        content: MoreDetails(openInvoice),
      );
    },
  );
}

class MoreDetails extends StatefulWidget {
  final OpenDealModel openInvoice;

  MoreDetails(this.openInvoice);

  @override
  _MoreDetailsState createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails>
    with SingleTickerProviderStateMixin {
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2020, 11, 1), 5),
      new TimeSeriesSales(new DateTime(2020, 12, 1), 25),
      new TimeSeriesSales(new DateTime(2021, 1, 1), 50),
      new TimeSeriesSales(new DateTime(2021, 2, 1), 25),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        areaColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  int selectedIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    if (widget.openInvoice.isRevenue != '1')
      _tabController = TabController(
        length: 2,
        vsync: this,
      );
    else
      _tabController = TabController(
        length: 1,
        vsync: this,
      );
  }

  final subStyle = TextStyle(
    color: Colors.grey[800],
  );
  final headingStyle = TextStyle(
    color: const Color(0xFF3AC0C9),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final OpenDealModel _openInvoice = widget.openInvoice;

    DateTime invoiceDate =
        new DateFormat("yyyy-MM-dd").parse(_openInvoice.start_date);

    DateTime invoiceDueDate =
        new DateFormat("yyyy-MM-dd").parse(_openInvoice.due_date);

    String startDate = DateFormat.yMMMd('en_US').format(invoiceDate);
    String dueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);

    return Container(
      width: 1300,
      height: 1000,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(18),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(CurrencyIcon.naira),
                    title: Text(
                      formatCurrency(_openInvoice.invoice_value),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.08,
                      ),
                    ),
                    subtitle: Text((widget.openInvoice.isRevenue != '1')
                        ? 'Invoice Value'
                        : "Amount"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(LineAwesomeIcons.calendar),
                    title: Text(
                      (widget.openInvoice.isRevenue != '1')
                          ? 'Invoice Date:\n' + startDate
                          : 'Start Date:\n' + startDate,
                      style: TextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(LineAwesomeIcons.calendar_check_o),
                    title: Text(
                      (widget.openInvoice.isRevenue != '1')
                          ? 'Invoice Due Date:\n' + dueDate
                          : 'End Date:\n' + dueDate,
                      style: TextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 40,
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.blue,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey[600],
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2),
                          tabs: [
                            const Tab(
                              text: 'Vendor',
                            ),
                            if (widget.openInvoice.isRevenue != '1')
                              const Tab(
                                text: 'Anchor',
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        tabView('seller', _openInvoice),
                        if (widget.openInvoice.isRevenue != '1')
                          tabView('buyer', _openInvoice),
                      ],
                      controller: _tabController,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Column tabView(String type, OpenDealModel openInvoice) {
    final OpenDealModel _openInvoice = openInvoice;
    bool tab1 = true;

    if (type == 'buyer') {
      tab1 = false;
    }

    OpenDealModel data = _openInvoice;
    DateTime founded = new DateFormat("yyyy-MM-dd").parse(_openInvoice.founded);

    String _founded = DateFormat.yMMMd('en_US').format(founded);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    subtitle: Text(
                      tab1 ? data.companyName : data.customer_name,
                      style: subStyle,
                    ),
                    title: Text(
                      'Name',
                      style: headingStyle,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CircularPercentIndicator(
                    radius: 100,
                    percent: 0.1,
                    progressColor: Theme.of(context).accentColor,
                    center: Text(
                      '1%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    subtitle: Text(
                      tab1 ? data.sel_industry : data.industry,
                      style: subStyle,
                    ),
                    title: Text(
                      'Industry',
                      style: headingStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    subtitle: Text(
                      'Not Available',
                      style: subStyle,
                    ),
                    title: Text(
                      'Credit Profile',
                      style: headingStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    subtitle: GestureDetector(
                      child: Text(
                        type == 'buyer' ? 'Not Applicable' : 'Verified Invoice',
                        style: type == 'buyer'
                            ? subStyle
                            : TextStyle(
                                color: Colors.blue,
                              ),
                      ),
                      onTap: () {},
                    ),
                    title: Text(
                      'Invoice Verification',
                      style: headingStyle,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    subtitle: Text(
                      !tab1
                          ? DateFormat('d MMM y')
                              .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                  .parse(data.founded))
                              .toString()
                          : DateFormat('d MMM y')
                              .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                  .parse(data.sel_founded))
                              .toString(),
                      style: subStyle,
                    ),
                    title: Text(
                      'Founded',
                      style: headingStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    subtitle: Text(
                      'Filed on 2021-02-21',
                      style: subStyle,
                    ),
                    title: Text(
                      'Returns',
                      style: headingStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Text(
                            'Balance Sheet',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {},
                        ),
                        GestureDetector(
                          child: Text(
                            'Profit & Loss Statements',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    title: Text(
                      'Audited Statements',
                      style: headingStyle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    subtitle: Text(
                      !tab1 ? data.key_person : data.sel_key_person,
                      style: subStyle,
                    ),
                    title: Text(
                      'Key Promoter',
                      style: headingStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    subtitle: Text(
                      ' ',
                      style: subStyle,
                    ),
                    title: Text(
                      'Social Profiles',
                      style: headingStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    subtitle: GestureDetector(
                      child: Text(
                        type == 'buyer' ? 'Not Applicable' : 'Analysis Reports',
                        style: type == 'buyer'
                            ? subStyle
                            : TextStyle(
                                color: Colors.blue,
                              ),
                      ),
                      onTap: () {},
                    ),
                    title: Text(
                      'Bank Statements',
                      style: headingStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 250,
              width: 280,
              child: SimpleTimeSeriesChart(_createSampleData()),
            ),
            SizedBox(
              height: 250,
              width: 280,
              child: SimpleTimeSeriesChart(_createSampleData()),
            ),
          ],
        )
      ],
    );
  }
}
