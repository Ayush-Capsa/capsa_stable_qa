import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class editAdmin extends StatefulWidget {
  subAdmin admin;
  var func;
  editAdmin({Key key,@required this.admin,@required this.func}) : super(key: key);

  @override
  _editAdminState createState() => _editAdminState();
}

TextEditingController _emailInput = TextEditingController();
TextEditingController _fNameInput = TextEditingController();
TextEditingController _lNameInput = TextEditingController();
bool privilege1 = false;
bool privilege2 = false;
bool privilege3 = false;
bool privilege4 = false;
bool privilege5 = false;

class _editAdminState extends State<editAdmin> {

  int boolToInt(bool b){
    return b == true?1:0;
  }

  bool intToBool(int n){
    return n == 0?false:true;
  }

  void updateAdmin(BuildContext context){
    var _action =
    Provider.of<AnchorActionProvider>(context, listen: false);
    var body = {};
    body['email'] = _emailInput.text;
    body['firstName'] = _fNameInput.text;
    body['lastName'] = _lNameInput.text;
    //body['isSuperAdmin'] = "1";
    body['roleBuyInvoice'] = boolToInt(privilege1).toString();
    body['roleAandRInvoice'] = boolToInt(privilege2).toString();
    body['roleEditInvoice'] = boolToInt(privilege3).toString();
    body['roleVentInvoice'] = boolToInt(privilege4).toString();
    body['roleMarkInvoiceAsPaid'] = boolToInt(privilege5).toString();

    _action.updateAdmin(body,widget.admin.adminId);
    Navigator.pop(context);

  }

  void initialise(){
    _emailInput.text = widget.admin.email;
    _fNameInput.text = widget.admin.firstName;
    _lNameInput.text = widget.admin.lastName;
    privilege1 = intToBool(widget.admin.roleBuyInvoice);
    privilege2 = intToBool(widget.admin.roleBuyInvoice);
    privilege3 = intToBool(widget.admin.editInvoice);
    setState(() {

    });
  }

  @override
  void initState(){
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width*0.3,
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.7),
        color: Color.fromRGBO(255, 255, 255, 1),
        child: FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 48, 171, 48),
                child: SizedBox(
                  width: 293,
                  height: 54,
                  child: Text(
                    'Edit Admin',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 351, 4),
                child: SizedBox(
                  width: 113,
                  height: 24,
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 64, 16),
                child: SizedBox(
                  width: 400,
                  height: 80,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Expanded(

                      child: UserTextFormField(
                        padding: EdgeInsets.all(0),
                        label: '',
                        // prefixIcon: Image.asset("assets/images/currency.png"),
                        hintText: 'name@example.com',
                        controller: _emailInput,
                        // initialValue: '',
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!validateEmail(value)) {
                            return 'Enter Valid Email address';
                          }

                          return null;
                        },
                        onChanged: (v) {},
                        keyboardType: TextInputType.emailAddress,
                      ),

                      // TextFormField(
                      //   controller: _emailInput,
                      //   decoration: InputDecoration(
                      //       border: InputBorder.none,
                      //       hintText: 'name@example.com',
                      //       hintStyle: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w400,
                      //           color: Color.fromRGBO(130, 130, 130, 1)
                      //       )
                      //   ),
                      // )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 379, 4),
                child: SizedBox(
                  width: 85,
                  height: 24,
                  child: Text(
                    'First Name',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 64, 16),
                child: SizedBox(
                  width: 400,
                  height: 80,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Expanded(
                      child:
                      UserTextFormField(
                        padding: EdgeInsets.all(0),
                        label: '',
                        // prefixIcon: Image.asset("assets/images/currency.png"),
                        hintText: 'Enter Text Here',
                        controller: _fNameInput,
                        // initialValue: '',
                        validator: (value) {
                          return null;
                        },
                        onChanged: (v) {},
                        keyboardType: TextInputType.name,
                      ),
                      // TextFormField(
                      //   controller: _fNameInput,
                      //   decoration: InputDecoration(
                      //       border: InputBorder.none,
                      //       hintText: 'Enter Text Here',
                      //       hintStyle: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w400,
                      //           color: Color.fromRGBO(130, 130, 130, 1)
                      //       )
                      //   ),
                      // )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 379, 4),
                child: SizedBox(
                  width: 85,
                  height: 24,
                  child: Text(
                    'Last Name',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 64, 16),
                child: SizedBox(
                  width: 400,
                  height: 80,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Expanded(
                      child:UserTextFormField(
                        padding: EdgeInsets.all(0),
                        label: '',
                        // prefixIcon: Image.asset("assets/images/currency.png"),
                        hintText: 'Enter Text Here',
                        controller:  _lNameInput,
                        // initialValue: '',
                        validator: (value) {

                          return null;
                        },
                        onChanged: (v) {},
                        keyboardType: TextInputType.name,
                      ),

                      // TextFormField(
                      //   controller: _lNameInput,
                      //   decoration: InputDecoration(
                      //       border: InputBorder.none,
                      //       hintText: 'Enter Text Here',
                      //       hintStyle: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w400,
                      //           color: Color.fromRGBO(130, 130, 130, 1)
                      //       )
                      //   ),
                      // )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 252, 20),
                child: SizedBox(
                  width: 212,
                  height: 27,
                  child: Text(
                    'Select admin privileges',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 210, 24),
                child: SizedBox(
                  width: 280,
                  height: 170,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: privilege1,
                              onChanged: (bool value) {
                                setState(() {
                                  privilege1 = value;
                                });
                              }
                          ),
                          Text(
                            'Buy invoice',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(51, 51, 51, 1)
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: privilege2,
                              onChanged: (bool value) {
                                setState(() {
                                  privilege2 = value;
                                });
                              }
                          ),
                          Text(
                            'Approve & Reject invoice',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(51, 51, 51, 1)
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: privilege3,
                              onChanged: (bool value) {
                                setState(() {
                                  privilege3 = value;
                                });
                              }
                          ),
                          Text(
                            'Edit invoice',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(51, 51, 51, 1)
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Checkbox(
                      //         value: privilege4,
                      //         onChanged: (bool value) {
                      //           setState(() {
                      //             privilege4 = value;
                      //           });
                      //         }
                      //     ),
                      //     Text(
                      //       'Vet invoice',
                      //       style: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w400,
                      //           color: Color.fromRGBO(51, 51, 51, 1)
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Checkbox(
                      //         value: privilege5,
                      //         onChanged: (bool value) {
                      //           setState(() {
                      //             privilege5 = value;
                      //           });
                      //         }
                      //     ),
                      //     Text(
                      //       'mark invoices as paid',
                      //       style: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w400,
                      //           color: Color.fromRGBO(51, 51, 51, 1)
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 64, 50),
                child: ElevatedButton(
                    onPressed: () {
                      updateAdmin(context);
                      //widget.func();
                    },
                    style: TextButton.styleFrom(
                        fixedSize: Size(400, 59),
                        backgroundColor: Color.fromRGBO(0, 152, 219, 1)
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(242, 242, 242, 1)
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 64, 60),
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                        fixedSize: Size(400, 59),
                        backgroundColor: Color.fromRGBO(219, 0, 0, 1.0)
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(242, 242, 242, 1)
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
