import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Invoice/approved.dart';
import 'package:capsa/anchor/Invoice/pending.dart';
import 'package:capsa/anchor/Invoice/rejected.dart';
import 'package:capsa/anchor/Invoice/vetted.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class invoicesScreen extends StatefulWidget {
  const invoicesScreen({Key key}) : super(key: key);

  @override
  _invoicesScreenState createState() => _invoicesScreenState();
}

class _invoicesScreenState extends State<invoicesScreen> {



  var _selectedIndex = 0;
  bool hasInfo = true;
  @override
  Widget build(BuildContext context) {
    var userData = Map<String, dynamic>.from(box.get('userData'));
    return Container(
      width: MediaQuery.of(context).size.width/0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   width: 550,
            //   height: 700,
            //   child: SfPdfViewer.network('https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(29, 38, 24, 26),
                    child: Text(
                        userData['isSubAdmin'].toString() == '0'
                            ? userData['name']
                            : userData['sub_admin_details']
                        ['firstName'] +
                            ' ' +
                            userData['sub_admin_details']
                            ['lastName'],
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(51, 51, 51, 1)
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 58, 24, 58),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications_none),
                      ),
                    ),
                    Image.asset(
                      'images/5982.png',
                      width: 60,
                      height: 60,
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 0, 36, 0),
              child: Container(
                width: MediaQuery.of(context).size.width*1.12,
                child: Card(
                  shadowColor: Colors.black,
                  color: Color.fromRGBO(245, 251, 255, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 250.33, 16),
                        child: TextButton(
                          child: Text(
                              'Pending',
                              style: _selectedIndex == 0?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 250.33, 16),
                        child: TextButton(
                          child: Text(
                              'Approved',
                              style: _selectedIndex == 2 ?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: TextButton(
                          child: Text(
                              'Rejected',
                              style: _selectedIndex == 3 ?
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ) :
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              )),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 3;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _selectedIndex == 0?
                pendingScreen()
                // :
                // _selectedIndex == 1?
                //     vettedScreen()
                    :
                    _selectedIndex == 2?
                        approvedScreen()
                        :
                        rejectedScreen()
          ],
        ),
      ),
    );
  }
}

