import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class CapsaLogoImage extends StatelessWidget {
  const CapsaLogoImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Full Logo.png',
            width: 200,
            height: 200,
          ),
        ],
      ),
    );
  }
}

class MobileBGWhiteContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  MobileBGWhiteContainer({this.child,this.height,this.width, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:width ?? MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        color: Color.fromRGBO(245, 251, 255, 1),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 1),
          width: 5,
        ),

        // image: DecorationImage(
        //     image: AssetImage(
        //       'assets/images/Frame 133.png',
        //     ),
        //     fit: BoxFit.fitWidth),
      ),
      child: child ?? Container(),
    );
  }
}
