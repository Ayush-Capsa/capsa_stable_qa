// import 'dart:js';

import 'dart:convert';

import 'package:capsa/anchor/Data/vendor_data.dart';
import 'package:capsa/anchor/Mobile_Profile/New_Admin.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/show_toast.dart';

import 'package:capsa/providers/auth_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:intl/intl.dart';

import 'package:universal_html/html.dart' as html;

class AnchorActionProvider extends ChangeNotifier {
  //String _url = apiUrl + 'dashboard/r/';
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

  Future<Object> setUploadInvoiceData(data, String type) async {
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    List<UploadedInvoiceData> _acctTableData = <UploadedInvoiceData>[];

    var _data = data;
    int i = 0;
    var _results;
    if (_data['res'] == 'success') {
      if (type == 'pending') {
        _results = _data['data'];
      } else if (type == 'closed') {
        _results = _data['closed'];
      } else {
        _results = _data['data'];
      }
      //String approvedBy = _data['data']['_action_by'];
      capsaPrint('$type ${_results.length}');

      _results.forEach((element) {
        //capsaPrint('\npass 1 $element');
        DateTime invoiceDate;
        DateTime invoiceDueDate;
        try {
          invoiceDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .parse(element['invoice_date']);
        } catch (e) {
          invoiceDate = DateFormat("yyyy-MM-dd").parse('2001-01-01');
        }

        try {
          invoiceDueDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .parse(element['invoice_due_date']);
        } catch (e) {
          invoiceDueDate = DateFormat("yyyy-MM-dd").parse('2001-01-01');
        }

        //capsaPrint('\npass 3');

        // DateTime sortingFactor = status == 2
        //     ? DateFormat("yyyy-MM-dd").parse(element['updated_at'])
        //     : element['actioned_at'] == null
        //     ? DateFormat("yyyy-MM-dd").parse(element['updated_at'])
        //     : DateFormat("yyyy-MM-dd").parse(element['actioned_at']);

        // capsaPrint(element['invoice_file']);

        var d1 = DateFormat.yMMMd('en_US').format(invoiceDate);
        var d2 = DateFormat.yMMMd('en_US').format(invoiceDueDate);
        var tenure = daysBetween(invoiceDate, invoiceDueDate).toString();

        if (i == 0) capsaPrint('ELEMENT: ${element} \n\n');

        //capsaPrint('\npass 4');

        //capsaPrint('upload data pass 5 $type ${element['status']}');

        i++;

        //capsaPrint('adding pending');
        capsaPrint(element['ask_rate']);

        bool pending = (type == 'pending' && element['status'].toString() == '1');
        bool approved = (type == 'approved' && element['status'].toString() != '1');

        if(type == 'closed' || pending || approved) {
          //capsaPrint(element);
          _acctTableData.add(UploadedInvoiceData(
            element['invoice_number'].toString(),
            element['customer_name'].toString(),
            DateFormat('d MMM, y').format(invoiceDate),
            element['payment_terms'].toString(),
            DateFormat('d MMM, y').format(invoiceDueDate),
            element['invoice_value'].toString(),
            element['company_pan'].toString(),
            element['invoice_line_items'] ?? '',
            element['ask_amt'].toString(),
            element['ask_rate'].toString(),
            element['actual_value'].toString(),
            element['invoice_line_items'].toString()
          ));
        }
        //capsaPrint('\npass 5');
      });
    }
    capsaPrint('accnt table length ${_acctTableData.length}');
    return _acctTableData;
  }

  Future<Object> setVendorListData(data, String type) async {
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    List<VendorData> _acctTableData = <VendorData>[];

    var _data = data;
    int i = 0;
    var _results;
    if (_data['msg'] == 'success') {
      _results = _data['data'];
      //String approvedBy = _data['data']['_action_by'];
      capsaPrint('$type ${_results.length}');

      _results.forEach((element) {
        //capsaPrint('\npass 1 $element');

        if (i == 0) capsaPrint('ELEMENT: ${element} \n');

       // capsaPrint('\npass 4');

        //capsaPrint('upload data pass 5 $type ${element['status']}');

        i++;

        //capsaPrint('adding pending');
        _acctTableData.add(VendorData(
          element['company_name'].toString(),
          element['director_name'].toString(),
          element['email'].toString(),
          '',
          element['status'].toString(),
        ));
        capsaPrint('\npass 5');
      });
    }
    capsaPrint('accnt table length ${_acctTableData.length}');
    return _acctTableData;
  }

