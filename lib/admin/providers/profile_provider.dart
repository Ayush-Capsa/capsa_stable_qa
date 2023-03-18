import 'package:capsa/admin/models/invoice_model.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';

class ProfileProvider extends ChangeNotifier {
  List<ProfileModel> _bidHistoryDataList = [];

  List<BankDetails> bankDetails = [];
  List _bankList = [];

  List get bankList => _bankList;

  bool _withdrawResponseReceived = false;

  dynamic _withdrawResponse;

  List<TransactionDetails> transactionDetails = [];

  List<TransactionDetails> ledgerTransactionDetails = [];

  dynamic get withdrawResponse => _withdrawResponse;

  bool get withdrawResponseReceived => _withdrawResponseReceived;

  List<String> ledgerAccNames = [];
  List ledgerAccNamesList = [];

  BankDetails get getBankDetails =>
      (bankDetails.isNotEmpty) ? bankDetails[0] : null;

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

  //get withdrawResponse => null;

  Future<Object> reconcilePlatformBalanceApi() async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/reconcilationPlatformBalance';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      try {
        var response = await http.post(_uri,
            headers: <String, String>{
              'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
            },
            body: _body);
        capsaPrint('Response recociliation api ${response.body}');
        var data = jsonDecode(response.body);

        return data;
      } catch (e) {
        return {"message": "failed"};
      }
    }
    return null;
  }

  Future<Object> reconcilePoolBalanceApi() async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/reconcilationPoolBalance';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      try {
        var response = await http
            .post(_uri,
                headers: <String, String>{
                  'Authorization':
                      'Basic ' + box.get('token', defaultValue: '0')
                },
                body: _body)
            .timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            // Time has run out, do what you wanted to do.
            var response1 = {
              "message": "failed",
            };
            return http.Response(jsonEncode(response1), 408);
            // Request Timeout response status code
          },
        );
        capsaPrint('Response recociliation api ${response.body}');
        var data = jsonDecode(response.body);

        return data;
      } catch (e) {
        return {"message": "failed"};
      }
    }
    return null;
  }

  Future<Object> closingBalanceList() async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/allClosingBalance';
      _uri = Uri.parse(_uri);

      Map<String, String> panNumber = {};
      Map<String, String> name = {};

      // capsaPrint('_body');
      // capsaPrint(_body);

      try {
        var response = await http.post(_uri,
            headers: <String, String>{
              'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
            },
            body: _body);
        //capsaPrint('Response recociliation api ${response.body}');
        var data = jsonDecode(response.body);

        //capsaPrint('Pass 1 closing balance list');

        //capsaPrint('All Closing Balance response: \n $data');

        dynamic details = data['data']['details'];
        dynamic closingBalances = data['data']['balances'];

        //capsaPrint('Pass 2 closing balance list ${details.length} ${closingBalances.length}');

        List<ClosingBalanceModel> models = [];

        for (int i = 0; i < details.length; i++) {
          dynamic e = details[i];
          //capsaPrint('$i ${e['account_number']} ${e['PAN_NO']} ${e['NAME']}');
          panNumber[e['account_number'].toString()] = e['PAN_NO'].toString();
          name[e['account_number'].toString()] = e['NAME'].toString();
        }

        //capsaPrint('Pass 3 closing balance list');

        for (int i = 0; i < closingBalances.length; i++) {
          dynamic e = closingBalances[i];
          models.add(ClosingBalanceModel(
              closingBalance: e['closing_balance'].toString(),
              accountNumber: e['account_number'].toString(),
              panNumber: panNumber[e['account_number']],
              name: name[e['account_number']]));

          //capsaPrint('Pass 4 closing balance list');

        }

        return models;

        //return data;
      } catch (e) {
        capsaPrint(e);

        return {"message": "failed"};
      }
    }
    return null;
  }

  Future<Object> queryProfile() async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'] ?? 'Admin';
      dynamic _uri;
      _uri = apiUrl + 'admin/profile';
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

  Future<Object> transferAmount(_body, {confirm}) async {
    var userData = Map<String, dynamic>.from(box.get('userData'));
    dynamic _uri;

    capsaPrint('confirm');
    capsaPrint(confirm);

    if (confirm != null && confirm) {
      _uri = apiUrl + 'admin/transferAmountConfirm';
    } else {
      _uri = apiUrl + 'admin/transferAmount';
    }

    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    return jsonDecode(response.body);
  }

  Future<Object> queryBankTransaction() async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'] ?? 'Admin';
      // capsaPrint(_body);
      dynamic _uri;
      _uri = apiUrl + 'admin/tList';
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

        List<BankDetails> _bankDetails = [];
        List<TransactionDetails> _transactionDetails = [];

        var tmpBankDetails = _data['bankDetails'];
        var tmpTransactionDetails = _data['transactionDetails'];

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

        _bankList = [];
        var tmpBankList = _data['banklist'];
        List<BankList> _tmpBankList = [];
        BankList _tmpBankDetails =
            BankList('', 'Select Bank Name from Dropdown');
        // _tmpBankList.add(_tmpBankDetails);
        tmpBankList.forEach((element) {
          BankList _tmpBankDetails =
              BankList(element['code'].toString(), element['name']);
          _tmpBankList.add(_tmpBankDetails);
        });

        _bankList.addAll(_tmpBankList);

        tmpTransactionDetails.forEach((element) {
          // capsaPrint(element);

          TransactionDetails _tmptransactionDetails = TransactionDetails(
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
            status: element['status'],
            trans_hash: element['trans_hash'].toString(),
            updated_on: element['updated_on'],
            withdrawl_amt: element['withdrawl_amt'].toString(),
          );
          _transactionDetails.add(_tmptransactionDetails);
        });

        transactionDetails.addAll(_transactionDetails);

        notifyListeners();
      }
      return data;
    }
    return null;
  }

  Future<Object> getAllAccountList() async {
    var userData = Map<String, dynamic>.from(box.get('userData'));
    dynamic _uri;
    _uri = apiUrl + 'admin/getAllAccountList';
    _uri = Uri.parse(_uri);
    var _body = {};

    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);

    return jsonDecode(response.body);
  }

  Future<Object> getAllAccountTransactions({filter}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      if (filter != null) _body['filter'] = jsonEncode(filter);
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'] ?? 'Admin';
      dynamic _uri;
      _uri = apiUrl + 'admin/allAccountTransactions';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      if (data['res'] == 'success') {
        List<TransactionDetails> _transactionDetails = [];
        var _data = data['data'];
        var names = _data['names'];
        var tmpTransactionDetails = _data['transactions'];

        tmpTransactionDetails.forEach((element) {
          var estateSelected = {};
          var name = '';
          try {
            estateSelected = names.firstWhere((dropdown) =>
                dropdown['account_number'] ==
                element['account_number'].toString());
            name = estateSelected['NAME'];
          } catch (e) {
            capsaPrint(e);
          }

          TransactionDetails _tmptransactionDetails = TransactionDetails(
            name: name,
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
            status: element['status'],
            trans_hash: element['trans_hash'].toString(),
            updated_on: element['updated_on'],
            withdrawl_amt: element['withdrawl_amt'].toString(),
          );
          _transactionDetails.add(_tmptransactionDetails);
        });

        List<String> _tmpNames = [];
        _tmpNames.add('All');
        names.forEach((element) {
          String _tmo =
              element['NAME'] + ' [ ' + element['account_number'] + ' ]';
          _tmpNames.add(_tmo);
        });

        ledgerTransactionDetails = [];
        ledgerAccNames = [];
        ledgerAccNamesList = [];

        ledgerTransactionDetails.addAll(_transactionDetails);
        ledgerAccNames.addAll(_tmpNames);
        ledgerAccNamesList.addAll(names);
        notifyListeners();
      }
      return data;
    }
    return null;
  }

  Future<Object> queryFewData() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['userName'] = userData['userName'] ?? 'Admin';
      dynamic _uri;
      _uri = apiUrl + 'admin/fewacc';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      if (data['res'] == 'success') {
        var _data = data['data'];
        capsaPrint('_data');
        // capsaPrint(_data);

        List<BankDetails> _bankDetails = [];

        var tmpBankDetails = _data['bankDetails'];

        _data['toBal'] = _data['toBal'].toStringAsFixed(2);

        _totalBalanceToWithDraw = _data['toWithdrawBal'] != null
            ? double.parse(_data['toWithdrawBal'].toString())
            : 0.0;

        _totalBalance = double.parse(_data['toBal']);
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
        notifyListeners();
      }
      return data;
    }
    return null;
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

  Future<Object> withDrawAmt(amount, desc, accountNo, order_number) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      // _body['userName'] = userData['userName'];
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
        const Duration(seconds: 20),
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

  Future<Object> fetchAccountList(String role, {String search = ""}) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = role;
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/fetchAllUsersForRole';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      // capsaPrint('Response ${response.body}');
      var data = jsonDecode(response.body);

      List<AccountData> accounts = [];

      int i = 0;

      data['data']?.forEach((element) {
        if (i == 0) {
          capsaPrint(element);
          capsaPrint('\n\n');
          i++;
        }
        if (search == "" ||
            search.toLowerCase() ==
                element['PAN_NO'].toString().toLowerCase() ||
            search.toLowerCase() == element['NAME'].toString().toLowerCase()) {
          accounts.add(AccountData(
            panNumber:
                element['PAN_NO'] != null ? element['PAN_NO'].toString() : '',
            role: element['ROLE'] != null ? element['ROLE'].toString() : '',
            name: element['NAME'] != null ? element['NAME'].toString() : '',
            userId:
                element['user_id'] != null ? element['user_id'].toString() : '',
            isBlackListed: element['isBlacklisted'] != null
                ? element['isBlacklisted'] == '1'
                    ? true
                    : false
                : false,
            isRestricted: element['isAllowed'] != null
                ? element['isAllowed'] == 'p'
                    ? true
                    : false
                : false,
          ));
        }
        accounts.sort((a, b) {
          String aDate = a.name;
          String bDate = b.name;
          return aDate.compareTo(bDate);
        });
      });

      // if (data['res'] == 'success') {
      //
      //
      // }
      return accounts;
    }
    return null;
  }

  Future<Object> fetchPendingAccountList(String role,
      {String search = "",
      String statusFilter = 'All',
      String datesFilter = 'Latest First'}) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    //capsaPrint('Pass 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = role;
      // _body['panNumber'] = userData['panNumber'];

      //capsaPrint('Pending account\n\n');

      dynamic _uri;
      _uri = apiUrl + '/admin/newUsersList';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      //capsaPrint('Pass 2');
      //capsaPrint('Pending account Response ${response.body}');
      var data = jsonDecode(response.body);

      List<PendingAccountData> accounts = [];

      int i = 0;

      data['data']?.forEach((element) {
        if (i < 10) {
          if (i == 0) {
            capsaPrint(element);
          }
          capsaPrint(
              '${element['user_id']} ${element['modified_at']} ${element['file_extensions_CACFORM7']}');
          capsaPrint('\n');
          i++;
        }
        if (search == "" ||
            element['PAN_NO']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            element['NAME']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase())) {
          bool allow = false;
          if (statusFilter == 'Pending') {
            if (element['isApproved'].toString() == '0' ||
                !notNull(element['isApproved'].toString())) {
              allow = true;
            }
          } else if (statusFilter == 'Approved') {
            if (element['isApproved'].toString() == '1') {
              allow = true;
            }
          } else {
            allow = true;
          }
          if (allow) {
            accounts.add(PendingAccountData(
              panNumber: notNull(element['PAN_NO'].toString())
                  ? element['PAN_NO'].toString()
                  : '',
              role: notNull(element['ROLE']) ? element['ROLE'].toString() : '',
              role2:
                  notNull(element['ROLE2']) ? element['ROLE2'].toString() : '',
              name: notNull(element['NAME']) ? element['NAME'].toString() : '',
              userId: notNull(element['user_id'].toString())
                  ? element['user_id'].toString()
                  : '',
              isApproved: notNull(element['isApproved'].toString())
                  ? element['isApproved'].toString()
                  : '0',
              cacCertificate: notNull(element['CAC_Certificate_URL'].toString())
                  ? element['CAC_Certificate_URL'].toString()
                  : '',
              cacForm: notNull(element['CAC_Form_7'].toString())
                  ? element['CAC_Form_7'].toString()
                  : '',
              validId: notNull(element['valid_id_URL'].toString())
                  ? element['valid_id_URL'].toString()
                  : '',
              contact: notNull(element['CONTACT'].toString())
                  ? element['CONTACT'].toString()
                  : '',
              validIdExt: notNull(element['file_extensions_id'].toString())
                  ? element['file_extensions_id'].toString()
                  : '',
              cacCertificateExt:
                  notNull(element['file_extensions_CACfile'].toString())
                      ? element['file_extensions_CACfile'].toString()
                      : '',
              cacFormExt:
                  notNull(element['file_extensions_CACFORM7'].toString())
                      ? element['file_extensions_CACFORM7'].toString()
                      : '',
              email: notNull(element['EMAIL'].toString())
                  ? element['EMAIL'].toString()
                  : '',
              createdDate: notNull(element['modified_at'].toString())
                  ? DateFormat('yMMMd')
                      .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .parse(element['modified_at'].toString()))
                      .toString()
                  : '',
              // isBlackListed: element['isBlacklisted'] != null
              //     ? element['isBlacklisted'] == '1'
              //     ? true
              //     : false
              //     : false,
              // isRestricted: element['isAllowed'] != null
              //     ? element['isAllowed'] == 'p'
              //     ? true
              //     : false
              //     : false,
            ));
          }
        }
        // accounts.sort((a, b) {
        //   String aDate = a.name;
        //   String bDate = b.name;
        //   return aDate.compareTo(bDate);
        // });
      });

      // if (data['res'] == 'success') {
      //
      //
      // }
      if (datesFilter == 'Oldest First') {
        List<PendingAccountData> reversedList = List.from(accounts.reversed);
        accounts = reversedList;
      }
      return accounts;
    }
    return null;
  }

  Future<Object> getInvoicesByInvoiceNumber({String search = ''}) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['invoice_number'] = search.toString();
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/getInvoiceByInvNum';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      //capsaPrint('Invoices Response \n$_body \n$_uri \n${response.body}');
      var data = jsonDecode(response.body);
      List<InvoiceModel> invoices = [];
      int i = 0;
      if (data['msg'] == "success") {
        data['data']?.forEach((element) {
          // capsaPrint(element);
          // capsaPrint('\n\n');
          if (i < 2) {
            capsaPrint(element);
            capsaPrint('\n\n');
            i++;
          }
          //if(search == '' || search.toString().toLowerCase() == element['invoice_number'].toString().toLowerCase())
          invoices.add(InvoiceModel(
            id: element['id'] != null ? element['id'].toString() : "",
            companyPan: element['company_pan'] != null
                ? element['company_pan'].toString()
                : "",
            invoiceNumber: element['invoice_number'] != null
                ? element['invoice_number'].toString()
                : "",
            invoiceDate: element['invoice_date'] != null
                ? element['invoice_date'].toString()
                : "",
            invoiceDueDate: element['invoice_due_date'] != null
                ? element['invoice_due_date'].toString()
                : "",
            description: element['description'] != null
                ? element['description'].toString()
                : "",
            invoiceQuantity: element['invoice_quantity'] != null
                ? element['invoice_quantity'].toString()
                : "",
            invoiceValue: element['invoice_value'] != null
                ? element['invoice_value'].toString()
                : "",
            customerName: element['company_name'] != null
                ? element['company_name'].toString()
                : "",
            paymentTerms: element['payment_terms'] != null
                ? element['payment_terms'].toString()
                : "",
            status:
                element['status'] != null ? element['status'].toString() : "",
            invoiceFile: element['invoice_file'] != null
                ? element['invoice_file'].toString()
                : "",
            askAmt:
                element['ask_amt'] != null ? element['ask_amt'].toString() : "",
            askRate: element['ask_rate'] != null
                ? element['ask_rate'].toString()
                : "",
            isSplit:
                element['isSplit'] != null ? element['isSplit'].toString() : "",
            parentInvoice: element['parent_invoice'] != null
                ? element['parent_invoice'].toString()
                : "",
            cu_gst: element['customer_gst'] != null
                ? element['customer_gst'].toString()
                : "",
          ));
          invoices.sort((a, b) {
            String aDate = a.customerName;
            String bDate = b.customerName;
            return aDate.compareTo(bDate);
          });
        });
      }

      return invoices;
    }
    return null;
  }

  Future<Object> fetchAccountLetter(String panNumber) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = panNumber;
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/showAccountLetters';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      capsaPrint('Account letter Response ${response.body}');
      var data = jsonDecode(response.body);

      List<AccountLetterModel> model = [];

      if (data['msg'] == 'success') {
        for (int i = 0; i < data['data'].length; i++) {
          dynamic element = data['data'][i];

          model.add(AccountLetterModel(
              anchorName: element['company_name'],
              accountLetterUrl: element['account_letter_url'],
              companyPan: element['companyPan'],
              customerPan: element['customerPan'],
              fileExtension: element['account_letter_ext'],
              approved: element['approved'].toString() == '1' ? true : false,
              uploaded: element['uploaded'].toString() == '1' ? true : false,
              isApproved: element['approved'].toString()));
        }
      }

      return model;
    }
    return null;
  }

  Future<Object> actionAccountLetter(
      AccountLetterModel model, String action) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['vendorPan'] = model.companyPan;
      _body['anchorPan'] = model.customerPan;
      _body['action'] = action;
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/accountLetterActions';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      capsaPrint('Action Response ${response.body}');
      var data = jsonDecode(response.body);

      return data;
    }
    return null;
  }

  Future<Object> blockAccount(String panNumber) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = panNumber;
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/blackListUser';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      capsaPrint('Response ${response.body}');
      var data = jsonDecode(response.body);

      return data;
    }
    return null;
  }

  Future<Object> unblockAccount(String panNumber) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = panNumber;
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/removeUserFromblacklist';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      capsaPrint('Response ${response.body}');
      var data = jsonDecode(response.body);

      return data;
    }
    return null;
  }

  Future<Object> restrictAccount(String panNumber) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = panNumber;
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/restrictUser';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      capsaPrint('Response ${response.body}');
      var data = jsonDecode(response.body);

      return data;
    }
    return null;
  }

  Future<Object> unrestrictAccount(String panNumber) async {
    // capsaPrint(amount);
    // capsaPrint(desc);
    // capsaPrint(accountNo);
    capsaPrint('calling unrestrict');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = panNumber;
      // _body['panNumber'] = userData['panNumber'];

      dynamic _uri;
      _uri = apiUrl + '/admin/removeUserFromRestricted';
      _uri = Uri.parse(_uri);

      // capsaPrint('_body');
      // capsaPrint(_body);

      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      capsaPrint('Response unrestrict $_uri ${response.body}');
      var data = jsonDecode(response.body);

      return data;
    }
    return null;
  }

  Future<Object> getUserEmailPreference({panNumber = null, role = null}) async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      var _role = userData['role'];
      _body['panNumber'] = panNumber ?? userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['role'] = role ?? userData['role'];
      if (_body['role'] == 'COMPANY') {
        _body['role'] = 'VENDOR';
      } else if (_body['role'] == 'BUYER') {
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

  Future<Object> setUserEmailPreference(dynamic _body,
      {panNumber = null, role = null}) async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _role = userData['role'];
      capsaPrint('PanNumber : ${userData['panNumber']} ');
      _body['panNumber'] = panNumber ?? userData['panNumber'];
      // _body['panNumber'] = userData['panNumber'];
      _body['role'] = role ?? userData['role'];
      dynamic _uri;
      capsaPrint('SEt Preferences Email $_body');
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

  Future<Object> setPendingAccountKycStatus(dynamic _body,
      {panNumber = null, role = null}) async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      // _body['panNumber'] = userData['panNumber'];
      dynamic _uri;
      capsaPrint('SEt KYC status $_body');
      // if (_role == 'INVESTOR')
      //   _uri = apiUrl + 'dashboard/i/profile';
      // else
      _uri = apiUrl + '/admin/approveDocs';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      capsaPrint('Set KYC status response : $data');

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

  Future<Object> checkDocumentStatus(dynamic _body,
      {panNumber = null, role = null}) async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      // _body['panNumber'] = userData['panNumber'];
      dynamic _uri;
      capsaPrint('SEt KYC status $_body');
      // if (_role == 'INVESTOR')
      //   _uri = apiUrl + 'dashboard/i/profile';
      // else
      _uri = apiUrl + '/admin/getKycStatus';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      capsaPrint('fetch Kyc Status response : $data');

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

  Future<Object> createAccount(PendingAccountData data,
      {panNumber = null, role = null}) async {
    var _body = {};

    _body['panNumber'] = data.panNumber;
    _body['role'] = data.role == 'COMPANY' ? 'VENDOR' : data.role;
    _body['contact'] = data.contact;
    _body['name'] = data.name;
    _body['email'] = data.email;

    // capsaPrint(_body);

    dynamic _uri;

    if (data.role == 'COMPANY' || data.role == 'VENDOR') {
      _uri = 'admin/racccreate';
    } else {
      _uri = 'admin/lacccreate';
    }

    //_uri = Uri.parse(_uri);
    capsaPrint('Pass 2 $_uri $_body');
    try {
      // var response = await http.post(_uri, body: _body);
      // capsaPrint(response);
      capsaPrint('Pass 3');
      var data = await callApi(_uri, body: _body);
      capsaPrint('Pass 4');
      capsaPrint('Response : $data');
      // return null;
      await Future.delayed(Duration(seconds: 1));
      //notifyListeners();
      return data;
    } catch (e) {
      capsaPrint(e);
      await Future.delayed(Duration(seconds: 1));
      notifyListeners();
      return null;
    }
    return null;
  }

  Future<Object> fetchAdminAccountPermissions() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      capsaPrint('api initiated pass 1');
      dynamic _body = {};
      var userData = Map<String, dynamic>.from(box.get('userData'));
      capsaPrint('api initiated pass 2');
      _body['panNumber'] = userData['panNumber'];
      capsaPrint('api initiated pass 3');
      dynamic _uri;
      capsaPrint('admin Account Permissions $_body');
      // if (_role == 'INVESTOR')
      //   _uri = apiUrl + 'dashboard/i/profile';
      // else
      _uri = apiUrl + '/admin/fetchadminroles';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      capsaPrint('fetch Account permissions response : \n$data');

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

  Future getCompanyName() async {
    dynamic _uri = apiUrl + 'dashboard/r/' + 'getCompanyName';
    _uri = Uri.parse(_uri);
    capsaPrint('company name pass 1');
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    _body['panNumber'] = userData['panNumber'];
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
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

  Future getTransactionTracker({String fromDate, String toDate}) async {
    dynamic _uri = 'admin/transactionsTracker';
    //_uri = Uri.parse(_uri);
    capsaPrint('transactionsTracker pass 1');
    var _body = {"from": fromDate, "to": toDate};
    //var userData = Map<String, dynamic>.from(box.get('tmpUserData'));

    capsaPrint('transactionsTracker pass 1.1 $_body');

    var response = await callApi(_uri, body: _body);
    capsaPrint('company name pass 2');
    //capsaPrint(response.body);
    //var data = jsonDecode(response.body);

    // if (data['res'] == 'success') {
    //   for (int i = 0; i < data['data'].length; i++) {
    //     _anchorsNameList.add(data['data'][i]['name']);
    //     _cinList[data['data'][i]['name']] = data['data'][i]['cu_pan'];
    //   }
    // }

    return response;
  }

  Future getRevenueTracker({String fromDate, String toDate}) async {
    dynamic _uri = 'admin/revenueTracker';
    //_uri = Uri.parse(_uri);
    capsaPrint('transactionsTracker pass 1');
    var _body = {"from": fromDate, "to": toDate};
    //var userData = Map<String, dynamic>.from(box.get('tmpUserData'));

    capsaPrint('transactionsTracker pass 1.1 $_body');

    var response = await callApi(_uri, body: _body);
    capsaPrint('company name pass 2');
    //capsaPrint(response.body);
    //var data = jsonDecode(response.body);

    // if (data['res'] == 'success') {
    //   for (int i = 0; i < data['data'].length; i++) {
    //     _anchorsNameList.add(data['data'][i]['name']);
    //     _cinList[data['data'][i]['name']] = data['data'][i]['cu_pan'];
    //   }
    // }

    return response;
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
