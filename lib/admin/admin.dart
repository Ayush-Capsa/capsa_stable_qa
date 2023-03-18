import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/edit_table_data_provider.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/admin/screens/change_password_admin.dart';
import 'package:capsa/admin/widgets/drawer_widget.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/providers/auth_provider.dart';
// import 'package:capsa/vendor/providers/creditscore_providers.dart';
import 'package:capsa/widgets/notification_bar.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'providers/navrail_provider.dart';
import 'providers/tabbar_model.dart';
import 'screens/home_view_big.dart';

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TabBarModel>(
          create: (_) => TabBarModel(),
        ),
        ChangeNotifierProvider<ActionModel>(
          create: (_) => ActionModel(),
        ),
        ChangeNotifierProvider<NavRailModel>(
          create: (_) => NavRailModel(),
        ),
        ChangeNotifierProvider<EditTableDataProvider>(
          create: (_) => EditTableDataProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
        // ChangeNotifierProvider<CreditScoreProvider>(
        //   create: (_) => CreditScoreProvider(),
        // ),

      ],
      child: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> title = [
    'Edit',
    'Dashboard',
    'Buyer List',
    'Vendor List',
    'Anchor List',
    'Pending Invoices',
    'Pending Revenues',
    'Vendor On-boarding',
    'Buyer On-boarding',
    'Anchor On-boarding',
    'Invoice List',
    'Account',
    'Manual settlement',
    'Manual settlement',
    'Check Credit Score',
    'Block List Account'
    // 'Edit Account',
    'Logout',
  ];

  @override
  void initState() {
    final box = Hive.box('capsaBox');
    if (box.get('isAuthenticated', defaultValue: false) == false) {
      logout(context);
      return;
    }
    Provider.of<ProfileProvider>(context, listen: false).queryFewData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    final _profileProvider = Provider.of<ProfileProvider>(context);

    // capsaPrint(tab.index.toString());
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backwardsCompatibility: false,
        leading: MediaQuery.of(context).size.width < 800
            ? IconButton(
                icon: const Icon(
                  LineAwesomeIcons.bars,
                  size: 31,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (MediaQuery.of(context).size.width < 800) _scaffoldKey.currentState.openDrawer();
                  // final navRailProvider =
                  //     Provider.of<NavRailModel>(context, listen: false);
                  // navRailProvider.showNavRail(!navRailProvider.showNavRailValue);
                },
              )
            : const SizedBox(),
        elevation: 0,
        title: MediaQuery.of(context).size.width < 800
            ? Text(
                title[tab.index],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Row(
                children: [
                  const Spacer(),
                  MediaQuery.of(context).size.width < 800
                      ? Container()
                      : InkWell(
                          onTap: () {
                            tab.changeTab(9);
                          },
                          child: Row(
                            children: [
                              Text(
                                'Capsa Account Balance',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      LineAwesomeIcons.credit_card,
                                      size: 20,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _profileProvider.totalBalance != null ? formatCurrency(_profileProvider.totalBalance) : '0',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // showNotificationBar(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ChangePasswordPageAdmin(),
          //       ),
          //     );
          //   },
          //   icon: Icon(Icons.settings),
          //   color: Colors.grey[700],
          // ),

          PopupMenuButton(
            icon: Icon(Icons.settings, color: Colors.black,),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ChangePasswordPageAdmin(),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider(
                                create: (BuildContext
                                context) =>
                                    ProfileProvider(),
                                child:ChangePasswordPageAdmin(),),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.password, color: Colors.black,),
                      RichText(
                        text: TextSpan(
                          text: 'Change Password',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color:
                              Color.fromRGBO(51, 51, 51, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

           SizedBox(width: 8,),

          // IconButton(
          //   onPressed: () {
          //     showNotificationBar(context);
          //   },
          //   icon: Icon(Icons.se),
          //   color: Colors.grey[700],
          // ),
        ],
      ),
      body: SafeArea(child: HomeViewBig()),
    );
  }
}
