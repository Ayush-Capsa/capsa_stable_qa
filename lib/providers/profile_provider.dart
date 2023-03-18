import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/vendor-new/model/account_letter_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:universal_html/html.dart' as html;

class ProfileProvider extends ChangeNotifier {
  List<ProfileModel> _bidHistoryDataList = [];

  List<BankDetails> bankDetails = [];

  List<TransactionDetails> transactionDetails = [];
  List<PendingTransactionDetails> pendingTransactionDetails = [];
  List _bankList = [];
  bool _withdrawResponseReceived = false;
  dynamic _withdrawResponse;
  BankDetails statementBankDetails;

  PortfolioData _portfolioData = PortfolioData(
    totalDiscount: 0,
    activeAmt: 0,
    activeCount: 0,
    totalTransactions: 0,
    transactionCount: 0,
    newUser: false,
    kyc1: "",
    kyc2: "",
    kyc3: "",
    kyc1File: "",
    kyc2File: "",
    kyc3File: "",
  );

  MyPortfolioData _myPortfolioData =
      MyPortfolioData(companyInyPortfolio: 0, invoiceBought: 0, vendorList: []);

  PortfolioData get portfolioData => _portfolioData;

  MyPortfolioData get myPortfolioData => _myPortfolioData;

  dynamic get withdrawResponse => _withdrawResponse;

  bool get withdrawResponseReceived => _withdrawResponseReceived;

  List get bankList => _bankList;

  BankDetails get getStatementBankDetails =>
      statementBankDetails;

  List _userDetails = [];

  BankDetails get getBankDetails =>
      (bankDetails.isNotEmpty) ? bankDetails[0] : null;

  bool _newUser = false;

  bool get newUser => _newUser;

  UserData get userDetails => (_userDetails.length > 0)
      ? _userDetails[0]
      : UserData("", "", "", "", "", "", "", "");

  num _totalBalance = 0;

  num _totalBalanceToWithDraw = 0;

  num get totalBalance => _totalBalance;

  num get totalBalanceToWithDraw => _totalBalanceToWithDraw;

  num _totalDeposits = 0;

  num get totalDeposits => _totalDeposits;

  num _totalWithdraw = 0;

  num get totalWithdraw => _totalWithdraw;

  List<ProfileModel> get bidHistoryDataList => _bidHistoryDataList;

  final box = Hive.box('capsaBox');

  bool _enableRevenueSell = false;

  bool get enableRevenueSell => _enableRevenueSell;

