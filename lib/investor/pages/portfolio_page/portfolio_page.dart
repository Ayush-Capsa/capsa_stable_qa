import 'package:capsa/common/page_bgimage.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/investor/data/my-portfolio-chart1.dart';

import 'package:capsa/investor/pages/portfolio_page/bids_analysis_tab.dart';
import 'package:capsa/investor/pages/portfolio_page/overview_tab.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/StatefulWrapper.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generatedcardwidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:beamer/beamer.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {

  dynamic anchor;
  TextEditingController currencyController = TextEditingController(text: 'All');
  String selectedCurrency = "";
  bool checking = false;
  Map<String, String> currencyAvailability = {};
  List<String> term = [];
  bool currencyLoaded = true;

  int currentIndex = 0;

  List<dynamic> tabs = [
    OverView(),
    BidsAnalysis()
  ];

  Widget returnTab(int index, dynamic selectedCurrency){
    return index == 0?OverView(selectedCurrency: selectedCurrency,):BidsAnalysis(selectedCurrency: selectedCurrency,);
  }

  Widget tab(String text, int index){
    return InkWell(
      onTap: (){
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        width: Responsive.isMobile(context) ? 110 : 154,
        height: Responsive.isMobile(context) ? 34 : 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(15),bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
          color: index == currentIndex?HexColor('#0098DB'):Colors.white,
          border: Border.all(width: 2, color: HexColor('#0098DB')),

        ),
        child: Center(
          child: Text(text,style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: Responsive.isMobile(context) ? 12 :  18, color: index == currentIndex?Colors.white:Colors.black),),
        ),
      ),
    ) ;
  }

  // void getData() async {
  //   capsaPrint('get data called');
  //   // setState(() {
  //   //   currencyLoaded = false;
  //   // });
  //   InvoiceProvider _invoiceProvider =
  //   Provider.of<InvoiceProvider>(context, listen: false);
  //   Map<dynamic, dynamic> _data = {};
  //   _data = await _invoiceProvider.getCurrencies();
  //   var currencyCheck = await _invoiceProvider.checkCurrency();
  //   capsaPrint('Response check $currencyCheck');
  //   term = [];
  //   var _items = _data['data'];
  //   //term.add('All');
  //   _items.forEach((element) {
  //     term.add(element['currency_code'].toString());
  //     currencyAvailability[element['currency_code']] =
  //         element['is_active'].toString();
  //   });
  //   selectedCurrency = term[0];
  //   setState(() {
  //     currencyLoaded = true;
  //   });
  // }

  @override
  void initState(){
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context);

    PortfolioData portfolioData = _profileProvider.portfolioData;

    MyPortfolioData myPortfolioData = _profileProvider.myPortfolioData;

    // if(Responsive.isMobile(context))currentIndex = 0;

    return StatefulWrapper(
      onInit: () {
        // _profileProvider.myportfoliopageData();
        //
        // _profileProvider.queryPortfolioData2(currency: selectedCurrency);
        // _profileProvider.queryFewData(currency: selectedCurrency);
        // _profileProvider.queryBankTransaction(currency: selectedCurrency);

      },
      child: Scaffold(
        body: Container(
          decoration: bgDecoration,
          child: SingleChildScrollView(
            child: Padding(
              padding: Responsive.isMobile(context) ? EdgeInsets.fromLTRB(10, 15, 10, 15) : EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: currencyLoaded?Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if(! Responsive.isMobile(context))
                  SizedBox(
                    height: 22,
                  ),
                  TopBarWidget("My Portfolio", ""),

                  SizedBox(
                    height: 31,
                  ),

                  //if(! Responsive.isMobile(context))
                    OrientationSwitcher(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: Responsive.isMobile(context)? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    orientation: Responsive.isMobile(context)?'Column':'Row',
                    children: [
                      Row(
                        children: [
                          tab('Overview',0),
                          SizedBox(width: 15,),
                          tab('Bids Analysis',1)
                        ],

                      ),

                      //SizedBox(height: 15,),
                    ],
                  ),

                  SizedBox(
                    height: Responsive.isMobile(context)? 8 : 31,
                  ),

                  returnTab(currentIndex, selectedCurrency),

                  // OrientationSwitcher(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Flexible(
                  //       flex: 2,
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //             child: SingleChildScrollView(
                  //               scrollDirection: Axis.horizontal,
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 children: [
                  //                   InkWell(
                  //                     // onTap: () => context.beamToNamed("/account"),
                  //                     child: GeneratedCardWidget(
                  //                         title: "Companies in Portfolio",
                  //                         icon: "assets/images/Frame 140.png",
                  //                         currency: false,
                  //                         subText: myPortfolioData.companyInyPortfolio.toString(),
                  //                         color: HexColor("#0098DB")),
                  //                   ),
                  //                   SizedBox(
                  //                     width: 14,
                  //                   ),
                  //                   InkWell(
                  //                     onTap: () => context.beamToNamed("/my-bids"),
                  //                     child: GeneratedCardWidget(
                  //                         title: "Total Invoice Bought",
                  //                         icon: "assets/images/invbought.png",
                  //                         currency: true,
                  //                         subText: formatCurrency(myPortfolioData.invoiceBought),
                  //                         color: HexColor("#219653")),
                  //                   ),
                  //                   SizedBox(
                  //                     width: 14,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             height: 35,
                  //           ),
                  //           Text(
                  //             'Portfolio Chart',
                  //             textAlign: TextAlign.right,
                  //             style: TextStyle(
                  //                 color: Color.fromRGBO(51, 51, 51, 1),
                  //                 fontFamily: 'Poppins',
                  //                 fontSize: 20,
                  //                 letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                  //                 fontWeight: FontWeight.normal,
                  //                 height: 1),
                  //           ),
                  //           SizedBox(
                  //             height: 3,
                  //           ),
                  //           Text(
                  //             'Chart analysis of your invoice investment is shown here',
                  //             textAlign: TextAlign.right,
                  //             style: TextStyle(
                  //                 color: Color.fromRGBO(51, 51, 51, 1),
                  //                 fontSize: 12,
                  //                 letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                  //                 fontWeight: FontWeight.normal,
                  //                 height: 1),
                  //           ),
                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           if(_profileProvider.portfolioData.x_axis != null)
                  //           Container(
                  //             //height: 600,
                  //             //width: double.infinity,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(Responsive.isMobile(context) ? 20 : 30.0),
                  //                 topRight: Radius.circular(Responsive.isMobile(context) ? 20 : 30.0),
                  //                 bottomRight: Radius.circular(Responsive.isMobile(context) ? 0 : 0.0),
                  //                 bottomLeft: Radius.circular(Responsive.isMobile(context) ? 20 : 30.0),
                  //               ),
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: Color.fromARGB(25, 0, 0, 0),
                  //                   offset: Offset(4.0, 4.0),
                  //                   blurRadius: 5.0,
                  //                 ),
                  //                 BoxShadow(
                  //                   color: Color.fromARGB(255, 255, 255, 255),
                  //                   offset: Offset(-4.0, -4.0),
                  //                   blurRadius: 0.0,
                  //                 )
                  //               ],
                  //               gradient: RadialGradient(
                  //                 center: Alignment(-1.0, -1.0),
                  //                 radius: 2,
                  //                 //stops: [0.0, 1.0],
                  //                 colors: [Color.fromARGB(193, 200, 248, 255), Color.fromARGB(0, 196, 196, 196)],
                  //               ),
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 children: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: SplineSeriesChart(
                  //                       PortfolioPage._createSampleData(_profileProvider.portfolioData),
                  //
                  //                     ),
                  //                   ),
                  //
                  //                   SizedBox(height: 14,),
                  //
                  //                   Padding(
                  //                     padding: const EdgeInsets.all(16.0),
                  //                     child: Container(
                  //                       width: 252,
                  //                       height: 34,
                  //                       decoration: BoxDecoration(
                  //                         color: Colors.white,
                  //                         borderRadius: BorderRadius.all(Radius.circular(15))
                  //                       ),
                  //                       child: Center(child: Text('Trends of your investment by month', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),)),
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 15,
                  //     ),
                  //     SizedBox(
                  //       height: 15,
                  //     ),
                  //     Flexible(flex: 1, child: vendorInPort(myPortfolioData,context)),
                  //   ],
                  // ),
                  SizedBox(
                    width: 28,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                ],
              ):Center(child: CircularProgressIndicator(),),
            ),
          ),
        ),
      ),
    );
  }

  Widget vendorInPort(MyPortfolioData myPortfolioData,context) {
    return // Figma Flutter Generator Frame163Widget - FRAME - VERTICAL
        Container(
      constraints: BoxConstraints(minHeight: 600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.10000000149011612), offset: Offset(10, 10), blurRadius: 20)],
        color: Color.fromRGBO(245, 251, 255, 1),
        // image : DecorationImage(
        //     image: AssetImage('assets/images/Frame163.png'),
        //     fit: BoxFit.fitWidth
        // ),
      ),
      padding: EdgeInsets.symmetric(horizontal:  Responsive.isMobile(context) ? 10:  20, vertical: 36),
      child: Column(
        children: <Widget>[
          Text(
            'Top Vendors in Portfolio',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontFamily: 'Poppins',
                fontSize: 18,
                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (VendorListPortfolio vendor in myPortfolioData.vendorList)
                        if (vendor.name != null)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            margin:  const EdgeInsets.only(bottom: 15),
                            constraints: BoxConstraints(minHeight: 100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.15000000596046448), offset: Offset(0, 2), blurRadius: 4)],
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: HexColor("#F5FBFF"),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Figma Flutter Generator ArdovaplcWidget - TEXT
                                      Text(
                                        vendor.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color.fromRGBO(51, 51, 51, 1),
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.normal,
                                            height: 1),
                                      ),
                                      // Figma Flutter Generator 222Widget - TEXT
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              vendor.percent.toString() + '%',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(33, 150, 83, 1),
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                            // Icon(
                                            //   Icons.arrow_upward,
                                            //   size: 15,
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Last investment',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(51, 51, 51, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            formatCurrency(vendor.lastInvestment, withIcon: true),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(51, 51, 51, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      VerticalDivider(
                                        width: 2,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total investment',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(51, 51, 51, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            formatCurrency(vendor.totalInvestment, withIcon: true),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(51, 51, 51, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // InkWell(
                //   onTap: () {},
                //   child: Text(
                //     'View all vendors in Portfolio',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         color: Color.fromRGBO(0, 152, 219, 1),
                //         fontFamily: 'Poppins',
                //         fontSize: 18,
                //         letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                //         fontWeight: FontWeight.normal,
                //         height: 1),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
