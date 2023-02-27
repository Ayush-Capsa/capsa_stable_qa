import 'dart:convert';

import 'package:capsa/common/constants.dart';
// import 'package:capsa/investor/providers/proposal_provider.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/investor/models/proposal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OpenDealProvider extends ChangeNotifier {
  List<OpenDealModel> _openDeal = [];
  List _keys = [];
  List _propDet = [];
  bool showRevenue = false;

  bool _loadingDeals = false;

  List<OpenDealModel> get openInvoices => _openDeal;

  bool get loadingDeals => _loadingDeals;

  openInvoicesByIndex(index) {
    return _openDeal[index];
  }

  changeDealsType(f) {
    showRevenue = f;
    _openDeal = [];
    queryOpenDealList();
    notifyListeners();
  }

  int get invoicesCount => _openDeal.length;

  final box = Hive.box('capsaBox');

  String _url = apiUrl;

  Future<Object> queryOpenDealList({String currency = 'NGN'}) async {
    //capsaPrint('CUrrency called $currency');
    _loadingDeals = true;
    notifyListeners();
    _openDeal = [];
    _keys = [];
    _propDet = [];
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      capsaPrint('$userData');

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];

      dynamic _uri;
      _uri = _url + 'dashboard/i/deal';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      capsaPrint('Response open deal list 1 $data ${data['invoice']}');
      /// commented by ayush to reduce delay
      await Future.delayed(Duration(milliseconds: 5000));
      await queryOpenDealFinalList(currency: currency);
      return null;
    }

    return null;
  }

  Future<Object> splitInvoice(String invoiceNumber) async{
    var _body = {};
    _body['parent_invoice'] = invoiceNumber;

    print('Split initialised');

    dynamic _uri;
    _uri = _url + 'dashboard/i/liveSplits';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
    print('Split Data $data');
    return data;
  }

  Future<Object> queryOpenDealFinalList({String currency = 'NGN'}) async {
    _openDeal = [];
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['showRevenue'] = showRevenue.toString();
      _body['currency'] = currency;

      dynamic _uri;
      _uri = _url + 'dashboard/i/final';
      _uri = Uri.parse(_uri);
      capsaPrint('Calling final list');
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      capsaPrint('Response open deal list 2 $data ${data['data']['invoicelist'].length}');

      if (data['res'] == 'success') {
        var _data = data['data'];
        // capsaPrint(_data);

        var invoiceList = _data['invoicelist'];
        List<OpenDealModel> _openDealList = [];
        //

        // capsaPrint(invoiceList);

        invoiceList.forEach((element) {

          print('$element \n\n');

          OpenDealModel _openDealModel = OpenDealModel(
            invoice_value: element['invoice_value'].toString(),
            isRevenue: element['isRevenue'].toString(),
            start_date: element['start_date'],
            due_date: element['due_date'],
            eff_due_date: element['eff_due_date'],
            minimum_investment: element['minimum_investment'].toString(),
            invoice_number: element['invoice_number'],
            trans_his: element['trans_his'],
            description: element['description'],
            customer_name: element['customer_name'],
            comp_contract_address: element['comp_contract_address'],
            child_address: element['child_address'],
            discount_percentage: element['discount_percentage'].toString(),
            discount_status: element['discount_status'].toString(),
            companyName: element['companyName'],
            companyPAN: element['companyPAN'],
            companySafePercentage: element['companySafePercentage'].toString(),
            customerCIN: element['customerCIN'],
            industry: element['industry'],
            founded: element['founded'],
            key_person: element['key_person'],
            about: element['about'],
            colour: element['colour'],
            city: element['city'],
            state: element['state'],
            website: element['website'],
            linkedin: element['linkedin'],
            fb: element['fb'],
            twitter: element['twitter'],
            insta: element['insta'],
            customer_pan: element['customer_pan'].toString(),
            sel_CIN: element['sel_CIN'],
            sel_industry: element['sel_industry'],
            sel_founded: element['sel_founded'],
            sel_key_person: element['sel_key_person'],
            sel_about: element['sel_about'],
            sel_website: element['sel_website'],
            sel_linkedin: element['sel_linkedin'],
            sel_fb: element['sel_fb'],
            sel_twitte: element['sel_twitte'],
            sel_insta: element['sel_insta'],
            ask_amt: element['ask_amt'].toString(),
            ask_rate: element['ask_rate'].toString(),
            totalDiscount: element['totalDiscount'].toString(),
            alcptdy: element['alcptdy'].toString(),
            isSplit: element['isSplit'].toString(),
          );

          _openDealList.add(_openDealModel);
        });

        _openDeal.addAll(_openDealList);

        // capsaPrint('_openDeal');
        // capsaPrint(_openDeal);

        _keys.addAll(_data['keys']);
        _propDet.addAll(_data['propDet']);
        _loadingDeals = false;
        notifyListeners();
      }

      return data;
    }
    return null;
  }

  void insertOpenDeal(OpenDealModel openDeal) {
    _openDeal.add(openDeal);
    notifyListeners();
  }

  Future<Object> checkBalance(OpenDealModel openInvoice) async {
    // if (box.get('isAuthenticated', defaultValue: false)) {
    var userData = Map<String, dynamic>.from(box.get('userData'));

    var _body = {};

    _body['panNumber'] = userData['panNumber'];
    _body['role'] = userData['role'];
    _body['invoicenum'] = openInvoice.invoice_number;

    dynamic _uri;
    _uri = _url + 'dashboard/i/checkbalance';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
    return data;
    // }
  }

  Future<Object> checkBalance2(ProposalModel openInvoice) async {
    // if (box.get('isAuthenticated', defaultValue: false)) {
    var userData = Map<String, dynamic>.from(box.get('userData'));

    var _body = {};

    _body['panNumber'] = userData['panNumber'];
    _body['role'] = userData['role'];
    _body['invoicenum'] = openInvoice.invoice_number;

    dynamic _uri;
    _uri = _url + 'dashboard/i/checkbalance';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
    return data;
    // }
  }

  Future<Object> bidAction(OpenDealModel openInvoice, int clickType,
      {String rate, String amt, String tRate,buyNow = false}) async {
    // capsaPrint('clickType');
    // capsaPrint(clickType);

    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var invoicedays = 0;

      var payableamount = double.parse(openInvoice.invoice_value);
      var purchaseprice;
      if (amt != null) {
        double _amt = double.parse(amt);
        purchaseprice = _amt;
      } else {
        purchaseprice = double.parse(openInvoice.ask_amt);
      }

      DateTime invoiceDate =
          new DateFormat("yyyy-MM-dd").parse(openInvoice.start_date);

      DateTime invoiceDueDate =
          new DateFormat("yyyy-MM-dd").parse(openInvoice.due_date);

      // invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
      // invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);
      invoicedays = invoiceDueDate.difference(invoiceDate).inDays;

      var termRate =
          (1 / invoicedays) * (payableamount / purchaseprice - 1) * invoicedays;
      termRate = termRate * 100;
      termRate = termRate.toPrecision(2);

      var rate = (1 / invoicedays) * (payableamount / purchaseprice - 1) * 360;
      rate = rate * 100;
      rate = rate.toPrecision(2);

      // return null;

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      _body['role'] = userData['role'];
      _body['discount_val'] = purchaseprice.toString();
      _body['discount_percentage'] = rate.toString();

      _body['pay_amt'] = '';
      // _body['discount_val'] = openInvoice.;
      _body['plt_fee'] = '';
      _body['pay_amt'] = '';
      _body['from_popup'] = '1';
      _body['compcin1'] = openInvoice.sel_CIN;
      _body['custcin1'] = openInvoice.customerCIN;
      // _body['discper1'] = openInvoice.discper;
      // _body['childcontract1'] = openInvoice.childcontract;
      _body['duedate1'] = openInvoice.due_date;
      _body['invoicenum1'] = openInvoice.invoice_number;
      _body['invval1'] = openInvoice.invoice_value;
      _body['start_date'] = openInvoice.start_date;
      _body['due_date'] = openInvoice.due_date;
      _body['click_type'] = clickType.toString();

      _body['diffDays'] = invoicedays.toString();
      _body['isBuyNow'] = buyNow ? '1' : '0';

      // capsaPrint(_body);
      // return null;

      dynamic _uri;
      _uri = _url + 'dashboard/i/deals-proposal-send';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      // capsaPrint(data);

      // if (data['res'] == 'success') {
      //   var _data = data['data'];
      //
      //   notifyListeners();
      // }

      return data;
    }
    return null;
  }

  Future<void> bidActionCall(
      context, OpenDealModel openInvoice, int clickType, index,
      {String rate, String amt, String tRate, buyNow = false}) async {
    // capsaPrint('bidActionCall');

    dynamic _result = await checkBalance(openInvoice);
    if (_result['res'] == 'success') {
      if (_result['data']['passok'].toString() == 'true') {
        dynamic _result2 = await bidAction(openInvoice, clickType,
            rate: rate, amt: amt, tRate: tRate, buyNow : buyNow);

        if (_result2['res'] == 'success') {
          await queryOpenDealList();
          Navigator.of(context, rootNavigator: true).pop();

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text("Proposal was successfully send"),
          //     action: SnackBarAction(
          //       label: 'Ok',
          //       onPressed: () {
          //         // Code to execute.
          //       },
          //     ),
          //   ),
          // );

          await showDialog(
              context: context,
              // barrierDismissible: false,
              builder: (context) => AlertDialog(
                    content: Padding(
                      padding: const EdgeInsets.all(58.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.done,
                            color: Colors.blue,
                            size: 70,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Success',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text("Bid was successfully placed."),
                          SizedBox(
                            height: 40,
                          ),
                          MaterialButton(
                            height: 50,
                            color: Colors.green,
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              // capsaPrint('Bid Suvess ok');
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ));
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something Wrong. Try again later'),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {
                  // Code to execute.
                },
              ),
            ),
          );
        }

        // html.window.location.reload();
      } else {
        Navigator.of(context, rootNavigator: true).pop();

        capsaPrint("Low Balance");
        String _text = _result['data']['text'].toString();

        // String _text = "0 - 1m, buyer should have 10 % of the invoice value in their account\n";
        // _text = _text + "1.0m - 2.5 m invoice amount buyer need to have(100 k) in wallet\n";
        // _text = _text + "2.5 m - 10 m invoice amount buyer need to have(250 k) in wallet\n";
        // _text = _text + "10 m - 50 m invoice amount buyer need to have(500 k) in wallet\n";
        // _text = _text + "Above 50 m invoice amount buyer need to have(1 m) in wallet\n";

        await showDialog(
            context: context,
            // barrierDismissible: false,
            builder: (context) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: Padding(
                    padding: Responsive.isMobile(context)
                        ? EdgeInsets.all(10.0)
                        : EdgeInsets.all(50.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 70,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Low Balance Alert',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _text,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              "Kindly fund your account to proceed. Thank you",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          MaterialButton(
                            height: 50,
                            color: Colors.red,
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ));

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Insufficient Balance in your account'),
        //     action: SnackBarAction(
        //       label: 'Ok',
        //       onPressed: () {
        //         // Code to execute.
        //       },
        //     ),
        //   ),
        // );

      }
    } else {
      Navigator.of(context).pop();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(_result['messg']),
      //     action: SnackBarAction(
      //       label: 'Ok',
      //       onPressed: () {
      //         // Code to execute.
      //       },
      //     ),
      //   ),
      // );

      showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (_) => AlertDialog(
                content: Padding(
                  padding: const EdgeInsets.all(58.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.blue,
                        size: 70,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Error!',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(_result['messg']),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: MaterialButton(
                          height: 50,
                          color: Colors.red,
                          child: Text(
                            'Ok',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    }
  }

  Future<Object> bidEdit(OpenDealModel invoice,
      {String rate, String amt, String tRate}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      // var invoicedays = 0;
      //
      // var payableamount = double.parse(invoice.invoice_value);
      // var purchaseprice;
      // if (amt != null) {
      //   double _amt = double.parse(amt);
      //   purchaseprice = _amt;
      // } else {
      //   purchaseprice = double.parse(invoice.ask_amt);
      // }
      //
      // DateTime invoiceDate =
      //     new DateFormat("yyyy-MM-dd").parse(invoice.start_date);
      //
      // DateTime invoiceDueDate =
      //     new DateFormat("yyyy-MM-dd").parse(invoice.due_date);
      //
      // // invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
      // // invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);
      // invoicedays = invoiceDueDate.difference(invoiceDate).inDays;
      //
      // var termRate =
      //     (1 / invoicedays) * (payableamount / purchaseprice - 1) * invoicedays;
      // termRate = termRate * 100;
      // termRate = termRate.toPrecision(2);
      //
      // var rate = (1 / invoicedays) * (payableamount / purchaseprice - 1) * 360;
      // rate = rate * 100;
      // rate = rate.toPrecision(2);

      // return null;

      var _body = {};

      _body['investor_pan'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      _body['role'] = userData['role'];
      _body['new_prop_amt'] = amt.toString();
      _body['discount_per'] = rate.toString();

      _body['pay_amt'] = '';
      // _body['discount_val'] = openInvoice.;
      _body['plt_fee'] = '';
      _body['pay_amt'] = '';
      _body['from_popup'] = '1';
      // _body['comp_pan'] = invoice.comp_pan;
      // _body['cust_pan'] = invoice.cust_pan;
      // _body['prop_amt'] = invoice.prop_amt;
      // _body['discper1'] = openInvoice.discper;
      // _body['childcontract1'] = openInvoice.childcontract;
      _body['duedate1'] = invoice.due_date;
      _body['inv_number'] = invoice.invoice_number;
      _body['invval1'] = invoice.invoice_value;
      _body['start_date'] = invoice.start_date;
      _body['due_date'] = invoice.due_date;
      // _body['click_type'] = clickType.toString();

      //_body['diffDays'] = invoicedays.toString();

      // capsaPrint(_body);
      // return null;

      dynamic _uri;
      _uri = _url + 'dashboard/i/editbid';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      capsaPrint('Edit response : $data');

      // if (data['res'] == 'success') {
      //   var _data = data['data'];
      //
      //   notifyListeners();
      // }

      return data;
    }
    return null;
  }

  // Future<void> bidEditCall(context, ProposalModel openInvoice,ProposalProvider proposalProvider,
  //     {String rate, String amt, String tRate}) async {
  //
  //   dynamic _result = await checkBalance2(openInvoice);
  //   if (_result['res'] == 'success') {
  //     if (_result['data']['passok'].toString() == 'true') {
  //       dynamic _result2 =
  //       await bidEdit(openInvoice, rate: rate, amt: amt, tRate: tRate);
  //
  //       if (_result2['res'] == 'success') {
  //         await   queryOpenDealList();
  //         await proposalProvider.queryProposalList();
  //         Navigator.of(context,rootNavigator: true).pop();
  //
  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   SnackBar(
  //         //     content: Text("Proposal was successfully send"),
  //         //     action: SnackBarAction(
  //         //       label: 'Ok',
  //         //       onPressed: () {
  //         //         // Code to execute.
  //         //       },
  //         //     ),
  //         //   ),
  //         // );
  //
  //
  //         await  showDialog(
  //             context: context,
  //             // barrierDismissible: false,
  //             builder: (context) => AlertDialog(
  //               content: Padding(
  //                 padding: const EdgeInsets.all(58.0),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Icon(
  //                       Icons.done     ,
  //                       color: Colors.blue,
  //                       size: 70,
  //                     ),
  //                     SizedBox(
  //                       height: 40,
  //                     ),
  //                     Text(
  //                       'Success',
  //                       style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  //                     ),
  //                     SizedBox(
  //                       height: 30,
  //                     ),
  //                     Text("Bid was successfully Updated."),
  //                     SizedBox(
  //                       height: 40,
  //                     ),
  //                     MaterialButton(
  //                       height: 50,
  //                       color: Colors.green,
  //                       child: Text(
  //                         'Ok',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       onPressed: () {
  //                         // capsaPrint('Bid updtaed ok');
  //                         Navigator.of(context,rootNavigator: true).pop();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ));
  //
  //
  //
  //       } else {
  //         Navigator.of(context).pop();
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Something Wrong. Try again later'),
  //             action: SnackBarAction(
  //               label: 'Ok',
  //               onPressed: () {
  //                 // Code to execute.
  //               },
  //             ),
  //           ),
  //         );
  //       }
  //
  //       // html.window.location.reload();
  //     } else {
  //       Navigator.of(context,rootNavigator: true).pop();
  //
  //
  //       String _text = "0 - 1m, buyer should have 10 % of the invoice value in their account\n";
  //       _text = _text + "1.0m - 2.5 m invoice amount buyer need to have(100 k) in wallet\n";
  //       _text = _text + "2.5 m - 10 m invoice amount buyer need to have(250 k) in wallet\n";
  //       _text = _text + "10 m - 50 m invoice amount buyer need to have(500 k) in wallet\n";
  //       _text = _text + "Above 50 m invoice amount buyer need to have(1 m) in wallet\n";
  //
  //       await showDialog(
  //           context: context,
  //           // barrierDismissible: false,
  //           builder: (context) => AlertDialog(
  //             contentPadding: EdgeInsets.zero,
  //
  //
  //             content: Padding(
  //               padding: Responsive.isMobile(context) ?  EdgeInsets.all(10.0) : EdgeInsets.all(50.0) ,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Icon(
  //                       Icons.info_outline,
  //                       color: Colors.blue,
  //                       size: 70,
  //                     ),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     Text(
  //                       'Low Balance Alert',
  //                       style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
  //                     ),
  //                     // SizedBox(
  //                     //   height: 10,
  //                     // ),
  //                     Center(
  //                       child: Flexible(child: Center(
  //                         child: Text(
  //                           "Please fund your Capsa account to enable you place a bid",
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //                         ),
  //                       ),),
  //                     ),
  //
  //                     Flexible(child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         '\n'+_text,
  //                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                       ),
  //                     ),),
  //
  //                     SizedBox(
  //                       height: 40,
  //                     ),
  //                     MaterialButton(
  //                       height: 50,
  //                       color: Colors.red,
  //                       child: Text(
  //                         'Ok',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.of(context,rootNavigator: true).pop();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ));
  //
  //
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(
  //       //     content: Text('Insufficient Balance in your account'),
  //       //     action: SnackBarAction(
  //       //       label: 'Ok',
  //       //       onPressed: () {
  //       //         // Code to execute.
  //       //       },
  //       //     ),
  //       //   ),
  //       // );
  //
  //
  //     }
  //   } else {
  //     Navigator.of(context).pop();
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: Text(_result['messg']),
  //     //     action: SnackBarAction(
  //     //       label: 'Ok',
  //     //       onPressed: () {
  //     //         // Code to execute.
  //     //       },
  //     //     ),
  //     //   ),
  //     // );
  //
  //     showDialog(
  //         context: context,
  //         // barrierDismissible: false,
  //         builder: (_) => AlertDialog(
  //           content: Padding(
  //             padding: const EdgeInsets.all(58.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Icon(
  //                   Icons.error_outline,
  //                   color: Colors.blue,
  //                   size: 70,
  //                 ),
  //                 SizedBox(
  //                   height: 40,
  //                 ),
  //                 Text(
  //                   'Error!',
  //                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  //                 ),
  //                 SizedBox(
  //                   height: 30,
  //                 ),
  //                 Text(_result['messg']),
  //                 SizedBox(
  //                   height: 40,
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.of(context,rootNavigator: true).pop();
  //                   },
  //                   child: MaterialButton(
  //                     height: 50,
  //                     color: Colors.red,
  //                     child: Text(
  //                       'Ok',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                     onPressed: () {
  //                       Navigator.of(context,rootNavigator: true).pop();
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ));
  //
  //
  //   }
  //
  // }

  Future<void> payClick(context, OpenDealModel openInvoice) async {
    // capsaPrint('payClick');

    // capsaPrint(openInvoice.)

    var amt;

    var userData = Map<String, dynamic>.from(box.get('userData'));

    var invoicedays = 0;

    var payableamount = double.parse(openInvoice.invoice_value);
    var purchaseprice = getFactorValue(openInvoice);
    num factorValue = getFactorValue(openInvoice);
    // if (amt != null) {
    //   double _amt = double.parse(amt);
    //   purchaseprice = _amt;
    // } else {
    //   purchaseprice = double.parse(openInvoice.ask_amt);
    // }

    DateTime invoiceDate =
        new DateFormat("yyyy-MM-dd").parse(openInvoice.start_date);

    DateTime invoiceDueDate =
        new DateFormat("yyyy-MM-dd").parse(openInvoice.due_date);

    // invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
    // invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);
    invoicedays = invoiceDueDate.difference(invoiceDate).inDays;

    var termRate =
        (1 / invoicedays) * (payableamount / purchaseprice - 1) * invoicedays;
    termRate = termRate * 100;
    termRate = termRate.toPrecision(2);

    var rate = (1 / invoicedays) * (payableamount / purchaseprice - 1) * 360;
    rate = rate * 100;
    rate = rate.toPrecision(2);

    var _body = {};

    var plt_fee = ((payableamount * 0.85) / 100) + 200;

    // return;

    _body['panNumber'] = userData['panNumber'];
    _body['role'] = userData['role'];
    _body['invoicenum'] = openInvoice.invoice_number;

    _body['panNumber'] = userData['panNumber'];
    _body['userName'] = userData['userName'];
    _body['role'] = userData['role'];
    _body['discount_val'] = purchaseprice.toString();
    _body['discount_percentage'] = rate.toString();

    _body['pay_amt'] = '';
    // _body['discount_val'] = openInvoice.;
    _body['plt_fee'] = '';
    _body['pay_amt'] = '';
    _body['from_popup'] = '1';
    _body['compcin1'] = openInvoice.sel_CIN;
    _body['custcin1'] = openInvoice.customerCIN;
    // _body['discper1'] = openInvoice.discper;
    // _body['childcontract1'] = openInvoice.childcontract;
    _body['duedate1'] = openInvoice.due_date;
    _body['invoicenum1'] = openInvoice.invoice_number;
    _body['invval1'] = openInvoice.invoice_value;
    _body['start_date'] = openInvoice.start_date;
    _body['due_date'] = openInvoice.due_date;
    _body['comp_pan'] = openInvoice.companyPAN;
    _body['minimum_invest'] = openInvoice.minimum_investment;
    _body['company_name'] = openInvoice.companyName;

    _body['plt_fee'] = plt_fee.round().toString();

    _body['pay_amt'] = factorValue.toString();
    _body['discount_val'] = factorValue.toString();
    _body['discount_percentage'] = rate.toString();

    // _body['click_type'] = clickType.toString();

    _body['diffDays'] = invoicedays.toString();
    dynamic _uri;
    _uri = _url + 'dashboard/i/payBidConfirm';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
    await queryOpenDealList();
    return data;
  }

  bool showBuyNow(OpenDealModel openInvoice) {
    bool showbuynow = true;
    var value1 = double.parse(openInvoice.ask_amt);
    var invoice_amt = double.parse(openInvoice.invoice_value);
    // console.log(value1, invoice_amt);

    // Greater than 70% of the invoice amount
    if(value1>0 && shwBid(openInvoice))
      return true;
    var per70 = (70 * invoice_amt / 100);

    // less than 80% of the invoice amount
    var per80 = (80 * invoice_amt / 100);

    if (!(value1 >= per70 && value1 <= per80)) {
      showbuynow = false;
    }

    int y = getYValue(openInvoice);

    if (y >= 0) if (_propDet[y][4].toString() == 'false') {
      if (showbuynow) {
        if (openInvoice.alcptdy == 'false') return true;
      }
    }

    if (showbuynow) {
      if (openInvoice.alcptdy == 'false') {
        return true;
      }
    }

    return false;
  }

  num getDiscountRate(OpenDealModel openInvoice) {
    int y = getYValue(openInvoice);
    if (y >= 0) {
      return _propDet[y][2];
    }

    return 0;
  }

  num getFactorValue(OpenDealModel openInvoice) {
    int y = getYValue(openInvoice);
    if (y >= 0) {
      return _propDet[y][1];
    }

    return 0;
  }

  int getYValue(OpenDealModel openInvoice) {
    var x = openInvoice.companyPAN +
        openInvoice.customer_pan +
        openInvoice.invoice_number;
    var y = _keys.indexOf(x);
    // capsaPrint("invoice no " + x + "---Index " + y.toString());
    return y;
  }

  bool showPay(OpenDealModel openInvoice) {
    // if (propDet[y][3] == 1) {
    int y = getYValue(openInvoice);
    if (y >= 0) {
      if (_propDet[y][3].toString() == '1') {
        return true;
      }
    }

    return false;
  }

  bool shwBid(OpenDealModel openInvoice) {
    int y = getYValue(openInvoice);
    if (y >= 0) {
      if (_propDet[y][3].toString() == '2') {
        if (_propDet[y][4].toString() == 'false') {
          return true;
        }
        return false;
      }
    } else if (!(y == 0)) {
      if (openInvoice.alcptdy == 'false') {
        return true;
      }
      return false;
    }

    return false;
  }
}
