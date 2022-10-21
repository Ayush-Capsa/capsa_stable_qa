import 'dart:convert';
import 'dart:typed_data';

import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnchorOnboarding extends StatefulWidget {
  @override
  _AnchorOnboardingState createState() => _AnchorOnboardingState();
}

class _AnchorOnboardingState extends State<AnchorOnboarding> {
  List<int> _selectedFile = [];
  Uint8List _bytesData;
  PlatformFile file;

  PlatformFile file2;

  String cName;

  String cac;

  String bvnNo;

  String email;

  String contact;

  String address;

  String city;

  String state;

  String keyPerson;

  String industry;

  String founded;

  String cCode;

  String _title = 'Anchor On-Boarding';

  DateTime _founded;
  final _foundedTextEditingController = TextEditingController();
  final _textEditingController2 = TextEditingController();
  final _textEditingController3 = TextEditingController();

  _selectFoundedDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _founded != null ? _founded : DateTime.now(),
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
      _founded = newSelectedDate;
      _foundedTextEditingController
        ..text = DateFormat.yMMMd().format(_founded)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _foundedTextEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController2.text = '';
    _textEditingController3.text = '';
  }

  final _formKey = GlobalKey<FormState>();

  void submitForm(BuildContext context) async {
    final _actionModel = Provider.of<ActionModel>(context, listen: false);
    final tab = Provider.of<TabBarModel>(context, listen: false);
    Map<String, dynamic> _body = {};

    _body['cName'] = cName;
    _body['cac'] = cac;
    _body['bvnNo'] = bvnNo;
    _body['email'] = email;
    _body['contact'] = contact;
    _body['address'] = address;
    _body['cCode'] = cCode;
    _body['city'] = city;
    _body['state'] = state;
    _body['keyPerson'] = keyPerson;
    _body['industry'] = industry;
    _body['founded'] = _founded.toString();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Processing Data')));

    dynamic _response =
        await _actionModel.anchorOnBoardData(_body, file, file2);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // capsaPrint('Server Response: ' + _response);
    if (_response['res'] == 'success') {
      // var _results = _response['data'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully On-boarded.'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
      tab.changeTab(3);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_response['messg']),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
  }

  // startWebFilePicker(TextEditingController _controller) async {
  //   html.InputElement uploadInput = html.FileUploadInputElement();
  //   uploadInput.multiple = true;
  //   uploadInput.draggable = true;
  //   uploadInput.click();

  //   uploadInput.onChange.listen((e) {
  //     final files = uploadInput.files;
  //     final file = files[0];
  //     capsaPrint(file.relativePath.toString() ?? 'aa');
  //     capsaPrint(file.size.toString());
  //     capsaPrint(file.type);
  //     setState(() {
  //       _controller.text = file.name;
  //     });
  //     final reader = new html.FileReader();

  //     reader.onLoadEnd.listen((e) {
  //       _handleResult(reader.result, _controller);
  //     });
  //     reader.readAsDataUrl(file);
  //   });
  // }

  // void _handleResult(Object result, TextEditingController _controller) {
  //   setState(() {
  //     _bytesData = Base64Decoder().convert(result.toString().split(",").last);
  //     _selectedFile = _bytesData;
  //   });
  // }

  pickFile(TextEditingController controller, bool isProfit) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png'],
    );

    if (result != null) {
      if (result.files.first.extension == 'jpg' ||
          result.files.first.extension == 'png' ||
          result.files.first.extension == 'jpeg' ||
          result.files.first.extension == 'pdf') {
        setState(() {
          isProfit ? file = result.files.first : file2 = result.files.first;

          controller.text = isProfit ? file.name : file2.name;
        });
      } else {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                    'Invalid Format Selected. Please Select Another File'),
                actions: <Widget>[
                  TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context)),
                ],
              );
            });
      }
    } else {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('Error Occured. Please Try Again!'),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context)),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 650),
      padding: MediaQuery.of(context).size.width < 800
          ? EdgeInsets.all(5)
          : const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: MediaQuery.of(context).size.width < 800
              ? Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        cName = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Company Name',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        cac = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'CAC',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        bvnNo = value;
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      // Only numbers can be entered

                      // Only numbers can be entered
                      maxLength: 11,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'BVN No',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        helperText: '',
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: 40,
                            child: TextFormField(
                              onChanged: (value) {
                                cCode = value;
                              },
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // Only numbers can be entered
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Code',
                                hintText: '234',
                                helperText: '',
                                counterText: '',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 8,
                          child: TextFormField(
                            onChanged: (value) {
                              contact = '0' + value;
                            },
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // Only numbers can be entered
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value.length != 10) {
                                return 'Please enter 10 digit mobile number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Phone no',
                              helperText: '',
                              counterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      onChanged: (value) {
                        address = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Address',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        city = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'City',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        state = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'State',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        keyPerson = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Key Person',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        industry = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Industry',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _foundedTextEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTap: () => _selectFoundedDate(context),
                      decoration: InputDecoration(
                        labelText: 'Founded',
                        helperText: '',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTap: () async {
                        return pickFile(_textEditingController2, true);
                      },
                      readOnly: true,
                      controller: _textEditingController2,
                      onChanged: (value) =>
                          _textEditingController2.text = file.name,
                      decoration: InputDecoration(
                          helperText: '',
                          labelText: 'Upload Latest Profit & Loss statement',
                          suffixIcon: Icon(
                            Icons.file_upload,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          )),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      onTap: () async {
                        return pickFile(_textEditingController3, false);
                      },
                      readOnly: true,
                      controller: _textEditingController3,
                      decoration: InputDecoration(
                          helperText: '',
                          labelText: 'Upload Latest Balance Sheet',
                          suffixIcon: Icon(
                            Icons.file_upload,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: MaterialButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            submitForm(context);
                          }
                        },
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Add Anchor',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                )
              // WEB
              : Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _title,
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              cName = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Company Name',
                              helperText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width < 800 ? 5 : 40,
                        ),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              cac = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'CAC',
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // Only numbers can be entered
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              bvnNo = value;
                            },
                            maxLength: 11,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value.length != 11) {
                                return value + ' : Invalid format for BVN';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'BVN No',
                                helperText: '',
                                counterText: ''),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width < 800 ? 5 : 40,
                        ),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              email = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              helperText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  // Only numbers can be entered
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 3,
                                  onChanged: (value) {
                                    cCode = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Code',
                                    hintText: '234', helperText: '',
                                    counterText: '',
                                    // helperText: '',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 8,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  // Only numbers can be entered
                                  maxLength: 10,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    contact = '0' + value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Mobile Number',
                                    counterText: '',
                                    helperText: '',
                                    // helperText: '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width < 800 ? 5 : 40,
                        ),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              address = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Address',
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              city = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'City',
                              helperText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width < 800 ? 5 : 40,
                        ),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              state = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'State',
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              keyPerson = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Key Person',
                              helperText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width < 800 ? 5 : 40,
                        ),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              industry = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Industry',
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _foundedTextEditingController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onTap: () => _selectFoundedDate(context),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Founded',
                              helperText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width < 800 ? 5 : 40,
                        ),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onTap: () async {
                              return pickFile(_textEditingController2, true);
                            },
                            readOnly: true,
                            controller: _textEditingController2,
                            decoration: InputDecoration(
                                helperText: '',
                                labelText:
                                    'Upload Latest Profit & Loss statement',
                                suffixIcon: Icon(
                                  Icons.file_upload,
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                )),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      onTap: () async {
                        return pickFile(_textEditingController3, false);
                      },
                      readOnly: true,
                      controller: _textEditingController3,
                      decoration: InputDecoration(
                          // prefixIcon: Icon(
                          //   Icons.link,
                          //   color: Theme.of(context).primaryColor,
                          //   size: 28,
                          // ),
                          labelText: 'Upload Latest Balance Sheet',
                          helperText: '',
                          suffixIcon: Icon(
                            Icons.file_upload,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: MaterialButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            submitForm(context);
                          }
                        },
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Add Anchor',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
