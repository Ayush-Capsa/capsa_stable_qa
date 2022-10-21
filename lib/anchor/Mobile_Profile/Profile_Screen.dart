import 'package:capsa/anchor/Mobile_Profile/Admin_Settings.dart';
import 'package:capsa/anchor/Mobile_Profile/edit_profile.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/logout.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({Key key}) : super(key: key);

  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {

  var userData;
  bool dataLoaded = false;

  Future<void> getData() async {
    userData = Map<String, dynamic>.from(box.get('userData'));
    setState(() {
      dataLoaded = true;
    });
  }


  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height*0.08
          ),
          child: AppBar(
            backgroundColor: Color.fromRGBO(245, 251, 255, 1),
            flexibleSpace: Title(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 0, 0),
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              color: Color.fromRGBO(245, 251, 255, 1),
            ),
          ),
        ),
        body: dataLoaded?SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16, left: MediaQuery.of(context).size.width*0.5-MediaQuery.of(context).size.width*0.115),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.23,
                  height: MediaQuery.of(context).size.height*0.08,
                  child: Image.asset(
                    'assets/images/5982.png'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.3),
                child: Text(
                  userData['userName'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.37),
                child: Text(
                  'Super Admin',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color.fromRGBO(58, 192, 201, 1)
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.12,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    color: Color.fromRGBO(255, 255, 255, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.38,
                            height: MediaQuery.of(context).size.height*0.04,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              color: Color.fromRGBO(245, 251, 255, 1),
                              child: Padding(
                                padding: EdgeInsets.only(left: 16, top: 4),
                                child: Text(
                                  'Account Handler',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(0, 152, 219, 1)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 0, 8),
                          child: Text(
                            userData['name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(51, 51, 51, 1)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.12,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    color: Color.fromRGBO(255, 255, 255, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.38,
                            height: MediaQuery.of(context).size.height*0.04,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              color: Color.fromRGBO(245, 251, 255, 1),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 4, 0, 0),
                                child: Text(
                                  'Email Address',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(0, 152, 219, 1)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 0, 8),
                          child: Text(
                            userData['email'],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(51, 51, 51, 1)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: MediaQuery.of(context).size.height*0.35,
                  width: MediaQuery.of(context).size.width*0.92,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    color: Color.fromRGBO(255, 255, 255, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.87,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: Card(
                              color: Color.fromRGBO(245, 251, 255, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                                        create: (BuildContext context) => AnchorActionProvider(),
                                        child: editProfile()),
                                    ));
                                  },
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(51, 51, 51, 1)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.87,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: Card(
                              color: Color.fromRGBO(245, 251, 255, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                                      create: (BuildContext context) => AnchorActionProvider(),
                                      child: adminSettings()),
                                    ));
                                  },
                                  child: Text(
                                    'Admin Settings',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(51, 51, 51, 1)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.87,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: Card(
                              color: Color.fromRGBO(245, 251, 255, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){},
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(51, 51, 51, 1)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.87,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: Card(
                              color: Color.fromRGBO(245, 251, 255, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){logout(context);},
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(235, 87, 87, 1)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ):Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
