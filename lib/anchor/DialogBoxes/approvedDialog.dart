import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class approvedDialog extends StatelessWidget {
  const approvedDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
      ),
      elevation: 5,
      child: _dialogScreen(context),
    );
  }

  _dialogScreen(BuildContext context) => Container(
    height: 700,
    width: 628,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 353, 35),
          child: Text(
            'Midas Touche',
            style: TextStyle(
                color: Color.fromRGBO(0, 152, 219, 1),
                fontSize: 36,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 298,
              height: 63,
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Invoice',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(51, 51, 51, 1)
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      '98789687585',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(0, 152, 219, 1)
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 250,
              height: 71,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Status',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(51, 51, 51, 1)
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Approved By:Olanrewaju A.',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color.fromRGBO(33, 150, 83, 1)
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 4, 4),
          child: Text(
            'Effective Due Date',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
        Container(
          width: 588,
          height: 72,
          padding: EdgeInsets.only(left: 20),
          child: Card(
            color: Color.fromRGBO(245, 251, 255, 1),
            child: Container(
                padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                child: Text(
                  'Dec 24, 2020',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(130, 130, 130, 1)
                  ),
                )
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 25, 463, 4),
          child: Text(
            'Payable Amount',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
        Container(
          width: 588,
          height: 72,
          padding: EdgeInsets.only(left: 20),
          child: Card(
            color: Color.fromRGBO(245, 251, 255, 1),
            child: Container(
                padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                child: Text(
                  '890,900,890,900',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(130, 130, 130, 1)
                  ),
                )
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 50, 4, 4),
          child: Text(
            'Invoice is already on the live deals',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 16, 408, 117),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Edit Invoice',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color.fromRGBO(0, 152, 219, 1),
                fixedSize: Size(200, 59)
            ),
          ),
        )
      ],
    ),
  );
}