import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/GeneratedDesktopMenuWidget.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class DesktopMainMenuWidget extends StatelessWidget {
final  List<Map> menuList;
final bool backButton ;
final String backUrl ;
final bool pop;
  DesktopMainMenuWidget(this.menuList,{this.backButton,this.backUrl, this.pop = false, Key key}) : super(key: key);




  @override
  Widget build(BuildContext context) {

    return Container(width: 185, height: MediaQuery.of(context).size.height, child: GeneratedDesktopMenuWidget(menuList,backButton: backButton,backUrl: backUrl,pop: pop,));
  }
}