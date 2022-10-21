import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:capsa/admin/models/invoice_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class EditBenDetails extends StatefulWidget {
  String panNumber;
  EditBenDetails({Key key,this.panNumber}) : super(key: key);

  @override
  State<EditBenDetails> createState() => _EditBenDetailsState();
}

class _EditBenDetailsState extends State<EditBenDetails> {
  final bankNameController = TextEditingController(text: '');
  final accountNumberController = TextEditingController(text: '');
  final reEnterAccountNumberController = TextEditingController(text: '');
  final accountNameController = TextEditingController(text: '');
  final ifscCodeController = TextEditingController(text: '');
  bool obscureText = true;

  final _formKey = GlobalKey<FormState>();

  String _password = '';
  String _pin = '';
  String _reEnterPin = '';
  String passwordErrorText = '';
  var userData;
  bool dataLoaded = false;

  List<String> terms = [];
  
  String bankName;

  bool isSaving = false;

  List<String> bankNames = [];
  List<String> ifscCodes = [];
  String selectedCurrency = "";

  void updateBankDetails(String panNumber) async{
    String _url = apiUrl + 'admin/';
    dynamic _uri = _url + 'editBeneficiaryDetails';
    var _body = {};
    _body['panNumber'] = panNumber;
    _body['bene_bank'] = bankNameController.text;
    _body['bene_account_number'] = accountNumberController.text;
    _body['bene_account_holder_name'] = accountNameController.text;
    _body['bene_ifsc'] = ifscCodeController.text;
    _body['currency'] = 'NGN';
    capsaPrint("Bank Data initialised $_body \n$_uri");
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    print('Response Update $data');
    if(data['msg'] == 'SUCCESS') {
      showToast("Update Successful", context);
    }else{
      showToast(data['msg'], context, type: 'error');
    }
    Navigator.pop(context);
    capsaPrint("Bank Data $data");
    return data;
  }

  Future getBankName(String panNumber) async {

    String _url = apiUrl + 'admin/';
    dynamic _uri = _url + 'listBankDetailsByPan';
    var _body = {};
    _body['panNumber'] = panNumber;
    capsaPrint("Bank Data initialised");
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    capsaPrint('BankResponse ${_body['panNumber']} $_uri ${response.body}');
    var data = jsonDecode(response.body);

    capsaPrint("\n\n\nBank Data \n\n$data");
    return data;
  }

  Future<dynamic> getBankNames() async {
    dynamic data = await getBankName(widget.panNumber);
    if(data['msg'] == 'success'){
      data['data'].forEach((element){
        //print('\n\nelements : $element');
        terms.add(element['bankname'].toString());
        bankNames.add(element['bankname'].toString());
        ifscCodes.add(element['bankcode'].toString());
      });
    }
    print('terms : $terms');
    setState(() {
      dataLoaded = true;
    });

    return null;
  }



