// import 'dart:js';

import 'package:capsa/anchor/Mobile_Profile/New_Admin.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/show_toast.dart';

import 'package:capsa/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

import 'package:universal_html/html.dart' as html;

class AnchorActionProvider extends ChangeNotifier {
  final box = Hive.box('capsaBox');

  String _url = apiUrl;

  bool _loading = false;

  bool get loading => _loading;

  void callRefresh() {
    _loading = !_loading;

    Future.delayed(const Duration(milliseconds: 500), () {
      _loading = !_loading;
      notifyListeners();
    });
  }

  Future<Object> getInvFile(_body) async {
    return await callApi('dashboard/a/getInvFile', body: _body);
  }

  Future<Object> setData(data, int status) async {
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    List<AcctTableData> _acctTableData = <AcctTableData>[];
    var _data = data;
    int i = 0;
    if (_data['res'] == 'success') {
      var _results = _data['data']['invoicelist'];
      String approvedBy = _data['data']['_action_by'];
      // capsaPrint(_results);

      _results.forEach((element) {
        DateTime invoiceDate =
            new DateFormat("yyyy-MM-dd").parse(element['invoice_date']);

        DateTime invoiceDueDate =
            new DateFormat("yyyy-MM-dd").parse(element['invoice_due_date']);

        DateTime sortingFactor = status == 2
            ? DateFormat("yyyy-MM-dd").parse(element['updated_at'])
            : element['actioned_at'] == null
                ? DateFormat("yyyy-MM-dd").parse(element['updated_at'])
                : DateFormat("yyyy-MM-dd").parse(element['actioned_at']);

        // capsaPrint(element['invoice_file']);

        var d1 = DateFormat.yMMMd('en_US').format(invoiceDate);
        var d2 = DateFormat.yMMMd('en_US').format(invoiceDueDate);
        var tenure = daysBetween(invoiceDate, invoiceDueDate).toString();

        if (i == 0) capsaPrint('ELEMENT: ${element} \n');

        i++;

        _acctTableData.add(AcctTableData(
          element['invoice_number'].toString(),
          element['NAME'],
          element['invoice_value'].toString(),
          d1,
          invoiceDate,
          d2,
          invoiceDueDate,
          sortingFactor,
          element['ask_amt'].toString(),
          element['payment_terms'],
          element['ask_rate'].toString(),
          element['status'].toString(),
          element['company_pan'].toString(),
          element['invoice_file'],
          tenure,
          element['actioned_by'] == null ? approvedBy : element['actioned_by'],
        ));
      });
    }
    return _acctTableData;
  }

