import 'dart:convert';
import 'package:beamer/src/beamer.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:capsa/admin/dialogs/investor_dialogs.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/investor/data/show_kyc_dialog.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/investor/provider/opendeal_provider.dart';
import 'package:capsa/investor/widgets/bid_details_widgets.dart';
import 'package:capsa/providers/profile_provider.dart';

import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class InvestorBidDetailsPage extends StatefulWidget {
  final invNum;
  bool isSplit;

  InvestorBidDetailsPage(this.invNum, {this.isSplit = false,Key key})
      : super(key: key);
  @override
  State<InvestorBidDetailsPage> createState() => _LiveBidDetailsPageState();
}

class _LiveBidDetailsPageState extends State<InvestorBidDetailsPage> {
  String invNum = "";
  String _url = apiUrl;

  List<Widget> splitInvoices = [];
  bool isSplit = true;

  // dynamic navigate(String invNo) {
  //   context.beamToNamed(
  //     '/live-deals/bid-details/' + invNo,
  //   );
  // }

  Future<void> splitInvoice(String invoiceNumber) async {
    if (widget.isSplit) {
      var _body = {};
      _body['parent_invoice'] = invoiceNumber;

      print('Split initialised');

      dynamic _uri;
      _uri = _url + 'dashboard/i/liveSplits';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      print('Split Data 1 $data');
      var result = {};

      if (data.length != 0) {
        splitInvoices.add(const SizedBox(
          height: 36,
        ));
        splitInvoices.add(Responsive.isMobile(context)?drawSplitInvoicesInformationPanel('Additional Information',
            'You can also invest in a portion of the invoice. Find  the portions available below.',context):drawSplitInvoicesInformationPanel('Information',
            'You can also bid on other split invoices similar to $invoiceNumber. View them below',context));
        splitInvoices.add(const SizedBox(
          height: 36,
        ));
        data.forEach((element) {
          splitInvoices.add(
            drawSplitInvoicesInfo(
              formatCurrency(element['invoice_value'].toString()),
              formatCurrency(element['ask_amt'].toString()),
              element['payment_terms'].toString().replaceAll('DAYS', ''),
              element['invoice_number'],
              element['isSplit'].toString(),
              context,
              showButton: true,
            ),
          );
          splitInvoices.add(const SizedBox(
            height: 18,
          ));
          setState(() {
            isSplit = true;
          });
        });
      }
    }
  }

  void getData() async {
    await splitInvoice(widget.invNum);
  }



  @override
  void initState() {
    super.initState();
    invNum = widget.invNum;
    print('invoice no. $invNum');
    //openDeal = Provider.of<OpenDealProvider>(context);
    Provider.of<OpenDealProvider>(context, listen: false).queryOpenDealList();
    Provider.of<ProfileProvider>(context, listen: false).queryPortfolioData2();

    getData();

  }

  OpenDealModel openInvoices;

