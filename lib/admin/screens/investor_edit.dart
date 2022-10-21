import 'package:capsa/admin/data/investor_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/edit_table_data_provider.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/functions/show_toast.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvestorEdit extends StatefulWidget {
  @override
  _InvestorEditState createState() => _InvestorEditState();
}

class _InvestorEditState extends State<InvestorEdit> {
  DateTime _selectedDate;
  String _foundedValue;
  final dateCont = TextEditingController();
  bool showLoader = false;
  InvestorData data;
  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                surface: Theme.of(context).primaryColor,
                // onSurface: Colors.yellow,
              ),
              // dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      dateCont
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateCont.text.length, affinity: TextAffinity.upstream));
    }
  }

  var role2 = '';

  noFileAlert() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Info",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              content: Container(
                width: 800,
                child: Text("No File uploaded"),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // dismisses only the dialog and returns nothing
                  },
                  child: new Text('Close'),
                ),
              ],
            ));
  }

  setKycManual(kycNo, type) {
    setState(() {
      if (kycNo == 1) {
        if (type == 'accept') {
          data.kyc1 = "2";
          return;
        } else if (type == 'reject') {
          data.kyc1 = "null";
          return;
        }
      }

      if (kycNo == 2) {
        if (type == 'accept') {
          data.kyc2 = "2";
          return;
        } else if (type == 'reject') {
          data.kyc2 = "null";
          return;
        }
      }

      // if (kycNo == 3) {
      //   if (type == 'accept') {
      //     data.kyc3 = "2";
      //     return;
      //   } else if (type == 'reject') {
      //     data.kyc3 = "null";
      //     return;

      //   }
      // }
    });
  }

  openFiles(ActionModel actionModel, _body, name, kycNo) async {
    // capsaPrint(kycNo);
    // capsaPrint(data.kyc1);
    // capsaPrint(data.kyc2);
    // capsaPrint(data.kyc3);

    var approveRequired = false;

    if (kycNo == 1) {
      if (data.kyc1 == 'null') {
        noFileAlert();
        return;
      } else if (data.kyc1 == '1') {
        approveRequired = true;
      }
    }

    if (kycNo == 2) {
      if (data.kyc2 == 'null') {
        noFileAlert();
        return;
      } else if (data.kyc2 == '1') {
        approveRequired = true;
      }
    }

    // if (kycNo == 3) {
    //   if (data.kyc3 == 'null') {
    //     noFileAlert();
    //     return;
    //   } else if (data.kyc3 == '1') {
    //     approveRequired = true;
    //   }
    // }

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              content: Container(
                width: 800,
                child: FutureBuilder<Object>(
                    future: actionModel.getKYCFiles(_body),
                    builder: (context, snapshot) {
                      // capsaPrint(snapshot.data);
                      dynamic _data = snapshot.data;
                      if (snapshot.hasData) {
                        if (_data['res'] == 'success') {
                          var url = _data['data']['url'];

                          // capsaPrint(url);
                          return Column(
                            children: [
                              Expanded(
                                flex: 5,
                                child: SfPdfViewer.network(url),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // if (approveRequired)
                                  ElevatedButton(
                                    onPressed: () async {
                                      await actionModel.approveRejectKYC(
                                          "accept", kycNo, data.bvnNum);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(); // dismisses only the dialog and returns nothing
                                      showToast(
                                          'Successfully Approved', context);
                                      // Provider.of<ActionModel>(context, listen: false).queryVendorView(data.bvnNum);
                                      setState(() {
                                        setKycManual(kycNo, "accept");
                                      });
                                    },
                                    child: new Text('Accept'),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  // if (approveRequired)
                                  ElevatedButton(
                                    onPressed: () async {
                                      await actionModel.approveRejectKYC(
                                          "reject", kycNo, data.bvnNum);

                                      Navigator.of(context, rootNavigator: true)
                                          .pop(); // dismisses only the dialog and returns nothing
                                      showToast(
                                          'Successfully Rejected', context);
                                      // Provider.of<ActionModel>(context, listen: false).queryVendorView(data.bvnNum);
                                      setState(() {
                                        setKycManual(kycNo, "reject");
                                      });
                                    },
                                    child: new Text('Reject'),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      actionModel.downloadFile(url, name: name);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(); // dismisses only the dialog and returns nothing
                                    },
                                    child: new Text('Download'),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(); // dismisses only the dialog and returns nothing
                                    },
                                    child: new Text('Close'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
              actions: <Widget>[],
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final tab = Provider.of<TabBarModel>(context, listen: false);
    data = tab.editTabData;
  }

  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    final _formKey = GlobalKey<FormState>();
    final actionModel = Provider.of<ActionModel>(context);

    // InvestorData _data;

    String title = '';
    int index;

    index = tab.editTabIndex;

    title = tab.editTitle;

    capsaPrint(tab.editTabData);
    // capsaPrint(title);

    if (title == 'InvestorEdit') {
      title = 'BUYER DETAILS';
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(title,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: FutureBuilder<Object>(
          future: Provider.of<ActionModel>(context, listen: false)
              .queryInvestorView(data.bvnNum),
          builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
            if (snapshot.hasData) {
              dynamic _data = snapshot.data;

              if (_data['res'] == 'success') {
                var _resultsData = _data['data'];
                var _requestor = _data['data']['requestor'];
                var _company = _data['data']['company'];

                data.email = _requestor['email'];
                data.contactNumber = _requestor['contact'];
                data.contactNumber = _requestor['contact'];
                data.state = _company['state'];
                data.kyc1 = _company['KYC1'].toString();
                data.kyc2 = _company['KYC2'].toString();
                data.kyc3 = _company['KYC3'].toString();

                data.kyc1File = _company['kyc1_doc'];
                data.kyc2File = _company['kyc2_doc'];
                data.kyc3File = _company['kyc3_doc'];

                role2 = _company['role2'];
              } else {
                return Center(
                  child: Text(_data['messg']),
                );
              }

              return Container(
                padding: MediaQuery.of(context).size.width < 800
                    ? EdgeInsets.fromLTRB(10, 5, 10, 10)
                    : EdgeInsets.fromLTRB(50, 10, 50, 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                readOnly: true,
                                onChanged: (value) {
                                  data.compName = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter this field';
                                  }
                                  return null;
                                },
                                initialValue: data.compName,
                                decoration: InputDecoration(
                                  labelText: 'Company Name',
                                  helperText: '',
                                ),
                              ),
                              TextFormField(
                                readOnly: true,
                                onChanged: (value) {
                                  data.bvnNum = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter this field';
                                  }
                                  return null;
                                },
                                initialValue: data.bvnNum,
                                decoration: InputDecoration(
                                  labelText: 'BVN',
                                  helperText: '',
                                ),
                              ),
                              TextFormField(
                                readOnly: true,
                                onChanged: (value) {
                                  data.cac = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter this field';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: data.cac,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "CAC",
                                  helperText: '',
                                ),
                              ),
                              TextFormField(
                                readOnly: true,
                                onChanged: (value) {
                                  data.email = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter this field';
                                  }
                                  return null;
                                },
                                initialValue: data.email,
                                decoration: InputDecoration(
                                  labelText: 'Email address',
                                  helperText: '',
                                ),
                              ),

                              TextFormField(
                                readOnly: true,
                                onChanged: (value) {
                                  data.contactNumber = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter this field';
                                  }
                                  return null;
                                },
                                initialValue: data.contactNumber,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  helperText: '',
                                ),
                              ),

                              TextFormField(
                                readOnly: true,
                                onChanged: (value) {
                                  data.address = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter this field';
                                  }
                                  return null;
                                },
                                initialValue: data.address,
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  helperText: '',
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              TextFormField(
                                readOnly: true,
                                onChanged: (value) {
                                  data.city = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter this field';
                                  }
                                  return null;
                                },
                                initialValue: data.city,
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  helperText: '',
                                ),
                              ),
                              TextFormField(
                                readOnly: true,
                                onChanged: (value) {
                                  data.state = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter this field';
                                  }
                                  return null;
                                },
                                initialValue: data.state,
                                decoration: InputDecoration(
                                  labelText: 'State',
                                  helperText: '',
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (data.account == null ||
                                      data.account == '')
                                    if (showLoader)
                                      new CircularProgressIndicator()
                                    else
                                      Material(
                                        //Wrap with Material
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0)),
                                        elevation: 18.0,
                                        color: Color(0xFF801E48),
                                        clipBehavior: Clip.antiAlias,
                                        // Add This
                                        child: MaterialButton(
                                          minWidth: 200.0,
                                          height: 35,
                                          color: Color(0xFF801E48),
                                          child: new Text('Create Account',
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white)),
                                          onPressed: () async {
                                            setState(() {
                                              showLoader = true;
                                            });
                                            dynamic result =
                                                await Provider.of<ActionModel>(
                                                        context,
                                                        listen: false)
                                                    .createLendorAccount(data);

                                            if (result['res'] == "success") {
                                              setState(() {
                                                data.account = "true";
                                                showLoader = false;
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Account Successfully Created"),
                                                  action: SnackBarAction(
                                                    label: 'Ok',
                                                    onPressed: () {
                                                      // Code to execute.
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                showLoader = false;
                                              });

                                              showAlertDialog(
                                                  BuildContext context) {
                                                // set up the button
                                                Widget okButton = TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                );

                                                // set up the AlertDialog
                                                AlertDialog alert = AlertDialog(
                                                  title: Text(
                                                      "Error Creating Account"),
                                                  content:
                                                      Text(result['messg']),
                                                  actions: [
                                                    okButton,
                                                  ],
                                                );

                                                // show the dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              }

                                              showAlertDialog(context);
                                            }
                                          },
                                        ),
                                      ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  if (false)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Material(
                                          //Wrap with Material
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.0)),
                                          elevation: 18.0,
                                          color: Colors.green,
                                          clipBehavior: Clip.antiAlias,
                                          // Add This
                                          child: MaterialButton(
                                            minWidth: 200.0,
                                            height: 35,
                                            color: Colors.green,
                                            child: new Text('Accept',
                                                style: new TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white)),
                                            onPressed: () async {
                                              // await Provider.of<ActionModel>(
                                              //         context,
                                              //         listen: false)
                                              //     .vendorAction(
                                              //         data, "APPROVE");
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Material(
                                          //Wrap with Material
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.0)),
                                          elevation: 18.0,
                                          color: Colors.redAccent,
                                          clipBehavior: Clip.antiAlias,
                                          // Add This
                                          child: MaterialButton(
                                            minWidth: 200.0,
                                            height: 35,
                                            color: Colors.redAccent,
                                            child: new Text('Reject',
                                                style: new TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white)),
                                            onPressed: () async {
                                              // await Provider.of<ActionModel>(
                                              //         context,
                                              //         listen: false)
                                              //     .vendorAction(data, "REJECT");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),

                              // TextFormField(
                              //   readOnly: true,
                              //   onChanged: (value) {
                              //     data.keyPerson = value;
                              //   },
                              //   autovalidateMode:
                              //       AutovalidateMode.onUserInteraction,
                              //   validator: (String v) {
                              //     if (v == null || v.isEmpty) {
                              //       return 'Please enter this field';
                              //     }
                              //     return null;
                              //   },
                              //   initialValue: data.keyPerson,
                              //   decoration: InputDecoration(
                              //     labelText: "Key Person",
                              //     helperText: '',
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 40,
                              // ),
                              // TextFormField(
                              //   readOnly: true,
                              //   onChanged: (value) {
                              //     data.industry = value;
                              //   },
                              //   validator: (String v) {
                              //     if (v == null || v.isEmpty) {
                              //       return 'Please enter this field';
                              //     }
                              //     return null;
                              //   },
                              //   autovalidateMode:
                              //       AutovalidateMode.onUserInteraction,
                              //   initialValue: data.industry,
                              //   decoration: InputDecoration(
                              //     labelText: "Industry",
                              //     helperText: '',
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 40,
                              // ),
                              // TextFormField(
                              //   // readOnly: (data.status == 'Not Onboarded') ? false : true,
                              //   readOnly: true,
                              //   controller: dateCont,
                              //   onTap: () {
                              //     _selectDate(context);
                              //   },
                              //   autovalidateMode:
                              //       AutovalidateMode.onUserInteraction,
                              //   keyboardType: TextInputType.number,
                              //   validator: (String v) {
                              //     if (v == null || v.isEmpty) {
                              //       return 'Please select date';
                              //     }
                              //     return null;
                              //   },
                              //   decoration: InputDecoration(
                              //     labelText: ("Founded"),
                              //   ),
                              // ),
                              if (false)
                                MediaQuery.of(context).size.width > 800
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.all(76),
                                        color: Theme.of(context).accentColor,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 2,
                                              right: 2,
                                              child: IconButton(
                                                color: Colors.black,
                                                icon: Icon(
                                                    LineAwesomeIcons.remove),
                                                onPressed: () {},
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                margin: EdgeInsets.all(46),
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              SizedBox(
                                height: 50,
                              ),
                              if (false)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: MaterialButton(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Processing Data')));

                                        var _body = {};

                                        _body['bvnName'] = data.bvnName;
                                        _body['bvnNum'] = data.bvnNum;
                                        _body['email'] = data.email;
                                        _body['compName'] = data.compName;
                                        _body['status'] = data.status;
                                        _body['contactNumber'] =
                                            data.contactNumber;
                                        _body['address'] = data.address;
                                        _body['city'] = data.city;
                                        _body['state'] = data.state;
                                        _body['cac'] = data.cac;
                                        _body['founded'] =
                                            _selectedDate.toString();
                                        _body['keyPerson'] = data.keyPerson;
                                        _body['industry'] = data.industry;

                                        dynamic _data =
                                            await Provider.of<ActionModel>(
                                                    context,
                                                    listen: false)
                                                .setOnBoardData(_body);

                                        ScaffoldMessenger.of(context)
                                            .removeCurrentSnackBar();

                                        if (_data['res'] == 'success') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Successfully On-Boarded')));
                                          tab.changeTab(tab.selectedIndexTmp);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Unable to process. Something Wrong!')));
                                        }
                                      }
                                      return;
                                    },
                                    color: Theme.of(context).accentColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'KYC ',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 32,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                              height: 25,
                            ),
                            if (role2 == "individual")
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        var _body = {'fName': data.kyc1File};
                                        openFiles(
                                            actionModel, _body, "Document", 1);
                                      },
                                      child: Text(
                                        "View Uploaded Document",
                                        style: TextStyle(
                                            color: data.kyc1 != "2"
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .primaryColor,
                                            fontSize: 15),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            if (role2 != "individual")
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        var _body = {'fName': data.kyc1File};
                                        openFiles(actionModel, _body,
                                            "CAC Certificate", 1);
                                      },
                                      child: Text(
                                        "View CAC Certificate",
                                        style: TextStyle(
                                            color: data.kyc1 != "2"
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .primaryColor,
                                            fontSize: 15),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var _body = {'fName': data.kyc2File};

                                      openFiles(actionModel, _body,
                                          "CAC form C07", 2);
                                    },
                                    child: Text(
                                      "View CAC Form 7",
                                      style: TextStyle(
                                          color: data.kyc2 != "2"
                                              ? Colors.red
                                              : Theme.of(context).primaryColor,
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var _body = {'fName': data.kyc3File};

                                      openFiles(
                                          actionModel,
                                          _body,
                                          "National ID card of a Company Director",
                                          3);
                                    },
                                    child: Text(
                                      "View National ID card of a Company Director",
                                      style: TextStyle(
                                          color: data.kyc3 != "2"
                                              ? Colors.red
                                              : Theme.of(context).primaryColor,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(
              child: Text('Loading...'),
            );
          }),
    );
  }
}
