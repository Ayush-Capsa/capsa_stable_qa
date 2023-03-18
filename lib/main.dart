import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:capsa/admin/admin.dart';
import 'package:capsa/common/MyCustomScrollBehavior.dart';
import 'package:capsa/investor/investor_new.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/change_notifier_provider.dart';
// import 'package:capsa/investor/vendor_new.dart';
// import 'package:capsa/signup/providers/verification_provider.dart';
// import 'package:capsa/signup/screens/activate_acct_screen.dart';
// import 'package:capsa/signup/screens/forget_pass.dart';
// import 'package:capsa/signup/screens/sign_in.dart';
// import 'package:capsa/signup/screens/unactive_acct_screen.dart';
import 'package:capsa/vendor-new/vendor_new.dart';
// import 'package:capsa/vendor/providers/invoice_providers.dart';
// import 'package:capsa/vendor/providers/profile_provider.dart';
// import 'package:capsa/vendor/vendor_new.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'anchor/Mobile_Home_Page.dart';
import 'anchor/Responsive_Layout.dart';
import 'anchor/anchor.dart';
import 'anchor/anchor_home.dart';
import 'anchor/provider/anchor_action_providers.dart';
import 'common/app_theme.dart';
import 'package:capsa/functions/custom_print.dart';
import 'investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'providers/auth_provider.dart';
import 'signup/signup.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   //capsaPrint = (String message, {int wrapWidth}) {};
//   await Hive.initFlutter();
//   const String _appTitle = 'Capsa Quality';
//   const String _buildFlavour = 'dev';
//   const String _ip = 'https://getcapsa.ml/api/';
//   // const String _ip = 'http://127.0.0.1:3012/';
//   runMain(appTitle: _appTitle, buildFlavour: _buildFlavour, ip: _ip);
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // if (!Hive.isAdapterRegistered(1)) {
  //   Hive.registerAdapter(DataModelAdapter());
  // }
  const String _appTitle = 'Capsa Quality';
  const String _buildFlavour = 'dev';
  const String _ip = 'https://getcapsaquality.com/api/';
  // const String _ip = 'http://127.0.0.1:3012/';
  runMain(appTitle: _appTitle, buildFlavour: _buildFlavour, ip: _ip);
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   //capsaPrint = (String message, {int wrapWidth}) {};
//   await Hive.initFlutter();
//   const String _appTitle = 'Capsa Quality';
//   const String _buildFlavour = 'dev';
//   const String _ip = 'https://getcapsadev.com/api/';
//   // const String _ip = 'http://127.0.0.1:3012/';
//   runMain(appTitle: _appTitle, buildFlavour: _buildFlavour, ip: _ip);
// }



Future<void> runMain(
    {@required String appTitle,
    @required String buildFlavour,
    @required String ip}) async {
// Future<void> main() async {

  Box box = await Hive.openBox('capsaBox');

  if(box.isEmpty) {
    // print('EMPTY BOX');
    box.clear();
  }

  box = await Hive.openBox('capsaBox');
  // print('buildFlavour ->' + buildFlavour);
  box.put('ip', ip);
  box.put('buildFlavour', buildFlavour);

  // final flavor = const String.fromEnvironment("flavor");
  // print('flavor');
  // print(flavor);

  //print = (String message, {int wrapWidth}) {};
  runZonedGuarded(() {
    runApp(CapsaApp());
  }, (error, stackTrace) {
    print(stackTrace);
  }, zoneSpecification: new ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String message){
        // parent.print(zone, '${new DateTime.now()}: $message');
        /**
         * print only in debug mode
         * */
        if (kDebugMode) {
          parent.print(zone, message);
        }
      }));
  //runApp(CapsaApp());
  setPathUrlStrategy();
}

class CapsaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        // ChangeNotifierProvider<ProfileProvider>(
        //   create: (_) => ProfileProvider(),
        // ),
        // ChangeNotifierProvider<InvoiceProvider>(
        //   create: (_) => InvoiceProvider(),
        // ),
        // ChangeNotifierProvider<ActionProvider>(
        //   create: (_) => ActionProvider(),
        // ),
        // ChangeNotifierProvider<VerificationDataProvider>(
        //   create: (_) => VerificationDataProvider(),
        // ),
        // ChangeNotifierProvider<SignupActionProvider.ActionProvider>(
        //   create: (_) => SignupActionProvider.ActionProvider(),
        // ),
      ],
      child: CapsaMaterialApp(),
    );
  }
}

class CapsaMaterialApp extends StatefulWidget {
  const CapsaMaterialApp({
    Key key,
  }) : super(key: key);

  @override
  _CapsaMaterialAppState createState() => _CapsaMaterialAppState();
}