  @override
  Widget build(BuildContext context) {
    final _openDealProvider = Provider.of<OpenDealProvider>(context);
    final _profileProvider = Provider.of<ProfileProvider>(context);

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
              TopBarWidget("Bid Details", ""),
              if (!Responsive.isMobile(context))
                SizedBox(
                  height: 18,
                ),
              if (_openDealProvider.loadingDeals)
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: CircularProgressIndicator(),
                ))
              else
                Builder(builder: (context) {
                  int index =
                      _openDealProvider.openInvoices.indexWhere((element) {
                    return element.invoice_number == invNum;
                  });
                  openInvoices = _openDealProvider.openInvoices[index];
                  if (index == -1) {
                    return Container(
                      child: Center(child: Text("No data found")),
                    );
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        OrientationSwitcher(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 4,
                              child: bidDetailsFrameTopInfo(
                                  context, openInvoices,
                                  isDetails: true),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            if (!Responsive.isMobile(context))
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: [
                                      if (_openDealProvider.showBuyNow(
                                          _openDealProvider
                                              .openInvoices[index]))
                                        InkWell(
                                          onTap: () {
                                            var userData = Map<String, dynamic>.from(box.get('userData'));
                                            //print('User Data $userData');

                                            int isBlackListed = int.parse(userData['isBlacklisted']);


                                            if(isBlackListed == 1){
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                    title: const Text(
                                                      'Function Suspended',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold, fontSize: 16),
                                                    ),
                                                    content: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text(
                                                            'This functionality has been temporarily suspended',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 14),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: ElevatedButton(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(4),
                                                            child: Text("Close".toUpperCase(),
                                                                style: TextStyle(fontSize: 14)),
                                                          ),
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.white),
                                                              backgroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Theme.of(context).primaryColor),
                                                              shape:
                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(50),
                                                                      side: BorderSide(
                                                                          color: Theme.of(context)
                                                                              .primaryColor)))),
                                                          onPressed: () =>
                                                              Navigator.of(context, rootNavigator: true)
                                                                  .pop(),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                              return;
                                            }
                                            if (kycErrorCondition(
                                                context, _profileProvider)) {
                                              showKycError(
                                                  context, _profileProvider);
                                              return;
                                            }
                                            showBidDialog(context, index,
                                                _openDealProvider,
                                                buyNow: true);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              ),
                                              color: Color.fromRGBO(
                                                  242, 153, 74, 1),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            child: Center(
                                              child: Text(
                                                'Buy Now',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 242, 1),
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (_openDealProvider.shwBid(
                                          _openDealProvider
                                              .openInvoices[index]))
                                        InkWell(
                                          onTap: () async{
                                            var userData = Map<String, dynamic>.from(box.get('userData'));
                                            //print('User Data $userData');

                                            int isBlackListed = int.parse(userData['isBlacklisted']);


                                            if(isBlackListed == 1){
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                    title: const Text(
                                                      'Function Suspended',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold, fontSize: 16),
                                                    ),
                                                    content: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text(
                                                            'This functionality has been temporarily suspended',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 14),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: ElevatedButton(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(4),
                                                            child: Text("Close".toUpperCase(),
                                                                style: TextStyle(fontSize: 14)),
                                                          ),
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.white),
                                                              backgroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Theme.of(context).primaryColor),
                                                              shape:
                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(50),
                                                                      side: BorderSide(
                                                                          color: Theme.of(context)
                                                                              .primaryColor)))),
                                                          onPressed: () =>
                                                              Navigator.of(context, rootNavigator: true)
                                                                  .pop(),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                              return;
                                            }
                                            if (kycErrorCondition(
                                                context, _profileProvider)) {
                                              showKycError(
                                                  context, _profileProvider);
                                              return;
                                            }
                                            InvoiceProvider _invoiceProvider =
                                            Provider.of<InvoiceProvider>(context, listen: false);
                                            showBidDialog(context, index, _openDealProvider);

                                            // showBidDialog(context, index,
                                            //     _openDealProvider);
                                            // show
                                          },
                                          child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                color: Color.fromRGBO(
                                                    0, 152, 219, 1),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 15),
                                              child: Center(
                                                child: Text(
                                                  'Place Bid',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          242, 242, 242, 1),
                                                      fontSize: 16,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                              )),
                                        ),
                                      if (_openDealProvider.showPay(
                                          _openDealProvider
                                              .openInvoices[index]))
                                        InkWell(
                                          onTap: () {
                                            if (kycErrorCondition(
                                                context, _profileProvider)) {
                                              showKycError(
                                                  context, _profileProvider);
                                              return;
                                            }

                                            showPayDialog(
                                                context,
                                                _openDealProvider
                                                    .openInvoices[index],
                                                _openDealProvider);
                                          },
                                          child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                color: Color.fromRGBO(
                                                    0, 152, 219, 1),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 15),
                                              child: Center(
                                                child: Text(
                                                  'Pay',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          242, 242, 242, 1),
                                                      fontSize: 16,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                              )),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        bidDetailsInfo(openInvoices, context),
                        if (Responsive.isMobile(context))
                          SizedBox(
                            height: 20,
                          ),
                        if (Responsive.isMobile(context))
                          Container(
                            child: Column(
                              children: [
                                if (_openDealProvider.showBuyNow(
                                    _openDealProvider.openInvoices[index]))
                                  InkWell(
                                    onTap: () {
                                      var userData = Map<String, dynamic>.from(box.get('userData'));
                                      //print('User Data $userData');

                                      int isBlackListed = int.parse(userData['isBlacklisted']);


                                      if(isBlackListed == 1){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text(
                                                'Function Suspended',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              content: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'This functionality has been temporarily suspended',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4),
                                                      child: Text("Close".toUpperCase(),
                                                          style: TextStyle(fontSize: 14)),
                                                    ),
                                                    style: ButtonStyle(
                                                        foregroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            Colors.white),
                                                        backgroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            Theme.of(context).primaryColor),
                                                        shape:
                                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(50),
                                                                side: BorderSide(
                                                                    color: Theme.of(context)
                                                                        .primaryColor)))),
                                                    onPressed: () =>
                                                        Navigator.of(context, rootNavigator: true)
                                                            .pop(),
                                                  ),
                                                ),
                                              ],
                                            ));
                                        return;
                                      }
                                      showBidDialog(
                                          context, index, _openDealProvider,
                                          buyNow: true);
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
                                        color: Color.fromRGBO(242, 153, 74, 1),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Buy Now',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  242, 242, 242, 1),
                                              fontSize: 16,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_openDealProvider.shwBid(
                                    _openDealProvider.openInvoices[index]))
                                  InkWell(
                                    onTap: () {
                                      var userData = Map<String, dynamic>.from(box.get('userData'));
                                      //print('User Data $userData');

                                      int isBlackListed = int.parse(userData['isBlacklisted']);


                                      if(isBlackListed == 1){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text(
                                                'Function Suspended',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              content: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'This functionality has been temporarily suspended',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4),
                                                      child: Text("Close".toUpperCase(),
                                                          style: TextStyle(fontSize: 14)),
                                                    ),
                                                    style: ButtonStyle(
                                                        foregroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            Colors.white),
                                                        backgroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            Theme.of(context).primaryColor),
                                                        shape:
                                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(50),
                                                                side: BorderSide(
                                                                    color: Theme.of(context)
                                                                        .primaryColor)))),
                                                    onPressed: () =>
                                                        Navigator.of(context, rootNavigator: true)
                                                            .pop(),
                                                  ),
                                                ),
                                              ],
                                            ));
                                        return;
                                      }
                                      showBidDialog(
                                          context, index, _openDealProvider);
                                      // show
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        child: Center(
                                          child: Text(
                                            'Place Bid',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    242, 242, 242, 1),
                                                fontSize: 16,
                                                letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                        )),
                                  ),
                                if (_openDealProvider.showPay(
                                    _openDealProvider.openInvoices[index]))
                                  InkWell(
                                    onTap: () {
                                      showPayDialog(
                                          context,
                                          _openDealProvider.openInvoices[index],
                                          _openDealProvider);
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          color: Color.fromRGBO(0, 152, 219, 1),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        child: const Center(
                                          child: Text(
                                            'Pay',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    242, 242, 242, 1),
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
                          )
                      ],
                    ),
                  );
                }),

              _openDealProvider.loadingDeals == false
                  ? isSplit
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: splitInvoices,
                        )
                      : Container()
                  : Container()

            ],
          ),
        ),
      ),
    );
  }
}

class CreateAccountWarning extends StatelessWidget {
  String currency;

  CreateAccountWarning({Key key,@required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 584,
      height: 579,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: HexColor('#F5FBFF')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/warning.png',
            width: 80,
            height: 80,
          ),
          Text(
            '$currency account required',
            style:
            GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Text(
            'To trade your $currency invoices, you would need to create a $currency account with LeatherbackTM.',
            style:
            GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: (){
              // nav;
              //Beamer.of(context).beamToNamed('/confirmInvoice');
              Navigator.pop(context);
            },
            child: Container(
              height: 60,
              width: 342,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: HexColor('#0098DB')),
              child: Center(child: Text('Create Account',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.center,),),
            ),
          ),
        ],
      ),
    );
  }
}