import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class MCapsaAcctTransactionCard extends StatelessWidget {
  final String title, date, amount;

  const MCapsaAcctTransactionCard({Key key, this.title, this.date, this.amount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Container(
            decoration: BoxDecoration(
              color: title == 'Debit' ? Color(0xFFafeaed) : Color(0xFF9cdff2),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                title == 'Debit' ? Icons.arrow_downward : Icons.add,
                color: title == 'Debit'
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
          title: Text(
            '$title',
            style: TextStyle(fontFamily: 'Semibold', fontSize: 19),
          ),
          subtitle: Text('22-02-2021'),
          trailing: Text(
            'N2.3m',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 19),
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
