// import 'dart:html';

import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';

class TabularView2 extends StatefulWidget {
  double scale = 1;
  ProfitAndLoss pnlData;
  //List<String> headers;
  //List<List<String>> rows;
  TabularView2({Key key, this.scale = 1,@required this.pnlData}) : super(key: key);

  @override
  State<TabularView2> createState() => _TabularView2State();
}

class _TabularView2State extends State<TabularView2> {

  double headerSize ;

  double itemSize ;

  double iconSize ;

  double textPadding;

  double percentageSize;

  bool dataLoaded = false;

  List<DataColumn> headers = [];
  List<DataRow> rows = [];


  String getIncrement(double a, double b) {
    if(a == b)
      return "0%";
    String s = ((a - b) / (b * 1.0) * 100).abs().toStringAsFixed(2);
    return (s + "%");
  }

  String inMillions(String num) {
    int n = int.parse(num);
    double result = n / 1000.0;
    // if (result < 1) {
    //   return result.toString().length<4?result.round().toString():result.round().toString().substring(0, 4);
    // } else {
    return result.round().toString();
    // }
  }

  DataRow generateRow(String title,Map<String, String> data, dynamic yearsPresent){

    List<DataCell> cells = [];

    cells.add( DataCell(
      Padding(
        padding: EdgeInsets.all(textPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: itemSize),
            ),
            Text(
              'yoy%',
              style: GoogleFonts.poppins(
                  fontSize: percentageSize,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    ),);

    for(int i = 0; i<yearsPresent.length;i++)
   {
      cells.add(DataCell(
        Padding(
          padding: EdgeInsets.all(textPadding),
          child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formatCurrency(inMillions(data[yearsPresent[i].toString()].toString())),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: itemSize),
                ),
                i == 0?Text(
                  '-',
                  style: GoogleFonts.poppins(
                      fontSize: percentageSize,
                      fontStyle: FontStyle.italic),
                ):Row(
                  children: [
                    double.parse(data[yearsPresent[i].toString()].toString())>=double.parse(data[yearsPresent[i-1].toString()].toString())?Icon(
                      Icons.arrow_drop_up_outlined,
                      color: Colors.green,
                    ):Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.red,
                    ),
                    Text(
                      getIncrement(double.parse(data[yearsPresent[i].toString()].toString()), double.parse(data[yearsPresent[i-1].toString()].toString())),
                      style: GoogleFonts.poppins(
                          fontSize: percentageSize,
                          fontStyle: FontStyle.italic,
                          color: double.parse(data[yearsPresent[i].toString()].toString())>=double.parse(data[yearsPresent[i-1].toString()].toString())?Colors.green:Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),);
    }

   return DataRow(cells: cells);
  }

  void getData(){

    headerSize = widget.scale == 1?16:10;
    itemSize = widget.scale == 1?18:10;
    iconSize = 35 * widget.scale;
    textPadding = 8 * widget.scale;
    percentageSize = widget.scale == 1?16:8;

    headers.add(DataColumn(
      label: Padding(
        padding: EdgeInsets.all(textPadding),
        child: Text(
          'in thousands of naira',
          style: GoogleFonts.poppins(
              fontStyle: FontStyle.italic,
              fontSize: headerSize),
        ),
      ),
    ),);

    widget.pnlData.yearsPresent.forEach((element){
      headers.add(DataColumn(
        label: Padding(
          padding: EdgeInsets.all(textPadding),
          child: Text(
            element,
            style: GoogleFonts.poppins(
                fontStyle: FontStyle.italic,
                fontSize: headerSize),
          ),
        ),
      ),);
    });

    rows.add(generateRow('Revenue', widget.pnlData.revenue, widget.pnlData.yearsPresent));
    rows.add(generateRow('EBIT', widget.pnlData.EBIT, widget.pnlData.yearsPresent));
    rows.add(generateRow('EBITDA', widget.pnlData.EBITDA, widget.pnlData.yearsPresent));
    rows.add(generateRow('Cost Of Sale', widget.pnlData.costOfSales, widget.pnlData.yearsPresent));
    rows.add(generateRow('Net Profit', widget.pnlData.netProfitValue, widget.pnlData.yearsPresent));

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState(){
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: dataLoaded?widget.scale == 1
          ? Row(
              children: [
                Expanded(
                  child: DataTable(
                      columnSpacing: 112 * widget.scale,
                      dataRowHeight: widget.scale == 1 ? 88 : 58,
                      headingRowHeight: widget.scale == 1?64:48,
                      columns: headers,
                      rows: rows

                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DataTable(
                      columnSpacing: 112 * widget.scale,
                      dataRowHeight: widget.scale == 1 ? 88 : 55,
                      headingRowHeight: 64 * widget.scale,
                      columns: [
                        DataColumn(
                          label: Padding(
                            padding: EdgeInsets.all(textPadding),
                            child: Text(
                              'in millions of naira',
                              style: GoogleFonts.poppins(
                                  fontStyle: FontStyle.italic,
                                  fontSize: headerSize),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Padding(
                            padding: EdgeInsets.all(textPadding),
                            child: Text(
                              '2020',
                              style: GoogleFonts.poppins(
                                  fontStyle: FontStyle.italic,
                                  fontSize: headerSize),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Padding(
                            padding: EdgeInsets.all(textPadding),
                            child: Text(
                              '2021',
                              style: GoogleFonts.poppins(
                                  fontStyle: FontStyle.italic,
                                  fontSize: headerSize),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Padding(
                            padding: EdgeInsets.all(textPadding),
                            child: Text(
                              '2022',
                              style: GoogleFonts.poppins(
                                  fontStyle: FontStyle.italic,
                                  fontSize: headerSize),
                            ),
                          ),
                        ),
                      ],
                      rows:rows),
                ],
              ),
            ):const Center(child: CircularProgressIndicator(),),
    );
  }
}
