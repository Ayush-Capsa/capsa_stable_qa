import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/textStyles.dart';
import 'package:capsa/anchor/Trade/early_payment_requests.dart';
import 'package:capsa/anchor/Trade/history.dart';

class tradeScreen extends StatefulWidget {
  const tradeScreen({Key key}) : super(key: key);

  @override
  _tradeScreenState createState() => _tradeScreenState();
}

class _tradeScreenState extends State<tradeScreen> {

  var _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(),
      /*child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(29, 20, 20, 14),
                child: Text(
                  'Early Payment',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 120, 21),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none),
                ),
              )
            ],
          ),
          Card(
            shadowColor: Colors.black,
            color: Color.fromRGBO(245, 251, 255, 1),
            margin: EdgeInsets.fromLTRB(29, 0, 840, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                  child: TextButton(
                    child: Text(
                        'Early Payment Requests',
                        style: _selectedIndex == 0 
                        tabHighlitedText() :
                        tabNormalText()),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(42, 16, 16, 16),
                  child: TextButton(
                    child: Text(
                        'History',
                        style: _selectedIndex == 1 
                        tabHighlitedText() :
                        tabNormalText()),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          _selectedIndex == 0
          eprScreen()
              :
          historyScreen()
        ],
      ),*/
    );
  }
}
