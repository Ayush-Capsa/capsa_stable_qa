import 'package:beamer/beamer.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/encryption.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountLetterDownload extends StatefulWidget {
  const AccountLetterDownload({Key key}) : super(key: key);

  @override
  State<AccountLetterDownload> createState() => _AccountLetterDownloadState();
}

class _AccountLetterDownloadState extends State<AccountLetterDownload> {
  String text1 = 'Change of Account Letters';
  String text2 =
      'The information required are for verification purposes. Capsa will never disclose your information to anyone else.';
  String text3 = '';
  String accountNumber = '';
  String bankName = '';
  String errorText = '';
  bool saving = false;

  List<dynamic> selectedList = [];

  List<String> dropList = [];
  Map<String, String> CIN = {};

  bool dataLoaded = false;

  void getAccountNumber() async {
    var _body = box.get('tmpUserData') ?? {};
    final _actionProvider =
        Provider.of<SignUpActionProvider>(context, listen: false);

    dynamic response = await _actionProvider.queryFewData();
    dynamic anchorsListResponse = await _actionProvider.getAnchorsList();

    //capsaPrint('Company Names : $anchorsListResponse');

    if(anchorsListResponse['res'] == 'success'){

      for(int i = 0;i<anchorsListResponse['data'].length;i++){
        dropList.add(anchorsListResponse['data'][i]['name']);
        CIN[anchorsListResponse['data'][i]['name']] = anchorsListResponse['data'][i]['cu_pan'];
      }

    }

    if(response['res'] == 'success') {
      accountNumber =
        response['data']['bankDetails'][0]['account_number'].toString();
      bankName = response['data']['bankDetails'][0]['bank_name'].toString();
    }else{
      errorText = 'Some unexpected error occurred!';
    }




    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getAccountNumber();
  }

