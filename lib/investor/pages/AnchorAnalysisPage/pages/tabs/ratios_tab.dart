import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/tabular_view/ratios_tabular_view.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class RatiosTab extends StatefulWidget {
  double scale;
  String panNumber;
  RatiosTab({Key key, this.scale = 1, @required this.panNumber})
      : super(key: key);

  @override
  State<RatiosTab> createState() => _RatiosTabState();
}

class _RatiosTabState extends State<RatiosTab> {
  List<Widget> datas = [];
  bool dataLoaded = false;


  List<String> generateHeaders(String name, dynamic yearsPresent) {
    List<String> result = [];
    result.add(name);
    yearsPresent.forEach((element) {
      result.add(element);
    });
    // print('Generated headers ${result.length}');
    return result;

    //print("Header length ")
  }

  List<String> generateInfo(
      String name, Map data, String parameterName, dynamic yearsPresent,
      {bool roundedValue = true}) {
    // print('Info initialised');
    List<String> result = [];
    result.add(name);
    // print('Info initialised 2');

    yearsPresent.forEach((element) {
      // print('DATA INFO ${element.toString()} $parameterName ${data['data'][element.toString()][parameterName]}');
      roundedValue
          ? result.add((data['data'][element.toString()][parameterName] != null && data['data'][element.toString()][parameterName] != '')
              ? '${(double.parse((data['data'][element.toString()][parameterName]).toString()) * 100).floor()}%'
              : 'NA')
          : result.add((data['data'][element.toString()][parameterName] != null && data['data'][element.toString()][parameterName] != '')
              ? '${(double.parse((data['data'][element.toString()][parameterName]).toString()) * 100).toStringAsFixed(2)}%'
              : 'NA');
    });
    // print('Info initialised ${result.length}');
    return result;
  }

  List<String> generateSpace(int length){
    List<String> result = [];
    for(int i = 0;i<=length;i++){
      result.add('');
    }
    // print('length ${result.length}');
    return result;
  }

  Map result;

  void getData() async {
    var anchorsAnalysis =
        Provider.of<AnchorAnalysisProvider>(context, listen: false);
    result = await anchorsAnalysis.fetchKeyRatios(widget.panNumber, '2022');

    capsaPrint(
        'Key Ratios Data $result ');

    datas.add(
      header(
          text: 'Ratios',
          left: 50 * widget.scale,
          top: 42 * widget.scale,
          scale: widget.scale),
    );

    datas.add(
      SizedBox(
        height: 52 * widget.scale,
      ),
    );

    // print('Pass 1');

    datas.add(
      RTabularView(
        showGrowth: false,
        headers:
            generateHeaders('Profitability Ratios', result['yearsPresent']),
        rows: [
          generateInfo('ROE (Return on Equity)', result,
              'ROE (Return on Equity)', result['yearsPresent']),
          generateInfo('ROA (Return on Assets)', result,
              'ROA (Return on Assests)', result['yearsPresent']),
          generateInfo('Retained Earnings to Total Assets Ratio', result,
              'Retained Earnings to Total Assets Ratio', result['yearsPresent']),
          generateSpace(result['yearsPresent'].length),
        ],
        scale: widget.scale,
      ),
    );

    // print('Pass 2');

    datas.add(
      RTabularView(
        showGrowth: false,
        headers: generateHeaders('Liquidity Ratios', result['yearsPresent']),
        rows: [
          generateInfo('Current Ratio', result,
              'Current Ratio', result['yearsPresent']),
          generateInfo('Quick Ratio', result,
              'Current Ratio', result['yearsPresent']),
          generateInfo('Days Payable', result,
              'Days Payable', result['yearsPresent']),
          generateInfo('Days Receivable', result,
              'Days Receviables', result['yearsPresent']),
          generateSpace(result['yearsPresent'].length),
        ],
        scale: widget.scale,
      ),
    );

    // print('Pass 3');

    datas.add(
      RTabularView(
        showGrowth: false,
        headers: generateHeaders('Capital Structure Ratios', result['yearsPresent']),
        rows: [
          generateInfo('Debt to Equity Ratio', result,
              'Debt To Equity Ratio', result['yearsPresent']),
          generateInfo('Leverage Ratio', result,
              'Leverage Ratio', result['yearsPresent']),
          generateInfo('Working Capital to Asset Ratio', result,
              'Working Capital to Asset Ratio', result['yearsPresent']),
          generateSpace(result['yearsPresent'].length),
        ],
        scale: widget.scale,
      ),
    );

    // print('Pass 4');

    datas.add(
      RTabularView(
        showGrowth: false,
        headers: generateHeaders('Solvency Ratios', result['yearsPresent']),
        rows: [
          generateInfo('Debt to EBITDA Ratio', result,
              'Debt To EBITDA', result['yearsPresent']),
          generateInfo('EBIT/EBITDA to Interest Coverage Ratio', result,
              'EBIT/EBITDA to Interest Coverage Ratio', result['yearsPresent']),
          generateInfo('Debt to Operating Cash Flow Ratio', result,
              'Debt to Operating Cash flow Ratio', result['yearsPresent']),
          generateInfo('Operating cash flow to Short-term Debt', result,
              'Operating Cash flow to Short-term Debt', result['yearsPresent']),
          generateSpace(result['yearsPresent'].length),
        ],
        scale: widget.scale,
      ),
    );

    // print('Pass 5');

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    // var anchorsAnalysis =
    // Provider.of<AnchorAnalysisProvider>(context, listen: false);
    // Map result = await anchorsAnalysis.fetchKeyRatios(widget.panNumber, '2022');
  }

  @override
  Widget build(BuildContext context) {
    return dataLoaded
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
           // [
           //   RTabularView(
           //     showGrowth: false,
           //     headers:
           //     generateHeaders('Profitability Ratios', result['yearsPresent']),
           //     rows: [
           //       generateInfo('ROE (Return on Equity)', result,
           //           'ROE (Return on Equity)', result['yearsPresent']),
           //       generateInfo('ROA (Return on Assets)', result,
           //           'ROA (Return on Assests)', result['yearsPresent']),
           //       generateInfo('Retained Earnings to Total Assets Ratio', result,
           //           'Retained Earnings to Total Assets Ratio', result['yearsPresent']),
           //       const ['', '', '', ''],
           //     ],
           //     scale: widget.scale,
           //   ),
           // ]
           datas
         )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
