import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generated_mobilemenunavigationsvendorwidget/generated/GeneratedHomeWidget.dart';

import 'package:beamer/beamer.dart';

class GeneratedHomeActiveWidget extends StatelessWidget {
  final List<Map> menuList;

  GeneratedHomeActiveWidget(this.menuList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 66.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(38, 0, 0, 0),
            offset: Offset(0.0, -2.0),
            blurRadius: 4.0,
          )
        ],
      ),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible, children: [
        ClipRRect(
          borderRadius: BorderRadius.zero,
          child: Container(
            color: Color.fromARGB(255, 15, 15, 15),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          width: MediaQuery.of(context).size.width,
          height: 66.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var menu in menuList)
                  if (menu['mobile'] == null || menu['mobile'] == true)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: InkWell(
                          onTap: () {
                            context.beamToNamed(menu['url'],

                                // replaceCurrent: (menu['replace'] != null && menu['replace']) ? true : false
                            );
                          },
                          child: GeneratedHomeWidget(menu)),
                    )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
