import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/signup/widgets/StackColumnSwitch.dart';
import 'package:capsa/signup/widgets/capsalogo.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';

class SelectAccountType extends StatefulWidget {
  const SelectAccountType({Key key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<SelectAccountType> {
  final formKey = GlobalKey<FormState>();

  // final myController0 = TextEditingController();
  // String _errorMsg1 = '';

  // bool processing = false;
  // bool isDone = false;

  String type = "";
  String type2 = "";

  final box = Hive.box('capsaBox');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box.put('onboardType', '');
    box.put('onboardInvestorType', '');
  }

  @override
  Widget build(BuildContext context) {
    String text1 = "Get started on";
    String text2 = "Capsa";
    if (type == "Investor") {
      text1 = "Get started as";
      text2 = "Investor";
    }

    return Container(
      decoration: Responsive.isMobile(context)
          ? BoxDecoration(
              color: HexColor("#0098DB"),
            )
          : BoxDecoration(),
      child: Form(
        key: formKey,
        child: Padding(
          padding: Responsive.isMobile(context) ? EdgeInsets.zero : EdgeInsets.all(45.0),
          child: Padding(
            padding: Responsive.isMobile(context) ? EdgeInsets.zero : EdgeInsets.only(left: 38.0),
            child: StackColumnSwitch(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isMobile(context)) Positioned(top: 33, child: CapsaLogoImage()),
                if (Responsive.isMobile(context))
                  Positioned(
                    bottom: 0,
                    child: MobileBGWhiteContainer(
                      child: _myWid(text1, text2),
                      height: MediaQuery.of(context).size.height * ((type == "") ? 0.5:  0.47),
                    ),
                  )
                else
                  _myWid(text1, text2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myWid(text1, text2) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  text1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontFamily: 'Poppins',
                      fontSize:  Responsive.isMobile(context) ? 18: 26,
                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: HexColor("#0098DB"),
                      fontFamily: 'Poppins',
                      fontSize:  Responsive.isMobile(context) ? 18: 26,
                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
              ],
            ),
          ),
          SizedBox(
            height:  Responsive.isMobile(context) ? 20: 90,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Continue as',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1),
                  fontFamily: 'Poppins',
                  fontSize:  Responsive.isMobile(context) ? 15: 22,
                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          if (type == "")
            OrientationSwitcher(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        type = "Vendor";
                        box.put('onboardType', type);
                      });
                      Beamer.of(context).beamToNamed('/select-country');
                    },
                    child: Image.asset(
                      Responsive.isMobile(context) ? "assets/images/Frame 281 m.png" : "assets/images/Frame 281.png",
                      width: Responsive.isMobile(context) ? double.infinity: 180,
                    )),
                SizedBox(
                  width: 25,
                  height: 10,
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        type = "Investor";
                        box.put('onboardType', type);
                      });
                    },
                    child: Image.asset(
                      Responsive.isMobile(context) ? "assets/images/Frame 280 m.png" : "assets/images/Frame 280.png",
                      width: Responsive.isMobile(context) ? double.infinity : 180,
                    )),
              ],
            ),
          if (type == "Investor")
            Row(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        type2 = "Individual";
                        box.put('onboardInvestorType', type2);
                      });
                      Beamer.of(context).beamToNamed('/select-country');
                    },
                    child: Image.asset(
                      "assets/images/Frame 2810.png",
                      width:  Responsive.isMobile(context) ? 170: 180,
                    )),
                SizedBox(
                  width: 25,
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        type2 = "Corporate";
                        box.put('onboardInvestorType', type2);
                      });
                      Beamer.of(context).beamToNamed('/select-country');
                    },
                    child: Image.asset(
                      "assets/images/Frame 2800.png",
                      width: Responsive.isMobile(context) ? 170: 180,
                    )),
              ],
            ),
        ],
      ),
    );
  }
}
