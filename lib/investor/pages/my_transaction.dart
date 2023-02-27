import 'package:beamer/beamer.dart';

import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/investor/widgets/bid_cards.dart';
import 'package:capsa/models/bid_history_model.dart';
import 'package:capsa/providers/bid_history_provider.dart';
import 'package:capsa/widgets/user_input.dart';

import 'package:intl/intl.dart';

import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class MyTransactions extends StatefulWidget {
  const MyTransactions({Key key}) : super(key: key);

  @override
  State<MyTransactions> createState() => _MyBidsPageState();
}

class _MyBidsPageState extends State<MyTransactions> {
  String _search = '';
  DateTime _selectedDate;
  final dateCont = TextEditingController();

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
      setState(() {});
    }
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
          TopBarWidget("My Transactions", ""),
          Container(
            // padding: EdgeInsets.all((!Responsive.isMobile(context)) ? 12 : 1.0),
            // color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
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
                            'Date',
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
                    .myBidHistoryList(search: _search, date: _selectedDate, isonlyAccept: true),
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
                                        Beamer.of(context).beamToNamed('/transaction-details/' + bids.invoiceNumber);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(1),
                                        child: BibsCard(bids,false),
                                      ),
                                    )
                                ],
                              )
                            : DataTable(
                                dataRowHeight: 60,
                                columns: dataTableColumn(["S/N", "Vendor Name", "Bid Amount", "Transaction Date", "Status", ""]),
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
                                        DataCell(Text(
                                          formatCurrency(bids.discountVal, withIcon: true),
                                          style: dataTableBodyTextStyle,
                                        )),
                                        DataCell(Text(
                                          DateFormat('d MMM, y').format(bids.discountedDate).toString(),
                                          style: dataTableBodyTextStyle,
                                        )),
                                        DataCell(_status(bids)),
                                        DataCell(// Figma Flutter Generator Data1Widget - TEXT
                                            InkWell(
                                          onTap: () {
                                            context.beamToNamed('/transaction-details/' + bids.invoiceNumber);
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
                              ),
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

  Widget _status(BidHistoryModel bids) {
    // return Text(bids.historyStatus);
    String _text = 'Pending';
    dynamic clr = HexColor('#F2994A');
    if (bids.paymentStatus == '1') {
      _text = 'Closed';
      clr = HexColor("#EB5757");
    } else {
      if (bids.discount_status == 'true') {
        _text = 'Open';
        clr = Colors.green;
      } else {
        _text = 'Pending';
        clr = HexColor('#F2994A');
      }
    }

    return Text(
      _text,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: clr,
          // fontFamily: 'Poppins',
          fontSize: 15,
          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          fontWeight: FontWeight.normal,
          height: 1),
    );
  }
}
