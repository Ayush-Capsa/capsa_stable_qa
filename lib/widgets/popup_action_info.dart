import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

showPopupActionInfo(BuildContext context,
    {String heading: '', String info: '', Function onTap, Function onTap2, bool barrierDismissible = false, String buttonText, String buttonText2, Color buttonColor1 = Colors.blue,Color buttonColor2 = Colors.blue,}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
          backgroundColor: Color.fromRGBO(245, 251, 255, 1),
          content: Container(
            constraints: Responsive.isMobile(context)
                ? BoxConstraints(
                    minHeight: 300,
                  )
                : BoxConstraints(minHeight: 300, maxWidth: 350),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(245, 251, 255, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (heading != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      child: Text(
                        heading,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(33, 150, 83, 1),
                            // fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1.5),
                      ),
                    ),
                  if (info != '')
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      child: Text(
                        info,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(130, 130, 130, 1),
                            // fontFamily: 'Poppins',
                            fontSize: 14,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1.5),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (buttonText2 != null)
                    SizedBox(
                      height: 20,
                    ),
                  if (buttonText != null)
                    InkWell(
                      onTap: onTap,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: buttonColor1,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  // fontFamily: 'Poppins',
                                  fontSize: 18,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (buttonText2 != null)
                    SizedBox(
                      height: 20,
                    ),
                  if (buttonText2 != null)
                    InkWell(
                      onTap: onTap2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: buttonColor2,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              buttonText2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  // fontFamily: 'Poppins',
                                  fontSize: 18,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      });
}

showLoader(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text("Loading..."),
                  ],
                ),
              ),
            ));
      });
}
