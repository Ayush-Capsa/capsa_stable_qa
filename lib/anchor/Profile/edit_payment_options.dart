import 'package:capsa/anchor/pages/homepage.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/pages/home_page.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';

import '../../functions/call_api.dart';
import 'new_admin.dart';

class EditPaymentSettings extends StatefulWidget {
  dynamic userData;
  Function func;
  EditPaymentSettings({Key key, @required this.userData, @required this.func})
      : super(key: key);

  @override
  State<EditPaymentSettings> createState() => _EditPaymentSettingsState();
}

class _EditPaymentSettingsState extends State<EditPaymentSettings> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');

  bool earlyPaymentOption = false;

  bool saving = false;

  bool loaded = false;

  final oldController = TextEditingController();
  final newController = TextEditingController();
  final conController = TextEditingController();

  final emailController = TextEditingController();

  List<String> vendorsList = [];
  Map<String, String> vendorPan = {};

  dynamic selectedList;
  List<String> dropList = ['option 1', 'option 2'];

  void getData() async {
    var userData = Map<String, dynamic>.from(box.get('userData'));
    dynamic _body = {'anchorPAN': userData['panNumber']};
    dynamic response = await callApi('dashboard/a/vendorList', body: _body);

    if (response['msg'] == 'success') {
      dynamic responseList = response['vendorList'];
      responseList.forEach((element) {
        vendorsList.add(element['NAME']);
        vendorPan[element['NAME']] = element['PAN_NO'];
      });
    }

    setState(() {
      loaded = true;
    });

    //capsaPrint('vendor list : \n $response');
  }

  Future<void> updateSettings() async{
    var _action = Provider.of<AnchorActionProvider>(context, listen: false);
    dynamic response = await _action.updateEarlyPaymentSettings(selectedList, vendorsList, vendorPan, '2.2');
    capsaPrint('response : $response');

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChangeNotifierProvider(
    //         create: (BuildContext context) => AnchorActionProvider(),
    //         child: AnchorHomePage()),
    //   ),
    // );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  String _oldPassword = "";
  String _newPassword = "";
  String _conPassword = "";

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            //width: 185,
            margin: EdgeInsets.all(0),
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.12,
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
                ? SingleChildScrollView(
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(
                          Responsive.isMobile(context) ? 15 : 25.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 22,
                            ),
                            TopBarWidget("Edit Payment Options", ""),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'Enable early payment Option for Vendors'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Switch(
                                      // thumb color (round icon)
                                      activeColor: Colors.amber,
                                      activeTrackColor: Colors.cyan,
                                      inactiveThumbColor:
                                          Colors.blueGrey.shade600,
                                      inactiveTrackColor: Colors.grey.shade400,
                                      splashRadius: 50.0,
                                      // boolean variable value
                                      value: earlyPaymentOption,
                                      // changes the state of the switch
                                      onChanged: (value) => setState(
                                          () => earlyPaymentOption = value),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width: Responsive.isMobile(context)
                                      ? MediaQuery.of(context).size.width * 0.7
                                      : 400,
                                  //height: 80,
                                  child: GFMultiSelect(
                                    items: vendorsList,
                                    onSelect: (value) {
                                      setState(() {
                                        selectedList = value;
                                      });
                                    },
                                    dropdownTitleTileText: 'Select Vendors ',
                                    dropdownTitleTileColor: Colors.grey[200],
                                    dropdownTitleTileMargin: EdgeInsets.only(
                                        top: 22,
                                        left: 18,
                                        right: 18,
                                        bottom: 5),
                                    dropdownTitleTilePadding:
                                        EdgeInsets.all(10),
                                    dropdownUnderlineBorder: const BorderSide(
                                        color: Colors.transparent, width: 2),
                                    dropdownTitleTileBorder: Border.all(
                                        color: Colors.grey[300], width: 1),
                                    dropdownTitleTileBorderRadius:
                                        BorderRadius.circular(5),
                                    expandedIcon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black54,
                                    ),
                                    collapsedIcon: const Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.black54,
                                    ),
                                    submitButton: Text('OK'),
                                    dropdownTitleTileTextStyle: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                    //padding: const EdgeInsets.all(6),
                                    //margin: const EdgeInsets.all(6),
                                    //type: GFCheckboxType.basic,
                                    activeBgColor:
                                        Colors.green.withOpacity(0.5),
                                    inactiveBorderColor: Colors.grey[200],
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width: 340,
                                  height: 120,
                                  child: UserTextFormField(
                                    label: "Enter Email",
                                    hintText: "email",
                                    controller: emailController,
                                    readOnly: false,
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width: 340,
                                  height: 120,
                                  child: UserTextFormField(
                                    label: "Enter percentage of discount",
                                    hintText: "Percentage",
                                    controller: emailController,
                                    readOnly: false,
                                  ),
                                ),

                                SizedBox(
                                  height: 12,
                                ),

                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      saving = true;
                                    });
                                    await updateSettings();
                                    setState(() {
                                      saving = false;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: HexColor('#0098DB'),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Update',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }

  inputSection(
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: UserTextFormField(
                label: "Old Password",
                hintText: "Old Password",
                controller: oldController,
                obscureText: true,
                onChanged: (v) {
                  _oldPassword = v;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: UserTextFormField(
                label: "New Password",
                hintText: "New Password",
                onChanged: (v) {
                  _newPassword = v.trim();
                  setState(() {});
                },
                controller: newController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (!validateStructure(value)) {
                    return 'Your password must be more than 8 characters long, should contain at least\n1 Uppercase, 1 Lowercase, 1 Numeric, 1 special character.';
                  }
                  if (value.length < 8) {
                    return 'Password length needs to be at least 8 characters long';
                  }
                  return null;
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: UserTextFormField(
                label: "Confirm New Password",
                hintText: "Confirm New Password",
                controller: conController,
                obscureText: true,
                onChanged: (v) {
                  _conPassword = v;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != newController.text) {
                    return 'Password does not match';
                  }
                  if (value.isEmpty) {
                    return 'Password cannot be empty';
                  }

                  if (!validateStructure(value)) {
                    return 'Your password must be more than 8 characters long, should contain at least\n1 Uppercase, 1 Lowercase, 1 Numeric, 1 special character.';
                  }

                  if (value.length < 8) {
                    return 'Password length needs to be at least 8 characters long';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        if (saving)
          Center(
            child: CircularProgressIndicator(),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                setState(() {
                  saving = true;
                });
                await updateSettings();
                setState(() {
                  saving = false;
                });
              },
              child: Container(
                  width: 200,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
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
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ],
                          ),
                        )),
                  ])),
            ),
          ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
