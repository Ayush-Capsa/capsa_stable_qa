import 'package:capsa/anchor/Components/nairaSymbol.dart';
import 'package:capsa/anchor/Mobile_Components/Payments_Card.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
// import 'package:universal_html/html.dart';

class upcoming7Days extends StatefulWidget {
  const upcoming7Days({Key key}) : super(key: key);

  @override
  State<upcoming7Days> createState() => _upcoming7DaysState();
}

class _upcoming7DaysState extends State<upcoming7Days> {
  List<Widget> upcoming7daycard = [];
  List<Widget> unpaidPaymentsCard = [];
  List<Widget> dueTodayCard = [];
  bool dataLoaded = false;
  // List<Details> cards;
  paymentsData data;
  List<paymentsInfo> data2;
  //paymentsData data3;
  void getData(BuildContext context) async {
    var anchorsActions =
        Provider.of<AnchorActionProvider>(context, listen: false);
    data = await anchorsActions.get7DaysUpcomingPayments();
    data2 = await anchorsActions.unpaidAfterDueDate();
    //data3 = await anchorsActions.paymentsDueToday();

    upcoming7daycard.add(
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
                'Other payments due in 0-7 days',
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
      upcoming7daycard.add(
        paymentCard(
            name: data.payments[i].customerName,
            date: data.payments[i].effectiveDueData,
            amount: data.payments[i].amt,
            invoiceNo: data.payments[i].invNo,
            context: context),
      );
    }

    unpaidPaymentsCard.add(
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.045,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(15))),
              color: Color.fromRGBO(245, 251, 255, 1),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  'Overdue payments',
                  style: TextStyle(
                      fontSize:
                      MediaQuery.of(context).size.width <
                          400
                          ? 12
                          : 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              ),
            ),
          ),
        ),
    );

    for (int i = 0; i < data2.length; i++) {
      unpaidPaymentsCard.add(
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 0, 22, 24),
        //   child: SizedBox(
        //     width: MediaQuery.of(context).size.width * 0.5,
        //     height: 71,
        //     child: Card(
        //       color: Color.fromRGBO(201, 248, 255, 0.76),
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(20))),
        //       child: Column(
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.only(top: 4),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(20, 0, 183.5, 0),
        //                   child: SizedBox(
        //                     width: 169.5,
        //                     height: 27,
        //                     child: Text(
        //                       data2[i].customerName,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.w400,
        //                           fontSize: 18,
        //                           color: Color.fromRGBO(51, 51, 51, 1)),
        //                     ),
        //                   ),
        //                 ),
        //                 Row(
        //                   children: [
        //                     Padding(
        //                       padding: EdgeInsets.only(right: 4, bottom: 2),
        //                       child: Text(
        //                         '${currency(context).currencySymbol}',
        //                         style: TextStyle(
        //                             fontSize: 16,
        //                             fontWeight: FontWeight.w600,
        //                             color: Color.fromRGBO(51, 51, 51, 1)),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.fromLTRB(0, 0, 8, 3.5),
        //                       child: SizedBox(
        //                         width: 106,
        //                         height: 24,
        //                         child: Text(
        //                           data2[i].amt,
        //                           style: TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.w600,
        //                               color: Color.fromRGBO(51, 51, 51, 1)),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 )
        //               ],
        //             ),
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(20, 0, 320, 0),
        //                 child: SizedBox(
        //                   width: 124,
        //                   height: 24,
        //                   child: Text(
        //                     data2[i].invNo,
        //                     style: TextStyle(
        //                         fontSize: 16,
        //                         fontWeight: FontWeight.w600,
        //                         color: Color.fromRGBO(130, 130, 130, 1)),
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        //                 child: SizedBox(
        //                   width: 78,
        //                   height: 24,
        //                   child: Text(
        //                     data2[i].effectiveDueData,
        //                     style: TextStyle(
        //                         fontSize: 16,
        //                         fontWeight: FontWeight.w600,
        //                         color: Color.fromRGBO(51, 51, 51, 1)),
        //                   ),
        //                 ),
        //               )
        //             ],
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        paymentCard(
            name: data2[i].customerName,
            date: data2[i].effectiveDueData,
            amount: data2[i].amt,
            invoiceNo: data2[i].invNo,
            context: context),
      );
    }

    // if(data3!=null){
    //   dueTodayCard.add(Padding(
    //     padding: const EdgeInsets.fromLTRB(16, 0, 500, 48),
    //     child: SizedBox(
    //       width: 150,
    //       height: 43,
    //       child: Card(
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(15))
    //         ),
    //         elevation: 10,
    //         color: Color.fromRGBO(245, 251, 255, 1),
    //         child: Padding(
    //           padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
    //           child: Text(
    //             'Due Today',
    //             style: TextStyle(
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.w600,
    //                 color: Color.fromRGBO(51, 51, 51, 1)
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),);
    //   for(int i = 0;i<data3.payments.length;i++){
    //     dueTodayCard.add(Container(
    //       width: MediaQuery.of(context).size.width*0.45,
    //       height: 92,
    //       child: Card(
    //         color: Color.fromRGBO(245, 251, 255, 1),
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(20))
    //         ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Column(
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(16, 14.5, 133.5, 4),
    //                   child: SizedBox(
    //                     width: 165.5,
    //                     height: 27,
    //                     child: Text(
    //                       data3.payments[i].customerName,
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w600,
    //                           fontSize: 16,
    //                           color: Color.fromRGBO(51, 51, 51, 1)
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(16, 0, 175, 14.5),
    //                   child: SizedBox(
    //                     width: 124,
    //                     height: 24,
    //                     child: Text(
    //                       data3.payments[i].invNo,
    //                       style: TextStyle(
    //                           color: Color.fromRGBO(130, 130, 130, 1),
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.w600
    //                       ),
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(top: 4),
    //                   child: Text(
    //                     '${currency(context).currencySymbol}',
    //                     style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.w600,
    //                         color: Color.fromRGBO(0, 152, 219, 1)
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(4, 32.5, 8, 32.5),
    //                   child: SizedBox(
    //                     width: 164,
    //                     height: 27,
    //                     child: Text(
    //                       data3.payments[i].amt,
    //                       style: TextStyle(
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.w600,
    //                           color: Color.fromRGBO(0, 152, 219, 1)
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //     ));
    //   }
    // }

    setState(() {
      dataLoaded = true;
    });
  }

  void apiTestfunction() async {
    var anchorsActions =
        Provider.of<AnchorActionProvider>(context, listen: false);
    data = await anchorsActions.unpaidAfterDueDate();
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
      child: dataLoaded?SingleChildScrollView(
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
                                          'of your Total Payout is due in 0 - 7 days',
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
                height: MediaQuery.of(context).size.height * 0.28,
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
                      children: upcoming7daycard,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.28,
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
                      children: unpaidPaymentsCard,
                      // [
                      //   Padding(
                      //     padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                      //     child: Container(
                      //       width: MediaQuery.of(context).size.width * 0.5,
                      //       height: MediaQuery.of(context).size.height * 0.045,
                      //       child: Card(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius:
                      //                 BorderRadius.all(Radius.circular(15))),
                      //         color: Color.fromRGBO(245, 251, 255, 1),
                      //         elevation: 5,
                      //         child: Padding(
                      //           padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                      //           child: Text(
                      //             'Overdue payments',
                      //             style: TextStyle(
                      //                 fontSize:
                      //                     MediaQuery.of(context).size.width <
                      //                             400
                      //                         ? 12
                      //                         : 14,
                      //                 fontWeight: FontWeight.w500,
                      //                 color: Color.fromRGBO(51, 51, 51, 1)),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   paymentCard(
                      //       name: 'Ardova Plc',
                      //       date: 'Oct 13',
                      //       amount: '100,000,000,000',
                      //       invoiceNo: 'PO2345454543',
                      //       context: context),
                      //   paymentCard(
                      //       name: 'Ardova Plc',
                      //       date: 'Oct 13',
                      //       amount: '100,000,000,000',
                      //       invoiceNo: 'PO2345454543',
                      //       context: context)
                      // ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ):const Center(child: CircularProgressIndicator(),),
    );
  }
}
