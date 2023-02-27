import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/signup/widgets/StackColumnSwitch.dart';
import 'package:capsa/signup/widgets/capsalogo.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';

class SelectCountry extends StatelessWidget {
  SelectCountry({Key key}) : super(key: key);
  final box = Hive.box('capsaBox');
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Responsive.isMobile(context)
          ? BoxDecoration(
              color: HexColor("#0098DB"),
            )
          : BoxDecoration(),
      child: Form(
        key: formKey,
        child: Padding(
          padding: Responsive.isMobile(context)
              ? EdgeInsets.zero
              : EdgeInsets.fromLTRB(45, 30, 45, 1),
          child: Padding(
            padding: Responsive.isMobile(context)
                ? EdgeInsets.zero
                : EdgeInsets.only(left: 8.0, right: 8),
            child: StackColumnSwitch(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isMobile(context))
                  Positioned(top: 33, child: CapsaLogoImage()),
                if (Responsive.isMobile(context))
                  Positioned(
                    bottom: 0,
                    child: MobileBGWhiteContainer(
                      child: _myWid(context),
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  )
                else
                  _myWid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myWid(context) {
    String type = "";
    String type2 = "";
    String text1 = "Get started on";
    String text2 = "Capsa";
    String text3 = "Capsa";
    final anchorController = TextEditingController(text: '');

    type = box.get('onboardType') ?? '';
    type2 = box.get('onboardInvestorType') ?? '';
    if (type == "Vendor") {
      text1 = "Enjoy Invoice Discounting";
      text2 = "Sign up on";
    } else if (type == "Investor") {
      text1 = "Invest in discounted invoices.";
      text2 = "Sign up on";
    }
    var anchorNameList = [];
    var anchor;
    var term = ["Nigeria", "Ghana (Coming soon)", "Kenya (Coming soon)"];
    final disabledItems = ['Ghana (Coming soon)', 'Kenya (Coming soon)'];

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontFamily: 'Poppins',
                      fontSize: Responsive.isMobile(context) ? 18 : 22,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      text2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          fontFamily: 'Poppins',
                          fontSize: Responsive.isMobile(context) ? 16 : 20,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                    Text(
                      " Capsa",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: HexColor("#0098DB"),
                          fontFamily: 'Poppins',
                          fontSize: Responsive.isMobile(context) ? 16 : 20,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 400,
            child: UserTextFormField(
              label: "Country",
              hintText: "Select from list",
              textFormField: DropdownButtonFormField(
                isExpanded: true,
                validator: (v) {
                  if (anchorController.text == '') {
                    return "Can't be empty";
                  }
                  return null;
                },
                items: term.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category.toString(),
                      style: TextStyle(
                          color: disabledItems.contains(category)
                              ? Colors.grey
                              : null),
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  // anchor = v;

                  if (!disabledItems.contains(v)) {
                    box.put('selectedCountry', v);
                    Beamer.of(context).beamToNamed('/onboard');
                  }
                },
                value: anchor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Select from list",
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(130, 130, 130, 1),
                      fontSize: 14,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                  contentPadding:
                      const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 12.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
