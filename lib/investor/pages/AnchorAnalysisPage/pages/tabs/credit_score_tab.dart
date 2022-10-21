import 'package:capsa/investor/pages/AnchorAnalysisPage/provider/anchor_analysis_provider.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/credit_score_gauge.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/tabular_view/tabular_view.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/text.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/src/intl/number_format.dart';

class CreditScoreTab extends StatefulWidget {
  double scale;
  String panNumber;
  CreditScoreTab({Key key, this.scale = 1,@required this.panNumber}) : super(key: key);

  @override
  State<CreditScoreTab> createState() => _CreditScoreTabState();
}

class _CreditScoreTabState extends State<CreditScoreTab> {
  int creditScore = 5;
  bool dataLoaded = false;
  CreditScoreModel creditScoreModel;
  String companyDetails;


  void getData() async {
    var anchorsAnalysis =
        Provider.of<AnchorAnalysisProvider>(context, listen: false);
    creditScoreModel =
        await anchorsAnalysis.fetchCreditScore(widget.panNumber, '2022');
    creditScore = creditScoreModel.result.floor();
    Map<String, dynamic> details = await anchorsAnalysis.fetchCompanyDetails(widget.panNumber);
    //capsaPrint('Credit Score Data $result ${widget.panNumber}');
    companyDetails = details['about'];
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState(){
    super.initState();
    capsaPrint('Scale :${widget.scale}');
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return dataLoaded?Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(
            text: 'About this company',
            left: 50 * widget.scale,
            top: 42 * widget.scale,
            scale: widget.scale),
        content(
            text:
              companyDetails,
            //'Ardova Plc is a Nigerian leading indigenous and integrated energy company involved in the distribution of petroleum products. With an extensive network of over 450 retail outlets in Nigeria and significant storage facilities in Apapa, Lagos and Onne, Rivers State, we procure and distribute petrol (PMS), diesel (AGO), kerosene (DPK) and liquefied petroleum gas (LPG). Our services also involve the manufacturing and distribution of a wide range of quality lubricants from our oil blending plant in Apapa, Lagos. These lubricants include: Super V, Visco 2000 and Diesel Motor Oil. We are also the sole authorised distributor of Shell branded Helix Engine Oils in Nigeria.',
            top: 9,
            left: 50 * widget.scale,
            right: 160 * widget.scale,
            scale: widget.scale),
        SizedBox(
          height: 70 * widget.scale,
        ),
        header(
            text: 'Credit Score', left: 50 * widget.scale, scale: widget.scale),
        SizedBox(
          height: widget.scale == 1?106:30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CreditScore(
              score: (creditScore * 3.6).toDouble(),
              // score: 200.0,
              scale: widget.scale,
            ),
          ],
        ),
        SizedBox(
          height: widget.scale == 1?138:198 * widget.scale,
        ),
        header(
            text: 'Credit Score Summary',
            left: 50 * widget.scale,
            scale: widget.scale),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 64 * widget.scale,
        ),
        Center(
            child: Padding(
          padding: EdgeInsets.only(
              left: 24 * widget.scale,
              right: 24 * widget.scale,
              top: 24 * widget.scale,
              bottom: 32 * widget.scale),
          child: TabularView(
            model: creditScoreModel,
            scale: widget.scale,
          ),
        )),
      ],
    ):Center(child: CircularProgressIndicator(),);
  }
}
