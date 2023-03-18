import 'package:beamer/beamer.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:capsa/investor/pages/portfolio_page/bid_details_page.dart';
import 'package:capsa/investor/widgets/bid_cards.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/common/constants.dart';

import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';

import 'package:capsa/models/bid_history_model.dart';
import 'package:capsa/providers/bid_history_provider.dart';

import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:csv/csv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

import '../../investor_new.dart';

class BidsAnalysis extends StatefulWidget {
  String selectedCurrency;
  BidsAnalysis({Key key, this.selectedCurrency}) : super(key: key);

  @override
  State<BidsAnalysis> createState() => _BidsAnalysisState();
}

class _BidsAnalysisState extends State<BidsAnalysis> {
  String _search = '';
  DateTime _selectedDate;
  DateTime _selectedToDate;
  final dateCont = TextEditingController();
  final toDateCont = TextEditingController();
  List<String> status = ['All', 'Open', 'Closed', 'OverDue'];

  String selectedStatus = 'All';
  dynamic sts;

  var currenciesData;
  bool currenciesLoaded = false;
  dynamic anchor;
  TextEditingController currencyController = TextEditingController();
  String selectedCurrency = "All";
  bool checking = false;
  Map<String, String> currencyAvailability = {};
  List<String> currencyTerm = ['All'];
  List<BidHistoryModel> dataSource = [];

