import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/helpers/transform/transform.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/generated/GeneratedParentDesktopMenuNavigationWidget.dart';

class GeneratedDesktopMenuWidget extends StatelessWidget {

  final  List<Map> menuList;
  final bool backButton ;
  final String backUrl  ;
  final bool pop;
  GeneratedDesktopMenuWidget(this.menuList,{this.backButton,this.backUrl, this.pop = false, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            height: MediaQuery.of(context).size.height + 40,
            child: Stack(children: [
              Container(
                  width: constraints.maxWidth,
                  child: Container(
                    width: 185,
                      height: MediaQuery.of(context).size.height + 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(0.0),
                      ),
                    ),
                    child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        overflow: Overflow.visible,
                        children: [
                          Positioned(
                            left: null,
                            top: 0.0,
                            right: null,
                            bottom: 0.0,
                            width: 185,
                            height: null,
                            child: LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              final double height = constraints.maxHeight;

                              return Stack(children: [
                                TransformHelper.translate(
                                    x: 0,
                                    y: 0,
                                    z: 0,
                                    child: Container(
                                      height: height,
                                      child:
                                          GeneratedParentDesktopMenuNavigationWidget(menuList,backButton: backButton,backUrl : backUrl,pop: pop,),
                                    ))
                              ]);
                            }),
                          )
                        ]),
                  ))
            ])),
      );
    }));
  }
}
