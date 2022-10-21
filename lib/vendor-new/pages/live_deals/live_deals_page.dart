import 'package:capsa/common/responsive.dart';
import 'package:capsa/vendor-new/pages/live_deals/widgets/live_deals_box.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:flutter/material.dart';

class LiveDealsPage extends StatefulWidget {
  const LiveDealsPage({Key key}) : super(key: key);

  @override
  State<LiveDealsPage> createState() => _LiveDealsPageState();
}

class _LiveDealsPageState extends State<LiveDealsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: SingleChildScrollView(
        child: Padding(
          padding: Responsive.isMobile(context) ? EdgeInsets.fromLTRB(15, 15, 15, 15) : EdgeInsets.fromLTRB(25, 25, 25, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 22,
              ),
              TopBarWidget("Add Invoice", ""),
              SizedBox(
                height: (!Responsive.isMobile(context)) ? 8 : 15,
              ),
              OrientationSwitcher(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                LiveDealsBox(),
                LiveDealsBox(),
                LiveDealsBox()
              ]),
            ],
          ),
        ),
      ),

    );
  }
}
