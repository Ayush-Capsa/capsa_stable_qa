import 'package:capsa/vendor-new/dialog_boxes/pdf_dialog_box.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/vendor-new/pages/edit_invoice.dart';
import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:intl/intl.dart';

class InvoiceListPageBackup extends StatefulWidget {
  final String type;

  InvoiceListPageBackup(this.type, {Key key}) : super(key: key);

  @override
  State<InvoiceListPageBackup> createState() => _InvoiceListPageBackupState();
}

class _InvoiceListPageBackupState extends State<InvoiceListPageBackup> {
  var _search = "";

  void navigate() {
    Beamer.of(context).beamToNamed('/upload-account-letter');
  }

  InvoiceProvider invoiceProvider;

  List<TableRow> rows = [];
  bool dataLoaded = false;
  String search = "";
  dynamic data = null;
  dynamic fetchedData = null;
  int current_index = 1;
  int total_pages = 1;

  String title = "";

  List<bool> expand = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Text status(int status, int ilcStatus) {
    String s = status == 1
        ? 'Not Presented'
        : status == 2
            ? 'Pending'
            : status == 3
                ? 'Live'
                : 'Rejected';
    Color c = status == 1
        ? HexColor('#828282')
        : status == 2
            ? Colors.yellow
            : status == 3
                ? HexColor('#219653')
                : HexColor('#EB5757');

    if(ilcStatus == 2){
      s = 'Sold';
      c = HexColor('#EB5757');
    }

    return Text(
      s,
      style: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w400, color: c),
    );
  }

  List<dynamic> searchData(List<dynamic> table, String search) {
    List<dynamic> result = [];
    print('Data1 $search');
    if (search == "") {
      return table;
    }
    table.forEach((element) {
      int a = element['invoice_number']
          .toString()
          .toLowerCase()
          .compareTo(search.toLowerCase());
      int b = element['customer_name']
          .toString()
          .toLowerCase()
          .compareTo(search.toLowerCase());
      if (a == 0 || b == 0) {
        result.add(element);
      }
    });
    if (result.isEmpty) {
      showToast('No Data Found', context, type: "warning");
      return table;
    }
    return result;
  }

  void getData(String type,int page) async {
    print('Data Received 0');
    rows = [];
    InvoiceProvider _invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    print('Data Received 0.1');
    fetchedData == null
        ? fetchedData = await _invoiceProvider.queryInvoiceList(type)
        : fetchedData = fetchedData;

    data = searchData(fetchedData['data']['invoicelist'], search);
    print('Data Received 0.2');
    total_pages = ((data.length~/10)+1);
    print('Data Received 1');
    //print('Data : $data');

    // data['data']['invoicelist'].forEach((_element){
    //  print('$_element \n\n') ;
    // }
    // );
    //print('Invoice Data : ${data['data']['invoicelist']}');

    // int x = 0,y = 0;
    // while(x<5 || y>=data['data']['invoiceList'].length){
    //   if(data['data']['invoiceList'][y]['isSplit'] == '1'){
    //     print('DATA $y \n${data['data']['invoiceList'][y]}\n\n');
    //     x++;
    //   }
    //   y++;
    // }

    rows.add(TableRow(children: [
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(' ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('S/N',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Invoice No',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Issue Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Due Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Anchor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Invoice Amount (₦)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(' ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
      )
    ]));
    print('Data Received 2');

    int begin = (page-1)*10;
    int limit = ((data.length - begin)>10)?(begin+9):(data.length - begin - 1);
    print('Data Received 3');

    for (int i = begin; i <= limit; i++) {
      print('$i $limit ${data[i]}\n\n');

      rows.add(TableRow(children: [
        Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  data[i]['isSplit'] == null
                      ? expand[i] = expand[i]
                      : data[i]['isSplit'].toString() == '1'
                          ? expand[i] = !expand[i]
                          : expand[i] = expand[i];
                  getData(type,current_index);
                });
              },
              child: data[i]['isSplit'] == null
                  ? Text('')
                  : data[i]['isSplit'].toString() == '1'
                      ? expand[i] == true
                          ? Icon(Icons.arrow_drop_down_sharp)
                          : Icon(Icons.arrow_right_sharp)
                      : Text(''),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text((i + 1).toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
              data[i]['invoice_number'] == null
                  ? ''
                  : data[i]['invoice_number'].toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: data[i]['invoice_date'] == null
              ? ''
              : Text(
                  DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
                      .parse((data[i]['invoice_date']))),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: data[i]['invoice_due_date'] == null
              ? ''
              : Text(
                  DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
                      .parse((data[i]['invoice_due_date']))),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: data[i]['customer_name'] == null
              ? ''
              : Text(data[i]['customer_name'].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: data[i]['invoice_value'] == null
              ? ''
              : Text(data[i]['invoice_value'].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: data[i]['status'] == null
                ? Text('')
                : status(int.parse(data[i]['status'].toString()),int.parse(data[i]['ilcStatus'].toString()))),
        Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: data[i]['status'] == null
                ? Text('')
                : data[i]['status'].toString() == '1'
                    ? PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              onTap: () {
                                // capsaPrint('view Tapped');
                                setState(() {
                                  // dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);

                                  DateTime date = DateFormat("yyyy-MM-dd")
                                      .parse((data[i]['invoice_date']));
                                  DateTime dueDate = DateFormat("yyyy-MM-dd")
                                      .parse((data[i]['invoice_due_date']));
                                  String date0 = DateFormat.yMMMd('en_US')
                                      .format(DateFormat("yyyy-MM-dd")
                                          .parse((data[i]['invoice_date'])));
                                  String dueDate0 = DateFormat.yMMMd('en_US')
                                      .format(DateFormat("yyyy-MM-dd").parse(
                                          (data[i]['invoice_due_date'])));

                                  dynamic invoiceFormData = {
                                    "invoiceNo":
                                        data[i]['invoice_number'].toString(),
                                    "poNumber": "",
                                    "tenure": "",
                                    "invAmt":
                                        data[i]['invoice_value'].toString(),
                                    "butAmt": data[i]['ask_amt'].toString(),
                                    "details":
                                        data[i]['description'].toString(),
                                    "anchor": null,
                                    "anchorAddress": null,
                                    "dateCont": date0.toString(),
                                    "tenureDaysDiff": '',
                                    "rate": data[i]['ask_rate'].toString(),
                                    "dueDateCont": dueDate0.toString(),
                                    "fileCont": '',
                                    "_selectedDate": date,
                                    "_selectedDueDate": dueDate,
                                    "file": null,
                                    "cuGst": data[i]['customer_gst'].toString(),
                                  };

                                  invoiceProvider
                                      .setInvoiceFormData(invoiceFormData);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditInvoice(
                                              data: data[i],
                                            )),
                                  );
                                });
                              },
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Edit Invoice',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          PopupMenuItem(
                              onTap: () {
                                // capsaPrint('view Tapped');
                                setState(() {
                                  showDialog(
                                      context: context,
                                      builder: (context) => pdfDialogBox(
                                            invoiceProvider: _invoiceProvider,
                                            fileName: data[i]['invoice_file'],
                                          ));
                                });
                              },
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_red_eye),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'View Invoice',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          PopupMenuItem(
                              onTap: () {
                                invoiceProvider.deleteInvoice(
                                    data[i]['invoice_number'],
                                    data[i]['company_pan']);
                                setState(() {
                                  dataLoaded = false;
                                });
                                fetchedData = null;
                                getData(widget.type,current_index);
                              },
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Delete',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )
                    : PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              onTap: () {
                                // capsaPrint('view Tapped');
                                setState(() {
                                  showDialog(
                                      context: context,
                                      builder: (context) => pdfDialogBox(
                                            invoiceProvider: _invoiceProvider,
                                            fileName: data[i]['invoice_file'],
                                          ));
                                });
                              },
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_red_eye),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'View Invoice',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          PopupMenuItem(
                              onTap: () {
                                // capsaPrint('view Tapped');
                                invoiceProvider.deleteInvoice(
                                    data[i]['invoice_number'],
                                    data[i]['company_pan']);
                                setState(() {
                                  dataLoaded = false;
                                });
                                fetchedData = null;
                                getData(widget.type,current_index);
                              },
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Delete',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ))
      ]));

      if (expand[i]) {
        int j = 0;
        if (data[i]['isSplit'].toString() == '1') {
          print('CHILD INVOICE: ${data[i]['chileInvoice'][0]}');
          data[i]['chileInvoice'].forEach((_element) {
            rows.add(TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(''),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${i + 1}.${j + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_element['invoice_number'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
                        .parse((_element['invoice_date']))),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    DateFormat.yMMMd('en_US').format(DateFormat("yyyy-MM-dd")
                        .parse((_element['invoice_due_date']))),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_element['customer_name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_element['invoice_value'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: status(_element['status'],_element['ilcStatus']),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () {
                            // capsaPrint('view Tapped');
                            setState(() {
                              showDialog(
                                  context: context,
                                  builder: (context) => pdfDialogBox(
                                        invoiceProvider: _invoiceProvider,
                                        fileName: data[i]['invoice_file'],
                                      ));
                            });
                          },
                          child: InkWell(
                            child: Row(
                              children: [
                                Icon(Icons.remove_red_eye),
                                RichText(
                                  text: TextSpan(
                                    text: 'View Invoice',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(51, 51, 51, 1)),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      PopupMenuItem(
                          onTap: () {
                            // capsaPrint('view Tapped');
                            invoiceProvider.deleteInvoice(
                                data[i]['invoice_number'],
                                data[i]['company_pan']);
                            setState(() {
                              dataLoaded = false;
                            });
                            fetchedData = null;
                            getData(widget.type,current_index);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(
                                width: 8,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Delete',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(51, 51, 51, 1)),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ))
            ]));
            j++;
          });
        }
      }
    }
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    var _type = widget.type;
    if (widget.type == 'notPresented') {
      _type = 'notPresented';
    }

    invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);

    title = _type == 'all'
        ? 'All Invoice'
        : _type == 'pending'
            ? 'Pending Invoice'
            : _type == 'not Presenented'
                ? 'Not Presented Invoice'
                : 'Sold Invoice';

    super.initState();
    getData(_type,current_index);
    //widget.type == 'all'?getData(_type):getDataFromProvider();
  }

  @override
  Widget build(BuildContext context) {
    var _type = widget.type;
    if (widget.type == 'notPresented') {
      _type = 'not Presented';
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 25.0),
      child: Container(
        child: dataLoaded
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 22,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(29, 0, 36, 0),
                        child: TopBarWidget(title, ""),
                      ),
                      SizedBox(
                        height: (!Responsive.isMobile(context)) ? 8 : 15,
                      ),
                      Container(
                        // padding: EdgeInsets.all((!Responsive.isMobile(context)) ? 12 : 1.0),
                        // color: Colors.white,
                        //width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(29, 24, 36, 0),
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                // width: 200,
                                height:
                                    (!Responsive.isMobile(context)) ? 65 : 60,
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
                                    ? EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2)
                                    : EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                child: Center(
                                  child: TextFormField(
                                    // autofocus: false,
                                    onChanged: (v) {
                                      search = v;
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
                                          setState(() {
                                            getData(_type,current_index);
                                          });
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
                                          color:
                                              Color.fromRGBO(130, 130, 130, 1),
                                          fontFamily: 'Poppins',
                                          fontSize:
                                              (!Responsive.isMobile(context))
                                                  ? 18
                                                  : 15,
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
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            InkWell(
                              onTap: () {
                                context.beamToNamed("/addInvoice");
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
                                    'Add Invoice',
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
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(29, 24, 36, 33),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1.2),
                                  2: FlexColumnWidth(2.4),
                                  3: FlexColumnWidth(2.4),
                                  4: FlexColumnWidth(2.4),
                                  5: FlexColumnWidth(3.4),
                                  6: FlexColumnWidth(2.8),
                                  7: FlexColumnWidth(2.8),
                                  8: FlexColumnWidth(0.9),
                                },
                                border: TableBorder(
                                    verticalInside: BorderSide.none),
                                children: rows,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(900, 10, 15, 16),
                              child: Card(
                                color: Color.fromRGBO(245, 251, 255, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  width: 290,
                                  height: 56,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            24, 17.5, 24, 17.5),
                                        child: Text(
                                          'Page',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  51, 51, 51, 1)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 17.5, 30, 17.5),
                                        child: Text(
                                          '$current_index of $total_pages',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  51, 51, 51, 1)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 22, 30, 22),
                                        child: IconButton(
                                            onPressed: () {
                                              if(current_index>1){
                                                current_index--;
                                                getData(widget.type, current_index);
                                              }
                                            },
                                            icon: Icon(Icons.arrow_back_ios),
                                            iconSize: 14,
                                            color: Color.fromRGBO(
                                                130, 130, 130, 1),
                                            padding: EdgeInsets.all(0)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 22, 14, 22),
                                        child: IconButton(
                                            onPressed: () {
                                              if(current_index<total_pages){
                                                current_index++;
                                                getData(widget.type, current_index);
                                              }
                                            },
                                            icon: Icon(Icons.arrow_forward_ios),
                                            iconSize: 14,
                                            color: Color.fromRGBO(
                                                130, 130, 130, 1),
                                            padding: EdgeInsets.all(0)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class PageBody1 extends StatelessWidget {
  final String type, search;

  const PageBody1(this.type, this.search, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: Provider.of<InvoiceProvider>(context, listen: false)
            .queryInvoiceList(type, search: search),
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
            final invProvider =
                Provider.of<InvoiceProvider>(context, listen: false);

            List<InvoiceModel> _invList = invProvider.getInvoicesFilter(type);
            int i = 0;
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
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
                    ? mobileViewList(context, _invList)
                    : DataTable(
                        columns: dataTableColumn([
                          "S/N",
                          "Invoice No",
                          "Issue Date",
                          "Due Date",
                          "Anchor",
                          "Amount(₦)",
                          "Status",
                          ""
                        ]),
                        rows: <DataRow>[
                          for (var invoices in _invList)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  (++i).toString(),
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  invoices.invNo,
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  invoices.invDate,
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  invoices.invDueDate,
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  invoices.anchor,
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(Text(
                                  formatCurrency(invoices.invAmt),
                                  style: dataTableBodyTextStyle,
                                )),
                                DataCell(statusShow(invoices)),
                                DataCell(ViewAction(invoices)),
                              ],
                            ),
                        ],
                      ),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text("No history found."));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget statusShow(InvoiceModel invoices) {
    String _text = 'Pending';
    TextStyle textStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: HexColor("#333333"));

    if (invoices.invStatus == '1') {
      _text = "Not Presented";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#828282"));
    }
    if (invoices.invStatus == '2' && invoices.ilcStatus == '1') {
      _text = "Pending";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#F2994A"));
    }
    if (invoices.discount_status == 'false' &&
        invoices.payment_status == '0' &&
        invoices.ilcStatus == '2') {
      _text = "Live";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#219653"));
    }
    if (invoices.invStatus == '4') {
      _text = "Rejected";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#EB5757"));
    }
    if (invoices.discount_status == 'true') {
      _text = "Sold";
      textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: HexColor("#EB5757"));
    }
    return Text(
      _text,
      style: textStyle,
    );
  }

  Widget mobileViewList(BuildContext context, List<InvoiceModel> invList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //   borderRadius : BorderRadius.only(
      //     topLeft: Radius.circular(25),
      //     topRight: Radius.circular(25),
      //     bottomLeft: Radius.circular(25),
      //     bottomRight: Radius.circular(25),
      //   ),
      //   boxShadow : [BoxShadow(
      //       color: Color.fromRGBO(0, 0, 0, 0.15000000596046448),
      //       offset: Offset(0,2),
      //       blurRadius: 4
      //   )],
      //   color : Color.fromRGBO(255, 255, 255, 1),
      // ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var invoices in invList)
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Color.fromRGBO(245, 251, 255, 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: InkWell(
                      onTap: () {
                        Beamer.of(context)
                            .beamToNamed('/viewInvoice/' + Uri.encodeComponent(invoices.invNo));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    invoices.invNo,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        // fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    invoices.anchor,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        // fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    formatCurrency(invoices.invAmt),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  SizedBox(height: 8),
                                  statusShow(invoices),
                                  // Text(
                                  //   // invoices.invDate,
                                  //   statusShow(invoices),
                                  //   textAlign: TextAlign.right,
                                  //   style: TextStyle(
                                  //       color: Color.fromRGBO(33, 150, 83, 1),
                                  //       // fontFamily: 'Poppins',
                                  //       fontSize: 14,
                                  //       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  //       fontWeight: FontWeight.normal,
                                  //       height: 1),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViewAction extends StatelessWidget {
  final InvoiceModel invoices;

  const ViewAction(this.invoices, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'One';
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);

    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: HexColor("#828282"),
        ),
        onSelected: (menu) async {
          if (menu == 1) {
            Beamer.of(context).beamToNamed('/viewInvoice/' +Uri.encodeComponent(invoices.invNo));
          } else if (menu == 2) {
            showToast("Please wait...", context, type: "info");
            dynamic _data = await callApi('dashboard/a/getInvFile',
                body: {'fName': invoices.fileType});
            if (_data['res'] == 'success') {
              var url = _data['data']['url'];
              invoiceProvider.downloadFile(url);
            } else {}
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("View"),
                value: 1,
              ),
              PopupMenuItem(
                child: Text("Download"),
                value: 2,
              )
            ]

        // child: Image.asset("assets/icons/dot_menu.png",width: 24,height: 24,),
        );
  }
}

// class InvoiceListMode{
//   String invNo;
//   String
// }