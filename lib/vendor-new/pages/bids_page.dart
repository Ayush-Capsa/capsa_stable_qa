import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/widgets/capsaapp/generatedvendorbidsdesktopwidget/GeneratedVendorBidsDesktopWidget.dart';
import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class BidsPage extends StatefulWidget {
  const BidsPage({Key key}) : super(key: key);

  @override
  _BidsPageState createState() => _BidsPageState();
}

class _BidsPageState extends State<BidsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Container(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!Responsive.isMobile(context))
              SizedBox(
                height: 22,
              ),
            TopBarWidget("Bids", "View and accept bids from investors"),
            if (!Responsive.isMobile(context))
              SizedBox(
                height: 22,
              ),
            Expanded(
              child: FutureBuilder<Object>(
                  future: Provider.of<VendorActionProvider>(context, listen: false).bidProposal(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'There was an error :( ' + snapshot.error.toString(),
                        style: Theme.of(context).textTheme.headline1,
                      );
                    } else if (snapshot.hasData) {
                      List<BidsModel> _bidsModel = [];
                      dynamic result = snapshot.data;
                      if (result['res'] == 'success') {
                        List proposalsList = result['data']['Proposalslist'];
                        int i = 0;
                        proposalsList.forEach((element) {
                          if(i == 0){
                            capsaPrint('Bids Data : $element');
                          }
                          i++;
                          BidsModel _dessert = BidsModel(
                            element['cust_pan'],
                            element['customer_name'],
                            element['description'],
                            element['docID'],
                            element['due_date'],
                            element['eff_due_date'],
                            element['int_rate'].toString(),
                            element['invoice_number'],
                            element['invoice_value'].toString(),
                            element['lender_name'].toString(),
                            element['lender_pan'],
                            element['p_type'].toString(),
                            element['prop_amt'].toString(),
                            element['prop_stat'].toString(),
                            element['sign_stat'].toString(),
                            element['start_date'],
                            element['nofBids'].toString(),
                            element['highBid'].toString(),
                            element['customer_rc'],
                          );

                          _bidsModel.add(_dessert);
                        });
                      }

                      // capsaPrint('bidsModel.length');
                      // capsaPrint(_bidsModel.length);

                      return StaggeredGridView.countBuilder(
                          crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
                          crossAxisSpacing: Responsive.isMobile(context) ? 20 : 50,
                          mainAxisSpacing: Responsive.isMobile(context) ? 20 : 50,
                          padding: EdgeInsets.all(5),
                          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                          // shrinkWrap: true,
                          itemCount: _bidsModel.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                                onTap: () => {context.beamToNamed('/bids/details/' + Uri.encodeComponent(_bidsModel[index].invoice_number))},
                                child: GeneratedVendorBidsDesktopWidget(_bidsModel[index]));
                          });
                    } else if (!snapshot.hasData) {
                      return Center(child: Text("No bids found."));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
