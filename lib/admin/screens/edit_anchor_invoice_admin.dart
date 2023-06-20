// import 'dart:convert';
//
// import 'package:beamer/beamer.dart';
// import 'package:capsa/admin/models/invoice_model.dart';
// import 'package:capsa/admin/providers/profile_provider.dart';
// import 'package:capsa/anchor/provider/anchor_action_providers.dart';
// import 'package:capsa/common/constants.dart';
// import 'package:capsa/common/responsive.dart';
// import 'package:capsa/functions/hexcolor.dart';
// import 'package:capsa/functions/show_toast.dart';
//
// import 'package:capsa/widgets/TopBarWidget.dart';
// import 'package:capsa/widgets/capsaapp/generateddesktopmenuwidget/GeneratedDesktopMenuWidget.dart';
// import 'package:capsa/widgets/orientation_switcher.dart';
// import 'package:capsa/widgets/popup_action_info.dart';
// import 'package:capsa/widgets/user_input.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
//
// import 'package:flutter/material.dart';
// import 'package:capsa/functions/custom_print.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
// import 'package:http/http.dart' as http;
//
// class EditAnchorInvoiceAdmin extends StatefulWidget {
//   UploadedInvoiceData invoice;
//   EditAnchorInvoiceAdmin({Key key, @required this.invoice}) : super(key: key);
//
//   @override
//   State<EditAnchorInvoiceAdmin> createState() => _EditAnchorInvoiceAdminState();
// }
//
// class _EditAnchorInvoiceAdminState extends State<EditAnchorInvoiceAdmin> {
//   final _formKey = GlobalKey<FormState>();
//
//   final Box box = Hive.box('capsaBox');
//   final dueDateCont = TextEditingController();
//   final dateCont = TextEditingController();
//   final extDateCont = TextEditingController();
//   final fileCont = TextEditingController(text: '');
//   DateTime _selectedDate;
//   DateTime _selectedDueDate;
//   DateTime _selectedExtDueDate;
//   var _cuGst;
//   dynamic daysDiff;
//
//   bool saving = false;
//
//   TextEditingController pfeeController = TextEditingController();
//
//   final rateController2 = TextEditingController(text: '');
//
//   dynamic companyDetails = null;
//
//   Future<dynamic> getCompanyNames(BuildContext context) async {
//     capsaPrint('pass 1 company');
//     if (companyDetails == null) {
//       capsaPrint('pass 2 company');
//       dynamic data =
//       await Provider.of<AnchorActionProvider>(context, listen: false)
//           .getCompanyName();
//       companyDetails = data;
//       capsaPrint('pass 3 company');
//       setState(() {
//
//       });
//     }
//
//     return companyDetails;
//   }
//
//   int navigate() {
//     Beamer.of(context).beamToNamed('/confirmInvoice');
//     return 1;
//   }
//
//   // void updateAdmin(String panNumber){
//   //
//   //
//   //
//   // }
//
//   void updateInvoice(String panNumber) async{
//
//     print('update field');
//
//     var _body = {};
//     // _body['company_pan'] = panNumber;
//     // // _body['cu_gst'] = widget.invoice.cu_gst;
//     // // _body['customer_gst'] = widget.invoice.cu_gst;
//     // _body['previous_invoice_number'] = invoiceNoController.text;
//     // _body['invoice_number'] = invoiceNoController.text;
//     // _body['invoice_due_date'] = dueDateCont.text;
//     // _body['description'] = detailsController.text;
//     // // _body['invoice_quantity'] = widget.invoice.invoiceQuantity;
//     // _body['invoice_value'] = invoiceAmtController.text;
//     // _body['payment_terms'] = tenureController.text;
//     // _body['rate'] = rateController2.text;
//     // _body['buyNowPrice'] = buyAmtController.text;
//     // _body['invoice_date'] = dateCont.text;
//     // _body['ext_due_date'] = extDateCont.text;
//
//     capsaPrint('pass 1');
//
//     _body = {
//       'invoice_number' : invoiceNoController.text,
//       'invoice_number_old' : widget.invoice.invNo,
//       'tenure' : _selectedDueDate.difference(_selectedDate).inDays.toString(),
//       'company_pan': widget.invoice.companyPan,
//       'po_num' : widget.invoice.poNum,
//       'invoice_date' : dateCont.text,
//       'invoice_due_date' : dueDateCont.text,
//       'invoice_value' : (num.parse(invoiceAmtController.text) + ((num.parse(rateController2.text)/100) * num.parse(invoiceAmtController.text))).toString(),
//       'buy_now' : buyAmtController.text,
//       'rate' : rateController2.text,
//       'details': detailsController.text
//     };
//
//     capsaPrint('pass 2');
//
//     String _url = apiUrl + '/dashboard/a/';
//     dynamic _uri = _url + 'invoiceEditAnchor';
//     //_uri = Uri.parse(_uri);
//
//     //var request = http.MultipartRequest('POST', Uri.parse(_uri));
//
//     print('\n\nBody : $_body \n$_uri');
//
//
//     _uri = Uri.parse(_uri);
//     var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
//     var data = jsonDecode(response.body);
//     capsaPrint('Update Invoice e: ${response.body}');
//     if(data['res'] == 'success'){
//       showToast('Update Successful', context);
//       Navigator.pop(context);
//     }else{
//       showToast(data, context, type: 'error');
//     }
//
//   }
//
//
//
//   Future getCompanyName() async {
//     String _url = apiUrl + 'dashboard/r/';
//     dynamic _uri = _url + 'getCompanyName';
//     _uri = Uri.parse(_uri);
//     var _body = {};
//     var userData = Map<String, dynamic>.from(box.get('tmpUserData'));
//     _body['panNumber'] = userData['panNumber'];
//     var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
//     var _data = jsonDecode(response.body);
//     if (_data['res'] == 'success') {
//       var _items = _data['data'];
//       anchorNameList = _items;
//       var userData = Map<String, dynamic>.from(box.get('userData'));
//
//       anchorNameList
//           .forEach((element1) {
//         if (element1['name'] == userData['name']) {
//           capsaPrint('anchor : element: $element1');
//           // cacAddress = element1['name_address'];
//           anchorController.text = element1['name'];
//           anchor = element1[
//           'name_address'];
//           pfeeController.text = element1['capsa_rate'].toString();
//           // capsaPrint(cacAddress);
//
//         }
//       });
//
//     }
//     capsaPrint("Bank Data $_data");
//     return _data;
//   }
//
//   void calculateRate() {
//     //print('x');
//     //rateController2.text = '';
//     var invAmt = invoiceAmtController.text;
//     var invSell = buyAmtController.text;
//     if (invAmt == null) return;
//     // if(invSell == null) invSell = 0;
//     if (_selectedDate == null) return;
//     if (_selectedDueDate == null) return;
//
//     if (invSell == null || invSell == '') invSell = '0';
//
//     tenureDaysDiff = _selectedDueDate.difference(_selectedDate).inDays;
//
//     // num rate = (((num.tryParse(invAmt) - num.tryParse(invSell)) / (num.tryParse(invAmt) * 1) * 100) / 360) * tenureDaysDiff;
//     num rate = 0;
//     if (num.tryParse(invSell) > 0) {
//       rate = ((num.tryParse(invAmt) / num.tryParse(invSell)) - 1) *
//           (1 / tenureDaysDiff) *
//           365;
//     }
//     //  (INVOICE AMOUNT/SELL NOW PRICE - 1) * (1-TENURE) * 365 DAYS
//
//     // setState(() {
//     // if (rate == 'Infinity') {
//     //   rateController2.text = '0';
//     // }
//     // rateController2.text = rate.toStringAsFixed(2);
//     // if (rateController2.text == 'Infinity') {
//     //   rateController2.text = '0';
//     // }
//
//     // });
//   }
//
//   var term = ["Select One"];
//
//   _selectDueDate(BuildContext context) async {
//     // capsaPrint("_selectDueDate");
//
//     DateTime newSelectedDate = await showDatePicker(
//         context: context,
//         initialDate:
//         _selectedDueDate != null ? _selectedDueDate : DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2040),
//         builder: (BuildContext context, Widget child) {
//           return Theme(
//             data: ThemeData.light().copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: Theme.of(context).primaryColor,
//                 onPrimary: Colors.white,
//                 surface: Theme.of(context).primaryColor,
//                 // onSurface: Colors.yellow,
//               ),
//               // dialogBackgroundColor: Colors.blue[500],
//             ),
//             child: child,
//           );
//         });
//
//     if (newSelectedDate != null) {
//       _selectedDueDate = newSelectedDate;
//       dueDateCont
//         ..text = DateFormat('yyyy-MM-dd').format(_selectedDueDate)
//         ..selection = TextSelection.fromPosition(TextPosition(
//             offset: dueDateCont.text.length, affinity: TextAffinity.upstream));
//       _selectedExtDueDate = _selectedDueDate.add(Duration(days: daysDiff));
//       extDateCont
//         ..text = DateFormat('yyyy-MM-dd').format(_selectedExtDueDate)
//         ..selection = TextSelection.fromPosition(TextPosition(
//             offset: extDateCont.text.length, affinity: TextAffinity.upstream));
//       calculateRate();
//     }
//   }
//
//   _selectDate(BuildContext context) async {
//     DateTime newSelectedDate = await showDatePicker(
//         context: context,
//         initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2040),
//         builder: (BuildContext context, Widget child) {
//           return Theme(
//             data: ThemeData.light().copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: Theme.of(context).primaryColor,
//                 onPrimary: Colors.white,
//                 surface: Theme.of(context).primaryColor,
//                 // onSurface: Colors.yellow,
//               ),
//               // dialogBackgroundColor: Colors.blue[500],
//             ),
//             child: child,
//           );
//         });
//
//     if (newSelectedDate != null) {
//       _selectedDate = newSelectedDate;
//       dateCont
//         ..text = DateFormat('yyyy-MM-dd').format(_selectedDate)
//         ..selection = TextSelection.fromPosition(TextPosition(
//             offset: dateCont.text.length, affinity: TextAffinity.upstream));
//       calculateRate();
//     }
//   }
//
//   final anchorNameController = TextEditingController(text: '');
//   final anchorController = TextEditingController(text: '');
//   final invoiceNoController = TextEditingController(text: '');
//   final poController = TextEditingController(text: '');
//   final tenureController = TextEditingController(text: '');
//   final invoiceAmtController = TextEditingController(text: '');
//   final buyAmtController = TextEditingController(text: '');
//   final detailsController = TextEditingController(text: '');
//   final vendorController = TextEditingController(text: '');
//   var anchor;
//   var vendor;
//
//   // var anchor, cacAddress, invNo, po, terms;
//
//   // var invAmt, details, rate, invDueDate;
//   // var invSell = '0';
//
//   var tenureDaysDiff = 0;
//
//   var anchorNameList = [];
//
//   PlatformFile file;
//
//   bool loadingCall = false;
//   bool loadingConfirm = false;
//
//   bool nextMobileType = false;
//   bool nextEnable = false;
//   var userData;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // final invoiceProvider =
//     // Provider.of<InvoiceProvider>(context, listen: false);
//
//     //capsaPrint("\n\ndescription ${widget.invoice.description}");
//      userData = Map<String, dynamic>.from(box.get('userData'));
//      capsaPrint('Rate : ${widget.invoice.rate}');
//
//     if (true) {
//       invoiceNoController.text = widget.invoice.invNo;
//       // poController.text = widget.invoice.poNo;
//       tenureController.text = widget.invoice.tenure;
//       invoiceAmtController.text = widget.invoice.amt;
//       buyAmtController.text = widget.invoice.amt;
//       rateController2.text = widget.invoice.rate;
//       capsaPrint('Rate 2 : ${rateController2.text}');
//       //detailsController.text = widget.invoice.details;
//       //anchor = invoiceFormData["anchor"];
//       anchorNameController.text = userData['userName'];
//       detailsController.text = '';
//       dateCont.text = DateFormat('yyyy-MM-dd')
//           .format(DateFormat("dd MMM, yyyy")
//           .parse(widget.invoice.issueDate))
//           .toString();
//       _selectedDate = DateFormat("dd MMM, yyyy")
//           .parse(widget.invoice.issueDate);
//       dueDateCont.text = DateFormat('yyyy-MM-dd')
//           .format(DateFormat("dd MMM, yyyy")
//           .parse(widget.invoice.dueDate))
//           .toString();
//       _selectedDueDate = DateFormat("dd MMM, yyyy")
//           .parse(widget.invoice.dueDate);
//       //tenureDaysDiff = num.parse(invoiceFormData["tenureDaysDiff"]);
//       //rateController2.text = widget.invoice.askRate;
//       extDateCont.text = DateFormat('yyyy-MM-dd')
//           .format(DateFormat("dd MMM, yyyy")
//           .parse(widget.invoice.dueDate))
//           .toString();
//       //fileCont.text = invoiceFormData["fileCont"];
//       //_selectedDate = invoiceFormData["_selectedDate"];
//       _selectedDueDate = DateFormat("dd MMM, yyyy")
//         .parse(widget.invoice.dueDate);
//       _selectedExtDueDate = DateFormat("dd MMM, yyyy")
//           .parse(widget.invoice.dueDate);
//       daysDiff = DateFormat("dd MMM, yyyy")
//           .parse(widget.invoice.dueDate).difference(DateFormat("dd MMM, yyyy")
//           .parse(widget.invoice.issueDate)).inDays;
//       //file = invoiceFormData["file"];
//       //_cuGst = invoiceFormData["cuGst"];
//
//       calculateRate();
//     }
//
//     //invoiceProvider.splitInvoice('DH001', '50000000');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final invoiceProvider =
//     // Provider.of<InvoiceProvider>(context, listen: false);
//
//     if (Responsive.isMobile(context)) {
//       nextMobileType = true;
//       nextEnable = false;
//     }
//
//     return Scaffold(
//       body: Row(
//         children: [
//           Container(
//             width: Responsive.isMobile(context) ? 0 : 185,
//             height: MediaQuery.of(context).size.height * 1.1,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(0.0),
//                 topRight: Radius.circular(20.0),
//                 bottomRight: Radius.circular(0.0),
//                 bottomLeft: Radius.circular(0.0),
//               ),
//               color: Color.fromARGB(255, 15, 15, 15),
//             ),
//             child: Stack(
//               fit: StackFit.expand,
//               alignment: Alignment.center,
//               overflow: Overflow.visible,
//               children: [
//                 Positioned(
//                     left: 42.5,
//                     top: 38.0,
//                     right: null,
//                     bottom: null,
//                     width: 34,
//                     height: 34,
//                     child: Container(
//                       width: 80.0,
//                       height: 45,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.zero,
//                           child: Image.asset(
//                             "assets/images/arrow-left.png",
//                             color: null,
//                             fit: BoxFit.cover,
//                             width: 34.0,
//                             height: 34,
//                             colorBlendMode: BlendMode.dstATop,
//                           ),
//                         ),
//                       ),
//                     )),
//               ],
//             ),
//           ),
//           true?Container(
//             //height: MediaQuery.of(context).size.height,
//             padding: const EdgeInsets.all(25.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (!Responsive.isMobile(context))
//                     SizedBox(
//                       height: 22,
//                     ),
//                   // TopBarWidget("Edit Invoice", ""),
//                   // SizedBox(
//                   //   height: (!Responsive.isMobile(context)) ? 8 : 15,
//                   // ),
//                   //if (Responsive.isMobile(context)) mobileFormSteper(),
//                   FutureBuilder<Object>(
//                       future: getCompanyNames(context),
//                       builder: (context, snapshot) {
//                         if (companyDetails == null) {
//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         int i = 0;
//                         if (snapshot.hasError) {
//                           return Center(
//                             child: Text(
//                               'There was an error :(\n' +
//                                   snapshot.error.toString(),
//                               style: Theme.of(context).textTheme.bodyText2,
//                             ),
//                           );
//                         } else if (snapshot.hasData) {
//                           dynamic temp = snapshot.data;
//                           dynamic _data = temp[0];
//                           dynamic _vendorData = temp[1];
//
//                           //_data['data'] = ['hello'];
//
//                           capsaPrint('\n\ncompany data  $_data');
//
//                           capsaPrint('\n\nvendor data  $_vendorData');
//
//                           TextEditingController pfeeController = TextEditingController();
//
//                           pfeeController.text = _data['data'][0]['capsa_rate'].toString();
//
//                           var _items = _data['data'];
//                           Map<String, bool> _isBlackListed = {};
//                           Map<String, String> anchorGrade = {};
//
//                           List<String> vendorsList = [];
//                           Map<String, String> vendorPan = {};
//
//                           String selectedVendor = '';
//                           String selectedVendorPan = '';
//
//                           var anchorNameList = [];
//
//                           var userData = Map<String, dynamic>.from(box.get('userData'));
//
//                           capsaPrint('Anchor userdata $userData');
//
//                           anchor = userData['name'];
//
//                           anchorController.text = anchor;
//
//
//
//                           if (_data['res'] == 'success') {
//                             anchorNameList = _items;
//
//                             anchorNameList
//                                 .forEach((element1) {
//                               if (element1['name'] == anchor) {
//                                 capsaPrint('anchor : element: $element1');
//                                 // cacAddress = element1['name_address'];
//                                 anchorController.text = element1['name'];
//                                 anchor = element1[
//                                 'name_address'];
//                                 pfeeController.text = element1['capsa_rate'].toString();
//                                 // grade =
//                                 // anchorGrade[anchor];
//                                 // capsaPrint(
//                                 //     'Grade initiated :  $grade');
//                                 _cuGst =
//                                 element1['cu_gst'];
//                                 // capsaPrint(cacAddress);
//
//                               }
//                             });
//
//                             term = [];
//                             _items.forEach((element) {
//                               term.add(element['name'].toString());
//                               _isBlackListed[element['name'].toString()] =
//                               element['isBlacklisted'] != null
//                                   ? element['isBlacklisted'] == '1'
//                                   ? true
//                                   : false
//                                   : false;
//                               anchorGrade[element['name'].toString()] =
//                                   element['grade'] ?? '';
//                             });
//
//                             dynamic responseList = _vendorData['vendorList'];
//                             responseList.forEach((element) {
//                               vendorsList.add(element['NAME']);
//                               vendorPan[element['NAME']] = element['PAN_NO'];
//                             });
//
//                           } else {
//                             return Center(
//                               child: Text(
//                                 'There was an error :(\n' + _data['messg'].toString(),
//                                 style: Theme.of(context).textTheme.bodyText2,
//                               ),
//                             );
//                           }
//
//                           // ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
//                           final GlobalKey<FormFieldState> _key =
//                           GlobalKey<FormFieldState>();
//
//                           return Container(
//                             width: MediaQuery.of(context).size.width - 240,
//                             child: Form(
//                               // onChanged: ,
//                               key: _formKey,
//                               child: OrientationSwitcher(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 // orientation: Responsive.isMobile(context) ? "Column" : "Row" ,
//                                 children: [
//                                   Flexible(
//                                       flex: 1,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           OrientationSwitcher(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "Anchor Name",
//                                                   hintText: "Select Anchor",
//                                                   controller: anchorNameController,
//                                                   readOnly: true,
//                                                   // textFormField:
//                                                   //     DropdownButtonFormField(
//                                                   //   isExpanded: true,
//                                                   //   validator: (v) {
//                                                   //     if (anchorController
//                                                   //             .text ==
//                                                   //         '') {
//                                                   //       return "Can't be empty";
//                                                   //     }
//                                                   //     return null;
//                                                   //   },
//                                                   //   items: term
//                                                   //       .map((String category) {
//                                                   //     return DropdownMenuItem(
//                                                   //       value: category,
//                                                   //       child: Text(category
//                                                   //           .toString()),
//                                                   //     );
//                                                   //   }).toList(),
//                                                   //   onChanged: (v) {
//                                                   //     // capsaPrint(anchorNameList);
//                                                   //     if (_isBlackListed[v]) {
//                                                   //       showToast(
//                                                   //           'Functionalities for this anchor is temporarily suspended',
//                                                   //           context,
//                                                   //           type: 'warning');
//                                                   //       _formKey.currentState
//                                                   //           .reset();
//                                                   //     } else {
//                                                   //       anchor = v;
//                                                   //       anchorNameList.forEach(
//                                                   //           (element1) {
//                                                   //         if (element1[
//                                                   //                 'name'] ==
//                                                   //             v) {
//                                                   //           // cacAddress = element1['name_address'];
//                                                   //           anchorController
//                                                   //                   .text =
//                                                   //               element1[
//                                                   //                   'name_address'];
//                                                   //           _cuGst = element1[
//                                                   //               'cu_gst'];
//                                                   //
//                                                   //           // capsaPrint(cacAddress);
//                                                   //
//                                                   //         }
//                                                   //       });
//                                                   //     }
//                                                   //   },
//                                                   //   value: anchor,
//                                                   //   decoration: InputDecoration(
//                                                   //     border: InputBorder.none,
//                                                   //     filled: true,
//                                                   //     fillColor: Colors.white,
//                                                   //     hintText: "Select Anchor",
//                                                   //     hintStyle: TextStyle(
//                                                   //         color: Color.fromRGBO(
//                                                   //             130, 130, 130, 1),
//                                                   //         fontSize: 14,
//                                                   //         letterSpacing:
//                                                   //             0 /*percentages not used in flutter. defaulting to zero*/,
//                                                   //         fontWeight:
//                                                   //             FontWeight.normal,
//                                                   //         height: 1),
//                                                   //     contentPadding:
//                                                   //         const EdgeInsets.only(
//                                                   //             left: 8.0,
//                                                   //             bottom: 12.0,
//                                                   //             top: 12.0),
//                                                   //     focusedBorder:
//                                                   //         OutlineInputBorder(
//                                                   //       borderSide: BorderSide(
//                                                   //           color:
//                                                   //               Colors.white),
//                                                   //       borderRadius:
//                                                   //           BorderRadius
//                                                   //               .circular(15.7),
//                                                   //     ),
//                                                   //     enabledBorder:
//                                                   //         UnderlineInputBorder(
//                                                   //       borderSide: BorderSide(
//                                                   //           color:
//                                                   //               Colors.white),
//                                                   //       borderRadius:
//                                                   //           BorderRadius
//                                                   //               .circular(15.7),
//                                                   //     ),
//                                                   //   ),
//                                                   // ),
//                                                 ),
//                                               ),
//                                               // UserTextFormField(
//                                               //   label: "Vendor Name",
//                                               //   hintText: "Select Vendor",
//                                               //   textFormField:
//                                               //   DropdownButtonFormField(
//                                               //     isExpanded: true,
//                                               //     validator: (v) {
//                                               //       if (vendorController.text ==
//                                               //           '') {
//                                               //         return "Can't be empty";
//                                               //       }
//                                               //       return null;
//                                               //     },
//                                               //     items:
//                                               //     vendorsList.map((String category) {
//                                               //       return DropdownMenuItem(
//                                               //         //key: _key,
//                                               //         value: category,
//                                               //         child:
//                                               //         Text(category.toString()),
//                                               //       );
//                                               //     }).toList(),
//                                               //     onChanged: (v) {
//                                               //       selectedVendor = v;
//                                               //       selectedVendorPan = vendorPan[v];
//                                               //       vendorController.text = v;
//                                               //     },
//                                               //     value: vendor,
//                                               //     decoration: InputDecoration(
//                                               //       border: InputBorder.none,
//                                               //       filled: true,
//                                               //       fillColor: Colors.white,
//                                               //       hintText: "Select Vendor",
//                                               //       hintStyle: TextStyle(
//                                               //           color: Color.fromRGBO(
//                                               //               130, 130, 130, 1),
//                                               //           fontSize: 14,
//                                               //           letterSpacing:
//                                               //           0 /*percentages not used in flutter. defaulting to zero*/,
//                                               //           fontWeight:
//                                               //           FontWeight.normal,
//                                               //           height: 1),
//                                               //       contentPadding:
//                                               //       const EdgeInsets.only(
//                                               //           left: 8.0,
//                                               //           bottom: 12.0,
//                                               //           top: 12.0),
//                                               //       focusedBorder:
//                                               //       OutlineInputBorder(
//                                               //         borderSide: BorderSide(
//                                               //             color: Colors.white),
//                                               //         borderRadius:
//                                               //         BorderRadius.circular(
//                                               //             15.7),
//                                               //       ),
//                                               //       enabledBorder:
//                                               //       UnderlineInputBorder(
//                                               //         borderSide: BorderSide(
//                                               //             color: Colors.white),
//                                               //         borderRadius:
//                                               //         BorderRadius.circular(
//                                               //             15.7),
//                                               //       ),
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                             ],
//                                           ),
//                                           OrientationSwitcher(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "Invoice No",
//                                                   hintText: "Invoice Number",
//                                                   readOnly: false,
//                                                   controller:
//                                                   invoiceNoController,
//                                                   onChanged: (v) {
//                                                     String s = v;
//                                                     if (v.contains('/') ||
//                                                         v.contains(r'\')) {
//                                                       showToast(
//                                                           'Invoice Number Cannot Contain  /  or  '
//                                                           r'\',
//                                                           context,
//                                                           type: 'warning');
//                                                       s = s.replaceAll(
//                                                           r'\', '-');
//                                                       s = s.replaceAll(
//                                                           '/', '-');
//                                                     }
//                                                     invoiceNoController.text =
//                                                         s;
//                                                     invoiceNoController
//                                                         .selection =
//                                                         TextSelection.fromPosition(
//                                                             TextPosition(
//                                                                 offset:
//                                                                 invoiceNoController
//                                                                     .text
//                                                                     .length));
//                                                   },
//                                                 ),
//                                               ),
//
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "Invoice No",
//                                                   hintText: "Invoice Number",
//                                                   readOnly: false,
//                                                   controller:
//                                                   invoiceNoController,
//                                                   onChanged: (v) {
//                                                     String s = v;
//                                                     if (v.contains('/') ||
//                                                         v.contains(r'\')) {
//                                                       showToast(
//                                                           'Invoice Number Cannot Contain  /  or  '
//                                                           r'\',
//                                                           context,
//                                                           type: 'warning');
//                                                       s = s.replaceAll(
//                                                           r'\', '-');
//                                                       s = s.replaceAll(
//                                                           '/', '-');
//                                                     }
//                                                     invoiceNoController.text =
//                                                         s;
//                                                     invoiceNoController
//                                                         .selection =
//                                                         TextSelection.fromPosition(
//                                                             TextPosition(
//                                                                 offset:
//                                                                 invoiceNoController
//                                                                     .text
//                                                                     .length));
//                                                   },
//                                                 ),
//                                               ),
//
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "PO Number",
//                                                   controller: poController,
//                                                   hintText: "Purchase order Number",
//                                                 ),
//                                               ),
//
//                                             ],
//                                           ),
//                                           OrientationSwitcher(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "Issue Date",
//                                                   readOnly: true,
//                                                   controller: dateCont,
//                                                   suffixIcon: Icon(Icons
//                                                       .date_range_outlined),
//                                                   hintText:
//                                                   "Invoice Issue date",
//                                                   onTap: () =>
//                                                       _selectDate(context),
//                                                   keyboardType:
//                                                   TextInputType.number,
//                                                 ),
//                                               ),
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "Due Date",
//                                                   suffixIcon: Icon(Icons
//                                                       .date_range_outlined),
//                                                   readOnly: true,
//                                                   controller: dueDateCont,
//                                                   hintText: "Invoice Due Date",
//                                                   onTap: () =>
//                                                       _selectDueDate(context),
//                                                   keyboardType:
//                                                   TextInputType.number,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//
//                                           if(daysDiff == const Duration(days: 0))
//                                             OrientationSwitcher(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                               children: [
//                                                 Flexible(
//                                                   child: UserTextFormField(
//                                                     label: "Extended Due Date",
//                                                     readOnly: true,
//                                                     controller: extDateCont,
//                                                     suffixIcon: Icon(Icons
//                                                         .date_range_outlined),
//                                                     hintText:
//                                                     "Extended Due Date",
//                                                     // onTap: () =>
//                                                     //     _selectDate(context),
//                                                     keyboardType:
//                                                     TextInputType.number,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//
//                                           OrientationSwitcher(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "Tenure",
//                                                   hintText: "30 or 60 Days?",
//                                                   controller: tenureController,
//                                                 ),
//                                               ),
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "Invoice Amount",
//                                                   hintText:
//                                                   "Enter invoice amount",
//                                                   prefixIcon: Image.asset(
//                                                       "assets/images/currency.png"),
//                                                   controller:
//                                                   invoiceAmtController,
//                                                   readOnly: false,
//                                                   onChanged: (v) {
//                                                     buyAmtController.text = invoiceAmtController.text;
//                                                     // if (num.parse(v) <
//                                                     //     num.parse(
//                                                     //         buyAmtController.text)) {
//                                                     //   invoiceAmtController.text =
//                                                     //   "";
//                                                     //   buyAmtController.text = '';
//                                                     //   showToast(
//                                                     //       'Invoice Amount cannot be less than sell now price',
//                                                     //       context, type: 'warning');
//                                                     // }
//                                                     // calculateRate();
//                                                   },
//                                                   keyboardType: TextInputType
//                                                       .numberWithOptions(
//                                                       decimal: true),
//                                                   inputFormatters: [
//                                                     FilteringTextInputFormatter
//                                                         .allow(
//                                                         RegExp(r"[0-9.]")),
//                                                     // TextInputFormatter
//                                                     //     .withFunction((oldValue,
//                                                     //     newValue) {
//                                                     //   try {
//                                                     //     final text =
//                                                     //         newValue.text;
//                                                     //     if (text.isNotEmpty)
//                                                     //       double.parse(text);
//                                                     //     return newValue;
//                                                     //   } catch (e) {}
//                                                     //   return oldValue;
//                                                     // }),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           OrientationSwitcher(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               // Flexible(
//                                               //   child: UserTextFormField(
//                                               //     label: "Sell Now Price",
//                                               //     hintText:
//                                               //     "Amount to sell invoice",
//                                               //     prefixIcon: Image.asset(
//                                               //         "assets/images/currency.png"),
//                                               //     validator: (v) {
//                                               //       return null;
//                                               //     },
//                                               //     readOnly : true,
//                                               //     onChanged: (v) {
//                                               //       if (num.parse(v) >=
//                                               //           num.parse(
//                                               //               invoiceAmtController
//                                               //                   .text)) {
//                                               //         buyAmtController.text =
//                                               //         "";
//                                               //         showToast(
//                                               //             'Sell Now Price can\'t be greater then invoice amount',
//                                               //             context, type: 'warning');
//                                               //       }
//                                               //       calculateRate();
//                                               //     },
//                                               //     controller: buyAmtController,
//                                               //     keyboardType: TextInputType
//                                               //         .numberWithOptions(
//                                               //         decimal: true),
//                                               //     inputFormatters: [
//                                               //       // CurrencyTextInputFormatter(locale: "en_US",decimalDigits: 2),
//                                               //       FilteringTextInputFormatter
//                                               //           .allow(
//                                               //           RegExp(r"[0-9.]")),
//                                               //       TextInputFormatter
//                                               //           .withFunction((oldValue,
//                                               //           newValue) {
//                                               //         try {
//                                               //           final text =
//                                               //               newValue.text;
//                                               //           if (text.isNotEmpty)
//                                               //             double.parse(text);
//                                               //           return newValue;
//                                               //         } catch (e) {}
//                                               //         return oldValue;
//                                               //       }),
//                                               //     ],
//                                               //     // prefixIcon : Text()
//                                               //   ),
//                                               // ),
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   label: "Discount rate",
//                                                   hintText: "",
//                                                   readOnly: false,
//                                                   controller: rateController2,
//                                                   suffixIcon: Image.asset(
//                                                       "assets/images/%.png"),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           OrientationSwitcher(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Flexible(
//                                                 child: UserTextFormField(
//                                                   // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
//                                                   label:
//                                                   "Details (e.g items or quantity)",
//                                                   hintText: "48 packs of goods",
//                                                   controller: detailsController,
//                                                   minLines: 1,
//                                                   readOnly: false,
//                                                   maxLines: 5,
//                                                   validator: (val) {
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(height: 16),
//                                           saving ?
//                                               CircularProgressIndicator() :
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                             children: [
//                                               InkWell(
//                                                 onTap: () async {
//                                                   setState(() {
//                                                     saving = true;
//                                                   });
//
//                                                   if (_formKey.currentState
//                                                       .validate()) {
//                                                     updateInvoice(widget.invoice.companyPan);
//                                                   }
//
//                                                   setState(() {
//                                                     saving = false;
//                                                   });
//
//                                                 },
//                                                 child: Container(
//                                                   width: 230,
//                                                   height: 59,
//                                                   decoration: const BoxDecoration(
//                                                     borderRadius: BorderRadius.only(
//                                                       topLeft: Radius.circular(15),
//                                                       topRight: Radius.circular(15),
//                                                       bottomLeft:
//                                                       Radius.circular(15),
//                                                       bottomRight:
//                                                       Radius.circular(15),
//                                                     ),
//                                                     color: Color.fromRGBO(
//                                                         0, 152, 219, 1),
//                                                   ),
//                                                   child: saving
//                                                       ? const Center(
//                                                     child: Padding(
//                                                       padding:
//                                                       EdgeInsets.all(8.0),
//                                                       child:
//                                                       CircularProgressIndicator(
//                                                         color: Color.fromRGBO(
//                                                             242, 242, 242, 1),
//                                                       ),
//                                                     ),
//                                                   )
//                                                       : Center(
//                                                     child: Text(
//                                                       'Save',
//                                                       textAlign:
//                                                       TextAlign.center,
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             242, 242, 242, 1),
//                                                         fontSize: 24,
//                                                         letterSpacing:
//                                                         0 /*percentages not used in flutter. defaulting to zero*/,
//                                                         fontWeight:
//                                                         FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(height: 16),
//                                               InkWell(
//                                                 onTap: () async {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Container(
//                                                   width: 230,
//                                                   height: 59,
//                                                   decoration: const BoxDecoration(
//                                                     borderRadius: BorderRadius.only(
//                                                       topLeft: Radius.circular(15),
//                                                       topRight: Radius.circular(15),
//                                                       bottomLeft:
//                                                       Radius.circular(15),
//                                                       bottomRight:
//                                                       Radius.circular(15),
//                                                     ),
//                                                     color: Colors.red,
//                                                   ),
//                                                   child: saving
//                                                       ? const Center(
//                                                     child: Padding(
//                                                       padding:
//                                                       EdgeInsets.all(8.0),
//                                                       child:
//                                                       CircularProgressIndicator(
//                                                         color: Color.fromRGBO(
//                                                             242, 242, 242, 1),
//                                                       ),
//                                                     ),
//                                                   )
//                                                       : Center(
//                                                     child: Text(
//                                                       'Cancel',
//                                                       textAlign:
//                                                       TextAlign.center,
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             242, 242, 242, 1),
//                                                         fontSize: 24,
//                                                         letterSpacing:
//                                                         0 /*percentages not used in flutter. defaulting to zero*/,
//                                                         fontWeight:
//                                                         FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//
//                                         ],
//                                       )),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else if (!snapshot.hasData) {
//                           return Center(child: Text("No history found."));
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       }),
//                 ],
//               ),
//             ),
//           ):Container(),
//         ],
//       ),
//     );
//   }
//
//   Widget mobileFormSteper() {
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         height: 60,
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(255, 255, 255, 1),
//         ),
//         child: Center(
//           child: Stack(children: <Widget>[
//             Positioned(
//                 top: 14,
//                 left: 104,
//                 child: Container(
//                     width: 80,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(130, 130, 130, 1),
//                     ))),
//             Positioned(
//                 top: 0,
//                 left: 67,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(50),
//                       topRight: Radius.circular(50),
//                       bottomLeft: Radius.circular(50),
//                       bottomRight: Radius.circular(50),
//                     ),
//                     color: Color.fromRGBO(245, 251, 255, 1),
//                     border: Border.all(
//                       color: Color.fromRGBO(0, 152, 219, 1),
//                       width: 2,
//                     ),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Text(
//                         '1',
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: Color.fromRGBO(0, 152, 219, 1),
//                             fontFamily: 'Poppins',
//                             fontSize: 16,
//                             letterSpacing:
//                             0 /*percentages not used in flutter. defaulting to zero*/,
//                             fontWeight: FontWeight.normal,
//                             height: 1),
//                       ),
//                     ],
//                   ),
//                 )),
//             Positioned(
//                 top: 0,
//                 left: 184,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(50),
//                       topRight: Radius.circular(50),
//                       bottomLeft: Radius.circular(50),
//                       bottomRight: Radius.circular(50),
//                     ),
//                     color: Color.fromRGBO(245, 251, 255, 1),
//                     border: Border.all(
//                       color: Color.fromRGBO(130, 130, 130, 1),
//                       width: 2,
//                     ),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Text(
//                         '2',
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: Color.fromRGBO(130, 130, 130, 1),
//                             fontFamily: 'Poppins',
//                             fontSize: 16,
//                             letterSpacing:
//                             0 /*percentages not used in flutter. defaulting to zero*/,
//                             fontWeight: FontWeight.normal,
//                             height: 1),
//                       ),
//                     ],
//                   ),
//                 )),
//           ]),
//         ));
//   }
// }
//
// class SplitInvoiceWarning extends StatelessWidget {
//   String invNo;
//   Function nav;
//   SplitInvoiceWarning({Key key, @required this.invNo, @required this.nav})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 584,
//       height: 579,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20), color: HexColor('#F5FBFF')),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/icons/warning.png',
//             width: 80,
//             height: 80,
//           ),
//           Text(
//             'Invoice Splitting',
//             style:
//             GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
//           ),
//           Text(
//             'Please note that your invoice will be split into smaller invoices. This will allow for faster trading of your invoice.\n\n This does not affect the invoice value. A breakdown of the split can be seen on the next page.',
//             style:
//             GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
//             textAlign: TextAlign.center,
//           ),
//           InkWell(
//             onTap: () {
//               // nav;
//               // Beamer.of(context).beamToNamed('/confirmInvoice');
//               Navigator.pop(context);
//             },
//             child: Container(
//               height: 60,
//               width: 342,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: HexColor('#0098DB')),
//               child: Center(
//                 child: Text(
//                   'Continue',
//                   style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/vendor-new/pages/add_invoice/confirm_invoice.dart';
import 'package:capsa/vendor-new/pages/confirm_invoice_page.dart';

