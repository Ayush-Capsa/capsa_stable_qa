import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';

class TabularView extends StatelessWidget {
  double scale;
  CreditScoreModel model;
  TabularView({Key key,this.scale = 1,@required this.model
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double headerSize = 24 * scale;
    double itemSize = 26 * scale;
    double iconSize = 35 * scale;
    double textPadding = 16 * scale;

    TextStyle header = GoogleFonts.poppins(
        fontSize: scale == 1?16:10, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400);
    TextStyle factor = GoogleFonts.poppins(
        fontSize: scale==1?18:10, fontWeight: FontWeight.w600);
    TextStyle details = GoogleFonts.poppins(
        fontSize: scale==1?18:10, fontWeight: FontWeight.w400);

    Widget indicator(int n){
      return n == 1?Icon(
        Icons.check,
        color: Colors.green,
        size: iconSize,
      ):Icon(
        Icons.clear_rounded,
        color: Colors.red,
        size: iconSize,
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 80 * scale, right: 115 * scale),
      child: scale == 1?Row(
        children: [
          Expanded(
            child: DataTable(
                columnSpacing: 102 * scale,
                dataRowHeight: scale == 1?64:42,
                headingRowHeight: 64 * scale,
                columns: [
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Factor', style: header),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text(
                        'Score',
                        style: header,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text(
                        'Details',
                        style: header,
                      ),
                    ),
                  )
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'Buisness Growth',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.growth),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.growth == 1?'Consistent Growth in Sales':'Inconsistent Growth in Sales',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'EBIDTA',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.ebidta),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.ebidta == 1?'Consistent EBIDTA growth':'Inconsistent EBIDTA growth',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'Earnings Per Share',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.eps),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.eps == 1?'Trend indicates increasing EPS':'Trend indicates inconsistent EPS',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'Trade Receivables',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.traderec),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.traderec == 1?'Significant increase  in trade receivables over the period':'Inconsistent trade receivables over the period',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'Solvency',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.solvency),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.solvency == 1?"The company is solvent":'The company is solvent, althought the amount of total liabilities is large in proportion to the asset base.',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                ]),
          ),
        ],
      ):SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            DataTable(
                columnSpacing: 102 * scale,
                dataRowHeight: scale == 1?64:42,
                headingRowHeight: 64 * scale,
                columns: [
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Factor', style: header),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text(
                        'Score',
                        style: header,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text(
                        'Details',
                        style: header,
                      ),
                    ),
                  )
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'Buisness Growth',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.growth),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.growth == 1?'Consistent Growth in Sales':'Inconsistent Growth in Sales',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'EBIDTA',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.ebidta),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.ebidta == 1?'Consistent EBIDTA growth':'Inconsistent EBIDTA growth',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'Earnings Per Share',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.eps),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.eps == 1?'Trend indicates increasing EPS':'Trend indicates inconsistent EPS',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'Trade Receivables',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.traderec),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.traderec == 1?'Significant increase  in trade receivables over the period':'Inconsistent trade receivables over the period',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          'Solvency',
                          style: factor,
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: indicator(model.solvency),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.all(textPadding),
                        child: Text(
                          model.solvency == 1?"The company is solvent":'The company is solvent, althought the amount of total liabilities is large in proportion to the asset base.',
                          style: details,
                        ),
                      ),
                    ),
                  ]),
                ]),
          ],
        ),
      )
    );
  }
}
