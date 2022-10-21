import 'package:capsa/admin/dialogs/investor_dialogs.dart';
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
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class InvestorBidDetailsPage extends StatefulWidget {
  final invNum;

  const InvestorBidDetailsPage(this.invNum, {Key key}) : super(key: key);

  @override
  State<InvestorBidDetailsPage> createState() => _LiveBidDetailsPageState();
}

class _LiveBidDetailsPageState extends State<InvestorBidDetailsPage> {
  String invNum = "";

  @override
  void initState() {
    super.initState();
    invNum = widget.invNum;
    Provider.of<OpenDealProvider>(context, listen: false).queryOpenDealList();
    Provider.of<ProfileProvider>(context, listen: false).queryPortfolioData2();
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
                  int index = _openDealProvider.openInvoices.indexWhere((element) {
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
                              child: bidDetailsFrameTopInfo(context, openInvoices, isDetails: true),
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
                                      if (_openDealProvider.showBuyNow(_openDealProvider.openInvoices[index]))
                                        InkWell(
                                          onTap: () {
                                            if (kycErrorCondition(context, _profileProvider)) {
                                              showKycError(context, _profileProvider);
                                              return;
                                            }
                                            showBidDialog(context, index, _openDealProvider, buyNow: true);
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
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                            child: Center(
                                              child: Text(
                                                'Buy Now',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(242, 242, 242, 1),
                                                    fontSize: 16,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (_openDealProvider.shwBid(_openDealProvider.openInvoices[index]))
                                        InkWell(
                                          onTap: () {
                                            if (kycErrorCondition(context, _profileProvider)) {
                                              showKycError(context, _profileProvider);
                                              return;
                                            }
                                            showBidDialog(context, index, _openDealProvider);
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
                                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                              child: Center(
                                                child: Text(
                                                  'Place Bid',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(242, 242, 242, 1),
                                                      fontSize: 16,
                                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight: FontWeight.normal,
                                                      height: 1),
                                                ),
                                              )),
                                        ),
                                      if (_openDealProvider.showPay(_openDealProvider.openInvoices[index]))
                                        InkWell(
                                          onTap: () {

                                            if (kycErrorCondition(context, _profileProvider)) {
                                              showKycError(context, _profileProvider);
                                              return;
                                            }

                                            showPayDialog(context, _openDealProvider.openInvoices[index], _openDealProvider);
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
                                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                              child: Center(
                                                child: Text(
                                                  'Pay',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(242, 242, 242, 1),
                                                      fontSize: 16,
                                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight: FontWeight.normal,
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
                        bidDetailsInfo(openInvoices,context),
                        if (Responsive.isMobile(context))
                          SizedBox(
                            height: 20,
                          ),
                        if (Responsive.isMobile(context))
                          Container(
                            child: Column(
                              children: [
                                if (_openDealProvider.showBuyNow(_openDealProvider.openInvoices[index]))
                                  InkWell(
                                    onTap: () {
                                      showBidDialog(context, index, _openDealProvider, buyNow: true);
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
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Buy Now',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromRGBO(242, 242, 242, 1),
                                              fontSize: 16,
                                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_openDealProvider.shwBid(_openDealProvider.openInvoices[index]))
                                  InkWell(
                                    onTap: () {
                                      showBidDialog(context, index, _openDealProvider);
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
                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                        child: Center(
                                          child: Text(
                                            'Place Bid',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(242, 242, 242, 1),
                                                fontSize: 16,
                                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                        )),
                                  ),
                                if (_openDealProvider.showPay(_openDealProvider.openInvoices[index]))
                                  InkWell(
                                    onTap: () {
                                      showPayDialog(context, _openDealProvider.openInvoices[index], _openDealProvider);
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
                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                        child: Center(
                                          child: Text(
                                            'Pay',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(242, 242, 242, 1),
                                                fontSize: 16,
                                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
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
                })
            ],
          ),
        ),
      ),
    );
  }
}
