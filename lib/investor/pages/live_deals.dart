import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:capsa/admin/dialogs/investor_dialogs.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/investor/data/show_kyc_dialog.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';
import 'package:capsa/investor/provider/opendeal_provider.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveDealsPage extends StatefulWidget {
  const LiveDealsPage({Key key}) : super(key: key);

  @override
  State<LiveDealsPage> createState() => _LiveDealsPageState();
}

class _LiveDealsPageState extends State<LiveDealsPage> with SingleTickerProviderStateMixin {
  bool onlyRF = false;
  int selectedIndex = 0;
  TabController controller;
  bool loaded = false;

  void checkSpeed() {
    var openDeal = Provider.of<OpenDealProvider>(context, listen: false);
    var result = openDeal.queryOpenDealList();
  }

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).queryPortfolioData2();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(milliseconds: 3000));
    // capsaPrint(Responsive.isMobile(context));
    loaded = false;
    ProfileProvider _profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    _profileProvider.queryPortfolioData2();
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (!Responsive.isMobile(context))
          //   SizedBox(
          //     height: 22,
          //   // ),
          TopBarWidget(
              "Live Deals", "Market place to buy and bid for invoices"),
          // if (!Responsive.isMobile(context))
          //   SizedBox(
          //     height: 22,
          //   ),

          SizedBox(
            height: (!Responsive.isMobile(context)) ? 8 : 15,
          ),

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       InkWell(
          //           onTap: () {
          //             selectedIndex = 0;
          //             setState(() {
          //               onlyRF = false;
          //             });
          //             capsaPrint('pendong pressed');
          //           },
          //           child: Text(
          //             'Invoices',
          //             style: GoogleFonts.poppins(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 20,
          //                 color: selectedIndex == 0
          //                     ? HexColor('#0098DB')
          //                     : Colors.black),
          //           )),
          //
          //       SizedBox(width: 20,),
          //
          //       InkWell(
          //           onTap: () {
          //             selectedIndex = 1;
          //
          //             setState(() {
          //               onlyRF = true;
          //             });
          //           },
          //           child: Text(
          //             'Buy Now Invoices',
          //             style: GoogleFonts.poppins(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 20,
          //                 color: selectedIndex == 1
          //                     ? HexColor('#0098DB')
          //                     : Colors.black),
          //           )),
          //     ],
          //   ),
          // ),

          TabBar(
            controller: controller,
            isScrollable: true,
            onTap: (v){
              if(loaded){
                if(v == 0){
                  onlyRF = false;
                }else{
                  onlyRF = true;
                }
                setState(() {

                });
              }else{
                controller.index = v==0 ? 1 : 0;
              }

            },
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: HexColor('#0098DB'),
            indicatorWeight: 2,
            labelColor: Colors.black,
            unselectedLabelColor: HexColor('#828282'),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.2),
            tabs: const [
              Tab(
                text: 'Invoices',
              ),

              Tab(
                text: 'Buy-Only Invoices',
              ),
            ],
          ),

          Expanded(
              child: FutureBuilder<Object>(
                  future: Provider.of<OpenDealProvider>(context, listen: false)
                      .queryOpenDealList(onlyRF: onlyRF),
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
                    } else {
                      loaded = true;
                      final _openDealProvider =
                          Provider.of<OpenDealProvider>(context);
                      final profileProvider =
                          Provider.of<ProfileProvider>(context);
                      return Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              SizedBox(
                                height: 10,
                              ),


                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.76,
                                  child: _openDealProvider.invoicesCount > 0 ? StaggeredGridView.countBuilder(
                                      crossAxisCount:
                                          Responsive.isMobile(context) ? 1 : 3,
                                      crossAxisSpacing:
                                          Responsive.isMobile(context)
                                              ? 20
                                              : 30,
                                      mainAxisSpacing:
                                          Responsive.isMobile(context)
                                              ? 20
                                              : 30,
                                      padding: EdgeInsets.all(5),
                                      staggeredTileBuilder: (int index) =>
                                          StaggeredTile.fit(1),
                                      // shrinkWrap: true,
                                      itemCount:
                                          _openDealProvider.invoicesCount,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return LiveBibsCard(
                                          context,
                                          _openDealProvider.openInvoices[index],
                                          index,
                                          _openDealProvider,
                                          _profileProvider,
                                          onlyRF ? '1' : '0'
                                        );
                                      }) : Center(child: Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Text('No Invoices available!', style: GoogleFonts.poppins(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),),
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }))
        ],
      ),
    );
  }
}

