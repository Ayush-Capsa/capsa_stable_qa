import 'package:capsa/anchor/Mobile_Profile/profile_screen.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class changePassword extends StatelessWidget {
  const changePassword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool value1 = false;
    bool value2 = false;
    bool value3 = false;
    bool value4 = false;
    bool value5 = false;

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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => profileScreen()));
            },
          ),
          title: Text(
            'Change Password',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*0.93,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Old Password',
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
                      child: Text(
                        'Welcome@123',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'New Password',
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
                      child: Text(
                        'Welcome@12345',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Confirm New Password',
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
                      child: Text(
                        'Welcome@12345',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
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
      ),
    );
  }
}