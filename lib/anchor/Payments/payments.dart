import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/textStyles.dart';
import 'package:capsa/anchor/Payments/paid_screen.dart';
import 'package:capsa/anchor/Payments/upcoming_30_tab.dart';
import 'package:capsa/anchor/Payments/upcoming45Tab.dart';
import 'package:capsa/anchor/Payments/upcoming60Tab.dart';
import 'package:capsa/anchor/Payments/upcoming_7_tab.dart';

class paymentScreen extends StatefulWidget {
  const paymentScreen({Key key}) : super(key: key);

  @override
  _paymentScreenState createState() => _paymentScreenState();
}

class _paymentScreenState extends State<paymentScreen> {
  var _selectedIndex = 0;
  var _selectedDue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/0.9,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(29, 51, 145, 51),
                  child: Text(
                    'Payments',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45, 58, 24, 58),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.notifications_none),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'images/5982.png',
                    width: 60,
                    height: 60,
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(29, 0, 233, 41),
                child: Container(
                  height: 59,
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Card(
                    color: Color.fromRGBO(245, 251, 255, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Text(
                              'Upcoming',
                              style: _selectedIndex == 0?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                        ),
                        Text('|',style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w200,
                          color: Colors.black.withOpacity(0.4),
                        ) ,),
                        TextButton(
                          child: Text(
                              'Paid',
                              style: _selectedIndex == 1?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _selectedIndex == 0?
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 36, 41),
                child: Container(
                  height: 59,
                  width: MediaQuery.of(context).size.width*0.75,
                  child: Card(
                    shadowColor: Colors.black,
                    color: Color.fromRGBO(245, 251, 255, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          child: Text(
                              'Due in 0 - 7 days',
                              style: _selectedDue == 0?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedDue = 0;
                            });
                          },
                        ),
                        Text('|',style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w200,
                          color: Colors.black.withOpacity(0.4),
                        ) ,),
                        TextButton(
                          child: Text(
                              'Due in 8 - 30 days',
                              style: _selectedDue == 1?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedDue = 1;
                            });
                          },
                        ),
                        Text('|',style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w200,
                          color: Colors.black.withOpacity(0.4),
                        ) ,),
                        TextButton(
                          child: Text(
                              'Due in 31 - 45 days',
                              style: _selectedDue == 2?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedDue = 2;
                            });
                          },
                        ),
                        Text('|',style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w200,
                          color: Colors.black.withOpacity(0.4),
                        ) ,),
                        TextButton(
                          child: Text(
                              'Due in 46 - 60 days',
                              style: _selectedDue == 3?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedDue = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
              :
                    Container(
                      height: 59,
                      width: MediaQuery.of(context).size.width*0.75,
                    )
            ],
          ),
          _selectedIndex == 0?
              _selectedDue == 0?
                  upcomingScreen()
                  :
                  _selectedDue == 1?
                      upcoming30Screen()
                      :
                      _selectedDue == 2?
                          upcoming45Screen()
                          :
                          upcoming60Screen()
              :
              paidScreen()
        ],
      ),
    );
  }
}