class LiveBibsCard extends StatelessWidget {
  final BuildContext context1;
  final OpenDealModel openInvoices;
  final int index;
  final OpenDealProvider openDealProvider;
  final ProfileProvider _profileProvider;
  bool showViewDeals = false;
  String onlyRF;
  //BuildContext context;
  LiveBibsCard(this.context1, this.openInvoices, this.index,
      this.openDealProvider, this._profileProvider, this.onlyRF,
      {Key key})
      : super(key: key);
  final double width = 360;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 10,
      padding: EdgeInsets.only(left: 6, top: 4, right: 6),
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            offset: Offset(5.0, 5.0),
            blurRadius: 5.0,
          ),
          BoxShadow(
            color: Color.fromARGB(255, 255, 255, 255),
            offset: Offset(-2.0, -2.0),
            blurRadius: 1.0,
          )
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Color.fromRGBO(218, 253, 255, 1),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 1 : 4, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isMobile(context) ? 1 : 6,
                    vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    // color: Color.tra
                                    ),
                                child: Image.asset(
                                  "assets/images/Frame 83.png",
                                  width: 60,
                                )),
                            SizedBox(width: 8),
                            Container(
                              // width: 150,

                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    openInvoices.customer_name.truncateTo(
                                        Responsive.isMobile(context) ? 15 : 18),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: Responsive.isMobile(context)
                                            ? 14
                                            : 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'CAC: ' + openInvoices.customerCIN,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontSize: Responsive.isMobile(context)
                                            ? 12
                                            : 15,
                                        overflow: TextOverflow.ellipsis,
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
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromRGBO(58, 192, 201, 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Anchor',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  fontSize: 12,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Color.fromRGBO(245, 251, 255, 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Invoice Value',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '₦',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  formatCurrency(openInvoices.invoice_value),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
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
                    VerticalDivider(
                      width: 2,
                      color: Colors.black54,
                    ),
                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Tenure',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  openInvoices.companySafePercentage + ' Days',
                                  //DateFormat("yyyy-MM-dd").parse(openInvoices.due_date).difference(DateFormat("yyyy-MM-dd").parse(openInvoices.start_date)).inDays.toString() + ' Days',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
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
                  ],
                ),
              ),
              SizedBox(height: 16),
              if (openDealProvider
                  .showBuyNow(openDealProvider.openInvoices[index]))
                Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Buy Now Price:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            SizedBox(width: 4),
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
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
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
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
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
                      SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                var userData = Map<String, dynamic>.from(
                                    box.get('userData'));
                                // print('User Data $userData');

                                int isBlackListed =
                                    int.parse(userData['isBlacklisted']);

                                if (isBlackListed == 1) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text(
                                              'Function Suspended',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'This functionality has been temporarily suspended',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Text(
                                                        "Close".toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                  ),
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              Colors.white),
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              Theme.of(context)
                                                                  .primaryColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(50),
                                                              side: BorderSide(color: Theme.of(context).primaryColor)))),
                                                  onPressed: () => Navigator.of(
                                                          context,
                                                          rootNavigator: true)
                                                      .pop(),
                                                ),
                                              ),
                                            ],
                                          ));
                                  return;
                                }
                                showBidDialog(context1, index, openDealProvider,
                                    buyNow: true);
                              },
                              child: Container(
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
                                    horizontal: 12, vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Buy Now',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(242, 242, 242, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 55,
                ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromRGBO(245, 251, 255, 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (openDealProvider
                      .shwBid(openDealProvider.openInvoices[index]) &&
                  openDealProvider.openInvoices[index].RF.toString() != '1')
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          capsaPrint('Place bid pass 1');
                          var userData =
                              Map<String, dynamic>.from(box.get('userData'));
                          // print('User Data $userData');
                          capsaPrint('Place bid pass 2');

                          int isBlackListed =
                              int.parse(userData['isBlacklisted']);

                          capsaPrint('Place bid pass 3');

                          if (isBlackListed == 1) {
                            capsaPrint('Place bid pass 4');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        'Function Suspended',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                            ),
                                            style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        Colors.white),
                                                backgroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        Theme.of(context)
                                                            .primaryColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(50),
                                                        side: BorderSide(color: Theme.of(context).primaryColor)))),
                                            onPressed: () => Navigator.of(
                                                    context,
                                                    rootNavigator: true)
                                                .pop(),
                                          ),
                                        ),
                                      ],
                                    ));
                            return;
                          }
                          capsaPrint('Place bid pass 5');
                          if (kycErrorCondition(context, _profileProvider)) {
                            capsaPrint('Place bid pass 6');
                            showKycError(context, _profileProvider);
                            return;
                          }
                          capsaPrint('SHow Bid Dialog passwd');

                          showBidDialog(context1, index, openDealProvider);
                          if (openDealProvider.openInvoices[index].RF == '1') {
                            final prefs = await SharedPreferences.getInstance();
                            showToast(prefs.getString('message'), context1,
                                type: prefs.getString('type'));
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            color: Color.fromRGBO(0, 152, 219, 1),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Place Bid',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(242, 242, 242, 1),
                                    // fontFamily: 'Poppins',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (openDealProvider
                  .showPay(openDealProvider.openInvoices[index]))
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await showPayDialog(
                              context,
                              openDealProvider.openInvoices[index],
                              openDealProvider);
                        },
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
                              horizontal: 16, vertical: 16),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Pay',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(242, 242, 242, 1),
                                    // fontFamily: 'Poppins',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        showViewDeals = false;
                        //await Future.delayed(Duration(milliseconds: 3000));
                        context.beamToNamed(
                          '/live-deals/bid-details/' +
                              openInvoices.invoice_number +
                              '/' +
                              openInvoices.isSplit + '/' + onlyRF ,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          border: Border.all(
                            color: Color.fromRGBO(58, 192, 201, 1),
                            width: 2,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'View Deal',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(58, 192, 201, 1),
                                  // fontFamily: 'Poppins',
                                  fontSize: 16,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
