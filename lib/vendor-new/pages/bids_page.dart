import 'package:beamer/beamer.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/widgets/capsaapp/generatedvendorbidsdesktopwidget/GeneratedVendorBidsDesktopWidget.dart';
import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BidsPage extends StatefulWidget {
  const BidsPage({Key key}) : super(key: key);

  @override
  _BidsPageState createState() => _BidsPageState();
}

class _BidsPageState extends State<BidsPage> {
  @override
  Widget build(BuildContext context) {
    final _profileProvider =
    Provider.of<ProfileProvider>(context, listen: true);
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

                      return _bidsModel.length>0?StaggeredGridView.countBuilder(
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
                          }):Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/No Bids Placed.png'),
                              SizedBox(height: 10,),
                              Text('No Bids Received',style: GoogleFonts.roboto(fontSize: 16),),
                              SizedBox(height: 10,),
                              InkWell(
                                onTap: (){
                                  var userData = Map<String, dynamic>.from(box.get('userData'));
                                  print('User Data $userData');

                                  int isBlackListed = int.parse(userData['isBlacklisted']);


                                  if(isBlackListed == 1){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          title: const Text(
                                            'Function Suspended',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'This functionality has been temporarily suspended',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),

                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: Text("Close".toUpperCase(),
                                                      style: TextStyle(fontSize: 14)),
                                                ),
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        Colors.white),
                                                    backgroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        Theme.of(context).primaryColor),
                                                    shape:
                                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(50),
                                                            side: BorderSide(
                                                                color: Theme.of(context)
                                                                    .primaryColor)))),
                                                onPressed: () =>
                                                    Navigator.of(context, rootNavigator: true)
                                                        .pop(),
                                              ),
                                            ),
                                          ],
                                        ));
                                    return;
                                  }

                                  if (_profileProvider.portfolioData.AL_UPLOAD != 2) {
                                    // capsaPrint('Add incoive check');
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          title: const Text(
                                            'Change of Account Letter',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _profileProvider.portfolioData.AL_UPLOAD == 1
                                                      ? 'Thank you for uploading your change of account form.\nPlease give us some minutes to verify your details.\nAn email will be sent to you shortly'
                                                      : 'To trade your Invoice, please upload change of account letter.',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            if (_profileProvider.portfolioData.AL_UPLOAD == 0)
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4),
                                                      child: Text(
                                                          "Upload account letter".toUpperCase(),
                                                          style: TextStyle(fontSize: 14)),
                                                    ),
                                                    style: ButtonStyle(
                                                        foregroundColor: MaterialStateProperty
                                                            .all<Color>(Colors.white),
                                                        backgroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            Theme.of(context).primaryColor),
                                                        shape:
                                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(50),
                                                                side: BorderSide(
                                                                    color: Theme.of(context)
                                                                        .primaryColor)))),
                                                    onPressed: () async {
                                                      //navigate();
                                                      Navigator.of(context, rootNavigator: true)
                                                          .pop();
                                                    }),
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: Text("Close".toUpperCase(),
                                                      style: TextStyle(fontSize: 14)),
                                                ),
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        Colors.white),
                                                    backgroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        Theme.of(context).primaryColor),
                                                    shape:
                                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(50),
                                                            side: BorderSide(
                                                                color: Theme.of(context)
                                                                    .primaryColor)))),
                                                onPressed: () =>
                                                    Navigator.of(context, rootNavigator: true)
                                                        .pop(),
                                              ),
                                            ),
                                            // TextButton(
                                            //   onPressed: () => {Navigator.of(context, rootNavigator: true).pop(), _tab.changeTab(3)},
                                            //   child: const Text('Update details'),
                                            // ),
                                          ],
                                        ));

                                    return;
                                  }

                                  if (_profileProvider.portfolioData.newUser) {
                                    if (_profileProvider
                                        .portfolioData.kyc1 !=
                                        2 ||
                                        _profileProvider.portfolioData.kyc2 != 2 ||
                                        _profileProvider.portfolioData.kyc3 != 2) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text(
                                                  'KYC',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                content: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: const [
                                                      Text(
                                                        'Your KYC Documents are currently being reviewed. Please give us some minutes to verify your details. An email will be sent to you shortly.',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal,
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: ElevatedButton(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(
                                                            4),
                                                        child: Text(
                                                            "Close".toUpperCase(),
                                                            style: TextStyle(
                                                                fontSize: 14)),
                                                      ),
                                                      style: ButtonStyle(
                                                          foregroundColor:
                                                          MaterialStateProperty.all<
                                                              Color>(
                                                              Colors.white),
                                                          backgroundColor:
                                                          MaterialStateProperty.all<
                                                              Color>(
                                                              Theme
                                                                  .of(context)
                                                                  .primaryColor),
                                                          shape:
                                                          MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      50),
                                                                  side: BorderSide(
                                                                      color: Theme
                                                                          .of(context)
                                                                          .primaryColor)))),
                                                      onPressed: () =>
                                                          Navigator.of(context,
                                                              rootNavigator: true)
                                                              .pop(),
                                                    ),
                                                  ),

                                                ],
                                              ));

                                      return;
                                    }
                                  }
                                  context.beamToNamed('/addInvoice');
                                },
                                child: Container(
                                  width: Responsive.isMobile(context)?double.infinity : 220,
                                  height: Responsive.isMobile(context) ? 48 : 59,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color.fromRGBO(0, 152, 219, 1),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Responsive.isMobile(context) ? 13 : 16,
                                      vertical: Responsive.isMobile(context) ? 13 : 16),
                                  child: Center(
                                    child: Text(
                                      'Upload Invoice',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: const Color.fromRGBO(242, 242, 242, 1),
                                          fontFamily: 'roboto',
                                          fontSize: Responsive.isMobile(context) ? 16 : 18,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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
