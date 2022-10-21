import 'package:capsa/admin/data/enquiry_list_data.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

class InvoiceScreenCard extends StatelessWidget {
  final List<EnquiryData> enquiryData;
  final String title;

  const InvoiceScreenCard({Key key, this.enquiryData, this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              if (enquiryData.isEmpty || enquiryData.isEmpty == null) {
                return Center(
                  child: Text('No Data'),
                );
              }
              final EnquiryData data = enquiryData[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    final tab =
                        Provider.of<TabBarModel>(context, listen: false);
                    tab.changeTab2(0, index, data, 'EnquiryEdit', title);
                  },
                  child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    'Requestor Name',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    data.bvnName,
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
                            flex: 2,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    'Email',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    data.email,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Status',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    data.status,
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
                      )),
                ),
              );
            }));
  }
}
