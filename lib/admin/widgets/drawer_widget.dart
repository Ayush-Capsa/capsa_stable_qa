import 'package:beamer/beamer.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../currency_icon_icons.dart';

class DrawerWidget extends StatelessWidget {
  final box = Hive.box('capsaBox');

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final tab = Provider.of<TabBarModel>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset('assets/cowry.png'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            leading: Icon(
              CurrencyIcon.naira,
            ),
            onTap: () {
              tab.changeTab(1);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Buyer List'),
            leading: Icon(
              CurrencyIcon.naira,
            ),
            onTap: () {
              tab.changeTab(2);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Vendor List'),
            leading: Icon(
              LineAwesomeIcons.tag,
            ),
            onTap: () {
              tab.changeTab(3);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Anchor List'),
            leading: Icon(
              LineAwesomeIcons.tag,
            ),
            onTap: () {
              tab.changeTab(4);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Pending Invoices'),
            leading: Icon(
              LineAwesomeIcons.credit_card,
            ),
            onTap: () {
              tab.changeTab(5);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Pending Revenues'),
            leading: Icon(
              LineAwesomeIcons.credit_card,
            ),
            onTap: () {
              tab.changeTab(6);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Vendor On-boarding'),
            leading: Icon(
              LineAwesomeIcons.history,
            ),
            onTap: () {
              tab.changeTab(7);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(
              'Buyer On-boarding',
            ),
            leading: Icon(
              LineAwesomeIcons.users,
            ),
            onTap: () {
              tab.changeTab(8);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(
              'Anchor On-boarding',
            ),
            leading: Icon(
              LineAwesomeIcons.user,
            ),
            onTap: () {
              tab.changeTab(9);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(
              'Invoice List',
            ),
            leading: Icon(
              LineAwesomeIcons.list,
            ),
            onTap: () {
              tab.changeTab(10);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Account'),
            leading: Icon(
              CurrencyIcon.naira,
            ),
            onTap: () {
              tab.changeTab(11);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Manual settlement'),
            leading: Icon(
              CurrencyIcon.naira,
            ),
            onTap: () {
              tab.changeTab(12);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Check Credit Score'),
            leading: Icon(
              CurrencyIcon.naira,
            ),
            onTap: () {
              tab.changeTab(13);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Transaction Ledger'),
            leading: Icon(
              CurrencyIcon.naira,
            ),
            onTap: () {
              tab.changeTab(14);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Block Account'),
            leading: Icon(
              Icons.block,
            ),
            onTap: () {
              tab.changeTab(15);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(
              LineAwesomeIcons.sign_out,
            ),
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}
