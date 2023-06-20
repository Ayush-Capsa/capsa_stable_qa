import 'package:beamer/src/beamer.dart';
import 'package:capsa/anchor/model/AnchorBulkInvoiceModel.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/data/ApiHistoryPageData.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/api_history_model.dart';
import 'package:capsa/providers/profile_provider.dart';
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
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//import '../vendor_new.dart';
import 'package:http/http.dart' as http;

import '../../admin/common/constants.dart';
import '../../main.dart';


class BulkUploadPreviewScreen extends StatefulWidget {
  List<BulkInvoiceModel> invoices;
  PlatformFile file;
  BulkUploadPreviewScreen({Key key, this.invoices, this.file}) : super(key: key);

  @override
  State<BulkUploadPreviewScreen> createState() =>
      _BulkUploadPreviewScreenPageState();
}

class _BulkUploadPreviewScreenPageState extends State<BulkUploadPreviewScreen> {

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

  bool saving = false;

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


  }

  InvoiceModel getInvoiceDetails(InvoiceBuilderModel model){

  }

  @override
  void initState(){
    super.initState();
    getData();
  }





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
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
                child: Column(
                  children: [
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        height: 22,
                      ),
                    TopBarWidget("Confirm Invoice Details",
                        ""),
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
                            child: Visibility(
                              visible: false,
                              child: InkWell(
                                // onTap: (){
                                //   context.beamToReplacementNamed('/invoice-builder');
                                // },
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
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
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
                        child: widget.invoices.length > 0
                            ? DataTable(
                          columns: dataTableColumn([
                            "S/N",
                            "Vendor Name",
                            "Invoice Number",
                            "Po. No.",
                            "Invoice Value",
                            "Tenure",
                            "Issue Date",
                            "Due Date"
                          ]),
                          rows: <DataRow>[
                            for (var element in widget.invoices)
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    element.sn,
                                    style: dataTableBodyTextStyle,
                                  )),
                                  DataCell(Text(
                                    element.vendorName,
                                    style: dataTableBodyTextStyle,
                                  )),
                                  DataCell(Text(
                                    element.invNo,
                                    style: dataTableBodyTextStyle,
                                  )),
                                  DataCell(Text(
                                    element.poNo.toString(),
                                    style: dataTableBodyTextStyle,
                                  )),

                                  DataCell(Text(
                                    formatCurrency(element.invValue.toString()),
                                    style: dataTableBodyTextStyle,
                                  )),
                                  // DataCell(Text(
                                  //   element.buyNowPrice.toString(),
                                  //   style: dataTableBodyTextStyle,
                                  // )),

                                  DataCell(Text(
                                    element.tenure.toString(),
                                    style: dataTableBodyTextStyle,
                                  )),

                                  DataCell(Text(
                                    element.issueDate.toString(),
                                    style: dataTableBodyTextStyle,
                                  )),

                                  DataCell(Text(
                                    element.dueDate.toString(),
                                    style: dataTableBodyTextStyle,
                                  )),
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
                    ),


                    SizedBox(height: 20,),


                    saving? CircularProgressIndicator() : InkWell(
                      onTap: () async {

                        setState(() {
                          saving = true;
                        });

                        dynamic response = await Provider.of<AnchorActionProvider>(context, listen: false).uploadMultiInvoiceCsv(widget.file);

                        dynamic errorList = response['errorList'];

                        capsaPrint('error list : ${errorList.length}');

                        if(response['res']  == 'success' && (errorList.length == 0)){
                          showToast('Invoices Uploaded Successfully', context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CapsaHome()
                            ),
                          );
                        }
                        else if(errorList!=null && errorList.length>0){
                          String error = '';
                          for(int i = 0;i<errorList.length;i++){
                            error = error + '\n' + errorList[i];
                          }

                          // for(int i = 0;i<10;i++){
                          //   error = error + '\n' + errorList[0];
                          // }

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                // title: Text(
                                //   '',
                                //   style: TextStyle(
                                //     fontSize: 24,
                                //     fontWeight: FontWeight.bold,
                                //     color: Theme.of(context).primaryColor,
                                //   ),
                                // ),
                                content: Container(
                                  // width: 800,
                                    height: Responsive.isMobile(context)?340:400,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:  [

                                          SizedBox(height: 12,),

                                          Image.asset('assets/icons/warning.png'),

                                          SizedBox(height: 12,),

                                          Text(
                                            'Incorrect Data',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),

                                          SizedBox(height: 12,),

                                          Container(
                                            height: 100,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    error,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 12,),

                                          Text(
                                            'Try uploading with correct file',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),

                                          SizedBox(height: 12,),

                                          InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CapsaHome()
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: Responsive.isMobile(context)?140 : 220,
                                              decoration: BoxDecoration(
                                                  color: HexColor('#0098DB'),
                                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Text(
                                                    'Okay',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
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
                                ),
                                //actions: <Widget>[],
                              ));
                        }else{
                          showToast('Something went wrong', context, type: 'warning');
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
                          color:
                          Color.fromRGBO(0, 152, 219, 1),
                        ),
                        child: saving
                            ? const Center(
                          child: Padding(
                            padding:
                            EdgeInsets.all(8.0),
                            child:
                            CircularProgressIndicator(
                              color: Color.fromRGBO(
                                  242, 242, 242, 1),
                            ),
                          ),
                        )
                            : Center(
                          child: Text(
                            'Upload',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(
                                  242, 242, 242, 1),
                              fontSize: 24,
                              letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
