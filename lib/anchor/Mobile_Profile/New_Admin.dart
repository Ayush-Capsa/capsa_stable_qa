import 'package:capsa/anchor/Mobile_Profile/Admin_Settings.dart';
import 'package:capsa/anchor/Profile/new_admin.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class addAdmin extends StatefulWidget {
  const addAdmin({Key key}) : super(key: key);

  @override
  _addAdminState createState() => _addAdminState();
}

TextEditingController _firstName = TextEditingController();
TextEditingController _lastName = TextEditingController();
TextEditingController _email = TextEditingController();
bool value1 = false;
bool value2 = false;
bool value3 = false;
bool value4 = false;
bool value5 = false;



class _addAdminState extends State<addAdmin> {

  void add(AnchorActionProvider _action,BuildContext context){
    var body = {};
    body['email'] = _email.text;
    body['firstName'] = _firstName.text;
    body['lastName'] = _lastName.text;
    //body['isSuperAdmin'] = "1";
    body['roleBuyInvoice'] = boolToInt(value1).toString();
    body['roleAandRInvoice'] = boolToInt(value2).toString();
    body['roleEditInvoice'] = boolToInt(value3).toString();
    body['roleVentInvoice'] = boolToInt(value4).toString();
    body['roleMarkInvoiceAsPaid'] = boolToInt(value5).toString();

    _action.addAdmin(body);
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    var anchorsActions = Provider.of<AnchorActionProvider>(context,listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height*0.09
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBar(
            backgroundColor: Color.fromRGBO(245, 251, 255, 1),
            leading: IconButton(
              color: Color.fromRGBO(0, 152, 219, 1),
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => adminSettings()));
              },
            ),
            title: Text(
              'Add New Admin',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(51, 51, 51, 1)
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 16),
              child: Text(
                'Email',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(51, 51, 51, 1)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.07,
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'name@example.com',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(130, 130, 130, 1)
                        )
                      ),
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                'First Name',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(51, 51, 51, 1)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.07,
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _firstName,
                      decoration: InputDecoration(
                          hintText: 'Enter first name here',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(130, 130, 130, 1)
                          )
                      ),
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                'Last Name',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(51, 51, 51, 1)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
              child: Container(
                width: MediaQuery.of(context).size.width*0.92,
                height: MediaQuery.of(context).size.height*0.07,
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _lastName,
                      decoration: InputDecoration(
                          hintText: 'Enter last name here',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(130, 130, 130, 1)
                          )
                      ),
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 32, 0, 0),
              child: Text(
                'Select admin privileges',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(51, 51, 51, 1)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 22, 0, 0),
              child: Text(
                'Admin will have access to',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1)
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Checkbox(
                    value: value1,
                    onChanged: (bool value) {
                      setState(() {
                        value1 = value;
                      });
                    },
                  ),
                ),
                Text(
                  'Buy invoice',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Checkbox(
                    value: value2,
                    onChanged: (bool value) {
                      setState(() {
                        value2 = value;
                      });
                    },
                  ),
                ),
                Text(
                  'Approve & Reject invoice',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Checkbox(
                    value: value3,
                    onChanged: (bool value) {
                      setState(() {
                        value3 = value;
                      });
                    },
                  ),
                ),
                Text(
                  'Edit invoice',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Checkbox(
                    value: value4,
                    onChanged: (bool value) {
                      setState(() {
                        value4 = value;
                      });
                    },
                  ),
                ),
                Text(
                  'Vet invoice',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Checkbox(
                    value: value5,
                    onChanged: (bool value) {
                      setState(() {
                        value5 = value;
                      });
                    },
                  ),
                ),
                Text(
                  'Mark invoices as paid',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 22, top: 16),
              child: ElevatedButton(
                onPressed: (){add(anchorsActions, context);},
                child: Text(
                  'Add Admin',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                ),
                style: TextButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width*0.87,
                    MediaQuery.of(context).size.height*0.06
                  ),
                  backgroundColor: Color.fromRGBO(0, 152, 219, 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
