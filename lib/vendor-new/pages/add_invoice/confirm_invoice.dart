import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
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

class ConfirmInvoicePage extends StatefulWidget {

  ConfirmInvoicePage({Key key,}) : super(key: key);

  @override
  State<ConfirmInvoicePage> createState() => _ConfirmInvoicePageState();
}

class _ConfirmInvoicePageState extends State<ConfirmInvoicePage> {

  InvoiceModel invoice;
  // dynamic invoiceFormData;
  var invoiceProvider;
  var _actionProvider;
  bool isSplit = false;
  bool dataLoaded = false;
  bool savingData = false;

  List<Widget> splitInvoices = [];


  Future<void> submitInvoiceData(dynamic invoiceFormData, BuildContext context, VendorActionProvider _actionProvider, InvoiceProvider invoiceProvider,
      {present: false, onlyPresent: false}) async {
    setState(() {
      savingData = true;
    });
    final Box box = Hive.box('capsaBox');


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
      extendedDueDate: invoiceFormData['showExtendedDueDate'] ? invoiceFormData['_extendedDueDate'].toString() : invoiceFormData['_selectedDueDate'].toString(),
      fileType: !onlyPresent ? invoiceFormData['file'].extension : '',
      img: !onlyPresent ? invoiceFormData['file'] : null,
      bvnNo: userData['panNumber'],
    );

    capsaPrint('Extended Due Date : ${invoice.extendedDueDate}');

    if (!onlyPresent) {
      final _responseData = await _actionProvider.uploadInvoice(invoice, invoiceFormData['file'],);

      if (_responseData['res'] == "failed") {

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

      DateTime invoiceDueDate = DateFormat("yyyy-MM-dd").parse(invoice.invDueDate);

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
      if (_data['res'] == 'success') {

        // var invNum = _data['data']['invnum'];
        showPopupActionInfo(
          context,
          //barrierDismissible: true,
          heading: "Congratulations! Your invoice \nhas been saved and presented. ",
          info: "When your Anchor approves the invoice, you will start receiving bids from Investors.",
          buttonText: "View Pending Invoices",
          // buttonText2: "Back",
          // onTap2: () {
          //   Navigator.of(context, rootNavigator: true).pop();
          // },
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
        //barrierDismissible: true,
        heading: "Congratulations! Your invoice has been saved on Capsa",
        info: "You can always edit and present your invoice anytime. ",
        buttonText: "View Saved Invoice",
        // buttonText2: "Back",
        //   onTap2: () {
        //     Navigator.of(context, rootNavigator: true).pop();
        //   },
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
          invoiceProvider.resetInvoiceFormData();
          Beamer.of(context).beamToNamed('/viewInvoice/' + Uri.encodeComponent(invoice.invNo),);
        },
      );
    }
    setState(() {
      savingData = false;
    });
  }

  void getData(dynamic invoiceFormData) async{
    print('Get Data Called : ${invoiceProvider.invoiceFormWorking}');
    bool b = invoiceProvider.invoiceFormWorking;
    if(b == false){
      print('Get Data Called 2 : ${b}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CapsaHome(),
        ),
      );
    }
    //capsaPrint('confirm invoice pass 1 ${invoiceFormData}');
    invoice = InvoiceModel(
      cuGst: invoiceFormData['cuGst'].toString(),
      anchor: invoiceFormData['anchor'].toString(),
      cacAddress: invoiceFormData['anchorAddress'].toString(),
      invNo: invoiceFormData['invoiceNo'].toString(),
      poNo: invoiceFormData['poNumber'].toString(),
      date: invoiceFormData['dateCont'].toString(),
      invDate: DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd").parse(invoiceFormData['_selectedDate'].toString())),
      invDueDate: DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd").parse(invoiceFormData['_selectedDueDate'].toString())),
      terms: invoiceFormData['tenure'].toString(),
      invAmt: invoiceFormData['invAmt'].toString(),
      // invDueDate:
      //     dueDateCont.text,
      invAmount: invoiceFormData['invAmt'].toString(),
      details: invoiceFormData['details'].toString(),
      invSell: (invoiceFormData['butAmt'] == '') ? '0' : invoiceFormData['butAmt'].toString(),
      buyNowPrice: (invoiceFormData['butAmt'] == '') ? '0' : invoiceFormData['butAmt'].toString(),
      rate: invoiceFormData['rate'].toString(),
      tenureDaysDiff: invoiceFormData['tenureDaysDiff'].toString(),
      extendedDueDate: invoiceFormData['extendedDueDateString'] ?? '',
      fileType: invoiceFormData['file'].extension.toString(),
      img: invoiceFormData['file'],
      bvnNo: '',
    );

