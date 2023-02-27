import 'package:beamer/beamer.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/home_page.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:capsa/investor/pages/homepage.dart';
import 'package:capsa/common/MyCustomScrollBehavior.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/page_bgimage.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/investor/pages/investor_bid_details_page.dart';
import 'package:capsa/investor/pages/investor_transaction_details_page.dart';
import 'package:capsa/investor/pages/live_deals.dart';
import 'package:capsa/investor/pages/my_bids.dart';
import 'package:capsa/investor/pages/my_transaction.dart';

import 'package:capsa/investor/pages/portfolio_page/portfolio_page.dart';
import 'package:capsa/investor/pages/upcoming_payments.dart';
import 'package:capsa/investor/pages/upload_kyc_docs.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';

import 'package:capsa/investor/provider/opendeal_provider.dart';
import 'package:capsa/investor/provider/proposal_provider.dart';
import 'package:capsa/pages/account-all-transaction-history.dart';
import 'package:capsa/pages/account_page.dart';
import 'package:capsa/pages/change-transaction-pin/change_transaction_pin.dart';
import 'package:capsa/pages/change_password_page.dart';
import 'package:capsa/pages/edit_profile_page.dart';
import 'package:capsa/pages/email-preference/email_preference_investor_page.dart';
import 'package:capsa/pages/faq-page.dart';
import 'package:capsa/pages/profile_page.dart';
import 'package:capsa/pages/withdraw-amt/withdraw_amt_page.dart';
import 'package:capsa/pages/withdraw-amt/withdraw_response_page.dart';
import 'package:capsa/providers/bid_history_provider.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/pages/confirm_invoice_page.dart';
import 'package:capsa/widgets/DesktopMainMenuWidget.dart';
import 'package:capsa/widgets/capsaapp/generated_mobilemenunavigationsvendorwidget/Generated_MobileMenuNavigationsVendorWidget.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class InvestorNewApp extends StatefulWidget {
  InvestorNewApp({Key key}) : super(key: key);

  @override
  State<InvestorNewApp> createState() => _InvestorNewAppState();
}

class _InvestorNewAppState extends State<InvestorNewApp> {
  var routerDelegate;