  Future<Object> downloadFile(String url) async {
    capsaPrint('Downloading file');
    dynamic _uri = Uri.parse(url);

    var response = await http.get(_uri);

    //capsaPrint(data);

    if (response.statusCode == 200) {
      capsaPrint('download pass 1');
      final blob = html.Blob([response.bodyBytes]);
      //capsaPrint('download pass 2');
      final url = html.Url.createObjectUrlFromBlob(blob);
      //capsaPrint('download pass 3 $url');
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      //capsaPrint('download pass 4');
      anchorElement.download = 'template.csv';
      anchorElement.click();
      html.Url.revokeObjectUrl(url);
    }
    return null;
  }

  Future<Object> removeFromList(
    AcctTableData invoice,
  ) async {
    return null;
  }

  List<UploadedInvoiceData> searchDataUploadedInvoice(
      List<UploadedInvoiceData> table, String search, BuildContext context) {
    List<UploadedInvoiceData> result = [];
    if (search == "") {
      return table;
    }
    table.forEach((element) {
      // int a = element.invNo.toLowerCase().compareTo(search.toLowerCase());
      // int b = element.vendor.toLowerCase().compareTo(search.toLowerCase());
      // if(a == 0 || b == 0){
      //   result.add(element);
      // }

      if (element.invNo
              .toString()
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          element.vendor
              .toString()
              .toLowerCase()
              .contains(search.toLowerCase())) {
        result.add(element);
      }
    });
    if (result.isEmpty) {
      showToast('No Data Found', context, type: "warning");
      return table;
    }
    return result;
  }

