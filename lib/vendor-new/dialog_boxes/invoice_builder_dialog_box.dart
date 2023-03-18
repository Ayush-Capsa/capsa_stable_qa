
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:html' as html; //ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:capsa/common/responsive.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:intl/intl.dart';

import 'package:capsa/common/constants.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/vendor-new/model/pdf_builder.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/vendor-new/model/invoice_builder_model.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';

import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as pr;


import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class InvoiceViewer extends StatefulWidget {
  InvoiceBuilderModel model;
  bool imageFromUrl;
  String imageUrl;
  PlatformFile image;
  bool uploadForApproval;
  dynamic invoice;
  InvoiceViewer({Key key, this.model, this.imageFromUrl, this.image, this.imageUrl, this.uploadForApproval = false, this.invoice}) : super(key: key);

  @override
  State<InvoiceViewer> createState() => _InvoiceViewerState();
}

class _InvoiceViewerState extends State<InvoiceViewer> {
  final GlobalKey genKey = GlobalKey();

  bool loading = false;
  bool uploaded = false;
  TextEditingController buyNowPrice = TextEditingController(text: '');

  Widget invoiceInfo(List<String> lead, List<String> info) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: !Responsive.isMobile(context)?CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < lead.length; i++)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                child: Text(
                  lead[i],
                  textAlign: TextAlign.end,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: HexColor('#333333')),
                ),
              )
          ],
        ),
        SizedBox(
          width: Responsive.isMobile(context)?16:29,
        ),
        Column(
          crossAxisAlignment: !Responsive.isMobile(context)?CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < info.length; i++)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                child: Text(
                  info[i],
                  textAlign: TextAlign.end,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: HexColor('#333333')),
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget header(String header, double width){
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        height: Responsive.isMobile(context)?12:29,
        width: width,
        color: HexColor('#828282'),
        child: Center(
          child: Text(
            header,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 6,
                color: HexColor('#FFFFFF')
            ),
          ),
        ),
      ),
    );
  }

  Widget content(String content, double width){
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        height: Responsive.isMobile(context)?12:29,
        width: width,
        color: HexColor('#FFFFFF'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                content,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 6,
                    color: HexColor('#333333')
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemDescription(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            header('Item Description', Responsive.isMobile(context)?62:288),
            for(int i = 0;i<widget.model.descriptions.length;i++)
              content(widget.model.descriptions[i].description,  Responsive.isMobile(context)?62:288)
          ],
        ),
        Column(
          children: [
            header('Quantity', Responsive.isMobile(context)?52:63),
            for(int i = 0;i<widget.model.descriptions.length;i++)
              content(formatCurrency(widget.model.descriptions[i].quantity), Responsive.isMobile(context)?52:63)
          ],
        ),
        Column(
          children: [
            header('Rate', Responsive.isMobile(context)?52:88),
            for(int i = 0;i<widget.model.descriptions.length;i++)
              content(formatCurrency(widget.model.descriptions[i].rate), Responsive.isMobile(context)?52:88)
          ],
        ),
        Column(
          children: [
            header('Amount', Responsive.isMobile(context)?52:89),
            for(int i = 0;i<widget.model.descriptions.length;i++)
              content(formatCurrency(widget.model.descriptions[i].amount), Responsive.isMobile(context)?52:89)
          ],
        )
      ],
    );
  }

  Future<Object> uploadInvoice(invoice, dynamic file,String currency) async {
    // capsaPrint(DateTime.now().millisecondsSinceEpoch.toString());

    String _url = apiUrl + 'dashboard/r/';
    capsaPrint('Upload Invoice \n\n');
    var _body = invoice.toJson();
    _body['currency'] = currency;

    capsaPrint('Invoice upload body = \n$_body');

    dynamic _uri = _url + 'invoiceupload';
    _uri = Uri.parse(_uri);

    var request = http.MultipartRequest('POST', _uri);
    request.fields['web'] = kIsWeb.toString();

    request.headers['Authorization'] = 'Basic ' + box.get('token', defaultValue: '0');

    capsaPrint('Pass 1 $_body');

    _body.forEach((key, value) {
      if(value != null) {
        request.fields[key] = value;
      }
    });

    capsaPrint('Pass 2');

    // var inv = _body['invNo'].replaceAll(new RegExp(r'[^\w\s]+'), '_');

    request.files.add(http.MultipartFile.fromBytes(
      'invoice_file',
      file,
      filename: _body['bvnNo'] + '_' + _body['invNo'] + '_' + DateTime.now().millisecondsSinceEpoch.toString() + '.' + 'png',
      contentType: MediaType('application', 'octet-stream'),
    ));

    capsaPrint('Pass 3');

    var res = await request.send();
    //capsaPrint(res.reasonPhrase);

    capsaPrint('Pass 4');

    var data = jsonDecode((await http.Response.fromStream(res)).body);
    capsaPrint('invoiceUpload data $data');

    if(data['res'] == 'success'){
      var userData = Map<String, dynamic>.from(box.get('userData'));

      _body['panNumber'] = userData['panNumber'];
      _body['role'] = userData['role'];
      _body['userName'] = userData['userName'];
      _body['invNum'] = invoice.invNo;
      // _body['invNum'] = invoice.invNo;

      //dynamic _uri;
      _body['isSplit'] = '0';
      _uri = _url + 'requestApproval';
      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      data = jsonDecode(response.body);
      capsaPrint('requestApproval data $data');
      return data;
    }

    return data;



    // var response = await http.post(_uri, body: _body);
    // var data = jsonDecode(response.body);
    // // capsaPrint(data);
    // return data;
  }

  Future<Object> invoiceApproved(String invNo) async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      _body['invoice_number'] = invNo;

      dynamic _uri = 'dashboard/r/uploadInvoiceDraft';

      return callApi(_uri, body: _body);
    }
    return null;
  }

  Widget pdfView(){
    return Container(
      height: 720,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: Responsive.isMobile(context)?12:34, right: Responsive.isMobile(context)?12:34),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 47,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !widget.imageFromUrl?Image.memory(
                    widget.image.bytes,
                    fit: BoxFit.contain,
                    width: 180,
                    height: 80,
                  ):Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    width: 150,
                    height: 50,
                  ),
                  Text(
                    'INVOICE',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: Responsive.isMobile(context)?14:24,
                        color: HexColor('#333333')),
                  ),
                ],
              ),
              SizedBox(
                height: 42,
              ),
              OrientationSwitcher(
                orientation: Responsive.isMobile(context)?'Column':'Row',

                mainAxisAlignment: !Responsive.isMobile(context)?MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      OrientationSwitcher(
                        orientation: !Responsive.isMobile(context)?'Column':'Row',
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Company Name : ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: HexColor('#828282')),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            widget.model.vendor,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: HexColor('#333333')),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: !Responsive.isMobile(context)?19:6,
                      ),
                      OrientationSwitcher(
                        orientation: !Responsive.isMobile(context)?'Column':'Row',
                        children: [
                          Text(
                            'Bill To : ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: HexColor('#828282')),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            widget.model.anchor,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: HexColor('#333333')),
                          ),
                        ],
                      ),

                    ],
                  ),

                  SizedBox(
                    height: !Responsive.isMobile(context)?19:12,
                  ),

                  //SizedBox(height: 8,),

                  invoiceInfo([
                    'Invoice Number : ',
                    'Date : ',
                    'Due Date : ',
                    'Tenure : ',
                    'PO Number : '
                  ], [
                    widget.model.invNo,
                    widget.model.invDate != ''?DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                        .parse(widget.model.invDate)):'',
                    widget.model.invDueDate!=''?DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                        .parse(widget.model.invDueDate)):'',
                    widget.model.tenure,
                    widget.model.poNo
                  ])

                ],
              ),

              SizedBox(
                height: 42,
              ),

              itemDescription(),

              SizedBox(
                height: 42,
              ),

              OrientationSwitcher(
                orientation: Responsive.isMobile(context)?'Column':'Row',
                mainAxisAlignment:Responsive.isMobile(context)?MainAxisAlignment.start:(widget.model.notes!=null || widget.model.notes!='')?MainAxisAlignment.spaceBetween: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if(widget.model.notes!=null || widget.model.notes!='')
                  Text(
                    "Note : ${widget.model.notes}",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: HexColor('#333333')),
                  ),


                  invoiceInfo([
                    'Subtotal :',
                    'Tax :',
                    'TOTAL:',
                    'Amount Paid:',
                    'Balance Due:'
                  ], [
                    formatCurrency(widget.model.subTotal, withIcon: false, withCurrencyName: true ),
                    formatCurrency(widget.model.tax, withIcon: false, withCurrencyName: true ),
                    formatCurrency(widget.model.total, withIcon: false, withCurrencyName: true ),
                    formatCurrency(widget.model.paid, withIcon: false, withCurrencyName: true ),
                    formatCurrency(widget.model.balanceDue, withIcon: false, withCurrencyName: true ),
                  ])

                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<Object> takePicture() async {
    RenderRepaintBoundary boundary = genKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  void saveImg(Uint8List bytes, String fileName){
    js.context.callMethod("saveAs", [
      html.Blob([bytes]),
      fileName
    ]);
  }

  ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    //capsaPrint('Image Url : ${widget.imageUrl}');
    return !loading?Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(height: 0,),
              RepaintBoundary(
                  key: genKey,
                  child: pdfView()),
              SizedBox(height: 10,),
              if(widget.uploadForApproval)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Enter Buy Now Price :  ', style: GoogleFonts.poppins(fontSize: Responsive.isMobile(context)?12:16),),
                    Container(
                      width: Responsive.isMobile(context)?80:120,
                      height: Responsive.isMobile(context)?60:60,
                      child:
                      UserTextFormField(
                        label: '',
                        padding:
                        EdgeInsets
                            .all(0),
                        borderRadius: 5,
                        showBorder: true,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly
                        ],
                        hintText: "",
                        controller:
                        buyNowPrice,
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 20,),

              if(widget.uploadForApproval)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async{

                        if(buyNowPrice.text == ''){
                          showToast('Buy Now Price cannot be empty', context, type: 'warning');
                        }else if(double.parse(buyNowPrice.text)>double.parse(widget.invoice.invAmt)){
                          showToast('Buy Now Price cannot be greater than invoice amount', context, type: 'warning');
                        }else {
                              scrollController.jumpTo(scrollController.position.minScrollExtent);
                              setState(() {
                                widget.uploadForApproval = false;
                              });
                              widget.invoice.buyNowPrice = buyNowPrice.text;

                              dynamic image = await takePicture();
                              capsaPrint('Pass 1 upload approval');
                              setState(() {
                                widget.uploadForApproval = true;
                              });
                                setState(() {
                                  loading = true;
                                });



                                dynamic response = await uploadInvoice(
                                    widget.invoice, image, 'NGN');

                                if (response['res'] == 'success') {
                                  dynamic res =
                                      await invoiceApproved(widget.model.invNo);
                                  uploaded = true;
                                  capsaPrint('\n\ninvoice approved $res');
                                  showToast(
                                      'Invoice submitted for approval', context);
                                } else {
                                  showToast(
                                      'Invoice could not be submitted', context,
                                      type: 'warning');
                                }

                                setState(() {
                                  loading = false;
                                });

                                Navigator.pop(context);
                              }
                            },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(child: Text('Proceed', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),)),
                          )),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),)),
                          )),
                    ),
                  ],
                ),

            ],
          ),
        ),
        !widget.uploadForApproval?Positioned(
            right: 20,
            top: 20,
            child: InkWell(
                onTap: () async{

                  // dynamic image = await takePicture();
                  // saveImg(image, widget.model.invNo + ".png");
                  // Navigator.pop(context);

                  dynamic netImage = widget.imageFromUrl? await pr.networkImage(widget.imageUrl) : pw.MemoryImage(
                    widget.image.bytes,
                  );
                  await pdfBuilder.printDoc(widget.model,netImage, context) ;
                },
                child: Icon(Icons.download,size: 34,))) : Positioned(
            right: 20,
            top: 20,
            child: Container())
      ],
    ):Center(
      child: CircularProgressIndicator(),
    );

  }
}
