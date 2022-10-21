import 'package:capsa/anchor/Mobile_Components/Rejected_Card.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class rejectedScreen extends StatefulWidget {
  const rejectedScreen({Key key}) : super(key: key);

  @override
  _rejectedScreenState createState() => _rejectedScreenState();
}

class _rejectedScreenState extends State<rejectedScreen> {
  List<Widget> cards = [];
  bool _dataLoaded = false;
  var _numberOfPages;
  var _currentIndex;
  List<AcctTableData> _acctTable = [];

  void getData(BuildContext context) async {
    var anchorsActions =
    Provider.of<AnchorActionProvider>(context, listen: false);
    _acctTable = await anchorsActions.queryInvoiceList(4);

    for (int i = 0; i < _acctTable.length; i++) {
      cards.add(rejectedCard(
          compName: _acctTable[i].vendor.toString(),
          invoiceNo: _acctTable[i].invNo.toString(),
          date: _acctTable[i].invDate.toString(),
          value: _acctTable[i].invAmt.toString(),
          data: _acctTable[i],
          context1: context));
    }
    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        color: Color.fromRGBO(255, 255, 255, 1),
        child: _dataLoaded?Column(
          children: cards,
        ):Center(child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),),
      ),
    );
  }
}
