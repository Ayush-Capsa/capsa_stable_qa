import 'package:capsa/anchor/Mobile_Components/Payments_Card.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class upcoming45Days extends StatefulWidget {
  const upcoming45Days({Key key}) : super(key: key);

  @override
  State<upcoming45Days> createState() => _upcoming45DaysState();
}

class _upcoming45DaysState extends State<upcoming45Days> {
  List<Widget> upcoming30daycard = [];
  bool dataLoaded = false;
  bool dataIsEmpty = false;
  // List<Details> cards;
  paymentsData data;
  List<paymentsInfo> data2;
  //paymentsData data3;
  void getData(BuildContext context) async {
    var anchorsActions =
    Provider.of<AnchorActionProvider>(context, listen: false);
    data = await anchorsActions.paymentsDueIn45days();
    //data3 = await anchorsActions.paymentsDueToday();

    upcoming30daycard.add(
      Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.73,
          height: MediaQuery.of(context).size.height * 0.045,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            color: Color.fromRGBO(245, 251, 255, 1),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(
                'Other payments due in 31-45 days',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(51, 51, 51, 1)),
              ),
            ),
          ),
        ),
      ),
    );
    for (int i = 0; i < data.payments.length; i++) {
      upcoming30daycard.add(
        paymentCard(
            name: data.payments[i].customerName,
            date: data.payments[i].effectiveDueData,
            amount: data.payments[i].amt,
            invoiceNo: data.payments[i].invNo,
            context: context),
      );
    }

    setState(() {
      if(upcoming30daycard.length==0)
        dataIsEmpty = true;
      dataLoaded = true;
    });
  }


  @override
  void initState() {
    super.initState();
    getData(context);
    //apiTestfunction();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(245, 251, 255, 1),
      child: dataLoaded?dataIsEmpty?Center(
        child: Text('You have no payemnts due between 31 - 45 days',style:TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(0, 152, 219, 1)),),
      ):SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50))),
                  color: Color.fromRGBO(245, 251, 255, 1),
                  elevation: 10,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Container(
                            width: 150,
                            height: 240,
                            child: CircularPercentIndicator(
                              radius: MediaQuery.of(context).size.width * 0.2,
                              lineWidth: 40,
                              animation: true,
                              percent:
                              double.parse(data.percentage).floor() / 100.0,
                              center: Text(
                                double.parse(data.percentage)
                                    .floor()
                                    .toString() +
                                    "%",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
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
                                text: double.parse(data.percentage)
                                    .floor()
                                    .toString() +
                                    "%",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(0, 152, 219, 1)),
                                children: [
                                  TextSpan(
                                      text:
                                      'of your Total Payout is due in 31 - 45 days',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          fontSize: 10))
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50))),
                  elevation: 10,
                  color: Color.fromRGBO(245, 251, 255, 1),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: upcoming30daycard,

                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}