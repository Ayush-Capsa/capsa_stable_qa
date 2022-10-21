import 'package:capsa/common/responsive.dart';

import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';

import 'package:capsa/models/profile_model.dart';

import 'package:capsa/providers/bid_history_provider.dart';
import 'package:capsa/providers/profile_provider.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AllTransactionHistoryPage extends StatefulWidget {
  AllTransactionHistoryPage({Key key}) : super(key: key);

  @override
  State<AllTransactionHistoryPage> createState() => _ALlAccountPageState();
}

class _ALlAccountPageState extends State<AllTransactionHistoryPage> {
  transactionType(TransactionDetails transactionDetails) {
    if (num.parse(transactionDetails.deposit_amt) > 0) {
      return "Deposit";
    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      return "Withdrawal";
    }
    return "";
  }

  final dateCont = TextEditingController();
  final dateCont2 = TextEditingController();

  transactionIcon(TransactionDetails transactionDetails) {
    if (num.parse(transactionDetails.deposit_amt) > 0) {
      return Image.asset("assets/images/deposite_img.png", width: 38);
    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      return Image.asset(
        "assets/images/withdrawImg.png",
        width: 38,
      );
    }
    return Container(
      width: 0,
    );
  }

  transactionAmount(TransactionDetails transactionDetails) {
    num amt = 0;
    if (num.parse(transactionDetails.deposit_amt) > 0) {
      amt = num.parse(transactionDetails.deposit_amt);
    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      amt = num.parse(transactionDetails.withdrawl_amt);
    }
    return (amt);
  }

  Widget transactionTextWidget2(TransactionDetails transactionDetails) {
    var color = Color.fromRGBO(33, 150, 83, 1);
    if (num.parse(transactionDetails.deposit_amt) > 0) {

    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      color =  HexColor("#EB5757");
    }

    var _text =  Text(
      formatCurrency(transactionAmount(transactionDetails),withIcon: true),
      textAlign: TextAlign.right,
      style: TextStyle(
          color: color,
          fontFamily: 'Poppins',
          fontSize: 14,
          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          fontWeight: FontWeight.normal,
          height: 1),
    );

    return  _text;
  }


  DateTime _selectedDate;
  DateTime _selectedDate2;

