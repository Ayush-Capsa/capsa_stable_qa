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

class EditBvnScreen extends StatefulWidget {
  PendingAccountData data;
  EditBvnScreen({Key key, this.data}) : super(key: key);

  @override
  State<EditBvnScreen> createState() => _EditBvnScreenState();
}

class _EditBvnScreenState extends State<EditBvnScreen> {
  final directorController = TextEditingController(text: '');
  final bvnController = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  bool value(dynamic x){
    if(x.toString() == '1') {
      return true;
    } else {
      return false;
    }
  }

  String stringInterpretation(bool x){
    return x ? '1':'0';
  }

  dynamic body(){
    dynamic _body = {
      "panNumber_old": widget.data.panNumber,
      "panNumber_new": bvnController.text,
      "director_name": directorController.text,
      "role": widget.data.role,
    };

    return _body;
  }


  bool saving = false;

  bool isSet = false;

  dynamic _body = {};

  bool valuesSet = false;

  Future _future;

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

    bvnController.text = formatPanNumber(widget.data.panNumber);



  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    //UserData userDetails = profileProvider.userDetails;

    final Box box = Hive.box('capsaBox');

    return Scaffold(
      body: Row(

        children: [
          Container(
            //width: 185,
            margin: EdgeInsets.all(0),
            height: double.infinity,
            width: MediaQuery.of(context).size.width*0.11,
            // color: Colors.black,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15)
              )),
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
            child: Container(
              // height: MediaQuery.of(context).size.height,
              padding:
              EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
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
                          TopBarWidget("Edit User BVN details",
                              ''),
                          Text(
                            "",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          Container(
                            // height: MediaQuery.of(context).size.height * 0.8,
                            width: Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.53,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      child: UserTextFormField(
                                        label: "Director's Name",
                                        hintText:
                                        "Enter Director's Name",
                                        controller: directorController,
                                        // suffixIcon: InkWell(
                                        //     onTap: () {
                                        //       setState(() {
                                        //         obscureText = !obscureText;
                                        //       });
                                        //     },
                                        //     child: Padding(
                                        //       padding:
                                        //           const EdgeInsets.all(8.0),
                                        //       child: Image.asset(
                                        //         "assets/images/eye-Icons.png",
                                        //         height: 14,
                                        //       ),
                                        //     )),
                                        onChanged: (v) {
                                          //_password = v;
                                        },
                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return "This field is required.";
                                          }
                                          return null;
                                        },
                                        // errorText: passwordErrorText,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      child: UserTextFormField(
                                        label: " Director's Bank Verification Number (BVN)",
                                        hintText: "Enter personal BVN of director",
                                        controller: bvnController,
                                        onChanged: (v) {

                                        },
                                        readOnly: false,
                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return "This field is required.";
                                          }if(v.length!=10){
                                            return "Enter 10 digit account number";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                if (saving)
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {

                                          setState(() {
                                            valuesSet = false;
                                          });

                                          _body = body();

                                          dynamic response = await profileProvider.updateBVN(_body);

                                          capsaPrint('Set preferences response : $response');



                                          if(response['msg'] == 'success'){
                                            showToast('BVN details updated', context);
                                            Navigator.pop(context);
                                          }else{
                                            showToast(response['message'], context, type: 'error');
                                          }




                                        },
                                        child: Container(
                                            width: Responsive.isMobile(context)
                                                ? MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.8
                                                : MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.2,
                                            height: 59,
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(15),
                                                        topRight:
                                                        Radius.circular(15),
                                                        bottomLeft:
                                                        Radius.circular(15),
                                                        bottomRight:
                                                        Radius.circular(15),
                                                      ),
                                                      color: Color.fromRGBO(
                                                          0, 152, 219, 1),
                                                    ),
                                                    width:
                                                    Responsive.isMobile(context)
                                                        ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.8
                                                        : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.2,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 16),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Save Details',
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                                color:
                                                                Color.fromRGBO(
                                                                    242,
                                                                    242,
                                                                    242,
                                                                    1),
                                                                fontFamily:
                                                                'Poppins',
                                                                fontSize: 18,
                                                                letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                height: 1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ])),
                                      ),
                                      SizedBox(width: 51,),
                                      InkWell(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),))
                                    ],
                                  ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );




    //return
  }

  // void _asyncmethodCall(ProfileProvider profileProvider) async {
  //   // async code here
  //   capsaPrint('Pass 1');
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //
  //     setState(() {
  //       // Here you can write your code for open new view
  //     });
  //
  //   });
  //   //capsaPrint('Pass 2 ${widget.panNumber}');
  //   //final profileProvider = Provider.of<ProfileProvider>(context);
  //   capsaPrint('Pass 3');
  //   dynamic data = await profileProvider.getUserEmailPreference(panNumber: widget.data.panNumber, role: 'INVESTOR');
  //   capsaPrint('Pass 4 $data');
  //   emailController.text = data['data']['email'];
  //   newDeals = value(data['data']['newDeals']);
  //   bidAccepted = value(data['data']['bidAccepted']);
  //   bidRejected = value(data['data']['bidRejected']);
  //   purchaseOnInvoice = value(data['data']['purchaseOfInvoice']);
  //   debitOnInvoicePurchased =
  //       value(data['data']['debitInvoicePurchase']);
  //   signInNotification = value(data['data']['signin']);
  //
  //   capsaPrint('\n\nResponse : $data');
  //
  //   setState(() {
  //     valuesSet = true;
  //   });
  // }
}
