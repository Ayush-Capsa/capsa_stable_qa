import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/bid_history_model.dart';
import 'package:capsa/vendor-new/data/vendor_history_data.dart';
import 'package:capsa/widgets/capsaapp/generatedframe96widget/GeneratedFrame96Widget.dart';
import 'package:capsa/providers/bid_history_provider.dart';
import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../admin/common/constants.dart';
import '../../common/constants.dart';
import '../../functions/export_to_csv.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _search = "";
  DateTime _selectedDate;
  DateTime _selectedDate2;
  final dateCont = TextEditingController();
  final dateCont2 = TextEditingController();

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
        ..text = DateFormat(' d / M / y').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateCont.text.length, affinity: TextAffinity.upstream));
      if (_selectedDate2 != null) setState(() {});
    }
  }

  _selectDate2(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate2 != null ? _selectedDate2 : DateTime.now(),
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
      _selectedDate2 = newSelectedDate;
      dateCont2
        ..text = DateFormat(' d / M / y').format(_selectedDate2)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateCont2.text.length, affinity: TextAffinity.upstream));
      setState(() {});
    }
  }

  void exportCSV(List<BidHistoryModel> dataSource) {
    {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      final find = ',';
      final replaceWith = '';
      List<List<dynamic>> rows = [];
      //capsaPrint('Length : ${bids.length}');
      rows.add([
        "S/N",
        "Invoice No",
        "Anchor Name",
        "Buyer Name",
        "Transaction\nDate",
        "Bid Amount",
        "Platform Fee",
      ]);
      int i = 0;
      //List<ClosingBalanceModel> finalList = sortList();
      for (var bids in dataSource) {
        List<dynamic> row = [];
        row.add(
          (++i).toString(),
        );
        row.add(
          bids.invoiceNumber,
        );
        row.add(
          bids.customerName,
        );
        row.add(
          bids.investorName,
        );
        row.add(
          DateFormat('dd/MM/yyyy').format(bids.discountedDate).toString(),
        );
        row.add(
          formatCurrency(bids.discountVal),
        );
        row.add(
          formatCurrency(bids.platFormFee),
        );
        rows.add(row);
      }

      String dataAsCSV = const ListToCsvConverter().convert(
        rows,
      );
      exportToCSV(dataAsCSV,
          fName: "Transaction_History_${userData['panNumber']}");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<BidHistoryModel> dataSource = [];
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context))
            SizedBox(
              height: 22,
            ),
          TopBarWidget(
              "Factored Invoices", "History of invoices that you have sold"),
          if (!Responsive.isMobile(context))
            SizedBox(
              height: 15,
            ),
          // if (!Responsive.isMobile(context))
          //   SizedBox(
          //     height: 15,
          //   ),
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
                  flex: 1,
                  child: Container(
                    width: 200,
                    height: (!Responsive.isMobile(context)) ? 65 : 60,
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
                if (!Responsive.isMobile(context)) SizedBox(width: 3),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'From',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                // fontFamily: 'Poppins',
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ),
                        SizedBox(width: 3),
                        SizedBox(
                          width: 220,
                          child: UserTextFormField(
                            label: "",
                            readOnly: true,
                            controller: dateCont,
                            prefixIcon: (_selectedDate != null)
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedDate = null;
                                        dateCont.text = "DD/MM/YYYY";
                                      });
                                    },
                                    child: Icon(Icons.close))
                                : null,
                            suffixIcon: Icon(Icons.date_range_outlined),
                            hintText: "DD/MM/YYYY",
                            onTap: () => _selectDate(context),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'To',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                // fontFamily: 'Poppins',
                                fontSize: 16,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ),
                        SizedBox(width: 3),
                        SizedBox(
                          width: 220,
                          child: UserTextFormField(
                            label: "",
                            readOnly: true,
                            controller: dateCont2,
                            prefixIcon: (_selectedDate2 != null)
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedDate2 = null;
                                        dateCont2.text = "DD/MM/YYYY";
                                      });
                                    },
                                    child: Icon(Icons.close))
                                : null,
                            suffixIcon: Icon(Icons.date_range_outlined),
                            hintText: "DD/MM/YYYY",
                            onTap: () => _selectDate2(context),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 10),
                        // currencyLoaded
                        //     ?
                        //     : Container(),
                      ],
                    ),
                  ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                    onTap: () {
                      exportCSV(dataSource);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.download),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Download',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                      ],
                    )),
              ],
            ),
          ),

          SizedBox(
            height: 15,
          ),
          Expanded(
            child: FutureBuilder<Object>(
                future: Provider.of<BidHistoryProvider>(context, listen: false)
                    .queryBidHistoryList(
                  search: _search,
                  date2: _selectedDate2,
                  date: _selectedDate,
                ),
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
                    final bidHistoryProvider =
                        Provider.of<BidHistoryProvider>(context, listen: false);
                    dataSource = bidHistoryProvider.bidHistoryDataList;

                    final VendorHistoryDataSource _historyDataSource =
                        VendorHistoryDataSource(
                      dataSource,
                    );

                    int _rowsPerPage = 20;
                    int _sortColumnIndex;
                    bool _sortAscending = true;

                    return Container(
                      width: double.infinity,
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
                            ? Column(
                                children: [
                                  for (var bids in dataSource)
                                    InkWell(
                                      onTap: () {
                                        Beamer.of(context).beamToNamed(
                                          '/history-details/' +
                                              bids.invoiceNumber,
                                        );
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          height: 90,
                                          margin: EdgeInsets.all(11),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: HexColor("#F5FBFF"),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                            ),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 2),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        bids.invoiceNumber,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    51,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 14,
                                                            letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            height: 1),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        bids.customerName,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    51,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 14,
                                                            letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            height: 1),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 2),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        formatCurrency(
                                                            bids.invoiceValue),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    51,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 14,
                                                            letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            height: 1),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(bids
                                                                .discountedDate)
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    51,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 14,
                                                            letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            height: 1),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ])),
                                    )
                                ],
                              )
                            : dataSource.length > 0
                                ? PaginatedDataTable(
                                    dataRowHeight: 60,
                                    columnSpacing: 42,
                                    onPageChanged: (value) {
                                      // capsaPrint('$value');
                                    },
                                    // columnSpacing: 110,
                                    availableRowsPerPage:
                                        _rowsPerPage > dataSource.length
                                            ? [dataSource.length]
                                            : [5, 10, 20],
                                    rowsPerPage:
                                        _rowsPerPage > dataSource.length
                                            ? dataSource.length
                                            : _rowsPerPage,
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
                                        label: Text('Invoice No',
                                            style: tableHeadlineStyle),
                                      ),
                                      DataColumn(
                                        // numeric: true,
                                        label: Text('Anchor Name',
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
                                        label: Text('Buyer Name',
                                            style: tableHeadlineStyle),
                                      ),
                                      // DataColumn(
                                      //   label: Text('Buy Now\nAmount', style: tableHeadlineStyle),
                                      // ),
                                      DataColumn(
                                        // numeric: true,
                                        label: Text('Transaction\nDate',
                                            style: tableHeadlineStyle),
                                      ),
                                      DataColumn(
                                        // numeric: true,
                                        label: Text('Bid Amount',
                                            style: tableHeadlineStyle),
                                      ),
                                      DataColumn(
                                        // numeric: true,
                                        label: Text('Platform Fee',
                                            style: tableHeadlineStyle),
                                      ),
                                      DataColumn(
                                        // numeric: true,
                                        label:
                                            Text('', style: tableHeadlineStyle),
                                      ),
                                    ],
                                    source: _historyDataSource)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                }),
          ),
        ],
      ),
    );
  }
}