  Future<Object> getCurrencies() async {
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));

      var _body = {};

      dynamic _uri = 'dashboard/r/getCurrenciesAvailable';

      currenciesData = await callApi(_uri, body: _body);
      var _items = currenciesData['data'];
      Map<String, bool> _isBlackListed = {};

      var currencyList = [];

      if (currenciesData['msg'] == 'success') {
        currencyList = _items;
        currencyTerm = ['All'];
        _items.forEach((element) {
          currencyTerm.add(element['currency_code'].toString());
          currencyAvailability[element['currency_code']] =
              element['is_active'].toString();
        });
      }
      setState(() {
        currenciesLoaded = true;
      });
    }
    return null;
  }

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
      setState(() {});
    }
  }

  _selectToDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedToDate != null ? _selectedToDate : DateTime.now(),
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
      _selectedToDate = newSelectedDate;
      toDateCont
        ..text = DateFormat(' d / M / y').format(_selectedToDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: toDateCont.text.length, affinity: TextAffinity.upstream));
      setState(() {});
    }
  }

  String gainPer(BidHistoryModel model) {
    double result =
        ((double.parse(gains(model)) / double.parse(model.discountVal))) * 100;
    return result.toStringAsFixed(2);
  }

  String gains(BidHistoryModel model) {
    double result =
        (double.parse(model.invoiceValue) - double.parse(model.discountVal)) *
            0.9;
    return result.toString();
  }

  String netReturn(BidHistoryModel model) {
    double pltfee = 0.1 *
        double.parse(
            (double.parse(model.invoiceValue) - double.parse(model.discountVal))
                .toString());
    double result = double.parse(model.invoiceValue) - pltfee;
    return result.toString();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void exportCSV(List<BidHistoryModel> bids) {
    {
      final find = ',';
      final replaceWith = '';
      List<List<dynamic>> rows = [];
      capsaPrint('Length : ${bids.length}');
      rows.add([
        "S/N",
        "Anchor Name",
        "Invoice Amount",
        "Bid Amount",
        "% Gain",
        "Gain",
        "Net Returns",
        "Due Date",
        "Tenure",
        "Status"
      ]);
      int i = 0;
      for (var bid in bids) {
        List<dynamic> row = [];
        row.add(
          (++i).toString(),
        );
        row.add(
          bid.customerName,
        );
        row.add(
          formatCurrency(
            bid.invoiceValue,
            withIcon: false,
          ),
        );
        row.add(
          formatCurrency(
            bid.discountVal,
            withIcon: false,
          ),
        );
        row.add(
          gainPer(bid),
        );
        row.add(
          formatCurrency(
            gains(bid),
            withIcon: false,
          ),
        );
        row.add(
          formatCurrency(
            netReturn(bid),
            withIcon: false,
          ),
        );

        row.add(
          DateFormat('d MMM, y').format(
              DateFormat(
                  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                  .parse(bid
                  .effectiveDueDate)),
        );
        row.add(
          daysBetween(
            bid.discountedDate,
            DateFormat(
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .parse(bid
                .effectiveDueDate),

          ).toString(),
        );
        row.add(statusString(bid));
        rows.add(row);
      }

      String dataAsCSV = const ListToCsvConverter().convert(
        rows,
      );
      exportToCSV(dataAsCSV, fName: "Bids Analysis");
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider _profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    double scaleFactor = !Responsive.isMobile(context)
        ? MediaQuery.of(context).size.width / 1536
        : MediaQuery.of(context).size.width / 400;

    return Container(
      height: MediaQuery.of(context).size.height,
      padding:
          EdgeInsets.all(Responsive.isMobile(context) ? 8 : 18.0 * scaleFactor),
      child: currenciesLoaded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (!Responsive.isMobile(context))
                //   SizedBox(
                //     height: 22,
                //   ),
                //if(dataSource.length>0)
                Container(
                  // padding: EdgeInsets.all((!Responsive.isMobile(context)) ? 12 : 1.0),
                  // color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  //height: 90,
                  child: OrientationSwitcher(
                    orientation: 'Row',
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: Responsive.isMobile(context)
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: Responsive.isMobile(context)
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width * 0.5
                                : MediaQuery.of(context).size.width * 0.3,
                            //height: (!Responsive.isMobile(context)) ? 65 * scaleFactor : 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              color: Colors.white,
                            ),
                            // padding: Responsive.isMobile(context)
                            //     ? EdgeInsets.symmetric(horizontal: 5, vertical: 2)
                            //     : EdgeInsets.symmetric(
                            //         horizontal: 16 * scaleFactor, vertical: 16 * scaleFactor),
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
                                    fontSize: (!Responsive.isMobile(context))
                                        ? 18
                                        : 15,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                                hintText: Responsive.isMobile(context)
                                    ? "Search by Anchor name"
                                    : "Search by Anchor name",
                              ),
                            ),
                          ),
                          if (Responsive.isMobile(context)) SizedBox(width: 8),
                        ],
                      ),
                      if (!Responsive.isMobile(context)) SizedBox(width: 3),
                      OrientationSwitcher(
                        orientation: 'Row',
                        mainAxisAlignment: Responsive.isMobile(context)
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        crossAxisAlignment: Responsive.isMobile(context)
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.center,
                        children: [
                          if (!Responsive.isMobile(context))
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Filter by : ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    // fontFamily: 'Poppins',
                                    fontSize:
                                        Responsive.isMobile(context) ? 12 : 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.w600,
                                    height: 1),
                              ),
                            ),
                          if (!Responsive.isMobile(context))
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '    Status  ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    // fontFamily: 'Poppins',
                                    fontSize:
                                        Responsive.isMobile(context) ? 12 : 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                          if (!Responsive.isMobile(context))
                            SizedBox(
                              width: !Responsive.isMobile(context)
                                  ? 160
                                  : MediaQuery.of(context).size.width * 0.8,
                              child: UserTextFormField(
                                label: !Responsive.isMobile(context)
                                    ? ""
                                    : "Currency",
                                hintText: "Status",
                                textFormField: DropdownButtonFormField(
                                  isExpanded: true,
                                  validator: (v) {
                                    if (currencyController.text == '') {
                                      return "Can't be empty";
                                    }
                                    return null;
                                  },
                                  items: status.map((String category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (v) async {
                                    selectedStatus = v;
                                    sts = v;
                                    setState(() {});
                                  },
                                  value: sts,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Status",
                                    hintStyle: TextStyle(
                                        color: Color.fromRGBO(130, 130, 130, 1),
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, bottom: 12.0, top: 12.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15.7),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15.7),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Responsive.isMobile(context)
                              ? SizedBox(width: 8)
                              : SizedBox(
                                  height: 8,
                                ),

                          if (!Responsive.isMobile(context)) SizedBox(width: 8),
                          if (!Responsive.isMobile(context))
                            InkWell(
                                onTap: () {
                                  exportCSV(dataSource);
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Export  ',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: HexColor('#0098DB')),
                                      ),
                                      Icon(Icons.download,
                                          size: Responsive.isMobile(context)
                                              ? 12
                                              : 26,
                                          color: HexColor('#0098DB')),
                                    ],
                                  ),
                                ))

                          // Row(
                          //   children: [
                          //     // Padding(
                          //     //   padding: const EdgeInsets.only(top: 8),
                          //     //   child: Text(
                          //     //     '   To  ',
                          //     //     textAlign: TextAlign.left,
                          //     //     style: TextStyle(
                          //     //         color: Color.fromRGBO(0, 0, 0, 1),
                          //     //         // fontFamily: 'Poppins',
                          //     //         fontSize: Responsive.isMobile(context)
                          //     //             ? 12
                          //     //             : 16,
                          //     //         letterSpacing:
                          //     //             0 /*percentages not used in flutter. defaulting to zero*/,
                          //     //         fontWeight: FontWeight.normal,
                          //     //         height: 1),
                          //     //   ),
                          //     // ),
                          //     // SizedBox(width: 3),
                          //     // SizedBox(
                          //     //   width: Responsive.isMobile(context)
                          //     //       ? 130
                          //     //       : 180 * scaleFactor,
                          //     //   child: UserTextFormField(
                          //     //     label: "",
                          //     //     readOnly: true,
                          //     //     controller: toDateCont,
                          //     //     prefixIcon: (_selectedToDate != null)
                          //     //         ? InkWell(
                          //     //             onTap: () {
                          //     //               setState(() {
                          //     //                 _selectedToDate = null;
                          //     //                 toDateCont.text = "DD/MM/YYYY";
                          //     //               });
                          //     //             },
                          //     //             child: Icon(
                          //     //               Icons.close,
                          //     //               size: Responsive.isMobile(context)
                          //     //                   ? 10
                          //     //                   : 22,
                          //     //             ))
                          //     //         : null,
                          //     //     suffixIcon: Icon(Icons.date_range_outlined),
                          //     //     hintText: "DD/MM/YYYY",
                          //     //     onTap: () => _selectToDate(context),
                          //     //     keyboardType: TextInputType.number,
                          //     //   ),
                          //     // ),
                          //
                          //
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: FutureBuilder<Object>(
                      future: Provider.of<BidHistoryProvider>(context,
                              listen: false)
                          .myBidHistoryList(
                              search: _search,
                              date: _selectedDate,
                              date2: _selectedToDate,
                              isonlyAccept: true,
                              currency: widget.selectedCurrency,
                              status: selectedStatus),
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
                              'There was an error :(\n' +
                                  snapshot.error.toString(),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final bidHistoryProvider =
                              Provider.of<BidHistoryProvider>(context,
                                  listen: false);
                          dataSource = bidHistoryProvider.bidHistoryDataList;
                          //dataSource = [];

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
                                              //Beamer.of(context).beamToNamed('/transaction-details/' + bids.invoiceNumber);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      InvestorMain(
                                                          //pageUrl: "/transaction-details/" + id,
                                                          pop: true,
                                                          backButton: true,
                                                          menuList: false,
                                                          mobileTitle:
                                                              bids.customerName +
                                                                  '\'s Invoice',
                                                          body: BidDetailsPage(
                                                            bid: bids,
                                                          )),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(1),
                                              child: BibsCard(bids, false),
                                            ),
                                          )
                                      ],
                                    )
                                  :
                              dataSource.length > 0 ? DataTable(
                                      dataRowHeight: 60,
                                      columns: dataTableColumn([
                                        "S/N",
                                        "Anchor Name",
                                        "Invoice Amount",
                                        "Bid Amount",
                                        "% Gain",
                                        "Gain",
                                        "Net Returns",
                                        "Due Date      ",
                                        "Tenure",
                                        "Status",
                                      ]),
                                      rows: <DataRow>[
                                        for (var bids in dataSource)
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(
                                                (++i).toString(),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                bids.customerName,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                formatCurrency(
                                                  bids.invoiceValue,
                                                  withIcon: true,
                                                ),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                formatCurrency(
                                                  bids.discountVal,
                                                  withIcon: true,
                                                ),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                gainPer(bids),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                formatCurrency(
                                                  gains(bids),
                                                  withIcon: true,
                                                ),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                formatCurrency(
                                                  netReturn(bids),
                                                  withIcon: true,
                                                ),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                DateFormat('d MMM, y').format(
                                                    DateFormat(
                                                            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                        .parse(bids
                                                            .effectiveDueDate)),

                                                // DateFormat('d MMM, y')
                                                //     .format(bids.discountedDate)
                                                //     .toString(),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(Text(
                                                daysBetween(
                                                  bids.discountedDate,
                                                  DateFormat(
                                                          "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                      .parse(bids
                                                          .effectiveDueDate),

                                                ).toString(),
                                                style: dataTableBodyTextStyle,
                                              )),
                                              DataCell(_status(bids)),
                                            ],
                                          ),
                                      ],
                                    ):
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 62,
                                  ),
                                  Container(
                                      child: Image.asset(
                                        'assets/icons/No Bids Placed.png',
                                        height: 229,
                                        width: 178,
                                      )),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    'No Overdue Invoices',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: HexColor('#333333')),
                                  ),
                                  SizedBox(
                                    height: 12,
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _status(BidHistoryModel bids) {
    // return Text(bids.historyStatus);
    // String _text = 'Pending';
    // dynamic clr = HexColor('#F2994A');
    // if (bids.paymentStatus == '1') {
    //   _text = 'Closed';
    //   clr = HexColor("#EB5757");
    // } else {
    //   if (bids.discount_status == 'true') {
    //     _text = 'Open';
    //     clr = Colors.green;
    //   } else if (DateFormat("yyyy-MM-ddThh:mm:ss")
    //       .parse(bids.effectiveDueDate)
    //       .isBefore(DateTime.now())) {
    //     _text = 'OverDue';
    //     clr = HexColor('#F2994A');
    //   }
    //   //if(DataTime.parse(bids.effectiveDueDate))
    // }

    String _text = 'Open';
    dynamic clr = HexColor('#F2994A');
    if (bids.paymentStatus == '1') {
      _text = 'Closed';
      clr = HexColor("#EB5757");
    } else {
      if (bids.discount_status == 'true') {
        if (DateFormat("yyyy-MM-ddThh:mm:ss")
            .parse(bids.effectiveDueDate)
            .isBefore(DateTime.now())) {
          _text = 'Overdue';
          clr = HexColor('#F2994A');
        } else {
          _text = 'Open';
          clr = Colors.green;
        }
      } else {
        _text = 'Pending';
      }
    }

    return Text(
      _text,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: clr,
          // fontFamily: 'Poppins',
          fontSize: 15,
          letterSpacing:
              0 /*percentages not used in flutter. defaulting to zero*/,
          fontWeight: FontWeight.normal,
          height: 1),
    );
  }
}

String statusString(BidHistoryModel bids) {
  String _text = 'Open';
  dynamic clr = HexColor('#F2994A');
  if (bids.paymentStatus == '1') {
    _text = 'Closed';
    clr = HexColor("#EB5757");
  } else {
    if (bids.discount_status == 'true') {
      if (DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(bids.effectiveDueDate)
          .isBefore(DateTime.now())) {
        _text = 'Overdue';
        clr = HexColor('#F2994A');
      } else {
        _text = 'Open';
        clr = Colors.green;
      }
    } else {
      _text = 'Pending';
    }
  }

  return _text;
}
