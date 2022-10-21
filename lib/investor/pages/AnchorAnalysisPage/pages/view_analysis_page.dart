import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/bar_graph_analysis.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/credit_score_gauge.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/tabular_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ViewAnalysis extends StatefulWidget {
  const ViewAnalysis({Key key}) : super(key: key);

  @override
  State<ViewAnalysis> createState() => _ViewAnalysisState();
}

class _ViewAnalysisState extends State<ViewAnalysis>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.08,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(
                height: 15,
              ),
              Icon(
                Icons.arrow_back,
                color: Colors.blue,
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Anchor Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      //Icon(Icons.notifications),
                      Row(
                        children: [
                          Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.grey,
                            size: 32,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/icon2.png',
                            height: 50,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 36, right: 36),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.construction_outlined,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ardova Plc',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'RC1166422',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(22.0),
                //   child: Container(
                //     color: Colors.grey[400],
                //     height: 1,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.black,
                    indicatorWeight: 4,
                    labelStyle:
                        const TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: const [
                      Tab(
                        text: 'Profit And Loss',
                      ),
                      Tab(
                        text: 'Balance Sheet',
                      ),
                      Tab(
                        text: 'Profitablility Ratios',
                      ),
                      Tab(
                        text: 'Liquidity Ratios',
                      ),
                      Tab(
                        text: 'Capital Structure Ratios',
                      ),
                      Tab(
                        text: 'Solvency Ratios',
                      )
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 38,
                  ),
                  child: Text(
                    'Financial Highlights',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 38,
                  ),
                  child: Text(
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

               IntrinsicHeight(
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         BarGraphWidget(),
                         BarGraphWidget(),
                       ],
                     ),
                     SizedBox(height: 40,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         BarGraphWidget(),
                         BarGraphWidget(),
                       ],
                     )
                   ],
                 ),
               ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 38,
                  ),
                  child: Text(
                    'Key Financials',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                TabularView(),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