class ViewAction extends StatelessWidget {
  final BidHistoryModel bids;

  const ViewAction(this.bids, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var urlDownload = "";
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    final actionProvider =
        Provider.of<VendorActionProvider>(context, listen: false);

    return InkWell(
        onTap: () {
          showDialog(
              // barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  // backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  title: Text(
                    bids.invoiceNumber,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                  content: Container(
                    // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(32))),
                    // width: MediaQuery.of(context).size.width * 0.6,
                    // height: MediaQuery.of(context).size.height * 0.8 ,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GeneratedFrame96Widget(
                                                "Invoice Value",
                                                bids.invoiceValue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GeneratedFrame96Widget(
                                                "Bid Amount",
                                                formatCurrency(bids.discountVal,
                                                    withIcon: true)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GeneratedFrame96Widget(
                                                "Purchase Price",
                                                formatCurrency(bids.netReturn,
                                                    withIcon: true)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Builder(builder: (context) {
                                              final sDate = DateTime.parse(
                                                  bids.startDate);
                                              final endDate =
                                                  DateTime.parse(bids.endDate);

                                              final difference = endDate
                                                  .difference(sDate)
                                                  .inDays;

                                              return GeneratedFrame96Widget(
                                                  "Tenure",
                                                  difference.toString() +
                                                      ' Days');
                                            }),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(bottom: 20),
                                          //   child: GeneratedFrame96Widget("Invoice No", bids.invoiceNumber),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GeneratedFrame96Widget(
                                                "Buyer Name",
                                                bids.investorName),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(bottom: 20),
                                          //   child: GeneratedFrame96Widget("Location", bids.address),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GeneratedFrame96Widget(
                                                "Anchor Name",
                                                bids.customerName),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GeneratedFrame96Widget(
                                                "Transaction Date",
                                                DateFormat('d/MM/yyyy')
                                                    .format(bids.discountedDate)
                                                    .toString()),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GeneratedFrame96Widget(
                                                "Discount Rate p.a",
                                                bids.askRate.toString()),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Download Bill of Sale',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    51, 51, 51, 1),
                                                // fontFamily: 'Poppins',
                                                fontSize: 18,
                                                letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (urlDownload == "") {
                                                return;
                                              }
                                              invoiceProvider.downloadFile(
                                                  urlDownload,
                                                  fName: "Bill of Sale");
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                color: Color.fromRGBO(
                                                    0, 152, 219, 1),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 16),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'Download',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            242, 242, 242, 1),
                                                        fontSize: 18,
                                                        letterSpacing:
                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        height: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: FutureBuilder<Object>(
                                  future: actionProvider
                                      .loadPurchaseAgreement2(bids),
                                  builder: (context, snapshot) {
                                    // capsaPrint(snapshot.data);
                                    dynamic _data = snapshot.data;
                                    if (snapshot.hasData) {
                                      if (_data['res'] == 'success') {
                                        var url = _data['data']['url'];
                                        urlDownload = url;
                                        // capsaPrint(url);
                                        return Column(
                                          children: [
                                            Expanded(
                                                child:
                                                    SfPdfViewer.network(url)),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.end,
                                            //   children: [
                                            //     ElevatedButton(
                                            //       onPressed: () {
                                            //         invoiceProvider.downloadFile(url);
                                            //         Navigator.of(context, rootNavigator: true).pop(); // dismisses only the dialog and returns nothing
                                            //       },
                                            //       child: new Text('Download'),
                                            //     ),
                                            //     SizedBox(
                                            //       width: 15,
                                            //     ),
                                            //     ElevatedButton(
                                            //       onPressed: () {
                                            //         Navigator.of(context, rootNavigator: true).pop(); // dismisses only the dialog and returns nothing
                                            //       },
                                            //       child: new Text('Close'),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: Container(
          child: Text(
            "View",
            style: TextStyle(color: HexColor("#0098DB")),
          ),
        ));
  }
}

class MHistoryDetails extends StatelessWidget {
  final inVNum;

  const MHistoryDetails(this.inVNum, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var urlDownload = '';
    final actionProvider =
        Provider.of<VendorActionProvider>(context, listen: false);
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);

    return FutureBuilder<Object>(
        future: Provider.of<BidHistoryProvider>(context, listen: false)
            .queryBidHistoryList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            BidHistoryModel bids;
            final bidHistoryProvider =
                Provider.of<BidHistoryProvider>(context, listen: false);
            List<BidHistoryModel> dataSource =
                bidHistoryProvider.bidHistoryDataList;

            int index = dataSource.indexWhere((element) {
              return inVNum == element.invoiceNumber;
            });
            if (index >= 0) {
              bids = dataSource[index];
            } else {
              return Container(
                child: Center(
                    child: Center(
                        child: InkWell(
                            onTap: () {
                              context.beamToNamed('/history');
                            },
                            child: Text("No Data Found. Click to go back")))),
              );
            }
            return Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneratedFrame96Widget(
                          "Invoice Value", bids.invoiceValue),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneratedFrame96Widget("Bid Amount",
                          formatCurrency(bids.discountVal, withIcon: true)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneratedFrame96Widget("Purchase Price",
                          formatCurrency(bids.netReturn, withIcon: true)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Builder(builder: (context) {
                        final sDate = DateTime.parse(bids.startDate);
                        final endDate = DateTime.parse(bids.endDate);

                        final difference = endDate.difference(sDate).inDays;

                        return GeneratedFrame96Widget(
                            "Tenure", difference.toString() + ' Days');
                      }),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 20),
                    //   child: GeneratedFrame96Widget("Invoice No", bids.invoiceNumber),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneratedFrame96Widget(
                          "Buyer Name", bids.investorName),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 20),
                    //   child: GeneratedFrame96Widget("Location", bids.address),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneratedFrame96Widget(
                          "Anchor Name", bids.customerName),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneratedFrame96Widget(
                          "Transaction Date",
                          DateFormat('d/MM/yyyy')
                              .format(bids.discountedDate)
                              .toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneratedFrame96Widget(
                          "Discount Rate p.a", bids.askRate.toString()),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      height: 500,
                      child: FutureBuilder<Object>(
                          future: actionProvider.loadPurchaseAgreement2(bids),
                          builder: (context, snapshot) {
                            // capsaPrint(snapshot.data);
                            dynamic _data = snapshot.data;
                            if (snapshot.hasData) {
                              if (_data['res'] == 'success') {
                                var url = _data['data']['url'];
                                urlDownload = url;
                                // capsaPrint(url);
                                return Column(
                                  children: [
                                    Expanded(child: SfPdfViewer.network(url)),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Download Bill of Sale',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            // fontFamily: 'Poppins',
                            fontSize: 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        if (urlDownload == "") {
                          return;
                        }

                        invoiceProvider.downloadFile(urlDownload,
                            fName: "Bill of Sale");
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromRGBO(0, 152, 219, 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Download',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  fontSize: 18,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              child: Center(
                  child: Center(
                      child: InkWell(
                          onTap: () {
                            context.beamToNamed('/history');
                          },
                          child: Text("No Data Found. Click to go back")))),
            );
          }
        });
  }
}