  List<VendorData> searchDataOnboardedVendor(
      List<VendorData> table, String search, BuildContext context) {
    List<VendorData> result = [];
    if (search == "") {
      return table;
    }
    table.forEach((element) {
      // int a = element.invNo.toLowerCase().compareTo(search.toLowerCase());
      // int b = element.vendor.toLowerCase().compareTo(search.toLowerCase());
      // if(a == 0 || b == 0){
      //   result.add(element);
      // }

      if (element.companyName
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase()) ||
          element.directorName
              .toString()
              .toLowerCase()
              .contains(search.toLowerCase())) {
        result.add(element);
      }
    });
    if (result.isEmpty) {
      showToast('No Data Found', context, type: "warning");
      return table;
    }
    return result;
  }

  List<AcctTableData> searchData(
      List<AcctTableData> table, String search, BuildContext context) {
    List<AcctTableData> result = [];
    if (search == "") return table;
    table.forEach((element) {
      int a = element.invNo.toLowerCase().compareTo(search.toLowerCase());
      int b = element.vendor.toLowerCase().compareTo(search.toLowerCase());
      if (a == 0 || b == 0) {
        result.add(element);
      }
    });
    if (result.isEmpty) {
      showToast('No Data Found', context, type: "warning");
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

  Future<Object> queryUploadedInvoiceList({String type = 'pending'}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      //capsaPrint('calling status $status \nUser Data:  $userData');

      var _body = {};

      //capsaPrint('SuperAdminId : ${userData}');
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      // _body['type'] = 'notPresented';
      // _body['search'] = "654321";

      var data = await callApi('dashboard/a/invoiceListRF', body: _body);
      //var data = await callApi3('requestor/invoicelist', body: _body);
      //capsaPrint("Data $status ${data}");

      //capsaPrint('\n\nUpload invoice data : ${data['closed']}');

      List<UploadedInvoiceData> _acctTableData =
          await setUploadInvoiceData(data, type);

      capsaPrint('data laoded');

      // _acctTableData.sort((a, b) {
      //   int aDate = a.sortingFactor.microsecondsSinceEpoch;
      //   int bDate = b.sortingFactor.microsecondsSinceEpoch;
      //   return bDate.compareTo(aDate);
      // });

      List<AcctTableData> finalAcctTableData;

      capsaPrint('table length ${_acctTableData.length}');

      return _acctTableData;
    }

    return null;
  }

  Future<Object> queryOnboardedVendorList({String type = 'pending'}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      //capsaPrint('calling status $status \nUser Data:  $userData');

      var _body = {};

      //capsaPrint('SuperAdminId : ${userData}');
      _body['anchor_pan'] = userData['panNumber'];
      _body['role'] = userData['role'];
      // _body['type'] = 'notPresented';
      // _body['search'] = "654321";

      var data = await callApi('dashboard/a/vendorInviteList', body: _body);
      //var data = await callApi3('requestor/invoicelist', body: _body);
      //capsaPrint("Data $status ${data}");

      capsaPrint('\n\nVendor data : ${data}');

      List<VendorData> _acctTableData = await setVendorListData(data, type);

      capsaPrint('data laoded');

      // _acctTableData.sort((a, b) {
      //   int aDate = a.sortingFactor.microsecondsSinceEpoch;
      //   int bDate = b.sortingFactor.microsecondsSinceEpoch;
      //   return bDate.compareTo(aDate);
      // });

      List<AcctTableData> finalAcctTableData;

      capsaPrint('table length ${_acctTableData.length}');

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
      _body['roleAandRInvoice'] =
          userData['sub_admin_details']['roleAandRInvoice'];
      _body['roleEditInvoice'] =
          userData['sub_admin_details']['roleEditInvoice'];
      _body['roleVentInvoice'] =
          userData['sub_admin_details']['roleVentInvoice'];
      _body['roleMarkInvoiceAsPaid'] =
          userData['sub_admin_details']['roleMarkInvoiceAsPaid'];

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

  Future<Object> approve(date, dateText, amt, AcctTableData invoice,
      String plan, String checked, String discountPer) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      capsaPrint('userData');
      capsaPrint('$userData');
      var _body = {};

      if (userData['isSubAdmin'] == '1') {
        _body['sub_admin_id'] = userData['sub_admin_details']['sub_admin_id'];
        String user = userData['firstName'].toString() +
            " " +
            userData['lastName'].toString();
        _body['userName'] = user;
      } else {
        _body['userName'] = userData['userName'];
      }

      _body['plan'] = plan;
      if (plan == 'a') {
        _body['checked'] = checked;
        _body['discount_per'] = discountPer;
      } else {
        _body['checked'] = '';
        _body['discount_per'] = '';
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

  Future<Object> updateInvoice(String invNo, String date, String invAmt,
      String plan, String checked, String discountPer) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      var _body = {};
      _body['panNumber'] = userData['panNumber'].toString();
      _body['inv_num'] = invNo;
      _body['inv_due_date'] = date;
      _body['inv_val'] = invAmt;

      _body['plan'] = plan;
      if (plan == 'a') {
        _body['checked'] = checked;
        _body['discount_per'] = discountPer;
      } else {
        _body['checked'] = '';
        _body['discount_per'] = '';
      }

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

  Future<Object> reject(AcctTableData invoice, String plan, String checked,
      String discountPer) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['ino'] = invoice.invNo;
      _body['comppan'] = invoice.companyPan;

      _body['plan'] = plan;
      if (plan == 'a') {
        _body['checked'] = checked;
        _body['discount_per'] = discountPer;
      } else {
        _body['checked'] = '';
        _body['discount_per'] = '';
      }

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
    //capsaPrint('Pass 2 check password reset');
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

  Future updateEarlyPaymentSettings(
      List<dynamic> selectedList,
      List<dynamic> vendors,
      Map<String, String> vendorPan,
      String discountRate) async {
    capsaPrint('Pass 1 update early payment');
    String _uri = 'dashboard/a/saveEarlyPaymentVendors';
    String vendorPanList = '';

    var _body = {};

    for (int i = 0; i < selectedList.length; i++) {
      capsaPrint('Vendor : ${vendors[i]} ${vendorPan[vendors[i]]}');
      if (i == 0) {
        vendorPanList += vendorPan[vendors[selectedList[i]]];
      } else {
        vendorPanList += ',' + vendorPan[vendors[selectedList[i]]];
      }
    }

    _body['vendors'] = vendorPanList;
    _body['discount_rate'] = discountRate;

    var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
    _body['anchorPAN'] = userData['panNumber'];
    //capsaPrint('Pass 2 update early payment');
    var response = await callApi(_uri, body: _body);

    return response;
  }

  Future getCompanyName() async {
    capsaPrint('\n\n\nget company name init');
    dynamic _uri = 'dashboard/r/getCompanyName';
    //_uri = Uri.parse(_uri);
    var _body = {};
    var userData = Map<String, dynamic>.from(box.get('userData'));
    _body['panNumber'] = userData['panNumber'];
    capsaPrint('\n\n\nget company name init 2 $_uri');
    capsaPrint('calling api 1');
    //List<dynamic> data;
    //capsaPrint('calling api 1.1');
    dynamic temp = await callApi(_uri, body: _body);
    capsaPrint('calling api 1.2 $temp');

    _uri = 'dashboard/a/vendorList';
    _body['anchorPAN'] = userData['panNumber'];
    capsaPrint('\n\n\nget company name init 2 $_uri');
    capsaPrint('calling api 2.1');
    dynamic temp2 = await callApi(_uri, body: _body);
    capsaPrint('calling api 2.2 $temp2');

    dynamic data = [temp, temp2];

    capsaPrint('calling api 2.3');

    //capsaPrint('company name : ${data['company_rate']} ');

    //capsaPrint(data);
    return data;
  }

  Future uploadInvoice(
    invoice,
  ) async {
    // capsaPrint(DateTime.now().millisecondsSinceEpoch.toString());

    var _body = invoice.toJson();
    _body['web'] = kIsWeb.toString();
    //_body['currency'] = currency;

    dynamic _uri = 'dashboard/a/invoiceUploadAnchor';
    //_uri = Uri.parse(_uri);

    // var request = http.MultipartRequest('POST', _uri);
    // request.fields['web'] = kIsWeb.toString();
    //
    // request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');
    //
    // capsaPrint('Upload Invoice body - $_body $_uri');
    //
    // _body.forEach((key, value) {
    //   request.fields[key] = value;
    // });

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');

    // request.files.add(http.MultipartFile.fromBytes(
    //   'invoice_file',
    //   file.bytes,
    //   filename: _body['bvnNo'] + '_' + _body['invNo'] + '_' + DateTime.now().millisecondsSinceEpoch.toString() + '.' + file.extension,
    //   contentType: MediaType('application', 'octet-stream'),
    // ));

    capsaPrint('sending request $_body');
    var res = await callApi(_uri, body: _body);
    //capsaPrint('response received $res');

    // var data = jsonDecode((await http.Response.fromStream(res)).body);
    // capsaPrint(data);
    //var res = {'res' : 'failed', };
    return res;

    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future uploadInvoiceCsv(PlatformFile file) async {
    // capsaPrint(DateTime.now().millisecondsSinceEpoch.toString());

    var _body = {};
    capsaPrint('pass 1');
    _body['web'] = kIsWeb.toString();
    var userData = Map<String, dynamic>.from(box.get('userData'));
    _body['panNumber'] = userData['panNumber'];
    //_body['currency'] = currency;

    dynamic _uri = _url + 'dashboard/a/invoiceBulkUpload';
    _uri = Uri.parse(_uri);
    //capsaPrint('pass 2');

    var request = http.MultipartRequest('POST', _uri);
   // capsaPrint('pass 2.1');
    //request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');
    //capsaPrint('pass 3');

    capsaPrint('Upload Invoice body - $_body $_uri');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    //capsaPrint('pass 4');

    //var inv = _body['invNo'].toString().replaceAll(new RegExp(r'[^\w\s]+'), '_');

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file.bytes,
      filename: _body['bvnNo'].toString() +
          '_' +
          _body['invNo'].toString() +
          '_' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.' +
          file.extension,
      contentType: MediaType('application', 'octet-stream'),
    ));

    capsaPrint('pass 5');

    capsaPrint('sending request');
    var res = await request.send();
    var str = await http.Response.fromStream(res);
    var response = jsonDecode(str.body);
    capsaPrint('pass 6');
    capsaPrint('response received $response');

    // var data = jsonDecode((await http.Response.fromStream(res)).body);
    // capsaPrint(data);
    return response;

    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future uploadMultiInvoiceCsv(PlatformFile file) async {
    // capsaPrint(DateTime.now().millisecondsSinceEpoch.toString());

    var _body = {};
    capsaPrint('pass 1');
    _body['web'] = kIsWeb.toString();
    var userData = Map<String, dynamic>.from(box.get('userData'));
    _body['panNumber'] = userData['panNumber'];
    //_body['currency'] = currency;

    dynamic _uri = _url + 'dashboard/a/invoiceMultiUpload';
    _uri = Uri.parse(_uri);
    //capsaPrint('pass 2');

    var request = http.MultipartRequest('POST', _uri);
   // capsaPrint('pass 2.1');
    //request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');
    ///capsaPrint('pass 3');

    capsaPrint('Upload Invoice body - $_body $_uri');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    //capsaPrint('pass 4');

    //var inv = _body['invNo'].toString().replaceAll(new RegExp(r'[^\w\s]+'), '_');

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file.bytes,
      filename: _body['bvnNo'].toString() +
          '_' +
          _body['invNo'].toString() +
          '_' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.' +
          file.extension,
      contentType: MediaType('application', 'octet-stream'),
    ));

    capsaPrint('pass 5');

    capsaPrint('sending request');
    var res = await request.send();
    var str = await http.Response.fromStream(res);
    var response = jsonDecode(str.body);
    capsaPrint('pass 6');
    capsaPrint('response received $response');

    // var data = jsonDecode((await http.Response.fromStream(res)).body);
    // capsaPrint(data);
    return response;

    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
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

class UploadedInvoiceData {
  String invNo;
  String vendor;
  String issueDate;
  String dueDate;
  String tenure;
  String amt;
  String companyPan;
  String poNum;
  String buyNowPrice;
  String rate;
  String actualValue;
  String poNumber;

  UploadedInvoiceData(this.invNo, this.vendor, this.issueDate, this.tenure,
      this.dueDate, this.amt, this.companyPan, this.poNum, this.buyNowPrice, this.rate, this.actualValue, this.poNumber);
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