  Future<Object> downloadFile(String url) async {
    dynamic _uri = Uri.parse(url);

    var response = await http.get(_uri);

    // capsaPrint(data);

    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = 'Invoice.pdf';
      anchorElement.click();
      html.Url.revokeObjectUrl(url);
    }
    return null;
  }

  Future<Object> removeFromList(AcctTableData invoice,) async {
    return null;
  }

  List<AcctTableData> searchData(List<AcctTableData> table,String search,BuildContext context){
    List<AcctTableData> result = [];
    if(search == "")
      return table;
    table.forEach((element) {
      int a = element.invNo.toLowerCase().compareTo(search.toLowerCase());
      int b = element.vendor.toLowerCase().compareTo(search.toLowerCase());
      if(a == 0 || b == 0){
        result.add(element);
      }
    });
    if(result.isEmpty) {
      showToast('No Data Found', context,type: "warning");
      return table;
    }
    return result;
  }

  Future<Object> queryInvoiceList(int status) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      //capsaPrint('calling status $status \nUser Data:  $userData');

      var _body = {};

      //capsaPrint('SuperAdminId : ${userData}');
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['status'] = status.toString();
      // _body['type'] = 'notPresented';
      // _body['search'] = "654321";


      var data = await callApi('dashboard/a/invoicelist', body: _body);
      //var data = await callApi3('requestor/invoicelist', body: _body);
      //capsaPrint("Data $status ${data}");

      List<AcctTableData> _acctTableData = await setData(data, status);

      _acctTableData.sort((a, b) {
        int aDate = a.sortingFactor.microsecondsSinceEpoch;
        int bDate = b.sortingFactor.microsecondsSinceEpoch;
        return bDate.compareTo(aDate);
      });

      List<AcctTableData> finalAcctTableData;

      return _acctTableData;
    }

    return null;
  }

  void addAdmin(var _body) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      _body['panNumber'] = userData['panNumber'];

      // _body['panNumber'] = userData['panNumber'];
      // _body['role'] = userData['role'];
      // _body['status'] = status.toString();

      var data = await callApi3('/admin/add/subAdmin', body: _body);
      capsaPrint("Data add admin $data");
      //List<AcctTableData> _acctTableData = await setData(data);
      //return _acctTableData;
    }

    return null;
  }

  Future<Object> getAllAdmins() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      List<subAdmin> admins = [];
      _body['panNumber'] = userData['panNumber'];

      // _body['panNumber'] = userData['panNumber'];
      // _body['role'] = userData['role'];
      // _body['status'] = status.toString();

      var data =
          await callApi('/admin/getAdminsCreatedByASuperAdmin', body: _body);
      if (data == 'Your are not an admin') {
        return null;
      }
      capsaPrint("Data admin list $data");

      for (int i = 0; i < data.length; i++) {
        admins.add(subAdmin(
            data[i]['sub_anchor_admin'],
            data[i]['email'],
            data[i]['firstName'],
            data[i]['lastName'],
            data[i]['roleBuyInvoice'],
            data[i]['roleAandRInvoice'],
            data[i]['roleEditInvoice'],
            data[i]['roleVentInvoice'],
            data[i]['roleMarkInvoiceAsPaid']));
      }

      return admins;
      //List<AcctTableData> _acctTableData = await setData(data);
      //return _acctTableData;
    }

    return null;
  }

  void removeAdmin(String anchorAdminId) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      // _body['panNumber'] = userData['panNumber'];
      // _body['role'] = userData['role'];
      // _body['status'] = status.toString();
      var _body = {};
      _body['sub_anchor_admin'] = anchorAdminId;
      _body['deletedByID'] = userData['panNumber'].toString();
      var data = await callApi3('/admin/deleteAdmin', body: _body);
      //capsaPrint("Data delete admin ${_body['deletedbyID']} $anchorAdminId $data");
      //List<AcctTableData> _acctTableData = await setData(data);
      //return _acctTableData;
    }
  }

  void getAdminDetails() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['sub_anchor_admin'] = 'l3o72oq646y3zl2wq78';

      // _body['panNumber'] = userData['panNumber'];
      // _body['role'] = userData['role'];
      // _body['status'] = status.toString();

      var data = await callApi3('/admin/getAdminDetails', body: _body);
      //capsaPrint("Data specific admin list $data");
      //List<AcctTableData> _acctTableData = await setData(data);
      //return _acctTableData;
    }

    return null;
  }

  void updateAdmin(_body, adminID) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      _body['panNumber'] = userData['panNumber'];
      _body['roleBuyInvoice'] = userData['sub_admin_details']['roleBuyInvoice'];
      _body['roleAandRInvoice'] = userData['sub_admin_details']['roleAandRInvoice'];
      _body['roleEditInvoice'] = userData['sub_admin_details']['roleEditInvoice'];
      _body['roleVentInvoice'] = userData['sub_admin_details']['roleVentInvoice'];
      _body['roleMarkInvoiceAsPaid'] = userData['sub_admin_details']['roleMarkInvoiceAsPaid'];



      // _body['panNumber'] = userData['panNumber'];
      // _body['role'] = userData['role'];
      // _body['status'] = status.toString();

      var data = await callApi3('/admin/updateAdmin/$adminID', body: _body);
      //capsaPrint("Data update admin $data");
      //List<AcctTableData> _acctTableData = await setData(data);
      //return _acctTableData;
    }

    return null;
  }

  void updateSuperAdmin(
    _body,
  ) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      _body['panNumber'] = userData['panNumber'];

      // _body['panNumber'] = userData['panNumber'];
      // _body['role'] = userData['role'];
      // _body['status'] = status.toString();

      var data = await callApi3('/anchor/updateSuperAdmin', body: _body);
      //capsaPrint("Data update admin $data");
      //List<AcctTableData> _acctTableData = await setData(data);
      //return _acctTableData;
    }

    return null;
  }

  void updateSubAdminPassword(_body, userId) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      // _body['panNumber'] = userData['panNumber'];
      // _body['role'] = userData['role'];
      // _body['status'] = status.toString();

      var data = await callApi3('/admin/changePassword/$userId', body: _body);
      //capsaPrint("Data update admin $data");
      //List<AcctTableData> _acctTableData = await setData(data);
      //return _acctTableData;
    }
  }

  Future<Object> approve(date, dateText, amt, AcctTableData invoice) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      capsaPrint('userData');
      capsaPrint('$userData');
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

  Future<Object> updateInvoice(String invNo, String date, String invAmt) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'].toString();
      _body['inv_num'] = invNo;
      _body['inv_due_date'] = date;
      _body['inv_val'] = invAmt;

      // _body['panNumber'] = userData['panNumber'];
      // _body['role'] = userData['role'];
      // _body['status'] = status.toString();

      var data = await callApi3('/dashboard/a/updateInvoice', body: _body);
      //capsaPrint("Data update admin $data");
      //List<AcctTableData> _acctTableData = await setData(data);
      //return _acctTableData;
      capsaPrint('Update invoice Data $_body $data');
    }

    return null;
  }

  void getAllPayments() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['pageNumber'] = "1";
      //_body['pageNumber'] = "1";
      var data = await callApi('/payment/paid', body: _body);
      return data;
    }
  }

  Future<Object> get7DaysUpcomingPayments() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['pageNumber'] = "1";
      var data = await callApi('/payment/upcoming/0to7', body: _body);
      //var d = await callApi('/payment/upcoming/today', body: _body);
      //capsaPrint("Payments 7 days ${data}");
      List<paymentsInfo> _payments = [];
      for (int i = 0; i < data['payments'].length; i++) {
        _payments.add(paymentsInfo(
            data['payments'][i]['invoice_number'].toString(),
            data['payments'][i]['company_name'].toString(),
            DateFormat("d MMMM")
                .format(DateTime.parse(
                  data['payments'][i]['effective_due_date'],
                ))
                .toString(),
            data['payments'][i]['status'].toString(),
            data['payments'][i]['invoice_value'].toString()));
      }
      paymentsData _data =
          paymentsData(data['percentage'].toString(), _payments);

      return _data;
    }
  }

  Future<Object> paymentsDueToday() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['pageNumber'] = "1";
      var data = await callApi('/payment/upcoming/today', body: _body);
      capsaPrint('Due Today Data: $data ${data['payments'].length}');
      if (data != null) {
        var d = await callApi('/payment/upcoming/today', body: _body);
        //capsaPrint("Payments Data ${d[0]}");
        List<paymentsInfo> _payments = [];
        for (int i = 0; i < data['payments'].length; i++) {
          _payments.add(paymentsInfo(
              data['payments'][i]['invoice_number'].toString(),
              data['payments'][i]['company_name'].toString(),
              DateFormat("d MMMM")
                  .format(DateTime.parse(
                    data['payments'][i]['effective_due_date'],
                  ))
                  .toString(),
              data['payments'][i]['status'].toString(),
              data['payments'][i]['invoice_value'].toString()));
        }
        paymentsData _data =
            paymentsData(data['percentage'].toString(), _payments);

        return _data;
      }
      return null;
    }
  }

  Future<Object> getNextMonthUpcomingPayments() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['pageNumber'] = "1";
      var data = await callApi('/payment/upcoming/8to30', body: _body);
      capsaPrint('UPCOMING 30 $data');
      List<paymentsInfo> _payments = [];
      for (int i = 0; i < data['payments'].length; i++) {
        _payments.add(paymentsInfo(
            data['payments'][i]['invoice_number'].toString(),
            data['payments'][i]['company_name'].toString(),
            DateFormat("d MMMM")
                .format(DateTime.parse(
                  data['payments'][i]['effective_due_date'],
                ))
                .toString(),
            data['payments'][i]['status'].toString(),
            data['payments'][i]['invoice_value'].toString()));
      }
      paymentsData _data =
          paymentsData(data['percentage'].toString(), _payments);
      //capsaPrint("Payments Data ${_data.percentage}");
      return _data;
    }
  }

  Future<Object> paymentsDueIn45days() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['pageNumber'] = "1";
      var data = await callApi('/payment/upcoming/31to45', body: _body);
      capsaPrint('UPCOMING 45 $data');
      List<paymentsInfo> _payments = [];
      for (int i = 0; i < data['payments'].length; i++) {
        _payments.add(paymentsInfo(
            data['payments'][i]['invoice_number'].toString(),
            data['payments'][i]['company_name'].toString(),
            DateFormat("d MMMM")
                .format(DateTime.parse(
                  data['payments'][i]['effective_due_date'],
                ))
                .toString(),
            data['payments'][i]['status'].toString(),
            data['payments'][i]['invoice_value'].toString()));
      }
      paymentsData _data =
          paymentsData(data['percentage'].toString(), _payments);
      //capsaPrint("Payments Data ${_data.percentage}");
      return _data;
    }
  }

  Future<Object> paymentsDueIn60days() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['pageNumber'] = "1";
      var data = await callApi('/payment/upcoming/gt45', body: _body);
      capsaPrint('UPCOMING 60 ${data['payments']}');
      List<paymentsInfo> _payments = [];
      for (int i = 0; i < data['payments'].length; i++) {
        _payments.add(paymentsInfo(
            data['payments'][i]['invoice_number'].toString(),
            data['payments'][i]['company_name'].toString(),
            DateFormat("d MMMM")
                .format(DateTime.parse(
                  data['payments'][i]['effective_due_date'],
                ))
                .toString(),
            data['payments'][i]['status'].toString(),
            data['payments'][i]['invoice_value'].toString()));
      }
      paymentsData _data =
          paymentsData(data['percentage'].toString(), _payments);
      //capsaPrint("Payments Data ${_data.percentage}");
      return _data;
    }
  }

  Future<Object> unpaidAfterDueDate() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['pageNumber'] = "1";
      //_body['pageNumber'] = "1";
      var data = await callApi('/payment/unpaidAfterDueDate', body: _body);
      // capsaPrint("Unpaid Payments Data ${data}");
      List<paymentsInfo> _payments = [];

      for (int i = 0; i < data.length; i++) {
        _payments.add(paymentsInfo(
            data[i]['invoice_number'].toString(),
            data[i]['company_name'].toString(),
            DateFormat("d MMMM")
                .format(DateTime.parse(
                  data[i]['effective_due_date'],
                ))
                .toString(),
            data[i]['status'].toString(),
            data[i]['invoice_value'].toString()));
      }

      return _payments;
    }
  }

  Future<Object> paidPayments() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['pageNumber'] = "1";
      var data = await callApi('/payment/paid', body: _body);
      //capsaPrint('UPCOMING 30 ${data[0]}');
      List<paymentsInfo> _payments = [];
      for (int i = 0; i < data.length; i++) {
        _payments.add(paymentsInfo(
            data[i]['invoice_number'].toString(),
            data[i]['company_name'].toString(),
            DateFormat("d MMMM y")
                .format(DateTime.parse(
                  data[i]['effective_due_date'],
                ))
                .toString(),
            data[i]['status'].toString(),
            data[i]['invoice_value'].toString()));
      }
      return _payments;
    }
  }

  Future<Object> reject(AcctTableData invoice) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['ino'] = invoice.invNo;
      _body['comppan'] = invoice.companyPan;
      return await callApi('dashboard/a/reject', body: _body);
    }

    return null;
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