class _CapsaMaterialAppState extends State<CapsaMaterialApp> {
  final routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
        pathPatterns: [
          '/admin',
          '/vendor',
          '/home',
          '/anchor',
        ],
        check: (context, location) {
          final box = Hive.box('capsaBox');
          final authProvider = box.get('isAuthenticated', defaultValue: false);
          print('Authenticated: $authProvider');
          return authProvider;
        },
        beamToNamed: (origin, target) => '/login',
        onCheckFailed: (context, location) {
          print('No Authentication!');
        },
      ),
    ],
    initialPath: '/',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/signin/forgot-password': (context, state, data) {
          // print("reaching here");
          final _token = state.queryParameters['t'];
          return BeamPage(
            key: ValueKey('Capsahome2'),
            title: 'Capsa',
            type: BeamPageType.material,
            child: CapsaHome(passwordResetToken: _token),
          );
        },
        '/': (context, state, data) {
          // context.beamTo('location');
          return BeamPage(
            key: ValueKey('Capsahome'),
            title: 'Capsa',
            type: BeamPageType.material,
            child: CapsaHome(),
          );
        },
        '/*': (context, state, data) {
          // context.beamTo('location');
          return BeamPage(
            key: ValueKey('Capsahome2'),
            title: 'Capsa',
            type: BeamPageType.material,
            child: CapsaHome(),
          );
        },
        '/anchor-analysis':(context, state, data) {
          // context.beamTo('location');
          return BeamPage(
            key: ValueKey('AnchorAnalysis'),
            title: 'Capsa',
            type: BeamPageType.material,
            child: AnchorAnalysisHomePage(),
          );
        },

        // '/activate/token': (context, state,data) {
        //   // final _token = state.pathParameters['bookId'];
        //   final _token = state.queryParameters['t'];
        //   // print("bookId here first");
        //   // print(_token);
        //   return BeamPage(
        //     key: ValueKey('activate-account'),
        //     title: 'Activate Capsa Account',
        //     // popToNamed: '/',
        //     type: BeamPageType.scaleTransition,
        //     child: ActivateAccountScreen(token: _token),
        //   );
        // },
        // '/sign_in': (context, state,data) {
        //   return BeamPage(
        //     key: ValueKey('SignIn'),
        //     title: 'Sign In',
        //     popToNamed: '/',
        //     type: BeamPageType.material,
        //     child: SignIn(),
        //   );
        // },
        // '/unactivated': (context, state,data) {
        //   return BeamPage(
        //     key: ValueKey('unactivated'),
        //     title: 'unactivated',
        //     popToNamed: '/',
        //     type: BeamPageType.material,
        //     child: UnActiveAccountScreen(),
        //   );
        // },

        // '/forget_password': (context, state,data) {
        //   return BeamPage(
        //     key: ValueKey('Forget-Password'),
        //     title: 'Forget Password',
        //     popToNamed: '/',
        //     type: BeamPageType.material,
        //     child: ForgetPasswordPage(),
        //   );
        // },

        // '/forgetPassword': (context,state) =>    ActivateAccountScreen(isReset:  true),
        '/signup': (context, state, data) =>
            BeamPage(key: ValueKey('SignupApp'), child: Signup()),

        // '/forgetPassword/token': (context, state,data) {
        //   final _token = state.queryParameters['t'];
        //   return BeamPage(
        //     key: ValueKey('forgetPassword-$_token'),
        //     title: 'Reset Your Password',
        //     popToNamed: '/',
        //     type: BeamPageType.scaleTransition,
        //     child: ActivateAccountScreen(token: _token, isReset: true),
        //   );
        // },
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) {
        return 'Dashboard';
      },
      scrollBehavior: MyCustomScrollBehavior(),
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
    );
  }
}

class CapsaHome extends StatelessWidget {
  final box = Hive.box('capsaBox');
  final DateTime now = new DateTime.now();
  String passwordResetToken = "";

  CapsaHome({this.passwordResetToken, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData;
    final authProvider = Provider.of<AuthProvider>(context);
    DateTime loginTime;

    loginTime = box.get('loginTime');
    // print(passwordResetToken);

    var _role = "";
    if (box.get('isAuthenticated', defaultValue: false)) {
      capsaPrint('Pass 1 auth');
      var _auth = authProvider.isAuthenticated;
      userData = Map<String, dynamic>.from(box.get('userData'));
      authProvider.authChange(true, userData['role'], notify: false);
      authProvider.setUserdata(userData);
      _role = userData['role'];
    }

    if (loginTime != null) {
      if (now.difference(loginTime).inMilliseconds > 0) {
        // print('Auto logout');\
        capsaPrint('Pass 2');
        box.put('isAuthenticated', false);
        box.delete('userData');
        box.delete('loginUserData');
        box.delete('loginTime');
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.authChange(false, '');
        // Beamer.of(context).beamToNamed('/sign_in', replaceCurrent: true);
        // print(pass           wordResetToken);
        return Signup(passwordResetToken: passwordResetToken);
      }
    }

    if (_role == 'ADMIN') {
      return AdminApp();
    } else if (_role == 'BUYER') {
      return ChangeNotifierProvider(
        create: (BuildContext context) => AnchorActionProvider(),
        child: responsiveLayout(
            mobileBody: mobileHomePage(), desktopBody: anchorHomePage()),
      );
    } else if (_role == 'INVESTOR') {
      return InvestorNewApp();
      return ChangeNotifierProvider(
        create: (BuildContext context) => AnchorAnalysisProvider(),
        child: AnchorAnalysisHomePage(),
      );
      // //return AnchorAnalysisHomePage();
    } else if (_role == 'COMPANY') {
      return VendorNewApp();
    } else {
      return Signup(passwordResetToken: passwordResetToken);
    }
  }
}
