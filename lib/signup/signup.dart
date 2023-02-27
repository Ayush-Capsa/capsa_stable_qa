import 'package:beamer/beamer.dart';
import 'package:capsa/common/MyCustomScrollBehavior.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/signup/pages/account-letter/account_letter_download.dart';
import 'package:capsa/signup/pages/account-letter/account_letter_upload.dart';
import 'package:capsa/signup/pages/account-letter/account_letter_upload_success.dart';
import 'package:capsa/signup/pages/capsa_account_generation.dart';
import 'package:capsa/signup/pages/enter_address_page.dart';
import 'package:capsa/signup/pages/enter_details_page.dart';
import 'package:capsa/signup/pages/enter_information_page.dart';
import 'package:capsa/signup/pages/forget_password.dart';
import 'package:capsa/signup/pages/last_success_page.dart';
import 'package:capsa/signup/pages/onboard_page.dart';
import 'package:capsa/signup/pages/otp_verify.dart';
import 'package:capsa/signup/pages/password_set_page.dart';
import 'package:capsa/signup/pages/registration_complete_screen.dart';
import 'package:capsa/signup/pages/resubmit-documents/resubmit_document_page.dart';
import 'package:capsa/signup/pages/resubmit-documents/resubmit_document_success_page.dart';
import 'package:capsa/signup/pages/select_account_type.dart';
import 'package:capsa/signup/pages/select_country.dart';
import 'package:capsa/signup/pages/signin.dart';
import 'package:capsa/signup/pages/terms_and_condition.dart';
import 'package:capsa/signup/pages/resubmit-documents/verification_unsuccessful_page.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  final String passwordResetToken;
  const Signup({this.passwordResetToken, Key key}) : super(key: key);

  @override
  State<Signup> createState() =>
      _SignupState(passwordResetToken: this.passwordResetToken);
}

