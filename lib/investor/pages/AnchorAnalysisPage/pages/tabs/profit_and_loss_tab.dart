import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/graph_analysis.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/credit_score_gauge.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/tabular_view/tabular_view.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/tabular_view/tabular_view_2.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/text.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/common/responsive.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/src/intl/number_format.dart';

class ProfitAndLossTab extends StatefulWidget {
  double scale;
  String panNumber;
  ProfitAndLossTab({Key key, this.scale = 1,@required this.panNumber}) : super(key: key);

  @override
  State<ProfitAndLossTab> createState() => _ProfitAndLossTabState();
}

class _ProfitAndLossTabState extends State<ProfitAndLossTab> {
  ProfitAndLoss pnlData = ProfitAndLoss([], {}, {}, {}, {}, {});
  bool dataLoaded = false;
  String companyDetails;



  void getData() async {
    var anchorsAnalysis =
        Provider.of<AnchorAnalysisProvider>(context, listen: false);
    pnlData = await anchorsAnalysis.fetchProfitAndLoss(widget.panNumber);
    //capsaPrint('PNL Data $pnlData');

    setState(() {
      dataLoaded = true;
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    print('Pan ${widget.panNumber}');
    return dataLoaded
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                header(
                    text: 'Financial Highlights',
                    left: 50 * widget.scale,
                    top: 42 * widget.scale,
                    scale: widget.scale),
                SizedBox(
                  height: 52 * widget.scale,
                ),
                IntrinsicHeight(
                  child: Responsive.isMobile(context)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: GraphWidget(
                                scale: widget.scale,
                                isOnlyBarChart: true,
                                title: 'Revenue',
                                data: pnlData.revenue,
                                barChartHexColor: '#3AC0C9',
                                yearsPresent: pnlData.yearsPresent,
                                note: '*The figure below Revenue is for the most recent financial year',
                              ),
                            ),
                            SizedBox(
                              height: 70 * widget.scale,
                            ),
                            GraphWidget(
                              scale: widget.scale,
                              isOnlyBarChart: false,
                              title: 'EBIT',
                              data: pnlData.EBIT,
                              barChartHexColor: '#3AC0C9',
                              yearsPresent: pnlData.yearsPresent,
                              note: '*The figure below EBIT is for the most recent financial year',
                            ),
                            SizedBox(
                              height: 70 * widget.scale,
                            ),
                            GraphWidget(
                              scale: widget.scale,
                              isOnlyBarChart: true,
                              title: 'EBITDA',
                              data: pnlData.EBITDA,
                              barChartHexColor: '#7B61FF',
                              yearsPresent: pnlData.yearsPresent,
                              note: '*The figure below EBITDA is for the most recent financial year',
                            ),
                            SizedBox(
                              height: 70 * widget.scale,
                            ),
                            GraphWidget(
                              scale: widget.scale,
                              isOnlyBarChart: false,
                              title: 'Net Profit',
                              data: pnlData.netProfitValue,
                              barChartHexColor: '#0098DB',
                              yearsPresent: pnlData.yearsPresent,
                              note: '*The figure below Net Profit is for the most recent financial year',
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GraphWidget(
                                  isOnlyBarChart: true,
                                  title: 'Revenue',
                                  data: pnlData.revenue,
                                  barChartHexColor: '#3AC0C9',
                                  yearsPresent: pnlData.yearsPresent,
                                  note: '*The figure below Revenue is for the most recent financial year',
                                ),
                                SizedBox(
                                  width: 141 * widget.scale,
                                ),
                                GraphWidget(
                                  isOnlyBarChart: true,
                                  title: 'EBITDA',
                                  data: pnlData.EBITDA,
                                  barChartHexColor: '#7B61FF',
                                  yearsPresent: pnlData.yearsPresent,
                                  note: '*The figure below EBITDA is for the most recent financial year',
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 70 * widget.scale,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GraphWidget(
                                  isOnlyBarChart: false,
                                  title: 'EBIT',
                                  data: pnlData.EBIT,
                                  barChartHexColor: '#3AC0C9',
                                  yearsPresent: pnlData.yearsPresent,
                                  note: '*The figure below EBIT is for the most recent financial year',
                                ),
                                SizedBox(
                                  width: 141 * widget.scale,
                                ),
                                GraphWidget(
                                  isOnlyBarChart: false,
                                  title: 'Net Profit',
                                  data: pnlData.netProfitValue,
                                  barChartHexColor: '#0098DB',
                                  yearsPresent: pnlData.yearsPresent,
                                  note: '*The figure below Net Profit is for the most recent financial year',
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 40 * widget.scale,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 38 * widget.scale,
                    bottom: 40 * widget.scale,
                  ),
                  child: Text(
                    'Key Financials',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.scale == 1 ? 20 : 14),
                  ),
                ),
                // widget.scale==1?TabularView2(scale: widget.scale,):SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     child: Row(
                //       children: [
                //         TabularView2(scale: widget.scale,),
                //       ],
                //     ),
                //   ),
                // ),
                TabularView2(
                  scale: widget.scale,
                  pnlData: pnlData,
                )
              ])
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
