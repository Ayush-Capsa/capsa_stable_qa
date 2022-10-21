import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/widgets/custom_button.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Container(
          decoration: BoxDecoration(color: Colors.white38),
          constraints: const BoxConstraints(minWidth: 600),
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Add Beneficiary',
                    style: TextStyle(
                      color: HexColor("#219653"),
                      fontSize: 22,
                      letterSpacing: 0.5,
                      height: 1.2,
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
                label: "Bank Name",
                hintText: "",
                fillColor: Colors.white60,
                textFormField: DropdownButtonFormField<BankList>(
                  validator: (BankList val) {
                    //capsaPrint(val);
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
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white60,
                    hintText: "Select Bank Name from Dropdown",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(130, 130, 130, 1),
                        fontSize: 14,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                    contentPadding: const EdgeInsets.only(
                        left: 8.0, bottom: 12.0, top: 12.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.7),
                    ),
                  ),
                ),
              ),
              UserTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                onChanged: (value) => accountNo1 = value,
                fillColor: Colors.white60,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (val) {
                  if (val.toString().isEmpty) {
                    return 'Cannot be empty';
                  }
                  return null;
                },
                label: 'Account Number',
                hintText: '',
              ),
              UserTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                onChanged: (value) => accountNo2 = value,
                fillColor: Colors.white60,
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
                label: 'Re-Enter Account Number',
                hintText: '',
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  btnController: _btnController,
                  enable: false,
                  buttonText: "Add Beneficiary",
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
