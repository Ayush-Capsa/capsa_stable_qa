import 'package:capsa/anchor/pages/homepage.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/home_page.dart';
import 'package:capsa/main.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';

import 'new_admin.dart';

// class EditProfileContainerView extends StatefulWidget {
//   dynamic userData;
//   Function func;
//   EditProfileContainerView(
//       {Key key, @required this.func, @required this.userData})
//       : super(key: key);
//
//   @override
//   State<EditProfileContainerView> createState() =>
//       _EditProfileContainerViewState();
// }
//
// class _EditProfileContainerViewState extends State<EditProfileContainerView> {
//   AcctTableData invoice;
//   AnchorActionProvider _invoiceProvider;
//
//   var urlDownload = "";
//
//   DateTime date;
//   TextEditingController _nameInput;
//   TextEditingController _emailInput;
//   TextEditingController _panNumberInput;
//
//   bool privillege1 = false;
//   bool privillege2 = false;
//
//   void updateProfile(BuildContext context) {
//     var _action = Provider.of<AnchorActionProvider>(context, listen: false);
//     var body = {};
//     body['name'] = _nameInput.text;
//
//     _action.updateSuperAdmin(body);
//     Navigator.pop(context);
//   }
//
//   bool intToBool(int n) {
//     return n == 0 ? false : true;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _emailInput = TextEditingController(text: widget.userData['email']);
//     _nameInput = TextEditingController(text: widget.userData['name']);
//     _panNumberInput = TextEditingController(text: widget.userData['panNumber']);
//   }
//
//   @override
//   void dispose() {
//     _emailInput.dispose();
//     _nameInput.dispose();
//     _panNumberInput.dispose();
//     super.dispose();
//   }
//
//   var _loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(32))),
//       width: MediaQuery.of(context).size.width * 0.6,
//       // height: MediaQuery.of(context).size.height * 0.8 ,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 1,
//               child: Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       child: UserTextFormField(
//                         label: "Name",
//                         action: 'Edit',
//                         keyboardType: TextInputType.name,
//                         controller: _nameInput,
//                         hintText: "Enter First Name Here",
//                         padding: EdgeInsets.zero,
//                         fillColor: Color.fromRGBO(238, 248, 255, 1.0),
//                         errorText: ' ',
//                         //errorText: "Amount you are going to pay the vendor. If this is not correct, please change.",
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Container(
//                       child: UserTextFormField(
//                         label: "Email",
//                         readOnly: true,
//                         keyboardType: TextInputType.name,
//                         controller: _emailInput,
//                         //hintText: "Enter Last Name Here",
//                         padding: EdgeInsets.zero,
//                         fillColor: Color.fromRGBO(238, 248, 255, 1.0),
//                         //errorText: "Amount you are going to pay the vendor. If this is not correct, please change.",
//                       ),
//                     ),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     Container(
//                       child: UserTextFormField(
//                         label: "Pan Number",
//                         readOnly: true,
//                         controller: _panNumberInput,
//                         //hintText: 'name@example.com',
//                         padding: EdgeInsets.zero,
//                         fillColor: Color.fromRGBO(238, 248, 255, 1.0),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     if (!_loading)
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Color.fromRGBO(255, 255, 255, 1),
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () async {
//                                   updateProfile(context);
//                                   widget.func();
//                                   //Navigator.pop(context);
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(15),
//                                       topRight: Radius.circular(15),
//                                       bottomLeft: Radius.circular(15),
//                                       bottomRight: Radius.circular(15),
//                                     ),
//                                     color: Color.fromRGBO(0, 152, 219, 1),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 16),
//                                   child: Text(
//                                     'Save Changes',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         color: Color.fromRGBO(242, 242, 242, 1),
//                                         fontSize: 18,
//                                         letterSpacing:
//                                             0 /*percentages not used in flutter. defaulting to zero*/,
//                                         fontWeight: FontWeight.normal,
//                                         height: 1),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 25,
//                             ),
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () async {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(15),
//                                       topRight: Radius.circular(15),
//                                       bottomLeft: Radius.circular(15),
//                                       bottomRight: Radius.circular(15),
//                                     ),
//                                     color: Color.fromRGBO(235, 87, 87, 1),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 16),
//                                   child: Text(
//                                     'Cancel',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         color: Color.fromRGBO(242, 242, 242, 1),
//                                         fontSize: 18,
//                                         letterSpacing:
//                                             0 /*percentages not used in flutter. defaulting to zero*/,
//                                         fontWeight: FontWeight.normal,
//                                         height: 1),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     else
//                       Center(child: CircularProgressIndicator()),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class EditProfile extends StatefulWidget {
//   dynamic userData;
//   Function func;
//   EditProfile({Key key, @required this.userData, @required this.func})
//       : super(key: key);
//
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   AcctTableData invoice;
//   AnchorActionProvider _invoiceProvider;
//
//   var urlDownload = "";
//
//   DateTime date;
//   TextEditingController _nameInput;
//   TextEditingController _emailInput;
//   TextEditingController _panNumberInput;
//
//   bool privillege1 = false;
//   bool privillege2 = false;
//
//   void updateProfile(BuildContext context) {
//     var _action = Provider.of<AnchorActionProvider>(context, listen: false);
//     var body = {};
//     body['name'] = _nameInput.text;
//
//     _action.updateSuperAdmin(body);
//     Navigator.pop(context);
//   }
//
//   bool intToBool(int n) {
//     return n == 0 ? false : true;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _emailInput = TextEditingController(text: widget.userData['email']);
//     _nameInput = TextEditingController(text: widget.userData['name']);
//     _panNumberInput = TextEditingController(text: widget.userData['panNumber']);
//   }
//
//   @override
//   void dispose() {
//     _emailInput.dispose();
//     _nameInput.dispose();
//     _panNumberInput.dispose();
//     super.dispose();
//   }
//
//   var _loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//
//           //Center(child: Text('Center'),)
//
//           Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.all(0),
//             width: MediaQuery.of(context).size.width*0.12,
//             height: double.infinity,
//             color: Colors.black,
//             child: FittedBox(
//               child: Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     bottomRight: Radius.circular(15)
//                 )),
//                 color: Colors.black,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(50.5, 36, 50.5, 24),
//                       child: SizedBox(
//                         width: 80,
//                         height: 45.42,
//                         child: Image.asset(
//                           'assets/images/logo.png',
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width*0.88,
//             height: double.infinity,
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.all(4.0),
//           //   child: Row(
//           //     mainAxisAlignment: MainAxisAlignment.start,
//           //     crossAxisAlignment: CrossAxisAlignment.start,
//           //     children: [
//           //       Expanded(
//           //         flex: 1,
//           //         child: Container(
//           //
//           //           child: Column(
//           //             mainAxisAlignment: MainAxisAlignment.start,
//           //             crossAxisAlignment: CrossAxisAlignment.start,
//           //             children: [
//           //
//           //               Container(
//           //                 child: UserTextFormField(
//           //                   label: "Name",
//           //                   action: 'Edit',
//           //                   keyboardType: TextInputType.name,
//           //                   controller: _nameInput,
//           //                   hintText: "Enter First Name Here",
//           //                   padding: EdgeInsets.zero,
//           //                   fillColor: Color.fromRGBO(238, 248, 255, 1.0),
//           //                   errorText: ' ',
//           //                   //errorText: "Amount you are going to pay the vendor. If this is not correct, please change.",
//           //                 ),
//           //               ),
//           //
//           //               SizedBox(
//           //                 height: 30,
//           //               ),
//           //
//           //               Container(
//           //                 child: UserTextFormField(
//           //                   label: "Email",
//           //                   readOnly: true,
//           //                   keyboardType: TextInputType.name,
//           //                   controller: _emailInput,
//           //                   //hintText: "Enter Last Name Here",
//           //                   padding: EdgeInsets.zero,
//           //                   fillColor: Color.fromRGBO(238, 248, 255, 1.0),
//           //                   //errorText: "Amount you are going to pay the vendor. If this is not correct, please change.",
//           //                 ),
//           //               ),
//           //
//           //               SizedBox(
//           //                 height: 40,
//           //               ),
//           //
//           //               Container(
//           //
//           //                 child: UserTextFormField(
//           //                   label: "Pan Number",
//           //                   readOnly: true,
//           //                   controller: _panNumberInput,
//           //                   //hintText: 'name@example.com',
//           //                   padding: EdgeInsets.zero,
//           //                   fillColor: Color.fromRGBO(238, 248, 255, 1.0),
//           //                 ),
//           //               ),
//           //
//           //               SizedBox(
//           //                 height: 50,
//           //               ),
//           //
//           //               if(!_loading)
//           //                 Container(
//           //                   decoration: BoxDecoration(
//           //                     color: Color.fromRGBO(255, 255, 255, 1),
//           //                   ),
//           //
//           //                   child: Row(
//           //                     children: <Widget>[
//           //                       Expanded(
//           //                         child: InkWell(
//           //                           onTap: () async{
//           //                             updateProfile(context);
//           //                             widget.func();
//           //                             //Navigator.pop(context);
//           //                           },
//           //                           child: Container(
//           //                             decoration: BoxDecoration(
//           //                               borderRadius: BorderRadius.only(
//           //                                 topLeft: Radius.circular(15),
//           //                                 topRight: Radius.circular(15),
//           //                                 bottomLeft: Radius.circular(15),
//           //                                 bottomRight: Radius.circular(15),
//           //                               ),
//           //                               color: Color.fromRGBO(0, 152, 219, 1),
//           //                             ),
//           //                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           //                             child: Text('Save Changes', textAlign: TextAlign.center, style: TextStyle(
//           //                                 color: Color.fromRGBO(242, 242, 242, 1),
//           //
//           //                                 fontSize: 18,
//           //                                 letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
//           //                                 fontWeight: FontWeight.normal,
//           //                                 height: 1
//           //                             ),),
//           //                           ),
//           //                         ),
//           //                       ), SizedBox(
//           //                         width: 25,
//           //                       ),
//           //                       Expanded(
//           //                         child: InkWell(
//           //                           onTap: () async {
//           //                             Navigator.pop(context);
//           //                           },
//           //                           child: Container(
//           //                             decoration: BoxDecoration(
//           //                               borderRadius: BorderRadius.only(
//           //                                 topLeft: Radius.circular(15),
//           //                                 topRight: Radius.circular(15),
//           //                                 bottomLeft: Radius.circular(15),
//           //                                 bottomRight: Radius.circular(15),
//           //                               ),
//           //                               color: Color.fromRGBO(235, 87, 87, 1),
//           //                             ),
//           //                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           //                             child: Text('Cancel', textAlign: TextAlign.center, style: TextStyle(
//           //                                 color: Color.fromRGBO(242, 242, 242, 1),
//           //                                 fontSize: 18,
//           //                                 letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
//           //                                 fontWeight: FontWeight.normal,
//           //                                 height: 1
//           //                             ),),
//           //                           ),
//           //                         ),
//           //                       ),
//           //
//           //
//           //                     ],
//           //                   ),
//           //                 )
//           //               else
//           //                 Center(child: CircularProgressIndicator()),
//           //             ],
//           //           ),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
class EditProfilePage extends StatefulWidget {
  dynamic userData;
  Function func;
  EditProfilePage({Key key,@required this.userData, @required this.func}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController numberController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  TextEditingController cityController = TextEditingController(text: '');
  TextEditingController stateController = TextEditingController(text: '');
  TextEditingController designationController = TextEditingController(text: 'Vendor');
  String _state = '';
  final _formKey = GlobalKey<FormState>();

  String _city = '';

  String _address = '';
  String _name = '';
  String _designation = "";

  void updateProfile(BuildContext context) {
    var _action = Provider.of<AnchorActionProvider>(context, listen: false);
    var body = {};
    body['name'] = nameController.text;

    if(widget.userData['isSubAdmin'] == '1'){
      _action.updateAdmin(body, widget.userData['sub_admin_details']['sub_admin_id']);
    }else {
      _action.updateSuperAdmin(body);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CapsaApp()
      ),
    );
  }

  void initialise(){
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email']);
    numberController = TextEditingController(text: widget.userData['contact']);
    designationController = TextEditingController(text: widget.userData['role']);
    capsaPrint('UserData update : ${widget.userData}');

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final Box box = Hive.box('capsaBox');

    // _designation = "Vendor";
    // var userData = Map<String, dynamic>.from(box.get('userData'));
    // String _role = userData['role'];
    //
    // if (_role == "INVESTOR") _designation = "Investor";
    // designationController.text = _designation;
    initialise();
  }

  bool saving = false;

  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    if (!saving) {
      // nameController.text = userDetails.nm;
      // emailController.text = userDetails.email;
      // numberController.text = userDetails.contact;
      // addressController.text = userDetails.ADD_LINE;
      // cityController.text = userDetails.CITY;
      // stateController.text = userDetails.STATE;
      //
      // _address = userDetails.ADD_LINE;
      // _state = userDetails.STATE;
      // _city = userDetails.CITY;
      // _name = userDetails.nm;



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
            width: MediaQuery.of(context).size.width*0.12,
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
                      //     builder: (context) => CapsaApp()
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

          //Expanded(child: Container(),)

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,


                padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 22,
                      ),
                      TopBarWidget("Edit Profile", "*If you would like to change your number or email address. Please contact support@getcapsa.com"),
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
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/Ellipse 3.png"),
                                  height: 70,
                                  width: 70,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            OrientationSwitcher(
                              children: [
                                Flexible(
                                  child: UserTextFormField(
                                    label: "Name",
                                    hintText: "Name",
                                    controller: nameController,
                                    readOnly: widget.userData['isSubAdmin'] == '1'?false:true,
                                    onChanged: (v) {
                                      _name = v;
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: UserTextFormField(
                                    label: "Designation",
                                    hintText: "Designation",
                                    readOnly: true,
                                    controller: designationController,
                                  ),
                                )
                              ],
                            ),
                            OrientationSwitcher(
                              children: [
                                Flexible(
                                  child: UserTextFormField(
                                    label: "Email",
                                    hintText: "Email",
                                    readOnly: true,
                                    controller: emailController,
                                  ),
                                ),
                                Flexible(
                                  child: UserTextFormField(
                                    label: "Phone number",
                                    hintText: "Phone number",
                                    readOnly: true,
                                    controller: numberController,
                                  ),
                                )
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
                              widget.userData['isSubAdmin'] == '1'?InkWell(
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      saving = true;
                                    });
                                   updateProfile(context);
                                   Navigator.pop(context);

                                    //dynamic response = await profileProvider.updateData(_body);

                                    // if (response['res'] == 'success') {
                                    //   UserData _user = UserData(
                                    //     _address,
                                    //     _city,
                                    //     userDetails.COUNTRY,
                                    //     _state,
                                    //     userDetails.cc,
                                    //     userDetails.contact,
                                    //     userDetails.email,
                                    //     _name,
                                    //   );
                                    //   // profileProvider.addUser(_user);
                                    //   await profileProvider.queryProfile();
                                    //   await profileProvider.queryFewData();
                                    //
                                    //   // setState(() {
                                    //   //   saving = false;
                                    //   // });
                                    //   context.beamToNamed('/profile');
                                    //   showToast('Profile details successfully updated', context);
                                    //   // context.beamBack();
                                    // } else {
                                    //   showToast('Something Wrong! Unable to update. Try again later', context, type: 'error');
                                    //   setState(() {
                                    //     saving = false;
                                    //   });
                                    // }
                                  }
                                },
                                child: Container(
                                    width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.8 : 200,
                                    height: 59,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight: Radius.circular(15),
                                              ),
                                              color: Color.fromRGBO(0, 152, 219, 1),
                                            ),
                                            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.8 : 200,
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    'Save',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(242, 242, 242, 1),
                                                        fontFamily: 'Poppins',
                                                        fontSize: 18,
                                                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                        fontWeight: FontWeight.normal,
                                                        height: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ])),
                              ):Container(),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
