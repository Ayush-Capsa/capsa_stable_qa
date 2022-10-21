import 'package:capsa/admin/data/dashboard_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:capsa/admin/widgets/file_info_card.dart';
import 'package:capsa/admin/widgets/storage_details.dart';
import 'package:capsa/admin/widgets/storage_details_2.dart';
import 'package:capsa/admin/widgets/storage_details_3.dart';
import 'package:capsa/functions/export_to_csv.dart';

// import 'package:capsa/common/app_theme.dart';
// import 'package:capsa/functions/currency_format.dart';
// import 'package:capsa/functions/show_toast.dart';
import 'package:csv/csv.dart';
import 'package:capsa/common/responsive.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/admin/common/constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final String title;

  const DashboardPage({Key key, this.title}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final cellStyle = TextStyle(
    color: Colors.blueGrey[800],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  csvExport() {
    List<List<dynamic>> rows = [];

    rows.add(["", "", '']);
    rows.add(["No of Vendors", '', result['set1']['requestorCount']]);
    rows.add(["No of Investors", '', result['set1']['investorCount']]);
    rows.add(["No of Anchors", '', result['set1']['anchorCount']]);
    rows.add(["Total number of users ", '', result['set1']['totaluser']]);
    rows.add(["", "", '']);
    rows.add(["", "", '']);

    rows.add(["Vendor volume traded ", '', result['set2']['VVT']]);
    rows.add(["Investor volume invested", '', result['set2']['IVI']]);
    rows.add(["Total Value of Invoice Traded", '', result['set2']['TVITsum']]);
    rows.add(["Total Payment Volume ", '', result['set2']['TPV']]);

    rows.add(["", "", '']);
    rows.add(["", "", '']);

    rows.add(["Average Invoice value traded ", '', result['set3']['AIVTavg']]);
    rows.add(["Average discount rate for traded invoices (%)", '', result['set3']['ADIVTavg']]);
    rows.add(["Average tenor of invoices traded ", '', result['set3']['ATIT']]);
    rows.add(["", "", '']);
    rows.add(["", "", '']);

    rows.add(["Conversion rate", '', result['set5']['ConversionRate']]);
    rows.add(["Churn rate ", '', result['set5']['Churnrate']]);
    rows.add(["", "", '']);
    rows.add(["", "", '']);

    rows.add(["Active Vendors", '', result['set4']['ActiveVendor']]);
    rows.add(["Active Investors", '', result['set4']['ActiveInvestor']]);

    String dataAsCSV = const ListToCsvConverter().convert(
      rows,
    );
    var now = new DateTime.now();

    exportToCSV(dataAsCSV, fName: "Dashboard " + new DateFormat("yyyy-MM-dd-hh-mm").format(now) + ".csv");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dynamic result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isMobile(context)
          ? FutureBuilder(
              future: Provider.of<ActionModel>(context, listen: false).queryAdminDashboard(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  result = snapshot.data;
                  if (result['res'] == "success") {
                    result = result['data'];
                  } else {
                    return Text(result['messg']);
                  }
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          FileInfoCardGridView(resultSet1: result['set1'], crossAxisCount: 2),
                          SizedBox(height: 20),
                          StarageDetails(resultSet2: result['set2']),
                          SizedBox(height: 20),
                          StarageDetails2(resultSet3: result['set3']),
                          SizedBox(height: 20),
                          StarageDetails3(resultSet4: result['set4'], set: false),
                          SizedBox(height: 20),
                          StarageDetails3(resultSet4: result['set5'], set: true),
                        ],
                      ),
                    ),
                  );
                }
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ));
              })
          : SingleChildScrollView(
              child: Padding(
                padding: Responsive.isDesktop(context) ? const EdgeInsets.fromLTRB(20, 0, 20, 0) : const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                '${widget.title}',
                                style: TextStyle(fontSize: 22, color: Colors.grey[700], fontWeight: FontWeight.bold, letterSpacing: 1),
                              ),
                            ),
                          ),
                        ),
                        Responsive.isDesktop(context)
                            ? Spacer(
                                flex: 3,
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 12 : 20,
                    ),
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).primaryColor,
                        thickness: 0,
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 12 : 20,
                    ),
                    Row(
                      children: [
                        Spacer(
                          flex: Responsive.isDesktop(context) ? 4 : 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 8 : 15,
                    ),
                    FutureBuilder(
                        future: Provider.of<ActionModel>(context, listen: false).queryAdminDashboard(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            result = snapshot.data;
                            if (result['res'] == "success") {
                              result = result['data'];
                            } else {
                              return Text(result['messg']);
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.download_rounded),
                                  onPressed: () {
                                  capsaPrint('excel download');

                                  csvExport();
                                },),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(child: FileInfoCardGridView(resultSet1: result['set1'])),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 3.7,
                                                  child: StarageDetails2(resultSet3: result['set3']),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width / 3.7,
                                                      child: StarageDetails3(
                                                        resultSet4: result['set4'],
                                                        set: false,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width / 3.7,
                                                      child: StarageDetails3(
                                                        resultSet4: result['set5'],
                                                        set: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Column(
                                        children: [
                                          // Center(child: FileInfoCardGridView()),
                                          StarageDetails(resultSet2: result['set2']),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        })
                  ],
                ),
              ),
            ),
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  FileInfoCardGridView({
    Key key,
    this.resultSet1,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final dynamic resultSet1;

  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    final List<DashboardDataInfo> _dashboardDataInfo = [
      DashboardDataInfo(
        title: "No of Vendors",
        numOfFiles: resultSet1['requestorCount'].toString(),
        // svgSrc: "",
        icon: Icons.supervised_user_circle_sharp,
        // totalStorage: "1.9GB",
        color: Colors.white,
        // percentage: 35,
      ),
      DashboardDataInfo(
        title: "No of Investor",
        numOfFiles: resultSet1['investorCount'].toString(),
        // svgSrc: "",
        icon: Icons.supervised_user_circle_sharp,
        // totalStorage: "1.9GB",
        color: Colors.white,
        // percentage: 35,
      ),
      DashboardDataInfo(
        title: "No of Anchors",
        numOfFiles: resultSet1['anchorCount'].toString(),
        // svgSrc: "",
        icon: Icons.supervised_user_circle_sharp,
        // totalStorage: "1.9GB",
        color: Colors.white,
        // percentage: 35,
      ),
      DashboardDataInfo(
        title: "Total no of users",
        numOfFiles: resultSet1['totaluser'].toString(),
        // svgSrc: "",
        icon: Icons.supervised_user_circle_sharp,
        // totalStorage: "1.9GB",
        color: Colors.white,
        // percentage: 35,
      ),
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _dashboardDataInfo.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => InkWell(
        onTap: (){
          if(index == 0){
            tab.changeTab(3);
          }
          if(index == 1){
            tab.changeTab(2);
          }
        },
          child: FileInfoCard(info: _dashboardDataInfo[index])
      ),
    );
  }
}