class AcctTableData {
  String invNo;
  String vendor;
  String invAmt;
  String invDate;
  DateTime invDateO;
  String invDueDate;
  DateTime invDueDateO;
  DateTime effDueDate;
  DateTime sortingFactor;
  String buyNowAmt;
  String payTerms;
  String bidRate;
  String status;
  String tenure;
  String companyPan;
  dynamic fileName;
  String approvedBy;

  AcctTableData(
      this.invNo,
      this.vendor,
      this.invAmt,
      this.invDate,
      this.invDateO,
      this.invDueDate,
      this.invDueDateO,
      this.sortingFactor,
      this.buyNowAmt,
      this.payTerms,
      this.bidRate,
      this.status,
      this.companyPan,
      this.fileName,
      this.tenure,
      this.approvedBy);
}

class paymentsData {
  String percentage;
  List<paymentsInfo> payments;
  paymentsData(this.percentage, this.payments);
}

class paymentsInfo {
  String invNo;
  String customerName;
  String effectiveDueData;
  String status;
  String amt;
  paymentsInfo(this.invNo, this.customerName, this.effectiveDueData,
      this.status, this.amt);
}

class subAdmin {
  String adminId;
  String email;
  String firstName;
  String lastName;
  int roleBuyInvoice;
  int roleAandRInvoice;
  int editInvoice;
  int roleVentInvoice;
  int roleMarkInvoiceAsPaid;
  subAdmin(
      this.adminId,
      this.email,
      this.firstName,
      this.lastName,
      this.roleBuyInvoice,
      this.roleAandRInvoice,
      this.editInvoice,
      this.roleVentInvoice,
      this.roleMarkInvoiceAsPaid);
}