import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../anchor/provider/anchor_action_providers.dart';
import '../../common/constants.dart';
import '../../functions/call_api.dart';
import '../data/anchor_invoice_data.dart';

class EditAnchorInvoiceAdmin extends StatefulWidget {
  AnchorInvoiceData invoice;
  EditAnchorInvoiceAdmin({ this.invoice,
    Key key,
  }) : super(key: key);

  @override
  State<EditAnchorInvoiceAdmin> createState() => _EditAnchorInvoiceAdminState();
}

class _EditAnchorInvoiceAdminState extends State<EditAnchorInvoiceAdmin> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');
  final dueDateCont = TextEditingController();
  final dateCont = TextEditingController();
  final extendedDueDateCont = TextEditingController();
  final fileCont = TextEditingController(text: '');
  dynamic pfeePercent;
  DateTime _selectedDate;
  DateTime _selectedDueDate;
  DateTime _extentedDueDate;

  String selectedVendor = '';
  String selectedVendorPan = '';
  var _cuGst;
  bool showExtendedDate = false;

  bool saving = false;

  final rateController2 = TextEditingController(text: '');

  dynamic companyDetails = null;

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  void updateInvoice(String panNumber) async{

    print('update field');

    var _body = {};
    // _body['company_pan'] = panNumber;
    // // _body['cu_gst'] = widget.invoice.cu_gst;
    // // _body['customer_gst'] = widget.invoice.cu_gst;
    // _body['previous_invoice_number'] = invoiceNoController.text;
    // _body['invoice_number'] = invoiceNoController.text;
    // _body['invoice_due_date'] = dueDateCont.text;
    // _body['description'] = detailsController.text;
    // // _body['invoice_quantity'] = widget.invoice.invoiceQuantity;
    // _body['invoice_value'] = invoiceAmtController.text;
    // _body['payment_terms'] = tenureController.text;
    // _body['rate'] = rateController2.text;
    // _body['buyNowPrice'] = buyAmtController.text;
    // _body['invoice_date'] = dateCont.text;
    // _body['ext_due_date'] = extDateCont.text;

    capsaPrint('pass 1');

    _body = {
      'invoice_number' : invoiceNoController.text,
      'invoice_number_old' : widget.invoice.invNo,
      'tenure' : _selectedDueDate.difference(_selectedDate).inDays.toString(),
      'company_pan': selectedVendorPan,
      'po_num' : poController.text,
      'invoice_date' : dateCont.text,
      'invoice_due_date' : dueDateCont.text,
      'invoice_value' : grossController.text,
      'buy_now' : (num.parse(grossController.text) - num.parse(rateAmountController.text)).toString(),
      'rate' : rateController2.text,
      'details': detailsController.text,
      'actualValue': invoiceAmtController.text,
    };

    capsaPrint('pass 2');

    String _url = apiUrl + '/dashboard/a/';
    dynamic _uri = _url + 'invoiceEditAnchor';
    //_uri = Uri.parse(_uri);

    //var request = http.MultipartRequest('POST', Uri.parse(_uri));

    print('\n\nBody : $_body \n$_uri');


    _uri = Uri.parse(_uri);
    var response = await http.post(_uri, headers: <String, String>{'Authorization': 'Basic ' + box.get('token', defaultValue: '0')}, body: _body);
    var data = jsonDecode(response.body);
    capsaPrint('Update Invoice e: ${response.body}');
    if(data['res'] == 'success'){
      showToast('Invoice Updated Successfully', context);
      Navigator.pop(context);
    }else{
      showToast(data, context, type: 'error');
    }

  }

  Future<Object> getCompanyName() async {
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
    _body['anchorPAN'] = widget.invoice.anchorPan;
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

  Future<dynamic> getCompanyNames(BuildContext context) async {
    if (companyDetails == null) {
      dynamic data =
      await getCompanyName();
      companyDetails = data;
      setState(() {

      });
    }

    return companyDetails;
  }

  int navigate() {
    Beamer.of(context).beamToNamed('/confirmInvoice');
    return 1;
  }

  void resetAnchor() {
    Future.delayed(const Duration(milliseconds: 500), () {
      anchor = null;
      anchorController.text = '';
      _cuGst = '';

      setState(() {
        showExtendedDate = true;
      });
      setState(() {
        showExtendedDate = false;
      });
    });
  }

  var term = ["Select One"];

  _selectDueDate(BuildContext context) async {
    // capsaPrint("_selectDueDate");

    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate:
        _selectedDueDate != null ? _selectedDueDate : DateTime.now(),
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
      _selectedDueDate = newSelectedDate;

      dueDateCont
        ..text = DateFormat.yMMMd().format(_selectedDueDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dueDateCont.text.length, affinity: TextAffinity.upstream));

      if (showExtendedDate == true) {
        _extentedDueDate =
            newSelectedDate.add(Duration(days: grade == 'C' ? 30 : 45));
        extendedDueDateCont.text = DateFormat.yMMMd().format(_extentedDueDate);
      }

      //calculateRate();
    }
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
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
      _selectedDate = newSelectedDate;
      dateCont
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateCont.text.length, affinity: TextAffinity.upstream));
      //calculateRate();
    }
  }

  final anchorController = TextEditingController(text: '');
  final vendorController = TextEditingController(text: '');

  final invoiceNoController = TextEditingController(text: '');
  final poController = TextEditingController(text: '');
  final tenureController = TextEditingController(text: '');
  final invoiceAmtController = TextEditingController(text: '');
  final buyAmtController = TextEditingController(text: '');
  final detailsController = TextEditingController(text: '');
  final currencyController = TextEditingController(text: '');
  final amtToPayController = TextEditingController(text: '');
  final grossController = TextEditingController(text: '');
  final pfeeController = TextEditingController(text: '');
  final rateAmountController = TextEditingController(text: '');
  var anchor;
  var vendor;
  dynamic grade;

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

  Widget getCurrencyIcon(String currency) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        currency == 'NGN'
            ? '₦'
            : currency == 'USD'
            ? '\$'
            : currency == 'GBP'
            ? '£'
            : '€',
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // final invoiceProvider =
    // Provider.of<InvoiceProvider>(context, listen: false);

    //capsaPrint("\n\ndescription ${widget.invoice.description}");
    var userData = Map<String, dynamic>.from(box.get('userData'));
    capsaPrint('Rate : ${widget.invoice.rate} ${widget.invoice.invDate} ${widget.invoice.invDueDate}');

    if (true) {
      invoiceNoController.text = widget.invoice.invNo;
      // poController.text = widget.invoice.poNo;
      tenureController.text = widget.invoice.tenure;
      invoiceAmtController.text = widget.invoice.actualValue ?? '0';
      buyAmtController.text = widget.invoice.invVal;
      rateController2.text = widget.invoice.rate;
      capsaPrint('Rate 2 : ${rateController2.text}');
      //detailsController.text = widget.invoice.details;
      //anchor = invoiceFormData["anchor"];
      anchorController.text = userData['userName'];
      detailsController.text = '';
      poController.text = widget.invoice.poNumber;
      dateCont.text = DateFormat('yyyy-MM-dd')
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.invoice.invDate))
          .toString();
      _selectedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.invoice.invDate);
      dueDateCont.text = DateFormat('yyyy-MM-dd')
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.invoice.invDueDate))
          .toString();
      _selectedDueDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.invoice.invDueDate);
      //tenureDaysDiff = num.parse(invoiceFormData["tenureDaysDiff"]);
      //rateController2.text = widget.invoice.askRate;
      // extDateCont.text = DateFormat('yyyy-MM-dd')
      //     .format(DateFormat("dd MMM, yyyy")
      //     .parse(widget.invoice.dueDate))
      //     .toString();
      //fileCont.text = invoiceFormData["fileCont"];
      //_selectedDate = invoiceFormData["_selectedDate"];
      // _selectedDueDate = DateFormat("dd MMM, yyyy")
      //     .parse(widget.invoice.dueDate);
      // _selectedExtDueDate = DateFormat("dd MMM, yyyy")
      //     .parse(widget.invoice.dueDate);
      tenureDaysDiff = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.invoice.invDueDate).difference(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(widget.invoice.invDate)).inDays;
      //amtToPayController.text = (((num.parse(rateController2.text)/100) * num.parse(invoiceAmtController.text)) + ((num.parse(pfeePercent)/100) * num.parse(invoiceAmtController.text))).toString();
      //pfeeController.text = ((num.parse(pfeePercent)/100) * num.parse(invoiceAmtController.text)).toString();
      // grossController.text = (num.parse(invoiceAmtController.text) + num.parse(amtToPayController.text)).toString();
      //file = invoiceFormData["file"];
      //_cuGst = invoiceFormData["cuGst"];

      //buyAmtController.text = invoiceAmtController.text;


      //calculateRate();
    }

    //invoiceProvider.splitInvoice('DH001', '50000000');
  }

  @override
  Widget build(BuildContext context) {
    // final invoiceProvider =
    // Provider.of<AnchorInvoiceProvider>(context, listen: false);

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
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!Responsive.isMobile(context))
                    SizedBox(
                      height: 22,
                    ),
                  TopBarWidget("Edit Invoice", ""),
                  SizedBox(
                    height: (!Responsive.isMobile(context)) ? 8 : 15,
                  ),
                  if (Responsive.isMobile(context)) mobileFormSteper(),
                  FutureBuilder<Object>(
                      future: getCompanyNames(context),
                      builder: (context, snapshot) {
                        if (companyDetails == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        int i = 0;
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'There was an error :(\n' + snapshot.error.toString(),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          );
                        }
                        else if (snapshot.hasData) {
                          dynamic temp = snapshot.data;
                          dynamic _data = temp[0];
                          dynamic _vendorData = temp[1];

                          //_data['data'] = ['hello'];

                          capsaPrint('\n\ncompany data  $_data');

                          capsaPrint('\n\nvendor data  $_vendorData');



                          //pfeeController.text = _data['data'][0]['capsa_rate'].toString();
                        //  pfeePercent = _data['data'][0]['capsa_rate'].toString();
                          capsaPrint('1 $pfeePercent');



                          capsaPrint('${amtToPayController.text} ${grossController.text} ${pfeeController.text} ${pfeePercent}');


                          var _items = _data['data'];
                          Map<String, bool> _isBlackListed = {};
                          Map<String, String> anchorGrade = {};

                          List<String> vendorsList = [];
                          Map<String, String> vendorPan = {};


                          var anchorNameList = [];

                          var userData = Map<String, dynamic>.from(box.get('userData'));

                          capsaPrint('Anchor userdata $userData');

                          anchor = widget.invoice.anchorName;

                          anchorController.text = anchor;



                          if (_data['res'] == 'success') {
                            anchorNameList = _items;

                            capsaPrint(anchorNameList);

                            anchorNameList
                                .forEach((element1) {
                              if (element1['name'] == anchor) {
                                capsaPrint('anchor : element: $element1');
                                // cacAddress = element1['name_address'];
                                anchorController.text = element1['name'];
                                anchor = element1[
                                'name_address'];
                                //pfeeController.text = element1['capsa_rate'].toString();
                                pfeePercent = element1['capsa_rate'] == null ? '0' : element1['capsa_rate'].toString();
                                num rate = rateController2.text == '' ? 0 : ((num.parse(rateController2.text)/100) * num.parse(invoiceAmtController.text));
                                num pfee = ((num.parse(pfeePercent)/100) * num.parse(invoiceAmtController.text));
                                rateAmountController.text = rate.toStringAsFixed(2);

                                amtToPayController.text = (rate + pfee).toString();
                                capsaPrint('2');
                                pfeeController.text = pfee.toStringAsFixed(2);
                                capsaPrint('3');
                                grossController.text = (num.parse(invoiceAmtController.text) + rate + pfee).toStringAsFixed(2);
                                grade =
                                anchorGrade[anchor];
                                capsaPrint(
                                    'Grade initiated :  $grade');
                                _cuGst =
                                element1['cu_gst'];
                                // capsaPrint(cacAddress);

                              }
                            });

                            term = [];
                            _items.forEach((element) {
                              term.add(element['name'].toString());
                              _isBlackListed[element['name'].toString()] =
                              element['isBlacklisted'] != null
                                  ? element['isBlacklisted'] == '1'
                                  ? true
                                  : false
                                  : false;
                              anchorGrade[element['name'].toString()] =
                                  element['grade'] ?? '';
                            });

                            //capsaPrint('\n\nendor name : ${widget.invoice.vendor}');

                            dynamic responseList = _vendorData['vendorList'];
                            responseList.forEach((element) {
                              vendorsList.add(element['NAME']);
                              vendorPan[element['NAME']] = element['PAN_NO'];
                              //capsaPrint('Vendor name : ${widget.invoice.companyPan} ${element['PAN_NO']}');
                              capsaPrint('\n\nVendor name : ${widget.invoice.companyPan} ${element['PAN_NO']}');
                              if(element['PAN_NO'].toString() == widget.invoice.companyPan.toString()){
                                // capsaPrint('\n\nVendor name : ${widget.invoice.companyPan} ${element['PAN_NO']}');
                                selectedVendor = element['NAME'];
                                selectedVendorPan = element['PAN_NO'];
                                vendorController.text = widget.invoice.vendorName;
                                vendor = element['NAME'];
                              }
                            });

                          } else {
                            return Center(
                              child: Text(
                                'There was an error :(\n' + _data['messg'].toString(),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            );
                          }

                          // ProfileProvider _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                          final GlobalKey<FormFieldState> _key =
                          GlobalKey<FormFieldState>();

                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Form(
                              // onChanged: ,
                              key: _formKey,
                              child: OrientationSwitcher(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // orientation: Responsive.isMobile(context) ? "Column" : "Row" ,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          OrientationSwitcher(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: UserTextFormField(
                                                  label: "Anchor Name",
                                                  hintText: "Select Anchor",
                                                  controller: anchorController,
                                                  readOnly: true,
                                                  // textFormField:
                                                  // DropdownButtonFormField(
                                                  //   isExpanded: true,
                                                  //   validator: (v) {
                                                  //     if (anchorController.text ==
                                                  //         '') {
                                                  //       return "Can't be empty";
                                                  //     }
                                                  //     return null;
                                                  //   },
                                                  //   items:
                                                  //   term.map((String category) {
                                                  //     return DropdownMenuItem(
                                                  //       //key: _key,
                                                  //       value: category,
                                                  //       child:
                                                  //       Text(category.toString()),
                                                  //     );
                                                  //   }).toList(),
                                                  //   onChanged: (v) {
                                                  //     // capsaPrint(anchorNameList);
                                                  //     if (_isBlackListed[v]) {
                                                  //       showToast(
                                                  //           'Functionalities for this anchor is ChangeRateContentorarily suspended',
                                                  //           context,
                                                  //           type: 'warning');
                                                  //       _formKey.currentState.reset();
                                                  //     } else {
                                                  //       anchor = v;
                                                  //       anchorNameList
                                                  //           .forEach((element1) {
                                                  //         if (element1['name'] == v) {
                                                  //           // cacAddress = element1['name_address'];
                                                  //           anchorController.text =
                                                  //           element1[
                                                  //           'name_address'];
                                                  //           grade =
                                                  //           anchorGrade[anchor];
                                                  //           capsaPrint(
                                                  //               'Grade initiated : ${anchor} $grade');
                                                  //           _cuGst =
                                                  //           element1['cu_gst'];
                                                  //           // capsaPrint(cacAddress);
                                                  //
                                                  //         }
                                                  //       });
                                                  //     }
                                                  //   },
                                                  //   value: anchor,
                                                  //   decoration: InputDecoration(
                                                  //     border: InputBorder.none,
                                                  //     filled: true,
                                                  //     fillColor: Colors.white,
                                                  //     hintText: "Select Anchor",
                                                  //     hintStyle: TextStyle(
                                                  //         color: Color.fromRGBO(
                                                  //             130, 130, 130, 1),
                                                  //         fontSize: 14,
                                                  //         letterSpacing:
                                                  //         0 /*percentages not used in flutter. defaulting to zero*/,
                                                  //         fontWeight:
                                                  //         FontWeight.normal,
                                                  //         height: 1),
                                                  //     contentPadding:
                                                  //     const EdgeInsets.only(
                                                  //         left: 8.0,
                                                  //         bottom: 12.0,
                                                  //         top: 12.0),
                                                  //     focusedBorder:
                                                  //     OutlineInputBorder(
                                                  //       borderSide: BorderSide(
                                                  //           color: Colors.white),
                                                  //       borderRadius:
                                                  //       BorderRadius.circular(
                                                  //           15.7),
                                                  //     ),
                                                  //     enabledBorder:
                                                  //     UnderlineInputBorder(
                                                  //       borderSide: BorderSide(
                                                  //           color: Colors.white),
                                                  //       borderRadius:
                                                  //       BorderRadius.circular(
                                                  //           15.7),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ),
                                              ),

                                              Flexible(
                                                child: UserTextFormField(
                                                  label: "Vendor Name",
                                                  hintText: "Select Vendor",
                                                  textFormField:
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    validator: (v) {
                                                      if (vendorController.text ==
                                                          '') {
                                                        return "Can't be empty";
                                                      }
                                                      return null;
                                                    },
                                                    items:
                                                    vendorsList.map((String category) {
                                                      return DropdownMenuItem(
                                                        //key: _key,
                                                        value: category,
                                                        child:
                                                        Text(category.toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (v) {
                                                      selectedVendor = v;
                                                      selectedVendorPan = vendorPan[v];
                                                      vendorController.text = v;
                                                    },
                                                    value: vendor,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText: "Select Vendor",
                                                      hintStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              130, 130, 130, 1),
                                                          fontSize: 14,
                                                          letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          height: 1),
                                                      contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          bottom: 12.0,
                                                          top: 12.0),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.white),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            15.7),
                                                      ),
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.white),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            15.7),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Flexible(
                                              //   child: UserTextFormField(
                                              //     label: "CAC/Address",
                                              //     hintText: "",
                                              //     controller: anchorController,
                                              //     readOnly: true,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          OrientationSwitcher(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: UserTextFormField(
                                                  label: "Invoice Number",
                                                  hintText: "Invoice Number",
                                                  controller: invoiceNoController,
                                                  onChanged: (v) {
                                                    String s = v;
                                                    if (v.contains('/') ||
                                                        v.contains(r'\')) {
                                                      showToast(
                                                          'Invoice Number Cannot Contain  /  or  '
                                                          r'\',
                                                          context,
                                                          type: 'warning');
                                                      s = s.replaceAll(r'\', '-');
                                                      s = s.replaceAll('/', '-');
                                                    }
                                                    invoiceNoController.text = s;
                                                    invoiceNoController.selection =
                                                        TextSelection.fromPosition(
                                                            TextPosition(
                                                                offset:
                                                                invoiceNoController
                                                                    .text
                                                                    .length));
                                                  },
                                                ),
                                              ),
                                              Flexible(
                                                child: UserTextFormField(
                                                  label: "PO Number",
                                                  controller: poController,
                                                  hintText: "Purchase order Number",
                                                ),
                                              ),
                                            ],
                                          ),
                                          OrientationSwitcher(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: UserTextFormField(
                                                  label: "Tenure",
                                                  hintText: "30 or 60 Days?",
                                                  controller: tenureController,
                                                ),
                                              ),
                                              Flexible(
                                                child: UserTextFormField(
                                                  label: "Invoice Amount",
                                                  hintText: "Enter invoice amount",
                                                  prefixIcon: getCurrencyIcon('NGN'),
                                                  note:
                                                  'Invoice amount should not include\nVAT fee',
                                                  // Image.asset(
                                                  //     "assets/images/currency.png"),
                                                  controller: invoiceAmtController,
                                                  onChanged: (v) {
                                                    capsaPrint('1 $pfeePercent ${rateController2.text} ${invoiceAmtController.text} ${pfeePercent}');
                                                    if(invoiceAmtController.text == ''){
                                                      pfeeController.text = '';
                                                      grossController.text = '';
                                                      amtToPayController.text = '';
                                                      rateAmountController.text = '';
                                                                                                          }else{
                                                      buyAmtController.text = invoiceAmtController.text;
                                                      capsaPrint('1 $pfeePercent');

                                                      num rate = rateController2.text == '' ? 0 : ((num.parse(rateController2.text)/100) * num.parse(invoiceAmtController.text));
                                                      num pfee = ((num.parse(pfeePercent)/100) * num.parse(invoiceAmtController.text));
                                                      rateAmountController.text = rate.toStringAsFixed(2);

                                                      amtToPayController.text = (rate + pfee).toStringAsFixed(2);
                                                      capsaPrint('2');
                                                      pfeeController.text = pfee.toStringAsFixed(2);
                                                      capsaPrint('3');
                                                      grossController.text = (num.parse(invoiceAmtController.text) + rate + pfee).toStringAsFixed(2);

                                                      capsaPrint('${amtToPayController.text} ${grossController.text} ${pfeeController.text} ${pfeePercent}');
                                                    }
                                                  },
                                                  // validator: (v) {
                                                  //   if (invoiceAmtController.text ==
                                                  //       '') {
                                                  //     return "Can't be empty";
                                                  //   }else if(num.parse(invoiceAmtController.text) < num.parse(pfeeController.text)){
                                                  //     showToast('Invoice Amount should be greater than Platform Fee', context, type: 'warning');
                                                  //     return "";
                                                  //   }
                                                  //   return null;
                                                  // },
                                                  keyboardType:
                                                  TextInputType.numberWithOptions(
                                                      decimal: true),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(
                                                        RegExp(r"[0-9.]")),
                                                    // TextInputFormatter.withFunction(
                                                    //         (oldValue, newValue) {
                                                    //       try {
                                                    //         final text = newValue.text;
                                                    //         if (text.isEmpty)
                                                    //           double.parse(text);
                                                    //         return newValue;
                                                    //       } catch (e) {}
                                                    //       return oldValue;
                                                    //     }),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          OrientationSwitcher(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [

                                              Flexible(
                                                child: UserTextFormField(
                                                  label: "Issue Date",
                                                  readOnly: true,
                                                  controller: dateCont,
                                                  suffixIcon:
                                                  Icon(Icons.date_range_outlined),
                                                  hintText: "Invoice Issue date",
                                                  onTap: () => _selectDate(context),
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ),


                                              Flexible(
                                                child:  UserTextFormField(
                                                    label: "Discount rate",
                                                    hintText: "Enter Percentage",
                                                    //info: "Absolute Value : ",
                                                    keyboardType:
                                                    TextInputType.numberWithOptions(
                                                        decimal: true),
                                                    //readOnly: true,
                                                    controller: rateController2,
                                                    suffixIcon: Image.asset(
                                                        "assets/images/%.png"),
                                                    onChanged: (v) {
                                                      // if(rateController2.text == ''){
                                                      //   buyAmtController.text = '';
                                                      // }
                                                      // else if(num.parse(rateController2.text)>100){
                                                      //   buyAmtController.text = '';
                                                      //   rateController2.text = '';
                                                      //   invoiceAmtController.text = '';
                                                      //   showToast('Rate cannot be more than 100% !', context, type: 'warning');
                                                      // }
                                                      // else if(num.parse(rateController2.text)>0){
                                                      //   buyAmtController.text = invoiceAmtController.text;
                                                      //   invoiceAmtController.text = (num.parse(invoiceAmtController.text) + (((num.parse(rateController2.text))/100) * num.parse(invoiceAmtController.text))).toString();
                                                      // }else{
                                                      //   buyAmtController.text = '';
                                                      //   invoiceAmtController.text = '';
                                                      // }

                                                      buyAmtController.text = invoiceAmtController.text;
                                                      capsaPrint('1 $pfeePercent');

                                                      num rate = rateController2.text == '' ? 0 : ((num.parse(rateController2.text)/100) * num.parse(invoiceAmtController.text));
                                                      num pfee = ((num.parse(pfeePercent)/100) * num.parse(invoiceAmtController.text));
                                                      rateAmountController.text = rate.toStringAsFixed(2);

                                                      amtToPayController.text = (rate + pfee).toStringAsFixed(2);
                                                      capsaPrint('2');
                                                      pfeeController.text = pfee.toStringAsFixed(2);
                                                      capsaPrint('3');
                                                      grossController.text = (num.parse(invoiceAmtController.text) + rate + pfee).toStringAsFixed(2);

                                                      capsaPrint('${amtToPayController.text} ${grossController.text} ${pfeeController.text} ${pfeePercent}');


                                                    }
                                                ),
                                              ),
                                            ],
                                          ),

                                          OrientationSwitcher(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: UserTextFormField(
                                                  label: "Due Date",
                                                  suffixIcon:
                                                  Icon(Icons.date_range_outlined),
                                                  readOnly: true,
                                                  controller: dueDateCont,
                                                  hintText: "Invoice Due Date",
                                                  onTap: () =>
                                                      _selectDueDate(context),
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ),

                                              Flexible(
                                                child:  UserTextFormField(
                                                  label: "Discount Amount",
                                                  hintText: "",
                                                  //info: "Absolute Value : ",
                                                  readOnly : true,
                                                  keyboardType:
                                                  TextInputType.numberWithOptions(
                                                      decimal: true),
                                                  //readOnly: true,
                                                  controller: rateAmountController,
                                                  prefixIcon: getCurrencyIcon('NGN'),
                                                  // onChanged: (v) {
                                                  //   // if(rateController2.text == ''){
                                                  //   //   buyAmtController.text = '';
                                                  //   // }
                                                  //   // else if(num.parse(rateController2.text)>100){
                                                  //   //   buyAmtController.text = '';
                                                  //   //   rateController2.text = '';
                                                  //   //   invoiceAmtController.text = '';
                                                  //   //   showToast('Rate cannot be more than 100% !', context, type: 'warning');
                                                  //   // }
                                                  //   // else if(num.parse(rateController2.text)>0){
                                                  //   //   buyAmtController.text = invoiceAmtController.text;
                                                  //   //   invoiceAmtController.text = (num.parse(invoiceAmtController.text) + (((num.parse(rateController2.text))/100) * num.parse(invoiceAmtController.text))).toString();
                                                  //   // }else{
                                                  //   //   buyAmtController.text = '';
                                                  //   //   invoiceAmtController.text = '';
                                                  //   // }
                                                  //
                                                  //   buyAmtController.text = invoiceAmtController.text;
                                                  //   capsaPrint('1 $pfeePercent');
                                                  //
                                                  //   num rate = rateController2.text == '' ? 0 : ((num.parse(rateController2.text)/100) * num.parse(invoiceAmtController.text));
                                                  //   num pfee = ((num.parse(pfeePercent)/100) * num.parse(invoiceAmtController.text));
                                                  //
                                                  //   amtToPayController.text = (rate + pfee).toString();
                                                  //   capsaPrint('2');
                                                  //   pfeeController.text = pfee.toString();
                                                  //   capsaPrint('3');
                                                  //   grossController.text = (num.parse(invoiceAmtController.text) + rate + pfee).toString();
                                                  //
                                                  //   capsaPrint('${amtToPayController.text} ${grossController.text} ${pfeeController.text} ${pfeePercent}');
                                                  //
                                                  //
                                                  // }
                                                ),
                                              ),
                                            ],
                                          ),

                                          OrientationSwitcher(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [

                                              Flexible(
                                                child: UserTextFormField(
                                                  // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                  label:
                                                  "Details (e.g items or quantity)",
                                                  hintText: "48 packs of goods",
                                                  controller: detailsController,
                                                  minLines: 1,
                                                  maxLines: 5,
                                                ),
                                              ),

                                              Flexible(
                                                child: UserTextFormField(
                                                  // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                  label:
                                                  "Platform Fee",
                                                  prefixIcon: getCurrencyIcon('NGN'),
                                                  hintText: "0",
                                                  controller: pfeeController,
                                                  readOnly: true,
                                                  // minLines: 1,
                                                  // maxLines: 5,
                                                ),
                                              ),

                                            ],
                                          ),

                                          OrientationSwitcher(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [

                                              Flexible(
                                                child: Visibility(
                                                  visible : false,
                                                  child: UserTextFormField(
                                                    // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                    label:
                                                    "Amount to pay",
                                                    prefixIcon: getCurrencyIcon('NGN'),
                                                    hintText: "0",
                                                    controller: amtToPayController,
                                                    readOnly: true,
                                                    // minLines: 1,
                                                    // maxLines: 5,
                                                  ),
                                                ),
                                              ),


                                              Flexible(
                                                child: UserTextFormField(
                                                  // padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                  label:
                                                  "Total Amount",
                                                  prefixIcon: getCurrencyIcon('NGN'),
                                                  hintText: "0",
                                                  controller: grossController,
                                                  readOnly: true,
                                                  // minLines: 1,
                                                  // maxLines: 5,
                                                ),
                                              ),

                                            ],
                                          ),

                                          SizedBox(height: 16),
                                          InkWell(

                                            onTap: () async {
                                              setState(() {
                                                saving = true;
                                              });

                                              capsaPrint('pressed save');

                                              if (_formKey.currentState
                                                  .validate()) {
                                                capsaPrint('pressed save 2');
                                                updateInvoice(widget.invoice.companyPan);
                                              }

                                              setState(() {
                                                saving = false;
                                              });

                                            },

                                            child: Container(
                                              width: 230,
                                              height: 59,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft: Radius.circular(15),
                                                  bottomRight: Radius.circular(15),
                                                ),
                                                color: Color.fromRGBO(0, 152, 219, 1),
                                              ),
                                              child: saving
                                                  ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                  CircularProgressIndicator(
                                                    color: Color.fromRGBO(
                                                        242, 242, 242, 1),
                                                  ),
                                                ),
                                              )
                                                  : Center(
                                                child: Text(
                                                  'Save',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 242, 1),
                                                    fontSize: 24,
                                                    letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),

                                              // Stack(children: <Widget>[
                                              //   Positioned(
                                              //       top: 0,
                                              //       left: 0,
                                              //       child: Container(
                                              //         decoration: BoxDecoration(
                                              //           borderRadius:
                                              //               BorderRadius.only(
                                              //             topLeft:
                                              //                 Radius.circular(15),
                                              //             topRight:
                                              //                 Radius.circular(15),
                                              //             bottomLeft:
                                              //                 Radius.circular(15),
                                              //             bottomRight:
                                              //                 Radius.circular(15),
                                              //           ),
                                              //           color: Color.fromRGBO(
                                              //               0, 152, 219, 1),
                                              //         ),
                                              //         padding: EdgeInsets.symmetric(
                                              //             horizontal: 16,
                                              //             vertical: 16),
                                              //         child: saving?Center(child: Padding(
                                              //           padding: const EdgeInsets.all(8.0),
                                              //           child: CircularProgressIndicator(),
                                              //         ),):Row(
                                              //           mainAxisSize:
                                              //               MainAxisSize.min,
                                              //           children: <Widget>[
                                              //             Text(
                                              //               'Preview',
                                              //               textAlign:
                                              //                   TextAlign.center,
                                              //               style: TextStyle(
                                              //                   color:
                                              //                       Color.fromRGBO(
                                              //                           242,
                                              //                           242,
                                              //                           242,
                                              //                           1),
                                              //                   fontSize: 18,
                                              //                   letterSpacing:
                                              //                       0 /*percentages not used in flutter. defaulting to zero*/,
                                              //                   fontWeight:
                                              //                       FontWeight
                                              //                           .normal,
                                              //                   height: 1),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       )),
                                              // ])),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Visibility(
                                        visible: false,
                                        child: Container(
                                          // width: MediaQuery.of(context).size.width * 0.6,
                                          height: MediaQuery.of(context).size.height,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(50),
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                            color: Color.fromRGBO(0, 152, 219, 1),
                                          ),
                                          child: Container(
                                            child: file != null
                                                ? file.extension == 'pdf'
                                                ? SfPdfViewer.memory(file.bytes)
                                                : Image.memory(file.bytes)
                                                : Center(
                                                child: Text(
                                                  'Uploaded Invoice will appear here',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                      // fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight: FontWeight.normal,
                                                      height: 1),
                                                )),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }
                        else if (!snapshot.hasData) {
                          return Center(child: Text("No history found."));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileFormSteper() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          //color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Center(
          child: Stack(children: <Widget>[
            Positioned(
                top: 14,
                left: 104,
                child: Container(
                    width: 180,
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
                left: 264,
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
