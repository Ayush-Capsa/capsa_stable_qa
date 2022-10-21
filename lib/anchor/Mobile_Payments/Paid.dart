import 'package:capsa/anchor/Mobile_Components/paidCard.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class paidScreen extends StatefulWidget {
  const paidScreen({Key key}) : super(key: key);

  @override
  State<paidScreen> createState() => _paidScreenState();
}

class _paidScreenState extends State<paidScreen> {

  List<Widget> card = [];
  bool dataLoaded = false;
  // List<Details> cards;
  List<paymentsInfo> data;
  void getData(BuildContext context) async {
    var anchorsActions =
    Provider.of<AnchorActionProvider>(context, listen: false);
    data = await anchorsActions.paidPayments();
    for(int i = 0;i<data.length;i++) {
      card.add(
        paidCard(compName: data[i].customerName, invoiceNo: data[i].invNo, date: data[i].effectiveDueData, value: "₦ "+data[i].amt, context1: context),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: dataLoaded?Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        color: Color.fromRGBO(255, 255, 255, 1),
        child: ListView(
          shrinkWrap: true,
          children: card,
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
