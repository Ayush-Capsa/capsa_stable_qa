import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/hexcolor.dart';
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

  double poolAccountBalance;
  double capsaAccountBalance;

  String errorText = '';

  void getReconciliationApi() async{

    ProfileProvider profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);

    dynamic response = await profileProvider.reconcileApi();

    capsaPrint('Pass 1');

    try {
      poolAccountBalance = double.parse(response['data']['totalClosingBalance'].toString());
      capsaAccountBalance = double.parse(response['data']['stanbicBalance'].toString());
      errorText = '';
    } catch (e) {
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

          !apiResponseFetched?SizedBox(height: MediaQuery.of(context).size.height * 0.4,):SizedBox(height: 80,),

          apiResponseFetched?

             errorText == '' ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text ('Pool Account Balance : ', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.grey),),

                        Text (formatCurrency(poolAccountBalance, withIcon: true), style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black),)
                      ],
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.025,),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text ('Capsa Platform Balance : ', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.grey),),
                        Text (formatCurrency(capsaAccountBalance, withIcon: true), style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black),)
                      ],
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                  Container(width: MediaQuery.of(context).size.width * 0.6 ,height: 2, color: Colors.black,),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text ('Difference : ', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.grey),),
                        Text (formatCurrency(poolAccountBalance-capsaAccountBalance, withIcon: true), style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black),)
                      ],
                    ),
                  ),





                ],
              ):Center(
               child: Text(errorText,style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 36, color: Colors.black),),
             ):Container(),

          apiResponseFetched?SizedBox(height: MediaQuery.of(context).size.height * 0.04,):Container(),

          !loading?Container(
            width: 260,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),

            ),
            child: Center(
              child: InkWell(
                onTap: (){

                  if(!loading){
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
                    child: Text('Reconcile',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ):Center(child: CircularProgressIndicator(),)


        ],
      ),
    );
  }
}
