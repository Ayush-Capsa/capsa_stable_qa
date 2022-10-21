import  'package:capsa/admin/widgets/card_widget.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'accts_table.dart';

class TableList extends StatefulWidget {
  final String title;

  const TableList({Key key, this.title}) : super(key: key);
  @override
  _TableListState createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${widget.title}',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 60,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(child: AccountTable()),
                ],
              ),
            ),
          ),
        ));
      }),
    );
  }
}