class _SignupState extends State<Signup> {
  var routerDelegate;
  String passwordResetToken;
  _SignupState({this.passwordResetToken});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // capsaPrint("VendorNewApp");
    String initialPathFinal = "/sign_in";
    capsaPrint("Password reset token is");
    capsaPrint(passwordResetToken);
    if (passwordResetToken != null) {
      initialPathFinal = "/change-password";
    }
    routerDelegate = BeamerDelegate(
      initialPath: initialPathFinal,
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
                      '/change-password': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('forgotPassword-holaholahola'),
                          title: 'Reset Your Password',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/change-password",
                              title: "Change password",
                              body: PasswordSetPage(
                                  token: widget.passwordResetToken,
                                  isReset: true)),
                        );
                      },
                      '/sign_in': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('sign_in'),
                          title: 'Sign In',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/home",
                              isSignup: true,
                              mobileTitle: 'Sign In',
                              title: 'Sign In',
                              body: SignIn()),
                        );
                      },
                      '/signup': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('signup'),
                          title: 'Sign up',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/signup",
                              mobileTitle: 'Sign Up',
                              title: 'Sign Up',
                              body: SelectAccountType()),
                        );
                      },
                      '/select-country': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('select-country'),
                          title: 'Select Country',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/select-country",
                              mobileTitle: 'Select Country',
                              title: 'Select Country',
                              body: SelectCountry()),
                        );
                      },
                      '/onboard': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('onboard'),
                          title: 'Sign up || Onboard',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/onboard",
                              mobileTitle: 'Sign Up',
                              title: 'Sign Up',
                              body: OnBoardPage()),
                        );
                      },
                      '/email-otp': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('email-otp'),
                          title: 'Verify Your E-mail',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/email-otp",
                              mobileTitle: 'Verify OTP',
                              title: 'Verify OTP',
                              body: OTPVerifyPage(isEmail: true)),
                        );
                      },
                      '/mobile-otp': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('mobile-otp'),
                          title: 'Verify Your Contact Number',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/mobile-otp",
                              mobileTitle: 'Verify OTP',
                              title: 'Verify OTP',
                              body: OTPVerifyPage(isEmail: false)),
                        );
                      },
                      '/home/:id/details': (context, state, data) {
                        final id = state.pathParameters['id'];
                        return BeamPage(
                          key: ValueKey(id + '-details'),
                          title: id.toUpperCase() + ' Details',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/home/" + id + "/details",
                              mobileTitle: 'Details',
                              title: 'Details',
                              body: EnterDetailsPage()),
                        );
                      },
                      '/home/:id/information': (context, state, data) {
                        final id = state.pathParameters['id'];
                        return BeamPage(
                          key: ValueKey(id + '-information'),
                          title: id.toUpperCase() + ' Information',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/home/" + id + "/information",
                              mobileTitle: 'Information',
                              title: 'Information',
                              body: EnterInformationPage()),
                        );
                      },
                      '/home/:id/address': (context, state, data) {
                        final id = state.pathParameters['id'];
                        return BeamPage(
                          key: ValueKey(id + '-address'),
                          title: id.toUpperCase() + ' Address',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/home/" + id + "/address",
                              mobileTitle: 'Information',
                              title: 'Information',
                              body: EnterAddressPage()),
                        );
                      },
                      '/reupload-document-page': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('Reupload-Document-Page'),
                          title: 'Reupload Document',
                          // popToNamed: 'on,
                          child: RegistrationMain(
                              pageUrl: "/reupload-document-page",
                              mobileTitle: 'Reupload Document',
                              title: 'Reupload Document',
                              body: ReUploadDocumentPage()),
                        );
                      },
                      '/verification-unsuccessful': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('verification-unsuccessful'),
                          title: 'Verification Unsuccessful',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/verification-unsuccessful",
                              mobileTitle: 'Verification Unsuccessful',
                              title: 'Verification Unsuccessful',
                              body: VerificationUnsuccessful()),
                        );
                      },
                      '/resubmit-document-success-page': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('resubmit-document-success-page'),
                          title: 'Reupload Document Success',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/verification-unsuccessful",
                              mobileTitle: 'Reupload Document Success',
                              title: 'Reupload Document Success',
                              body: ResubmitDocumentSuccessPage()),
                        );
                      },
                      '/forgot-password': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('forget_password'),
                          title: 'Forgot Password',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/forgot-password",
                              mobileTitle: 'Forgot Password',
                              title: 'Forgot Password',
                              body: ForgetPassword()),
                        );
                      },
                      '/terms-and-condition': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('termsCondition'),
                          title: 'Terms And Condition',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/terms-and-condition",
                              mobileTitle: 'Terms And Condition',
                              title: 'Terms And Condition',
                              body: TermsAndCondition()),
                        );
                      },
                      '/success': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('success'),
                          title: 'Success',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/success",
                              mobileTitle: 'Success',
                              title: 'Success',
                              body: LastSuccessPage()),
                        );
                      },
                      '/registration-complete': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('registration'),
                          title: 'Registration Complete',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/registration-complete",
                              mobileTitle: 'Registration Complete',
                              title: 'Registration Complete',
                              body: RegistrationCompletePage()),
                        );
                      },
                      '/account-generation': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('CapsaAccountGeneration'),
                          title: 'Capsa Account Generation',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/account-generation",
                              mobileTitle: 'Account Generation',
                              title: 'Account Generation',
                              body: CapsaAccountGeneration()),
                        );
                      },
                      '/account-letter-download': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('CapsaAccountLetterDownload'),
                          title: 'Capsa Account Letter Download',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/account-letter-download",
                              mobileTitle: 'Account Letter Download',
                              title: 'Account Letter Download',
                              body: AccountLetterDownload()),
                        );
                      },
                      '/account-letter-upload/:encryptedList': (context, state, data) {
                        final id = state.pathParameters['encryptedList'];
                        return BeamPage(
                          key: ValueKey(id + '-CapsaAccountLetterUpload'),
                          title: id.toUpperCase() + ' Details',
                          // popToNamed: '/',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: '/account-letter-upload/'+id,
                              mobileTitle: 'Account Letter Upload',
                              title: 'Account Letter Upload',
                              body: AccountLetterUpload(selectedList: id,)),
                        );
                      },
                      '/account-letter-upload-success': (context, state, data) {
                        return BeamPage(
                          key: ValueKey('CapsaAccountLetterUploadSucess'),
                          title: 'Capsa Account Letter Upload',
                          type: BeamPageType.fadeTransition,
                          child: RegistrationMain(
                              pageUrl: "/account-letter-upload-success",
                              mobileTitle: 'Account Letter Upload',
                              title: 'Account Letter Upload',
                              body: AccountLetterUploadSuccessPage()),
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
        ChangeNotifierProvider<SignUpActionProvider>(
          create: (_) => SignUpActionProvider(),
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

class RegistrationMain extends StatelessWidget {
  final Widget body;
  final String pageUrl;
  final bool menuList;
  final bool backButton;
  final bool isSignup;
  final String mobileTitle;
  final String title;
  final String mobileSubTitle;
  final String backUrl;

  RegistrationMain(
      {this.pageUrl,
      this.isSignup: false,
      this.body,
      this.title: '',
      this.mobileSubTitle,
      this.mobileTitle,
      this.backUrl,
      this.menuList,
      this.backButton,
      Key key})
      : super(key: key);

  final BoxDecoration bgDecoration = BoxDecoration(
    color: HexColor("#3AC0C9"),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (Responsive.isMobile(context))
          ? body
          : Container(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: bgDecoration,
              child: Responsive(
                desktop: Row(
                  children: <Widget>[
                    if (!Responsive.isMobile(context))
                      SideBar(
                        isSideImage: isSignup,
                        sideTopText: title,
                      ),
                    // const VerticalDivider(thickness: 1, width: 1),

                    Expanded(
                      child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: Responsive.isMobile(context)
                                ? HexColor("#0098DB")
                                : HexColor("#F5FBFF"),
                          ),
                          child: body),
                    )
                  ],
                ),
                mobile: body,
              ),
            ),
    );
  }
}

class SideBar extends StatelessWidget {
  final bool isSideImage;
  final String sideTopText;

  const SideBar({this.isSideImage: true, this.sideTopText: '', Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185,
      height: MediaQuery.of(context).size.height,
      decoration: isSideImage
          ? BoxDecoration()
          : BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/signup-sidebar.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
      child: (!isSideImage)
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        'Sign In',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 24,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 300,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back to',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                // fontFamily: 'Poppins',
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            "Capsa",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontFamily: 'Poppins',
                                fontSize: 26,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
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
