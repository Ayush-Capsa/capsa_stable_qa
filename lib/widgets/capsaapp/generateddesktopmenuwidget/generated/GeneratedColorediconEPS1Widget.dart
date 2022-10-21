import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:beamer/beamer.dart';

class GeneratedColorediconEPS1Widget extends StatelessWidget {


  final  List<Map> menuList;
  final bool backButton ;
  final String backUrl ;
  final bool pop;
  GeneratedColorediconEPS1Widget(this.menuList,{this.backButton,this.backUrl, this.pop = false, Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    if(backButton){

      return Container(
        width: 80.0,
        height: 45,
        child: InkWell(
          onTap: () {
            if(pop) {
              Navigator.pop(context);
            } else{
              if (backUrl != null) {
                context.beamToNamed(backUrl);
              } else {
                context.beamBack();
              }
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: Image.asset(
              "assets/images/arrow-left.png",
              color: null,
              fit: BoxFit.cover,
              width: 34.0,
              height: 34,
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 80.0,
      height: 45,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Image.asset(
          "assets/images/Colorediconeps1.png",
          color: null,
          fit: BoxFit.cover,
          width: 80.0,
          height: 45.41567611694336,
          colorBlendMode: BlendMode.dstATop,
        ),
      ),
    );
  }
}
