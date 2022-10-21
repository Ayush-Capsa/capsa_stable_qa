import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class vettedDialog extends StatelessWidget {
  const vettedDialog({Key key}) : super(key: key);

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

  void _viewPDF() async{

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
              width: 325,
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
              width: 223,
              height: 71,
              padding: EdgeInsets.only(left: 10),
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
                      'Vetted By:Olanrewaju A.',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color.fromRGBO(130, 130, 130, 1)
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: Text(
                      'Dec 24, 2020',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(51, 51, 51, 1)
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(320, 20.5, 16, 20.5),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(0, 152, 219, 1),
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 4, 229, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Date on which you are going to pay the vendor.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(235, 87, 87, 1)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'If this is not correct, please change.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(235, 87, 87, 1)
                  ),
                ),
              )
            ],
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: Text(
                      '890,900,890,900',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(51, 51, 51, 1)
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(280, 20.5, 16, 20.5),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(0, 152, 219, 1),
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 4, 310, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Amount you are going to pay vendor.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(235, 87, 87, 1)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'If this is not correct, please change.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(235, 87, 87, 1)
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 55),
          child: ButtonBar(
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Reject',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Color.fromRGBO(235, 85, 85, 1),
                    fixedSize: Size(282, 59)
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Approve',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(33, 150, 83, 1),
                    primary: Colors.white,
                    fixedSize: Size(282, 59)
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}