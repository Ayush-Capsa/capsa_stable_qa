import 'package:beamer/src/beamer.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/vendor-new/dialog_boxes/invoice_builder_dialog_box.dart';
import 'package:capsa/vendor-new/model/invoice_builder_model.dart';
import 'package:capsa/vendor-new/pages/EditInvoice/edit_built_invoice.dart';
import 'package:capsa/vendor-new/provider/invoice_builder_provider.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../vendor_new.dart';
import 'package:http/http.dart' as http;

class InvoiceBuilderHistory extends StatefulWidget {
  const InvoiceBuilderHistory({Key key}) : super(key: key);

  @override
  State<InvoiceBuilderHistory> createState() =>
      _InvoiceBuilderHistoryPageState();
}

class _InvoiceBuilderHistoryPageState extends State<InvoiceBuilderHistory> {

  void uploadForApproval(InvoiceBuilderModel model)async{
    var _body = {};

    // final responseData = await http.get(model.logo);
    // uint8list = responseData.bodyBytes;
    // var buffer = uint8list.buffer;
    // ByteData byteData = ByteData.view(buffer);
    // var tempDir = await getTemporaryDirectory();
    // File file = await File('${tempDir.path}/img').writeAsBytes(
    //     buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    //
    // _body = {
    //  "web": "true",
    //   "anchor": model.anchor,
    //   "cacAddress": RC1001781 ( Okotie-eboh ),
    //   invNo: shiv-bv-c,
    //   poNo: 4342fd,
    //   invDate: 2022-11-01 00:00:00.000,
    // terms: 45,
    // invDueDate: 2022-11-30 00:00:00.000,
    // details: abc etc,
    // rate: 0.66,
    // invAmount: 20000,
    // buyNowPrice: 19000,
    // tenureDaysDiff: 29,
    // fileType: jpg,
    // bvnNo:22151153491,
    // cuGst:X22141733973XXX,
    // currency:NGN (edited),
    // };

  }

  TextEditingController buyNowPrice = TextEditingController(text: '');

  String _cuGst = "";

  var anchorName;
  String customer_cin = "";

  var anchorNameList = [];

  dynamic companyDetails = null;

  Map<String, bool> _isBlackListed = {};
  List<String> anchorTerm = [];

  Map<String, String> cuGst = {};
  Map<String, String> cacAddress = {};
  String _search = "";

  bool isNull(String s){
    if(s == '' || s == null || s.toLowerCase() == 'null')
      return true;
    return false;
  }

  String value(String s){
    return isNull(s) ? "" : s;
  }

