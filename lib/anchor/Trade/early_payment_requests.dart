import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/textStyles.dart';
import 'package:capsa/anchor/Helpers/dialogHelper.dart';

class eprScreen extends StatefulWidget {
  const eprScreen({Key key}) : super(key: key);

  @override
  _eprScreenState createState() => _eprScreenState();
}

class _eprScreenState extends State<eprScreen> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(29, 24, 36, 33),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(5),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
                4: FlexColumnWidth(3),
                5: FlexColumnWidth(4),
              },
              border: TableBorder(verticalInside: BorderSide.none),
              children: [
                TableRow(children: [
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('S/N', style: tableHeading()),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Vendor Name', style: tableHeading()),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('P.O.Number', style: tableHeading()),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Invoice Amount', style: tableHeading()),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Discounted Amount', style: tableHeading()),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 50),
                    child: Text('Action', style: tableHeading()),
                  ),
                ]),
                TableRow(children: [
                  Text('1', style: tableContent()),
                  Text('Pacegate', style: tableContent()),
                  Text('IN0000001', style: tableContent()),
                  Text('550,000', style: tableContent()),
                  Text('500,000', style: tableContent()),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: TextButton(
                        onPressed: () {
                          dialogHelper.showPayment(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('2', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Noval Systems & Solutions', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('IN0000232', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('100,000,000,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('100,000,000,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35, top: 8),
                    child: TextButton(
                        onPressed: () {
                         // dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Text('3', style: tableContent()),
                  Text('Stanbic IBTC Plc', style: tableContent()),
                  Text('IN\$654672', style: tableContent()),
                  Text('200,000,000', style: tableContent()),
                  Text('200,000,000', style: tableContent()),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: TextButton(
                        onPressed: () {
                          //dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('4', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Delloite Nigeria', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('IN\$654672', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('30,000,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('30,000,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35, top: 8),
                    child: TextButton(
                        onPressed: () {
                          //dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Text('5', style: tableContent()),
                  Text('Mtn', style: tableContent()),
                  Text('IN\$654672', style: tableContent()),
                  Text('298,000,000,000', style: tableContent()),
                  Text('298,000,000,000', style: tableContent()),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: TextButton(
                        onPressed: () {
                         // dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('6', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Noval Systems & Solutions', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('INVG6726', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('300,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('300,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35, top: 8),
                    child: TextButton(
                        onPressed: () {
                         // dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Text('7', style: tableContent()),
                  Text('Stanbic IBTC Plc', style: tableContent()),
                  Text('IN\$654672', style: tableContent()),
                  Text('30,000,000', style: tableContent()),
                  Text('30,000,000', style: tableContent()),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: TextButton(
                        onPressed: () {
                         // dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('8', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Noval Systems & Solutions', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('IN\$654672', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('30,000,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('30,000,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35, top: 8),
                    child: TextButton(
                        onPressed: () {
                         // dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Text('9', style: tableContent()),
                  Text('Pacegate', style: tableContent()),
                  Text('IN\$654672', style: tableContent()),
                  Text('30,000,000', style: tableContent()),
                  Text('30,000,000', style: tableContent()),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: TextButton(
                        onPressed: () {
                          //dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('10', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Stanbic IBTC Plc', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('IN\$654672', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('30,000,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('30,000,000', style: tableContent()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35, top: 8),
                    child: TextButton(
                        onPressed: () {
                         // dialogHelper.show(context);
                        },
                        child: Text(
                          'Mark as paid',
                          style: invoiceView(),
                        )
                    ),
                  )
                ]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(900, 10, 24, 16),
            child: Card(
              color: Color.fromRGBO(245, 251, 255, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: 270,
                height: 56,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 17.5, 24, 17.5),
                      child: Text(
                        'Page',
                        style: TextStyle(fontSize: 14, color: Color.fromRGBO(51, 51, 51, 1)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 17.5, 30, 17.5),
                      child: Text(
                        '1 of 1',
                        style: TextStyle(fontSize: 14, color: Color.fromRGBO(51, 51, 51, 1)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 22, 30, 22),
                      child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios), iconSize: 14, color: Color.fromRGBO(130, 130, 130, 1), padding: EdgeInsets.all(0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 22, 14, 22),
                      child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios), iconSize: 14, color: Color.fromRGBO(130, 130, 130, 1), padding: EdgeInsets.all(0)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
