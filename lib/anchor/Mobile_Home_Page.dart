import 'Mobile_Invoices/Invoices_Page.dart';
import 'Mobile_Payments/Payments_Landing.dart';
import 'Mobile_Profile/profile_screen.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class mobileHomePage extends StatefulWidget {
  const mobileHomePage({Key key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

int _selectedIndex = 0;

class _homePageState extends State<mobileHomePage> {

  List pages = [
    invoicesPage(),
    paymentsScreen(),
    profileScreen()
  ];

  void onItemChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(16, 16, 16, 1),
                icon: Icon(Icons.sim_card_outlined),
                label: 'Invoices'
            ),
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(16, 16, 16, 1),
                icon: Icon(Icons.credit_card),
                label: 'Payments'
            ),
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(16, 16, 16, 1),
                icon: Icon(Icons.person_outline),
                label: 'Profile'
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: onItemChange
        ),
      ),
    );
  }
}
