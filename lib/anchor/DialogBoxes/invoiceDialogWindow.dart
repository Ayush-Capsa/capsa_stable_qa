
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:beamer/beamer.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/page_bgimage.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe96widget/GeneratedFrame96Widget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class dialogBox extends StatelessWidget {
  AcctTableData acctTable;
  dialogBox({Key key,@required this.acctTable}) : super(key: key);
  TextEditingController payableAmountCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    payableAmountCont.text = acctTable.invAmt.toString();
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
      ),
      elevation: 5,
      child: _dialogScreen(context),
    );
  }

  _dialogScreen(BuildContext context) => Container(
    height: 700,
    width: 628,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 353, 35),
          child: Text(
            'Midas Touche',
            style: TextStyle(
              color: Color.fromRGBO(0, 152, 219, 1),
              fontSize: 36,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 448,
              height: 63,
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Invoice',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(51, 51, 51, 1)
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      acctTable.invNo,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 152, 219, 1)
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 130,
              height: 71,
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(51, 51, 51, 1)
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      acctTable.status == 2?"Pending":acctTable.status == 3?"Approved":"Rejected",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Color.fromRGBO(242, 153, 74, 1)
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 4, 4),
          child: Text(
            'Effective Due Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
        Container(
          width: 588,
          height: 72,
          padding: EdgeInsets.only(left: 20),
          child: Card(
            color: Color.fromRGBO(245, 251, 255, 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: Text(
                      'Dec 24, 2020',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(51, 51, 51, 1)
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(320, 20.5, 16, 20.5),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(0, 152, 219, 1),
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 4, 229, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Date on which you are going to pay the vendor.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(235, 87, 87, 1)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'If this is not correct, please change.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(235, 87, 87, 1)
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 25, 463, 4),
          child: Text(
            'Payable Amount',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
        Container(
          width: 588,
          height: 72,
          padding: EdgeInsets.only(left: 20),
          child: Card(
            color: Color.fromRGBO(245, 251, 255, 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 588,
                  height: 72,
                  child: UserTextFormField(
                    label: "Payable Amount",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: payableAmountCont,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        try {
                          final text = newValue.text;
                          if (text.isNotEmpty) double.parse(text);
                          return newValue;
                        } catch (e) {}
                        return oldValue;
                      }),
                    ],
                    hintText: "",
                    padding: EdgeInsets.zero,
                    fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                    errorText: "Date on which you are going to pay the vendor.\nIf this is not correct, please change.",
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.fromLTRB(280, 20.5, 16, 20.5),
                //   child: TextButton(
                //     onPressed: () {},
                //     child: Text(
                //       'Edit',
                //       style: TextStyle(
                //           fontSize: 18,
                //           color: Color.fromRGBO(0, 152, 219, 1),
                //           fontWeight: FontWeight.w600
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 4, 310, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Amount you are going to pay vendor.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(235, 87, 87, 1)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'If this is not correct, please change.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(235, 87, 87, 1)
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 54),
          child: ButtonBar(
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Reject',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color.fromRGBO(235, 85, 85, 1),
                  fixedSize: Size(282, 59)
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Approve',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(33, 150, 83, 1),
                  primary: Colors.white,
                  fixedSize: Size(282, 59)
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

class ContainerView extends StatefulWidget {
  final AcctTableData invoice;
  final AnchorActionProvider invoiceProvider;
  final Function functionStateChange;



  ContainerView(this.invoice,this.invoiceProvider,this.functionStateChange,{Key key}) :super(key: key);

  @override
  State<ContainerView> createState() => _ContainerViewState();
}

class _ContainerViewState extends State<ContainerView> {

  AcctTableData invoice;
  AnchorActionProvider _invoiceProvider ;

  var urlDownload = "";

  DateTime date;
  TextEditingController effDueDateCont;
  TextEditingController rejectReasonCont;
  TextEditingController payableAmountCont;


  _selectEffDueDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: date,
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
      date = newSelectedDate;
      effDueDateCont
        ..text = DateFormat.yMMMd().format(date)
        ..selection = TextSelection.fromPosition(TextPosition(offset: effDueDateCont.text.length, affinity: TextAffinity.upstream));
    }
  }


  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
    _invoiceProvider = widget.invoiceProvider;


    effDueDateCont = TextEditingController(text: widget.invoice.invDueDate);
    payableAmountCont = TextEditingController(text: widget.invoice.invAmt);
    date = widget.invoice.invDueDateO;

  }

  @override
  void dispose() {
    payableAmountCont.dispose();
    effDueDateCont.dispose();
    super.dispose();
  }

  var _loading = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(32))),
      // width: MediaQuery.of(context).size.width * 0.6,
      // height: MediaQuery.of(context).size.height * 0.8 ,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  'Invoice',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: 14,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.invoice.invNo,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 152, 219, 1),
                                      fontSize: 18,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 40),
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Status',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: 14,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.invoice.status == '1'
                                      ? 'Approved'
                                      : widget.invoice.status == '2'
                                      ? 'Pending'
                                      : 'Rejected',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(242, 153, 74, 1),
                                      fontSize: 18,
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
                    SizedBox(
                      height: 40,
                    ),

                    Container(

                      child: UserTextFormField(
                        label: "Effective Due Date",
                        hintText: "",
                        controller: effDueDateCont,
                        readOnly: true,
                        onTap: () {
                          return _selectEffDueDate(context);
                        },
                        padding: EdgeInsets.zero,
                        fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                        errorText: "Date on which you are going to pay the vendor.\nIf this is not correct, please change.",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    Container(

                      child: UserTextFormField(
                        label: "Payable Amount",
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        controller: payableAmountCont,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            try {
                              final text = newValue.text;
                              if (text.isNotEmpty) double.parse(text);
                              return newValue;
                            } catch (e) {}
                            return oldValue;
                          }),
                        ],
                        hintText: "",
                        padding: EdgeInsets.zero,
                        fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                        errorText: "Date on which you are going to pay the vendor.\nIf this is not correct, please change.",
                      ),
                    ),

                    SizedBox(
                      height: 50,
                    ),

                    if(!_loading)
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),

                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () async{

                                  capsaPrint('Approve Call');

                                  setState(() {
                                    _loading = true;
                                  });

                                  // return;

                                  dynamic _data = await _invoiceProvider.approve(  date.toString(), effDueDateCont.text, payableAmountCont.text, widget.invoice, 'a', '', '');

                                  if (_data['res'] == 'success') {
                                    // setState(() {
                                    //
                                    // });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Successfully Approved.'),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {
                                            // Code to execute.
                                          },
                                        ),
                                      ),
                                    );


                                    widget.functionStateChange();
                                    Navigator.pop(context);


                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color.fromRGBO(0, 152, 219, 1),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  child: Text('Vet Invoice', textAlign: TextAlign.center, style: TextStyle(
                                      color: Color.fromRGBO(242, 242, 242, 1),

                                      fontSize: 18,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1
                                  ),),
                                ),
                              ),
                            ), SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {

                                  capsaPrint('Reject Call');
                                  setState(() {
                                    _loading = true;
                                  });
                                  // return;

                                  dynamic _data = await _invoiceProvider.reject( widget.invoice, '', '', '');

                                  if (_data['res'] == 'success') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Successfully Rejected.'),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {
                                            // Code to execute.
                                          },
                                        ),
                                      ),
                                    );


                                    // Navigator.of(context, rootNavigator: true).pop();

                                    widget.functionStateChange();
                                    Navigator.pop(context);
                                  } else {
                                    showToast('Unable to proceed', context);
                                  }



                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color.fromRGBO(235, 87, 87, 1),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  child: Text('Reject', textAlign: TextAlign.center, style: TextStyle(
                                      color: Color.fromRGBO(242, 242, 242, 1),
                                      fontSize: 18,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1
                                  ),),
                                ),
                              ),
                            ),


                          ],
                        ),
                      )
                    else
                      Center(child: CircularProgressIndicator()),


                  ],
                ),
              ),
            ),
            SizedBox(
              width: 25,
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.4,
                child: Builder(builder: (context) {
                  var _body = {'fName': invoice.fileName};
                  return FutureBuilder<Object>(
                      future: _invoiceProvider.getInvFile(_body),
                      builder: (context, snapshot) {
                        dynamic _data = snapshot.data;
                        if (snapshot.hasData) {
                          if (_data['res'] == 'success') {
                            var url = _data['data']['url'];
                            urlDownload = url;
                            return Column(
                              children: [
                                Expanded(child: SfPdfViewer.network(url)),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      });
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
