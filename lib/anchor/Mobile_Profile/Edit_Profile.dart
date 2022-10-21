import 'package:capsa/anchor/mobile_home_page.dart';
import 'package:capsa/anchor/Mobile_Profile/profile_screen.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class editProfile extends StatefulWidget {
  editProfile({Key key,}) : super(key: key);

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();



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
            'Edit Profile',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height*0.93,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5-MediaQuery.of(context).size.width*0.08),
              child: Container(
                width: MediaQuery.of(context).size.width*0.167,
                height: MediaQuery.of(context).size.height*0.094,
                child: Image.asset(
                  'assets/images/5982.png'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.25),
              child: RichText(
                text: TextSpan(
                  text: 'Change profile picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 152, 219, 1)
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {

                    }
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                'First Name',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(51, 51, 51, 1)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.07,
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _firstName,
                        decoration: InputDecoration(
                            hintText: 'Enter first name here',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(130, 130, 130, 1)
                            )
                        ),
                      )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                'Last Name',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(51, 51, 51, 1)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.07,
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _lastName,
                        decoration: InputDecoration(
                            hintText: 'Enter last name here',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(130, 130, 130, 1)
                            )
                        ),
                      )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                'Email',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(51, 51, 51, 1)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.07,
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(

                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                            hintText: 'name@example.com',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(130, 130, 130, 1)
                            )
                        ),
                      )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: ElevatedButton(
                  onPressed: (){},
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 152, 219, 1),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width*0.92,
                      MediaQuery.of(context).size.height*0.083
                    )
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}