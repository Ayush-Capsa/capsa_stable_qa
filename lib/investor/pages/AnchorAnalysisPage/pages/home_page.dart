import 'dart:async';
// import 'dart:html';

import 'package:beamer/beamer.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/common/responsive.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/tabs/balance_sheet_tab.dart';

import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/tabs/credit_score_tab.dart';

import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/tabs/profit_and_loss_tab.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/tabs/ratios_tab.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';

import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/text.dart';
import 'package:capsa/vendor-new/pages/confirm_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/credit_score_gauge.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/custom_button.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/tabular_view/tabular_view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';

class AnchorAnalysisHomePage extends StatefulWidget {
  double scale;
  OpenDealModel model;
  AnchorAnalysisHomePage({Key key, this.scale = 1, this.model})
      : super(key: key);

  @override
  State<AnchorAnalysisHomePage> createState() => _AnchorAnalysisHomePageState();
}

class _AnchorAnalysisHomePageState extends State<AnchorAnalysisHomePage>
    with SingleTickerProviderStateMixin {
  void navigate() {
    Beamer.of(context).beamToNamed('/view-analysis');
  }

  TabController _tabController;
  //late double scale;
  List<Widget> tabs = [];
  String customer_pan = "";
  bool dataLoaded = false;
  bool hasData = false;

  Widget getTab(int index, double scale) {
    switch (index) {
      case 0:
        return CreditScoreTab(
          scale: scale,
          panNumber: customer_pan,
          // panNumber:'22178927198',
        );
      case 1:
        return ProfitAndLossTab(
          scale: scale,
          panNumber: customer_pan,
          // panNumber:'22178927198',
        );
      case 2:
        return BalanceSheetTab(
          scale: scale,
          panNumber: customer_pan,
          // panNumber:'22178927198',
        );
      case 3:
        return RatiosTab(
          panNumber: customer_pan,
          // panNumber:'22178927198',
          scale: scale,
        );
    }
    return Container();
  }

  int _tabIndex = 0;

  void checkApi() async {
    var userData = Map<String, dynamic>.from(box.get('userData'));
    var _body = {};
    //_body['year'] = '2021';
    _body['panNumber'] = customer_pan;
    _body['year'] = '2022';

    var data = await callApi3('/credit/fetchCreditScore', body: _body);
    capsaPrint('credit analysis Data $data ${_body['panNumber']}');
    setState(() {
      dataLoaded = true;
    });
    if (data['yearsPresent'].length >0) {
      setState(() {
        hasData = true;
      });
    }
  }

  void setIndex(int n) {
    setState(() {
      _tabIndex = n;
    });
  }

  @override
  void initState() {
    customer_pan = widget.model != null
        ? widget.model.customer_pan
        : customer_pan;
    //widget.model.customer_pan = '22178927198';
    // customer_pan = '22178927198';
    tabs = [
      ChangeNotifierProvider(
        create: (BuildContext context) => AnchorAnalysisProvider(),
        child: CreditScoreTab(
          panNumber: customer_pan,
        ),
      ),
      ProfitAndLossTab(
        panNumber: customer_pan,
      ),
      BalanceSheetTab(
        panNumber: customer_pan,
      ),
      RatiosTab(
        panNumber: customer_pan,
      ),
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
    checkApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   width: Responsive.isMobile(context)?0:179,
            //   height: double.infinity,
            //   decoration: const BoxDecoration(
            //     color: Colors.black,
            //     borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
            //   ),
            //   child:Responsive.isMobile(context)?Container(): Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       SizedBox(
            //         height: 43.5 * widget.scale,
            //       ),
            //       Icon(
            //         Icons.arrow_back,
            //         color: Colors.blue,
            //         size: 21 * widget.scale,
            //       )
            //     ],
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !Responsive.isMobile(context)
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: 37 * widget.scale,
                                top: 51 * widget.scale,
                                right: 36 * widget.scale),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Anchor Information',
                                    style: GoogleFonts.poppins(
                                        fontSize: widget.scale == 1 ? 28 : 18,
                                        fontWeight: FontWeight.w600)
                                    //TextStyle(fontWeight: FontWeight.w600, fontSize: 36,),
                                    ),
                                //Icon(Icons.notifications),
                                Container(
                                  width: 120 * widget.scale,
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 18 * widget.scale,
                                          height: 16 * widget.scale,
                                          child: Icon(
                                            Icons.notifications_none_sharp,
                                          )),
                                      SizedBox(
                                        width: 35 * widget.scale,
                                      ),
                                      Image.asset(
                                        'assets/Ellipse 4.png',
                                        height: widget.scale == 1 ? 60 : 40,
                                        width: widget.scale == 1 ? 60 : 40,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 87 * widget.scale,
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 70 * widget.scale),
                            child: Container(
                              width: widget.scale == 1 ? 70 : 40,
                              height: widget.scale == 1 ? 70 : 40,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(58, 192, 201, 1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Image.asset(
                                'assets/company_icon.png',
                                width: widget.scale == 1 ? 26.33 : 20,
                                height: widget.scale == 1 ? 24 : 18,
                              )),
                            )),
                        const SizedBox(
                          width: 12,
                        ),
                        IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.model != null?widget.model.customer_name:"",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: widget.scale == 1 ? 21 : 14),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                widget.model != null?widget.model.customerCIN:"",
                                //'Test CIN Number',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: widget.scale == 1 ? 15 : 12,
                                  color: Color.fromRGBO(130, 130, 130, 1),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 38 * widget.scale, top: 62 * widget.scale),
                      child: dataLoaded
                          ? hasData
                              ? TabBar(
                                  isScrollable: true,
                                  onTap: (n) {
                                    setIndex(n);
                                  },
                                  labelColor: Colors.black,
                                  indicatorWeight: widget.scale == 1 ? 3 : 1,
                                  labelStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: widget.scale == 1 ? 16 : 10),
                                  unselectedLabelColor:
                                      Color.fromRGBO(130, 130, 130, 1),
                                  unselectedLabelStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: widget.scale == 1 ? 16 : 10),
                                  tabs: const [
                                    Tab(
                                      text: 'Credit Score',
                                    ),
                                    Tab(
                                      text: 'Profit And Loss',
                                    ),
                                    Tab(
                                      text: 'Balance Sheet',
                                    ),
                                    Tab(
                                      text: 'Ratios',
                                    ),
                                  ],
                                  controller: _tabController,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                )
                              : Container(
                                  height: 200,
                                  child: Center(
                                    child: Text(
                                      'Data is not available for this anchor',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              widget.scale == 1 ? 21 : 14),
                                    ),
                                  ),
                                )
                          : Container(
                              height: 200,
                              child:
                                  Center(child: CircularProgressIndicator())),
                    ),
                    dataLoaded
                        ? hasData
                            ? getTab(_tabIndex, widget.scale)
                            : Container()
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 69 * widget.scale,
                          left: 50 * widget.scale,
                          right: 59 * widget.scale),
                      child: IntrinsicWidth(
                        //width: 1103,
                        child: Align(
                          child: Text(
                            '© 2022 Capsa Technology. All rights reserved. No part of this publication may be reproduced or transmitted in any form or for any purpose without the express permission of Capsa Technology. These materials are provided by Capsa Technology for informational purposes only, without representation or warranty of any kind, and Capsa Technology shall not be liable for errors or omissions with respect to the materials. All forward-looking statements are subject to various risks and uncertainties that could cause actual results to differ materially from expectations. Readers are cautioned not to place undue reliance on these forward-looking statements, which speak only as of their dates, and they should not be relied upon in making decisions.',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(
                                fontSize: widget.scale == 1 ? 12 : 8,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
