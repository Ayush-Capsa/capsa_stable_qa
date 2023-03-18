import 'package:beamer/beamer.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/page_bgimage.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/pages/change_password_vendor_investor.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/StatefulWrapper.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generatedcardwidget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe163widget/GeneratedFrame163Widget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';
import 'package:capsa/widgets/capsaapp/generatedpresentedwidget/GeneratedPresentedWidget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class InvestorHomePage extends StatefulWidget {
    InvestorHomePage({Key key}) : super(key: key);

  @override
  State<InvestorHomePage> createState() => _InvestorHomePageState();
}

class _InvestorHomePageState extends State<InvestorHomePage> {

  void checkPassword() async{
    dynamic response = await Provider.of<ProfileProvider>(context, listen: false)
        .checkLastPasswordReset();

    capsaPrint('\n\nCheck passwrod : $response');

    if(response['msg'] != 'success') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            // title: Text(
            //   '',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Theme.of(context).primaryColor,
            //   ),
            // ),
            content: Container(
              // width: 800,
                height: Responsive.isMobile(context)?340:300,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [

                      SizedBox(height: 12,),

                      Image.asset('assets/icons/warning.png'),

                      SizedBox(height: 12,),

                      Text(
                        'Action Required',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 12,),

                      Text(
                        'Your GetCapsa Password has not been changed for more than 90 days!\nKindly change password to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 12,),

                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider(
                                    create: (BuildContext
                                    context) =>
                                        ProfileProvider(),
                                    child:ChangePasswordPageVI(canGoBack: false,),),
                            ),
                          );
                        },
                        child:  Container(
                          width: Responsive.isMobile(context)?140 : 220,
                          decoration: BoxDecoration(
                              color: HexColor('#0098DB'),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Okay',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                )
            ),
            //actions: <Widget>[],
          ));
    }
  }



  dynamic userData;

  @override
  void initState(){
    super.initState();
    userData = Map<String, dynamic>.from(box.get('userData'));
    capsaPrint('Data : 222 $userData');
    checkPassword();
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context);

    PortfolioData portfolioData = _profileProvider.portfolioData;




    final _desktopHomeCardList = [
      {
        'title': "Active Bids",
        'text': "Bids that you have submitted for invoices and vendor is yet to take action.",
        'number': portfolioData.activeCount.toString() + " Bids",
        'icon': "assets/images/bid_icon.png",
        'color': HexColor("#219653"),
      },
      {
        'title': "My Transactions",
        'text': "Status of transactions and payments made for invoices.",
        'icon': "assets/images/beats_Icons.png",
        'color': HexColor('#0098DB'),
        'number': portfolioData.transactionCount.toString() + " Transactions",
        'sTextWidth':  Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth':  Responsive.isMobile(context) ? 148.0 : 200.0
      },

      {
        'title': "My Portfolio",
        'text': "Chart analysis of your invoice investment is shown here.",
        'icon': "",
        'color': HexColor('#6B006D'),
        'number': "Portfolio Returns "+ portfolioData.returnPercent +"%",
        'sTextWidth': 150.0,
        'sTabWidth':  Responsive.isMobile(context) ? 150.0 : 180.0,
        'img1' : 'assets/images/undraw_crypto_portfolio_2jy5 1.png'
      },

    ];

    return StatefulWrapper(
      onInit: () {
        capsaPrint('INIT HOMEPAGE');
        _profileProvider.queryPortfolioData2();
        _profileProvider.queryFewData();
        _profileProvider.queryBankTransaction();

      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: bgDecoration,
          child: SingleChildScrollView(
            child: Padding(
              padding: Responsive.isMobile(context) ? EdgeInsets.fromLTRB(15, 15, 8, 15) : EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height:  Responsive.isMobile(context) ?  06 : 22,
                  ),
                  TopBarWidget("👋 Welcome ${userData['userName']},", "Welcome, enjoy alternative financing!", quickGuide : true ),
                  SizedBox(
                    height: 22,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        InkWell(
                          onTap: () => context.beamToNamed("/account"),
                          child: GeneratedCardWidget(
                              title: "Account Balance",
                              icon: "assets/images/account.png",
                              currency: true,
                              subText: formatCurrency(_profileProvider.totalBalance),
                              color: HexColor("#0098DB")),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        InkWell(
                          onTap: () => context.beamToNamed("/my-bids"),
                          child: GeneratedCardWidget(
                              title: "Total Invoices Bought",
                              icon: "assets/images/invbought.png",
                              currency: true,
                              subText: formatCurrency(portfolioData.totalDiscount),
                              color: HexColor("#219653")),
                        ),
                        SizedBox(
                          width: 24,
                        ),

                        InkWell(
                          onTap: () => context.beamToNamed("/my-transactions"),
                          child: GeneratedCardWidget(
                              title: "Total no of Transactions",
                              icon: "assets/images/timer.png",
                              currency: false,
                              subText: portfolioData.transactionCount.toString(),
                              color: HexColor("#3AC0C9")),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  OrientationSwitcher(
                    orientation:  Responsive.isMobile(context) ?  "Column" : "Row",
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Portfolio",
                            style: TextStyle(
                              color: Color(
                                0xff333333,
                              ),
                              fontSize: Responsive.isMobile(context) ? 16 : 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    context.beamToNamed('/my-bids');
                                  },
                                  child: Center(child: GeneratedPresentedWidget(_desktopHomeCardList[0] , width:   Responsive.isMobile(context) ?  MediaQuery.of(context).size.width  * 0.44 : 280.0,height:  Responsive.isMobile(context) ? 220.0 : 260.0,), )),
                              SizedBox(width: 15),
                              InkWell(
                                  onTap: () {
                                    context.beamToNamed('/my-transactions');
                                  },
                                  child: GeneratedPresentedWidget(_desktopHomeCardList[1], width:   Responsive.isMobile(context) ?  MediaQuery.of(context).size.width   * 0.44 : 280.0,height:  Responsive.isMobile(context) ? 220.0 : 260.0, )),

                            ],
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          InkWell(
                              onTap: () {
                                context.beamToNamed('/my-portfolio');
                              },
                              child: Center(child: GeneratedPresentedWidget(_desktopHomeCardList[2] , width:   Responsive.isMobile(context) ?  double.infinity : 280.0 * 2 + 22,height:  Responsive.isMobile(context) ? 240 : 260.0,), )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: 22,
                            ),
                          Text(
                            "Upcoming Payments",
                            style: TextStyle(
                              color: Color(
                                0xff333333,
                              ),
                              fontSize: Responsive.isMobile(context) ? 16 : 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          ),


                          if(_profileProvider.portfolioData.up_pymt != null && _profileProvider.portfolioData.up_pymt.length > 0 )
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GeneratedFrame163Widget(),
                          )
                          else
                            Container(
                              width: Responsive.isMobile(context) ?  MediaQuery.of(context).size.width - 35 : 414,
                              height: 400.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50.0),
                                  topRight: Radius.circular(50.0),
                                  bottomRight: Radius.circular(0.0),
                                  bottomLeft: Radius.circular(50.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(25, 0, 0, 0),
                                    offset: Offset(10.0, 10.0),
                                    blurRadius: 2.0,
                                  ),
                                  BoxShadow(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    offset: Offset(-2.0, -2.0),
                                    blurRadius: 0,
                                  )
                                ],
                              ),
                              child: FutureBuilder<Object>(
                                future: Future.delayed(const Duration(milliseconds: 1000)),
                                builder: (context, snapshot) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text("You do not have any payment due."),),
                                  );
                                }
                              ),
                            )


                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  if(Responsive.isMobile(context))
                  Container(
                    width: double.infinity,
                    height: 240,
                    child: InkWell(
                      onTap: () {
                        return showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            YoutubePlayerController _controller = YoutubePlayerController(
                              initialVideoId: '8yuNQreXtaE',
                              params: YoutubePlayerParams(
                                playlist: [], // Defining custom playlist
                                startAt: Duration(seconds: 0),
                                showControls: true,
                                autoPlay: true,
                                showFullscreenButton: true,
                              ),
                            );

                            var _ap = 16 / 9;

                            return AlertDialog(
                              // title: const Text('AlertDialog Title'),
                              content: Center(
                                child: YoutubePlayerControllerProvider(
                                  // Provides controller to all the widget below it.
                                  controller: _controller,
                                  child: YoutubePlayerIFrame(
                                    aspectRatio: _ap,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 0.0,
                            top: 0.0,
                            child: Container(
                              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.95 : 590,
                              height: Responsive.isMobile(context) ? 180 : 240,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Responsive.isMobile(context) ? 15 : 25),
                                  topRight: Radius.circular(Responsive.isMobile(context) ? 15 : 25),
                                  bottomLeft: Radius.circular(Responsive.isMobile(context) ? 15 : 25),
                                  bottomRight: Radius.circular(Responsive.isMobile(context) ? 15 : 25),
                                ),
                                // color: Color.fromRGBO(3, 3, 3, 0.7843137254901961),
                                image: DecorationImage(
                                    image: AssetImage('assets/images/hqdefault1.png'),
                                    fit: Responsive.isMobile(context) ? BoxFit.contain : BoxFit.fitWidth),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0.0,
                            top: 0.0,
                            child: Container(
                              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.95 : 590,
                              height: Responsive.isMobile(context) ? 180 : 240,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Responsive.isMobile(context) ? 15 : 25),
                                  topRight: Radius.circular(Responsive.isMobile(context) ? 15 : 25),
                                  bottomLeft: Radius.circular(Responsive.isMobile(context) ? 15 : 25),
                                  bottomRight: Radius.circular(Responsive.isMobile(context) ? 15 : 25),
                                ),
                                // color: Color.fromRGBO(3, 3, 3, 0.7843137254901961),
                                image: DecorationImage(
                                    image: AssetImage('assets/images/Rectangle 90.png'),
                                    fit: Responsive.isMobile(context) ? BoxFit.contain : BoxFit.fitWidth),
                              ),
                            ),
                          ),
                          Positioned(
                              left: Responsive.isMobile(context) ? 150 : 250,
                              top: Responsive.isMobile(context) ? 80 : 110.0,
                              child: Image.asset(
                                'assets/images/youtube.png',
                                height: 50,
                                width: 50,
                              )),
                        ],
                      ),
                    ),
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
}
