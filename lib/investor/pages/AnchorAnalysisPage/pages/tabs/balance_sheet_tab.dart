import 'package:capsa/investor/pages/AnchorAnalysisPage/common/responsive.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/charts/balance_sheet_bar_chart.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/charts/chart_legend/line_chart_legend.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/tabular_view/balance_sheet_tabular_view.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/text.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BalanceSheetTab extends StatefulWidget {
  double scale;
  String panNumber;
  BalanceSheetTab({Key key,this.scale = 1,@required this.panNumber}) : super(key: key);

  @override
  State<BalanceSheetTab> createState() => _BalanceSheetTabState();
}

class _BalanceSheetTabState extends State<BalanceSheetTab> {


  BalanceSheetModel balance =
  BalanceSheetModel([], {}, {}, {}, {}, {}, {}, {}, {}, {});
  bool dataLoaded = false;

  void getData() async {
    capsaPrint('data initiated ');
    var anchorsAnalysis =
    Provider.of<AnchorAnalysisProvider>(context, listen: false);
    balance = await anchorsAnalysis.fetchBalanceSheet(widget.panNumber);
    capsaPrint('data received $balance');
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
    //scale = Responsive.isMobile(context)?1:MediaQuery.of(context).size.width/1400.0;
    capsaPrint('Scale ${widget.scale}');
    return dataLoaded?Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(text: 'Key Balance Sheet data', left: 50 * widget.scale, top: 42 * widget.scale,scale: widget.scale),
          SizedBox(
            height: 52 * widget.scale,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:widget.scale==1? ((MediaQuery.of(context).size.width * 0.95) - 181):MediaQuery.of(context).size.width * 0.95,
                height: 526 * widget.scale,
                child: Stack(
                  children: [
                    Center(child: BalanceSheetBarChart(color: Color.fromRGBO(235, 87, 87, 1),scale: widget.scale, balance: balance,yearsPresent: balance.yearsPresent,)),
                    //Center(child: LineChart(color: Color.fromRGBO(235, 87, 87, 1),)),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(height: 10,),
          // Padding(
          //   padding: EdgeInsets.only(left: 50 * widget.scale),
          //   child: Text('* All values are in thousands of Naira',style: GoogleFonts.poppins(
          //       color: Colors.black,
          //       fontSize: widget.scale == 1 ? 12 : 6,
          //       fontWeight: FontWeight.w400),),
          // ),
          SizedBox(
            height: 40 * widget.scale,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 20,
                      color: Color.fromRGBO(0, 152, 219, 1),
          ),
                    SizedBox(width: 9,),
                    Text('Total Assets',style: GoogleFonts.poppins(fontSize: 19,fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 20,
                      color: Color.fromRGBO(242, 153, 74, 1),
                    ),
                    SizedBox(width: 9,),
                    Text('Total Liabilities',style: GoogleFonts.poppins(fontSize: 19,fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 20,
                      color: Color.fromRGBO(58, 192, 201, 1),
                    ),
                    SizedBox(width: 9,),
                    Text('Equity',style: GoogleFonts.poppins(fontSize: 19,fontWeight: FontWeight.w500),)
                  ],
                ),
              ),

              Container(
                child:  Row(
                  children: [
                    LineChartLegend(
                      color: Colors.red,
                      scale: widget.scale + 0.2,
                    ),
                    SizedBox(
                      width: 9 * widget.scale,
                    ),
                    Text(
                      'Financial Debt',
                        style: GoogleFonts.poppins(fontSize: 19,fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )

            ],
          ),
          SizedBox(
            height: 40 * widget.scale,
          ),
         BSTabularView(scale: widget.scale,model: balance,),
          //TabularView2(),
        ]):Center(child: CircularProgressIndicator(),);
  }
}
