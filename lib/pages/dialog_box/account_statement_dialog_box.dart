import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:html' as html; //ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:intl/intl.dart';
import 'package:capsa/pages/dialog_box/transaction_details_pdf_builder.dart';

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
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:ui' as ui;

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as pr;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AccountStatementViewer extends StatefulWidget {
  ProfileProvider profileProvider;
  List<dynamic> transactionDetails;

  AccountStatementViewer(
      {Key key, this.profileProvider, this.transactionDetails})
      : super(key: key);

  @override
  State<AccountStatementViewer> createState() => _AccountStatementViewerState();
}

class _AccountStatementViewerState extends State<AccountStatementViewer> {
  final GlobalKey genKey = GlobalKey();

  bool loading = false;
  bool uploaded = false;
  TextEditingController buyNowPrice = TextEditingController(text: '');

  transactionAmount(TransactionDetails transactionDetails) {
    num amt = 0;
    if (num.parse(transactionDetails.deposit_amt) > 0) {
      amt = num.parse(transactionDetails.deposit_amt);
    } else if (num.parse(transactionDetails.withdrawl_amt) > 0) {
      amt = num.parse(transactionDetails.withdrawl_amt);
    } else if (num.parse(transactionDetails.blocked_amt) > 0) {
      amt = num.parse(transactionDetails.blocked_amt);
    }
    return (amt);
  }

