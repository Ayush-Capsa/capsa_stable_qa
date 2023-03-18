import 'package:beamer/beamer.dart';
import 'package:capsa/common/MyCustomScrollBehavior.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/page_bgimage.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';

import 'package:capsa/pages/account-all-transaction-history.dart';
import 'package:capsa/pages/change-transaction-pin/change_transaction_pin.dart';
import 'package:capsa/pages/email-preference/email_preference_vendor_page.dart';
import 'package:capsa/pages/withdraw-amt/withdraw_amt_page.dart';
import 'package:capsa/pages/withdraw-amt/withdraw_response_page.dart';
import 'package:capsa/vendor-new/pages/add_invoice/confirm_invoice.dart';
import 'package:capsa/vendor-new/pages/add_invoice/invoice_table_page.dart';
import 'package:capsa/vendor-new/pages/invoice_builder_history.dart';
import 'package:capsa/vendor-new/pages/invoice_builder_page.dart';

import 'package:capsa/vendor-new/pages/invoice_list_page.dart';
import 'package:capsa/vendor-new/pages/live_deals/live_deals_page.dart';
import 'package:capsa/vendor-new/pages/upload_kyc_docs.dart';
import 'package:capsa/vendor-new/pages/account-letter/upload_account_letter_profile.dart';
import 'package:capsa/vendor-new/provider/invoice_builder_provider.dart';
import 'package:capsa/widgets/capsaapp/generated_mobilemenunavigationsvendorwidget/Generated_MobileMenuNavigationsVendorWidget.dart';
import 'package:capsa/pages/account_page.dart';
import 'package:capsa/vendor-new/pages/add_invoice/add_invoice_page.dart';
import 'package:capsa/pages/change_password_page.dart';
import 'package:capsa/vendor-new/pages/confirm_invoice_page.dart';
import 'package:capsa/pages/edit_profile_page.dart';
import 'package:capsa/pages/faq-page.dart';
import 'package:capsa/vendor-new/pages/invoices_list_page_2.dart';
import 'package:capsa/pages/profile_page.dart';
import 'package:capsa/providers/bid_history_provider.dart';
import 'package:capsa/vendor-new/pages/bids_details_page.dart';
import 'package:capsa/vendor-new/pages/bids_page.dart';
import 'package:capsa/vendor-new/pages/history_page.dart';

// import 'package:capsa/functions/hexcolor.dart';
// import 'package:capsa/widgets/capsaapp/generatedcardwidget/generatedcardwidget.dart';
// import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/GeneratedDesktopMenuWidget.dart';
// import 'package:capsa/widgets/capsaapp/generatedframe171widget/GeneratedFrame171Widget.dart';
// import 'package:capsa/widgets/capsaapp/generatedpresentedwidget/GeneratedPresentedWidget.dart';
// import 'package:capsa/vendor-new/pages/bids_page.dart';
import 'package:capsa/vendor-new/pages/vendor_home_page.dart';
import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/DesktopMainMenuWidget.dart';

// import 'package:capsa/vendor-new/widgets/TopBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

import '../main.dart';
// import 'package:hive/hive.dart';

class VendorNewApp extends StatefulWidget {
  VendorNewApp({Key key}) : super(key: key);

  @override
  State<VendorNewApp> createState() => _VendorNewAppState();
}

class _VendorNewAppState extends State<VendorNewApp> {
  var routerDelegate;

