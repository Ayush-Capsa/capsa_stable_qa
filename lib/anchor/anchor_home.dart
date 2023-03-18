import 'package:capsa/common/responsive.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/anchor/pages/homepage.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/pages/change_password_vendor_investor.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/buttonStyles.dart';
import 'package:capsa/anchor/Invoice/invoices.dart';
import 'package:capsa/anchor/Payments/payments.dart';
import 'package:capsa/anchor/Profile/profile.dart';
import 'package:capsa/anchor/Trade/trade.dart';
import 'package:provider/provider.dart';

class anchorHomePage extends StatefulWidget {
  const anchorHomePage({Key key}) : super(key: key);

  @override
  State<anchorHomePage> createState() => _anchorHomePageState();
}

class _anchorHomePageState extends State<anchorHomePage> {
  var _selectedIndex = 0;

  void checkPassword() async{
    dynamic response = await Provider.of<AnchorActionProvider>(context, listen: false)
        .checkLastPasswordReset();

    capsaPrint('\n\nCheck passwrod : $response');

    if(response['msg'] != 'success') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            // title: Text(
            //   '',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Theme.of(context).primaryColor,
            //   ),
            // ),
            content: Container(
              // width: 800,
                height: Responsive.isMobile(context)?260:180,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [

                      SizedBox(height: 12,),

                      Text(
                        'Action Required',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),

                      SizedBox(height: 12,),

                      Text(
                        'Password has not been changed for more than 90 days!\nChange password to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 12,),

                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider(
                                    create: (BuildContext
                                    context) =>
                                        ProfileProvider(),
                                    child:ChangePasswordPageVI(canGoBack: false,),),
                            ),
                          );
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                    ],
                  ),
                )
            ),
            //actions: <Widget>[],
          ));
    }
  }

  @override
  void initState(){
    super.initState();
    checkPassword();
  }

  @override
  Widget build(BuildContext context) {
    var anchorsActions = Provider.of<AnchorActionProvider>(context,listen: false);
    anchorsActions.getAllPayments();
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(0),
              height: double.infinity,
              child: FittedBox(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                  )),
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50.5, 36, 50.5, 24),
                        child: SizedBox(
                          width: 80,
                          height: 45.42,
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                        child: SizedBox(
                          width: 157,
                          height: 59,
                          child: TextButton.icon(
                            icon: Icon(Icons.sim_card_outlined),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 33, 16),
                              child: Text('Invoices', style: TextStyle(fontSize: 18)),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            },
                            style: _selectedIndex == 0?
                            selectedButton()
                                :
                            normalButton(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                        child: SizedBox(
                          width: 157,
                          height: 59,
                          child: TextButton.icon(
                            icon: Icon(Icons.credit_card),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 12, 16),
                              child: Text('Payments', style: TextStyle(fontSize: 18)),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            },
                            style: _selectedIndex == 1?
                            selectedButton()
                                :
                            normalButton(),
                          ),
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 12, 24),
                        child: SizedBox(
                          width: 157,
                          height: 59,
                          child: TextButton.icon(
                            icon: Icon(Icons.history),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 38, 16),
                              child: Text('Trade', style: TextStyle(fontSize: 18)),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                            },
                            style: _selectedIndex == 2
                            selectedButton()
                                :
                            normalButton(),
                          ),
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                        child: SizedBox(
                          width: 157,
                          height: 59,
                          child: TextButton.icon(
                            icon: Icon(Icons.person_outline),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 42, 16),
                              child: Text('Profile', style: TextStyle(fontSize: 18)),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                            },
                            style: _selectedIndex == 3?
                            selectedButton()
                                :
                            normalButton(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 474, 12, 45.48),
                        child: SizedBox(
                          width: 157,
                          height: 59,
                          child: TextButton.icon(
                            icon: Icon(Icons.login_outlined, color: Colors.grey),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 27, 16),
                              child: Text('Logout', style: TextStyle(color: Colors.grey, fontSize: 18)),
                            ),
                            onPressed: () {
                              logout(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.88,
              height: double.infinity,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child:
                _selectedIndex == 0?
                invoicesScreen()
                    :
                _selectedIndex == 1?
                paymentScreen()
                    :
                _selectedIndex == 2?
                tradeScreen()
                    :
                profileScreen(),
              ),
            )
          ],
        ),
      ),
    );
  }
}