  Widget pdfView() {
    final _getBankDetails = widget.profileProvider.getStatementBankDetails;
    var userData = Map<String, dynamic>.from(box.get('userData'));
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: Responsive.isMobile(context) ? 12 : 34,
            right: Responsive.isMobile(context) ? 12 : 34),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 47,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/capsa_logo_blue.png',
                        fit: BoxFit.contain,
                        width: 180,
                        height: 80,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        userData['name'],
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: HexColor('#333333')),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        userData['email'],
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: HexColor('#333333')),
                      ),
                    ],
                  ),
                  Text(
                    'Capsa Technology Limited\n7th floor Mulliner Towers,\n39 Alfred Rewane Rd,\n 101233, Lagos\n\n0704-627-2950\nhello@getcapsa.com',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: HexColor('#333333')),
                  ),
                ],
              ),
              SizedBox(
                height: 42,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Account Statement',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: HexColor('#333333')),
                  ),
                ],
              ),

              SizedBox(
                height: 24,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Account Number',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: HexColor('#333333')),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        _getBankDetails.account_number,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: HexColor('#333333')),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: HexColor('#333333')),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        formatCurrency(widget.profileProvider.totalBalance,
                            withIcon: false, withCurrencyName: true),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: HexColor('#333333')),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Available To Withdraw',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: HexColor('#333333')),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        formatCurrency(
                            widget.profileProvider.totalBalanceToWithDraw, withIcon: false, withCurrencyName: true),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: HexColor('#333333')),
                      ),
                    ],
                  ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Account Number',
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 10,
                  //           color: HexColor('#333333')),
                  //     ),
                  //     SizedBox(
                  //       height: 20,
                  //     ),
                  //     Text(
                  //       '0000123455',
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w700,
                  //           fontSize: 10,
                  //           color: HexColor('#333333')),
                  //     ),
                  //   ],
                  // ),
                ],
              ),

              SizedBox(
                height: 42,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Account Statement',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: HexColor('#333333')),
                  ),
                ],
              ),

              SizedBox(
                height: 24,
              ),
              //itemDescription(),

              Table(
                defaultColumnWidth: FixedColumnWidth(140.0),
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Account Name', style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Opening Balance', style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Inflows', style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Outflows', style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Closing Balance', style: TextStyle(fontSize: 14.0))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text(_getBankDetails.bene_account_holdername ?? '', style: TextStyle(fontSize: 12))]),
                    Column(children: [Text(widget.transactionDetails[widget.transactionDetails.length - 1].opening_balance?? '', style: TextStyle(fontSize: 12))]),
                    Column(children: [Text(_getBankDetails.inflow?? '', style: TextStyle(fontSize: 12))]),
                    Column(children: [Text(_getBankDetails.outflow?? '', style: TextStyle(fontSize: 12))]),
                    Column(children: [Text(widget.transactionDetails[0].closing_balance?? '', style: TextStyle(fontSize: 12))]),
                  ]),
                ],
              ),

              SizedBox(
                height: 42,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Account Statement',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: HexColor('#333333')),
                  ),
                ],
              ),

              SizedBox(
                height: 24,
              ),
              //itemDescription(),

              Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Date', style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Amount', style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Transaction Details',
                          style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Opening Balance', style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Closing Balance', style: TextStyle(fontSize: 14.0))
                    ]),
                    Column(children: [
                      Text('Reference Number', style: TextStyle(fontSize: 14.0))
                    ]),
                  ]),
                  for (TransactionDetails transaction
                      in widget.transactionDetails)
                    TableRow(children: [
                      Column(children: [
                        Text(
                            DateFormat('d MMM, y')
                                .format(
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                        .parse(transaction.created_on))
                                .toString(),
                            style: TextStyle(fontSize: 12.0))
                      ]),
                      Column(children: [
                        Text(formatCurrency(transactionAmount(transaction)),
                            style: TextStyle(fontSize: 12.0))
                      ]),
                      Column(children: [
                        Text(transaction.narration,
                            style: TextStyle(fontSize: 12.0))
                      ]),
                      Column(children: [
                        Text(formatCurrency(transaction.opening_balance),
                            style: TextStyle(fontSize: 12.0))
                      ]),
                      Column(children: [
                        Text(formatCurrency(transaction.closing_balance),
                            style: TextStyle(fontSize: 12.0))
                      ]),
                      Column(children: [
                        Text(transaction.order_number,
                            style: TextStyle(fontSize: 12.0))
                      ]),
                    ]),
                  // TableRow( children: [
                  //   Column(children:[Text('Javatpoint')]),
                  //   Column(children:[Text('MySQL')]),
                  //   Column(children:[Text('5*')]),
                  //   Column(children:[Text('Javatpoint')]),
                  //   Column(children:[Text('Flutter')]),
                  //   Column(children:[Text('5*')]),
                  // ]),
                  // TableRow( children: [
                  //   Column(children:[Text('Javatpoint')]),
                  //   Column(children:[Text('ReactJS')]),
                  //   Column(children:[Text('5*')]),
                  //   Column(children:[Text('Javatpoint')]),
                  //   Column(children:[Text('Flutter')]),
                  //   Column(children:[Text('5*')]),
                  // ]),
                ],
              ),

              SizedBox(
                height: 42,
              ),
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

  void saveImg(Uint8List bytes, String fileName) {
    js.context.callMethod("saveAs", [
      html.Blob([bytes]),
      fileName
    ]);
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //capsaPrint('Image Url : ${widget.imageUrl}');
    return !loading
        ? Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    RepaintBoundary(key: genKey, child: pdfView()),
                    SizedBox(
                      height: 10,
                    ),
                    // if(widget.uploadForApproval)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Text('Enter Buy Now Price :  ', style: GoogleFonts.poppins(fontSize: Responsive.isMobile(context)?12:16),),
                    //       Container(
                    //         width: Responsive.isMobile(context)?80:120,
                    //         height: Responsive.isMobile(context)?60:60,
                    //         child:
                    //         UserTextFormField(
                    //           label: '',
                    //           padding:
                    //           EdgeInsets
                    //               .all(0),
                    //           borderRadius: 5,
                    //           showBorder: true,
                    //           inputFormatters: [
                    //             FilteringTextInputFormatter
                    //                 .digitsOnly
                    //           ],
                    //           hintText: "",
                    //           controller:
                    //           buyNowPrice,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //
                    // SizedBox(height: 20,),
                    //
                    // if(widget.uploadForApproval)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       InkWell(
                    //         onTap: () async{
                    //
                    //           if(buyNowPrice.text == ''){
                    //             showToast('Buy Now Price cannot be empty', context, type: 'warning');
                    //           }else if(double.parse(buyNowPrice.text)>double.parse(widget.invoice.invAmt)){
                    //             showToast('Buy Now Price cannot be greater than invoice amount', context, type: 'warning');
                    //           }else {
                    //             scrollController.jumpTo(scrollController.position.minScrollExtent);
                    //             setState(() {
                    //               widget.uploadForApproval = false;
                    //             });
                    //             widget.invoice.buyNowPrice = buyNowPrice.text;
                    //
                    //             dynamic image = await takePicture();
                    //             capsaPrint('Pass 1');
                    //             setState(() {
                    //               widget.uploadForApproval = true;
                    //             });
                    //             setState(() {
                    //               loading = true;
                    //             });
                    //
                    //
                    //
                    //             dynamic response = await uploadInvoice(
                    //                 widget.invoice, image, 'NGN');
                    //
                    //             if (response['res'] == 'success') {
                    //               dynamic res =
                    //               await invoiceApproved(widget.model.invNo);
                    //               uploaded = true;
                    //               capsaPrint('\n\ninvoice approved $res');
                    //               showToast(
                    //                   'Invoice submitted for approval', context);
                    //             } else {
                    //               showToast(
                    //                   'Invoice could not be submitted', context,
                    //                   type: 'warning');
                    //             }
                    //
                    //             setState(() {
                    //               loading = false;
                    //             });
                    //
                    //             Navigator.pop(context);
                    //           }
                    //         },
                    //         child: Container(
                    //             decoration: BoxDecoration(
                    //                 color: Colors.green
                    //             ),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(12.0),
                    //               child: Center(child: Text('Proceed', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),)),
                    //             )),
                    //       ),
                    //       InkWell(
                    //         onTap: (){
                    //           Navigator.pop(context);
                    //         },
                    //         child: Container(
                    //             decoration: BoxDecoration(
                    //                 color: Colors.red
                    //             ),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(12.0),
                    //               child: Center(child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),)),
                    //             )),
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ),
              Positioned(
                  right: 20,
                  top: 20,
                  child: InkWell(
                      onTap: () async {
                        // dynamic image = await takePicture();
                        // saveImg(image, widget.model.invNo + ".png");
                        // Navigator.pop(context);

                        // dynamic netImage = widget.imageFromUrl? await pr.networkImage(widget.imageUrl) : pw.MemoryImage(
                        //   widget.image.bytes,
                        // );
                        //await transactionDetailsPdfBuilder.transactionPrintDoc(widget.profileProvider,widget.transactionDetails);
                      },
                      child: Icon(
                        Icons.download,
                        size: 34,
                      )))
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
