import 'dart:convert';

import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransferAmount extends StatefulWidget {
  const TransferAmount({Key key}) : super(key: key);

  @override
  _TransferAmountState createState() => _TransferAmountState();
}

class _TransferAmountState extends State<TransferAmount> {
  var _selectedOption = {};
  List _options = [];
  List ledgerAccNamesList = [];
  bool loading = false;
  var _selectedValue;

  var fistRes;

  var from = {};
  var to = {};

  bool showConfirm = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    runOnInit();
  }

  void runOnInit() async {
    dynamic _res = await Provider.of<ProfileProvider>(context, listen: false).getAllAccountList();

    if (_res['res'] == "success") {
      setState(() {
        _options = _res['data']['list'];
      });
    }
  }

  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  void changeOccurs(newValue, type) async {
    if (newValue == null) return;
    int index = _options.indexWhere((e) {
      if (e['account_number'] == newValue) return true;

      return false;
    });

    _selectedOption = _options[index];

    // if (index > 0)
    //   _selectedValue = ledgerAccNamesList[index - 1];
    // else
    //   _selectedValue = null;

    if (type == 'from') {
      from = {
        'pan': _selectedOption['PAN_NO'],
        'account': _selectedOption['account_number'],
      };
    } else if (type == 'to') {
      to = {
        'pan': _selectedOption['PAN_NO'],
        'account': _selectedOption['account_number'],
      };
    }

    // setState(() {
    //   loading = true;
    //
    //
    // });
  }

  final _formKey = GlobalKey<FormState>();

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
                // Expanded(
                //   child: InvoiceScreenCard(
                //     enquiryData: [],
                //     title: widget.title,
                //   ),
                // ),
              ],
            )
          : Container(
              child: SingleChildScrollView(
                child: Padding(
                  padding: Responsive.isDesktop(context) ? const EdgeInsets.fromLTRB(20, 0, 20, 0) : const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              subtitle: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Transfer Amount (one nodal account to another)',
                                  style: TextStyle(fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.bold, letterSpacing: 1),
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
                        height: Responsive.isMobile(context) ? 12 : 20,
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
                        height: Responsive.isMobile(context) ? 8 : 8,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField(
                                  // isExpanded: false,
                                  validator: (value) => value == null ? 'This field is required' : null,

                                  hint: Text('From Account'),
                                  // value: _selectedOption,
                                  onChanged: (newValue) async {
                                    changeOccurs(newValue, 'from');
                                  },
                                  items: _options.map((option) {
                                    return DropdownMenuItem(
                                      child: Text(' ' + option['account_number'].toString() + '[' + option['NAME'] + '] '),
                                      value: option['account_number'].toString(),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: myController2,
                                  // initialValue: 0,
                                  validator: (String v) {
                                    if (v.isEmpty) {
                                      return "Can't be empty";
                                    }
                                    return null;
                                  },

                                  decoration: InputDecoration(
                                    labelText: 'From Narration',
                                    // hintText: 'CAC / Address',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField(
                                  validator: (value) => value == null ? 'This field is required' : null,
                                  // isExpanded: false,
                                  hint: Text('To Account'),
                                  // value: _selectedOption,
                                  onChanged: (newValue) async {
                                    changeOccurs(newValue, 'to');
                                  },
                                  items: _options.map((option) {
                                    return DropdownMenuItem(
                                      child: Text(' ' + option['account_number'].toString() + '[' + option['NAME'] + '] '),
                                      value: option['account_number'].toString(),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: myController3,
                                  // initialValue: 0,
                                  validator: (String v) {
                                    if (v.isEmpty) {
                                      return "Can't be empty";
                                    }
                                    return null;
                                  },

                                  decoration: InputDecoration(
                                    labelText: 'To Narration',
                                    // hintText: 'CAC / Address',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: myController1,
                                  // initialValue: 0,
                                  validator: (String v) {
                                    if (v.isEmpty) {
                                      return "Can't be empty";
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                      try {
                                        final text = newValue.text;
                                        if (text.isNotEmpty) double.parse(text);
                                        return newValue;
                                      } catch (e) {}
                                      return oldValue;
                                    }),
                                  ],

                                  decoration: InputDecoration(
                                    labelText: 'Enter Amount',
                                    // hintText: 'CAC / Address',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (showConfirm)
                                Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Are you sure to transfer ₦' +
                                            myController2.text +
                                            ' from account ' +
                                            from['account'] +
                                            ' to ' +
                                            to['account'] +
                                            ' ?'),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text('Are you sure to transfer ₦' + myController2.text + ' from account ' + from['account'] + ' to ' + to['account'] + ' ?' ),
                                      // ),
                                    ],
                                  ),
                                ),
                              if (!loading)
                                ElevatedButton(
                                    child: Text(showConfirm ? "Confirm" : "Send", style: TextStyle(fontSize: 14)),
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all<Size>(Size(100, 42)),
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero, side: BorderSide(color: Theme.of(context).primaryColor)))),
                                    onPressed: () async {
                                      // capsaPrint(from);
                                      // capsaPrint(to);

                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                          // showConfirm = false;
                                        });
                                        var _body = {};
                                        _body['from'] = jsonEncode(from);
                                        _body['to'] = jsonEncode(to);
                                        _body['amount'] = myController1.text;
                                        _body['narration1'] = myController2.text;
                                        _body['narration2'] = myController3.text;
                                        dynamic _fistRes =
                                            await Provider.of<ProfileProvider>(context, listen: false).transferAmount(_body, confirm: showConfirm);

                                        if (_fistRes['res'] == "success") {
                                          if (showConfirm) {


                                            // set up the button
                                            Widget okButton = TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context, rootNavigator: true).pop();
                                              },
                                            );

                                            // set up the AlertDialog
                                            AlertDialog alert = AlertDialog(
                                              title: Text("Success"),
                                              content: Text("Amount was successfully transferred. "),
                                              actions: [
                                                okButton,
                                              ],
                                            );

                                            // show the dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );

                                            showToast('Successfully Completed', context);
                                            setState(() {
                                              loading = false;
                                              showConfirm = false;
                                              fistRes = null;
                                              from = {};
                                              to = {};
                                              myController1.text = "";
                                              myController2.text = "";
                                              myController3.text = '';
                                            });
                                          } else {
                                            setState(() {
                                              loading = false;
                                              showConfirm = true;
                                              fistRes = _fistRes['data'];
                                            });
                                          }
                                        } else {
                                          // set up the button
                                          Widget okButton = TextButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context, rootNavigator: true).pop();
                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            title: Text("Alert"),
                                            content: Text(_fistRes['messg'] ),
                                            actions: [
                                              okButton,
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );

                                          setState(() {
                                            loading = false;
                                            // showConfirm = false;
                                          });

                                          showToast('Something wrong ', context);
                                        }

                                        // showToast('Invoice Submitted & Presented Successfully!', context);
                                      } else {
                                        showToast('Please fill all details', context, type: 'warning');
                                        setState(() {
                                          loading = false;
                                          // showConfirm = false;
                                        });
                                      }
                                    }),
                              if (loading) SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
