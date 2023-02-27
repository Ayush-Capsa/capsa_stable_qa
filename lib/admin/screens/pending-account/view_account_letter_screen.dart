import 'package:capsa/admin/models/invoice_model.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/main.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:http/http.dart' as http;
import 'package:capsa/functions/call_api.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewAccountLetterScreen extends StatefulWidget {
  PendingAccountData data;
  ViewAccountLetterScreen({Key key, this.data}) : super(key: key);

  @override
  State<ViewAccountLetterScreen> createState() =>
      _ViewAccountLetterScreenState();
}

class _ViewAccountLetterScreenState extends State<ViewAccountLetterScreen> {
  final emailController = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  String _email = '';

  bool cacCertificate = false;
  bool cacForm = false;
  bool validId = false;

  bool value(dynamic x) {
    if (x.toString() == '1') {
      return true;
    } else {
      return false;
    }
  }

  String stringInterpretation(bool x) {
    return x ? '1' : '0';
  }

  Widget preferenceCheck(Widget w, String title, String subText) {
    bool c = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          w,
          SizedBox(
            width: 33,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: HexColor('#333333')),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                subText,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#333333')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool saving = false;

  bool isSet = false;

  bool valuesSet = false;

  bool loaded = false;

  Future _future;

  List<AccountLetterModel> accountLetters = [];

  void getData() async {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    accountLetters =
        await profileProvider.fetchAccountLetter(widget.data.panNumber);

    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    //final profileProvider = Provider.of<ProfileProvider>(context);\
    //final profileProvider = Provider.of<ProfileProvider>(context);
    final Box box = Hive.box('capsaBox');
    var userData = Map<String, dynamic>.from(box.get('userData'));
    // if(!valuesSet) {
    //   _asyncmethodCall(profileProvider);
    // }

    //capsaPrint("\n\nUserdata $userData \nPanNumber ${widget.panNumber}");

    getData();

    emailController.text = userData['email'];
  }

  @override
  Widget build(BuildContext context) {
    //UserData userDetails = profileProvider.userDetails;

    final profileProvider = Provider.of<ProfileProvider>(context);

    if (!saving) {
      isSet = true;
    }
    final Box box = Hive.box('capsaBox');

    return Scaffold(
      body: Row(
        children: [
          Container(
            //width: 185,
            margin: EdgeInsets.all(0),
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.11,
            // color: Colors.black,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              color: Colors.black,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50.5, 36, 50.5, 24),
                    child: SizedBox(
                      width: 80,
                      height: 45.42,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ChangeNotifierProvider(
                      //         create: (BuildContext
                      //         context) =>
                      //             AnchorActionProvider(),
                      //         child:
                      //        AnchorHomePage()),
                      //   ),
                      // );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: HexColor("#0098DB"),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: loaded
                ? Container(
                    // height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(
                        Responsive.isMobile(context) ? 15 : 25.0),
                    child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 22,
                                ),
                                TopBarWidget("Account Letters",
                                    'Verify Account letters uploaded by user'),
                                Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 22,
                                ),

                                if(accountLetters.isEmpty)
                                  Center(child: Text('No Account Letter available'),),

                                for (int i = 0; i < accountLetters.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Account Letter for ${accountLetters[i].anchorName}",
                                                  ),
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20),
                                                      constraints:
                                                          BoxConstraints(
                                                              minWidth: 750),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          accountLetters[i].uploaded?Expanded(
                                                            child: accountLetters[
                                                                            i]
                                                                        .fileExtension ==
                                                                    'pdf'
                                                                ? SfPdfViewer
                                                                    .network(
                                                                    accountLetters[
                                                                            i]
                                                                        .accountLetterUrl,
                                                                  )
                                                                : Image.network(
                                                                    accountLetters[
                                                                            i]
                                                                        .accountLetterUrl),
                                                          ):Container(
                                                            child: Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(24.0),
                                                                child: Text(
                                                                  'File not available',
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize: 22,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Colors.black),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          (accountLetters[i].isApproved == '1' || accountLetters[i].isApproved == '2' || !accountLetters[i].uploaded)?
                                                          Container(
                                                            child : accountLetters[i].isApproved == '1'?
                                                            Row(
                                                              children: [
                                                                Icon(Icons.check, color: Colors.green,),
                                                                SizedBox(width: 10,),
                                                                Text('Document has been accepted', style: GoogleFonts.poppins(fontSize: 20),),
                                                              ],
                                                            ):accountLetters[i].isApproved == '2'?Row(
                                                              children: [
                                                                Icon(Icons.cancel, color: Colors.red,),
                                                                SizedBox(width: 10,),
                                                                Text('Document has been rejected', style: GoogleFonts.poppins(fontSize: 20),),
                                                              ],
                                                            ):Container(),
                                                          ):
                                                          !saving
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          saving =
                                                                              true;
                                                                        });
                                                                        dynamic
                                                                            response =
                                                                            await profileProvider.actionAccountLetter(accountLetters[i],
                                                                                '1');
                                                                        setState(
                                                                            () {
                                                                          saving =
                                                                              false;
                                                                        });
                                                                        if (response['msg'] ==
                                                                            'success') {
                                                                          showToast(
                                                                              'Account Letter Accepted',
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                          getData();
                                                                        } else {
                                                                          showToast(
                                                                              'Something went wrong',
                                                                              context,
                                                                              type: 'error');
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            200,
                                                                        height:
                                                                            49,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15)),
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Accept',
                                                                            style: GoogleFonts.poppins(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          saving =
                                                                              true;
                                                                        });
                                                                        dynamic
                                                                            response =
                                                                            await profileProvider.actionAccountLetter(accountLetters[i],
                                                                                '0');
                                                                        setState(
                                                                            () {
                                                                          saving =
                                                                              false;
                                                                        });
                                                                        if (response['msg'] ==
                                                                            'success') {
                                                                          showToast(
                                                                              'Account Letter Rejected',
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                          getData();
                                                                        } else {
                                                                          showToast(
                                                                              'Something went wrong',
                                                                              context,
                                                                              type: 'error');
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            200,
                                                                        height:
                                                                            49,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15)),
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Reject',
                                                                            style: GoogleFonts.poppins(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    CircularProgressIndicator(),
                                                                  ],
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        'View Account Letter for ${accountLetters[i].anchorName}',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue),
                                      ),
                                    ),
                                  )

                                // SizedBox(
                                //   height: 15,
                                // ),
                              ],
                            ),
                          ],
                        )),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );

    //return
  }
}
