
import 'package:capsa/admin/data/enquiry_list_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/edit_table_data_provider.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EnquiryEdit extends StatefulWidget {
  @override
  _EnquiryEditState createState() => _EnquiryEditState();
}

class _EnquiryEditState extends State<EnquiryEdit> {
  DateTime _selectedDate;
  // String _foundedValue;
  final dateCont = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    final _formKey = GlobalKey<FormState>();
    EnquiryData data;
    // EnquiryData _data;

    String title;
    int index;

    index = tab.editTabIndex;
    data = tab.editTabData;
    title = tab.editTitle;

    if (title == 'Vendor On-boarding') {
      title = title = 'Edit Vendor Details';
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
      body: Container(
        padding: MediaQuery.of(context).size.width < 800
            ? EdgeInsets.fromLTRB(4, 5, 4, 4)
            : EdgeInsets.fromLTRB(50, 10, 50, 50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      // FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: (data.status == 'Not Onboarded')
                                    ? false
                                    : true,
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
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width < 800
                                  ? 5
                                  : 40,
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: (data.status == 'Not Onboarded')
                                    ? false
                                    : true,
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
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: (data.status == 'Not Onboarded')
                                    ? false
                                    : true,
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
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width < 800
                                  ? 5
                                  : 40,
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: (data.status == 'Not Onboarded')
                                    ? false
                                    : true,
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
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: (data.status == 'Not Onboarded')
                                    ? false
                                    : true,
                                onChanged: (value) {
                                  data.bvnName = value;
                                },
                                validator: (String v) {
                                  if (v == null || v.isEmpty) {
                                    // return 'Please enter this field';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: data.bvnName,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "Requestor Name",
                                  helperText: '',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width < 800
                                  ? 5
                                  : 40,
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: (data.status == 'Not Onboarded')
                                    ? false
                                    : true,
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
                            ),
                          ],
                        ),

                        TextFormField(
                          readOnly:
                              (data.status == 'Not Onboarded') ? false : true,
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
                          width:
                              MediaQuery.of(context).size.width < 800 ? 5 : 40,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: (data.status == 'Not Onboarded')
                                    ? false
                                    : true,
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
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width < 800
                                  ? 5
                                  : 40,
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: (data.status == 'Not Onboarded')
                                    ? false
                                    : true,
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
                            ),
                          ],
                        ),

                        TextFormField(
                          readOnly:
                              (data.status == 'Not Onboarded') ? false : true,
                          onChanged: (value) {
                            data.keyPerson = value;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter this field';
                            }
                            return null;
                          },
                          initialValue: data.keyPerson,
                          decoration: InputDecoration(
                            labelText: "Key Person",
                            helperText: '',
                          ),
                        ),
                        // SizedBox(
                        //   width: 40,
                        // ),
                        TextFormField(
                          readOnly:
                              (data.status == 'Not Onboarded') ? false : true,
                          onChanged: (value) {
                            data.industry = value;
                          },
                          validator: (String v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter this field';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: data.industry,
                          decoration: InputDecoration(
                            labelText: "Industry",
                            helperText: '',
                          ),
                        ),
                        // SizedBox(
                        //   width: 40,
                        // ),
                        TextFormField(
                          // readOnly: (data.status == 'Not Onboarded') ? false : true,
                          readOnly: true,
                          controller: dateCont,
                          onTap: () {
                            _selectDate(context);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          validator: (String v) {
                            if (v == null || v.isEmpty) {
                              return 'Please select date';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: ("Founded"),
                          ),
                        ),

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
                                        icon: Icon(LineAwesomeIcons.remove),
                                        onPressed: () {},
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.all(46),
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.width < 800 ? 20 : 50,
                        ),
                        if (data.status == 'Not Onboarded')
                          Align(
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Processing Data')));

                                  var _body = {};

                                  _body['bvnName'] = data.bvnName;
                                  _body['bvnNum'] = data.bvnNum;
                                  _body['email'] = data.email;
                                  _body['compName'] = data.compName;
                                  _body['role2'] = data.role2;
                                  _body['role'] = data.role;
                                  _body['status'] = data.status;
                                  _body['contactNumber'] = data.contactNumber;
                                  _body['address'] = data.address;
                                  _body['city'] = data.city;
                                  _body['state'] = data.state;
                                  _body['cac'] = data.cac;
                                  _body['founded'] = _selectedDate.toString();
                                  _body['keyPerson'] = data.keyPerson;
                                  _body['industry'] = data.industry;

                                  // capsaPrint(_body);
                                  // return;
                                  dynamic _data =
                                      await Provider.of<ActionModel>(context,
                                              listen: false)
                                          .setOnBoardData(_body);

                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();

                                  if (_data['res'] == 'success') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Successfully On-Boarded')));
                                    tab.changeTab(tab.selectedIndexTmp);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Unable to process. Something Wrong!')));
                                  }
                                }
                                return;
                                // BuyerVendorListData element = BuyerVendorListData(
                                //   data.name,
                                //   data.bvnNo,
                                //   data.phoneNo,
                                //   data.email,
                                //   data.address,
                                //   data.city,
                                //   data.state,
                                //   data.action,
                                // );
                                // setState(() {
                                //   // _historyDataSource.data[index] = element;
                                // });
                                // final editTableDataProvider =
                                //     Provider.of<EditTableDataProvider>(context,
                                //         listen: false);

                                // editTableDataProvider.setData(_historyDataSource);
                                // Navigator.of(context).pop();
                                // tab.changeTab(tab.selectedIndexTmp);
                              },
                              color: Theme.of(context).accentColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'On-Board',
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
            ),
            if (false)
              MediaQuery.of(context).size.width < 800
                  ? Container()
                  : Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.all(76),
                        color: Theme.of(context).accentColor,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 2,
                              right: 2,
                              child: IconButton(
                                color: Colors.black,
                                icon: Icon(LineAwesomeIcons.remove),
                                onPressed: () {},
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.all(46),
                                decoration: BoxDecoration(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
          ],
        ),
      ),
    );
  }
}
