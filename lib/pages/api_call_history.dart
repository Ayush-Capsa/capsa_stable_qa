import 'package:beamer/src/beamer.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//import '../vendor_new.dart';
import 'package:http/http.dart' as http;

import '../admin/common/constants.dart';

class ApiCallHistory extends StatefulWidget {
  const ApiCallHistory({Key key}) : super(key: key);

  @override
  State<ApiCallHistory> createState() =>
      _ApiCallHistoryPageState();
}

class _ApiCallHistoryPageState extends State<ApiCallHistory> {

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
              TopBarWidget("API History",
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
                      child: InkWell(
                        // onTap: (){
                        //   context.beamToReplacementNamed('/invoice-builder');
                        // },
                        child: Visibility(
                          visible: false,
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

              FutureBuilder<Object>(
                  future: Provider.of<ProfileProvider>(context,
                      listen: false)
                      .callApiHistory(),
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
                      capsaPrint('Response : ${snapshot.data}');
                      dynamic response = snapshot.data;
                      List<ApiHistoryModel> historyModel = [];
                      dynamic apiHistoryDataSource = ApiHistoryDataSource(historyModel);
                      int _rowsPerPage = 10;
                      int _sortColumnIndex;
                      bool _sortAscending = true;

                      if(response['status'] == 'success'){
                        capsaPrint('Data length : ${response['data'].length}');
                        for(int i = 0; i<response['data'].length;i++){
                          historyModel.add(ApiHistoryModel(
                            endPoint: response['data'][i]['endpoint'].toString() ,
                            walletBalance: response['data'][i]['wallet_balance'].toString(),
                            amount: response['data'][i]['amount'].toString(),
                            refNo: response['data'][i]['ref_no'].toString(),
                            status: response['data'][i]['status'].toString(),
                            date: response['data'][i]['date'].toString(),
                          ));
                        }

                        apiHistoryDataSource = ApiHistoryDataSource(historyModel);

                      }

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
                          child: historyModel.length > 0
                              ? historyModel.length <= 30 ? DataTable(
                            columns: dataTableColumn([
                              "S/N",
                              "Endpoint",
                              "Date",
                              "Amount",
                              "Wallet Balance",
                              "Reference Number",
                              "Status"
                            ]),
                            rows: <DataRow>[
                              for (var element in historyModel)
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(
                                      (++i).toString(),
                                      style: dataTableBodyTextStyle,
                                    )),
                                    DataCell(Text(
                                      element.endPoint,
                                      style: dataTableBodyTextStyle,
                                    )),
                                    DataCell(Text(
                                      DateFormat('d MMM, y')
                                          .format(DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                          .parse(
                                          element.date))
                                          .toString(),
                                      style: dataTableBodyTextStyle,
                                    )),
                                    DataCell(Text(
                                      element.amount.toString(),
                                      style: dataTableBodyTextStyle,
                                    )),

                                    DataCell(Text(
                                      formatCurrency(element.walletBalance.toString()),
                                      style: dataTableBodyTextStyle,
                                    )),
                                    DataCell(Text(
                                      element.refNo.toString(),
                                      style: dataTableBodyTextStyle,
                                    )),

                                    DataCell(Text(
                                      element.status.toString(),
                                      style: dataTableBodyTextStyle,
                                    )),
                                  ],
                                ),
                            ],
                          ) : PaginatedDataTable(
                              dataRowHeight: 60,
                              columnSpacing: 42,
                              onPageChanged: (value) {
                                // capsaPrint('$value');
                              },
                              // columnSpacing: 110,
                              availableRowsPerPage: _rowsPerPage > historyModel.length ? [historyModel.length] : [5, 10, 20],
                              rowsPerPage: _rowsPerPage > historyModel.length ? historyModel.length : _rowsPerPage,
                              onRowsPerPageChanged: (int value) {
                                setState(() {
                                  _rowsPerPage = value;
                                });
                              },
                              // constrained : false,
                              sortColumnIndex: _sortColumnIndex,
                              sortAscending: _sortAscending,
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text('S/N',
                                      style: tableHeadlineStyle),
                                ),
                                DataColumn(
                                  label: Text('Endpoint',
                                      style: tableHeadlineStyle),
                                ),
                                DataColumn(
                                  // numeric: true,
                                  label: Text('Date',
                                      style: tableHeadlineStyle),
                                ),
                                // DataColumn(
                                //   // numeric: true,
                                //   label: Text('Seller', style: tableHeadlineStyle),
                                // ),
                                // DataColumn(
                                //   label: Text('Anchor', style: tableHeadlineStyle),
                                // ),
                                DataColumn(
                                  label: Text('Amount (N)',
                                      style: tableHeadlineStyle),
                                ),
                                // DataColumn(
                                //   label: Text('Buy Now\nAmount', style: tableHeadlineStyle),
                                // ),
                                DataColumn(
                                  // numeric: true,
                                  label: Text('Wallet Balance (N)',
                                      style: tableHeadlineStyle),
                                ),
                                DataColumn(
                                  // numeric: true,
                                  label: Text('Reference Number',
                                      style: tableHeadlineStyle),
                                ),

                                DataColumn(
                                  // numeric: true,
                                  label: Text('Status',
                                      style: tableHeadlineStyle),
                                ),
                              ],
                              source: apiHistoryDataSource)
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
