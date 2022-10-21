import 'package:beamer/beamer.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/main.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/widgets/custom_button.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

showWithdrawalDialog(context, getBankDetails, profileProvider,{bool isBarrierDismissible = true,}) async {

  await showDialog(
    barrierDismissible: isBarrierDismissible,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      backgroundColor: Color.fromRGBO(245, 251, 255, 1),

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
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final accountNoC = TextEditingController(text: '');
  bool isSaving = false;
  bool isWithdrawable = false;

  @override
  Widget build(BuildContext context) {
    double limit = double.parse(widget.profileProvider.totalBalanceToWithDraw.toString());
    BankDetails _getBankDetails = widget.getBankDetails;
    accountNoC.text = _getBankDetails.bene_account_no;
    return Form(
      key: _formKey,
      child: Container(
        constraints: BoxConstraints(minWidth: 600, maxWidth: 600),
        decoration: BoxDecoration(color:  Colors.white38),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Withdraw funds',
                  style: TextStyle(
                    color: HexColor("#219653"),
                    fontSize: 25,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Spacer(),
                // IconButton(
                //   padding: EdgeInsets.zero,
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   icon: Icon(
                //     LineAwesomeIcons.remove,
                //     size: 30,
                //   ),
                // )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            UserTextFormField(
              readOnly: true,
              // initialValue: _getBankDetails.bene_account_no,
              validator: (val) {
                if (val.toString().isEmpty) {
                  return 'Cannot be empty';
                }
                return null;
              },

              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,

              controller: accountNoC,
              label: 'Account number',
              hintText: '',
            ),
            UserTextFormField(
              onChanged: (value) {
                amt = value;
                if(double.parse(value.toString())>limit && value == null){
                  setState(() {
                    isWithdrawable = false;
                  });
                }else{
                  setState(() {
                    isWithdrawable = true;
                  });
                }
              },
              validator: (val) {
                if (val.toString().isEmpty) {
                  isWithdrawable = false;
                  return 'Cannot be empty';
                }

                if(double.parse(val.toString())>limit){
                  return 'Withdrawal amount greater than available amount';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              label: 'Amount',
              hintText: '',
            ),
            UserTextFormField(
              onChanged: (value) {
                note = value;
              },
              validator: (v){
                return null;

              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              label: 'Notes (Optional)',
              hintText: '',
            ),
            Align(
              alignment: Alignment.center,
              child: CustomButton2(
                enable: isWithdrawable?true:false,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    capsaPrint(widget.profileProvider.getBankDetails.bene_account_no);
                    var _result = await widget.profileProvider.withDrawAmt(amt, note, widget.profileProvider.getBankDetails.bene_account_no);

                    if (_result['res'] == 'success') {
                      Navigator.of(context).pop();
                      var _rData = _result['data'];
                      showToast('Successfully Done!', context);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
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
                                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Message :' + _result['messg'],
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (_rData.length > 0 && _rData['amount'] != null)
                                        Text(
                                          'Amount : ₦ ' + _rData['amount'],
                                          textAlign: TextAlign.center,
                                        ),
                                      if (_rData.length > 0 && _rData['transferId'] != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (_rData.length > 0 && _rData['transferId'] != null)
                                        Text(
                                          'TXNId : ' + _rData['transferId'],
                                          textAlign: TextAlign.center,
                                        ),
                                      if (_rData.length > 0 && _rData['status'] != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (_rData.length > 0 && _rData['status'] != null)
                                        Text(
                                          'Status : ' + _rData['status'],
                                          textAlign: TextAlign.center,
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // MaterialButton(
                                      //   height: 50,
                                      //   color: Colors.blue,
                                      //   child: Text(
                                      //     'Go Home',
                                      //     style: TextStyle(color: Colors.white),
                                      //   ),
                                      //   onPressed: () {
                                      //     Navigator.pushReplacement(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) => CapsaHome(),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      ElevatedButton(
                                        // height: 50,
                                        // color: Colors.blue,
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          //widget.profileProvider.queryBankTransaction();
                                          Navigator.of(context, rootNavigator: true).pop();
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
                          barrierDismissible: false,
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
                                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                                      if (_rData.length > 0 && _rData['amount'] != null)
                                        Text(
                                          'Amount : ₦ ' + _rData['amount'],
                                          textAlign: TextAlign.center,
                                        ),
                                      if (_rData.length > 0 && _rData['transferId'] != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (_rData.length > 0 && _rData['transferId'] != null)
                                        Text(
                                          'TXNId : ' + _rData['transferId'],
                                          textAlign: TextAlign.center,
                                        ),
                                      if (_rData.length > 0 && _rData['status'] != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (_rData.length > 0 && _rData['status'] != null)
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
                                          //widget.profileProvider.queryBankTransaction();
                                          Navigator.of(context, rootNavigator: true).pop();
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

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Material(
                    elevation: 2,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        color: Colors.red,
                      ),

                      child: Center(
                        child: Text(
                          '<   Back',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
