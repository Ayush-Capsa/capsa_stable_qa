import 'dart:async';

import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class deleteAdmin extends StatelessWidget {
  String name;
  String id;
  Function func;

  deleteAdmin({Key key,@required this.name,@required this.id,@required this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    capsaPrint('firstName; $name $id');
    return Dialog(
      backgroundColor: Color.fromRGBO(245, 251, 255, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      elevation: 5,
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*0.35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(24, 48, 24, 4),
              child: RichText(
                text: TextSpan(
                    text: 'You are about to remove ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins'),
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromRGBO(0, 152, 219, 1), fontFamily: 'Poppins'),
                      ),
                      TextSpan(
                        text: ' as',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins'),
                      )
                    ]
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 30),
              child: RichText(
                  text: TextSpan(
                      text: 'a ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins'),
                      children: [
                        TextSpan(
                          text: 'Sub-Admin ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromRGBO(0, 152, 219, 1), fontFamily: 'Poppins'),
                        ),
                        TextSpan(
                          text: 'of this account.',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins'),
                        ),
                      ]
                  )
              ),
            ),
            Container(
                child: Text(
                    'Do you wish to continue?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1))
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(39, 44, 35, 48),
              child: Row(
                children: [
                  ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      ElevatedButton(
                          onPressed: () async{
                            var anchorsActions = Provider.of<AnchorActionProvider>(context,listen: false);
                            await anchorsActions.removeAdmin(id);
                            //Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CapsaApp()
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            primary: Color.fromRGBO(242, 242, 242, 1),
                            backgroundColor: Color.fromRGBO(235, 87, 87, 1),
                            fixedSize: Size(200, 59),
                          ),
                          child: Text(
                            'Remove',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                      ),
                      ElevatedButton(
                          onPressed: (){Navigator.pop(context);},
                          style: ElevatedButton.styleFrom(
                            onPrimary: Color.fromRGBO(130, 130, 130, 1),
                            primary: Color.fromRGBO(245, 251, 255, 1),
                            fixedSize: Size(200, 59),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
