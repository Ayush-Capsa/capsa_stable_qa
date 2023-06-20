import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:capsa/admin/models/invoice_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/profile_model.dart';

import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/GeneratedDesktopMenuWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import '../../functions/currency_format.dart';
import '../../vendor-new/pages/add_invoice/widgets/info_box.dart';

class EditTransaction extends StatefulWidget {
  String id;
  EditTransaction({Key key, @required this.id}) : super(key: key);

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');
  final dueDateCont = TextEditingController();
  final dateCont = TextEditingController();
  final fileCont = TextEditingController(text: '');
  DateTime _selectedDate;
  DateTime _selectedDueDate;
  var _cuGst;
  TransactionDetails transactions;

  bool saving = false;

  final rateController2 = TextEditingController(text: '');

  dynamic companyDetails = null;

  bool dataLoaded = false;
  String selectedStatus = '';

  dynamic status;

  List<String> term = ['PENDING', 'FAILED', 'COMPLETED'];

  void saveTransactionStatus() async{

    setState(() {
      dataLoaded = false;
    });

    dynamic body = {
      'id' : widget.id,
      'status' : selectedStatus,
    };
    
    dynamic response = await callApi('admin/editTransactionStatus', body: body);

    capsaPrint('response : $response');

    if(response['res'] == 'success' || response['msg'] == 'success'){
      showToast('Saved Successfully', context);
      Navigator.pop(context);
    }else{
      showToast('Something went wrong!', context, type: 'error');
    }

    setState(() {
      dataLoaded = false;
    });
    
  }

  int navigate() {
    Beamer.of(context).beamToNamed('/confirmInvoice');
    return 1;
  }

  // void updateAdmin(String panNumber){
  //
  //
  //
  // }

  Future<Object> getData() async {
    dynamic response = await callApi('admin/tranasactionsById',
        body: {'id': widget.id.toString()});
    capsaPrint('response : $response ${widget.id.toString()}');
    dynamic element = response['data'][0];
    transactions = TransactionDetails(
      account_number: element['account_number'].toString(),
      blocked_amt: element['blocked_amt'].toString(),
      closing_balance: element['closing_balance'].toString(),
      created_on: element['created_on'],
      deposit_amt: element['deposit_amt'].toString(),
      id: element['id'].toString(),
      narration: element['narration'],
      opening_balance: element['opening_balance'].toString(),
      order_number: element['order_number'].toString(),
      stat_txt: element['stat_txt'],
      status: element['admin_status'] ?? '',
      trans_hash: element['trans_hash'].toString(),
      updated_on: element['updated_on'],
      withdrawl_amt: element['withdrawl_amt'].toString(),
    );

    status = transactions.status;
    selectedStatus = status;

    dataLoaded = true;
    setState(() {});
  }

  // var anchor, cacAddress, invNo, po, terms;

  // var invAmt, details, rate, invDueDate;
  // var invSell = '0';

  var tenureDaysDiff = 0;

  var anchorNameList = [];

  PlatformFile file;

  bool loadingCall = false;
  bool loadingConfirm = false;

  bool nextMobileType = false;
  bool nextEnable = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    // final invoiceProvider =
    // Provider.of<InvoiceProvider>(context, listen: false);

