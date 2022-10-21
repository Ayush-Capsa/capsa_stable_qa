import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class deleteAdminMobile extends StatelessWidget {
  subAdmin admin;

  deleteAdminMobile({Key key,@required this.admin,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //capsaPrint('firstName; $name $id');
    return Dialog(
        backgroundColor: Color.fromRGBO(245, 251, 255, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        elevation: 5,
        child: SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width*0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(24, 48, 24, 4),
                child: RichText(
                  text: TextSpan(
                      text: 'You are about to remove ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins'),
                      children: [
                        TextSpan(
                          text: admin.firstName + " " + admin.lastName,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color.fromRGBO(0, 152, 219, 1), fontFamily: 'Poppins'),
                        ),
                        TextSpan(
                          text: 'as',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins'),
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
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins'),
                        children: [
                          TextSpan(
                            text: 'Sub-Admin ',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color.fromRGBO(0, 152, 219, 1), fontFamily: 'Poppins'),
                          ),
                          TextSpan(
                            text: 'of this account.',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins'),
                          ),
                        ]
                    )
                ),
              ),
              Container(
                  child: Text(
                      'Do you wish to continue',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1))
                  )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(39, 44, 35, 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonBar(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                            onPressed: (){Navigator.pop(context);},
                            style: ElevatedButton.styleFrom(
                              onPrimary: Color.fromRGBO(130, 130, 130, 1),
                              primary: Color.fromRGBO(245, 251, 255, 1),
                              fixedSize: Size(100, 40),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            )
                        ),
                        ElevatedButton(
                            onPressed: () async{
                              var anchorsActions = Provider.of<AnchorActionProvider>(context,listen: false);
                              await anchorsActions.removeAdmin(admin.adminId);
                              Navigator.pop(context);

                            },
                            style: TextButton.styleFrom(
                              primary: Color.fromRGBO(242, 242, 242, 1),
                              backgroundColor: Color.fromRGBO(235, 87, 87, 1),
                              fixedSize: Size(100, 40),
                            ),
                            child: Text(
                              'Remove',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            )
                        )
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
