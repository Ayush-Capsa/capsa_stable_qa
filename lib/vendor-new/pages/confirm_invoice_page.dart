import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:intl/intl.dart';

import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/input_preview.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ConfirmInvoice extends StatefulWidget {
  final invVoiceNumber;


  const ConfirmInvoice({this.invVoiceNumber, Key key}) : super(key: key);

  @override
  State<ConfirmInvoice> createState() => _ConfirmInvoiceState();
}

class _ConfirmInvoiceState extends State<ConfirmInvoice> {
  bool processing = false;
  bool complete = false;
  bool isEditShow = false;
  bool saving = false;

  Future<void> submitInvoiceData(dynamic invoiceFormData, BuildContext context, VendorActionProvider _actionProvider, InvoiceProvider invoiceProvider,
      {present: false, onlyPresent: false}) async {
    final Box box = Hive.box('capsaBox');

    setState(() {
      processing = true;
      complete = false;
    });

    var userData = box.get('userData');

    final InvoiceModel invoice = InvoiceModel(
      cuGst: invoiceFormData['cuGst'],
      anchor: invoiceFormData['anchor'],
      cacAddress: invoiceFormData['anchorAddress'],
      invNo: invoiceFormData['invoiceNo'],
      poNo: invoiceFormData['poNumber'],
      date: invoiceFormData['dateCont'],
      invDate: invoiceFormData['_selectedDate'].toString(),
      invDueDate: invoiceFormData['_selectedDueDate'].toString(),
      terms: invoiceFormData['tenure'],
      invAmt: invoiceFormData['invAmt'],
      // invDueDate:
      //     dueDateCont.text,
      invAmount: invoiceFormData['invAmt'],
      details: invoiceFormData['details'],
      invSell: (invoiceFormData['butAmt'] == '') ? '0' : invoiceFormData['butAmt'],
      buyNowPrice: (invoiceFormData['butAmt'] == '') ? '0' : invoiceFormData['butAmt'],
      rate: invoiceFormData['rate'],
      tenureDaysDiff: invoiceFormData['tenureDaysDiff'],

      fileType: !onlyPresent ? invoiceFormData['file'].extension : '',
      img: !onlyPresent ? invoiceFormData['file'].extension : null,
      bvnNo: userData['panNumber'],
    );

    if (!onlyPresent) {
      Map<dynamic, dynamic> response = await invoiceProvider.queryInvoiceData(widget.invVoiceNumber);
      final _responseData = await _actionProvider.uploadInvoice(invoice, invoiceFormData['file'],);

      if (_responseData['res'] == "failed") {
        setState(() {
          processing = false;
          complete = false;
        });

        showPopupActionInfo(
          context,
          heading: "Unable to upload invoice",
          info: _responseData['messg'],
          buttonText: "Ok",
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );
        return;
      }

      DateTime invoiceDate = DateFormat("yyyy-MM-dd").parse(invoice.invDate);

      DateTime invoiceDueDate = new DateFormat("yyyy-MM-dd").parse(invoice.invDueDate);

      invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
      invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);
    }
    if (present) {
      var _body = {};
      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];
      _body['invNum'] = invoice.invNo;
      // _body['invNum'] = invoice.invNo;