  @override
  void initState() {
    super.initState();
    getBankNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dataLoaded?Row(
        children: [
          Container(
            width: Responsive.isMobile(context) ? 0 : 185,
            height: MediaQuery.of(context).size.height * 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
              ),
              color: Color.fromARGB(255, 15, 15, 15),
            ),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: [
                Positioned(
                    left: 42.5,
                    top: 38.0,
                    right: null,
                    bottom: null,
                    width: 34,
                    height: 34,
                    child: Container(
                      width: 80.0,
                      height: 45,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image.asset(
                            "assets/images/arrow-left.png",
                            color: null,
                            fit: BoxFit.cover,
                            width: 34.0,
                            height: 34,
                            colorBlendMode: BlendMode.dstATop,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
            child: Form(
              key: _formKey,
              child: Responsive.isMobile(context)
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 22,
                          ),
                          // TopBarWidget("Create/Change Transaction Pin", ''),
                          Text(
                            "",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          Container(
                            // height: MediaQuery.of(context).size.height * 0.8,
                            width: Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Update Beneficiary account details',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                UserTextFormField(
                                  label: "Bank Name",
                                  hintText: "Select Bank Name",
                                  textFormField:
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    validator: (v) {
                                      if (bankNameController
                                          .text ==
                                          '') {
                                        return "Can't be empty";
                                      }
                                      return null;
                                    },
                                    items: terms
                                        .map((String category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(category
                                            .toString()),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      bankNameController
                                          .text = bankNames[terms.indexOf(v)];
                                      ifscCodeController.text = ifscCodes[terms.indexOf(v)];
                                      // selectedCurrency = currencies[terms.indexOf(v)];
                                    },
                                    value: bankName,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Select Bank",
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              130, 130, 130, 1),
                                          fontSize: 14,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight:
                                          FontWeight.normal,
                                          height: 1),
                                      contentPadding:
                                      const EdgeInsets.only(
                                          left: 8.0,
                                          bottom: 12.0,
                                          top: 12.0),
                                      focusedBorder:
                                      OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                            Colors.white),
                                        borderRadius:
                                        BorderRadius
                                            .circular(15.7),
                                      ),
                                      enabledBorder:
                                      UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                            Colors.white),
                                        borderRadius:
                                        BorderRadius
                                            .circular(15.7),
                                      ),
                                    ),
                                  ),
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      child: UserTextFormField(
                                        label: "Beneficiary Account Number",
                                        hintText:
                                            "Enter beneficiary account number",
                                        controller: accountNumberController,
                                        // suffixIcon: InkWell(
                                        //     onTap: () {
                                        //       setState(() {
                                        //         obscureText = !obscureText;
                                        //       });
                                        //     },
                                        //     child: Padding(
                                        //       padding:
                                        //           const EdgeInsets.all(8.0),
                                        //       child: Image.asset(
                                        //         "assets/images/eye-Icons.png",
                                        //         height: 14,
                                        //       ),
                                        //     )),
                                        onChanged: (v) {
                                          _password = v;
                                        },
                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return "This field is required.";
                                          }if(v.length!=10){
                                            return "Enter 10 digit account number";
                                          }
                                          return null;
                                        },
                                        // errorText: passwordErrorText,
                                      ),
                                    ),
                                  ],
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      child: UserTextFormField(
                                        label: "Re-Enter Beneficiary Account Number",
                                        hintText:
                                        "Re-Enter beneficiary account number",
                                        controller: reEnterAccountNumberController,
                                        // suffixIcon: InkWell(
                                        //     onTap: () {
                                        //       setState(() {
                                        //         obscureText = !obscureText;
                                        //       });
                                        //     },
                                        //     child: Padding(
                                        //       padding:
                                        //           const EdgeInsets.all(8.0),
                                        //       child: Image.asset(
                                        //         "assets/images/eye-Icons.png",
                                        //         height: 14,
                                        //       ),
                                        //     )),
                                        onChanged: (v) {
                                          _password = v;
                                        },
                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return "This field is required.";
                                          }else if(accountNumberController.text!=reEnterAccountNumberController.text){
                                            return 'Account Numbers don\'t match!';
                                          }else
                                          return null;
                                        },
                                        // errorText: passwordErrorText,
                                      ),
                                    ),
                                  ],
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      child: UserTextFormField(
                                        label: "Beneficiary Account Name",
                                        hintText:
                                            "Enter Beneficiary Account Name",
                                        controller: accountNameController,
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        // inputFormatters: <TextInputFormatter>[
                                        //   FilteringTextInputFormatter.digitsOnly
                                        // ],
                                        onChanged: (v) {},
                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return "This field is required.";
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      child: UserTextFormField(
                                          label: "Bank Code",
                                          //hintText:
                                            //  "Enter beneficiary IFSC code",
                                          controller: ifscCodeController,
                                          keyboardType: TextInputType.number,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          readOnly: true,
                                          onChanged: (v) {},
                                          validator: (v) {
                                            if (v.isEmpty) {
                                              return "This field is required.";
                                              return null;
                                            }
                                          }),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                // if (saving)
                                // Center(
                                // child: CircularProgressIndicator(),
                                // )
                                InkWell(
                                  child: Container(
                                      width: Responsive.isMobile(context)
                                          ? MediaQuery.of(context).size.width *
                                              0.8
                                          : MediaQuery.of(context).size.width *
                                              0.2,
                                      height: 59,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                color: Color.fromRGBO(
                                                    0, 152, 219, 1),
                                              ),
                                              width:
                                                  Responsive.isMobile(context)
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.8
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.2,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 16),
                                              child: Center(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      'Update Beneficiary Details',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 18,
                                                          letterSpacing:
                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ])),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 22,
                        ),
                        //TopBarWidget("Create/Change Transaction Pin", ''),
                        Text(
                          "",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.8,
                          width: Responsive.isMobile(context)
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update Beneficiary Account details',
                                style: GoogleFonts.poppins(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              UserTextFormField(
                                label: "Bank Name",
                                hintText: "Select Bank",
                                // controller: ,
                                textFormField:
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  validator: (v) {
                                    if (bankNameController
                                        .text ==
                                        '') {
                                      return "Can't be empty";
                                    }
                                    return null;
                                  },
                                  items: terms
                                      .map((String category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category
                                          .toString()),
                                    );
                                  }).toList(),
                                  onChanged: (v) {
                                    print(v);
                                    bankNameController
                                        .text = bankNames[terms.indexOf(v)];
                                    //selectedCurrency = currencies[terms.indexOf(v)];
                                    ifscCodeController.text = ifscCodes[terms.indexOf(v)];
                                  },
                                  value: bankName,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Select Bank",
                                    hintStyle: TextStyle(
                                        color: Color.fromRGBO(
                                            130, 130, 130, 1),
                                        fontSize: 14,
                                        letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight:
                                        FontWeight.normal,
                                        height: 1),
                                    contentPadding:
                                    const EdgeInsets.only(
                                        left: 8.0,
                                        bottom: 12.0,
                                        top: 12.0),
                                    focusedBorder:
                                    OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          Colors.white),
                                      borderRadius:
                                      BorderRadius
                                          .circular(15.7),
                                    ),
                                    enabledBorder:
                                    UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          Colors.white),
                                      borderRadius:
                                      BorderRadius
                                          .circular(15.7),
                                    ),
                                  ),
                                ),
                              ),
                              OrientationSwitcher(
                                children: [
                                  Flexible(
                                    child: UserTextFormField(
                                      label: "Beneficiary Account Number",
                                      hintText:
                                      "Enter beneficiary account number",
                                      controller: accountNumberController,
                                      // suffixIcon: InkWell(
                                      //     onTap: () {
                                      //       setState(() {
                                      //         obscureText = !obscureText;
                                      //       });
                                      //     },
                                      //     child: Padding(
                                      //       padding:
                                      //           const EdgeInsets.all(8.0),
                                      //       child: Image.asset(
                                      //         "assets/images/eye-Icons.png",
                                      //         height: 14,
                                      //       ),
                                      //     )),
                                      onChanged: (v) {
                                        _password = v;
                                      },
                                      validator: (v) {
                                        if (v.isEmpty) {
                                          return "This field is required.";
                                        }if(v.length!=10){
                                          return "Enter 10 digit account number";
                                        }
                                        return null;
                                      },
                                      // errorText: passwordErrorText,
                                    ),
                                  ),
                                ],
                              ),
                              OrientationSwitcher(
                                children: [
                                  Flexible(
                                    child: UserTextFormField(
                                      label: "Re-Enter Beneficiary Account Number",
                                      hintText:
                                      "Re-Enter beneficiary account number",
                                      controller: reEnterAccountNumberController,
                                      // suffixIcon: InkWell(
                                      //     onTap: () {
                                      //       setState(() {
                                      //         obscureText = !obscureText;
                                      //       });
                                      //     },
                                      //     child: Padding(
                                      //       padding:
                                      //           const EdgeInsets.all(8.0),
                                      //       child: Image.asset(
                                      //         "assets/images/eye-Icons.png",
                                      //         height: 14,
                                      //       ),
                                      //     )),
                                      onChanged: (v) {
                                        _password = v;
                                      },
                                      validator: (v) {
                                        if (v.isEmpty) {
                                          return "This field is required.";
                                        }else if(accountNumberController.text!=reEnterAccountNumberController.text){
                                          return 'Account Numbers don\'t match!';
                                        }else
                                          return null;
                                      },
                                      // errorText: passwordErrorText,
                                    ),
                                  ),
                                ],
                              ),
                              OrientationSwitcher(
                                children: [
                                  Flexible(
                                    child: UserTextFormField(
                                      label: "Beneficiary Account Name",
                                      hintText:
                                          "Enter Beneficiary Account Name",
                                      controller: accountNameController,
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter.digitsOnly
                                      // ],
                                      onChanged: (v) {},
                                      validator: (v) {
                                        if (v.isEmpty) {
                                          return "This field is required.";
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              OrientationSwitcher(
                                children: [
                                  Flexible(
                                    child: UserTextFormField(
                                      label: "Bank Code",
                                      // hintText: "Enter beneficiary IFSC code",
                                      controller: ifscCodeController,
                                      keyboardType: TextInputType.number,
                                      readOnly: true,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (v) {},
                                      validator: (v) {
                                        if (v.isEmpty) {
                                          return "This field is required.";
                                          return null;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // if (saving)
                              // Center(
                              // child: CircularProgressIndicator(),
                              // )

                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    updateBankDetails(widget.panNumber);
                                  }
                                },
                                child: Container(
                                    width: Responsive.isMobile(context)
                                        ? MediaQuery.of(context).size.width *
                                            0.8
                                        : MediaQuery.of(context).size.width *
                                            0.2,
                                    height: 59,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              ),
                                              color: Color.fromRGBO(
                                                  0, 152, 219, 1),
                                            ),
                                            width: Responsive.isMobile(context)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 16),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    'Update',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            242, 242, 242, 1),
                                                        fontFamily: 'Poppins',
                                                        fontSize: 18,
                                                        letterSpacing:
                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        height: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ])),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          )
        ],
      ):Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator()
        ],
      ),
    );
  }
}
