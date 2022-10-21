// import 'dart:html';

import 'package:capsa/investor/pages/AnchorAnalysisPage/common/responsive.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';

class RTabularView extends StatefulWidget {
  List<String> headers;
  List<List<String>> rows;
  bool showGrowth;
  double scale = 1;
  RTabularView(
      {Key key,
      @required this.headers,
      @required this.rows,
      @required this.showGrowth,
      this.scale = 1})
      : super(key: key);

  @override
  State<RTabularView> createState() => _RTabularViewState();
}

class _RTabularViewState extends State<RTabularView> {
  List<DataColumn> columns = [];
  List<DataRow> rows = [];

  bool dataLoaded = false;

  String formatString(String s) {
    for (int i = s.length; i < 100; i++) {
      s = s + ' ';
    }
    capsaPrint('Length: ${s.length}   $s');
    return s;
  }

  double textPadding;

  TextStyle header1;

  TextStyle header2;

  TextStyle factor;
  TextStyle details;

  void getData() {
    textPadding = 8 * widget.scale;

    TextStyle header1 = GoogleFonts.poppins(
        fontSize: widget.scale == 1 ? 16 : 10, fontWeight: FontWeight.w600);
    TextStyle header2 = GoogleFonts.poppins(
        fontSize: widget.scale == 1 ? 20 : 11,
        fontWeight: FontWeight.w600,
        color: Colors.blue);
    TextStyle factor = GoogleFonts.poppins(
        fontSize: widget.scale == 1 ? 16 : 10, fontWeight: FontWeight.w600);
    TextStyle details = GoogleFonts.poppins(
        fontSize: 18 * widget.scale, fontWeight: FontWeight.w400);
    for (int i = 0; i < widget.headers.length; i++) {
      columns.add(DataColumn(
        label: Padding(
          padding: EdgeInsets.all(textPadding),
          child: Text(widget.headers[i], style: i == 0 ? header2 : header1),
        ),
      ));
    }

    for (int i = 0; i < widget.rows.length; i++) {
      List<DataCell> cell = [];
      for (int j = 0; j < widget.rows[i].length; j++) {
        (!widget.showGrowth || j == 0)
            ? cell.add(
                DataCell(
                  Padding(
                    padding: EdgeInsets.all(textPadding),
                    child: j == 0
                        ? Container(
                            width: widget.scale == 1 ? 420 : 230,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.rows[i][j],
                                  style: factor,
                                ),
                              ],
                            ),
                          )
                        : Text(
                            widget.rows[i][j],
                            style: factor,
                          ),
                  ),
                ),
              )
            : (i % 2 == 0)
                ? cell.add(
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: (widget.rows[i][j] == '-' ||
                                widget.rows[i][j] == '')
                            ? Text(
                                widget.rows[i][j],
                                style: factor,
                              )
                            : IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_up_outlined,
                                      color: Colors.green,
                                      size: widget.scale == 1 ? 10 : 10,
                                    ),
                                    Text(
                                      widget.rows[i][j],
                                      style: GoogleFonts.poppins(
                                          fontSize: widget.scale == 1 ? 16 : 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  )
                : cell.add(
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          widget.rows[i][j],
                          style: factor,
                        ),
                      ),
                    ),
                  );
      }
      // print('Length ${widget.rows[i]} ${cell.length}');
      rows.add(DataRow(cells: cell));
      cell = [];
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: dataLoaded
          ? widget.scale == 1
              ? Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Responsive.isMobile(context) ? 16 : 100,
                          right: Responsive.isMobile(context) ? 16 : 120,
                        ),
                        child: DataTable(
                          columnSpacing: 102 * widget.scale,
                          dataRowHeight: 64 * widget.scale,
                          headingRowHeight: 64 * widget.scale,
                          columns: columns,
                          rows: rows,
                        ),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: Responsive.isMobile(context) ? 16 : 100,
                          right: Responsive.isMobile(context) ? 16 : 120,
                        ),
                        child: DataTable(
                          columnSpacing: 102 * (widget.scale + 0.1),
                          dataRowHeight: 64 * (widget.scale + 0.2),
                          headingRowHeight: 64 * (widget.scale + 0.2),
                          columns: columns,
                          rows: rows,
                        ),
                      ),
                    ],
                  ),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
