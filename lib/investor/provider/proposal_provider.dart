import 'package:capsa/common/constants.dart';
import 'package:capsa/investor/models/proposal_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:universal_html/html.dart' as html;
class ProposalProvider extends ChangeNotifier {
  List<ProposalModel> _proposalDataList = [];

  List<ProposalModel> get proposalDataList => _proposalDataList;
  final box = Hive.box('capsaBox');

  Future<Object> queryProposalList() async {
    // capsaPrint('here 1');/
    _proposalDataList = [];
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      // capsaPrint(userData);
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];

      _body['userName'] = "xyx";

      dynamic _uri;
      _uri = apiUrl + 'dashboard/i/proposal-discounted';
      _uri = Uri.parse(_uri);

      var response = await http.post(_uri, headers: <String, String>{
        'Authorization': 'Basic '+box.get('token',defaultValue: '0')
      }, body: _body);
      var data = jsonDecode(response.body);
      // capsaPrint(data);
      if (data['res'] == 'success') {
        var _data = data['data'];

        var proposalListList = _data['Proposalslist']; // as Map
        List<ProposalModel> _proposalList = [];
        // _proposalList = proposalListList;
        // var tmp = [];

        // proposalListList.forEach((element) {
        //   element.forEach((k,v) {
        //
        //     });
        //   _proposalList.add(ProposalModel(v));
        // });

        // _proposalList = List<ProposalModel>.from(tmp));

        proposalListList.forEach((element) {
          // capsaPrint(element);
          ProposalModel _proposalModel = ProposalModel(
            invoice_value: element['invoice_value'].toString(),
            p_type: element['p_type'].toString(),
            start_date: element['start_date'],
            due_date: element['due_date'],
            eff_due_date: element['eff_due_date'],
            minimum_investment: element['minimum_investment'],
            invoice_number: element['invoice_number'],
            description: element['description'],
            customer_name: element['customer_name'],
            comp_contract_address: element['comp_contract_address'],
            child_address: element['child_address'],
            discount_percentage: element['discount_percentage'].toString(),
            discount_status: element['discount_status'],
            companyName: element['companyName'],
            lender_pan: element['lender_pan'],
            cust_pan: element['cust_pan'],
            comp_pan: element['comp_pan'],
            prop_amt: element['prop_amt'].toString(),
            int_rate: element['int_rate'].toString(),
            prop_stat: element['prop_stat'].toString(),
            docID: element['docID'],
            sign_stat: element['sign_stat'].toString(),
            ask_amt: element['ask_amt'].toString(),
            digital_name: element['digital_name'],
            digital_name_buyer: element['digital_name_buyer'],
            digital_name_accept_time: element['digital_name_accept_time'],
            digital_name_buyer_accept_time: element['digital_name_buyer_accept_time'],
          );
          _proposalList.add(_proposalModel);
        });
        _proposalDataList.addAll(_proposalList);
        notifyListeners();
      }
      return data;
    }

    return null;
  }

  Future<Object> loadPurchaseAgreement(invoice, download, {dName}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};
      capsaPrint('loadPurchaseAgreement');
      // capsaPrint('userData');
      // capsaPrint(invoice.cust_pan);

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];

      _body['hidden_download'] = download;
      _body['hidden_comp_pan'] = invoice.comp_pan;
      _body['hidden_cust_pan'] = invoice.cust_pan;
      _body['hidden_inv_pan'] = invoice.lender_pan;
      _body['hidden_inv_no'] = invoice.invoice_number;

      if (dName != null) _body['hidden_digisign'] = dName;

      // _body['hidden_digisign'] = '';

      _body['hidden_adata'] = jsonEncode(invoice.toJson());

      // capsaPrint('_body');
      // capsaPrint(_body);

      dynamic _uri;
      _uri = apiUrl + 'dashboard/i/loadPurchaseAgreement';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,  headers: <String, String>{
        'Authorization': 'Basic '+box.get('token',defaultValue: '0')
      }, body: _body);
      var data = jsonDecode(response.body);

      // if(download)

      return data;
    }

    return null;
  }


  downloadFile(_url) async {
    dynamic _uri = _url ;
    _uri = Uri.parse(_uri);
    var _body = {};
    var response = await http.get(_uri);
    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes], "application/pdf");
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = 'Sale Agreement.pdf';
      anchorElement.click();
      html.Url.revokeObjectUrl(url);
    }

  }
}
