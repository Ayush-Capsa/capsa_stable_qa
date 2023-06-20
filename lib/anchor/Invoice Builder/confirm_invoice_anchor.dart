import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/main.dart';
import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/vendor-new/pages/add_invoice/widgets/info_box.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../anchor/provider/anchor_action_providers.dart';
import '../model/AnchorInvoiceModel.dart';
import '../provider/anchor_invoice_provider.dart';

class ConfirmInvoicePageAnchor extends StatefulWidget {
  AnchorInvoiceProvider invoiceProvider;

  ConfirmInvoicePageAnchor({Key key, this.invoiceProvider}) : super(key: key);

  @override
  State<ConfirmInvoicePageAnchor> createState() =>
      _ConfirmInvoicePageAnchorState();
}

class _ConfirmInvoicePageAnchorState extends State<ConfirmInvoicePageAnchor> {
  AnchorInvoiceModel invoice;
  // dynamic invoiceFormData;
  var invoiceProvider;
  var _actionProvider;
  bool isSplit = false;
  bool dataLoaded = false;
  bool savingData = false;

  List<Widget> splitInvoices = [];

  Future<void> submitInvoiceData(
      dynamic invoiceFormData,
      BuildContext context,
      AnchorActionProvider _actionProvider,
      AnchorInvoiceProvider invoiceProvider,
      {present: false,
      onlyPresent: false}) async {
    capsaPrint('ANchor invoice upload 1');
    setState(() {
      savingData = true;
    });
    final Box box = Hive.box('capsaBox');

    var userData = box.get('userData');

    capsaPrint('ANchor invoice upload 2');

    capsaPrint('Extended Due Date :${invoiceFormData['vendorName']}');

    final AnchorInvoiceModel invoice = AnchorInvoiceModel(
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
      invSell:
          (invoiceFormData['butAmt'] == '') ? '0' : invoiceFormData['butAmt'],
      buyNowPrice:
          (invoiceFormData['butAmt'] == '') ? '0' : invoiceFormData['butAmt'],
      rate: invoiceFormData['rate'],
      tenureDaysDiff: invoiceFormData['tenureDaysDiff'],
      extendedDueDate: invoiceFormData['showExtendedDueDate']
          ? invoiceFormData['_extendedDueDate'].toString()
          : invoiceFormData['_selectedDueDate'].toString(),
      //fileType: !onlyPresent ? invoiceFormData['file'].extension : '',
      //img: !onlyPresent ? invoiceFormData['file'] : null,
      vendorPAN: invoiceFormData['vendorPan'],
      vendorName: invoiceFormData['vendorName'],
      bvnNo: userData['panNumber'],
      platformFee: invoiceFormData['platformFee'],
        actualValue: invoiceFormData['actualValue']
    );

    capsaPrint('ANchor invoice upload 3');

    capsaPrint(
        'Extended Due Date : ${invoice.extendedDueDate} ${invoiceFormData['vendorName']}');

     final _responseData = await _actionProvider.uploadInvoice(
       invoice,
     );

    //final _responseData = {'res' : 'failed'};

    var _body = invoice.toJson();

    capsaPrint('ANchor invoice upload 4 $_body');

    if (_responseData['res'] == "failed") {
      if( _responseData['messg'] != null) {
        showPopupActionInfo(
        context,
        heading: "Unable to upload invoice",
        info: _responseData['messg'],
        buttonText: "Ok",
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
      }
      return;
    }else{
      showToast('Invoice Uploaded Successfully', context);
    }

    DateTime invoiceDate = DateFormat("yyyy-MM-dd").parse(invoice.invDate);

    DateTime invoiceDueDate =
        DateFormat("yyyy-MM-dd").parse(invoice.invDueDate);

    invoice.invDate = DateFormat.yMMMd('en_US').format(invoiceDate);
    invoice.invDueDate = DateFormat.yMMMd('en_US').format(invoiceDueDate);

    //showToast('Invoice Uploaded Successfully', context);

    setState(() {
      savingData = false;
    });

    // Navigator.pop(context);
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CapsaHome()),
    );
  }

  void getData(dynamic invoiceFormData) async {
    print('Get Data Called : ${invoiceProvider.invoiceFormWorking}');
    bool b = invoiceProvider.invoiceFormWorking;
    if (b == false) {
      print('Get Data Called 2 : ${b}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CapsaHome(),
        ),
      );
    }
    capsaPrint('confirm invoice pass 1 ');
    invoice = AnchorInvoiceModel(
      cuGst: invoiceFormData['cuGst'].toString(),
      anchor: invoiceFormData['anchor'].toString(),
      cacAddress: invoiceFormData['anchorAddress'].toString(),
      invNo: invoiceFormData['invoiceNo'].toString(),
      poNo: invoiceFormData['poNumber'].toString(),
      date: invoiceFormData['dateCont'].toString(),
      invDate: DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
          .parse(invoiceFormData['_selectedDate'].toString())),
      invDueDate: DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
          .parse(invoiceFormData['_selectedDueDate'].toString())),
      terms: invoiceFormData['tenure'].toString(),
      invAmt: invoiceFormData['invAmt'].toString(),
      // invDueDate:
      //     dueDateCont.text,
      invAmount: invoiceFormData['invAmt'].toString(),
      details: invoiceFormData['details'].toString(),
      invSell: (invoiceFormData['butAmt'] == '')
          ? '0'
          : invoiceFormData['butAmt'].toString(),
      buyNowPrice: (invoiceFormData['butAmt'] == '')
          ? '0'
          : invoiceFormData['butAmt'].toString(),
      rate: invoiceFormData['rate'].toString(),
      tenureDaysDiff: invoiceFormData['tenureDaysDiff'].toString(),
      extendedDueDate: invoiceFormData['extendedDueDateString'] ?? '',
      //fileType: invoiceFormData['file'].extension.toString(),
      //img: invoiceFormData['file'],
      vendorName: invoiceFormData['vendorName'],
      bvnNo: invoiceFormData['vendorPan'],
      platformFee: invoiceFormData['platformFee']
    );

    capsaPrint('confirm invoice pass 2 ${invoice.extendedDueDate}');

    dynamic data =
        await invoiceProvider.splitInvoice(invoice.invNo, invoice.invAmt);
    capsaPrint('confirm invoice pass 3 ');
    if (data['isSplit'].toString() == '1') {
      isSplit = true;
      print('Split data : $data');
      int splitSellAmount =
          (double.parse(invoice.buyNowPrice) / (data['result'].length * 1.0))
              .floor();
      splitInvoices.add(
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Invoice Split Breakdown',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      );
      for (int i = 0; i < data['result'].length; i++) {
        splitInvoices.add(
          OrientationSwitcher(children: [
            InfoBox(
              header: 'Invoice Number',
              content: data['result'][i]['invoice_number'],
              width: 208,
            ),
            InfoBox(
              header: 'Split Invoice Amount',
              content: formatCurrency(
                  data['result'][i]['invoice_amount'].toString()),
              width: 248,
            ),
            InfoBox(
              header: 'Purchase Price',
              content: formatCurrency(splitSellAmount.toString()),
              width: 208,
            ),
          ]),
        );
      }
    }

    capsaPrint('confirm invoice pass 4 ');

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceProvider = widget.invoiceProvider;
    _actionProvider = Provider.of<AnchorActionProvider>(context, listen: false);

    // print('Confirm Page : ${invoiceProvider.invoiceFormData}');

    // if (widget.invVoiceNumber != null) {
    //   // complete = true;
    //   isEditShow = true;
    //   _future = invoiceProvider.queryInvoiceData(widget.invVoiceNumber);
    // } else if (!invoiceProvider.invoiceFormWorking) {
    //   Beamer.of(context).beamToNamed('/addInvoice');
    // } else {
    //   // _future = justDataSet(invoiceProvider.invoiceFormData['invAmt']);
    //   invoiceFormData = invoiceProvider.invoiceFormData;
    // }

    // invoiceFormData = invoiceProvider.invoiceFormData;
    getData(invoiceProvider.invoiceFormData);
  }

  Size columnSize;
  final _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
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
          dataLoaded
              ? Container(
                  //height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.8,
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
                      TopBarWidget("Add Invoice", ""),
                      SizedBox(
                        height: (!Responsive.isMobile(context)) ? 8 : 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'General Details',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              key: _key,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OrientationSwitcher(children: [
                                  InfoBox(
                                      header: 'Anchor Name',
                                      content: invoice.anchor),
                                  InfoBox(
                                      header: 'Vendor Name',
                                      content: invoice.vendorName ?? '')
                                ]),
                                OrientationSwitcher(children: [
                                  InfoBox(
                                      header: 'Invoice No.',
                                      content: invoice.invNo),
                                  InfoBox(
                                      header: 'PO Number',
                                      content: invoice.poNo)
                                ]),
                                OrientationSwitcher(children: [
                                  InfoBox(
                                      header: 'Issue Date',
                                      content: invoice.invDate),
                                  InfoBox(
                                      header: 'Due Date',
                                      content: invoice.invDueDate)
                                ]),
                                // if(invoice.extendedDueDate != '')
                                //   OrientationSwitcher(children: [
                                //     InfoBox(
                                //       header: 'Extended Due Date',
                                //       content: invoice.extendedDueDate,
                                //       width: 596,
                                //     ),
                                //   ]),
                                OrientationSwitcher(children: [
                                  InfoBox(
                                      header: 'Tenure',
                                      content: invoice.tenureDaysDiff),
                                  InfoBox(
                                      header: 'Invoice Amount',
                                      content: formatCurrency(invoice.invAmt))
                                ]),
                                OrientationSwitcher(children: [
                                  InfoBox(
                                    header: 'Purchase Price',
                                    content: invoice.buyNowPrice,
                                    width: 596,
                                  ),
                                ]),
                                OrientationSwitcher(children: [
                                  InfoBox(
                                    header: 'Platform Fee',
                                    content: invoice.platformFee ?? '0',
                                    width: 596,
                                  ),
                                ]),
                                OrientationSwitcher(children: [
                                  InfoBox(
                                    header: 'Details (e.g items or quantity)',
                                    content: invoice.details,
                                    width: 596,
                                  ),
                                ]),
                              ],
                            ),

                            // Container(
                            //   width: MediaQuery.of(context).size.width * 0.4,
                            //   height: 644,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(15),
                            //     color: Colors.white,
                            //   ),
                            //   child: Container(
                            //     child: invoice.img != null
                            //         ? invoice.fileType == 'pdf'
                            //         ? SfPdfViewer.memory(invoice.img.bytes)
                            //         : Image.memory(invoice.img.bytes)
                            //         : Center(
                            //         child: Text(
                            //           'Uploaded Invoice will appear here',
                            //           textAlign: TextAlign.left,
                            //           style: TextStyle(
                            //               color: Color.fromRGBO(
                            //                   255, 255, 255, 1),
                            //               // fontFamily: 'Poppins',
                            //               fontSize: 14,
                            //               letterSpacing:
                            //               0 /*percentages not used in flutter. defaulting to zero*/,
                            //               fontWeight: FontWeight.normal,
                            //               height: 1),
                            //         )),
                            //   ),
                            // ),
                          ]),
                      isSplit
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: splitInvoices)
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: savingData
                            ? Row(
                                children: [
                                  Container(
                                    width: 200,
                                    height: 59,
                                    color: Colors.transparent,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    )),
                                  ),
                                ],
                              )
                            : OrientationSwitcher(
                                orientation: Responsive.isMobile(context)
                                    ? 'Column'
                                    : 'Row',
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await submitInvoiceData(
                                          invoiceProvider.invoiceFormData,
                                          context,
                                          _actionProvider,
                                          invoiceProvider,
                                          present: false);
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 59,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: HexColor('#3AC0C9'),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Upload Invoice',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 31,
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: InkWell(
                                      // onTap: () async{
                                      //   await submitInvoiceData(invoiceProvider.invoiceFormData, context, _actionProvider, invoiceProvider, present: true);
                                      // },
                                      child: Container(
                                        width: 200,
                                        height: 59,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: HexColor('#0098DB'),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Save & Present',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      )
                    ],
                  )),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
