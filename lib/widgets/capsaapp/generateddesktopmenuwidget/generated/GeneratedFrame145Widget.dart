import 'package:beamer/beamer.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/generated/GeneratedHomeWidget.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class GeneratedFrame145Widget extends StatelessWidget {
  final List<Map> menuList;
  final bool backButton;

  GeneratedFrame145Widget(this.menuList, {this.backButton, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155.0,
      // height: 474.0,
      child: Column(
          // fit: StackFit.expand, alignment: Alignment.center, overflow: Overflow.visible,

          children: [
            for (var menu in menuList)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: InkWell(
                    onTap: () {
                      bool _replaceCurrent = false;
                      // capsaPrint("_replaceCurrent");
                      // capsaPrint(menu['replace']);
                      if (menu['replace'] != null && menu['replace'] == true) {
                        _replaceCurrent = true;
                        // capsaPrint("_replaceCurrent2");


                        // capsaPrint(_replaceCurrent);



                      }

                      context.beamToNamed(menu['url'],
                          // replaceCurrent: _replaceCurrent
                      );
                    },
                    child: GeneratedHomeWidget(menu)),
              ),
            // Positioned(
            //   left: 0.0,
            //   top: 83.0,
            //   right: null,
            //   bottom: null,
            //   width: 141.0,
            //   height: 59.0,
            //   child: GeneratedBidsWidget(),
            // ),
          ]),
    );
  }
}