      Map<String, dynamic> _data = await invoiceProvider.submitForApproval(_body);
      // Navigator.of(context,rootNavigator: true).pop();
      setState(() {
        complete = true;
      });
      if (_data['res'] == 'success') {

        // var invNum = _data['data']['invnum'];
        showPopupActionInfo(
          context,
          heading: "Congratulations! Your invoice \nhas been saved and presented. ",
          info: "When your Anchor approves the invoice, you will start receiving bids from Investors.",
          buttonText: "View Pending Invoices",
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            invoiceProvider.resetInvoiceFormData();
            Beamer.of(context).beamToNamed('/pending-invoices');
          },
        );
      } else {
        showPopupActionInfo(
          context,
          heading: "Unable to present invoice",
          info: _data['messg'],
          buttonText: "Ok",
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );
      }
    } else {
      showPopupActionInfo(
        context,
        heading: "Congratulations! Your invoice has been saved on Capsa",
        info: "You can always edit and present your invoice anytime. ",
        buttonText: "View Saved Invoice",
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
          invoiceProvider.resetInvoiceFormData();
          // Beamer.of(context).beamToNamed('/viewInvoice/' + invoiceFormData['invoiceNo']);
          Beamer.of(context).beamToNamed('/viewInvoice/' + Uri.encodeComponent(invoice.invNo));
        },
      );
      setState(() {
        complete = true;
      });
    }
  }

  Future _future = Future.delayed(Duration.zero);
  dynamic invoiceFormData = {};

  // String savedFileName;

  Widget statusShow(InvoiceModel invoices) {
    String _text = 'Pending';
    TextStyle textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#333333"));

    if (invoices.invStatus == '1') {
      _text = "Not Presented";
      textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#828282"));
    }
    if (invoices.invStatus == '2' && invoices.ilcStatus == '1') {
      _text = "Pending";
      textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#F2994A"));
    }
    if (invoices.discount_status == 'false' && invoices.payment_status == '0' && invoices.ilcStatus == '2') {
      _text = "Live Deals";
      textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#219653"));
    }
    if (invoices.invStatus == '4') {
      _text = "Rejected";
      textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#EB5757"));
    }
    if (invoices.discount_status == 'true') {
      _text = "Sold";
      textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#EB5757"));
    }
    return Text(
      _text,
      style: textStyle,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);

    if (widget.invVoiceNumber != null) {
      // complete = true;
      isEditShow = true;
      _future = invoiceProvider.queryInvoiceData(widget.invVoiceNumber);
      //print('Invoice Data $_future');
    } else if (!invoiceProvider.invoiceFormWorking) {
      Beamer.of(context).beamToNamed('/addInvoice');
    } else {
      // _future = justDataSet(invoiceProvider.invoiceFormData['invAmt']);
      invoiceFormData = invoiceProvider.invoiceFormData;
    }
  }

  Future justDataSet(data) {
    return data;
  }

  String savedFileName = "";

  bool isSaved = false;
  InvoiceModel invModel;

  @override
  Widget build(BuildContext context) {
    PlatformFile file;
    final invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);

    file = invoiceFormData['file'];
    final _actionProvider = Provider.of<VendorActionProvider>(context);
    // final _profileProvider = Provider.of<ProfileProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Responsive.isMobile(context) ? 10 : 22,
            ),
            TopBarWidget((widget.invVoiceNumber != null) ? "Invoice info" : "Confirm Invoice", ""),
            if (!Responsive.isMobile(context))
              SizedBox(
                height: 15,
              ),
            FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
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
                  } else if (widget.invVoiceNumber == null || snapshot.hasData) {
                    if (widget.invVoiceNumber != null) {
                      dynamic _data = snapshot.data;

                      if (_data['res'] == 'success') {
                        var _results = _data['data']['invoicelist'];

                        _results.forEach((element) {
                          DateTime invoiceDate = new DateFormat("yyyy-MM-dd").parse(element['invoice_date']);

                          DateTime invoiceDueDate = new DateFormat("yyyy-MM-dd").parse(element['invoice_due_date']);

                          savedFileName = element['invoice_file'];
                          processing = false;
                          complete = false;
                          isEditShow = false;
                          invModel = InvoiceModel(
                            cacAddress: element['customer_address'],
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
                            fileType: element['invoice_file'],
                            cuGst: element['customer_gst'],
                            poNo: element['invoice_line_items'],
                            details: element['description'],
                            discount_status: element['discount_status'].toString(),
                            invStatus: element['invStatus'].toString(),
                            payment_status: element['payment_status'].toString(),
                            ilcStatus: element['ilcStatus'].toString(),
                          );
                        });

                        isSaved = invModel.invStatus == '1' ? true : false;
                        complete = invModel.invStatus == '1' ? false : true;

                        invoiceFormData['cuGst'] = invModel.cuGst;
                        invoiceFormData['anchor'] = invModel.anchor;
                        invoiceFormData['anchorAddress'] = invModel.cacAddress;
                        invoiceFormData['invoiceNo'] = invModel.invNo;
                        invoiceFormData['poNumber'] = invModel.poNo;
                        invoiceFormData['dateCont'] = invModel.invDate;
                        invoiceFormData['dueDateCont'] = invModel.invDueDate;
                        // invoiceFormData['_selectedDate'] = invModel.invDate;
                        // invoiceFormData['_selectedDueDate'] = invModel.invDueDate;
                        invoiceFormData['tenure'] = invModel.terms;
                        invoiceFormData['invAmt'] = invModel.invAmt;
                        // invoiceFormData['invAmt'] = invModel.invAmount;
                        invoiceFormData['details'] = invModel.details;

                        invoiceFormData['butAmt'] = invModel.buyNowPrice;
                        invoiceFormData['rate'] = invModel.rate;
                        invoiceFormData['tenureDaysDiff'] = invModel.tenureDaysDiff;
                        // invoiceFormData['file'] = invModel.img;
                        // invoiceFormData['file'] = invModel.fileType;

                        // capsaPrint(invoiceFormData);
                      }
                    }

                    return OrientationSwitcher(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                // if (widget.invVoiceNumber != null) statusShow(invModel),

                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Anchor Name', invoiceFormData['anchor']),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('CAC/Address', invoiceFormData['anchorAddress']),
                                    ),
                                  ],
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Invoice No', invoiceFormData['invoiceNo']),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('PO Number', invoiceFormData['poNumber']),
                                    ),
                                  ],
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Issue Date', invoiceFormData['dateCont']),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Due Date', invoiceFormData['dueDateCont']),
                                    ),
                                  ],
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Tenure', invoiceFormData['tenure']),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Invoice Amount', formatCurrency(invoiceFormData['invAmt'], withIcon: true)),
                                    ),
                                  ],
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Sell Now Price', formatCurrency(invoiceFormData['butAmt'], withIcon: true)),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Discount rate', invoiceFormData['rate'] + ' %'),
                                    ),
                                  ],
                                ),
                                OrientationSwitcher(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InputPreview('Details (e.g items or quantity)', invoiceFormData['details']),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                if (!Responsive.isMobile(context))
                                  if (!complete)
                                    if (processing)
                                      Center(child: CircularProgressIndicator())
                                    else
                                      buttonsActions(context, _actionProvider, invoiceProvider),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 16,
                        ),
                        Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Container(
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
                                  child: (widget.invVoiceNumber == null)
                                      ? Container(
                                          child: file != null
                                              ? file.extension == 'pdf'
                                                  ? SfPdfViewer.memory(file.bytes)
                                                  : Image.memory(file.bytes)
                                              : Center(
                                                  child: Text(
                                                  'Uploaded Invoice will appear here',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(255, 255, 255, 1),
                                                      // fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight: FontWeight.normal,
                                                      height: 1),
                                                )),
                                        )
                                      : Container(
                                          child: FutureBuilder(
                                              future: callApi('dashboard/a/getInvFile', body: {'fName': savedFileName}),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState != ConnectionState.done) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                      'There was an error :(\n' + snapshot.error.toString(),
                                                      style: Theme.of(context).textTheme.bodyText2,
                                                    ),
                                                  );
                                                } else if (snapshot.hasData) {
                                                  dynamic _data = snapshot.data;
                                                  if (_data['res'] == 'success') {
                                                    var url = _data['data']['url'];
                                                    return SfPdfViewer.network(url);
                                                  }
                                                  return Center(child: CircularProgressIndicator());
                                                } else if (!snapshot.hasData) {
                                                  return Center(child: Text("No history found."));
                                                } else {
                                                  return Center(child: CircularProgressIndicator());
                                                }
                                              }),
                                        ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                if (Responsive.isMobile(context))
                                  if (!complete)
                                    if (processing)
                                      Center(child: CircularProgressIndicator())
                                    else
                                      buttonsActions(context, _actionProvider, invoiceProvider),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            )),
                      ],
                    );
                  } else if (!snapshot.hasData) {
                    return Center(child: Text("No data found."));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget buttonsActions(BuildContext context, _actionProvider, invoiceProvider) {
    return Row(
      children: [
        SizedBox(
          width: 12,
        ),
        if (!isSaved)
          InkWell(
            onTap: () async {
              await submitInvoiceData(invoiceFormData, context, _actionProvider, invoiceProvider, present: false);
            },
            child: Container(
              // width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: HexColor("#3AC0C9"),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Save Invoice',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(242, 242, 242, 1),
                        fontSize: 18,
                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(
          width: 5,
        ),

        saving ? CircularProgressIndicator() : InkWell(
          onTap: () async {
            setState(() {
              saving = true;
            });
            if ((!isSaved))
              await submitInvoiceData(invoiceFormData, context, _actionProvider, invoiceProvider, present: true);
            else
              await submitInvoiceData(invoiceFormData, context, _actionProvider, invoiceProvider, present: true, onlyPresent: true);
            setState(() {
              saving = false;
            });
          },
          child: Container(
            // width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: Color.fromRGBO(0, 152, 219, 1),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  (!isSaved) ? 'Save & Present' : 'Present',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 18,
                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 2,
        ),
      ],
    );
  }
}
