import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/nairaSymbol.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class upcomingScreen extends StatefulWidget {
  const upcomingScreen({Key key}) : super(key: key);

  @override
  _upcomingScreenState createState() => _upcomingScreenState();
}

class Details {
  String name;
  String invoiceNo;
  String amount;
  String date;
  Details(
    this.name,
    this.invoiceNo,
    this.amount,
    this.date
  );
}


List<Details> temp = [
  new Details('Ardova Plc', 'PO2345454543', 'N 100,000,000,000', 'Oct 13'),
  new Details('Ardova Plc', 'PO2345454543', 'N 100,000,000,000', 'Oct 13'),
  new Details('Ardova Plc', 'PO2345454543', 'N 100,000,000,000', 'Oct 13'),
  new Details('Ardova Plc', 'PO2345454543', 'N 100,000,000,000', 'Oct 13'),
];

class _upcomingScreenState extends State<upcomingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/0.9,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(29, 0, 66, 79),
            child: Container(
              width: MediaQuery.of(context).size.width*0.5,
              height: 689,
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(121.5, 36, 121.5, 53.5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.21,
                        child: CircularPercentIndicator(
                          radius: 150,
                          lineWidth: 80,
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
                      padding: const EdgeInsets.fromLTRB(76, 0, 76, 53.5),
                      child: SizedBox(
                        height: 27,
                        width: 391,
                        child: RichText(
                          text: TextSpan(
                            text: '75% ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(0, 152, 219, 1)
                            ),
                            children: [
                              TextSpan(
                                text: 'of your Total Payout is due in 0 - 7 days',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontSize: 18
                                )
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 500, 48),
                      child: SizedBox(
                        width: 150,
                        height: 43,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          elevation: 10,
                          color: Color.fromRGBO(245, 251, 255, 1),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: Text(
                              'Due Today',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(51, 51, 51, 1)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.45,
                      height: 92,
                      child: Card(
                        color: Color.fromRGBO(245, 251, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 14.5, 133.5, 4),
                                  child: SizedBox(
                                    width: 165.5,
                                    height: 27,
                                    child: Text(
                                      'Ardova Plc',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color.fromRGBO(51, 51, 51, 1)
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 175, 14.5),
                                  child: SizedBox(
                                    width: 124,
                                    height: 24,
                                    child: Text(
                                      'PO2345454543',
                                      style: TextStyle(
                                        color: Color.fromRGBO(130, 130, 130, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    '${currency(context).currencySymbol}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(0, 152, 219, 1)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 32.5, 8, 32.5),
                                  child: SizedBox(
                                    width: 164,
                                    height: 27,
                                    child: Text(
                                      '100,000,000,000',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(0, 152, 219, 1)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 36, 48),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: 313,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 36, 287, 32),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.2,
                            height: 43,
                            child: Card(
                              color: Color.fromRGBO(245, 251, 255, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24, top: 4),
                                child: Text(
                                  'Payments due in 0-7 days',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(51, 51, 51, 1)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 22, 24),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.5,
                            height: 71,
                            child: Card(
                              color: Color.fromRGBO(201, 248, 255, 0.76),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
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
                                              'Ardova Plc',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: Color.fromRGBO(51, 51, 51, 1)
                                              ),
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
                                                    color: Color.fromRGBO(51, 51, 51, 1)
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 3.5),
                                              child: SizedBox(
                                                width: 146,
                                                height: 24,
                                                child: Text(
                                                  '100,000,000,000',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(51, 51, 51, 1)
                                                  ),
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
                                            'PO2345454543',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(130, 130, 130, 1)
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: SizedBox(
                                          width: 48,
                                          height: 24,
                                          child: Text(
                                            'Oct 13',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(51, 51, 51, 1)
                                            ),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 22, 24),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.5,
                            height: 71,
                            child: Card(
                              color: Color.fromRGBO(201, 248, 255, 0.76),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
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
                                              'Ardova Plc',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: Color.fromRGBO(51, 51, 51, 1)
                                              ),
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
                                                    color: Color.fromRGBO(51, 51, 51, 1)
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 3.5),
                                              child: SizedBox(
                                                width: 146,
                                                height: 24,
                                                child: Text(
                                                  '100,000,000,000',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(51, 51, 51, 1)
                                                  ),
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
                                            'PO2345454543',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(130, 130, 130, 1)
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: SizedBox(
                                          width: 48,
                                          height: 24,
                                          child: Text(
                                            'Oct 13',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(51, 51, 51, 1)
                                            ),
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
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 36, 94),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: 313,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 36, 287, 32),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.2,
                            height: 43,
                            child: Card(
                              color: Color.fromRGBO(245, 251, 255, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24, top: 4),
                                child: Text(
                                  'Overdue Payments',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(51, 51, 51, 1)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 22, 24),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.5,
                            height: 71,
                            child: Card(
                              color: Color.fromRGBO(201, 248, 255, 0.76),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
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
                                              'Ardova Plc',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: Color.fromRGBO(51, 51, 51, 1)
                                              ),
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
                                                    color: Color.fromRGBO(51, 51, 51, 1)
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 3.5),
                                              child: SizedBox(
                                                width: 146,
                                                height: 24,
                                                child: Text(
                                                  '100,000,000,000',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(51, 51, 51, 1)
                                                  ),
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
                                            'PO2345454543',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(130, 130, 130, 1)
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: SizedBox(
                                          width: 48,
                                          height: 24,
                                          child: Text(
                                            'Oct 13',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(51, 51, 51, 1)
                                            ),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 22, 24),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.5,
                            height: 71,
                            child: Card(
                              color: Color.fromRGBO(201, 248, 255, 0.76),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
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
                                              'Ardova Plc',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: Color.fromRGBO(51, 51, 51, 1)
                                              ),
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
                                                    color: Color.fromRGBO(51, 51, 51, 1)
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 3.5),
                                              child: SizedBox(
                                                width: 146,
                                                height: 24,
                                                child: Text(
                                                  '100,000,000,000',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(51, 51, 51, 1)
                                                  ),
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
                                            'PO2345454543',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(130, 130, 130, 1)
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: SizedBox(
                                          width: 48,
                                          height: 24,
                                          child: Text(
                                            'Oct 13',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(51, 51, 51, 1)
                                            ),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
