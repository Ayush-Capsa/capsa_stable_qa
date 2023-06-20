import 'package:capsa/anchor/Profile/edit_payment_options.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/anchor/Profile/change_password.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/pages/email-preference/email_preferences_anchor_page.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Helpers/dialogHelper.dart';
import 'package:capsa/anchor/Profile/edit_admin.dart';
import 'package:capsa/anchor/Profile/edit_profile.dart';
import 'package:capsa/anchor/Profile/new_admin.dart';
import 'package:provider/provider.dart';

import 'delete_admin.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({Key key}) : super(key: key);

  @override
  _profileScreenState createState() => _profileScreenState();
}

class adminModel {
  String name;
  String title;
  adminModel(this.name, this.title);
}

class _profileScreenState extends State<profileScreen> {
  var userData;
  List<subAdmin> admins = [];
  List<Widget> subAdminCards = [];
  bool dataLoaded = false;

  refresh() {
    getData();
  }

  getData() async {
    capsaPrint('Refresh Function Called');
    admins = [];
    subAdminCards = [];

    userData = Map<String, dynamic>.from(box.get('userData'));
    capsaPrint('UserData $userData');
    var anchorsActions =
        Provider.of<AnchorActionProvider>(context, listen: false);
    admins = await anchorsActions.getAllAdmins();

    if (admins != null) {
      capsaPrint('cards length : $userData');
      for (int i = 0; i < admins.length; i++) {
        subAdminCards.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 254,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                color: Color.fromRGBO(245, 251, 255, 1),
                elevation: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/images/5982.png'),
                      ),
                    ),
                    Container(
                      width: 151,
                      height: 27,
                      child: Center(
                        child: Text(
                          admins[i].firstName + ' ' + admins[i].lastName,
                          style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Container(
                        width: 107,
                        height: 27,
                        child: Text(
                          'Sub-Admin',
                          style: TextStyle(
                              color: Color.fromRGBO(58, 192, 201, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    userData['isSubAdmin'] == '0'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 165,
                                height: 24,
                                child: TextButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   showDialog(
                                    //       context: context,
                                    //       builder: (context) {
                                    //         return editAdmin(admin: admins[i],func: getData,);
                                    //       });
                                    // });
                                    showDialog(
                                        // barrierColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          functionBack() {
                                            Navigator.pop(context);
                                          }

                                          return AlertDialog(
                                            // backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(32.0))),
                                            title: Text(
                                              'Edit Admin',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: 'Poppins',
                                                  fontSize: 28,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                            content: ChangeNotifierProvider(
                                                create:
                                                    (BuildContext context) =>
                                                        AnchorActionProvider(),
                                                child: EditAdminContainerView(
                                                  admin: admins[i],
                                                  func: getData,
                                                )),
                                          );
                                        });
                                  },
                                  child: Text(
                                    'Edit Privileges',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 152, 219, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: IconButton(
                                  onPressed: () {
                                    capsaPrint("Admins ${admins[i].firstName}");
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                              create: (BuildContext context) =>
                                                  AnchorActionProvider(),
                                              child: deleteAdmin(
                                                name: admins[i].firstName +
                                                    " " +
                                                    admins[i].lastName,
                                                id: admins[i].adminId,
                                                func: refresh,
                                              ),
                                            ));
                                  },
                                  icon: Icon(Icons.delete_outline),
                                  iconSize: 20,
                                  color: Color.fromRGBO(235, 85, 85, 1),
                                ),
                              )
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    setState(() {
      dataLoaded = true;
    });
  }

  bool showPaymentOptions = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 0.9,
      child: dataLoaded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(29, 48, 184, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.73,
                    height: 54,
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(184, 40, 241, 22),
                            child: Container(
                                width: 150,
                                height: 150,
                                child: Image.asset('assets/images/5982.png')),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(167.5, 0, 202.5, 4),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.16,
                              height: 36,
                              child: Text(
                                userData['isSubAdmin'].toString() == '0'
                                    ? userData['userName']
                                    : userData['sub_admin_details']
                                            ['firstName'] +
                                        ' ' +
                                        userData['sub_admin_details']
                                            ['lastName'],
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(218.5, 0, 253.5, 22),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.09,
                              height: 27,
                              child: Text(
                                userData['isSubAdmin'] == '0'
                                    ? 'Super Admin'
                                    : 'Sub Admin',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(58, 192, 201, 1)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(29, 0, 64, 16),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 115,
                              child: Card(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 316, 7),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.12,
                                        height: 43,
                                        child: Card(
                                          color:
                                              Color.fromRGBO(245, 251, 255, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              'Account Handler',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      0, 152, 219, 1)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 0, 310, 16),
                                      child: Text(
                                        userData['isSubAdmin'].toString() == '0'
                                            ? userData['name']
                                            : userData['sub_admin_details']
                                        ['firstName'] +
                                            ' ' +
                                            userData['sub_admin_details']
                                            ['lastName'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(29, 0, 64, 25),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 110,
                              child: Card(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 340, 8),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.12,
                                        height: 43,
                                        child: Card(
                                          color:
                                              Color.fromRGBO(245, 251, 255, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Email address',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      0, 152, 219, 1)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 171, 12),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        height: 27,
                                        child: Text(
                                          userData['email'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromRGBO(
                                                  51, 51, 51, 1)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(29, 0, 462, 24),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              height: 36,
                              child: Text(
                                'Settings',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(29, 0, 64, 55),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 260,
                              child: Card(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 16, 16, 20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.34,
                                        height: 59,
                                        child: Card(
                                          color:
                                              Color.fromRGBO(245, 251, 255, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeNotifierProvider(
                                                          create: (BuildContext
                                                                  context) =>
                                                              AnchorActionProvider(),
                                                          child:
                                                              EditProfilePage(
                                                            func: getData,
                                                            userData: userData,
                                                          )),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 8, 340, 8),
                                              child: Text(
                                                'Edit Profile',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        51, 51, 51, 1)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeNotifierProvider(
                                                    create: (BuildContext
                                                            context) =>
                                                        AnchorActionProvider(),
                                                    child: ChangePasswordPage(
                                                      func: getData,
                                                      userData: userData,
                                                    )),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.34,
                                          height: 59,
                                          child: Card(
                                            color: Color.fromRGBO(
                                                245, 251, 255, 1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 8, 260, 8),
                                              child: Text(
                                                'Change Password',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        51, 51, 51, 1)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // InkWell(
                                    //   onTap: () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ChangeNotifierProvider(
                                    //                 create: (BuildContext
                                    //                 context) =>
                                    //                     AnchorActionProvider(),
                                    //                 child: EditPaymentSettings()),
                                    //       ),
                                    //     );
                                    //   },
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.fromLTRB(
                                    //         16, 0, 16, 16),
                                    //     child: Container(
                                    //       width: MediaQuery.of(context)
                                    //           .size
                                    //           .width *
                                    //           0.34,
                                    //       height: 59,
                                    //       child: Card(
                                    //         color: Color.fromRGBO(
                                    //             245, 251, 255, 1),
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius.all(
                                    //                 Radius.circular(15))),
                                    //         child: Padding(
                                    //           padding:
                                    //           const EdgeInsets.fromLTRB(
                                    //               16, 8, 260, 8),
                                    //           child: Text(
                                    //             'Edit Payment Settings',
                                    //             style: TextStyle(
                                    //                 fontSize: 18,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: Color.fromRGBO(
                                    //                     51, 51, 51, 1)),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       16, 0, 16, 16),
                                    //   child: InkWell(
                                    //     onTap: () {
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               ChangeNotifierProvider(
                                    //                   create: (BuildContext
                                    //                   context) =>
                                    //                       ProfileProvider(),
                                    //                   child: EmailPreferenceAnchorPage()),
                                    //         ),
                                    //       );
                                    //     },
                                    //     child: Container(
                                    //       width: MediaQuery.of(context)
                                    //           .size
                                    //           .width *
                                    //           0.34,
                                    //       height: 59,
                                    //       child: Card(
                                    //         color: Color.fromRGBO(
                                    //             245, 251, 255, 1),
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius.all(
                                    //                 Radius.circular(15))),
                                    //         child: Padding(
                                    //           padding:
                                    //           const EdgeInsets.fromLTRB(
                                    //               16, 8, 260, 8),
                                    //           child: Text(
                                    //             'Email Preference',
                                    //             style: TextStyle(
                                    //                 fontSize: 18,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: Color.fromRGBO(
                                    //                     51, 51, 51, 1)),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.fromLTRB(0, 42, 36, 28),
                          child: Card(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: userData['isSubAdmin'] == '0'
                                ? Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            16, 32.5, 6, 32.5),
                                        child: Text(
                                          'Total number of admins:',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  51, 51, 51, 1)),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 28, 148, 28),
                                        child: Text(
                                          admins == null
                                              ? '0'
                                              : admins.length.toString(),
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  0, 152, 219, 1)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 16.5, 16, 16.5),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                // showDialog(
                                                //     context: context,
                                                //     builder: (context) {
                                                //       return ChangeNotifierProvider(
                                                //           create: (BuildContext
                                                //                   context) =>
                                                //               AnchorActionProvider(),
                                                //           child: addNewAdmin(
                                                //             func: getData,
                                                //           ));
                                                //     });
                                                showDialog(
                                                    // barrierColor: Colors.transparent,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      functionBack() {
                                                        Navigator.pop(context);
                                                      }

                                                      return AlertDialog(
                                                        // backgroundColor: Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0))),
                                                        title: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15),
                                                          child: Text(
                                                            'Add Admin',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 28,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height: 1),
                                                          ),
                                                        ),
                                                        content:
                                                            ChangeNotifierProvider(
                                                                create: (BuildContext
                                                                        context) =>
                                                                    AnchorActionProvider(),
                                                                child:
                                                                    AddAdminContainerView(
                                                                  func: getData,
                                                                )),
                                                      );
                                                    });
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                                fixedSize: Size(200, 59),
                                                backgroundColor: Color.fromRGBO(
                                                    0, 152, 219, 1)),
                                            child: Text(
                                              'Add New Admin',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Color.fromRGBO(
                                                      242, 242, 242, 1)),
                                            )),
                                      )
                                    ],
                                  )
                                : Center(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          16, 32.5, 6, 32.5),
                                      child: Text(
                                        admins == null
                                            ? 'Total number of admins: 0'
                                            : 'Total number of admins: ${admins.length}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1)),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        admins != null
                            ? Container(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                padding: EdgeInsets.only(right: 20, bottom: 20),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: subAdminCards,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    )
                  ],
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
