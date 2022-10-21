import 'package:capsa/anchor/Mobile_Invoices/approvedTab.dart';
import 'package:capsa/anchor/Mobile_Invoices/pending_tab.dart';
import 'package:capsa/anchor/Mobile_Invoices/rejectedTab.dart';
import 'package:capsa/anchor/Mobile_Invoices/vetted_tab.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class invoicesPage extends StatefulWidget {
  const invoicesPage({Key key}) : super(key: key);

  @override
  _invoicesPageState createState() => _invoicesPageState();
}

int selectedInvoiceTab = 0;

class _invoicesPageState extends State<invoicesPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: selectedInvoiceTab,
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height*0.14
            ),
            child: AppBar(
              backgroundColor: Color.fromRGBO(245, 251, 255, 1),
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Title(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Text(
                              'Hi Stanbic IBTC,',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color.fromRGBO(51, 51, 51, 1)
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 28),
                            child: Text(
                              'Welcome to your dashboard',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color.fromRGBO(130, 130, 130, 1)
                              ),
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Container(
                        width: 28,
                        height: 28,
                        margin: EdgeInsets.fromLTRB(0, 12, 30, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          color: Color.fromRGBO(130, 130, 130, 1),
                          iconSize: 15,
                          onPressed: () {},
                          icon: Icon(Icons.notifications_none),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 20, 0),
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            'assets/images/5982.png'
                          ),
                        ),
                      )
                    ],
                  ),
                  color: Color.fromRGBO(245, 251, 255, 1),
                ),
              ),
              bottom: TabBar(
                labelColor: Color.fromRGBO(51, 51, 51, 1),
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelColor: Color.fromRGBO(130, 130, 130, 1),
                unselectedLabelStyle: TextStyle(fontSize: 12),
                tabs: [
                  Tab(
                    child: Text('Pending'),
                  ),
                  Tab(
                    child: Text('Approved'),
                  ),
                  Tab(
                    child: Text('Rejected'),
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(child: pendingScreen()),
              SingleChildScrollView(child: approvedScreen()),
              SingleChildScrollView(child: rejectedScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
