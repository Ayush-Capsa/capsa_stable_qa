import 'package:capsa/admin/screens/change_password_admin.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/page_bgimage.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/pages/change_password_vendor_investor.dart';
import 'package:capsa/signup/widgets/card_widget.dart';
import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';

// import 'package:capsa/widgets/capsaapp/generatedaccountbalancewidget/GeneratedAccountBalanceWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generatedcardwidget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe171widget/GeneratedFrame171Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedpresentedwidget/GeneratedPresentedWidget.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/StatefulWrapper.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VendorHomePage extends StatefulWidget {
  VendorHomePage({Key key}) : super(key: key);

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {

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
                        child:Container(
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
    void navigate() {
      Beamer.of(context).beamToNamed('/upload-account-letter');
    }

    void navigate2() {
      Beamer.of(context).beamToNamed('/profile');
    }

    final _profileProvider =
    Provider.of<ProfileProvider>(context, listen: true);

    var invoice = Provider.of<InvoiceProvider>(context);
    var bidcount = Provider.of<VendorActionProvider>(context);
    dynamic _desktopHomeCardList = [
      {
        'title': "Bids",
        'text': "View all bids from investors",
        'number': bidcount.bidProposalCount.toString() + " Bids",
        'icon': "assets/images/bid_icon.png",
        'color': Color.fromARGB(255, 107, 0, 109),
        'sTextWidth': Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth': Responsive.isMobile(context) ? 120.0 : 160.0
      },
      {
        'title': "Live Invoices",
        'text': "View all your active invoices for bidding here",
        'icon': "assets/images/beats_Icons.png",
        'color': HexColor('#219653'),
        'number': invoice.getInvoicesFilterCount(type: 'live').toString() +
            " Invoices",
        'sTextWidth': Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth': Responsive.isMobile(context) ? 120.0 : 160.0
      },
      {
        'title': "Pending Invoices",
        'number': invoice.getInvoicesFilterCount(type: 'pending').toString() +
            " Invoices",
        'text': "View all invoices pending anchor’s approval",
        'icon': "assets/images/window_likeicon.png",
        'color': HexColor('#F2994A'),
        'sTextWidth': Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth': Responsive.isMobile(context) ? 120.0 : 160.0
      },
      {
        'title': "All Invoices",
        'number': invoice.getInvoicesFilterCount(type: 'all').toString() +
            " Invoices",
        'text': "View all your uploaded invoices",
        'icon': "assets/images/booklike_icon.png",
        'color': HexColor('#3AC0C9'),
        'sTextWidth': Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth': Responsive.isMobile(context) ? 120.0 : 160.0
      },
    ];

    final _mobileHomeCardList = [
      {
        'title': "Bids",
        'text': "View all bids from investors",
        'number': bidcount.bidProposalCount.toString() + " Bids",
        'icon': "assets/images/bid_icon.png",
        'color': Color.fromARGB(255, 107, 0, 109),
        'sTextWidth': Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth': Responsive.isMobile(context) ? 120.0 : 160.0
      },
      {
        'title': "Invoice Builder",
        'text': "Build you own invoice",
        'icon': "assets/images/beats_Icons.png",
        'color': HexColor('#219653'),
        'number': 'Try Now',
        'sTextWidth': Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth': Responsive.isMobile(context) ? 120.0 : 160.0
      },
      {
        'title': "Pending Invoices",
        'number': invoice.getInvoicesFilterCount(type: 'pending').toString() +
            " Invoices",
        'text': "View all invoices pending anchor’s approval",
        'icon': "assets/images/window_likeicon.png",
        'color': HexColor('#F2994A'),
        'sTextWidth': Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth': Responsive.isMobile(context) ? 120.0 : 160.0
      },
      {
        'title': "All Invoices",
        'number': invoice.getInvoicesFilterCount(type: 'all').toString() +
            " Invoices",
        'text': "View all your uploaded invoices",
        'icon': "assets/images/booklike_icon.png",
        'color': HexColor('#3AC0C9'),
        'sTextWidth': Responsive.isMobile(context) ? 120.0 : 120.0,
        'sTabWidth': Responsive.isMobile(context) ? 120.0 : 160.0
      },
    ];

    if(Responsive.isMobile(context)) {
      _desktopHomeCardList = _mobileHomeCardList;
    }

    //ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context);

    PortfolioData portfolioData = _profileProvider.portfolioData;

    return StatefulWrapper(
      onInit: () {
        ProfileProvider _profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);

        _profileProvider.queryPortfolioData();
        _profileProvider.queryFewData();
        _profileProvider.queryBankTransaction();

        Provider.of<InvoiceProvider>(context, listen: false)
            .queryInvoiceList('');
        Provider.of<VendorActionProvider>(context, listen: false).bidProposal();
      },
      child: Scaffold(
        floatingActionButton: Responsive.isMobile(context)?FloatingActionButton(
          onPressed: (){
            var userData = Map<String, dynamic>.from(box.get('userData'));
            print('User Data $userData');

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

            if (_profileProvider.portfolioData.AL_UPLOAD != 2) {
              // capsaPrint('Add incoive check');
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Change of Account Letter',
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
                          Text(
                            _profileProvider.portfolioData.AL_UPLOAD == 1
                                ? 'Thank you for uploading your change of account form.\nPlease give us some minutes to verify your details.\nAn email will be sent to you shortly'
                                : 'To trade your Invoice, please upload change of account letter.',
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
                      if (_profileProvider.portfolioData.AL_UPLOAD == 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                    "Upload account letter".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                              ),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty
                                      .all<Color>(Colors.white),
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
                              onPressed: () async {
                                navigate();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }),
                        ),
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
                      // TextButton(
                      //   onPressed: () => {Navigator.of(context, rootNavigator: true).pop(), _tab.changeTab(3)},
                      //   child: const Text('Update details'),
                      // ),
                    ],
                  ));

              return;
            }

            if (_profileProvider.portfolioData.newUser) {
              if (_profileProvider
                  .portfolioData.kyc1 !=
                  2 ||
                  _profileProvider.portfolioData.kyc2 != 2 ||
                  _profileProvider.portfolioData.kyc3 != 2) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                          title: const Text(
                            'KYC',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment
                                  .start,
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                const Text(
                                  'Your KYC Documents are currently being reviewed. Please give us some minutes to verify your details. An email will be sent to you shortly.',
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .normal,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                // const Text(
                                //   'Please provide and link your company’s bank account to proceed further!',
                                //   style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                // ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: ElevatedButton(
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(4),
                            //         child: Text("Upload documents".toUpperCase(),
                            //             style: TextStyle(fontSize: 14)),
                            //       ),
                            //       style: ButtonStyle(
                            //           foregroundColor:
                            //               MaterialStateProperty.all<Color>(
                            //                   Colors.white),
                            //           backgroundColor:
                            //               MaterialStateProperty.all<Color>(
                            //                   Theme.of(context).primaryColor),
                            //           shape:
                            //               MaterialStateProperty.all<RoundedRectangleBorder>(
                            //                   RoundedRectangleBorder(
                            //                       borderRadius:
                            //                           BorderRadius.circular(50),
                            //                       side: BorderSide(
                            //                           color: Theme.of(context)
                            //                               .primaryColor)))),
                            //       onPressed: () async {
                            //         navigate2();
                            //         Navigator.of(context, rootNavigator: true)
                            //             .pop();
                            //       }),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      4),
                                  child: Text(
                                      "Close".toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 14)),
                                ),
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all<
                                        Color>(
                                        Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all<
                                        Color>(
                                        Theme
                                            .of(context)
                                            .primaryColor),
                                    shape:
                                    MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                50),
                                            side: BorderSide(
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor)))),
                                onPressed: () =>
                                    Navigator.of(context,
                                        rootNavigator: true)
                                        .pop(),
                              ),
                            ),
                            // TextButton(
                            //   onPressed: () => {Navigator.of(context, rootNavigator: true).pop(), _tab.changeTab(3)},
                            //   child: const Text('Update details'),
                            // ),
                          ],
                        ));

                return;
              }
            }
            context.beamToNamed('/addInvoice');
          },
          backgroundColor: HexColor('#0098DB'),
          child: Icon(Icons.add,color: Colors.white,),
        ):null,
        body: Container(
          decoration: bgDecoration,
          child: SingleChildScrollView(
            child: Padding(
              padding: Responsive.isMobile(context)
                  ? EdgeInsets.fromLTRB(15, 15, 15, 15)
                  : EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 22,
                  ),
                  TopBarWidget(
                      "👋 Welcome ${userData['userName']},", "Welcome, enjoy alternative financing!"),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 0 : 22,
                  ),
                  !Responsive.isMobile(context)?Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          var userData = Map<String, dynamic>.from(box.get('userData'));
                          print('User Data $userData');

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

                          if (_profileProvider.portfolioData.AL_UPLOAD != 2) {
                            // capsaPrint('Add incoive check');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                    'Change of Account Letter',
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
                                        Text(
                                          _profileProvider.portfolioData.AL_UPLOAD == 1
                                              ? 'Thank you for uploading your change of account form.\nPlease give us some minutes to verify your details.\nAn email will be sent to you shortly'
                                              : 'To trade your Invoice, please upload change of account letter.',
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
                                    if (_profileProvider.portfolioData.AL_UPLOAD == 0)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Text(
                                                  "Upload account letter".toUpperCase(),
                                                  style: TextStyle(fontSize: 14)),
                                            ),
                                            style: ButtonStyle(
                                                foregroundColor: MaterialStateProperty
                                                    .all<Color>(Colors.white),
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
                                            onPressed: () async {
                                              navigate();
                                              Navigator.of(context, rootNavigator: true)
                                                  .pop();
                                            }),
                                      ),
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
                                    // TextButton(
                                    //   onPressed: () => {Navigator.of(context, rootNavigator: true).pop(), _tab.changeTab(3)},
                                    //   child: const Text('Update details'),
                                    // ),
                                  ],
                                ));

                            return;
                          }

                          if (_profileProvider.portfolioData.newUser) {
                            if (_profileProvider
                                .portfolioData.kyc1 !=
                                2 ||
                                _profileProvider.portfolioData.kyc2 != 2 ||
                                _profileProvider.portfolioData.kyc3 != 2) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text(
                                          'KYC',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              const Text(
                                                'Your KYC Documents are currently being reviewed. Please give us some minutes to verify your details. An email will be sent to you shortly.',
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .normal,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              // const Text(
                                              //   'Please provide and link your company’s bank account to proceed further!',
                                              //   style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          // Padding(
                                          //   padding: const EdgeInsets.all(8.0),
                                          //   child: ElevatedButton(
                                          //       child: Padding(
                                          //         padding: const EdgeInsets.all(4),
                                          //         child: Text("Upload documents".toUpperCase(),
                                          //             style: TextStyle(fontSize: 14)),
                                          //       ),
                                          //       style: ButtonStyle(
                                          //           foregroundColor:
                                          //               MaterialStateProperty.all<Color>(
                                          //                   Colors.white),
                                          //           backgroundColor:
                                          //               MaterialStateProperty.all<Color>(
                                          //                   Theme.of(context).primaryColor),
                                          //           shape:
                                          //               MaterialStateProperty.all<RoundedRectangleBorder>(
                                          //                   RoundedRectangleBorder(
                                          //                       borderRadius:
                                          //                           BorderRadius.circular(50),
                                          //                       side: BorderSide(
                                          //                           color: Theme.of(context)
                                          //                               .primaryColor)))),
                                          //       onPressed: () async {
                                          //         navigate2();
                                          //         Navigator.of(context, rootNavigator: true)
                                          //             .pop();
                                          //       }),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    4),
                                                child: Text(
                                                    "Close".toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                              ),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Theme
                                                          .of(context)
                                                          .primaryColor),
                                                  shape:
                                                  MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                          side: BorderSide(
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColor)))),
                                              onPressed: () =>
                                                  Navigator.of(context,
                                                      rootNavigator: true)
                                                      .pop(),
                                            ),
                                          ),
                                          // TextButton(
                                          //   onPressed: () => {Navigator.of(context, rootNavigator: true).pop(), _tab.changeTab(3)},
                                          //   child: const Text('Update details'),
                                          // ),
                                        ],
                                      ));

                              return;
                            }
                          }
                          context.beamToNamed('/addInvoice');
                        },
                        child: Container(
                            width: Responsive.isMobile(context)?120:200,
                            height: Responsive.isMobile(context)?40:59,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(Responsive.isMobile(context)?5:15)),
                                color: HexColor('#0098DB')),
                            child: Center(
                                child: Text(
                              '+  Add invoice',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Responsive.isMobile(context)?12:18,
                                  color: Colors.white),
                            ))),
                      )
                    ],
                  ):Container(),
                  Responsive.isMobile(context)?SizedBox(height: 16,):SizedBox(height: 22,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // GeneratedAccountBalanceWidget(),
                        InkWell(
                          onTap: () => context.beamToNamed("/account"),
                          child: CardWidget(
                              width: !Responsive.isMobile(context) ? ((MediaQuery.of(context).size.width - 185 - 28 - 14) / 3) : null,
                              title: "Account Balance",
                              icon: "assets/images/account.png",
                              currency: true,
                              subText:
                                  formatCurrency(_profileProvider.totalBalance),
                              color: HexColor("#0098DB")),
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        InkWell(
                          onTap: () => context.beamToNamed("/history"),
                          child: CardWidget(
                              width: !Responsive.isMobile(context) ? ((MediaQuery.of(context).size.width - 185 - 28 - 14) / 3) : null,
                              title: "Total Invoices Traded",
                              icon: "assets/images/invbought.png",
                              currency: true,
                              subText:
                                  formatCurrency(portfolioData.totalDiscount),
                              color: HexColor("#219653")),
                        ),
                        SizedBox(
                          width: 14,
                        ),

                        InkWell(
                          onTap: () => context.beamToNamed("/history"),
                          child: CardWidget(
                              width: !Responsive.isMobile(context) ? ((MediaQuery.of(context).size.width - 185 - 28 - 14) / 3) : null,
                              title: "Total no of Transactions",
                              icon: "assets/images/timer.png",
                              currency: false,
                              subText: portfolioData.activeCount.toString(),
                              color: HexColor("#3AC0C9")),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  OrientationSwitcher(
                    orientation:
                        Responsive.isMobile(context) ? "Column" : "Row",
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invoices",
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
                              Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        context.beamToNamed('/bids');
                                      },
                                      child: Center(
                                          child: GeneratedPresentedWidget(
                                        _desktopHomeCardList[0],
                                        width: Responsive.isMobile(context)
                                            ? 160
                                            : 228,
                                      ))),
                                  SizedBox(height: 22),
                                  InkWell(
                                      onTap: () {
                                        context
                                            .beamToNamed('/pending-invoices');
                                      },
                                      child: GeneratedPresentedWidget(
                                        _desktopHomeCardList[2],
                                        width: Responsive.isMobile(context)
                                            ? 160
                                            : 228,
                                      )),
                                ],
                              ),
                              SizedBox(width: 22),
                              Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Responsive.isMobile(context)?context.beamToNamed('/invoice-builder'):context.beamToNamed('/live-invoices');
                                      },
                                      child: GeneratedPresentedWidget(
                                        _desktopHomeCardList[1],
                                        width: Responsive.isMobile(context)
                                            ? 160
                                            : 228,
                                      )),
                                  SizedBox(height: 22),
                                  InkWell(
                                      onTap: () {
                                        context.beamToNamed('/all-invoices');
                                      },
                                      child: GeneratedPresentedWidget(
                                        _desktopHomeCardList[3],
                                        width: Responsive.isMobile(context)
                                            ? 160
                                            : 228,
                                      )),
                                ],
                              ),
                            ],
                          ),
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
                            "Quick Guide",
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
                          Container(
                            width: 590,
                            height: 240,
                            child: InkWell(
                              onTap: () {
                                return showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    YoutubePlayerController _controller =
                                        YoutubePlayerController(
                                      initialVideoId: 'IBWF4Gp7xgs',
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
                                      width: Responsive.isMobile(context)
                                          ? MediaQuery.of(context).size.width *
                                              0.92
                                          : 590,
                                      height: Responsive.isMobile(context)
                                          ? 180
                                          : 240,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 25),
                                          topRight: Radius.circular(
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 25),
                                          bottomLeft: Radius.circular(
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 25),
                                          bottomRight: Radius.circular(
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 25),
                                        ),
                                        // color: Color.fromRGBO(3, 3, 3, 0.7843137254901961),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/hqdefault.png'),
                                            fit: Responsive.isMobile(context)
                                                ? BoxFit.contain
                                                : BoxFit.fitWidth),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0.0,
                                    top: 0.0,
                                    child: Container(
                                      width: Responsive.isMobile(context)
                                          ? MediaQuery.of(context).size.width *
                                              0.92
                                          : 590,
                                      height: Responsive.isMobile(context)
                                          ? 180
                                          : 240,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 25),
                                          topRight: Radius.circular(
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 25),
                                          bottomLeft: Radius.circular(
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 25),
                                          bottomRight: Radius.circular(
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 25),
                                        ),
                                        // color: Color.fromRGBO(3, 3, 3, 0.7843137254901961),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Rectangle 90.png'),
                                            fit: Responsive.isMobile(context)
                                                ? BoxFit.contain
                                                : BoxFit.fitWidth),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      left: Responsive.isMobile(context)
                                          ? 150
                                          : 250,
                                      top: Responsive.isMobile(context)
                                          ? 80
                                          : 110.0,
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
                            height: Responsive.isMobile(context) ? 5 : 22,
                          ),
                          Container(
                            child: GeneratedFrame171Widget(),
                          ),
                        ],
                      )
                    ],
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
