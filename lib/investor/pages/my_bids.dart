import 'package:beamer/beamer.dart';

import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';
import 'package:capsa/investor/widgets/bid_cards.dart';
import 'package:capsa/models/bid_history_model.dart';
import 'package:capsa/providers/bid_history_provider.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class MyBidsPage extends StatefulWidget {
  const MyBidsPage({Key key}) : super(key: key);

  @override
  State<MyBidsPage> createState() => _MyBidsPageState();
}

class _MyBidsPageState extends State<MyBidsPage> {
  String _search = '';
  DateTime _selectedDate;
  final dateCont = TextEditingController();
  DateTime _selectedDate2;
  final dateCont2 = TextEditingController();

  // dynamic anchor;
  // TextEditingController currencyController = TextEditingController(text: 'All');
  // String selectedCurrency = "";
  // bool checking = false;
  // Map<String, String> currencyAvailability = {};
  // List<String> term = ['All'];
  // bool currencyLoaded = false;
  //
  //
  // void getData() async {
  //   InvoiceProvider _invoiceProvider =
  //   Provider.of<InvoiceProvider>(context, listen: false);
  //   Map<dynamic, dynamic> _data = {};
  //   _data = await _invoiceProvider.getCurrencies();
  //   term = [];
  //   var _items = _data['data'];
  //   term.add('All');
  //   _items.forEach((element) {
  //     term.add(element['currency_code'].toString());
  //     currencyAvailability[element['currency_code']] =
  //         element['is_active'].toString();
  //   });
  //   selectedCurrency = term[0];
  //   setState(() {
  //     currencyLoaded = true;
  //   });
  // }

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
        ..selection = TextSelection.fromPosition(TextPosition(offset: dateCont.text.length, affinity: TextAffinity.upstream));
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
        ..selection = TextSelection.fromPosition(TextPosition(offset: dateCont2.text.length, affinity: TextAffinity.upstream));
      setState(() {});
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          TopBarWidget("My Bids", ""),
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
                  flex: 1,
                  child: Container(
                    // width: 200,
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
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                        hintText: Responsive.isMobile(context) ? "Search by Anchor Name, Status" : "Search by invoice number, Anchor name, Status",
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
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
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
                        SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'To',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                // fontFamily: 'Poppins',
                                fontSize: 16,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
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
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: FutureBuilder<Object>(
                future: Provider.of<BidHistoryProvider>(context, listen: false)
                    .myBidHistoryList(search: _search, date: _selectedDate, date2: _selectedDate2,),
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
                    final bidHistoryProvider = Provider.of<BidHistoryProvider>(context, listen: false);
                    List<BidHistoryModel> dataSource = bidHistoryProvider.bidHistoryDataList;

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
                                        Beamer.of(context).beamToNamed('/bid-details/' + bids.invoiceNumber + '/' + bids.discountVal);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        // padding: EdgeInsets.all(1),
                                        child: BibsCard(bids,true),
                                      ),
                                    )
                                ],
                              )
                            :dataSource.length > 0
                            ? DataTable(
                                dataRowHeight: 60,
                                columns: dataTableColumn(["S/N", "Vendor Name", "Anchor Name", "Invoice Amount", "Bid Amount", "Currency", "Status", ""]),
                                rows: <DataRow>[
                                  for (var bids in dataSource)
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(
                                          (++i).toString(),
                                          style: dataTableBodyTextStyle,
                                        )),
                                        DataCell(SizedBox(
                                          width: 150,
                                          child: Text(
                                            bids.companyName,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: dataTableBodyTextStyle,
                                          ),
                                        )),
                                        DataCell(SizedBox(
                                          width: 150,
                                          child: Text(
                                            bids.customerName,
                                            style: dataTableBodyTextStyle,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                        DataCell(Text(
                                          formatCurrency(bids.invoiceValue, ),
                                          style: dataTableBodyTextStyle,
                                        )),
                                        DataCell(Text(
                                          formatCurrency(bids.discountVal, ),
                                          style: dataTableBodyTextStyle,
                                        )),
                                        DataCell(Text(
                                          bids.currency,
                                          style: dataTableBodyTextStyle,
                                        )),
                                        DataCell(_status(bids)),
                                        DataCell(// Figma Flutter Generator Data1Widget - TEXT
                                            InkWell(
                                          onTap: () {
                                            Beamer.of(context).beamToNamed('/bid-details/' + bids.invoiceNumber + '/' + bids.discountVal);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'View',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(0, 152, 219, 1),
                                                  // fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                ],
                              ): Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
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
                                        fontWeight:
                                        FontWeight.w500,
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

  List<String> status = [
    'Accepted',
    'Pending',
    'Rejected'
  ];

  Widget _status(BidHistoryModel bids) {
    // return Text(bids.historyStatus);
    String _text = 'Pending';
    var clr = Color.fromRGBO(235, 87, 87, 1);
    if (bids.historyStatus == '0') {
      _text = 'Pending';
      clr = HexColor('#F2994A');
    } else if (bids.historyStatus == '1') {
      _text = 'Accepted';
      clr = HexColor("#219653");
    } else if (bids.historyStatus == '2') {
      _text = 'Rejected';
      clr = Color.fromRGBO(235, 87, 87, 1);
    }

    return Text(
      _text,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: clr,
          // fontFamily: 'Poppins',
          fontSize: Responsive.isMobile(context) ? 12 : 15,
          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          fontWeight: FontWeight.normal,
          height: 1),
    );
  }
}

