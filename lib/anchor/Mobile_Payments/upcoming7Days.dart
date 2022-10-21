import 'package:capsa/anchor/Components/nairaSymbol.dart';
import 'package:capsa/anchor/Mobile_Components/Payments_Card.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class upcoming7Days extends StatelessWidget {
  const upcoming7Days({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(245, 251, 255, 1),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.4,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50)
                    )
                  ),
                  color: Color.fromRGBO(245, 251, 255, 1),
                  elevation: 10,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Container(
                            width: 150,
                            height: 160,
                            child: CircularPercentIndicator(
                              radius: MediaQuery.of(context).size.width*0.2,
                              lineWidth: 40,
                              animation: true,
                              percent: 0.75,
                              center: new Text(
                                "75%",
                                style:
                                new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              progressColor: Color.fromRGBO(0, 152, 219, 1),
                              backgroundColor: Color.fromRGBO(187, 229, 255, 1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: RichText(
                            text: TextSpan(
                              text: '75% ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(0, 152, 219, 1)
                                ),
                                children: [
                                  TextSpan(
                                      text: 'of your Total Payout is due in 0 - 7 days',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          fontSize: 10
                                      )
                                  )
                                ]
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.045,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                color: Color.fromRGBO(245, 251, 255, 1),
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(32, 4, 32, 4),
                                  child: Text(
                                    'Due Today',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width<400?12: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(51, 51, 51, 1)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.92,
                            height: MediaQuery.of(context).size.height*0.075,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              color: Color.fromRGBO(245, 251, 255, 1),
                              elevation: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Text(
                                      'Ardova Plc',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(51, 51, 51, 1)
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 4, bottom: 2),
                                        child: Text(
                                          '${currency(context).currencySymbol}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(51, 51, 51, 1)
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: Text(
                                          '100,000,000,000',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(51, 51, 51, 1)
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.26,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50)
                    )
                  ),
                  elevation: 10,
                  color: Color.fromRGBO(245, 251, 255, 1),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.73,
                            height: MediaQuery.of(context).size.height*0.045,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              color: Color.fromRGBO(245, 251, 255, 1),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                child: Text(
                                  'Other payments due in 0-7 days',
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width<400?12: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(51, 51, 51, 1)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        paymentCard(name: 'Ardova Plc', date: 'Oct 13', amount: '100,000,000,000', invoiceNo: 'PO2345454543', context: context),
                        paymentCard(name: 'Ardova Plc', date: 'Oct 13', amount: '100,000,000,000', invoiceNo: 'PO2345454543', context: context)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.26,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50)
                      )
                  ),
                  elevation: 10,
                  color: Color.fromRGBO(245, 251, 255, 1),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            height: MediaQuery.of(context).size.height*0.045,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              color: Color.fromRGBO(245, 251, 255, 1),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                                child: Text(
                                  'Overdue payments',
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width<400?12: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(51, 51, 51, 1)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        paymentCard(name: 'Ardova Plc', date: 'Oct 13', amount: '100,000,000,000', invoiceNo: 'PO2345454543', context: context),
                        paymentCard(name: 'Ardova Plc', date: 'Oct 13', amount: '100,000,000,000', invoiceNo: 'PO2345454543', context: context)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
