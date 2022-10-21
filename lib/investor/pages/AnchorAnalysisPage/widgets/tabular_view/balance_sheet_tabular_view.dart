// import 'dart:html';

import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';

class BSTabularView extends StatefulWidget {
  double scale;
  BalanceSheetModel model;
  BSTabularView({Key key, @required this.scale, @required this.model})
      : super(key: key);

  @override
  State<BSTabularView> createState() => _BSTabularViewState();
}

class _BSTabularViewState extends State<BSTabularView> {
  List<DataColumn> headerColumn = [];
  List<DataRow> rows = [];
  bool dataLoaded = false;

  String inMillions(String num) {
    int n = int.parse(num);
    double result = n / 1000.0;
    // if (result < 1) {
    //   return result.toString().length<4?result.round().toString():result.round().toString().substring(0, 4);
    // } else {
    return result.round().toString();
    // }
  }

  String getIncrement(double a, double b) {
    if(a == b){
      return '0%';
    }
    String s = ((a - b) / (b * 1.0) * 100).abs().toStringAsFixed(2);
    return (s + "%");
  }

  DataRow generateRow(String title, dynamic data, dynamic yearsPresent) {
    double headerSize = widget.scale == 1 ? 16 : 10;
    double itemSize = widget.scale == 1 ? 18 : 10;
    double iconSize = 35 * widget.scale;
    double textPadding = 8 * widget.scale;
    double percentageSize = widget.scale == 1 ? 16 : 8;
    List<DataCell> cells = [];
    cells.add(
      DataCell(
        Padding(
          padding: EdgeInsets.all(textPadding),
          child: Text(
            title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: itemSize),
          ),
        ),
      ),
    );
    for (int i = 0; i < yearsPresent.length; i++) {
      cells.add(
        DataCell(
          Padding(
            padding: EdgeInsets.all(textPadding),
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatCurrency(inMillions(data[yearsPresent[i].toString()])),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: itemSize),
                  ),
                  i == 0
                      ? Text(
                          '-',
                          style: GoogleFonts.poppins(
                              fontSize: percentageSize,
                              fontStyle: FontStyle.italic),
                        )
                      : Row(
                          children: [
                            double.parse(data[yearsPresent[i].toString()]
                                        .toString()) >=
                                    double.parse(
                                        data[yearsPresent[i - 1].toString()]
                                            .toString())
                                ? Icon(
                                    Icons.arrow_drop_up_outlined,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Colors.red,
                                  ),
                            Text(
                              getIncrement(
                                  double.parse(data[yearsPresent[i].toString()]
                                      .toString()),
                                  double.parse(
                                      data[yearsPresent[i - 1].toString()]
                                          .toString())),
                              style: GoogleFonts.poppins(
                                  fontSize: percentageSize,
                                  fontStyle: FontStyle.italic,
                                  color: double.parse(
                                              data[yearsPresent[i].toString()]
                                                  .toString()) >=
                                          double.parse(data[yearsPresent[i - 1]
                                                  .toString()]
                                              .toString())
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return DataRow(cells: cells);
  }

  DataRow generateSubRow(String title, dynamic data, dynamic yearsPresent) {

    //print('\nData $data');

    double headerSize = widget.scale == 1 ? 16 : 10;
    double itemSize = widget.scale == 1 ? 18 : 10;
    double iconSize = 35 * widget.scale;
    double textPadding = 8 * widget.scale;
    double percentageSize = widget.scale == 1 ? 16 : 8;
    List<DataCell> cells = [];
    cells.add(
      DataCell(
        Padding(
          padding: EdgeInsets.all(textPadding),
          child: Text(
            '    ' + title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400, fontSize: itemSize),
          ),
        ),
      ),
    );
    for (int i = 0; i < yearsPresent.length; i++) {
      // print('added ${data[yearsPresent[i]]}');
      cells.add(
        DataCell(
          Padding(
            padding: EdgeInsets.all(textPadding),
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatCurrency(inMillions(data[yearsPresent[i].toString()])),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: itemSize),
                  ),
                  i == 0
                      ? Text(
                          '-',
                          style: GoogleFonts.poppins(
                              fontSize: percentageSize,
                              fontStyle: FontStyle.italic),
                        )
                      : Row(
                          children: [
                            double.parse(data[yearsPresent[i].toString()]
                                        .toString()) >=
                                    double.parse(
                                        data[yearsPresent[i - 1].toString()]
                                            .toString())
                                ? Icon(
                                    Icons.arrow_drop_up_outlined,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Colors.red,
                                  ),
                            Text(
                              getIncrement(
                                  double.parse(data[yearsPresent[i].toString()]
                                      .toString()),
                                  double.parse(
                                      data[yearsPresent[i - 1].toString()]
                                          .toString())),
                              style: GoogleFonts.poppins(
                                  fontSize: percentageSize,
                                  fontStyle: FontStyle.italic,
                                  color: double.parse(
                                              data[yearsPresent[i].toString()]
                                                  .toString()) >=
                                          double.parse(data[yearsPresent[i - 1]
                                                  .toString()]
                                              .toString())
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return DataRow(cells: cells);
  }

  void getData() {
    double headerSize = widget.scale == 1 ? 16 : 10;
    double itemSize = widget.scale == 1 ? 18 : 10;
    double iconSize = 35 * widget.scale;
    double textPadding = 8 * widget.scale;
    double percentageSize = widget.scale == 1 ? 16 : 8;



    rows.add(generateRow(
        'Total Assets', widget.model.totalAssets, widget.model.yearsPresent));



    rows.add(generateSubRow('Total Non-Current Assets',
        widget.model.totalNonCurrentAssets, widget.model.yearsPresent));



    rows.add(generateSubRow('Total Current Assets',
        widget.model.totalCurrentAssets, widget.model.yearsPresent));



    rows.add(generateRow('Equity and Liabilities',
        widget.model.totalEquityAndLiabilities, widget.model.yearsPresent));



    rows.add(generateSubRow('Total Non-Current Liabilities',
        widget.model.totalNonCurrentLiabilities, widget.model.yearsPresent));



    rows.add(generateSubRow('Long Term Debt', widget.model.longTermDebt,
        widget.model.yearsPresent));



    rows.add(generateSubRow('Total Current Liabilities',
        widget.model.totalLiabilities, widget.model.yearsPresent));



    rows.add(generateSubRow(
        'Total Equity', widget.model.equity, widget.model.yearsPresent));



    headerColumn = [];
    headerColumn.add(
      DataColumn(
        label: Padding(
          padding: EdgeInsets.all(textPadding),
          child: Text(
            'in thousands of naira',
            style: GoogleFonts.poppins(
                fontStyle: FontStyle.italic, fontSize: headerSize),
          ),
        ),
      ),
    );



    for (int i = 0; i < widget.model.yearsPresent.length; i++) {
      headerColumn.add(
        DataColumn(
          label: Padding(
            padding: EdgeInsets.all(textPadding),
            child: Text(
              widget.model.yearsPresent[i],
              style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic, fontSize: headerSize),
            ),
          ),
        ),
      );
    }



    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double headerSize = widget.scale == 1 ? 16 : 10;
    double itemSize = widget.scale == 1 ? 18 : 10;
    double iconSize = 35 * widget.scale;
    double textPadding = 8 * widget.scale;
    double percentageSize = widget.scale == 1 ? 16 : 8;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: dataLoaded
          ? widget.scale == 1
              ? Row(
                  children: [
                    Expanded(
                      child: DataTable(
                          columnSpacing: 102 * (widget.scale + 0.1),
                          dataRowHeight: 88,
                          headingRowHeight: 64,
                          columns: headerColumn,
                          rows: rows),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      DataTable(
                          columnSpacing: 102 * (widget.scale * 0.1),
                          dataRowHeight: widget.scale == 1 ? 88 : 48,
                          headingRowHeight: widget.scale == 1 ? 64 : 44,
                          columns: headerColumn,
                          rows: rows),
                    ],
                  ),
                )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
