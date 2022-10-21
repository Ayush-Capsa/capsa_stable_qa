import 'package:capsa/anchor/mobile_home_page.dart';
import 'package:capsa/anchor/Mobile_Invoices/Invoices_Page.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/main.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pendingDetails extends StatefulWidget {
  AcctTableData data;
  pendingDetails({Key key, @required this.data}) : super(key: key);

  @override
  State<pendingDetails> createState() => _pendingDetailsState();
}

class _pendingDetailsState extends State<pendingDetails> {
  DateTime date;

  TextEditingController effDueDateCont = TextEditingController();
  TextEditingController payableAmountCont = TextEditingController();

  bool dataInitialised = false;

  bool hasEditPrivileges = true;
  bool hasARPrivileges = true;
  var userData;
  var _pdfData;

  bool intToBool(int n) {
    return n == 1 ? true : false;
  }

  Future<Object> getInvFile(_body) async {
    return await callApi('dashboard/a/getInvFile', body: _body);
  }

  _pdfDialogScreen(BuildContext context, String url) {
    capsaPrint('PDF URL : $url');
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SfPdfViewer.network(url));
  }

  void initialise() async {
    effDueDateCont = TextEditingController(text: widget.data.invDueDate);
    payableAmountCont = TextEditingController(text: widget.data.invAmt);
    var _body = {'fName': widget.data.fileName};
    _pdfData = await getInvFile(_body);
    date = widget.data.invDueDateO;
    userData = Map<String, dynamic>.from(box.get('userData'));
    if (userData['isSubAdmin'] == '0') {
      hasEditPrivileges = true;
      hasARPrivileges = true;
    } else {
      hasEditPrivileges = intToBool(int.parse(
          userData['sub_admin_details']['roleEditInvoice'].toString()));
      hasARPrivileges = intToBool(int.parse(
          userData['sub_admin_details']['roleAandRInvoice'].toString()));
    }

    setState(() {
      dataInitialised = true;
    });
  }

  Future<Object> approve(date, dateText, amt, AcctTableData invoice) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      userData = Map<String, dynamic>.from(box.get('userData'));

      capsaPrint('userData');
      capsaPrint(userData);
      var _body = {};

      if(userData['isSubAdmin'] == '1'){
        _body['sub_admin_id'] = userData['sub_admin_details']['sub_admin_id'];
        String user = userData['firstName'].toString() + " " + userData['lastName'].toString();
        _body['userName'] = user;
      }else{
        _body['userName'] = userData['userName'];
      }
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['role'] = userData['role'];
      _body['i_amount'] = amt;
      _body['i_date'] = date;
      _body['inv_num'] = invoice.invNo;
      _body['inv_date'] = invoice.invDueDate;
      _body['inv_date'] = invoice.invDate;
      _body['inv_val'] = invoice.invAmt;
      _body['cust_name'] = '';
      _body['invoice_num_'] = invoice.invNo;
      // _body['invoice_num_'] = invoice.invNo;

      // capsaPrint('_body');
      // capsaPrint(_body);
      return await callApi('dashboard/a/approve', body: _body);
    }
    return null;
  }

  _selectEffDueDate(BuildContext context) async {
    capsaPrint('Date tapped');
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
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: effDueDateCont.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  @override
  void initState() {
    super.initState();
    initialise();
    // invoice = widget.invoice;
    // _invoiceProvider = widget.invoiceProvider;

    // capsaPrint(
    //     'Date: ${DateFormat('yyyy-MM-dd').format(widget.invoice.invDueDateO)}  ${widget.invoice.invDueDate}');
  }

  @override
  Widget build(BuildContext context) {
    selectedInvoiceTab = 0;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: Color.fromRGBO(245, 251, 255, 1),
          leading: IconButton(
            color: Color.fromRGBO(0, 152, 219, 1),
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Invoice Details',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(51, 51, 51, 1)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 28),
                child: Card(
                  color: Color.fromRGBO(242, 153, 74, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pending',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Invoice Number',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.data.invNo,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Vendor Name',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.data.vendor,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Issue Date',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.data.invDate,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Tenure',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.data.tenure,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)),
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 22),
              //   child: Text(
              //     'Effective Due Date',
              //     style: TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w500,
              //         color: Color.fromRGBO(51, 51, 51, 1)
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width*0.92,
              //     height: MediaQuery.of(context).size.height*0.07,
              //     child: Card(
              //       color: Color.fromRGBO(255, 255, 255, 1),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(8))
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(10),
              //         child: Text(
              //           'Dec 23, 2023',
              //           style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: Color.fromRGBO(51, 51, 51, 1)
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 22, bottom: 22),
              //   child: Text(
              //     'Date on which the vendor gets paid. If this is incorrect, kindly edit',
              //     style: TextStyle(
              //       fontSize: 10,
              //       fontWeight: FontWeight.w400,
              //       color: Color.fromRGBO(235, 87, 87, 1)
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: 110,
                  child: UserTextFormField(
                    label: "Effective Due Date",
                    hintText: "",
                    action: hasEditPrivileges ? 'Edit' : '',
                    controller: effDueDateCont,
                    readOnly: true,
                    onActionTap: () {
                      return hasEditPrivileges
                          ? {_selectEffDueDate(context)}
                          : null;
                    },
                    padding: EdgeInsets.zero,
                    fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                    errorText: hasEditPrivileges
                        ? "Date on which you are going to pay the vendor.\nIf this is not correct, please change."
                        : "",
                    isMobile: true,
                  ),
                ),
              ),
              //SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: 110,
                  child: UserTextFormField(
                    label: "Payable Amount",
                    hintText: "",
                    action: hasEditPrivileges ? 'Edit' : '',
                    readOnly: hasEditPrivileges ? false : true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: payableAmountCont,
                    // onActionTap: () {
                    //   return hasEditPrivileges
                    //       ? {_selectEffDueDate(context)}
                    //       : null;
                    // },
                    padding: EdgeInsets.zero,
                    fillColor: Color.fromRGBO(238, 248, 255, 1.0),
                    errorText: hasEditPrivileges
                        ? "Amount you are going to pay the vendor.\nIf this is not correct, please change."
                        : "",
                    isMobile: true,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  capsaPrint('tapped');
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                            backgroundColor: dataInitialised
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: 5,
                            child: //_dialogScreen(context, widget.invoiceProvider, widget.fileName),
                                dataInitialised
                                    ? _pdfDialogScreen(
                                        context, _pdfData['data']['url'])
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      )));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Text(
                    'Click here to view invoice',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 152, 219, 1)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        color: Color.fromRGBO(255, 255, 255, 1),
        child: ButtonBar(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Reject',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(235, 87, 87, 1),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.45,
                      MediaQuery.of(context).size.height * 0.05)),
            ),
            hasARPrivileges?ElevatedButton(
              onPressed: () async {
                dynamic _data = await approve(date.toString(),
                    effDueDateCont.text, payableAmountCont.text, widget.data);

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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CapsaHome()));
                }
              },
              child: Text(
                'Approve',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(33, 150, 83, 1),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.45,
                      MediaQuery.of(context).size.height * 0.05)),
            ):Container()
          ],
        ),
      ),
    );
  }
}