  BeamPage returnFunInvoiceList(type, url) {
    String mobileTitle = type;
    if (type == 'notPresented') {
      mobileTitle = 'not Presented';
    }

    mobileTitle = mobileTitle.capitalize();
    return BeamPage(
      key: ValueKey('invoice-list-' + type),
      title: mobileTitle + " Invoice's",
      // popToNamed: '/',
      type: BeamPageType.fadeTransition,

      child: VendorMain(
        pageUrl: url,
        mobileTitle: mobileTitle + ' Invoices',
        menuList: true,
        body: InvoiceListPage(type),
        backButton: true,
        backUrl: "/home",
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // capsaPrint("VendorNewApp");
    var userData = Map<String, dynamic>.from(box.get('userData'));
    routerDelegate = BeamerDelegate(
      initialPath: '/home',
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/*': (context, state, data) {
            final beamerKey = GlobalKey<BeamerState>();
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Beamer(
                key: beamerKey,
                routerDelegate: BeamerDelegate(
                  locationBuilder: RoutesLocationBuilder(
                    routes: {
                      // ':pageName': (context, state,data) {
                      //   final pageName = state.pathParameters['pageName'];
                      //   return BeamPage(
                      //     key: ValueKey('vendor-'+pageName),
                      //     title: pageName,
                      //     type: BeamPageType.fadeTransition,
                      //     child: VendorMain(pageUrl: "/home", body: VendorHomePage()),
                      //   );
                      // },
                      '/home': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-home'),
                          title: 'Dashboard',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/home",
                              mobileTitle: "Hello ${userData['name']} 👋",
                              mobileSubTitle:
                                  "Welcome, enjoy alternative financing!",
                              showLogo: true,
                              body: VendorHomePage()

                              // ConfirmInvoicePage()
                              // InvoiceTable(),

                              ),
                        );
                      },
                      '/live-deals': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-live-deals'),
                          title: 'Live Deals',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/live-deals",
                              mobileTitle: "👋 Capsa,",
                              mobileSubTitle:
                                  "Welcome, enjoy alternative financing!",
                              body: LiveDealsPage()

                              // ConfirmInvoicePage()
                              // InvoiceTable(),

                              ),
                        );
                      },
                      '/bids': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-bids'),
                          title: 'Bids',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/bids",
                              mobileTitle: "Bids",
                              body: BidsPage()),
                        );
                      },
                      '/history': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-history'),
                          title: 'History',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/history",
                              mobileTitle: "Factored Invoices",
                              body: HistoryPage()),
                        );
                      },

                      '/history-details/:id': (context, state, data) {
                        final id = state.pathParameters['id'];
                        return BeamPage(
                          key: ValueKey('vendor-history-details-' + id),
                          title: 'Details',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/history-details/" + id,
                              mobileTitle: id,
                              backButton: true,
                              body: MHistoryDetails(id)),
                        );
                      },

                      '/bids/details/:id': (context, state, data) {
                        final id = state.pathParameters['id'];
                        return BeamPage(
                          key: ValueKey('vendor-bids-view'),
                          title: 'Bid Details',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                            menuList: false,
                            pageUrl: "/bids/details/" + id,
                            mobileTitle: "Bid Details",
                            body: BidsDetailsPage(id),
                            backButton: true,
                          ),
                        );
                      },
                      '/viewInvoice/:id': (context, state, data) {
                        final id =
                            Uri.decodeComponent(state.pathParameters['id']);

                        return BeamPage(
                          key: ValueKey('vendor-viewInvoice'),
                          title: id + ' || Invoice Details',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                            pageUrl: "/viewInvoice/" + id,
                            menuList: false,
                            mobileTitle: id,
                            body: ConfirmInvoice(
                              invVoiceNumber: id,
                            ),
                            backButton: true,
                          ),
                        );
                      },
                      '/addInvoice': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-addInvoice'),
                          title: 'Add Invoice',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/addInvoice",
                              mobileTitle: "Upload Invoice",
                              menuList: false,
                              backButton: true,
                              body: AddInvoice()),
                        );
                      },

                      '/profile': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-profile'),
                          title: 'Profile',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
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
                          child: VendorMain(
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
                          child: VendorMain(
                              pageUrl: "/change-transaction-pin",
                              mobileTitle: "Change Transaction Pin",
                              menuList: false,
                              backButton: true,
                              body: ChangeTransactionPinPage()),

                          //ChangeTransactionPinPage(),
                        );
                      },
                      '/change-password': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-change-password'),
                          title: 'Change Password',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/change-password",
                              mobileTitle: "Change Password",
                              menuList: false,
                              backButton: true,
                              body: ChangePasswordPage()),
                        );
                      },
                      '/upload-account-letter': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('upload-account-letter'),
                          title: 'Upload Account Letter',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/upload-account-letter",
                              mobileTitle: "Upload Account Letter",
                              menuList: false,
                              backButton: true,
                              body: UploadAccountLetter()),
                        );
                      },
                      '/upload-kyc-document': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('upload-kyc-document'),
                          title: 'Upload Kyc Document',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
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
                          child: VendorMain(
                              pageUrl: "/confirmInvoice",
                              mobileTitle: "Confirm Invoice",
                              menuList: false,
                              backButton: true,
                              body: ConfirmInvoicePage()),
                        );
                      },
                      '/faq-vendor': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-faq-vendor'),
                          title: 'FAQ',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/faq-vendor",
                              mobileTitle: "FAQs",
                              body: FaqPAGE()),
                        );
                      },
                      '/all-invoices': (context, state, data) {
                        return returnFunInvoiceList("all", "/all-invoices");
                      },
                      '/pending-invoices': (context, state, data) {
                        return returnFunInvoiceList(
                            "pending", "/pending-invoices");
                      },
                      '/live-invoices': (context, state, data) {
                        return returnFunInvoiceList("live", "/live-invoices");
                      },
                      '/sold-invoices': (context, state, data) {
                        return returnFunInvoiceList("sold", "/sold-invoices");
                      },
                      '/bid-invoices': (context, state, data) {
                        return returnFunInvoiceList("bid", "/bid-invoices");
                      },
                      '/notPresented-invoices': (context, state, data) {
                        return returnFunInvoiceList(
                            "notPresented", "/notPresented-invoices");
                      },
                      '/invoice-builder': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('invoice-builder'),
                          title: 'Invoice Builder',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/invoice-builder",
                              mobileTitle: "Invoice Builder",
                              menuList:
                                  Responsive.isMobile(context) ? false : null,
                              backButton:
                                  Responsive.isMobile(context) ? true : false,
                              body: InvoiceBuilderPage()),
                        );

                        //   BeamPage(
                        //   key: ValueKey('invoice-builder'),
                        //   title: 'Invoice Builder',
                        //   type: BeamPageType.fadeTransition,
                        //   child: VendorMain(
                        //       pageUrl: "/invoice-builder",
                        //       mobileTitle: "Invoice Builder",
                        //       menuList: false,
                        //       backButton: true,
                        //       body: InvoiceBuilderPage()),
                        // );
                      },
                      '/invoice-history': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('invoice-history'),
                          title: 'Invoice History',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/invoice-history",
                              mobileTitle: "Invoice History",
                              menuList: false,
                              backButton: true,
                              body: InvoiceBuilderHistory()),
                        );
                      },
                      '/email-preference': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('email-preference'),
                          title: 'Email Preference',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/email-preference",
                              mobileTitle: "Email Preference Page",
                              menuList: false,
                              backButton: true,
                              body: EmailPreferenceVendorPage()),
                        );
                      },
                      '/account': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-account'),
                          title: 'Account',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/account",
                              mobileTitle: "My Account",
                              body: AccountPage()),
                        );
                      },
                      '/account/withdraw-amt': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('withdraw-amt'),
                          title: 'Withdraw Amount',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: WithdrawPage(),

                          // VendorMain(
                          //     pageUrl: "/account/withdraw-amt",
                          //     mobileTitle: "Withdraw Amount",
                          //     menuList: false,
                          //     backButton: true,
                          //     body: WithdrawPage()),
                        );
                      },
                      '/withdraw-response': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('withdraw-response'),
                          title: 'Withdraw response',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: WithdrawResponse(
                            response: data,
                          ),

                          // VendorMain(
                          //     pageUrl: "/account/withdraw-amt",
                          //     mobileTitle: "Withdraw Amount",
                          //     menuList: false,
                          //     backButton: true,
                          //     body: WithdrawPage()),
                        );
                      },
                      '/sign_in': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('Loading'),
                          title: 'Loading...',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      },
                      '/all-transaction-history': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('vendor-all-ths'),
                          title: 'Account',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/all-transaction-history",
                              backButton: true,
                              mobileTitle: "Transaction history",
                              body: AllTransactionHistoryPage()),
                        );
                      },
                    },
                  ),
                ),
              ),
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
        ChangeNotifierProvider<VendorActionProvider>(
          create: (_) => VendorActionProvider(),
        ),
        ChangeNotifierProvider<BidHistoryProvider>(
          create: (_) => BidHistoryProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider<InvoiceProvider>(
          create: (_) => InvoiceProvider(),
        ),
        ChangeNotifierProvider<InvoiceBuilderProvider>(
          create: (_) => InvoiceBuilderProvider(),
        ),
      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) {
          return 'Dashboard';
        },
        backButtonDispatcher:
            BeamerBackButtonDispatcher(delegate: routerDelegate),
        scrollBehavior: MyCustomScrollBehavior(),
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
      ),
    );
  }
}

class VendorMain extends StatelessWidget {
  final Widget body;
  final String pageUrl;
  final bool menuList;
  final bool backButton;
  final bool pop;
  final String mobileTitle;
  final String mobileSubTitle;
  final String backUrl;
  final bool showLogo;

  VendorMain(
      {this.pageUrl,
      this.body,
      this.mobileSubTitle,
      this.mobileTitle,
      this.backUrl,
      this.menuList,
      this.backButton,
      this.pop = false,
      this.showLogo = false,
      Key key})
      : super(key: key);

  List<Map> _menuList = [
    {
      'title': 'Home',
      'icon': 'assets/icons/homeIcons.png',
      'activeIcon': 'assets/icons/active_homeIcons.png',
      'active': false,
      'url': "/home",
    },
    // {
    //   'title': 'Live Deals',
    //   'icon': 'assets/icons/livedealsicon.png',
    //   'activeIcon': 'assets/icons/active_livedealsIcons.png',
    //   'active': false,
    //   'url': "/live-deals",
    // },
    {
      'title': 'Bids',
      'icon': 'assets/icons/bidsIcons.png',
      'activeIcon': 'assets/icons/active_bidsIcons.png',
      'active': false,
      'url': "/bids",
    },
    {
      'title': 'Invoice Builder',
      'icon': 'assets/icons/pending.png',
      'activeIcon': 'assets/icons/active_pending.png',
      'active': false,
      'url': "/invoice-builder",
    },
    {
      'title': 'History',
      'icon': 'assets/icons/history.png',
      'activeIcon': 'assets/icons/active_historyIcons.png',
      'active': false,
      'url': "/history",
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
      'url': "/faq-vendor",
    }
  ];

  final List<Map> _mobileMenuList = [
    {
      'title': 'Home',
      'icon': 'assets/icons/homeIcons.png',
      'activeIcon': 'assets/icons/active_homeIcons.png',
      'active': false,
      'url': "/home",
    },
    // {
    //   'title': 'Live Deals',
    //   'icon': 'assets/icons/livedealsicon.png',
    //   'activeIcon': 'assets/icons/active_livedealsIcons.png',
    //   'active': false,
    //   'url': "/live-deals",
    // },
    {
      'title': 'Bids',
      'icon': 'assets/icons/bidsIcons.png',
      'activeIcon': 'assets/icons/active_bidsIcons.png',
      'active': false,
      'url': "/bids",
    },
    {
      'title': 'History',
      'icon': 'assets/icons/history.png',
      'activeIcon': 'assets/icons/active_historyIcons.png',
      'active': false,
      'url': "/history",
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
      'url': "/faq-vendor",
    }
  ];

  final List<Map> _invoiceMenuList = [
    {
      'title': 'All Invoices',
      'icon': 'assets/icons/allinvoice.png',
      'activeIcon': 'assets/icons/active_allinvoices.png',
      'active': false,
      'url': "/all-invoices",
      'replace': true,
    },
    {
      'title': 'Pending',
      'icon': 'assets/icons/pending.png',
      'activeIcon': 'assets/icons/active_pending.png',
      'active': false,
      'url': "/pending-invoices",
      'replace': true,
    },
    {
      'title': 'Live',
      'icon': 'assets/icons/live.png',
      'activeIcon': 'assets/icons/active_live.png',
      'active': false,
      'url': "/live-invoices",
      'replace': true,
    },
    {
      'title': 'Sold',
      'icon': 'assets/icons/livedealsicon.png',
      'activeIcon': 'assets/icons/active_livedealsIcons.png',
      'active': false,
      'url': "/sold-invoices",
      'replace': true,
    },
    {
      'title': 'Not Presented',
      'icon': 'assets/icons/not-presented.png',
      'activeIcon': 'assets/icons/active_not-presented.png',
      'active': false,
      'url': "/notPresented-invoices",
      'replace': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    !Responsive.isMobile(context)
        ? _menuList = [
            {
              'title': 'Home',
              'icon': 'assets/icons/homeIcons.png',
              'activeIcon': 'assets/icons/active_homeIcons.png',
              'active': false,
              'url': "/home",
            },
            // {
            //   'title': 'Live Deals',
            //   'icon': 'assets/icons/livedealsicon.png',
            //   'activeIcon': 'assets/icons/active_livedealsIcons.png',
            //   'active': false,
            //   'url': "/live-deals",
            // },
            {
              'title': 'Bids',
              'icon': 'assets/icons/bidsIcons.png',
              'activeIcon': 'assets/icons/active_bidsIcons.png',
              'active': false,
              'url': "/bids",
            },
            {
              'title': 'Invoice Builder',
              'icon': 'assets/icons/pending.png',
              'activeIcon': 'assets/icons/active_pending.png',
              'active': false,
              'url': "/invoice-builder",
            },
            {
              'title': 'History',
              'icon': 'assets/icons/history.png',
              'activeIcon': 'assets/icons/active_historyIcons.png',
              'active': false,
              'url': "/history",
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
              'url': "/faq-vendor",
            }
          ]
        : _menuList = _mobileMenuList;

    List<Map> _menuList2 = [];

    bool invmenu = false;

    bool _backButton = false;
    if (menuList != null && menuList) {
      _menuList2 = [];
      // _menuList2 = menuList;
      _invoiceMenuList.forEach((k) => {
            if (k['url'] == pageUrl) {k['active'] = true, invmenu = true},
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

    var invMenu2 = invmenu ? invBottomMenu(_invoiceMenuList, context) : null;

    var userData = Map<String, dynamic>.from(box.get('userData'));

    capsaPrint('User Detrails : $userData\n\n\n');



    // if (!currentFocus.hasPrimaryFocus) {
    //
    // }

    return Scaffold(
      bottomNavigationBar: (Responsive.isMobile(context))
          ? (_backButton)
              ? invMenu2
              : Generated_MobileMenuNavigationsVendorWidget(_menuList2)
          : null,
      appBar: Responsive.isMobile(context)
          ? PreferredSize(
              preferredSize: Size.fromHeight(72.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: HexColor("#F5FBFF"),
                actions: [
                  showLogo
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12, right: 8),
                          child: Image.asset(
                            "assets/images/Ellipse 3.png",
                            width: 35,
                            height: 35,
                          ),
                        )
                      : Container(),
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
                              // FocusScopeNode currentFocus = FocusScope.of(context);
                              // currentFocus.unfocus();
                              if (pop) {
                                Navigator.pop(context);
                              } else if (invmenu)
                                context.beamToNamed('/home');
                              else if (Beamer.of(context).canBeamBack) {
                                try {
                                  capsaPrint('can beam back 1');

                                  Beamer.of(context).beamBack();
                                } catch (e) {
                                  capsaPrint('can beam back 2');
                                  // FocusScopeNode currentFocus = FocusScope.of(context);
                                  // currentFocus.unfocus();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VendorNewApp(),
                                    ),
                                  );
                                }
                              } else {
                                capsaPrint('can beam back 3');
                                // FocusScopeNode currentFocus = FocusScope.of(context);
                                // currentFocus.unfocus();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VendorNewApp(),
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
                              mobileTitle != null
                                  ? mobileTitle
                                  : 'Hello ${userData['name']} 👋',
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
      resizeToAvoidBottomInset: false,
      body: Container(
        // height: MediaQuery.of(context).size.height,
        //width: MediaQuery.of(context).size.width,
        decoration: bgDecoration,
        child: Responsive(
          desktop: Row(
            children: <Widget>[
              DesktopMainMenuWidget(_menuList2,
                  backUrl: backUrl, backButton: _backButton, pop: pop),
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

  Widget invBottomMenu(List<Map> menus, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 68,
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 251, 255, 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (var menu in menus)
            Builder(builder: (context) {
              if (!menu['active'])
                return InkWell(
                  onTap: () {
                    context.beamToNamed(
                      menu['url'],

                      // replaceCurrent: (menu['replace'] != null && menu['replace']) ? true : false
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Color.fromRGBO(245, 251, 255, 1),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                menu['icon'],
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              else
                return InkWell(
                  onTap: () {
                    context.beamToNamed(
                      menu['url'],
                      // replaceCurrent: (menu['replace'] != null && menu['replace']) ? true : false
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(0, 152, 219, 1),
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                menu['activeIcon'],
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          menu['title'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ],
                    ),
                  ),
                );
            }),
          // SizedBox(width: 25,),
        ],
      ),
    );
  }
}

// class VendorMain extends StatelessWidget {
//   final Widget body;
//   final String pageUrl;
//   final bool menuList;
//   final bool backButton;
//   final String mobileTitle;
//   final String mobileSubTitle;
//   final String backUrl;
//   final bool pop;
//
//   VendorMain(
//       {this.pageUrl,
//       this.body,
//       this.mobileSubTitle,
//       this.mobileTitle,
//       this.backUrl,
//       this.menuList,
//       this.backButton,
//         this.pop,
//       Key key})
//       : super(key: key);
//
//   final List<Map> _menuList = [
//     {
//       'title': 'Home',
//       'icon': 'assets/icons/homeIcons.png',
//       'activeIcon': 'assets/icons/active_homeIcons.png',
//       'active': false,
//       'url': "/home",
//     },
//     // {
//     //   'title': 'Live Deals',
//     //   'icon': 'assets/icons/livedealsicon.png',
//     //   'activeIcon': 'assets/icons/active_livedealsIcons.png',
//     //   'active': false,
//     //   'url': "/live-deals",
//     // },
//     {
//       'title': 'Bids',
//       'icon': 'assets/icons/bidsIcons.png',
//       'activeIcon': 'assets/icons/active_bidsIcons.png',
//       'active': false,
//       'url': "/bids",
//     },
//     {
//       'title': 'History',
//       'icon': 'assets/icons/history.png',
//       'activeIcon': 'assets/icons/active_historyIcons.png',
//       'active': false,
//       'url': "/history",
//     },
//     {
//       'title': 'Account',
//       'icon': 'assets/icons/accounticon.png',
//       'activeIcon': 'assets/icons/active_accountIcons.png',
//       'active': false,
//       'url': "/account",
//     },
//     {
//       'title': 'Profile',
//       'icon': 'assets/icons/profileIcons.png',
//       'activeIcon': 'assets/icons/active_profileIcons.png',
//       'active': false,
//       'url': "/profile",
//     },
//     {
//       'title': 'FAQ',
//       'icon': 'assets/icons/faqIcons.png',
//       'activeIcon': 'assets/icons/active_faqIcons.png',
//       'active': false,
//       'mobile': false,
//       'url': "/faq-vendor",
//     }
//   ];
//
//   final List<Map> _invoiceMenuList = [
//     {
//       'title': 'All Invoices',
//       'icon': 'assets/icons/allinvoice.png',
//       'activeIcon': 'assets/icons/active_allinvoices.png',
//       'active': false,
//       'url': "/all-invoices",
//       'replace': true,
//     },
//     {
//       'title': 'Pending',
//       'icon': 'assets/icons/pending.png',
//       'activeIcon': 'assets/icons/active_pending.png',
//       'active': false,
//       'url': "/pending-invoices",
//       'replace': true,
//     },
//     {
//       'title': 'Live',
//       'icon': 'assets/icons/live.png',
//       'activeIcon': 'assets/icons/active_live.png',
//       'active': false,
//       'url': "/live-invoices",
//       'replace': true,
//     },
//     {
//       'title': 'Sold',
//       'icon': 'assets/icons/livedealsicon.png',
//       'activeIcon': 'assets/icons/active_livedealsIcons.png',
//       'active': false,
//       'url': "/sold-invoices",
//       'replace': true,
//     },
//     {
//       'title': 'Not Presented',
//       'icon': 'assets/icons/not-presented.png',
//       'activeIcon': 'assets/icons/active_not-presented.png',
//       'active': false,
//       'url': "/notPresented-invoices",
//       'replace': true,
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map> _menuList2 = [];
//
//     bool invmenu = false;
//
//     bool _backButton = false;
//     if (menuList != null && menuList) {
//       _menuList2 = [];
//       // _menuList2 = menuList;
//       _invoiceMenuList.forEach((k) => {
//             if (k['url'] == pageUrl) {k['active'] = true, invmenu = true},
//             _menuList2.add(k)
//           });
//     } else if (menuList != null && !menuList) {
//       _menuList2 = [];
//     } else {
//       _menuList2 = [];
//       _menuList.forEach((k) => {
//             if (k['url'] == pageUrl) {k['active'] = true},
//             _menuList2.add(k)
//           });
//     }
//     //
//     // capsaPrint('_menuList2');
//     // capsaPrint(_menuList2);
//
//     if (backButton != null) _backButton = backButton;
//
//     // capsaPrint(Responsive.isMobile(context));
//
//     var invMenu2 = invmenu ? invBottomMenu(_invoiceMenuList, context) : null;
//
//     return Scaffold(
//       bottomNavigationBar: (Responsive.isMobile(context))
//           ? (_backButton)
//               ? invMenu2
//               : Generated_MobileMenuNavigationsVendorWidget(_menuList2)
//           : null,
//       appBar: Responsive.isMobile(context)
//           ? PreferredSize(
//               preferredSize: Size.fromHeight(72.0),
//               child: AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: HexColor("#F5FBFF"),
//                 title: Column(
//                   children: [
//                     SizedBox(
//                       height: 18,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         if (_backButton)
//                           InkWell(
//                             onTap: () {
//                               if (invmenu)
//                                 context.beamToNamed('/home');
//                               else
//                               if(Beamer.of(context).canBeamBack) {
//                                 Beamer.of(context).beamBack();
//                               } else {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => CapsaHome(),
//                                   ),
//                                 );
//                               }
//                             },
//                             child: Icon(
//                               Icons.arrow_back,
//                               color: HexColor("#0098DB"),
//                               size: 30,
//                             ),
//                           ),
//                         SizedBox(
//                           width: (_backButton) ? 12 : 8,
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               mobileTitle != null ? mobileTitle : '👋 Capsa,',
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                   color: Color.fromRGBO(51, 51, 51, 1),
//                                   fontFamily: 'Poppins',
//                                   fontSize: 16,
//                                   letterSpacing:
//                                       0 /*percentages not used in flutter. defaulting to zero*/,
//                                   fontWeight: FontWeight.normal,
//                                   height: 1),
//                             ),
//                             if (mobileSubTitle != null)
//                               SizedBox(
//                                 height: 8,
//                               ),
//                             if (mobileSubTitle != null)
//                               Text(
//                                 (mobileSubTitle != null)
//                                     ? mobileSubTitle
//                                     : 'Welcome, enjoy alternative financing!',
//                                 textAlign: TextAlign.left,
//                                 style: TextStyle(
//                                     color: Color.fromRGBO(51, 51, 51, 1),
//                                     // fontFamily: 'Poppins',
//                                     fontSize: 14,
//                                     letterSpacing:
//                                         0 /*percentages not used in flutter. defaulting to zero*/,
//                                     fontWeight: FontWeight.normal,
//                                     height: 1),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : null,
//       body: Container(
//         // height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         decoration: bgDecoration,
//         child: Responsive(
//           desktop: Row(
//             children: <Widget>[
//               DesktopMainMenuWidget(_menuList2,
//                   backUrl: backUrl, backButton: _backButton),
//               // const VerticalDivider(thickness: 1, width: 1),
//               Expanded(
//                 child: body,
//               )
//             ],
//           ),
//           mobile: body,
//         ),
//       ),
//     );
//   }
//
//   Widget invBottomMenu(List<Map> menus, context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.9,
//       height: 68,
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(245, 251, 255, 1),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           for (var menu in menus)
//             Builder(builder: (context) {
//               if (!menu['active'])
//                 return InkWell(
//                   onTap: () {
//                     context.beamToNamed(
//                       menu['url'],
//
//                       // replaceCurrent: (menu['replace'] != null && menu['replace']) ? true : false
//                     );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20),
//                       ),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(8),
//                               topRight: Radius.circular(8),
//                               bottomLeft: Radius.circular(8),
//                               bottomRight: Radius.circular(8),
//                             ),
//                             color: Color.fromRGBO(245, 251, 255, 1),
//                           ),
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Image.asset(
//                                 menu['icon'],
//                                 height: 20,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               else
//                 return InkWell(
//                   onTap: () {
//                     context.beamToNamed(
//                       menu['url'],
//                       // replaceCurrent: (menu['replace'] != null && menu['replace']) ? true : false
//                     );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20),
//                       ),
//                       border: Border.all(
//                         color: Color.fromRGBO(0, 152, 219, 1),
//                         width: 2,
//                       ),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(8),
//                               topRight: Radius.circular(8),
//                               bottomLeft: Radius.circular(8),
//                               bottomRight: Radius.circular(8),
//                             ),
//                             color: Color.fromRGBO(255, 255, 255, 1),
//                           ),
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Image.asset(
//                                 menu['activeIcon'],
//                                 height: 20,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         Text(
//                           menu['title'],
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                               color: Color.fromRGBO(51, 51, 51, 1),
//                               fontFamily: 'Poppins',
//                               fontSize: 14,
//                               letterSpacing:
//                                   0 /*percentages not used in flutter. defaulting to zero*/,
//                               fontWeight: FontWeight.normal,
//                               height: 1),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//             }),
//           // SizedBox(width: 25,),
//         ],
//       ),
//     );
//   }
// }
