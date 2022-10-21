import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/show_toast.dart';

import 'package:capsa/common/responsive.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/admin/common/constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ManualSettleInvoiceScreen extends StatefulWidget {
  final String title;

  const ManualSettleInvoiceScreen({Key key, this.title}) : super(key: key);

  @override
  _ManualSettleInvoiceScreenState createState() => _ManualSettleInvoiceScreenState();
}

class _ManualSettleInvoiceScreenState extends State<ManualSettleInvoiceScreen> {
  final cellStyle = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isMobile(context)
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView(
              padding: Responsive.isDesktop(context) ? const EdgeInsets.fromLTRB(20, 0, 20, 0) : const EdgeInsets.fromLTRB(5, 0, 5, 0),
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.title}',
                            style: TextStyle(fontSize: 22, color: Colors.grey[700], fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    Responsive.isDesktop(context)
                        ? Spacer(
                            flex: 3,
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  height: Responsive.isMobile(context) ? 12 : 30,
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).primaryColor,
                    thickness: 0,
                  ),
                ),
                SizedBox(
                  height: Responsive.isMobile(context) ? 12 : 35,
                ),
                Row(
                  children: [
                    Spacer(
                      flex: Responsive.isDesktop(context) ? 4 : 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: Responsive.isMobile(context) ? 8 : 10,
                ),
                SizedBox(
                  height: Responsive.isMobile(context) ? 8 : 10,
                ),
                FutureBuilder(
                    future: Provider.of<ActionModel>(context, listen: false).queryInvoiceForSettlement(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        dynamic _results = [];
                        var i = 0;

                        var _data = snapshot.data;
                        if (_data['res'] == "success") {
                          _results = _data['data']['results'];
                          var _length = _data['data']['length'];
                          if (_length == 0) {
                            return Center(child: Text("No data found for settle"));
                          }
                          capsaPrint(_results);
                        }

                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          color: Colors.white,
                          child: Theme(
                            data: tableTheme,
                            child: DataTable(
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    '#',
                                    style: tableHeadlineStyle,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Invoice',
                                    style: tableHeadlineStyle,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Seller',
                                    style: tableHeadlineStyle,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Anchor',
                                    style: tableHeadlineStyle,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Bid Amount',
                                    style: tableHeadlineStyle,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Start Date',
                                    style: tableHeadlineStyle,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'End Date',
                                    style: tableHeadlineStyle,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Action',
                                    style: tableHeadlineStyle,
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                for (var inv in _results)
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                        (++i).toString(),
                                        style: cellStyle,
                                      )),
                                      DataCell(Text(
                                        inv['invoice_number'].toString(),
                                        style: cellStyle,
                                      )),
                                      DataCell(Text(
                                        inv['company_name'],
                                        style: cellStyle,
                                      )),
                                      DataCell(Text(
                                        inv['customer_name'],
                                        style: cellStyle,
                                      )),
                                      DataCell(Text(
                                        formatCurrency(inv['discount_val'], withIcon: true),
                                        style: cellStyle,
                                      )),
                                      DataCell(Text(
                                        DateFormat('yMMMd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(inv['invoice_date'])).toString(),
                                        style: cellStyle,
                                      )),
                                      DataCell(Text(
                                        DateFormat('yMMMd')
                                            .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(inv['effective_due_date']))
                                            .toString(),
                                        style: cellStyle,
                                      )),
                                      DataCell(
                                        ElevatedButton(
                                          child: Text('Settle'),
                                          onPressed: () {
                                            showAlertDialog(BuildContext context) {
                                              // set up the buttons
                                              Widget cancelButton = TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.red,
                                                ),
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context,rootNavigator: true).pop();
                                                },
                                              );
                                              Widget continueButton = TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.green,
                                                ),
                                                child: Text("Yes"),
                                                onPressed: () async {
                                                  Navigator.of(context,rootNavigator: true).pop();
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return Dialog(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(25.0),
                                                          child: new Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              new CircularProgressIndicator(),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              new Text("Loading..."),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  var _body = {};
                                                  _body['invoice'] = inv['invoice_number'];
                                                  _body['pan'] = inv['company_pan'];

                                                  dynamic _result1 =
                                                      await Provider.of<ActionModel>(context, listen: false).invoiceSettlementApply(_body);

                                                  // capsaPrint(_result1);
                                                  Navigator.of(context,rootNavigator: true).pop();

                                                  if (_result1['res'] == "success") {
                                                    showToast('Successfully Done', context);
                                                    setState(() {});
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(25.0),
                                                            child: new Column(
                                                              // crossAxisAlignment: ,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                new Text(_result1['messg']),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                TextButton(
                                                                  style: TextButton.styleFrom(
                                                                    primary: Colors.blueAccent,
                                                                  ),
                                                                  child: Text("OK"),
                                                                  onPressed: () {
                                                                    Navigator.of(context,rootNavigator: true).pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                              );

                                              // set up the AlertDialog
                                              AlertDialog alert = AlertDialog(
                                                title: Text("Manual Settle Invoice"),
                                                content: Text("Would you like to continue?"),
                                                actions: [
                                                  cancelButton,
                                                  continueButton,
                                                ],
                                              );

                                              // show the dialog
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            }

                                            showAlertDialog(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context).primaryColor,
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                    })
              ],
            ),
    );
  }
}
