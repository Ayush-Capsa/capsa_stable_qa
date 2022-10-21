import 'package:capsa/anchor/Mobile_Payments/Paid.dart';
import 'package:capsa/anchor/Mobile_Payments/upcoming30Days.dart';
import 'package:capsa/anchor/Mobile_Payments/upcoming45Days.dart';
import 'package:capsa/anchor/Mobile_Payments/upcoming60Days.dart';
import 'package:capsa/anchor/Mobile_Payments/upcoming_7_days.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class paymentsScreen extends StatefulWidget {
  const paymentsScreen({Key key}) : super(key: key);

  @override
  _paymentsScreenState createState() => _paymentsScreenState();
}

var _selectedIndex = 0;

class _paymentsScreenState extends State<paymentsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height*0.14
            ),
            child: AppBar(
              backgroundColor: Color.fromRGBO(245, 251, 255, 1),
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
                child: Title(
                  child: Text(
                    'Payments',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                  color: Color.fromRGBO(245, 251, 255, 1),
                ),
              ),
              bottom: TabBar(
                labelColor: Color.fromRGBO(51, 51, 51, 1),
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelColor: Color.fromRGBO(130, 130, 130, 1),
                unselectedLabelStyle: TextStyle(fontSize: 12),
                tabs: [
                  Tab(
                    child: Text('Upcoming'),
                  ),
                  Tab(
                    child: Text('Paid'),
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = 0;
                                    });
                                  },
                                  child: Text(
                                    'Due in 0 - 7 days',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(51, 51, 51, 1)
                                    ),
                                  ),
                                ),
                                elevation: 0,
                                color: _selectedIndex == 0?Color.fromRGBO(219, 219, 219, 1) : Color.fromRGBO(245, 251, 255, 1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = 1;
                                    });
                                  },
                                  child: Text(
                                    'Due in 8 - 30 days',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(51, 51, 51, 1)
                                    ),
                                  ),
                                ),
                                elevation: 0,
                                color: _selectedIndex == 1? Color.fromRGBO(219, 219, 219, 1) : Color.fromRGBO(245, 251, 255, 1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = 2;
                                    });
                                  },
                                  child: Text(
                                    'Due in 31 - 45 days',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(51, 51, 51, 1)
                                    ),
                                  ),
                                ),
                                elevation: 0,
                                color: _selectedIndex == 2? Color.fromRGBO(219, 219, 219, 1) : Color.fromRGBO(245, 251, 255, 1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = 3;
                                    });
                                  },
                                  child: Text(
                                    'Due in 46 - 60 days',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(51, 51, 51, 1)
                                    ),
                                  ),
                                ),
                                elevation: 0,
                                color: _selectedIndex == 3? Color.fromRGBO(219, 219, 219, 1) : Color.fromRGBO(245, 251, 255, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _selectedIndex == 0?
                        upcoming7Days()
                        :
                        _selectedIndex == 1?
                            upcoming30Days()
                            :
                            _selectedIndex == 2?
                                upcoming45Days()
                                :
                                upcoming60Days()
                  ],
                ),
              ),
              paidScreen()
            ],
          ),
        )
      ),
    );
  }
}