  @override
  Widget build(BuildContext context) {
    final _actionProvider =
    Provider.of<SignUpActionProvider>(context, listen: false);
    var _body = box.get('tmpUserData') ?? {};
    //capsaPrint('SignUp Data : $_body');
    return Padding(
      padding: !Responsive.isMobile(context)
          ? EdgeInsets.only(left: 112, top: 70)
          : EdgeInsets.only(left: 20, top: 20),
      child: dataLoaded
          ? errorText == ''?SingleChildScrollView(
            child: Column(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Responsive.isMobile(context) ? 70 : 10,
                  ),
                  if (!Responsive.isMobile(context)) topHeading(),
                  if (Responsive.isMobile(context))
                    Text(
                      'Change Of Account\nLetter',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: HexColor('#333333')),
                    ),
                  SizedBox(
                    height: (!Responsive.isMobile(context)) ? 42 : 15,
                  ),
                  Container(
                    width: 400,
                    height: 180,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 19),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Capsa Bank Account Number',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: HexColor('#333333')),
                          ),
                          Text(
                            accountNumber,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 36,
                                color: HexColor('#0098DB')),
                          ),
                          Text(
                            bankName,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: HexColor('#828282')),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: (!Responsive.isMobile(context)) ? 42 : 15,
                  ),

                  Text('Select Anchors You Work With',style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: HexColor('#333333')),),
                  SizedBox(height: 5,),
                  Container(
                    width: Responsive.isMobile(context)? MediaQuery.of(context).size.width * 0.7:400,
                    //height: 80,
                    child: GFMultiSelect(
                      items: dropList,
                      onSelect: (value) {
                        //capsaPrint('selected $value ');
                        setState(() {
                          selectedList = value;
                        });
                      },
                      dropdownTitleTileText: 'Select Anchors ',
                      dropdownTitleTileColor: Colors.grey[200],
                      dropdownTitleTileMargin: EdgeInsets.only(
                          top: 22, left: 18, right: 18, bottom: 5),
                      dropdownTitleTilePadding: EdgeInsets.all(10),
                      dropdownUnderlineBorder: const BorderSide(
                          color: Colors.transparent, width: 2),
                      dropdownTitleTileBorder:
                      Border.all(color: Colors.grey[300], width: 1),
                      dropdownTitleTileBorderRadius: BorderRadius.circular(5),
                      expandedIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black54,
                      ),
                      collapsedIcon: const Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.black54,
                      ),
                      submitButton: Text('OK'),
                      dropdownTitleTileTextStyle: const TextStyle(
                          fontSize: 14, color: Colors.black54),
                      //padding: const EdgeInsets.all(6),
                      //margin: const EdgeInsets.all(6),
                      //type: GFCheckboxType.basic,
                      activeBgColor: Colors.green.withOpacity(0.5),
                      inactiveBorderColor: Colors.grey[200],
                    ),
                  ),


                  SizedBox(height: 15,),


                  saving?CircularProgressIndicator() : Column(
                    children: [
                      InkWell(
                        onTap: () async{
                          setState(() {
                            saving = true;
                          });

                          List<dynamic> cuGst = [];

                          if(selectedList.isNotEmpty){
                                      for (int i = 0;
                                          i < selectedList.length;
                                          i++) {
                                        cuGst.add(CIN[dropList[int.parse(
                                            selectedList[i].toString())]]);
                                      }

                                      dynamic saveAnchorResponse =
                                          await _actionProvider
                                              .saveAnchorList(cuGst);

                                      if (saveAnchorResponse['msg'] ==
                                          'success') {
                                        Beamer.of(context).beamToNamed(
                                            '/account-letter-upload/' +
                                                encryptList(selectedList));
                                        selectedList.length == 0
                                            ? null
                                            : await _actionProvider
                                                .downloadLetter();
                                      } else {
                                        showToast(
                                            saveAnchorResponse['msg'], context,
                                            type: 'error');
                                      }
                                    }else{
                            showToast(
                                'Select Anchors To Proceed', context,
                                type: 'warning');
                          }
                                    setState(() {
                            saving = false;
                          });
                        },
                        child: Container(
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: selectedList.length == 0?HexColor('#DBDBDB') : HexColor('#0098DB')
                          ),
                          child: Center(child: Text(
                            'Download Account Letters & Proceed',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: HexColor('#F2F2F2')),
                          ),),
                        ),
                      ),

                      SizedBox(height: 15,),


                      // InkWell(
                      //   onTap: () async{
                      //     setState(() {
                      //       saving = true;
                      //     });
                      //     List<dynamic> cuGst = [];
                      //
                      //     for(int i = 0;i<selectedList.length;i++){
                      //       cuGst.add(CIN[dropList[int.parse(selectedList[i].toString())]]);
                      //     }
                      //
                      //     dynamic saveAnchorResponse = await _actionProvider.saveAnchorList(cuGst);
                      //     setState(() {
                      //       saving = true;
                      //     });
                      //
                      //     if(saveAnchorResponse['msg'] == 'success') {
                      //       Beamer.of(context).beamToNamed('/account-letter-upload/'+encryptList(selectedList));
                      //     }else{
                      //       showToast(saveAnchorResponse['msg'], context, type: 'error');
                      //     }
                      //   },
                      //   child: Container(
                      //     width: 400,
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.all(Radius.circular(15)),
                      //         color: selectedList.length == 0?HexColor('#DBDBDB') : HexColor('#0098DB')
                      //     ),
                      //     child: Center(child: Text(
                      //       'Proceed',
                      //       style: GoogleFonts.poppins(
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 16,
                      //           color: HexColor('#F2F2F2')),
                      //     ),),
                      //   ),
                      // )

                    ],
                  ),



                ],
              ),
          ):Center(
        child: Text(
          errorText,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 36,
              color: Colors.red),
        ),
      )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget topHeading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap:(){
                  logout(context);
                },
                child: Container(
                  width: Responsive.isMobile(context)
                      ? 100 : 180 ,
                  height: Responsive.isMobile(context)
                      ? 42 : 58 ,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(15 )),
                      border: Border.all(color: Colors.red, width: 3 ),
                      ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.red,),
                        Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 14  : 20 ,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20,),
            ],
          ),
          SizedBox(height: 20,),
          Text(
            text1,
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 36,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.w600,
                height: 1),
          ),
          if (text2 != '')
            SizedBox(
              height: 20,
            ),
          if (text2 != '')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text2,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 18,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.w400,
                      height: 1),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text3,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: HexColor("#0098DB"),
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