    if (Responsive.isMobile(context)) {
      nextMobileType = true;
      nextEnable = false;
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: Responsive.isMobile(context) ? 0 : 185,
            height: MediaQuery.of(context).size.height * 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
              ),
              color: Color.fromARGB(255, 15, 15, 15),
            ),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: [
                Positioned(
                    left: 42.5,
                    top: 38.0,
                    right: null,
                    bottom: null,
                    width: 34,
                    height: 34,
                    child: Container(
                      width: 80.0,
                      height: 45,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image.asset(
                            "assets/images/arrow-left.png",
                            color: null,
                            fit: BoxFit.cover,
                            width: 34.0,
                            height: 34,
                            colorBlendMode: BlendMode.dstATop,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          true
              ? dataLoaded
                  ? Container(
                      //height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width - 185,
                      padding: const EdgeInsets.all(25.0),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TopBarWidget('Edit Transaction', ''),
                              SizedBox(
                                height: 32,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InfoBox(
                                    header: 'id',
                                    content: transactions.id,
                                    width: 500,
                                  ),
                                  InfoBox(
                                    header: 'Account Number',
                                    content: transactions.account_number,
                                    width: 500,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InfoBox(
                                    header: 'Opening Balance',
                                    content: formatCurrency(
                                        transactions.opening_balance),
                                    width: 500,
                                  ),
                                  InfoBox(
                                    header: 'Closing Balance',
                                    content: formatCurrency(
                                        transactions.closing_balance),
                                    width: 500,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InfoBox(
                                    header: 'Date',
                                    content: DateFormat('yyyy-MM-dd')
                                        .format(DateFormat(
                                                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                            .parse(transactions.created_on))
                                        .toString(),
                                    width: 500,
                                  ),
                                  InfoBox(
                                    header: 'Narration',
                                    content: transactions.narration,
                                    width: 500,
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  InfoBox(
                                    header: 'Deposit',
                                    content: formatCurrency(transactions.deposit_amt),
                                    width: 500,
                                  ),
                                  InfoBox(
                                    header: 'Withdraw',
                                    content: formatCurrency(transactions.withdrawl_amt),
                                    width: 500,
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width : 500,
                                    child: UserTextFormField(
                                      label: "",
                                      hintText: "Select Status",
                                      textFormField: DropdownButtonFormField(
                                        isExpanded: true,
                                        // validator: (v) {
                                        //   if (anchorController.text ==
                                        //       '') {
                                        //     return "Can't be empty";
                                        //   }
                                        //   return null;
                                        // },
                                        items: term.map((String category) {
                                          return DropdownMenuItem(
                                            //key: _key,
                                            value: category,
                                            child: Text(category.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (v) {
                                          selectedStatus = v;
                                        },
                                        value: status,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Select Status",
                                          hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  130, 130, 130, 1),
                                              fontSize: 14,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                          contentPadding: const EdgeInsets.only(
                                              left: 8.0, bottom: 12.0, top: 12.0),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(15.7),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(15.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0,
                                    child: InfoBox(
                                      header: '',
                                      content: '',
                                      width: 500,
                                    ),
                                  ),
                                ],
                              ),



                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: (){
                        saveTransactionStatus();
                      },
                                    child: Container(
                                      height: 60,
                                      width: 500,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: HexColor('#0098DB')),
                                      child: Center(
                                        child: Text(
                                          'Save',
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () async{
                                      setState(() {
                                        dataLoaded = false;
                                      });

                                      dynamic response = await callApi('admin/transactionReversal', body: {'id': widget.id});
                                      capsaPrint('Reversal response = $response');
                                      if(response['res'] == 'success' || response['msg'] == 'success'){
                                        showToast('Transaction Reversed Successfully', context);
                                        Navigator.pop(context);
                                      }else{
                                        showToast('Something went wrong!', context, type: 'error');
                                      }

                                      setState(() {
                                        dataLoaded = true;
                                      });

                                    },
                                    child: Container(
                                      height: 60,
                                      width: 500,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.red),
                                      child: Center(
                                        child: Text(
                                          'Reverse',
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )

                            ]),
                      ),
                    )
                  : Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
    );
  }

  Widget mobileFormSteper() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Center(
          child: Stack(children: <Widget>[
            Positioned(
                top: 14,
                left: 104,
                child: Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(130, 130, 130, 1),
                    ))),
            Positioned(
                top: 0,
                left: 67,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: Color.fromRGBO(245, 251, 255, 1),
                    border: Border.all(
                      color: Color.fromRGBO(0, 152, 219, 1),
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '1',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 0,
                left: 184,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: Color.fromRGBO(245, 251, 255, 1),
                    border: Border.all(
                      color: Color.fromRGBO(130, 130, 130, 1),
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '2',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(130, 130, 130, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                )),
          ]),
        ));
  }
}

class SplitInvoiceWarning extends StatelessWidget {
  String invNo;
  Function nav;
  SplitInvoiceWarning({Key key, @required this.invNo, @required this.nav})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 584,
      height: 579,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: HexColor('#F5FBFF')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/warning.png',
            width: 80,
            height: 80,
          ),
          Text(
            'Invoice Splitting',
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Text(
            'Please note that your invoice will be split into smaller invoices. This will allow for faster trading of your invoice.\n\n This does not affect the invoice value. A breakdown of the split can be seen on the next page.',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: () {
              // nav;
              // Beamer.of(context).beamToNamed('/confirmInvoice');
              Navigator.pop(context);
            },
            child: Container(
              height: 60,
              width: 342,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: HexColor('#0098DB')),
              child: Center(
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
