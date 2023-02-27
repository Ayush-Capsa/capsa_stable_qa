import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/admin/screens/reconcilation/closing_balance_list.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReconciliationScreen extends StatefulWidget {
  const ReconciliationScreen({Key key}) : super(key: key);

  @override
  State<ReconciliationScreen> createState() => _ReconciliationScreenState();
}

class _ReconciliationScreenState extends State<ReconciliationScreen> {
  bool apiResponseFetched = false, loading = false;

  String poolAccountBalance = '';
  String capsaAccountBalance = '';
  String difference = '';

  String errorText = '';

  dynamic closingBalanceList;

  void getReconciliationApi() async {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    dynamic platformBalanceResponse =
        await profileProvider.reconcilePlatformBalanceApi();
    dynamic poolBalanceResponse =
        await profileProvider.reconcilePoolBalanceApi();

    closingBalanceList = await profileProvider.closingBalanceList();

    capsaPrint('Pass 1 $platformBalanceResponse $poolBalanceResponse');


    try{
      capsaAccountBalance = platformBalanceResponse['message'] != 'success'
          ? 'Error!'
          : formatCurrency(
              double.parse(platformBalanceResponse['data']
                      ['totalClosingBalance']
                  .toString()),
              withIcon: true);
      poolAccountBalance = poolBalanceResponse['message'] != 'success'
          ? 'Error!'
          : formatCurrency(
              double.parse(
                  poolBalanceResponse['data']['stanbicBalance'].toString()),
              withIcon: true);
      capsaPrint('Pass 2 $capsaAccountBalance $poolAccountBalance ');
      if (capsaAccountBalance != 'Error!' && poolAccountBalance != 'Error!') {
        capsaPrint('pass 3');
        difference = (double.parse(
                    poolBalanceResponse['data']['stanbicBalance'].toString()) -
                double.parse(platformBalanceResponse['data']
                        ['totalClosingBalance']
                    .toString()))
            .toString();
      } else {
        difference = 'Error!';
      }
      errorText = '';
    }catch(e){
      errorText = 'Some unexpected error occurred!';
    }



    setState(() {
      apiResponseFetched = true;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.fromLTRB(20, 0, 20, 0)
            : const EdgeInsets.fromLTRB(5, 0, 5, 0),
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Reconciliation',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
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
            height: Responsive.isMobile(context) ? 12 : 30,
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
            height: Responsive.isMobile(context) ? 12 : 35,
          ),
          !apiResponseFetched
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                )
              : SizedBox(
                  height: 80,
                ),
          apiResponseFetched
              ? errorText == ''
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 320,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pool Account Balance : ',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                            color: Colors.grey),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                width: 320,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      poolAccountBalance,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                width: 180,
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 320,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Capsa Platform Balance : ',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                            color: Colors.grey),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                width: 320,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      capsaAccountBalance,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                            create: (context) =>
                                                ProfileProvider(),
                                            child: ClosingBalanceList(
                                              model: closingBalanceList,
                                            )),
                                  ));
                                },
                                child: Container(
                                  width: 180,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Center(
                                      child: Text(
                                    'Balance History',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 2,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 320,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Difference : ',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                width: 320,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                     difference,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                width: 180,
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        errorText,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 36,
                            color: Colors.black),
                      ),
                    )
              : Container(),
          apiResponseFetched
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                )
              : Container(),
          !loading
              ? Container(
                  width: 260,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (!loading) {
                          setState(() {
                            loading = true;
                          });
                          getReconciliationApi();
                        }
                      },
                      child: Container(
                        width: 260,
                        height: 54,
                        decoration: BoxDecoration(
                          color: HexColor('#0098DB'),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            'Reconcile',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }
}
