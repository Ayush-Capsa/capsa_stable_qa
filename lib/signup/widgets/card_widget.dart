import 'package:capsa/common/responsive.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generated/GeneratedAccountBalanceWidget1.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generated/GeneratedAmountWidget.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generated/GeneratedFrame140Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedcardwidget/generated/GeneratedFrame141Widget.dart';

import 'package:capsa/widgets/capsaapp/generatedwidgettemplatewidget/generated/GeneratedVectorWidget2.dart';
import 'package:capsa/widgets/capsaapp/helpers/transform/transform.dart';
import 'package:capsa/widgets/capsaapp/generatedwidgettemplatewidget/generated/GeneratedVectorWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedwidgettemplatewidget/generated/GeneratedVectorWidget1.dart';
import 'package:popover/popover.dart';

class CardWidget extends StatelessWidget {
  final String title, subText, icon, helpText;
  final bool currency;
  final double width;
  final bool isWithDrawCard;
  final Widget withdrawSection;
  final bool addNewBene;

  final color;

  const CardWidget(
      {this.color,
      this.width,
      this.helpText,
      this.title,
      this.subText,
      this.icon,
      this.withdrawSection,
      this.currency,
      this.isWithDrawCard: false,
      this.addNewBene = false,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Responsive.isMobile(context)
            ? (width != null)
                ? width
                : 280
            : (width != null)
                ? width
                : 360.0,
        height: Responsive.isMobile(context) ? 104 : 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Responsive.isMobile(context) ? 20 : 30.0),
            topRight: Radius.circular(Responsive.isMobile(context) ? 20 : 30.0),
            bottomRight:
                Radius.circular(Responsive.isMobile(context) ? 0 : 0.0),
            bottomLeft:
                Radius.circular(Responsive.isMobile(context) ? 20 : 30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(25, 0, 0, 0),
              offset: Offset(4.0, 4.0),
              blurRadius: 5.0,
            ),
            BoxShadow(
              color: Color.fromARGB(255, 255, 255, 255),
              offset: Offset(-1.0, -1.0),
              blurRadius: 0.0,
            )
          ],
          gradient: RadialGradient(
            center: Alignment(-1.0, -1.0),
            radius: 2,
            //stops: [0.0, 1.0],
            colors: [
              Color.fromARGB(193, 200, 248, 255),
              Color.fromARGB(0, 196, 196, 196)
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 0 : 16.0),
          child: Responsive.isMobile(context)
              ? Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  overflow: Overflow.visible,
                  children: [
                      Positioned(
                        left: Responsive.isMobile(context) ? 16 : 24.0,
                        top: Responsive.isMobile(context) ? 33 : 20.0,
                        right: null,
                        bottom: null,
                        width: 38.0,
                        height: 38.0,
                        child: GeneratedFrame140Widget(icon: icon),
                      ),
                      if (withdrawSection != null)
                        Positioned(
                          left: null,
                          top: 20,
                          right: 0,
                          bottom: null,
                          width: addNewBene ? 180.0 : 130.0,
                          height: 40.0,
                          child: withdrawSection,
                        ),
                      Positioned(
                        left: Responsive.isMobile(context) ? 78 : 24.0,
                        top: Responsive.isMobile(context) ? 24 : 90.0,
                        right: null,
                        bottom: null,
                        width: Responsive.isMobile(context) ? 186 : 332.0,
                        height: 83.0,
                        child: GeneratedFrame141Widget(
                          color: color,
                          currency: currency,
                          subText: subText,
                          title: title,
                          helpText: helpText,
                          icon: icon,
                        ),
                      ),
                      if (helpText != null)
                        Positioned(
                          left: null,
                          top: null,
                          right: 10,
                          bottom: 20,
                          width: 24.0,
                          height: 24.0,
                          child: GeneratedIconsWidget(helpText),
                        ),
                    ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GeneratedFrame140Widget(icon: icon),

                    SizedBox(
                      height: 12,
                    ),

                    if (withdrawSection != null)
                      Container(child: withdrawSection),

                    GeneratedAccountBalanceWidget1(title: title),

                    SizedBox(
                      height: 16,
                    ),

                    GeneratedAmountWidget(
                      subText: subText,
                      currency: currency,
                      color: color,
                    ),

                    // GeneratedFrame141Widget(
                    //         color: color,
                    //         currency: currency,
                    //         subText: subText,
                    //         title: title,
                    //         helpText : helpText,
                    //         icon: icon,
                    //       ),

                    if (helpText != null) GeneratedIconsWidget(helpText),
                  ],
                ),
        ));
  }
}

class GeneratedIconsWidget extends StatelessWidget {
  final String helpText;
  const GeneratedIconsWidget(this.helpText, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showPopover(
          context: context,
          transitionDuration: const Duration(milliseconds: 150),
          bodyBuilder: (context) => ListItems(helpText),
          // onPop: () => capsaPrint('Popover was popped!'),
          direction: PopoverDirection.top,
          width: 250,
          height: 100,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
      child: Container(
          width: 24.0,
          height: 24.0,
          child: Image.asset('assets/images/question-Icons.png')),
    );
  }
}

class ListItems extends StatelessWidget {
  final String helpText;

  const ListItems(this.helpText, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Container(
              height: 80,
              child: Center(child: Text(helpText)),
            ),
          ],
        ),
      ),
    );
  }
}
