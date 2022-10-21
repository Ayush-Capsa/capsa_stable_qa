import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class paymentDialog extends StatelessWidget {
  const paymentDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(245, 251, 255, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      elevation: 5,
      child: _paymentDialog(context),
    );
  }

  _paymentDialog(BuildContext context) => Container(
    height: 279,
    width: 456,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(24, 48, 24, 4),
          child: RichText(
            text: TextSpan(
              text: 'You are about to mark the invoice of',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1)),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 30),
          child: RichText(
            text: TextSpan(
              text: 'N949,000 ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromRGBO(0, 152, 219, 1)),
                children: [
                  TextSpan(
                    text: 'from ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1)),
                  ),
                  TextSpan(
                      text: 'Pacegate ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromRGBO(0, 152, 219, 1))
                  ),
                  TextSpan(
                    text: 'as paid.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1)),
                  )
                ]
            )
          ),
        ),
        Container(
          child: RichText(
            text: TextSpan(
              text: 'Would you like to continue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1)),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(140, 44, 125, 48),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 40),
                child: TextButton(
                    onPressed: (){},
                    child: Text(
                      'Yes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromRGBO(33, 150, 83, 1)),
                    )
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromRGBO(235, 87, 87, 1)),
                  )
              )
            ],
          ),
        )
      ],
    ),
  );
}