    capsaPrint('confirm invoice pass 2 ${invoice.extendedDueDate}');

    dynamic data = await invoiceProvider.splitInvoice(invoice.invNo,invoice.invAmt);
    if(data['isSplit'].toString() == '1'){
      isSplit = true;
      print('Split data : $data');
      int splitSellAmount = (double.parse(invoice.buyNowPrice)/(data['result'].length*1.0)).floor();
      splitInvoices.add( Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Invoice Split Breakdown',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),);
      for(int i = 0;i<data['result'].length;i++){
        splitInvoices.add( OrientationSwitcher(children: [
          InfoBox(header: 'Invoice Number', content: data['result'][i]['invoice_number'], width: 208,),
          InfoBox(header: 'Split Invoice Amount', content: formatCurrency(data['result'][i]['invoice_amount'].toString()), width: 248,),
          InfoBox(header: 'Sell Now Price', content: formatCurrency(splitSellAmount.toString()), width: 208,),
        ]),);
      }
    }

    setState(() {
      dataLoaded = true;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);
    _actionProvider = Provider.of<VendorActionProvider>(context, listen: false);

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
    return dataLoaded?Container(
      //height: MediaQuery.of(context).size.height,
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
              children:

          [
            Column(
              key: _key,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrientationSwitcher(children: [
                  InfoBox(header: 'Anchor Name', content: invoice.anchor),
                  InfoBox(header: 'CAC/Address', content: invoice.cacAddress)
                ]),
                OrientationSwitcher(children: [
                  InfoBox(header: 'Invoice No.', content: invoice.invNo),
                  InfoBox(header: 'PO Number', content: invoice.poNo)
                ]),
                OrientationSwitcher(children: [
                  InfoBox(header: 'Issue Date', content: invoice.invDate),
                  InfoBox(header: 'Due Date', content: invoice.invDueDate)
                ]),
                if(invoice.extendedDueDate != '')
                OrientationSwitcher(children: [
                  InfoBox(
                    header: 'Extended Due Date',
                    content: invoice.extendedDueDate,
                    width: 596,
                  ),
                ]),
                OrientationSwitcher(children: [
                  InfoBox(header: 'Tenure', content: invoice.tenureDaysDiff),
                  InfoBox(header: 'Invoice Amount', content: formatCurrency(invoice.invAmt))
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

            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 644,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Container(
                child: invoice.img != null
                    ? invoice.fileType == 'pdf'
                    ? SfPdfViewer.memory(invoice.img.bytes)
                    : Image.memory(invoice.img.bytes)
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


            ]),

          isSplit?Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: splitInvoices
          ):Container(),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: savingData?Row(
              children: [
                Container(
                  width: 200,
                  height: 59,
                  color: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.blue,)
                  ),
                ),
              ],
            ): OrientationSwitcher(
              orientation: Responsive.isMobile(context)?'Column':'Row',
              children: [
                InkWell(
                  onTap: () async {
                    await submitInvoiceData(invoiceProvider.invoiceFormData, context, _actionProvider, invoiceProvider, present: false);
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
                        'Save Invoice',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 31,),
                InkWell(
                  onTap: () async{
                    await submitInvoiceData(invoiceProvider.invoiceFormData, context, _actionProvider, invoiceProvider, present: true);
                  },
                  child: Container(
                    width: 200,
                    height: 59,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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
              ],
            ),
          )
        ],
      )),
    ):const Center(child: CircularProgressIndicator(),);
  }
}