  Widget invoiceCard(InvoiceBuilderModel model, InvoiceBuilderProvider provider){
    //capsaPrint('Creating invoice card');
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: HexColor('#F5FBFF')
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.invNo, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: HexColor('#333333')),),
                Text(model.anchor, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: HexColor('#333333')),),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(formatCurrency(model.total), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: HexColor('#333333')),),
                    Text(
                      model.uploaded?"Uploaded":"Draft",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: model.uploaded?HexColor("#219653"):HexColor("#828282")),
                    )

                  ],
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context1) => [
                    PopupMenuItem(

                      child: InkWell(
                        onTap: () async{
                          Navigator.pop(context1);
                          Navigator.push(
                            context1,
                            MaterialPageRoute(
                              builder: (context) => VendorMain(
                                  pageUrl: "/upload-kyc-document",
                                  mobileTitle: "Edit Your Invoice",
                                  menuList: false,
                                  backButton: true,
                                  pop: true,
                                  body: InvoiceBuilderEditPage(model: model,)),
                            ),
                          ).then((value) {
                            setState(() {

                            });
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.edit),
                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Edit Invoice',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.w400,
                                    color: Color.fromRGBO(
                                        51, 51, 51, 1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (model.complete && !model.uploaded && value(model.customerCin)!='')?PopupMenuItem(
                      onTap: () async{
                        Navigator.pop(context1);

                        dynamic invoice = getInvoiceDetails(model);

                        showDialog(
                          // barrierColor: Colors.transparent,
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context1) {
                              functionBack() {
                                Navigator.pop(context1);
                              }

                              return AlertDialog(
                                  backgroundColor: Colors
                                      .white,
                                  contentPadding:
                                  const EdgeInsets
                                      .fromLTRB(12.0,
                                      12.0, 12.0, 12.0),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius:
                                  //     BorderRadius.all(
                                  //         Radius.circular(
                                  //             32.0))),
                                  elevation: 0,
                                  content: InvoiceViewer(
                                    model: model,
                                    imageFromUrl: true,
                                    uploadForApproval: true,
                                    invoice: invoice,
                                    imageUrl: model.img,
                                  ));
                            }).then((value) {
                          setState(() {

                          });
                        });



                      },
                      child: InkWell(
                        //onTap: () async {},
                        child: Row(
                          children: [
                            const Icon(Icons.upload),
                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Upload for approval',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.w400,
                                    color: Color.fromRGBO(
                                        51, 51, 51, 1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):null,
                    PopupMenuItem(
                      onTap: () async{
                        Navigator.pop(context1);

                        await showDialog(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'Are you sure you want to delete invoice\nwith invoice number ${model.invNo}?')

                                    // Text('Would you like to approve of this message?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    dynamic response = await provider
                                        .deleteInvoiceDraft(model.invNo);
                                    if (response['status'] == 'success') {
                                      showToast(
                                          'Invoice deleted successfully',
                                          context);
                                    } else {
                                      showToast(
                                          'Invoice could not be deleted',
                                          context,
                                          type: 'warning');
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          setState(() {});
                        });

                      },
                      child: InkWell(
                        //onTap: () async {},
                        child: Row(
                          children: [
                            const Icon(Icons.delete),
                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Delete Invoice',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.w400,
                                    color: Color.fromRGBO(
                                        51, 51, 51, 1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  void getData() async{

    dynamic _data;
    dynamic _items;

    _data = await Provider.of<VendorActionProvider>(context, listen: false)
        .getCompanyName();
    _items = _data['data'];
    companyDetails = _data;
    if (_data['res'] == 'success') {
      anchorNameList = _items;
      anchorTerm = [];
      cuGst['stanbic IBTC'] = 'X22141733973XXX';
      cacAddress['stanbic IBTC'] = 'RC1001781 ( Okotie-eboh )';
      _items.forEach((element) {
        anchorTerm.add(element['name'].toString());
        cuGst[element['name'].toString()] = element['cu_gst'];
        cacAddress[element['name'].toString()] = element['name_address'];
        //anchorTerm = ['test1'];
        _isBlackListed[element['name'].toString()] =
        element['isBlacklisted'] != null
            ? element['isBlacklisted'] == '1'
            ? true
            : false
            : false;
      });

      capsaPrint('\n\n$cacAddress \n\n$cuGst');

  }}

  InvoiceModel getInvoiceDetails(InvoiceBuilderModel model){

    final Box box = Hive.box('capsaBox');

    var userData = box.get('userData');

    final InvoiceModel invoice = InvoiceModel(
      cuGst: cuGst[model.anchor] ?? "1234",
      anchor: model.anchor,
      cacAddress: cacAddress[model.anchor] ?? 'XXX123XXX',
      invNo: model.invNo,
      poNo: model.poNo,
      date: DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(model.invDate)) ,
      invDate: DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(model.invDate)) ,
      invDueDate: DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(model.invDueDate)) ,
      terms: model.tenure,
      invAmt: model.total,
      // invDueDate:
      //     dueDateCont.text,
      invAmount: model.total,
      details: model.notes,
      invSell: model.total,
      buyNowPrice: '0',
      rate: '0',
      tenureDaysDiff: model.tenure,

      fileType: '.png',
      bvnNo: userData['panNumber'],
    );

    return invoice;

  }

  @override
  void initState(){
    super.initState();
    getData();
  }





  @override
  Widget build(BuildContext context) {
    InvoiceBuilderProvider _invoiceBuilderProvider =  Provider.of<InvoiceBuilderProvider>(context,
        listen: false);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
          child: Column(
            children: [
              if (!Responsive.isMobile(context))
                SizedBox(
                  height: 22,
                ),
              TopBarWidget("Invoice Builder History",
                  "History of invoices that you have built"),
              if (!Responsive.isMobile(context))
                SizedBox(
                  height: 15,
                ),

              Container(
                // padding: EdgeInsets.all((!Responsive.isMobile(context)) ? 12 : 1.0),
                // color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: Responsive.isMobile(context)?140:200,
                        height: (!Responsive.isMobile(context)) ? 59 : 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Colors.white,
                        ),
                        padding: Responsive.isMobile(context)
                            ? EdgeInsets.symmetric(horizontal: 5, vertical: 2)
                            : EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: TextFormField(
                          // autofocus: false,
                          onChanged: (v) {
                            _search = v;
                            if (v == "") {
                              setState(() {});
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // fillColor: Color.fromRGBO(234, 233, 233, 1.0),
                            // filled: true,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,

                            // contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                            suffixIcon: IconButton(
                              onPressed: () {
                                // type

                                setState(() {});
                              },
                              icon: Icon(Icons.search),
                            ),
                            // isDense: true,
                            // focusedBorder: InputBorder.none,
                            // enabledBorder: InputBorder.none,
                            // errorBorder: InputBorder.none,
                            // disabledBorder: InputBorder.none,
                            // contentPadding: EdgeInsets.only(left: 15, bottom: 15, top: 15, right: 15),
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(130, 130, 130, 1),
                                fontFamily: 'Poppins',
                                fontSize: (!Responsive.isMobile(context)) ? 18 : 15,
                                letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                            hintText: Responsive.isMobile(context)
                                ? "Search by invoice number"
                                : "Search by invoice number, Anchor name",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          context.beamToReplacementNamed('/invoice-builder');
                        },
                        child: Container(
                          width: Responsive.isMobile(context)?50:200,
                          height: (!Responsive.isMobile(context)) ? 59 : 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            color: HexColor('#0098DB'),
                          ),
                          padding: Responsive.isMobile(context)
                              ? EdgeInsets.symmetric(horizontal: 5, vertical: 2)
                              : EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Center(
                            child: Text('New Invoice', style: GoogleFonts.poppins(fontSize: Responsive.isMobile(context)?14:18, fontWeight: FontWeight.w500,color: Colors.white),),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              FutureBuilder<Object>(
                  future: Provider.of<InvoiceBuilderProvider>(context,
                          listen: false)
                      .getInvoiceList(_search),
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
                    } else if (snapshot.hasData) {
                      List<InvoiceBuilderModel> data = snapshot.data;

                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(25, 0, 0, 0),
                              offset: Offset(5.0, 5.0),
                              blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Color.fromARGB(255, 255, 255, 255),
                              offset: Offset(-5.0, -5.0),
                              blurRadius: 0.0,
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: (Responsive.isMobile(context))
                              ? data.length > 0? Column(
                            children: [
                              for (var element in data)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: invoiceCard(element,_invoiceBuilderProvider),
                                )
                            ],
                          ):Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Sorry, No Results Found!',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ])
                              // Column(
                              //   children: [
                              //     for (var bids in dataSource)
                              //       InkWell(
                              //         onTap: () {
                              //           Beamer.of(context).beamToNamed(
                              //             '/history-details/' +
                              //                 bids.invoiceNumber,
                              //           );
                              //         },
                              //         child: Container(
                              //             width: double.infinity,
                              //             height: 90,
                              //             margin: EdgeInsets.all(11),
                              //             padding: EdgeInsets.all(8),
                              //             decoration: BoxDecoration(
                              //               color: HexColor("#F5FBFF"),
                              //               borderRadius: BorderRadius.only(
                              //                 topLeft:
                              //                 Radius.circular(10.0),
                              //                 topRight:
                              //                 Radius.circular(10.0),
                              //                 bottomRight:
                              //                 Radius.circular(10.0),
                              //                 bottomLeft:
                              //                 Radius.circular(10.0),
                              //               ),
                              //             ),
                              //             child: Row(
                              //                 mainAxisAlignment:
                              //                 MainAxisAlignment
                              //                     .spaceBetween,
                              //                 children: <Widget>[
                              //                   Container(
                              //                     decoration:
                              //                     BoxDecoration(),
                              //                     padding:
                              //                     EdgeInsets.symmetric(
                              //                         horizontal: 2,
                              //                         vertical: 2),
                              //                     child: Column(
                              //                       mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .start,
                              //                       crossAxisAlignment:
                              //                       CrossAxisAlignment
                              //                           .start,
                              //                       mainAxisSize:
                              //                       MainAxisSize.min,
                              //                       children: <Widget>[
                              //                         Text(
                              //                           bids.invoiceNumber,
                              //                           textAlign:
                              //                           TextAlign.left,
                              //                           style: TextStyle(
                              //                               color: Color
                              //                                   .fromRGBO(
                              //                                   51,
                              //                                   51,
                              //                                   51,
                              //                                   1),
                              //                               fontSize: 14,
                              //                               letterSpacing:
                              //                               0 /*percentages not used in flutter. defaulting to zero*/,
                              //                               fontWeight:
                              //                               FontWeight
                              //                                   .normal,
                              //                               height: 1),
                              //                         ),
                              //                         SizedBox(height: 20),
                              //                         Text(
                              //                           bids.customerName,
                              //                           textAlign:
                              //                           TextAlign.left,
                              //                           style: TextStyle(
                              //                               color: Color
                              //                                   .fromRGBO(
                              //                                   51,
                              //                                   51,
                              //                                   51,
                              //                                   1),
                              //                               fontSize: 14,
                              //                               letterSpacing:
                              //                               0 /*percentages not used in flutter. defaulting to zero*/,
                              //                               fontWeight:
                              //                               FontWeight
                              //                                   .normal,
                              //                               height: 1),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     decoration:
                              //                     BoxDecoration(),
                              //                     padding:
                              //                     EdgeInsets.symmetric(
                              //                         horizontal: 2,
                              //                         vertical: 2),
                              //                     child: Column(
                              //                       mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .start,
                              //                       crossAxisAlignment:
                              //                       CrossAxisAlignment
                              //                           .start,
                              //                       mainAxisSize:
                              //                       MainAxisSize.min,
                              //                       children: <Widget>[
                              //                         Text(
                              //                           formatCurrency(bids
                              //                               .invoiceValue),
                              //                           textAlign:
                              //                           TextAlign.right,
                              //                           style: TextStyle(
                              //                               color: Color
                              //                                   .fromRGBO(
                              //                                   51,
                              //                                   51,
                              //                                   51,
                              //                                   1),
                              //                               fontFamily:
                              //                               'Poppins',
                              //                               fontSize: 14,
                              //                               letterSpacing:
                              //                               0 /*percentages not used in flutter. defaulting to zero*/,
                              //                               fontWeight:
                              //                               FontWeight
                              //                                   .normal,
                              //                               height: 1),
                              //                         ),
                              //                         SizedBox(height: 20),
                              //                         Text(
                              //                           DateFormat(
                              //                               'yyyy-MM-dd')
                              //                               .format(bids
                              //                               .discountedDate)
                              //                               .toString(),
                              //                           textAlign:
                              //                           TextAlign.right,
                              //                           style: TextStyle(
                              //                               color: Color
                              //                                   .fromRGBO(
                              //                                   51,
                              //                                   51,
                              //                                   51,
                              //                                   1),
                              //                               fontSize: 14,
                              //                               letterSpacing:
                              //                               0 /*percentages not used in flutter. defaulting to zero*/,
                              //                               fontWeight:
                              //                               FontWeight
                              //                                   .normal,
                              //                               height: 1),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   )
                              //                 ])),
                              //       )
                              //   ],
                              // )
                              : data.length > 0
                                  ? DataTable(
                                      columns: dataTableColumn([
                                        "S/N",
                                        "Invoice No",
                                        "Buyer Name",
                                        "Anchor",
                                        "Total",
                                        "Status",
                                        ""
                                      ]),
                                      rows: <DataRow>[
                                        for (var element in data)
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(
                                                (++i).toString(),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                element.invNo,
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                element.vendor.toString(),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                element.anchor.toString(),
                                                style: dataTableBodyTextStyle,
                                              )),

                                              DataCell(Text(
                                                formatCurrency(element.total.toString()),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                element.uploaded?"Uploaded":"Draft",
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color:  element.uploaded?HexColor("#219653"):HexColor("#828282")),
                                              )),
                                              DataCell(
                                                  PopupMenuButton(
                                                icon: const Icon(Icons.more_vert),
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(

                                                    child: InkWell(
                                                      onTap: () async{
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          this.context,
                                                          MaterialPageRoute(
                                                            builder: (context) => VendorMain(
                                                                pageUrl: "/upload-kyc-document",
                                                                mobileTitle: "Edit Your Invoice",
                                                                menuList: false,
                                                                backButton: true,
                                                                pop: true,
                                                                body: InvoiceBuilderEditPage(model: element,)),
                                                          ),
                                                        ).then((value) {
                                                          setState(() {

                                                          });
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.edit),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: 'Edit Invoice',
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  color: Color.fromRGBO(
                                                                      51, 51, 51, 1)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  (element.complete && !element.uploaded && value(element.customerCin)!='')?PopupMenuItem(
                                                    onTap: () async{

                                                      dynamic invoice = getInvoiceDetails(element);

                                                      showDialog(
                                                        // barrierColor: Colors.transparent,
                                                          context: context,
                                                          //barrierDismissible: false,
                                                          builder: (BuildContext context1) {
                                                            functionBack() {
                                                              Navigator.pop(context1);
                                                            }

                                                            return AlertDialog(
                                                                backgroundColor: Colors
                                                                    .white,
                                                                contentPadding:
                                                                const EdgeInsets
                                                                    .fromLTRB(12.0,
                                                                    12.0, 12.0, 12.0),
                                                                // shape: RoundedRectangleBorder(
                                                                //     borderRadius:
                                                                //     BorderRadius.all(
                                                                //         Radius.circular(
                                                                //             32.0))),
                                                                elevation: 0,
                                                                content: InvoiceViewer(
                                                                  model: element,
                                                                  imageFromUrl: true,
                                                                  uploadForApproval: true,
                                                                  invoice: invoice,
                                                                  imageUrl: element.img,
                                                                ));
                                                          }).then((value) {
                                                            setState(() {

                                                            });
                                                      });



                                                    },
                                                    child: InkWell(
                                                      //onTap: () async {},
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.upload),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: 'Upload for approval',
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  color: Color.fromRGBO(
                                                                      51, 51, 51, 1)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ):null,
                                                  PopupMenuItem(
                                                    onTap: () async{

                                                      await showDialog(
                                                        context: context,
                                                        barrierDismissible: true, // user must tap button!
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text('Confirm'),
                                                            content: SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <Widget>[
                                                                  Text(
                                                                      'Are you sure you want to delete invoice\nwith invoice number ${element.invNo}?')

                                                                  // Text('Would you like to approve of this message?'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text('Yes'),
                                                                onPressed: () async {
                                                                  dynamic response = await _invoiceBuilderProvider
                                                                      .deleteInvoiceDraft(element.invNo);
                                                                  if (response['status'] == 'success') {
                                                                    showToast(
                                                                        'Invoice deleted successfully',
                                                                        context);
                                                                  } else {
                                                                    showToast(
                                                                        'Invoice could not be deleted',
                                                                        context,
                                                                        type: 'warning');
                                                                  }
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text('No'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ).then((value) {
                                                        setState(() {});
                                                      });

                                                    },
                                                    child: InkWell(
                                                      //onTap: () async {},
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.delete),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: 'Delete Invoice',
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  color: Color.fromRGBO(
                                                                      51, 51, 51, 1)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                              // DataCell(InkWell(
                                              //   onTap: () {
                                              //     Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //         builder: (context) => VendorMain(
                                              //             pageUrl: "/upload-kyc-document",
                                              //             mobileTitle: "Edit Your Invoice",
                                              //             menuList: false,
                                              //             backButton: true,
                                              //             pop: true,
                                              //             body: InvoiceBuilderEditPage(model: element,)),
                                              //       ),
                                              //     ).then((value) {
                                              //       setState(() {
                                              //
                                              //       });
                                              //     });
                                              //   },
                                              //   child: Icon(Icons.edit),
                                              // )),
                                            ],
                                          ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline_outlined,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                'Sorry, No Results Found!',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ]),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(child: Text("No history found."));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