  Future<Object> myportfoliopageData() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];

      dynamic _uri;
      _uri = apiUrl + 'dashboard/i/get-my-portfolio';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      List<VendorListPortfolio> vendorList = [];
      if (data['res'] == 'success') {
        var _data = data['data'];

        for (var vendor in _data['anchorList']) {
          VendorListPortfolio _vendorListPortfolio = VendorListPortfolio(
            companyPan: vendor['company_pan'],
            lastInvestment: vendor['lastInvestment'],
            percent: vendor['percent'],
            name: vendor['name'],
            totalInvestment: vendor['totalInvestment'],
          );

          vendorList.add(_vendorListPortfolio);
        }

        _myPortfolioData = MyPortfolioData(
          companyInyPortfolio: _data['companyInyPortfolio'],
          invoiceBought: _data['invoiceBought'],
          vendorList: vendorList,
        );

        notifyListeners();
      }
    }
  }

  Future<Object> queryPortfolioData() async {
    capsaPrint('queryPortfolioData called');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];

      dynamic _uri;
      _uri = apiUrl + 'dashboard/r/portfolio';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      capsaPrint('Portfolio Data 1 : $data');
      if (data['res'] == 'success') {
        var _data = data['data'];

        if (_data['totalDiscount'] == null) _data['totalDiscount'] = 0;
        if (_data['activeAmt'] == null) _data['activeAmt'] = 0;
        if (_data['activeCount'] == null) _data['activeCount'] = 0;

        _portfolioData = PortfolioData(
          totalDiscount: _data['totalDiscount'],
          activeAmt: _data['activeAmt'],
          activeCount: _data['activeCount'],
          totalTransactions: _data['totalTransactions'],
          newUser: _data['newUser'],
          kyc1: _data['kyc1'],
          kyc2: _data['kyc2'],
          kyc3: _data['kyc3'],
          AL_UPLOAD: _data['AL_UPLOAD'],
          kyc1File: _data['kyc1File'],
          kyc2File: _data['kyc2File'],
          kyc3File: _data['kyc3File'],
          account_letterDoc: _data['account_letterDoc'],
        );
        _newUser = _data['newUser'];
        // capsaPrint(_portfolioData);
        notifyListeners();
      }
      return data;
    }
    return null;
  }

  Future<Object> queryPortfolioData2() async {
    capsaPrint('queryPortfolioData 2 ');
    if (box.get('isAuthenticated', defaultValue: false)) {
      capsaPrint('Query Data pass 0');

      var userData = Map<String, dynamic>.from(box.get('userData'));

      capsaPrint('Query Data pass 0.1');

      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      capsaPrint('Query Data pass 0.2');
      dynamic _uri;
      _uri = apiUrl + 'dashboard/i/portfolio';
      _uri = Uri.parse(_uri);
      capsaPrint('Query Data pass 0.3 $_uri $_body');
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      capsaPrint('Query Data pass 0.4 \n${response.body}');
      var data = jsonDecode(response.body);
      capsaPrint('Query Data pass 1');
      if (data['res'] == 'success') {
        capsaPrint('Query Data pass 2');
        var _data = data['data'];
        capsaPrint('Query Data pass 3');

        if (_data['totalDiscount'] == null) _data['totalDiscount'] = 0;
        if (_data['grandannualExpReturn'] == null)
          _data['grandannualExpReturn'] = 0;
        if (_data['grandTotalExpReturn'] == null)
          _data['grandTotalExpReturn'] = 0;

        num grandTotalDiscount = _data['totalDiscount'];
        num grandAnnualExpectedReturn = _data['grandTotalExpReturn'];
        num returnPercentage =
            (grandAnnualExpectedReturn / grandTotalDiscount) * 100;
        num retPer = returnPercentage;

        var returnPercent = '0';
        if (_data['returnPercent'] != null)
          returnPercent = _data['returnPercent'].toStringAsFixed(2);

        var up_pymt = _data['up_pymt'];
        List upPmt = [];
        if (up_pymt != null && up_pymt.length > 0) {
          up_pymt.forEach((element) {
            if (element['payment_status'] == 0) upPmt.add(element);
          });
        }
        capsaPrint('Query Data pass 4');

        capsaPrint('Portfolio Data WEEK: $data');

        _portfolioData = PortfolioData(
          totalUpcomingPayments: _data['totalUpcomingPayments'],
            totalDiscount: _data['totalDiscount'],
            totalReceived: _data['totalReceived'],
            transactionCount: _data['transactionCount'],
            activeCount: _data['activeBidsCount'],
            companyPortfolioDetails: _data['companyPortfolioDetails'],
            ExpectedReturn: _data['ExpectedReturn'],
            grandTotalExpReturn: _data['grandTotalExpReturn'],
            grandannualExpReturn: _data['grandannualExpReturn'],
            marker: _data['marker'],
            x_axis: _data['x_axis'],
            y_axis: _data['y_axis'],
            y_axis_gain_per: _data['y_axis_gain_per'],
            up_pymt: upPmt,
            account_no: _data['account_no'],
            retPer: retPer,
            newUser: _data['newUser'],
            investorType: _data['investorType'],
            kyc1: _data['kyc1'],
            kyc2: _data['kyc2'],
            kyc3: _data['kyc3'],
            kyc1File: _data['kyc1File'],
            kyc2File: _data['kyc2File'],
            kyc3File: _data['kyc3File'],
            totalUpcomingPaymentin1month:
                _data['totalUpPaymentsIn1Month'] ?? 0.0,
            totalUpcomingPaymentin1week:
                _data['totalUpPaymentsIn1Week'] ?? 0.0,
            percentageOfPaymentIn1month:
                _data['percentageIn1Month'] ?? 0.0,
            percentageOfPaymentIn1week:
                _data['percentageIn1Week'] ?? 0.0,
            returnPercent: returnPercent,
            invIn1Week: _data['invoicesIn1Week'],
            invIn1Month: _data['invoicesIn1Month'],
            invIn2Month: _data['invoicesIn2Months'],
            invIn6Month: _data['invoicesIn6Months'],
            pymtIn1Week: _data['totalUpPaymentsIn1Week'],
            pymtIn1Month: _data['totalUpPaymentsIn1Month'],
            pymtIn2Month: _data['totalUpPaymentsIn2Months'],
            pymtIn6Month: _data['totalUpPaymentsIn6Months'],
            perIn1Week: _data['percentageIn1Week'],
            perIn1Month: _data['percentageIn1Month'],
            perIn2Month: _data['percentageIn2Months'],
            perIn6Month: _data['percentageIn6Months']);

        // capsaPrint(_portfolioData);
        notifyListeners();
      }
      capsaPrint('Protfolio Data Loaded');
      return data;
    }
    return null;
  }

  Future<Object> queryProfile() async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      var _role = userData['role'];
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      dynamic _uri;
      if (_role == 'INVESTOR')
        _uri = apiUrl + 'dashboard/i/profile';
      else
        _uri = apiUrl + 'dashboard/r/profile';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      if (data['res'] == 'success') {
        var _data = data['data'];
        // capsaPrint('_data');
        // capsaPrint(_data);

        var bankDetails = _data['bankDetails'];
        List<ProfileModel> _profileModel = [];

        _bidHistoryDataList.addAll(_profileModel);
        notifyListeners();
      }
      return data;
    }
    return null;
  }

  Future<Object> getKYCFiles(_body) async {
    return await callApi('dashboard/r/getKYCFiles', body: _body);
  }

  Future<Object> downloadFile(String url, fName) async {
    dynamic _uri = Uri.parse(url);

    var response = await http.get(_uri);

    // capsaPrint(data);

    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = fName + '.pdf';
      anchorElement.click();
      html.Url.revokeObjectUrl(url);
    }
    return null;
  }

  Future<Object> uploadKYCFiles(
      PlatformFile file1, PlatformFile file2, PlatformFile file3) async {
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('userData'));
    dynamic _uri;
    var _role = userData['role'];
    // if (_role == 'INVESTOR')
    //   _uri = apiUrl + 'dashboard/i/profileUploadKyc';
    // else
    _uri = apiUrl + 'dashboard/r/profileUploadKyc';

    _uri = Uri.parse(_uri);
    _body['panNumber'] = userData['panNumber'];
    _body['bvnNo'] = userData['panNumber'];

    _body['userName'] = userData['userName'];
    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');

    request.fields['kyc1'] = portfolioData.kyc1.toString();
    request.fields['kyc2'] = portfolioData.kyc2.toString();
    request.fields['kyc3'] = portfolioData.kyc3.toString();

    _body.forEach((key, value) {
      request.fields[key] = value;
    });

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');
    if (portfolioData.kyc1 == null || file1 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'kyc1',
        file1.bytes,
        filename: _body['bvnNo'] +
            '_kyc1' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file1.extension,
        contentType: MediaType('application', 'octet-stream'),
      ));

    if (file2 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'kyc2',
        file2.bytes,
        filename: _body['bvnNo'] +
            '_kyc2' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file2.extension,
        contentType: MediaType('application', 'octet-stream'),
      ));

    if (file3 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'kyc3',
        file3.bytes,
        filename: _body['bvnNo'] +
            '_kyc3' +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file3.extension,
        contentType: MediaType('application', 'octet-stream'),
      ));

    var res = await request.send();
    // capsaPrint(res.reasonPhrase);
    return jsonDecode((await http.Response.fromStream(res)).body);

    return null;
  }

  Future<Object> uploadAccountLetterFile(PlatformFile file1) async {
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('userData'));
    dynamic _uri;
    var _role = userData['role'];

    _uri = apiUrl + 'signup/setActive';

    _uri = Uri.parse(_uri);
    _body['panNumber'] = userData['panNumber'];
    _body['bvnNo'] = userData['panNumber'];
    _body['bvn'] = userData['panNumber'];

    _body['userName'] = userData['userName'];
    _body['role'] = userData['role'];
    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    var extension = file1.extension;
    if (file1 != null)
      request.files.add(http.MultipartFile.fromBytes(
        'account_letter',
        file1.bytes,
        filename: _body['bvnNo'] + '_accLetter.' + extension,
        contentType: MediaType('application', 'octet-stream'),
      ));

    var res = await request.send();
    return jsonDecode((await http.Response.fromStream(res)).body);

    return null;
  }

  Future<void> queryPendingBankTransactions() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      dynamic _uri;
      _uri = apiUrl + 'dashboard/r/pendingWithDraw';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      if (data['res'] == 'success') {
        var _data = data['data'];
        // capsaPrint('_data');
        // capsaPrint(_data);
        // capsaPrint('Data $data');

        if (data['messg'] == 'pending withdraws') {
          List<PendingTransactionDetails> _transactionDetails = [];

          var tmpTransactionDetails = _data;

          tmpTransactionDetails.forEach((element) {
            PendingTransactionDetails _tmptransactionDetails =
                PendingTransactionDetails(
              account_number: element['account_number'] != null
                  ? element['account_number'].toString()
                  : '',
              created_on: element['created_at'] != null
                  ? element['created_at'].toString()
                  : '',
              status:
                  element['status'] != null ? element['status'].toString() : '',
              trans_amt: element['trans_amount'] != null
                  ? element['trans_amount'].toString()
                  : '',
              updated_on: element['updated_at'] != null
                  ? element['updated_at'].toString()
                  : '',
              ref_no:
                  element['ref_no'] != null ? element['ref_no'].toString() : '',
            );
            _transactionDetails.add(_tmptransactionDetails);
          });
          pendingTransactionDetails = [];
          pendingTransactionDetails.addAll(_transactionDetails);
        } else {
          pendingTransactionDetails = [];
        }
        notifyListeners();
      }
    }
  }

  Future<Object> queryBankTransaction({date,}) async {
    //capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      //await queryPendingBankTransactions();
      //capsaPrint('here 2');
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      // _body['currency'] = currency;
      if (date != null) _body['date'] = date.toString();
      dynamic _uri;

      var _role = userData['role'];
      if (_role == 'INVESTOR')
        _uri = apiUrl + 'dashboard/i/tList';
      else
        _uri = apiUrl + 'dashboard/r/tList';

      _uri = Uri.parse(_uri);
      //capsaPrint('here 2.1');
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      //capsaPrint('here 2.2');
      var data = jsonDecode(response.body);
      //capsaPrint('here 3');
      //capsaPrint("details : \n${data}");
      if (data['res'] == 'success') {
        var _data = data['data'];
        // capsaPrint('_data');
        //capsaPrint("bank details : \n${_data['bankDetails']}");

        List<BankDetails> _bankDetails = [];
        List<TransactionDetails> _transactionDetails = [];

        var tmpBankDetails = _data['bankDetails'];
        var tmpTransactionDetails = _data['transactionDetails'];
        tmpBankDetails?.forEach((element) {
          BankDetails _tmpBankDetails = BankDetails(
            PAN_NO:
                element['PAN_NO'] != null ? element['PAN_NO'].toString() : '',
            bank_name: element['bank_name'] != null
                ? element['bank_name'].toString()
                : '',
            IBTC: element['IBTC'] != null ? element['IBTC'].toString() : '',
            ifsc: element['ifsc'] != null ? element['ifsc'].toString() : '',
            account_number: element['account_number'] != null
                ? element['account_number'].toString()
                : '',
            bene_account_no: element['bene_account_no'] != null
                ? element['bene_account_no'].toString()
                : '',
            bene_ifsc: element['bene_ifsc'] != null
                ? element['bene_ifsc'].toString()
                : '',
            bene_bank: element['bene_bank'] != null
                ? element['bene_bank'].toString()
                : '',
            bene_account_holdername: element['bene_account_holdername'] != null
                ? element['bene_account_holdername'].toString()
                : '',
            bene_bvn: element['bene_bvn'] != null
                ? element['bene_bvn'].toString()
                : '',
            trf_typ_ft: element['trf_typ_ft'] != null
                ? element['trf_typ_ft'].toString()
                : '',
            pan_copy: element['pan_copy'] != null
                ? element['pan_copy'].toString()
                : '',
            chq_copy: element['chq_copy'] != null
                ? element['chq_copy'].toString()
                : '',
            inflow: element['totalInflow'].toString(),
            outflow: element['totalOutflow'] != null
                ? element['totalOutflow'].toString()
                : '',

          );

          //capsaPrint('_data 2 ${element['totalInflow'].toString()} ${_tmpBankDetails.inflow} ${_tmpBankDetails.outflow} ${_tmpBankDetails.bene_bvn} ${_tmpBankDetails.account_number}');


          bankDetails.add(_tmpBankDetails);
          statementBankDetails = _tmpBankDetails;
        });

        bankDetails.addAll(_bankDetails);
        _bankList = [];
        var tmpBankList = _data['banklist'];
        //var tmpBankList = null;
        List<BankList> _tmpBankList = [];
        BankList _tmpBankDetails =
            BankList('', 'Select Bank Name from Dropdown');
        _tmpBankList.add(_tmpBankDetails);
        tmpBankList?.forEach((element) {
          BankList _tmpBankDetails =
              BankList(element['code'].toString(), element['name']);
          _tmpBankList.add(_tmpBankDetails);
        });

        _bankList.addAll(_tmpBankList);

        int i = 0;

        tmpTransactionDetails?.forEach((element) {
          if(i == 0){
            capsaPrint('Transaction Details');
            capsaPrint(element);
          }

          i++;


          TransactionDetails _tmptransactionDetails = TransactionDetails(
            account_number: element['account_number'] != null
                ? element['account_number'].toString()
                : '',
            blocked_amt: element['blocked_amt'] != null
                ? element['blocked_amt'].toString()
                : '',
            closing_balance: element['closing_balance'] != null
                ? element['closing_balance'].toString()
                : '',
            created_on:
                element['created_on'] != null ? element['created_on'] : '',
            deposit_amt: element['deposit_amt'] != null
                ? element['deposit_amt'].toString()
                : '',
            id: element['id'] != null ? element['id'].toString() : '',
            narration: element['narration'] != null ? element['narration'] : '',
            opening_balance: element['opening_balance'] != null
                ? element['opening_balance'].toString()
                : '',
            order_number: element['order_number'] != null
                ? element['order_number'].toString()
                : '',
            stat_txt: element['stat_txt'] != null ? element['stat_txt'] : '',
            status: element['status'] != null ? element['status'] : '',
            trans_hash: element['trans_hash'] != null
                ? element['trans_hash'].toString()
                : '',
            updated_on:
                element['updated_on'] != null ? element['updated_on'] : '',
            withdrawl_amt: element['status'] != null
                ? element['status'] == 'PENDING'
                    ? element['pending_amt_transaction'].toString()
                    : element['status'] == 'FAILED'
                        ? element['failed_amt'].toString()
                        : element['withdrawl_amt'].toString()
                : '',
            reference: element['reference'] != null ? element['reference'] : '',
          );
          _transactionDetails.add(_tmptransactionDetails);
        });

        transactionDetails = [];
        transactionDetails.addAll(_transactionDetails);
        // for(int i = 0;i<10;i++){
        //   print(transactionDetails[i].closing_balance);
        //   print('\n');
        // }

        notifyListeners();
      }
      //capsaPrint('here 4');
      return data;
    }
    return null;
  }

  Future downloadLetter() async {
    dynamic _uri = apiUrl + 'signin/accountletterdownload';
    _uri = Uri.parse(_uri);
    var _body = {};
    Box box = Hive.box('capsaBox');

    var signUpData = box.get('signUpData');
    _body['panNumber'] = signUpData['panNumber'];
    _body['role'] = signUpData['role'];

    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    // var response = await callApi('signin/accountletterdownload', body: _body);
    // capsaPrint(response);

    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes], "application/octet-stream");
      final url = html.Url.createObjectUrlFromBlob(blob);

      // final anchor = html.document.createElement('a') as html.AnchorElement
      //   ..href = url
      //   ..style.display = 'none'
      //   ..download = 'Account Letter.pdf';
      // html.document.body.children.add(anchor);
      //
      // anchor.click();
      //
      // html.document.body.children.remove(anchor);
      // html.Url.revokeObjectUrl(url);

      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = 'Account Letter.docx';
      anchorElement.click();
      html.Url.revokeObjectUrl(url);
    }

    return null;
  }

  Future<Object> queryFewData() async {
    //capsaPrint('few data called $currency');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      //_body['currency'] = currency;
      dynamic _uri;

      var _role = userData['role'];
      if (_role == 'INVESTOR')
        _uri = apiUrl + 'dashboard/i/fewacc';
      else
        _uri = apiUrl + 'dashboard/r/fewacc';

      _uri = Uri.parse(_uri);
      //capsaPrint('Uri : ${_uri} \n Authorization: ${'Basic ' + box.get('token', defaultValue: '0')}\nbody: $_body');
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      capsaPrint('Few Data $data');
      if (data['res'] == 'success') {
        var _data = data['data'];
        // capsaPrint('_data');
        // capsaPrint(_data);

        List<BankDetails> _bankDetails = [];

        var tmpBankDetails = _data['bankDetails'];

        _data['toBal'] = _data['toBal'].toStringAsFixed(2);

        _totalBalance = double.parse(_data['toBal']);

        try {
          _totalBalanceToWithDraw =
              double.parse(_data['toWithdrawBal'].toString());
        } catch (e) {}
        _totalDeposits = _data['totDeposit'];
        _totalWithdraw = _data['totwithdrawl'];

        // capsaPrint(_data);
        // capsaPrint('_totalBalance');
        // capsaPrint(_totalBalance);

        tmpBankDetails.forEach((element) {
          BankDetails _tmpBankDetails = BankDetails(
            PAN_NO: element['PAN_NO'],
            bank_name: element['bank_name'],
            IBTC: element['IBTC'].toString(),
            ifsc: element['ifsc'].toString(),
            account_number: element['account_number'].toString(),
            bene_account_no: element['bene_account_no'].toString(),
            bene_ifsc: element['bene_ifsc'],
            bene_bank: element['bene_bank'],
            bene_account_holdername: element['bene_account_holdername'],
            bene_bvn: element['bene_bvn'],
            trf_typ_ft: element['trf_typ_ft'].toString(),
            pan_copy: element['pan_copy'],
            chq_copy: element['chq_copy'],
          );
          _bankDetails.add(_tmpBankDetails);
        });

        bankDetails.addAll(_bankDetails);

        var tmpUser = _data['user'];
        tmpUser.forEach((element) {
          UserData _user = UserData(
            element['ADD_LINE'],
            element['CITY'],
            element['COUNTRY'],
            element['STATE'],
            element['cc'],
            element['contact'],
            element['email'],
            element['nm'],
          );
          _userDetails = [];
          _userDetails.add(_user);
        });

        notifyListeners();
      }
      return data;
    }
    return null;
  }

  addUser(UserData userPass) {
    UserData _user = userPass;
    _userDetails.add(_user);
  }

  Future<Object> addBeneCall(
      BankList bank, String accountNo1, String accountNo2) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      _body['bank'] = jsonEncode(bank.toJson());
      _body['accountNo1'] = accountNo1;
      _body['accountNo2'] = accountNo2;
      _body['step'] = 'ADD';
      dynamic _uri;

      var _role = userData['role'];
      if (_role == 'INVESTOR')
        _uri = apiUrl + 'dashboard/i/addbene';
      else
        _uri = apiUrl + 'dashboard/r/addbene';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      // if (data['res'] == 'success') {
      //
      //
      // }
      return data;
    }
    return null;
  }

  Future<Object> getUserEmailPreference() async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      var _role = userData['role'];
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      if(_body['role'] == 'COMPANY'){
        _body['role'] = 'VENDOR';
      }else if(_body['role'] == 'BUYER'){
        _body['role'] = 'ANCHOR';
      }
      dynamic _uri;
      // if (_role == 'INVESTOR')
      //   _uri = apiUrl + 'dashboard/i/profile';
      // else
      _uri = apiUrl + 'dashboard/r/getUserEmailPreferences';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      //capsaPrint('Body : $_bankList')

      // if (data['res'] == 'success') {
      //   var _data = data['data'];
      //   // capsaPrint('_data');
      //   // capsaPrint(_data);
      //
      //   var bankDetails = _data['bankDetails'];
      //   List<ProfileModel> _profileModel = [];
      //
      //   _bidHistoryDataList.addAll(_profileModel);
      //   notifyListeners();
      // }
      return data;
    }
    return null;
  }

  Future<Object> setUserEmailPreference(dynamic _body) async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _role = userData['role'];
      capsaPrint('PanNumber : ${userData['panNumber']} ');
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      dynamic _uri;
      // if (_role == 'INVESTOR')
      //   _uri = apiUrl + 'dashboard/i/profile';
      // else
      _uri = apiUrl + 'dashboard/r/setUserEmailPreferences';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      //capsaPrint('Body : $_bankList')

      // if (data['res'] == 'success') {
      //   var _data = data['data'];
      //   // capsaPrint('_data');
      //   // capsaPrint(_data);
      //
      //   var bankDetails = _data['bankDetails'];
      //   List<ProfileModel> _profileModel = [];
      //
      //   _bidHistoryDataList.addAll(_profileModel);
      //   notifyListeners();
      // }
      return data;
    }
    return null;
  }

  Future<Object> withDrawAmt(amount, desc, accountNo, order_number) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'];
      _body['trf_amt'] = amount;
      if (desc != null) _body['desc'] = desc;
      _body['bene_account_no'] = accountNo;
      _body['order_number'] = order_number;

      _body['step'] = 'withdraw';
      dynamic _uri;
      _uri = apiUrl + 'dashboard/r/withDrawAmt';
      _uri = Uri.parse(_uri);

      // capsaPrint(_body);

      var response = await http
          .post(_uri,
              headers: <String, String>{
                'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
              },
              body: _body)
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          var response1 = {
            'res': 'failed',
            'messg':
                'Failed to receive update from bank server. Check account for transaction status!'
          };
          return http.Response(jsonEncode(response1),
              408); // Request Timeout response status code
        },
      );
      var data = jsonDecode(response.body);
      // if (data['res'] == 'success') {
      //
      //
      // }
      _withdrawResponse = data;
      _withdrawResponseReceived = true;
      notifyListeners();
      return data;
    }
    return null;
  }

  Future<Object> resetWithdrawData() {
    _withdrawResponse = null;
    _withdrawResponseReceived = false;
    notifyListeners();
  }

  Future<Object> updateData(_body) async {
    dynamic _uri;
    _uri = apiUrl + 'dashboard/r/updateProfile';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> getAccountLetters() async {
    dynamic _uri;
    capsaPrint('pass 1 account letter');
    _uri = apiUrl + 'dashboard/r/getAnchors';
    _uri = Uri.parse(_uri);
    var userData = Map<String, dynamic>.from(box.get('userData'));
    var _body = {};
    _body['panNumber'] = userData['panNumber'];
    capsaPrint('pass 2 account letter $_body');
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);

    var data = jsonDecode(response.body);

    capsaPrint('pass 3 account letter \n$data\n\n');



    capsaPrint('pass 3.1 account letter ${data['anchorsList']}\n\n');

    List<String> anchorsNameList = [];

    for(int i = 0;i<data['anchorsList'].length;i++){
      capsaPrint('pass 3.1 account letter ${data['anchorsList'][i]}\n\n');
      anchorsNameList.add(data['anchorsList'][i].toString());
    }



    capsaPrint('Pass 4 account letter');

    var accountLetterList = data['data'];
    List<AccountLetterModel> accountLetterModels = [];
    capsaPrint('Pass 5 account letter');
    accountLetterList.forEach((element) {
      AccountLetterModel model = AccountLetterModel(
        element['anchor_name'] ?? "",
        element['companyPan'] ?? "",
        element['customerPan'] ?? "",
        element['account_letter_url'] ?? "",
        element['account_letter_ext'] ?? "",
        element['uploaded'] != null ? element['uploaded'].toString() : "",
        element['approved'] != null ? element['approved'].toString() : "",
      );
      accountLetterModels.add(model);
    });
    capsaPrint('Pass 6 account letter');

    AnchorsListApiModel anchorsList = AnchorsListApiModel(anchorsNameList, accountLetterModels);

    //anchorsList.accountLetters = accountLetterModels;

    capsaPrint('Pass 7 account letter');

    return anchorsList;
  }

  Future<Object> saveAnchorList(List<dynamic> cuGst) async {
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    dynamic _uri;
    var _role = userData['role'];

    _uri = apiUrl + 'signup/saveAnchors';

    String anchorPan = '';
    for(int i = 0;i<cuGst.length;i++){
      if(i == 0){
        anchorPan += cuGst[i];
      }else{
        anchorPan += ' ' + cuGst[i];
      }
    }

    _uri = Uri.parse(_uri);
    _body['vendorPan'] = userData['panNumber'];
    _body['anchorPan'] = anchorPan;

    _body['bvnNo'] = userData['panNumber'];
    _body['bvn'] = userData['panNumber'];
    var response = await http.post(_uri, headers: <String, String>{
      'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
    }, body: _body);
    capsaPrint('save anchor $_uri $_body');
    capsaPrint(response.body);
    var data = jsonDecode(response.body);
    return data;

    return null;
  }

  Future getAnchorsList() async {
    dynamic _uri = apiUrl + 'signup/getAllAnchors';
    _uri = Uri.parse(_uri);
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    _body['panNumber'] = userData['panNumber'];
    capsaPrint('company name pass 1 anchors list');
    var response = await http.post(_uri, headers: <String, String>{
      'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
    }, body: _body);
    capsaPrint('company name pass 2');
    capsaPrint(response.body);
    var data = jsonDecode(response.body);

    // if (data['res'] == 'success') {
    //   for (int i = 0; i < data['data'].length; i++) {
    //     _anchorsNameList.add(data['data'][i]['name']);
    //     _cinList[data['data'][i]['name']] = data['data'][i]['cu_pan'];
    //   }
    // }

    return data;
  }

  Future checkLastPasswordReset() async {
    capsaPrint('Pass 1 check password reset');
    String _uri = 'signin/checkLastPasswordReset';
    //_uri = Uri.parse(_uri);
    //capsaPrint('company name pass 1');
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    _body['panNumber'] = userData['panNumber'];
    capsaPrint('Pass 2 check password reset');
    var response = await callApi(_uri, body: _body);
    // capsaPrint('Pass 3 check password reset ${response.body}');
    // // await http.post(_uri,
    // //     headers: <String, String>{
    // //       'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
    // //     },
    // //     body: _body);
    // //capsaPrint('company name pass 2');
    // capsaPrint(response.body);
    // var data = jsonDecode(response.body);

    // if (data['res'] == 'success') {
    //   for (int i = 0; i < data['data'].length; i++) {
    //     _anchorsNameList.add(data['data'][i]['name']);
    //     _cinList[data['data'][i]['name']] = data['data'][i]['cu_pan'];
    //   }
    // }

    return response;
  }

}
