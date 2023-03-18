import 'package:capsa/admin/data/investor_data.dart';
import 'package:capsa/admin/models/revenue_tracker_model.dart';
import 'package:capsa/admin/models/transation_tracker_model.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/admin/widgets/buyer_list_card.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/admin/common/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RevenueTracker extends StatefulWidget {
  final String title;

  const RevenueTracker({Key key, this.title}) : super(key: key);

  @override
  _RevenueTrackerState createState() => _RevenueTrackerState();
}

class _RevenueTrackerState extends State<RevenueTracker> {
  int _rowsPerPage = 5;

  DateTime _selectedToDate;
  DateTime _selectedFromDate;

  TextEditingController _fromDateCont = TextEditingController(text: '');
  TextEditingController _toDateCont = TextEditingController(text: '');

  List<RevenueTrackerModel> revenues = [];

  String errorText = '';
  bool dataFetched = false;

  final _formKey = GlobalKey<FormState>();

  void fetchData() async {

    setState(() {
      errorText = 'Loading...';
    });

    dynamic response =
        await Provider.of<ProfileProvider>(context, listen: false)
            .getRevenueTracker(
                fromDate: DateFormat('yyyy-MM-dd').format(_selectedFromDate),
                toDate: DateFormat('yyyy-MM-dd').format(_selectedToDate));

    if (response['res'] == 'success') {
      capsaPrint('\n\nResponse : $response');
      revenues = [];

      for (int i = 0; i < response['data'].length; i++) {
        capsaPrint(
            '${response['data'][i]['transaction_month'].toString()} ${response['data'][i]['requestorFee'].toString()}');
        revenues.add(RevenueTrackerModel(
          transactionMonth: response['data'][i]['revenue_month'].toString(),
          requestorFee: response['data'][i]['requestorFee'].toString(),
          investorFee: response['data'][i]['investorFee'].toString(),
          totalRevenue: response['data'][i]['totalRevenue'].toString(),
        ));
        capsaPrint(
            'Adding Revenues : ${revenues[i].transactionMonth} ${revenues[i].requestorFee}\n');
      }
      errorText = '';
    }else{
      errorText = 'Something Went Wrong!';
    }

    dataFetched = true;

    setState(() {});
  }

  _selectFromDate(BuildContext context) async {
    // capsaPrint("_selectFromDate");

    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate:
            _selectedFromDate != null ? _selectedFromDate : DateTime.now(),
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
      _selectedFromDate = newSelectedDate;

      _fromDateCont
        ..text = DateFormat.yMMMd().format(_selectedFromDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _fromDateCont.text.length,
            affinity: TextAffinity.upstream));
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
      _toDateCont
        ..text = DateFormat.yMMMd().format(_selectedToDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _toDateCont.text.length, affinity: TextAffinity.upstream));
    }
  }

  @override
  Widget build(BuildContext context) {
    var searchInvoiceText = "";
    return Form(
      key: _formKey,
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: Responsive.isMobile(context)
                  ? const EdgeInsets.fromLTRB(5, 0, 5, 0)
                  : const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '${widget.title}',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 5 : 30,
                  ),
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: Divider(
                      height: 1,
                      color: Theme.of(context).primaryColor,
                      thickness: 0,
                    ),
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 8 : 35,
                  ),

                  Row(
                    children: [
                      Flexible(
                        child: UserTextFormField(
                          label: "",
                          readOnly: true,
                          controller: _fromDateCont,
                          suffixIcon: Icon(Icons.date_range_outlined),
                          hintText: "Starting Date",
                          onTap: () => _selectFromDate(context),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Flexible(
                        child: UserTextFormField(
                          label: "",
                          suffixIcon: Icon(Icons.date_range_outlined),
                          readOnly: true,
                          controller: _toDateCont,
                          hintText: "Ending Date",
                          onTap: () => _selectToDate(context),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            fetchData();
                          }
                        },
                        child: Container(
                          width: 260,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            color: Color.fromRGBO(0, 152, 219, 1),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Center(
                            child: Text(
                              'Submit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 50,
                  ),

                  errorText == ''
                      ? revenues.length > 0
                          ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  final find = ',';
                                  final replaceWith = '';
                                  List<List<dynamic>> rows = [];
                                  rows.add([
                                    "Transaction Month",
                                    "Requester Fee",
                                    "Investor Fee",
                                    "Total Revenue",
                                  ]);
                                  for (int i = 0; i < revenues.length; i++) {
                                    List<dynamic> row = [];
                                    row.add(revenues[i].transactionMonth ?? '');
                                    row.add(revenues[i].requestorFee != null
                                        ? formatCurrency(
                                        revenues[i].requestorFee)
                                        : '');
                                    row.add(revenues[i].investorFee != null
                                        ? formatCurrency(
                                        revenues[i].investorFee)
                                        : '',);
                                    row.add(revenues[i].totalRevenue != null
                                        ? formatCurrency(
                                        revenues[i].totalRevenue)
                                        : '',);

                                    rows.add(row);
                                  }

                                  String dataAsCSV = const ListToCsvConverter().convert(
                                    rows,
                                  );
                                  exportToCSV(dataAsCSV);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.download_rounded),
                                    SizedBox(width: 4,),
                                    Text(
                                      'Download As CSV',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                width: double.infinity,
                                child: DataTable(
                                  columns: dataTableColumn([
                                    //"S/L Number",
                                    "Transaction Month",
                                    "Requester Fee",
                                    "Investor Fee",
                                    "Total Revenue",
                                  ]),
                                  rows: <DataRow>[
                                    for (int i = 0; i < revenues.length; i++)
                                      DataRow(
                                        cells: <DataCell>[
                                          // DataCell(Text(
                                          //   // transaction.created_on,
                                          //   '${i + 1}',
                                          //   style: dataTableBodyTextStyle,
                                          // )),
                                          DataCell(Text(
                                            // transaction.created_on,
                                            revenues[i].transactionMonth ?? '',
                                            style: dataTableBodyTextStyle,
                                          )),
                                          DataCell(Text(
                                            // transaction.created_on,
                                            revenues[i].requestorFee != null
                                                ? formatCurrency(
                                                    revenues[i].requestorFee)
                                                : '',
                                            style: dataTableBodyTextStyle,
                                          )),
                                          DataCell(Text(
                                            revenues[i].investorFee != null
                                                ? formatCurrency(
                                                    revenues[i].investorFee)
                                                : '',
                                            style: dataTableBodyTextStyle,
                                          )),
                                          DataCell(Text(
                                            revenues[i].totalRevenue != null
                                                ? formatCurrency(
                                                    revenues[i].totalRevenue)
                                                : '',
                                            style: dataTableBodyTextStyle,
                                          )),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          : Expanded(
                              child: Center(
                                  child: dataFetched
                                      ? Container(
                                          child: Text(
                                          'Sorry, No results found!',
                                          style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      : Container(
                                          child: Text(
                                          'Select the range of dates to view revenues.',
                                          style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ))))
                      :Expanded(
                    child: Center(
                      child: Container(
                        child: Text(errorText,style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600)),
                      ),
                    ),
                  )

                  // Expanded(
                  //     child: AccountTable(filter: searchInvoiceText)),
                ],
              ),
            ),
          ),
        ));
      }),
    );
  }
}