  String _type = "All transactions";
  var term = ["All transactions", "Deposit", "Withdrawal"];

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
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
        ..text = DateFormat(' d / M / y').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(offset: dateCont.text.length, affinity: TextAffinity.upstream));
      if (_selectedDate2 != null) setState(() {});
    }
  }

  _selectDate2(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate2 != null ? _selectedDate2 : DateTime.now(),
        firstDate: DateTime(2000),
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
      _selectedDate2 = newSelectedDate;
      dateCont2
        ..text = DateFormat(' d / M / y').format(_selectedDate2)
        ..selection = TextSelection.fromPosition(TextPosition(offset: dateCont2.text.length, affinity: TextAffinity.upstream));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 5 : 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<Object>(
                        future: Provider.of<ProfileProvider>(context, listen: false).queryBankTransaction(date: _selectedDate),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          int i = 0;
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'There was an error :(\n' + snapshot.error.toString(),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            bool addnewbene = false;
                            ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                            final _getBankDetails = _profileProvider.getBankDetails;
                            final _tmpTransactionDetails = _profileProvider.transactionDetails;
                            List _transactionDetails = _tmpTransactionDetails.where((element) {
                              var isDate = false;
                              var isType = false;
                              if (_selectedDate != null) {
                                DateTime createdOn = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(element.created_on);
                                isDate = createdOn.isSameDate(DateTime.now());
                              }

                              if (_type != "All transactions") {
                                isType = false;
                                if (_type == "Deposit") if (num.parse(element.deposit_amt) > 0) {
                                  isType = true;
                                }
                                if (_type == "Withdrawal") if (num.parse(element.withdrawl_amt) > 0) {
                                  isType = true;
                                }
                              } else {
                                isType = true;
                              }
                              // if(isDate){
                              //   return true;
                              // }
                              return isType;
                            }).toList();

                            if (_selectedDate != null && _selectedDate2 != null)
                              _transactionDetails = _tmpTransactionDetails.where((element) {
                                var isDate = false;
                                if (_selectedDate != null && _selectedDate2 != null) {
                                  DateTime createdOn = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(element.created_on);
                                  if (_selectedDate.isBefore(createdOn) && _selectedDate2.isAfter(createdOn)) {
                                    isDate = true;
                                  }
                                }

                                return isDate;
                              }).toList();

                            // _tmpTransactionDetails.forEach((element) {
                            //   transactionDetails.add(value)
                            // });
                            final _bankList = _profileProvider.bankList;
                            if (_getBankDetails.bene_account_no.trim() == '') {
                              addnewbene = true;
                            }
                            return Container(
                              child: Column(
                                children: [
                                  transactionHistory(context, _transactionDetails),
                                ],
                              ),
                            );
                          } else if (!snapshot.hasData) {
                            return Center(child: Text("No history found."));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            height: 70,
            bottom: 0,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              size: 14,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'From',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontSize: 14,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: Colors.black54,
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate2(context);
                      },
                      child: Container(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              size: 14,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'To',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontSize: 14,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: Colors.black54,
                    ),
                    InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                backgroundColor: Color.fromRGBO(245, 251, 255, 1),
                                content: Container(
                                  constraints: Responsive.isMobile(context)
                                      ? BoxConstraints(
                                          minHeight: 200,
                                        )
                                      : BoxConstraints(minHeight: 200, maxWidth: 250),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(245, 251, 255, 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _type = "All transactions";
                                              Navigator.of(context, rootNavigator: true).pop();
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                                            child: Text(
                                              "All transactions",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(

                                                  // fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1.5),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _type = "Deposit";
                                              Navigator.of(context, rootNavigator: true).pop();
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                                            child: Text(
                                              "Deposit",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(

                                                  // fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1.5),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _type = "Withdrawal";
                                              Navigator.of(context, rootNavigator: true).pop();
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                                            child: Text(
                                              "Withdrawal",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(

                                                  // fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'All transactions',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  fontSize: 14,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionHistory(BuildContext context, List transactionDetails) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var transaction in transactionDetails)
                  if (transactionAmount(transaction) > 0)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(),
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              color: Color.fromRGBO(245, 251, 255, 1),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.only(
                                  //     topLeft: Radius.circular(50),
                                  //     topRight: Radius.circular(50),
                                  //     bottomLeft: Radius.circular(50),
                                  //     bottomRight: Radius.circular(50),
                                  //   ),
                                  //   color: Color.fromRGBO(200, 217, 207, 1),
                                  // ),
                                  // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      // Icon(Icons.copy,size: 25,),
                                      transactionIcon(transaction),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                transactionType(transaction),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(51, 51, 51, 1),
                                                    // fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                              SizedBox(height: 3),
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      transaction.order_number,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(51, 51, 51, 1),
                                                          // fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight: FontWeight.normal,
                                                          height: 1),
                                                    ),
                                                    SizedBox(width: 16),
                                                    Text(
                                                      'Successful',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(33, 150, 83, 1),
                                                          // fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight: FontWeight.normal,
                                                          height: 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              transactionTextWidget2(transaction),
                                              SizedBox(height: 3),
                                              Text(
                                                DateFormat('d MMM, y')
                                                    .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(transaction.created_on))
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(51, 51, 51, 1),
                                                    // fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                SizedBox(height: 16),
                // Text(
                //   'View all transactions',
                //   textAlign: TextAlign.right,
                //   style: TextStyle(
                //       color: Color.fromRGBO(0, 152, 219, 1),
                //       fontFamily: 'Poppins',
                //       fontSize: 14,
                //       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                //       fontWeight: FontWeight.normal,
                //       height: 1),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
