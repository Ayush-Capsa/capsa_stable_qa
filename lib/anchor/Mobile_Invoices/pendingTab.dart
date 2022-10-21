import 'package:capsa/anchor/Mobile_Components/pending_card.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class pendingScreen extends StatefulWidget {
  const pendingScreen({Key key}) : super(key: key);

  @override
  _pendingScreenState createState() => _pendingScreenState();
}

class _pendingScreenState extends State<pendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Column(
          children: [
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            pendingCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
          ],
        ),
      ),
    );
  }
}
