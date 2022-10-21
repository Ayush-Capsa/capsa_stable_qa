import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/textStyles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class paidScreen extends StatefulWidget {
  const paidScreen({Key key}) : super(key: key);

  @override
  _paidScreenState createState() => _paidScreenState();
}

class _paidScreenState extends State<paidScreen> {

  final oCcy = NumberFormat("#,##0.00", "en_US");

  List<TableRow> card = [];
  bool dataLoaded = false;
  // List<Details> cards;
  List<paymentsInfo> data;
  void getData(BuildContext context) async {
    var anchorsActions =
    Provider.of<AnchorActionProvider>(context, listen: false);
    data = await anchorsActions.paidPayments();
    card.add( TableRow(children: [
      Container(
        padding: const EdgeInsets.only(top: 5, bottom: 16),
        child: Text('S/N', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(0, 152, 219, 1),
        )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 5, bottom: 16),
        child: Text('Vendor Name', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(0, 152, 219, 1),
        )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 5, bottom: 16),
        child: Text('PO Number', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(0, 152, 219, 1),
        )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 5, bottom: 16),
        child: Text('Invoice Amount', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(0, 152, 219, 1),
        )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 5, bottom: 16),
        child: Text('Date', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(0, 152, 219, 1),
        )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 5, bottom: 16),
        child: Text('Approved By', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(0, 152, 219, 1),
        )),
      ),
    ]),);
    for(int i = 0;i<data.length;i++) {
      card.add(
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text((i+1).toString(), style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(51, 51, 51, 1),
            )),
          ),
          Text(data[i].customerName, style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(51, 51, 51, 1),
          )),
          Text(data[i].invNo, style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(51, 51, 51, 1),
          )),
          Text("₦ "+oCcy.format(double.parse(data[i].amt)), style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(51, 51, 51, 1),
          )),
          Text(data[i].effectiveDueData, style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(51, 51, 51, 1),
          )),
          Text('Olanrewaju A.', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(51, 51, 51, 1),
          )),
        ]),
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
      width: MediaQuery.of(context).size.width/0.9,
      height: MediaQuery.of(context).size.height*0.95,
      child: Card(
        margin: EdgeInsets.fromLTRB(29, 24, 36, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: dataLoaded?Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1.5),
                  4: FlexColumnWidth(1.5),
                  5: FlexColumnWidth(1.5),
                },
                border: TableBorder(verticalInside: BorderSide.none),
                children: card,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(900, 10, 15, 16),
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
        ):Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