  //
  // BeamPage returnFunInvoiceList(type, url) {
  //   return BeamPage(
  //     key: ValueKey('invoice-list-' + type),
  //     title: type + " Invoice's",
  //     // popToNamed: '/',
  //     type: BeamPageType.fadeTransition,
  //
  //     child: InvestorMain(
  //       pageUrl: url,
  //       mobileTitle: "All Invoice",
  //       menuList: true,
  //       body: InvoiceListPage(type),
  //       backButton: true,
  //     ),
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userData = Map<String, dynamic>.from(box.get('userData'));
    // capsaPrint("VendorNewApp");
    routerDelegate = BeamerDelegate(
      initialPath: '/home',
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/*': (context, state, data) {
            final beamerKey = GlobalKey<BeamerState>();

            return Scaffold(
              body: Beamer(
                key: beamerKey,
                routerDelegate: BeamerDelegate(
                  locationBuilder: RoutesLocationBuilder(
                    routes: {
                      '/home': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-home'),
                          title: 'Dashboard',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/home",
                              mobileTitle: 'Hello ${userData['name']} 👋',
                              mobileSubTitle:
                                  "Welcome, make money from alternative financing!",
                              showLogo: true,
                              body: InvestorHomePage()),
                        );
                      },
                      '/my-transactions': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('my-transactions'),
                          title: 'My Transactions',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/my-transactions",
                              backButton: true,
                              menuList: false,
                              mobileTitle: "My Transactions",
                              body: MyTransactions()),
                        );
                      },
                      '/my-bids': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('my-bids'),
                          title: 'My Bids',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/my-bids",
                              mobileTitle: "My Bids",
                              body: MyBidsPage()),
                        );
                      },
                      '/live-deals': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('live-deals'),
                          title: 'Live Deals',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/live-deals",
                              mobileTitle: "Live deals",
                              body: LiveDealsPage()),
                        );
                      },
                      '/live-deals/bid-details/:id/:isSplit': (context, state, data) {
                        final id = state.pathParameters['id'];
                        bool isSplit = stringToBool(state.pathParameters['isSplit']);
                        //String currencyAvailable = state.pathParameters['currencyAvailable'];
                        return BeamPage(
                          key: ValueKey('live-deals-details-' + id),
                          title: 'Bid Deals',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/live-deals/bid-details/" + id,
                              backButton: true,
                              menuList: false,
                              mobileTitle: "Bid Details",
                              body: InvestorBidDetailsPage(id,isSplit: isSplit)),
                        );
                      },
                      // '/live-deals/bid-details/anchor-analysis': (context, state, data) {
                      //   //final panNumber = state.pathParameters['panNumber'];
                      //   //capsaPrint('PanNumber: $panNumber');
                      //   capsaPrint('tapped');
                      //   return BeamPage(
                      //     key: const ValueKey('live-deals-details-anchor-analysis'),
                      //     title: 'Anchor Analysis',
                      //     type: BeamPageType.fadeTransition,
                      //     child:
                      //     InvestorMain(
                      //         pageUrl: "/live-deals/bid-details/anchor-analysis",
                      //         backButton: true,
                      //         menuList: false,
                      //         mobileTitle: "Anchor Analysis",
                      //         body: const Center(child: Text('Anchor Analysis'),)
                      //
                      //         //AnchorAnalysisHomePage()
                      //     ),
                      //   );
                      // },
                      '/live-deals/anchor-analysis': (context, state, data) {
                        //capsaPrint('PanNumber: $panNumber');
                        capsaPrint('tapped');
                        return BeamPage(
                          key: const ValueKey('live-deals-details-anchor'),
                          title: 'Anchor Analysis',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl:
                                  "/live-deals/bid-details/anchor-analysis",
                              backButton: true,
                              menuList: false,
                              mobileTitle: "Anchor Analysis",
                              body: ChangeNotifierProvider(
                                create: (BuildContext context) =>
                                    AnchorAnalysisProvider(),
                                child: AnchorAnalysisHomePage(
                                  model: data,
                                    scale: Responsive.isMobile(context)?MediaQuery.of(context).size.width/1050.0:1,
                                ),
                              )),
                        );
                      },
                      '/bid-details/:id/:amt': (context, state, data) {
                        final id = state.pathParameters['id'];
                        final amt = state.pathParameters['amt'];
                        return BeamPage(
                          key: ValueKey('bid-details-' + id),
                          title: 'Bid Details',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/bid-details/" + id,
                              backButton: true,
                              menuList: false,
                              mobileTitle: "Bid Details",
                              body: InvestorTransactionDetailsPage(id,
                                  amt: amt, onlyBid: true)),
                        );
                      },
                      '/transaction-details/:id': (context, state, data) {
                        final id = state.pathParameters['id'];
                        return BeamPage(
                          key: ValueKey('transaction-details-' + id),
                          title: 'Transaction Details',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/transaction-details/" + id,
                              backButton: true,
                              menuList: false,
                              mobileTitle: "Transaction Details",
                              body: InvestorTransactionDetailsPage(id,
                                  onlyBid: false)),
                        );
                      },
                      '/my-portfolio': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('my-portfolio'),
                          title: 'My Portfolio',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/my-portfolio",
                              backButton: true,
                              menuList: false,
                              mobileTitle: "My Portfolio",
                              body: PortfolioPage()),
                        );
                      },
                      '/profile': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-profile'),
                          title: 'Profile',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/profile",
                              mobileTitle: "My Profile",
                              body: ProfilePage()),
                        );
                      },
                      '/edit-profile': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-edit-profile'),
                          title: 'Edit Profile',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/edit-profile",
                              mobileTitle: "Edit Profile",
                              menuList: false,
                              backButton: true,
                              body: EditProfilePage()),
                        );
                      },
                      '/change-transaction-pin': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-change-transaction-pin'),
                          title: 'Change Transaction Pin',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/change-transaction-pin",
                              mobileTitle: "Change Transaction Pin",
                              menuList: false,
                              backButton: true,
                              body: ChangeTransactionPinPage()),
                        );
                      },

                      '/change-password': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-change-password'),
                          title: 'Change Password',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/change-password",
                              mobileTitle: "Change Password",
                              menuList: false,
                              backButton: true,
                              body: ChangePasswordPage()),
                        );
                      },
                      '/upload-kyc-document': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('upload-kyc-document'),
                          title: 'Upload Kyc Document',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/upload-kyc-document",
                              mobileTitle: "Upload Kyc Document",
                              menuList: false,
                              backButton: true,
                              body: UploadKycDocument()),
                        );
                      },
                      '/confirmInvoice': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-confirmInvoice'),
                          title: 'Confirm Invoice',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/confirmInvoice",
                              mobileTitle: "Confirm Invoice",
                              menuList: false,
                              backButton: true,
                              body: ConfirmInvoice()),
                        );
                      },
                      '/faq': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-faq-vendor'),
                          title: 'FAQ',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/faq",
                              mobileTitle: "FAQs",
                              body: FaqPAGE()),
                        );
                      },
                      '/all-transaction-history': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-all-ths'),
                          title: 'Transaction history',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/all-transaction-history",
                              backButton: true,
                              menuList: false,
                              mobileTitle: "Transaction history",
                              body: AllTransactionHistoryPage()),
                        );
                      },
                      '/all-upcoming-payments': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-all-ths'),
                          title: 'Upcoming Payments',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/all-upcoming-payments",
                              backButton: true,
                              menuList: false,
                              mobileTitle: "Upcoming Payments",
                              body: AllUpcomingPaymentsPage()),
                        );
                      },
                      '/email-preference': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('email-preference'),
                          title: 'Email Preference',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/email-preference",
                              mobileTitle: "Email Preference",
                              menuList: false,
                              backButton: true,
                              body: EmailPreferenceInvestorPage()),
                        );
                      },
                      '/account': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('investor-account'),
                          title: 'Account',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: InvestorMain(
                              pageUrl: "/account",
                              mobileTitle: "My Account",
                              body: AccountPage()),
                        );
                      },
                      '/account/withdraw-amt': (context, state, data) {
                        return  BeamPage(
                          key: ValueKey('withdraw-amt'),
                          title: 'Withdraw Amount',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: WithdrawPage(),
                        );
                      },
                      '/withdraw-response': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('withdraw-response'),
                          title: 'Withdraw response',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: WithdrawResponse(response: data,),
                        );
                      },
                      '/sign_in': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('Loading'),
                          title: 'Loading,,,',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      },
                    },
                  ),
                ),
              ),
              // bottomNavigationBar: BottomNavigationBarWidget(
              //   beamerKey: beamerKey,
              // ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BidHistoryProvider>(
          create: (_) => BidHistoryProvider(),
        ),
        ChangeNotifierProvider<OpenDealProvider>(
          create: (_) => OpenDealProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider<InvoiceProvider>(
          create: (_) => InvoiceProvider(),
        ),
        ChangeNotifierProvider<ProposalProvider>(
          create: (_) => ProposalProvider(),
        ),
      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) {
          return 'Dashboard';
        },
        scrollBehavior: MyCustomScrollBehavior(),
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        backButtonDispatcher:
            BeamerBackButtonDispatcher(delegate: routerDelegate),
        debugShowCheckedModeBanner: false,
        theme: appTheme,
      ),
    );
  }
}

class InvestorMain extends StatelessWidget {
  final Widget body;
  final String pageUrl;
  final bool menuList;
  final bool backButton;
  final String mobileTitle;
  final String mobileSubTitle;
  final bool showLogo;
  final bool pop;

  InvestorMain(
      {this.pageUrl,
      this.body,
      this.mobileSubTitle,
      this.mobileTitle,
      this.menuList,
      this.backButton,
        this.pop = false,
        this.showLogo = false,
      Key key})
      : super(key: key);

  final List<Map> _menuList = [
    {
      'title': 'Home',
      'icon': 'assets/icons/homeIcons.png',
      'activeIcon': 'assets/icons/active_homeIcons.png',
      'active': false,
      'url': "/home",
    },
    {
      'title': 'Live Deals',
      'icon': 'assets/icons/bidsIcons.png',
      'activeIcon': 'assets/icons/active_bidsIcons.png',
      'active': false,
      'url': "/live-deals",
    },
    {
      'title': 'My Bids',
      'icon': 'assets/icons/history.png',
      'activeIcon': 'assets/icons/active_historyIcons.png',
      'active': false,
      'url': "/my-bids",
    },
    {
      'title': 'Account',
      'icon': 'assets/icons/accounticon.png',
      'activeIcon': 'assets/icons/active_accountIcons.png',
      'active': false,
      'url': "/account",
    },
    {
      'title': 'Profile',
      'icon': 'assets/icons/profileIcons.png',
      'activeIcon': 'assets/icons/active_profileIcons.png',
      'active': false,
      'url': "/profile",
    },
    {
      'title': 'FAQ',
      'icon': 'assets/icons/faqIcons.png',
      'activeIcon': 'assets/icons/active_faqIcons.png',
      'active': false,
      'mobile': false,
      'url': "/faq",
    }
  ];

  final List<Map> _invoiceMenuList = [
    {
      'title': 'Anchor',
      'icon': '',
      'activeIcon': '',
      'active': false,
      'url': "/bid-details/anchor",
      'replace': true,
    },
    {
      'title': 'Vendor',
      'icon': '',
      'activeIcon': '',
      'active': false,
      'url': "/bid-details/vendor",
      'replace': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map> _menuList2 = [];

    bool _backButton = false;
    if (menuList != null && menuList) {
      _menuList2 = [];
      // _menuList2 = menuList;
      _invoiceMenuList.forEach((k) => {
            if (k['url'] == pageUrl) {k['active'] = true},
            _menuList2.add(k)
          });
    } else if (menuList != null && !menuList) {
      _menuList2 = [];
    } else {
      _menuList2 = [];
      _menuList.forEach((k) => {
            if (k['url'] == pageUrl) {k['active'] = true},
            _menuList2.add(k)
          });
    }
    //
    // capsaPrint('_menuList2');
    // capsaPrint(_menuList2);

    if (backButton != null) _backButton = backButton;

    // capsaPrint(Responsive.isMobile(context));

    var userData = Map<String, dynamic>.from(box.get('userData'));

    return Scaffold(
      bottomNavigationBar: (Responsive.isMobile(context))
          ? Generated_MobileMenuNavigationsVendorWidget(_menuList2)
          : null,
      appBar: Responsive.isMobile(context)
          ? PreferredSize(
              preferredSize: Size.fromHeight(72.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: HexColor("#F5FBFF"),
                actions: [
                  showLogo?Padding(
                    padding: const EdgeInsets.only(top: 12, right: 8),
                    child: Image.asset(
                      "assets/images/Ellipse 3.png",
                      width: 35,
                      height: 35,
                    ),
                  ):Container(),
                ],
                title: Column(
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_backButton)
                          InkWell(
                            onTap: () {
                              print('BeamBack ${Beamer.of(context).canBeamBack} \n\n');
                              if(Beamer.of(context).canBeamBack) {
                                Beamer.of(context).beamBack();
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CapsaHome(),
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: HexColor("#0098DB"),
                              size: 30,
                            ),
                          ),
                        SizedBox(
                          width: (_backButton) ? 12 : 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mobileTitle != null ? mobileTitle : 'Hello ${userData['name']} 👋',
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
                            if (mobileSubTitle != null)
                              SizedBox(
                                height: 8,
                              ),
                            if (mobileSubTitle != null)
                              Text(
                                (mobileSubTitle != null)
                                    ? mobileSubTitle
                                    : 'Welcome, enjoy alternative financing!',
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Container(
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: bgDecoration,
        child: Responsive(
          desktop: Row(
            children: <Widget>[
              DesktopMainMenuWidget(_menuList2, backButton: _backButton,pop: pop,),
              // const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: body,
              )
            ],
          ),
          mobile: body,
        ),
      ),
    );
  }
}
