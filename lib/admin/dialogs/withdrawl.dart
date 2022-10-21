import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/widgets/custom_button.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

showWithdrawalDialog(context, getBankDetails, profileProvider) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      content: WidthDrawClass(getBankDetails, profileProvider),
    ),
  );
}

class WidthDrawClass extends StatefulWidget {
  dynamic getBankDetails;
  dynamic profileProvider;

  WidthDrawClass(this.getBankDetails, this.profileProvider);

  @override
  _WidthDeawClassState createState() => _WidthDeawClassState();
}

class _WidthDeawClassState extends State<WidthDrawClass> {
  var amt;
  var note;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    BankDetails _getBankDetails = widget.getBankDetails;
    return Form(
      key: _formKey,
      child: Container(
        constraints: BoxConstraints(minWidth: 600, maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'ENTER WITHDRAWAL DETAILS',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 25,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    LineAwesomeIcons.remove,
                    size: 30,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              readOnly: true,
              initialValue: _getBankDetails.bene_account_no,
              validator: (val) {
                if (val.toString().isEmpty) {
                  return 'Cannot be empty';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Account No',
                helperText: '',
              ),
            ),
            TextFormField(
              onChanged: (value) {
                amt = value;
              },
              validator: (val) {
                if (val.toString().isEmpty) {
                  return 'Cannot be empty';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                helperText: '',
              ),
            ),
            TextFormField(
              onChanged: (value) {
                note = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Notes(Optional)',
                helperText: '',
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                btnController: _btnController,
                enable: false,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    capsaPrint(
                        widget.profileProvider.getBankDetails.bene_account_no);
                    var _result = await widget.profileProvider.withDrawAmt(
                        amt,
                        note,
                        widget.profileProvider.getBankDetails.bene_account_no);

                    if (_result['res'] == 'success') {
                      Navigator.of(context).pop();
                      var _rData = _result['data'];
                      showToast('Successfully Done!', context);
                      showDialog(
                          context: context,
                          // barrierDismissible: false,
                          builder: (context) => AlertDialog(
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.done,
                                        color: Colors.green,
                                        size: 70,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Success!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            'Message :' + _result['messg'],
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (_rData.length > 0 &&
                                          _rData['amount'] != null)
                                        Text(
                                          'Amount : ₦ ' + _rData['amount'],
                                          textAlign: TextAlign.center,
                                        ),
                                      if (_rData.length > 0 &&
                                          _rData['transferId'] != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (_rData.length > 0 &&
                                          _rData['transferId'] != null)
                                        Text(
                                          'TXNId : ' + _rData['transferId'],
                                          textAlign: TextAlign.center,
                                        ),
                                      if (_rData.length > 0 &&
                                          _rData['status'] != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (_rData.length > 0 &&
                                          _rData['status'] != null)
                                        Text(
                                          'Status : ' + _rData['status'],
                                          textAlign: TextAlign.center,
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MaterialButton(
                                        height: 50,
                                        color: Colors.blue,
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                    } else {
                      Navigator.of(context).pop();
                      // showToast('Error!', context,type: 'error');

                      var _rData = _result['data'];

                      showDialog(
                          context: context,
                          // barrierDismissible: false,
                          builder: (context) => AlertDialog(
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 70,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Error!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          // CircularProgressIndicator(),
                                          // SizedBox(width: 15,),
                                          Text(
                                            "Message : " + _result['messg'],
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      if (_rData.length > 0 &&
                                          _rData['amount'] != null)
                                        Text(
                                          'Amount : ₦ ' + _rData['amount'],
                                          textAlign: TextAlign.center,
                                        ),
                                      if (_rData.length > 0 &&
                                          _rData['transferId'] != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (_rData.length > 0 &&
                                          _rData['transferId'] != null)
                                        Text(
                                          'TXNId : ' + _rData['transferId'],
                                          textAlign: TextAlign.center,
                                        ),
                                      if (_rData.length > 0 &&
                                          _rData['status'] != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (_rData.length > 0 &&
                                          _rData['status'] != null)
                                        Text(
                                          'Status : ' + _rData['status'],
                                          textAlign: TextAlign.center,
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        // height: 50,
                                        // color: Colors.blue,
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                    }
                  } else {
                    _btnController.reset();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAddBeneficiaryDialog(
    context, getBankDetails, bankList, profileProvider) async {
  await showDialog(
    context: context,
    builder: (context) =>
        AddBeneClass(getBankDetails, bankList, profileProvider),
  );
}

class AddBeneClass extends StatefulWidget {
  final dynamic getBankDetails;
  final dynamic bankList;
  final dynamic profileProvider;

  AddBeneClass(this.getBankDetails, this.bankList, this.profileProvider);

  @override
  _AddBeneClassState createState() => _AddBeneClassState();
}

class _AddBeneClassState extends State<AddBeneClass> {
  BankList _tmpBankDetails = BankList('', 'Select Bank Name from Dropdown');

  BankList bank;
  var accountNo1;
  var accountNo2;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        content: Container(
          constraints: const BoxConstraints(minWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'ADD BENEFICIARY DETAILS',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 25,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      LineAwesomeIcons.remove,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<BankList>(
                validator: (BankList val) {
                  capsaPrint('$val');
                  if (val == null || val.code.isEmpty) {
                    return 'Cannot be empty';
                  }
                  return null;
                },
                // value: _tmpBankDetails,
                items: widget.bankList
                    .map<DropdownMenuItem<BankList>>(
                        (data) => new DropdownMenuItem<BankList>(
                              value: data,
                              child: Text(data.name),
                            ))
                    .toList(),
                onChanged: (BankList newValue) {
                  bank = newValue;
                },
                decoration: InputDecoration(
                    helperText: '',
                    labelText: "Select Bank Name from Dropdown"),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                onChanged: (value) => accountNo1 = value,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (val) {
                  if (val.toString().isEmpty) {
                    return 'Cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  helperText: '',
                ),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                onChanged: (value) => accountNo2 = value,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (val) {
                  if (val.toString().isEmpty) {
                    return 'Cannot be empty';
                  }
                  if (accountNo2 != accountNo1) {
                    return 'Account numbers should match';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Re-Enter Account Number',
                  helperText: '',
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  btnController: _btnController,
                  enable: false,
                  buttonText: "Add new",
                  // child: Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: const Text(
                  //     'Add New',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),

                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var _result = await widget.profileProvider
                          .addBeneCall(bank, accountNo1, accountNo2);

                      if (_result['res'] == 'success') {
                        _btnController.reset();
                        Navigator.of(context).pop();
                        showToast('Added beneficiary successfully!', context);
                      } else {
                        showToast(
                            'Unable to add Beneficiary Account! Try again.',
                            context,
                            type: 'error');
                        _btnController.reset();
                      }
                    } else {
                      _btnController.reset();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
