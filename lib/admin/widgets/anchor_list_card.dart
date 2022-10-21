import 'package:capsa/admin/data/anchor_data.dart';
import 'package:capsa/admin/data/enquiry_list_data.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class AnchorListCard extends StatelessWidget {
  final List<AnchorData> enquiryData;
  final String title;

  const AnchorListCard({Key key, this.enquiryData, this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: enquiryData.length,
        itemBuilder: (BuildContext context, int index) {
          final AnchorData data = enquiryData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 0),
            child: Card(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  final tab =
                      Provider.of<TabBarModel>(context, listen: false);
                  //   tab.changeTab2(0, index, data, 'AnchorEdit', 'AnchorEdit');
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'BVN No.',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                data.bvnNum,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Company Name',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                data.compName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'Address',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                data.address,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Industry',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                data.industry,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_right,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
              ),
            ),
          );
        });
  }
}
