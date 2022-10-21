import 'package:capsa/common/page_bgimage.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/investor/data/my-portfolio-chart1.dart';
import 'package:capsa/investor/data/my-portfolio-chart2.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/StatefulWrapper.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generatedcardwidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:beamer/beamer.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class PortfolioPage extends StatelessWidget {
  PortfolioPage({Key key}) : super(key: key);

  static List<TimeSeriesSales2> _createSampleData(PortfolioData portfolioData) {


    List<TimeSeriesSales2> data = [];
    var now = DateTime.now();

    if (portfolioData.x_axis.length > 0) {
      data.add(new TimeSeriesSales2(new DateTime(now.year, 1, 1).month.toString(), 0));

      int i = 0;
      portfolioData.x_axis.forEach((element) {
        var yAxis = portfolioData.y_axis[i];

        // capsaPrint('yAxis');
        // capsaPrint(yAxis);

        var xAxis = element;

        // capsaPrint('xAxis');
        // capsaPrint(xAxis);

        data.add(new TimeSeriesSales2(new DateTime(xAxis[0], xAxis[1], xAxis[2]).month.toString(), num.parse(yAxis)));
        i++;
      });
      data.add(new TimeSeriesSales2(new DateTime(now.year, 12, 31).month.toString(), 0));

    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context);

    PortfolioData portfolioData = _profileProvider.portfolioData;

    MyPortfolioData myPortfolioData = _profileProvider.myPortfolioData;

    return StatefulWrapper(
      onInit: () {
        _profileProvider.myportfoliopageData();

        _profileProvider.queryPortfolioData2();
        _profileProvider.queryFewData();
        _profileProvider.queryBankTransaction();

      },
      child: Scaffold(
        body: Container(
          decoration: bgDecoration,
          child: SingleChildScrollView(
            child: Padding(
              padding: Responsive.isMobile(context) ? EdgeInsets.fromLTRB(10, 15, 10, 15) : EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(! Responsive.isMobile(context))
                  SizedBox(
                    height: 22,
                  ),
                  TopBarWidget("My Portfolio,", ""),
                  SizedBox(
                    height: 10,
                  ),
                  OrientationSwitcher(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      // onTap: () => context.beamToNamed("/account"),
                                      child: GeneratedCardWidget(
                                          title: "Companies in Portfolio",
                                          icon: "assets/images/Frame 140.png",
                                          currency: false,
                                          subText: myPortfolioData.companyInyPortfolio.toString(),
                                          color: HexColor("#0098DB")),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    InkWell(
                                      onTap: () => context.beamToNamed("/my-bids"),
                                      child: GeneratedCardWidget(
                                          title: "Total Invoice Bought",
                                          icon: "assets/images/invbought.png",
                                          currency: true,
                                          subText: formatCurrency(myPortfolioData.invoiceBought),
                                          color: HexColor("#219653")),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Text(
                              'Portfolio Chart',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Chart analysis of your invoice investment is shown here',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontSize: 12,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if(_profileProvider.portfolioData.x_axis != null)
                            SizedBox(
                              height: 500,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SplineSeriesChart(
                                  _createSampleData(_profileProvider.portfolioData),

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Flexible(flex: 1, child: vendorInPort(myPortfolioData,context)),
                    ],
                  ),
                  SizedBox(
                    width: 28,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                ],
              ),
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
