import 'package:beamer/beamer.dart';
import 'package:capsa/anchor/pages/homepage.dart';

import 'package:capsa/common/MyCustomScrollBehavior.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/page_bgimage.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/widgets/capsaapp/generated_mobilemenunavigationsvendorwidget/Generated_MobileMenuNavigationsVendorWidget.dart';

import 'package:capsa/anchor/provider/anchor_action_providers.dart';




import 'package:capsa/widgets/DesktopMainMenuWidget.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class AnchorApp extends StatefulWidget {
  AnchorApp({Key key}) : super(key: key);

  @override
  State<AnchorApp> createState() => _AnchorAppState();
}

class _AnchorAppState extends State<AnchorApp> {
  var routerDelegate;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // capsaPrint("VendorNewApp");
    routerDelegate = BeamerDelegate(
      initialPath: '/home',
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/*': (context, state,data) {
            final beamerKey = GlobalKey<BeamerState>();

            return Scaffold(
              body: Beamer(
                key: beamerKey,
                routerDelegate: BeamerDelegate(
                  locationBuilder: RoutesLocationBuilder(
                    routes: {

                      '/home': (context, state,data) {
                        return BeamPage(
                          key: ValueKey('anchor-home'),
                          title: 'Invoices',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: VendorMain(
                              pageUrl: "/home",
                              mobileTitle: "👋 Capsa,",
                              mobileSubTitle: "Welcome, enjoy alternative financing!",
                              body: AnchorHomePage()),
                        );
                      },

                      '/sign_in': (context, state,data) {
                        return BeamPage(
                          key: ValueKey('Loading'),
                          title: 'Loading...',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child:  Container(child: Center(child:
                          CircularProgressIndicator(),)

                            ,),
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
        ChangeNotifierProvider<AnchorActionProvider>(
          create: (_) => AnchorActionProvider(),
        ),

      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) {
          return 'Dashboard';
        },
        backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
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
  final String mobileTitle;
  final String mobileSubTitle;
  final String backUrl;

  VendorMain({this.pageUrl, this.body, this.mobileSubTitle, this.mobileTitle, this.backUrl, this.menuList, this.backButton, Key key})
      : super(key: key);

  final List<Map> _menuList = [
    {
      'title': 'Invoices',
      'icon': 'assets/icons/homeIcons.png',
      'activeIcon': 'assets/icons/active_homeIcons.png',
      'active': false,
      'url': "/home",
    },

  ];

  final List<Map> _invoiceMenuList = [

  ];

  @override
  Widget build(BuildContext context) {
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

    var invMenu2  ; // ? invBottomMenu(_invoiceMenuList, context) : null

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
                        if (invmenu)
                          context.beamToNamed('/home');
                        else
                          context.beamBack();
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
                        mobileTitle != null ? mobileTitle : '👋 Capsa,',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                      if (mobileSubTitle != null)
                        SizedBox(
                          height: 8,
                        ),
                      if (mobileSubTitle != null)
                        Text(
                          (mobileSubTitle != null) ? mobileSubTitle : 'Welcome, enjoy alternative financing!',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              // fontFamily: 'Poppins',
                              fontSize: 14,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
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
              DesktopMainMenuWidget(_menuList2, backUrl: backUrl, backButton: _backButton),
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
