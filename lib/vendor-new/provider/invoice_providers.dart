import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class InvoiceProvider extends ChangeNotifier {
  List<InvoiceModel> _invoices = [];
  String _url = apiUrl + 'dashboard/r/';

  dynamic _invoiceFormData = {};
  bool _invoiceFormWorking = false;

  dynamic get invoiceFormData => _invoiceFormData;

  bool get invoiceFormWorking => _invoiceFormWorking;

  void setInvoiceFormData(dynamic data) {
    capsaPrint('Form Data initiated');
    _invoiceFormData = data;
    _invoiceFormWorking = true;
    capsaPrint('Form Data saved');
    notifyListeners();
  }

  Future<Object> getInvFile(_body) async {
    return await callApi('dashboard/a/getInvFile', body: _body);
  }

  void resetInvoiceFormData() {
    _invoiceFormData = {};
    _invoiceFormWorking = false;
    notifyListeners();
  }

  void insertInvoices(InvoiceModel invoice) {
    _invoices.insert(0, invoice);
    notifyListeners();
  }

  Future<Object> splitInvoice(String invoiceNo, String invAmt) async {
    print('split called');

    var _body = {};
    _body['invoice_number'] = invoiceNo;
    _body['invoice_amount'] = invAmt;
    var data = await callApi3('/dashboard/r/invoiceSplitNum', body: _body);

    var result = {};

    if (data[0] != null) {
      result['isSplit'] = 1;
    } else {
      result['isSplit'] = 0;
    }

    result['result'] = data;

    print('Split Data $result');

    return result;
  }

  Future<Object> deleteInvoice(String invoiceNo, String panNo) async {
    //print('split called');

    var _body = {};
    _body['invoice_number'] = invoiceNo;
    _body['panNumber'] = panNo;
    var data = await callApi3('/dashboard/r/deleteInvoice', body: _body);
    return data;
  }

  Future<Object> updateInvoice(dynamic _body, PlatformFile file) async {
    //return data;
    //_body['year'] = '2022';
    //capsaPrint('Upload Function Called ${_body} ${file.path}');

    print('update invoice body : $_body');

    dynamic _uri;
    _uri = _url + 'updateInvoice';
    //capsaPrint('URL: $_uri');
    //_uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', Uri.parse(_uri));
    //request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value;
    });
    if (file != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.bytes,
        filename: _body['bvnNo'] +
            '_' +
            _body['invNo'] +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file.extension,
        contentType: MediaType('multipart', 'form-data'),
      ));
      request.headers.addAll({'Content-type': 'multipart/form-data'});
    }
    // request.files.add(http.MultipartFile.fromBytes(
    //   'file',
    //   file.bytes,
    //   filename: 'invoice' + file.extension,
    //   contentType: MediaType('multipart', 'form-data'),
    // ));
    // request.headers.addAll({'Content-type': 'multipart/form-data'});
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    capsaPrint('\n\nInvoice Uploaded File:\n\n ${response.body}\n');
    return jsonDecode(response.body);
  }

  Future<Object> editPendingInvoice(dynamic _body, PlatformFile file) async {
    //return data;
    //_body['year'] = '2022';
    //capsaPrint('Upload Function Called ${_body} ${file.path}');

    capsaPrint('update invoice body : $_body');

    dynamic _uri;
    _uri = _url + 'editPendingInvoice';
    //capsaPrint('URL: $_uri');
    //_uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', Uri.parse(_uri));
    request.headers['Authorization'] =
        'Basic ' + box.get('token', defaultValue: '0');
    request.fields['web'] = kIsWeb.toString();

    capsaPrint('pass 1 update api');

    //request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');

    _body.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    capsaPrint('pass 2 update api');
    if (file != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.bytes,
        filename: _body['bvnNo'] +
            '_' +
            _body['invNo'] +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file.extension,
        contentType: MediaType('multipart', 'form-data'),
      ));
      request.headers.addAll({'Content-type': 'multipart/form-data'});
    }

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    capsaPrint(
        'Invoice edit response: ${response.body} ${res.reasonPhrase} \n$_uri');
    return jsonDecode(response.body);
  }

  getInvoicesFilterCount({String type}) {
    var count = 0;
    List<String> invoiceNumbers = [];
    if (type == 'all') return _invoices.length;

    _invoices.forEach((element) {

      if (type == 'pending' &&
          element.invStatus == '2' &&
          element.ilcStatus == '1') {
        //capsaPrint('Pending Invoice 1 - ${element.invNo}');
        if(!invoiceNumbers.contains(element.invNo.toString())){
          invoiceNumbers.add(element.invNo.toString());
        }
      } else if (type == 'pending' && element.childInvoice.isNotEmpty) {
        capsaPrint('Child Ilc Status : ${element.childInvoice[0]['ilcStatus']} ${element.childInvoice[0]['invStatus']} \n\n${element.childInvoice[0]}');
        if (element.childInvoice[0]['ilcStatus'].toString() == '1' && element.childInvoice[0]['invStatus'].toString() == '2') {
          //capsaPrint('Pending Invoice 2 - ${element.invNo}');
          if(!invoiceNumbers.contains(element.invNo.toString())){
            invoiceNumbers.add(element.invNo.toString());
          }
        }
      } else if (type == 'live' &&
          element.discount_status == 'false' &&
          element.payment_status == '0' &&
          element.ilcStatus == '2') {
        if(!invoiceNumbers.contains(element.invNo.toString())){
          invoiceNumbers.add(element.invNo.toString());
        }
      } else if (element.status == '2') {
      } else if (element.status == '2') {}
    });

    capsaPrint("invoices : $type    $invoiceNumbers");

    return invoiceNumbers.length;
  }

  getInvoicesFilter(String type) {
    // capsaPrint('getInvoicesFilter');
    // capsaPrint(type);

    List list = <InvoiceModel>[];
    if (type == 'notPresented') {
      _invoices.forEach((element) {
        // capsaPrint('status: ' + element.status);
        if (element.invStatus == '1') {
          list.add(element);
        }
      });
    } else if (type == 'live') {
      _invoices.forEach((element) {
        if (element.discount_status == 'false' &&
            element.payment_status == '0' &&
            element.ilcStatus == '2') {
          list.add(element);
        }
      });
    } else if (type == 'sold') {
      _invoices.forEach((element) {
        if (element.discount_status == 'true') {
          list.add(element);
        }
      });
    } else if (type == 'pending') {
      _invoices.forEach((element) {
        if (element.invStatus == '2' && element.ilcStatus == '1') {
          list.add(element);
        }
      });
    } else {
      list = _invoices;
    }
    return list;
  }

  List<InvoiceModel> get invoices => _invoices;

  final box = Hive.box('capsaBox');

  Future<Object> setInvoiceList(data) async {
    _invoices = [];
    List<InvoiceModel> _acctTableData = <InvoiceModel>[];
    var _data = data;
    if (_data['res'] == 'success') {
      var _results = _data['data']['invoicelist'];

      _results.forEach((element) {
        DateTime invoiceDate =
            new DateFormat("yyyy-MM-dd").parse(element['invoice_date']);

        DateTime invoiceDueDate =
            new DateFormat("yyyy-MM-dd").parse(element['invoice_due_date']);

        _acctTableData.add(InvoiceModel(
          anchor: element['customer_name'],
          bvnNo: element['company_pan'],
          isRevenue: element['isRevenue'].toString(),
          invNo: element['invoice_number'].toString(),
          invAmt: element['invoice_value'].toString(),
          invDate: DateFormat.yMMMd('en_US').format(invoiceDate),
          invDueDate: DateFormat.yMMMd('en_US').format(invoiceDueDate),
          buyNowPrice: element['ask_amt'].toString(),
          terms: element['payment_terms'],
          rate: element['ask_rate'].toString(),
          status: element['status'].toString(),
          discount_status: element['discount_status'].toString(),
          invStatus: element['invStatus'].toString(),
          payment_status: element['payment_status'].toString(),
          ilcStatus: element['ilcStatus'].toString(),
          fileType: element['invoice_file'],
          cuGst: element['customer_gst'],
          childInvoice: element['isSplit'].toString() == '1' ? element['chileInvoice'] : []
        ));
      });

      _invoices.addAll(_acctTableData);
      notifyListeners();
    }

    return null;
  }

  Future<Object> queryInvoiceList(String type, {String search}) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      // capsaPrint('userData');
      // capsaPrint(userData);
      _body['panNumber'] = userData['panNumber'];

      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];
      _body['type'] = (type != null) ? type : '';
      _body['search'] = (search != null) ? search : '';
      _body['currency'] = 'all';

      dynamic _uri;
      _uri = _url + 'invoicelist';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);
      //capsaPrint('\n\nInvoices $type\n : $data');

      await setInvoiceList(data);

      return data;
    }
    return null;
  }

  Future<Object> queryInvoiceData(String invoiceNumber) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      // capsaPrint('userData');
      // capsaPrint(userData);
      _body['panNumber'] = userData['panNumber'];

      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];
      _body['invoiceNumber'] = (invoiceNumber != null) ? invoiceNumber : '';

      dynamic _uri = 'dashboard/r/invoiceByNumber';

      dynamic _response = callApi(_uri, body: _body);
      capsaPrint('Invoice Response : \n$_response');
      return _response;
    }
    return null;
  }

  Future<Object> submitForApproval(_body) async {
    // capsaPrint('userData');
    // capsaPrint(userData);

    dynamic _uri;
    _body['isSplit'] = '0';
    _uri = _url + 'requestApproval';
    _uri = Uri.parse(_uri);
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Object> updateStatus(invNum) async {
    int index = _invoices.indexWhere((element) => element.invNo == invNum);

    InvoiceModel _invoiceModel = _invoices[index];

    _invoiceModel.status = '2';
    _invoices[index] = _invoiceModel;
    _invoiceModel = _invoices[index];

    // capsaPrint(_invoiceModel.status);
    notifyListeners();

    return null;
  }

  Future<Object> downloadFile(String url, {fName: "Invoice"}) async {
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

  Future<Object> deletePendingInvoice(String invoiceNumber) async {
    // capsaPrint('userData');
    // capsaPrint(userData);

    dynamic _uri;
    var userData = Map<String, dynamic>.from(box.get('userData'));

    var _body = {};

    // capsaPrint('userData');
    // capsaPrint(userData);
    _body['panNumber'] = userData['panNumber'];
    _body['invoice_number'] = invoiceNumber;
    _uri = _url + 'deletePendingInvoice';
    _uri = Uri.parse(_uri);
    capsaPrint('Delete invoice body : \n$_uri\n$_body');
    var response = await http.post(_uri,
        headers: <String, String>{
          'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
        },
        body: _body);
    capsaPrint('Delete Invoice response : \n${response.body}');
    var data = jsonDecode(response.body);
    return data;
  }

  // Future<Object> getCurrencies() async {
  //   if (box.get('isAuthenticated', defaultValue: false)) {
  //     var userData = Map<String, dynamic>.from(box.get('userData'));
  //
  //     var _body = {};
  //
  //     dynamic _uri = 'dashboard/r/getCurrenciesAvailable';
  //
  //     return callApi(_uri, body: _body);
  //   }
  //   return null;
  // }
  //
  // Future<Object> checkCurrency(String currency){
  //   if (box.get('isAuthenticated', defaultValue: false)) {
  //     var userData = Map<String, dynamic>.from(box.get('userData'));
  //
  //     var _body = {};
  //     _body['currency'] = currency;
  //     _body['panNumber'] = userData['panNumber'];
  //
  //     dynamic _uri = 'dashboard/r/getCurrenciesAvailable';
  //
  //     return callApi(_uri, body: _body);
  //   }
  //   return null;
  // }

}
