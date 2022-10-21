import 'package:capsa/anchor/Mobile_Components/Admin_Card.dart';
import 'package:capsa/anchor/mobile_home_page.dart';
import 'package:capsa/anchor/Mobile_Profile/New_Admin.dart';
import 'package:capsa/anchor/Mobile_Profile/profile_screen.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/constants.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class adminSettings extends StatefulWidget {
  const adminSettings({Key key}) : super(key: key);

  @override
  _adminSettingsState createState() => _adminSettingsState();
}

class _adminSettingsState extends State<adminSettings> {

  var userData;
  List<subAdmin> admins = [];
  List<Widget> subAdminCards = [];
  bool dataLoaded = false;

  Future<void> getData() async {

    admins = [];
    subAdminCards = [];

    userData = Map<String, dynamic>.from(box.get('userData'));
    var anchorsActions =
    Provider.of<AnchorActionProvider>(context, listen: false);
    admins = await anchorsActions.getAllAdmins();
    if(admins!=null) {
      subAdminCards.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: MediaQuery.of(context).size.height * 0.09,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              color: Color.fromRGBO(245, 251, 255, 1),
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'Total number of Admins:',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      admins.length.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(0, 152, 219, 1)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

    for (int i = 0; i < admins.length; i++) {
      subAdminCards.add(
        adminCard(admin: admins[i], context: context),
      );
    }}
    else{
      subAdminCards.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: MediaQuery.of(context).size.height * 0.09,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              color: Color.fromRGBO(245, 251, 255, 1),
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'Total number of Admins:',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      '0',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(0, 152, 219, 1)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height*0.08
        ),
        child: AppBar(
          backgroundColor: Color.fromRGBO(245, 251, 255, 1),
          leading: IconButton(
            color: Color.fromRGBO(0, 152, 219, 1),
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => mobileHomePage()));
            },
          ),
          title: Text(
            'Admin Settings',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
      ),
      body: dataLoaded?SingleChildScrollView(
        child: Column(
          children: subAdminCards
        ),
      ):Center(child: CircularProgressIndicator(),),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.09,
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonBar(
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ChangeNotifierProvider(
                      create: (BuildContext context) => AnchorActionProvider(),
                      child: addAdmin())));
                },
                child: Text(
                  'Add New Admin',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(0, 152, 219, 1),
                  fixedSize: Size(
                    MediaQuery.of(context).size.width*0.93,
                    MediaQuery.of(context).size.height*0.06
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
