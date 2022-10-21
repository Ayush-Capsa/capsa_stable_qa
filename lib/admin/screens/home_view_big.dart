import 'package:beamer/beamer.dart';
import 'package:capsa/admin/common/widget_list.dart';
import 'package:capsa/admin/currency_icon_icons.dart';
import 'package:capsa/admin/providers/navrail_provider.dart';

import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'package:provider/provider.dart';

class HomeViewBig extends StatefulWidget {
  @override
  _HomeViewBigState createState() => _HomeViewBigState();
}

class _HomeViewBigState extends State<HomeViewBig> with SingleTickerProviderStateMixin {
  final box = Hive.box('capsaBox');
  int selectedIndex = 1;
  int _cSelectedIndex = 1;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaQuery.of(context).size.width < 800
            ? Container()
            : LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(child: Consumer<NavRailModel>(builder: (context, value, child) {
                      if (value.showNavRailValue == false) return Container();

                      return NavigationRail(
                        // minExtendedWidth: 60,
                        minWidth: 56,
                        trailing: Center(
                          child: Text(
                            '_________',
                            style: TextStyle(color: Colors.grey[300]),
                          ),
                        ),
                        selectedIndex: ((tab.index - 1) < 0) ? _cSelectedIndex - 1 : tab.index - 1,
                        onDestinationSelected: (int index) {
                          index++;
                          if (index == 20) {
                            authProvider.authChange(false,'');
                            box.put('isAuthenticated', false);
                            box.delete('userData');
                            // capsaPrint(box.get('userData') ?? 'no data');
                            showToast('Logged Out', context, type: 'info');
                            Beamer.of(context).beamToNamed('/signup');
                          } else {
                            tab.changeTab(index);
                            _cSelectedIndex = index;
                          }
                        },
                        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                        selectedLabelTextStyle: TextStyle(color: Theme.of(context).primaryColor),
                        labelType: NavigationRailLabelType.all,
                        destinations: [
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.dashboard,
                              size: 18,
                            ),
                            label: Text(
                              'Dashboard',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              CurrencyIcon.naira,
                              size: 18,
                            ),
                            label: Text(
                              "Buyer\nList",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              LineAwesomeIcons.tag,
                              size: 18,
                            ),
                            label: Text(
                              'Vendor\nList',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              LineAwesomeIcons.tag,
                              size: 18,
                            ),
                            label: Text(
                              'Anchor\nList',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          NavigationRailDestination(
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
                          // NavigationRailDestination(
                          //   icon: Icon(
                          //     Icons.edit,
                          //     size: 19,
                          //   ),
                          //   label: Text(
                          //     'Edit \nAccount',
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(fontSize: 12),
                          //   ),
                          // ),
                          NavigationRailDestination(
                            icon: Icon(
                              LineAwesomeIcons.sign_out,
                              size: 19,
                            ),
                            label: Text('Logout'),
                          ),
                        ],
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
          ),
        )
      ],
    );
  }
}

class Content extends StatefulWidget {
  final int selected;

  const Content({Key key, this.selected}) : super(key: key);

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
        child: desktopWidgetList[_selected],
      ),
    );
  }
}
