import 'package:capsa/anchor/Mobile_Components/Vetted_Card.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class vettedScreen extends StatefulWidget {
  const vettedScreen({Key key}) : super(key: key);

  @override
  _vettedScreenState createState() => _vettedScreenState();
}

class _vettedScreenState extends State<vettedScreen> {
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
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context),
            vettedCard(compName: 'Pacegate', invoiceNo: 'IN0000001', date: 'Sept 16, 2021', value: '550,000', context1: context)
          ],
        ),
      ),
    );
  }
}
