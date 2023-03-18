import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:capsa/admin/common/widget_list.dart';
import 'package:capsa/admin/currency_icon_icons.dart';
import 'package:capsa/admin/providers/navrail_provider.dart';
import 'package:capsa/admin/providers/profile_provider.dart';

import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'package:provider/provider.dart';

import 'change_password_admin.dart';

class HomeViewBig extends StatefulWidget {
  @override
  _HomeViewBigState createState() => _HomeViewBigState();
}

class _HomeViewBigState extends State<HomeViewBig>
    with SingleTickerProviderStateMixin {
  final box = Hive.box('capsaBox');
  int selectedIndex = 1;
  int _cSelectedIndex = 1;
  bool show = false;
  List<dynamic> permissions = [];
  List<NavigationRailDestination> destinations = [];
  bool permissionsLoaded = false;



  List<NavigationRailDestination> destinationsTotal = [
    const NavigationRailDestination(
      icon: Icon(
        Icons.dashboard,
        size: 18,
      ),
      selectedIcon: Icon(
        Icons.dashboard,
        size: 18,
        color: Colors.blue,
      ),
      label: Text(
        'Dashboard',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        CurrencyIcon.naira,
        size: 18,
      ),
      selectedIcon: Icon(
        CurrencyIcon.naira,
        size: 18,
        color: Colors.blue,
      ),
      label: Text(
        "Buyer\nList",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.tag,
        size: 18,
      ),
      selectedIcon: Icon(
        LineAwesomeIcons.tag,
        size: 18,
        color: Colors.blue,
      ),
      label: Text(
        'Vendor\nList',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.tag,
        size: 18,
      ),
      selectedIcon: Icon(
        LineAwesomeIcons.tag,
        size: 18,
        color: Colors.blue,
      ),
      label: Text(
        'Anchor\nList',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        Icons.monetization_on_outlined,
        size: 18,
      ),
      selectedIcon: Icon(
        Icons.monetization_on_outlined,
        size: 18,
        color: Colors.blue,
      ),
      label: Text(
        'Revenue',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        Icons.monetization_on_outlined,
        size: 18,
      ),
      selectedIcon: Icon(
        Icons.monetization_on_outlined,
        size: 18,
        color: Colors.blue,
      ),
      label: Text(
        'Transaction Volume',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    // const NavigationRailDestination(
    //   icon: Icon(
    //     LineAwesomeIcons.tag,
    //     size: 18,
    //   ),
    //   label: Text(
    //     'Anchor\nList',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(fontSize: 12),
    //   ),
    // ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.credit_card,
        size: 18,
      ),
      label: Text(
        'Pending\nInvoices',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    // NavigationRailDestination(
    //   icon: Icon(
    //     LineAwesomeIcons.credit_card,
    //     size: 18,
    //   ),
    //   label: Text(
    //     'Pending\nRevenue',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(fontSize: 12),
    //   ),
    // ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.history,
        size: 18,
      ),
      label: Text(
        'Vendor\nOn-boarding',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.users,
        size: 18,
      ),
      label: Text(
        'Buyer\nOn-boarding',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),

    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.user,
        size: 18,
      ),
      label: Text(
        'Anchor\nOn-boarding',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),

    const NavigationRailDestination(
      icon: Icon(
        Icons.grade,
        size: 18,
      ),
      label: Text(
        'Anchor\nGrading',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),

    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.list,
        size: 18,
      ),
      label: Text(
        'Invoice\nList',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.list,
        size: 18,
      ),
      label: Text(
        'Account',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.list_alt,
        size: 18,
      ),
      label: Text(
        'Manual\nSettlement',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    // NavigationRailDestination(
    //   icon: Icon(
    //     LineAwesomeIcons.list_alt,
    //     size: 18,
    //   ),
    //   label: Text(
    //     'Check\nCredit',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(fontSize: 12),
    //   ),
    // ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.list_alt,
        size: 18,
      ),
      label: Text(
        'Transaction\nLedger',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.list_alt,
        size: 18,
      ),
      label: Text(
        'Reconcilation',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.list_ul,
        size: 18,
      ),
      label: Text(
        'Transfer\nAmount',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.list_ul,
        size: 19,
      ),
      label: Text(
        'Revenue \nAmount',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        LineAwesomeIcons.list_ul,
        size: 19,
      ),
      label: Text(
        'Blocked \nAmount',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        Icons.edit,
        size: 19,
      ),
      label: Text(
        'Edit \nAccount',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        Icons.pending,
        size: 19,
      ),
      label: Text(
        'Pending \nAccount Request',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        Icons.block,
        size: 19,
      ),
      label: Text(
        'Block \nAccount',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
    const NavigationRailDestination(
      icon: Icon(
        Icons.edit,
        size: 19,
      ),
      label: Text(
        'Edit \nInvoice',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ),
  ];
  List<Widget> desktopFinalWidget = [];

  List<String> permissionsTotal = [
    'DA',
    'BL',
    'VL',
    'AL',
    'RT',
    'TT',
    'PI',
    'VO',
    'BO',
    'AO',
    'AG',
    'IL',
    'AC',
    'MS',
    'TL',
    'RC',
    'TA',
    'RA',
    'BA',
    'EA',
    'PA',
    'BAC',
    'EI'
  ];


  Map<dynamic, dynamic> navigationRailsMap = {};
  Map<dynamic, dynamic> pagesMap = {};

  List<String> stringToList(String s) {
    List<String> result = [];
    String x = '';
    for (int i = 0; i < s.length; i++) {
      if (s[i] != ' ') {
        x = x + s[i];
      } else {
        result.add(x);
        x = '';
      }
    }
    if(x!='') {
      result.add(x);
    }
    return result;
  }

  void mapping() {
    for (int i = 0; i < permissionsTotal.length; i++) {
      navigationRailsMap[permissionsTotal[i]] = destinationsTotal[i];

      pagesMap[permissionsTotal[i]] = desktopWidgetList[i];
    }
  }

  void getAdminPermissions() async {

    capsaPrint('get admin ');
    dynamic response =
        await Provider.of<ProfileProvider>(context, listen: false)
            .fetchAdminAccountPermissions();
    capsaPrint('get admin pass 1');
    //capsaPrint('$response['data)
    // String s = '{"message":"success","data":[{"id":3,"PAN_NO":"12345678912","email":"commercial@getcapsa.com","role":"support_admin","permissions":"DA BL VL AL PI VO BO IL TL RA","totalPermissions":"DA BL VL AL RT TT PI VO BO AO AG IL AC MS TL RC TA RA BA EA PA BAC EI"}]}';
    // response = jsonDecode(s);
    //permissionsTotal = stringToList(response['data'][0]['totalPermissions']);
    mapping();
    permissions = stringToList(response['data'][0]['permissions']);
    capsaPrint('get admin pass 2 $permissions');

    desktopFinalWidget.add(EditTabCall());

    for (int i = 0; i < permissions.length; i++) {
      capsaPrint('adding ${permissions[i]}');
      destinations.add(navigationRailsMap[permissions[i]]);
      desktopFinalWidget.add(pagesMap[permissions[i]]);
    }

    // destinations.add(
    //   const NavigationRailDestination(
    //     icon: Icon(
    //       LineAwesomeIcons.tag,
    //       size: 18,
    //     ),
    //     // selectedIcon: Icon(
    //     //   LineAwesomeIcons.tag,
    //     //   size: 18,
    //     //   color: Colors.blue,
    //     // ),
    //     label: Text(
    //       'Vendor\nList',
    //       textAlign: TextAlign.center,
    //       style: TextStyle(fontSize: 12),
    //     ),
    //   ),
    // );

    destinations.add(
      const NavigationRailDestination(
        icon: Icon(
          LineAwesomeIcons.sign_out,
          size: 19,
        ),
        // selectedIcon: Icon(
        //   LineAwesomeIcons.sign_out,
        //   size: 19,
        //   color: Colors.blue,
        // ),
        label: Text('Logout'),
      ),
    );
    capsaPrint('Pass 2 home view');

    desktopFinalWidget.add(LogOut());

    capsaPrint('Pass 3 home view');

    // destinations.add(const NavigationRailDestination(
    //   icon: Icon(
    //     Icons.dashboard,
    //     size: 18,
    //   ),
    //   label: Text(
    //     'Dashboard',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(fontSize: 12),
    //   ),
    // ),);
    // destinations.add(const NavigationRailDestination(
    //   icon: Icon(
    //     CurrencyIcon.naira,
    //     size: 18,
    //   ),
    //   label: Text(
    //     "Buyer\nList",
    //     textAlign: TextAlign.center,
    //     style: TextStyle(fontSize: 12),
    //   ),
    // ),);
    //
    // destinations.add(const NavigationRailDestination(
    //   icon: Icon(
    //     LineAwesomeIcons.sign_out,
    //     size: 19,
    //   ),
    //   label: Text('Logout'),
    // ),);
    capsaPrint('get admin pass 3');




    //dynamic rawData = box.get('tmpUserData');

    response = await Provider.of<ProfileProvider>(context, listen: false)
        .checkLastPasswordReset();

    //capsaPrint('\n\nCheck passwrod : $response');

    if(response['msg'] != 'success') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          // title: Text(
          //   '',
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //     color: Theme.of(context).primaryColor,
          //   ),
          // ),
          content: Container(
            // width: 800,
              height: Responsive.isMobile(context)?340:300,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [

                    SizedBox(height: 12,),

                    Image.asset('assets/icons/warning.png'),

                    SizedBox(height: 12,),

                    Text(
                      'Action Required',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 12,),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider(
                                  create: (BuildContext
                                  context) =>
                                      ProfileProvider(),
                                  child:ChangePasswordPageAdmin(canGoBack: false,),),
                          ),
                        );
                      },
                      child: Container(
                        width: Responsive.isMobile(context)?140 : 220,
                        decoration: BoxDecoration(
                            color: HexColor('#0098DB'),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Okay',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              )
          ),
          //actions: <Widget>[],
        ));
    }

    setState(() {
      permissionsLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getAdminPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return permissionsLoaded
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediaQuery.of(context).size.width < 800
                  ? Container()
                  : LayoutBuilder(builder: (context, constraint) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraint.maxHeight),
                          child: IntrinsicHeight(child: Consumer<NavRailModel>(
                              builder: (context, value, child) {
                            if (value.showNavRailValue == false)
                              return Container();

                            return NavigationRail(
                              // minExtendedWidth: 60,
                              minWidth: 56,
                              trailing: Center(
                                child: Text(
                                  '_________',
                                  style: TextStyle(color: Colors.grey[300]),
                                ),
                              ),
                              selectedIndex: ((tab.index - 1) < 0)
                                  ? _cSelectedIndex - 1
                                  : tab.index - 1,
                              onDestinationSelected: (int index) {
                                index++;
                                if (index == (desktopFinalWidget.length-1)) {
                                  authProvider.authChange(false, '');
                                  box.put('isAuthenticated', false);
                                  box.delete('userData');
                                  // capsaPrint(box.get('userData') ?? 'no data');
                                  showToast('Logged Out', context,
                                      type: 'info');
                                  Beamer.of(context).beamToNamed('/signup');
                                } else {
                                  tab.changeTab(index);
                                  _cSelectedIndex = index;
                                }
                              },
                              selectedIconTheme:
                                  IconThemeData(color: Colors.blue),
                              selectedLabelTextStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              labelType: NavigationRailLabelType.all,
                              destinations: destinations,

                              // [
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       Icons.dashboard,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Dashboard',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       CurrencyIcon.naira,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       "Buyer\nList",
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.tag,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Vendor\nList',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.tag,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Anchor\nList',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.credit_card,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Pending\nInvoices',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   // NavigationRailDestination(
                              //   //   icon: Icon(
                              //   //     LineAwesomeIcons.credit_card,
                              //   //     size: 18,
                              //   //   ),
                              //   //   label: Text(
                              //   //     'Pending\nRevenue',
                              //   //     textAlign: TextAlign.center,
                              //   //     style: TextStyle(fontSize: 12),
                              //   //   ),
                              //   // ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.history,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Vendor\nOn-boarding',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.users,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Buyer\nOn-boarding',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.user,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Anchor\nOn-boarding',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.list,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Invoice\nList',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.list,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Account',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.list_alt,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Manual\nSettlement',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   // NavigationRailDestination(
                              //   //   icon: Icon(
                              //   //     LineAwesomeIcons.list_alt,
                              //   //     size: 18,
                              //   //   ),
                              //   //   label: Text(
                              //   //     'Check\nCredit',
                              //   //     textAlign: TextAlign.center,
                              //   //     style: TextStyle(fontSize: 12),
                              //   //   ),
                              //   // ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.list_alt,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Transaction\nLedger',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.list_alt,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Reconcilation',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.list_ul,
                              //       size: 18,
                              //     ),
                              //     label: Text(
                              //       'Transfer\nAmount',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.list_ul,
                              //       size: 19,
                              //     ),
                              //     label: Text(
                              //       'Revenue \nAmount',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.list_ul,
                              //       size: 19,
                              //     ),
                              //     label: Text(
                              //       'Blocked \nAmount',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       Icons.edit,
                              //       size: 19,
                              //     ),
                              //     label: Text(
                              //       'Edit \nAccount',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       Icons.pending,
                              //       size: 19,
                              //     ),
                              //     label: Text(
                              //       'Pending \nAccount Request',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       Icons.block,
                              //       size: 19,
                              //     ),
                              //     label: Text(
                              //       'Block \nAccount',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       Icons.edit,
                              //       size: 19,
                              //     ),
                              //     label: Text(
                              //       'Edit \nInvoice',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //   ),
                              //   // NavigationRailDestination(
                              //   //   icon: Icon(
                              //   //     Icons.edit,
                              //   //     size: 19,
                              //   //   ),
                              //   //   label: Text(
                              //   //     'Edit \nAccount',
                              //   //     textAlign: TextAlign.center,
                              //   //     style: TextStyle(fontSize: 12),
                              //   //   ),
                              //   // ),
                              //   NavigationRailDestination(
                              //     icon: Icon(
                              //       LineAwesomeIcons.sign_out,
                              //       size: 19,
                              //     ),
                              //     label: Text('Logout'),
                              //   ),
                              // ],
                            );
                          })),
                        ),
                      );
                    }),
              VerticalDivider(
                width: 2,
              ),
              Expanded(
                child: Content(
                  selected: tab.index,
                  desktopList: desktopFinalWidget,
                ),
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class Content extends StatefulWidget {
  final int selected;
  final List<Widget> desktopList;

  const Content({Key key, this.selected, this.desktopList})
      : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _selected = widget.selected;
    // if(_selected != 0) _selected++;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: widget.desktopList[_selected],
      ),
    );
  }
}
