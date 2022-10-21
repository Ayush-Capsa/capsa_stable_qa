import  'package:capsa/admin/widgets/card_widget.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../charts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2020, 11, 1), 5),
      new TimeSeriesSales(new DateTime(2020, 12, 1), 25),
      new TimeSeriesSales(new DateTime(2021, 1, 1), 50),
      new TimeSeriesSales(new DateTime(2021, 2, 1), 25),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        areaColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardFragment(
                  title: 'Total Transaction Value',
                  subtitle: '33 Discounts',
                  no: '54,000,000',
                  width: 420,
                  icon: LineAwesomeIcons.pie_chart,
                ),
                const SizedBox(
                  width: 10,
                ),
                CardFragment(
                  title: 'Total Returns',
                  subtitle: '12%',
                  no: '34,222,333',
                  width: 420,
                  icon: LineAwesomeIcons.line_chart,
                ),
                const SizedBox(
                  width: 10,
                ),
                CardFragment(
                  title: 'Upcoming Payment',
                  subtitle: '01/04/2021',
                  no: '33,500,000',
                  width: 420,
                  icon: LineAwesomeIcons.credit_card,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 420,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last 4 Investment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text('₦ 451,200', style: TextStyle(fontSize: 22)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('To Echelion'),
                        Row(
                          children: [
                            SizedBox(
                              width: 300,
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: 4.0,
                                percent: 0.2,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                backgroundColor: Colors.grey[200],
                                progressColor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '2.30%',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text('₦ 1,917,451,200', style: TextStyle(fontSize: 22)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('To Midas Touche'),
                        Row(
                          children: [
                            SizedBox(
                              width: 300,
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: 4.0,
                                percent: 0.977,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                backgroundColor: Colors.grey[200],
                                progressColor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '97.70%',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text('₦', style: TextStyle(fontSize: 22)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('To'),
                        Row(
                          children: [
                            SizedBox(
                              width: 300,
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: 4.0,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                backgroundColor: Colors.grey[200],
                                progressColor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '%',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text('₦', style: TextStyle(fontSize: 22)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('To'),
                        Row(
                          children: [
                            SizedBox(
                              width: 300,
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: 4.0,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                backgroundColor: Colors.grey[200],
                                progressColor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '%',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: 470,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Portfolio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 360,
                          width: 460,
                          child: SimpleTimeSeriesChart(_createSampleData()),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
