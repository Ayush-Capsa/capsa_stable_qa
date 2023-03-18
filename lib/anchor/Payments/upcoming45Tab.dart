import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/nairaSymbol.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class upcoming45Screen extends StatefulWidget {
  const upcoming45Screen({Key key}) : super(key: key);

  @override
  _upcoming45ScreenState createState() => _upcoming45ScreenState();
}

class _upcoming45ScreenState extends State<upcoming45Screen> {
  List<Widget> card = [];
  bool dataLoaded = false;
  // List<Details> cards;
  paymentsData data;
  List<paymentsInfo> data2;
  void getData(BuildContext context) async {
    var anchorsActions =
    Provider.of<AnchorActionProvider>(context, listen: false);
    data = await anchorsActions.paymentsDueIn45days();
    card.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 36, 287, 32),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          height: 43,
          child: Card(
            color: Color.fromRGBO(245, 251, 255, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 4),
              child: Text(
                'Payments due in 31-45 days',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(51, 51, 51, 1)),
              ),
            ),
          ),
        ),
      ),
    );
    for(int i = 0;i<data.payments.length;i++) {
      card.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 22, 24),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 71,
            child: Card(
              color: Color.fromRGBO(201, 248, 255, 0.76),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 183.5, 0),
                          child: SizedBox(
                            width: 169.5,
                            height: 27,
                            child: Text(
                              data.payments[i].customerName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Color.fromRGBO(51, 51, 51, 1)),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 3.5),
                              child: SizedBox(
                                // width: 106,
                                height: 24,
                                child: Text(
                                    formatCurrency(data.payments[i].amt),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(51, 51, 51, 1)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 320, 0),
                        child: SizedBox(
                          width: 124,
                          height: 24,
                          child: Text(
                            data.payments[i].invNo,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: SizedBox(
                          // width: 106,
                          height: 24,
                          child: Text(
                            data.payments[i].effectiveDueData,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    setState(() {
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
      width: MediaQuery.of(context).size.width / 0.9,
      child: dataLoaded?Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(29, 0, 66, 79),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 689,
              child: Card(
                color: Color.fromRGBO(245, 251, 255, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(121.5, 36, 121.5, 53.5),
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularPercentIndicator(
                          radius: 150,
                          lineWidth: 80,
                          animation: true,
                          percent:  double.parse(data.percentage).floor()/100.0,
                          center: new Text(
                            double.parse(data.percentage).floor().toString()+"%",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.butt,
                          progressColor: Color.fromRGBO(0, 152, 219, 1),
                          backgroundColor: Color.fromRGBO(187, 229, 255, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(76, 0, 76, 53.5),
                      child: SizedBox(
                        height: 27,
                        width: 391,
                        child: RichText(
                          text: TextSpan(
                              text:  double.parse(data.percentage).floor().toString()+"%",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(0, 152, 219, 1)),
                              children: [
                                TextSpan(
                                    text:
                                    'of your Total Payout is due in 31 - 45 days',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontSize: 18))
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 36, 79),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 689,
              child: Card(
                color: Color.fromRGBO(245, 251, 255, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
                elevation: 5,
                child: data.payments.length != 0
                    ? SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: card),
                )
                    : Center(
                  child: Text(
                    'No Payments Due in 31-45 days',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(51, 51, 51, 1)),
                  ),
                ),
              ),
            ),
          )
        ],
      ):Container(
        height: MediaQuery.of(context).size.height,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
