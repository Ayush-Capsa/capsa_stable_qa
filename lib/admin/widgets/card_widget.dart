import  'package:capsa/admin/providers/tabbar_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

import 'package:provider/provider.dart';

class CardFragment extends StatelessWidget {
  final String title, subtitle, no;
  final IconData icon;
  final double width;

  const CardFragment(
      {Key key,
      this.title,
      this.subtitle,
      this.no,
      this.icon,
      this.width = 310})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).accentColor.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(1.0, 1.0),
          )
        ],
      ),
      width: width,
      child: InkWell(
        onTap: () {
          // if (title == 'Total Returns') {
          tab.changeTab(3);
          //  } else {
          //   tab.changeTab(3);
          // }
        },
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("$title"),
                  trailing: Icon(
                    icon,
                    color: Theme.of(context).accentColor,
                    size: 38,
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).accentColor.withOpacity(0.9),
                        ),
                        child: Text(
                          '$subtitle',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '$no',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
