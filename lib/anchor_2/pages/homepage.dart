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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AnchorHomePage extends StatefulWidget {
  AnchorHomePage({Key key}) : super(key: key);

  @override
  State<AnchorHomePage> createState() => _AnchorHomePageState();
}

class _AnchorHomePageState extends State<AnchorHomePage> {
  int _state = 1;

  final box = Hive.box('capsaBox');
  var userData = {};


  void functionStateChange(){
    capsaPrint('functionStateChange call');
    setState(() {


    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userData = box.get('userData') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final _invoiceProvider = Provider.of<AnchorActionProvider>(context);

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 18.0),
      decoration: bgDecoration,
      child: Padding(
          padding: Responsive.isMobile(context) ? EdgeInsets.fromLTRB(15, 2, 8, 15) : EdgeInsets.fromLTRB(25, 2, 25, 0),
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 06 : 15,
              ),
              TopBarWidget(userData['userName'], ""),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: FutureBuilder<Object>(
                    future: _invoiceProvider.queryInvoiceList(2),
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        // dynamic _response = snapshot.data;


                        List<AcctTableData> _data = snapshot.data;

                        return Container(
                          width: double.infinity,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(25, 0, 0, 0),
                                offset: Offset(5.0, 5.0),
                                blurRadius: 20.0,
                              ),
                              BoxShadow(
                                color: Color.fromARGB(255, 255, 255, 255),
                                offset: Offset(-5.0, -5.0),
                                blurRadius: 0.0,
                              )
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: (Responsive.isMobile(context))
                                ? Column(
                              children: [
                                for (var bids in _data)
                                  InkWell(
                                    onTap: () {
                                      // Beamer.of(context).beamToNamed('/transaction-details/' + bids.invoiceNumber);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(1),
                                      // child: BibsCard(bids,false),
                                    ),
                                  )
                              ],
                            )
                                : DataTable(
                              dataRowHeight: 60,
                              columns: dataTableColumn(
                                  ["S/N", "Invoice No", "Vendor Name", "Issue Date", "Invoice\nAmount", "Due Date", "Tenure", "Action"]),
                              rows: <DataRow>[
                                for (var invoice in _data)
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                        (++i).toString(),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(SizedBox(
                                        // width: 150,
                                        child: Text(
                                          invoice.invNo,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: dataTableBodyTextStyle,
                                        ),
                                      )),
                                      DataCell(SizedBox(
                                        width: 150,
                                        child: Text(
                                          invoice.vendor,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: dataTableBodyTextStyle,
                                        ),
                                      )),
                                      DataCell(Text(
                                        DateFormat('d MMM, y').format(invoice.invDateO).toString(),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        formatCurrency(invoice.invAmt, withIcon: true),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        DateFormat('d MMM, y').format(invoice.invDateO).toString(),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        invoice.tenure,
                                      )),
                                      DataCell(ViewAction(invoice,functionStateChange)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(child: Text("No history found."));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ],
          )),
    );
  }

  Widget _textWidget1({state: 1, text: ''}) {
    var active = (state == _state) ? true : false;

    return InkWell(
      onTap: () {
        setState(() {
          _state = state;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[],
              ),
            ),
            SizedBox(width: 4),
            Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: !active ? Color.fromRGBO(130, 130, 130, 1) : Color.fromRGBO(0, 152, 219, 1),
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewAction extends StatelessWidget {
  final AcctTableData invoice;
  final Function functionStateChange;

  const ViewAction(this.invoice,this.functionStateChange, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _invoiceProvider = Provider.of<AnchorActionProvider>(context, listen: false);

    return InkWell(
        onTap: () {
          showDialog(
            // barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {


                functionBack(){

                  Navigator.pop(context);

                }


                return AlertDialog(
                  // backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  title: Text(
                    invoice.vendor,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                  content:ContainerView(invoice,_invoiceProvider,functionStateChange,functionBack),
                );
              });
        },
        child: Container(
          child: Text(
            "View",
            style: TextStyle(color: HexColor("#0098DB")),
          ),
        ));
  }
}


class ContainerView extends StatefulWidget {
  final AcctTableData invoice;
  final AnchorActionProvider invoiceProvider;
  final Function functionStateChange;
  final Function functionBack;


  ContainerView(this.invoice,this.invoiceProvider,this.functionStateChange,this.functionBack,{Key key}) :super(key: key);

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

                                dynamic _data = await _invoiceProvider.approve(  date.toString(), effDueDateCont.text, payableAmountCont.text, widget.invoice);

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

                                  widget.functionBack();
                                  widget.functionStateChange();


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

                                dynamic _data = await _invoiceProvider.reject( widget.invoice);

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
                                  widget.functionBack();
                                  widget.functionStateChange();
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
