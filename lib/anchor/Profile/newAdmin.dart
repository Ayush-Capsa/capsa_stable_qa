import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class addNewAdmin extends StatefulWidget {
  const addNewAdmin({Key key}) : super(key: key);

  @override
  _addNewAdminState createState() => _addNewAdminState();
}

TextEditingController _emailInput = TextEditingController();
TextEditingController _fNameInput = TextEditingController();
TextEditingController _lNameInput = TextEditingController();
bool privilege1 = false;
bool privilege2 = false;
bool privilege3 = false;
bool privilege4 = false;
bool privilege5 = false;

class _addNewAdminState extends State<addNewAdmin> {
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
                    'Add New Admin',
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
                  height: 59,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Expanded(
                      child: TextFormField(
                        controller: _emailInput,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'name@example.com',
                          hintStyle: TextStyle(
                            fontSize: 18,
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
                  height: 59,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Expanded(
                        child: TextFormField(
                          controller: _fNameInput,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Text Here',
                              hintStyle: TextStyle(
                                  fontSize: 18,
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
                  height: 59,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Expanded(
                        child: TextFormField(
                          controller: _lNameInput,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Text Here',
                              hintStyle: TextStyle(
                                  fontSize: 18,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: privilege4,
                              onChanged: (bool value) {
                                setState(() {
                                  privilege4 = value;
                                });
                              }
                          ),
                          Text(
                            'Vet invoice',
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
                              value: privilege5,
                              onChanged: (bool value) {
                                setState(() {
                                  privilege5 = value;
                                });
                              }
                          ),
                          Text(
                            'mark invoices as paid',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(51, 51, 51, 1)
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 64, 225),
                child: ElevatedButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      fixedSize: Size(400, 59),
                      backgroundColor: Color.fromRGBO(0, 152, 219, 1)
                    ),
                    child: Text(
                      'Add New Admin',
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
