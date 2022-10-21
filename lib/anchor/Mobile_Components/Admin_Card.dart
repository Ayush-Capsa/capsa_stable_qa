import 'package:capsa/anchor/Mobile_Profile/Edit_Privileges.dart';
import 'package:capsa/anchor/Mobile_Profile/delete_admin_mobile.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

Widget adminCard({
  @required subAdmin admin,
  @required BuildContext context
}) {
  return Container(
    padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
    width: MediaQuery.of(context).size.width*0.95,
    height: MediaQuery.of(context).size.height*0.16,
    child: Card(
      elevation: 5,
      color: Color.fromRGBO(245, 251, 255, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16, left: 8),
            child: Container(
              width: 40,
              height: 40,
              child: Image.asset(
                'assets/images/5982.png'
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  admin.firstName + " " + admin.lastName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Text(
                'Sub-Admin',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(58, 192, 201, 1)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 22),
                child: RichText(
                  text: TextSpan(
                    text: 'Edit Privileges',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(0, 152, 219, 1)
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => editPrivileges(admin: admin,)));
                      }
                  ),
                ),
              )
            ],
          ),
          Spacer(),
          InkWell(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context) => ChangeNotifierProvider(
                    create: (BuildContext context) =>
                        AnchorActionProvider(),
                    child: deleteAdminMobile(
                      admin: admin,
                    ),
                  ));
            },
            child: Icon(
              Icons.delete,
              color: Color.fromRGBO(235, 87, 87, 1),
            ),
          )
        ],
      ),
    ),
  );
}