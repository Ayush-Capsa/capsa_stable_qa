import 'dart:convert';

import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/main.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/admin/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:http/http.dart' as http;
import 'package:capsa/functions/call_api.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:html' as html;

class ViewKycDocumentScreen extends StatefulWidget {
  String cacCertificate;
  String cacForm;
  String validId;
  PendingAccountData data;
  ViewKycDocumentScreen(
      {Key key, this.cacCertificate, this.cacForm, this.validId, this.data})
      : super(key: key);

  @override
  State<ViewKycDocumentScreen> createState() => _ViewKycDocumentScreenState();
}

class _ViewKycDocumentScreenState extends State<ViewKycDocumentScreen> {
  final emailController = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  String _email = '';

  bool cacCertificate = false;
  bool cacForm = false;
  bool validId = false;

  String cacCertificateStatus = "";
  String cacFormStatus = "";
  String validIdStatus = "";

  bool value(dynamic x) {
    if (x.toString() == '1') {
      return true;
    } else {
      return false;
    }
  }

  String stringInterpretation(bool x) {
    return x ? '1' : '0';
  }

  Widget preferenceCheck(Widget w, String title, String subText) {
    bool c = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          w,
          SizedBox(
            width: 33,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: HexColor('#333333')),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                subText,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#333333')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool saving = false;

  bool isSet = false;

  bool valuesSet = false;

  Future _future;



  Future<Object> checkDocumentStatus(dynamic _body,{panNumber = null, role = null}) async {
    // capsaPrint('here 1');
    if (box.get('isAuthenticated', defaultValue: false)) {
      var userData = Map<String, dynamic>.from(box.get('userData'));
      // _body['panNumber'] = userData['panNumber'];
      dynamic _uri;
      capsaPrint('SEt KYC status $_body');
      // if (_role == 'INVESTOR')
      //   _uri = apiUrl + 'dashboard/i/profile';
      // else
      _uri = apiUrl + '/admin/getKycStatus';

      _uri = Uri.parse(_uri);
      var response = await http.post(_uri,
          headers: <String, String>{
            'Authorization': 'Basic ' + box.get('token', defaultValue: '0')
          },
          body: _body);
      var data = jsonDecode(response.body);

      capsaPrint('fetch Kyc Status response : $data');

      if(data['msg'] == 'success'){
        cacCertificateStatus = data['data']['KYC1'].toString();
        cacFormStatus = data['data']['KYC2'].toString();
        validIdStatus = data['data']['KYC3'].toString();
      }




      // if (data['res'] == 'success') {
      //   var _data = data['data'];
      //   // capsaPrint('_data');
      //   // capsaPrint(_data);
      //
      //   var bankDetails = _data['bankDetails'];
      //   List<ProfileModel> _profileModel = [];
      //
      //   _bidHistoryDataList.addAll(_profileModel);
      //   notifyListeners();
      // }
      return data;
    }
    return null;
  }


  void downloadFile(String url) {
    html.AnchorElement anchorElement =  html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }



  void documentStatusCheck()async{

    capsaPrint('Pass 0');

    //final profileProvider = Provider.of<ProfileProvider>(context);

    setState(() {
      saving = true;
    });

    //await Future.delayed(const Duration(seconds: 1));

    var _body = {
      "panNumber":
      widget.data.panNumber
    };

    capsaPrint('Pass 1');

    dynamic response =
        await checkDocumentStatus(
        _body);

    capsaPrint('Pass 2');

    capsaPrint('Document Status : $response');

    //if()

    setState(() {
      saving = false;
    });



  }

  @override
  void initState() {
    super.initState();
    //final profileProvider = Provider.of<ProfileProvider>(context);\
    //final profileProvider = Provider.of<ProfileProvider>(context);
    final Box box = Hive.box('capsaBox');
    var userData = Map<String, dynamic>.from(box.get('userData'));

    documentStatusCheck();
    // if(!valuesSet) {
    //   _asyncmethodCall(profileProvider);
    // }

    //capsaPrint("\n\nUserdata $userData \nPanNumber ${widget.panNumber}");

    emailController.text = userData['email'];
  }

  @override
  Widget build(BuildContext context) {
    //UserData userDetails = profileProvider.userDetails;

    final profileProvider = Provider.of<ProfileProvider>(context);



    if (!saving) {
      isSet = true;
    }
    final Box box = Hive.box('capsaBox');






    return Scaffold(
      body: Row(
        children: [
          Container(
            //width: 185,
            margin: EdgeInsets.all(0),
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.11,
            // color: Colors.black,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              color: Colors.black,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50.5, 36, 50.5, 24),
                    child: SizedBox(
                      width: 80,
                      height: 45.42,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ChangeNotifierProvider(
                      //         create: (BuildContext
                      //         context) =>
                      //             AnchorActionProvider(),
                      //         child:
                      //        AnchorHomePage()),
                      //   ),
                      // );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: HexColor("#0098DB"),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 22,
                          ),
                          TopBarWidget("KYC Documents",
                              'Accept KYC documents uploaded by user'),
                          Text(
                            "",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          !saving?Container(
                            // height: MediaQuery.of(context).size.height * 0.8,
                            width: Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.53,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                OrientationSwitcher(
                                  orientation: 'Column',
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    widget.data.role2 == 'individual' ? Container() :
                                    Row(
                                      children: [
                                        Container(
                                          width: 550,
                                          height: 820,
                                          child: Column(
                                            children: [
                                              Text(
                                                'CAC Certificate',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 32),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  width: 550,
                                                  height: 700,
                                                  color: Colors.grey[200],
                                                  child: notNull(
                                                          widget.cacCertificate)
                                                      ? widget.data
                                                                  .cacCertificateExt ==
                                                              'pdf'
                                                          ? SfPdfViewer.network(
                                                              widget.cacCertificate)
                                                          : Image.network(
                                                              widget.cacCertificate,
                                                              loadingBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget child,
                                                                      ImageChunkEvent
                                                                          loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null)
                                                                  return child;
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress
                                                                                .expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress
                                                                                .cumulativeBytesLoaded /
                                                                            loadingProgress
                                                                                .expectedTotalBytes
                                                                        : null,
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                      : Center(
                                                          child: Text(
                                                              'File not available'),
                                                        )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              if(notNull(
                                                  widget.cacCertificate))
                                              cacCertificateStatus == '2' ?
                                              Row(
                                                children: [
                                                  Icon(Icons.check, color: Colors.green,),
                                                  SizedBox(width: 10,),
                                                  Text('Document has been accepted', style: GoogleFonts.poppins(fontSize: 20),),
                                                ],
                                              ):
                                              cacCertificateStatus == '3'?
                                              Row(
                                                children: [
                                                  Icon(Icons.cancel, color: Colors.red,),
                                                  SizedBox(width: 10,),
                                                  Text('Document has been rejected', style: GoogleFonts.poppins(fontSize: 20),),
                                                ],
                                              ):
                                              !notNull(
                                                  widget.cacCertificate)?Container():Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        saving = true;
                                                      });
                                                      var _body = {
                                                        "doctype": 'CAC_Certificate',
                                                        "status": '1',
                                                        "panNumber":
                                                        widget.data.panNumber
                                                      };

                                                      dynamic response =
                                                      await profileProvider
                                                          .setPendingAccountKycStatus(
                                                          _body);

                                                      capsaPrint('Cac Form Response : $response');

                                                      //if()

                                                      documentStatusCheck();
                                                    },
                                                    child: Container(
                                                      decoration:
                                                      const BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(15),
                                                          topRight:
                                                          Radius.circular(15),
                                                          bottomLeft:
                                                          Radius.circular(15),
                                                          bottomRight:
                                                          Radius.circular(15),
                                                        ),
                                                        color: Colors.green,
                                                      ),
                                                      width: Responsive.isMobile(
                                                          context)
                                                          ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.8
                                                          : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.1,
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 16),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: const <Widget>[
                                                            Text(
                                                              'Accept',
                                                              textAlign:
                                                              TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      242,
                                                                      242,
                                                                      242,
                                                                      1),
                                                                  fontFamily:
                                                                  'Poppins',
                                                                  fontSize: 18,
                                                                  letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                                  height: 1),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        saving = true;
                                                      });
                                                      var _body = {
                                                        "doctype": 'CAC_Certificate',
                                                        "status": '0',
                                                        "panNumber":
                                                        widget.data.panNumber
                                                      };

                                                      dynamic response =
                                                      await profileProvider
                                                          .setPendingAccountKycStatus(
                                                          _body);

                                                      capsaPrint('Cac Form Response : $response');

                                                      documentStatusCheck();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(15),
                                                          topRight:
                                                          Radius.circular(15),
                                                          bottomLeft:
                                                          Radius.circular(15),
                                                          bottomRight:
                                                          Radius.circular(15),
                                                        ),
                                                        color: Colors.red,
                                                      ),
                                                      width:
                                                      Responsive.isMobile(context)
                                                          ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.8
                                                          : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.1,
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 16),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: <Widget>[
                                                            Text(
                                                              'Reject',
                                                              textAlign:
                                                              TextAlign.center,
                                                              style: TextStyle(
                                                                  color:
                                                                  Color.fromRGBO(
                                                                      242,
                                                                      242,
                                                                      242,
                                                                      1),
                                                                  fontFamily:
                                                                  'Poppins',
                                                                  fontSize: 18,
                                                                  letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                                  height: 1),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width : 16),
                                        InkWell(
                                            onTap : (){
                                              downloadFile(widget.cacCertificate);
                                            },
                                            child: Icon(Icons.download))
                                      ],
                                    ),
                                    widget.data.role2 == 'individual' ? Container() : SizedBox(
                                      height: 40,
                                    ),
                                    widget.data.role2 == 'individual' ? Container() : Container(
                                      width: 550,
                                      height: 820,
                                      child: Column(
                                        children: [
                                          Text(
                                            'CAC Form',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 32),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              width: 550,
                                              height: 700,
                                              color: Colors.grey[200],
                                              child: notNull(widget.cacForm)
                                                  ? widget.data.cacFormExt ==
                                                          'pdf'
                                                      ? SfPdfViewer.network(
                                                          widget.cacForm)
                                                      : Image.network(
                                                          widget.cacForm,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        loadingProgress
                                                                            .expectedTotalBytes
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                  : Center(
                                                      child: Text(
                                                          'File not available'),
                                                    )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if(notNull(
                                              widget.cacForm))
                                          cacFormStatus == '2' ?
                                          Row(
                                            children: [
                                              Icon(Icons.check, color: Colors.green,),
                                              SizedBox(width: 10,),
                                              Text('Document has been accepted', style: GoogleFonts.poppins(fontSize: 20),),
                                            ],
                                          ):
                                          cacFormStatus == '3'?
                                          Row(
                                            children: [
                                              Icon(Icons.cancel, color: Colors.red,),
                                              SizedBox(width: 10,),
                                              Text('Document has been rejected', style: GoogleFonts.poppins(fontSize: 20),),
                                            ],
                                          ):
                                          !notNull(
                                              widget.cacForm)?Container():Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    saving = true;
                                                  });
                                                  var _body = {
                                                    "doctype": 'CAC_Form_7',
                                                    "status": '1',
                                                    "panNumber":
                                                        widget.data.panNumber
                                                  };

                                                  dynamic response =
                                                      await profileProvider
                                                          .setPendingAccountKycStatus(
                                                              _body);

                                                  capsaPrint('Cac Form Response : $response');

                                                  documentStatusCheck();
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                    ),
                                                    color: Colors.green,
                                                  ),
                                                  width: Responsive.isMobile(
                                                          context)
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.8
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.1,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 16),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const <Widget>[
                                                        Text(
                                                          'Accept',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      242,
                                                                      242,
                                                                      242,
                                                                      1),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height: 1),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    saving = true;
                                                  });
                                                  var _body = {
                                                    "doctype": 'CAC_Form_7',
                                                    "status": '0',
                                                    "panNumber":
                                                    widget.data.panNumber
                                                  };

                                                  dynamic response =
                                                  await profileProvider
                                                      .setPendingAccountKycStatus(
                                                      _body);

                                                  capsaPrint('Cac Form Response : $response');

                                                  documentStatusCheck();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                    ),
                                                    color: Colors.red,
                                                  ),
                                                  width:
                                                      Responsive.isMobile(context)
                                                          ? MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8
                                                          : MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 16),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'Reject',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Color.fromRGBO(
                                                                      242,
                                                                      242,
                                                                      242,
                                                                      1),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height: 1),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    widget.data.role2 == 'individual' ? Container() : SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                      width: 550,
                                      height: 820,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Valid ID',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 32),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              width: 550,
                                              height: 700,
                                              color: Colors.grey[200],
                                              child: notNull(widget.validId)
                                                  ? widget.data.validIdExt ==
                                                          'pdf'
                                                      ? SfPdfViewer.network(
                                                          widget.validId)
                                                      :
                                                                Image.network(
                                                                  widget
                                                                      .validId,
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  },
                                                                )

                                                        : Center(
                                                      child: Text(
                                                          'File not available'),
                                                    )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if(notNull(
                                              widget.validId))
                                            validIdStatus == '2' ?
                                          Row(
                                            children: [
                                              Icon(Icons.check, color: Colors.green,),
                                              SizedBox(width: 10,),
                                              Text('Document has been accepted', style: GoogleFonts.poppins(fontSize: 20),),
                                            ],
                                          ):
                                          validIdStatus == '3'?
                                          Row(
                                            children: [
                                              Icon(Icons.cancel, color: Colors.red,),
                                              SizedBox(width: 10,),
                                              Text('Document has been rejected', style: GoogleFonts.poppins(fontSize: 20),),
                                            ],
                                          ):
                                          !notNull(
                                              widget.validId)?Container():Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    saving = true;
                                                  });
                                                  var _body = {
                                                    "doctype": 'valid_id',
                                                    "status": '1',
                                                    "panNumber":
                                                    widget.data.panNumber
                                                  };

                                                  dynamic response =
                                                  await profileProvider
                                                      .setPendingAccountKycStatus(
                                                      _body);

                                                  capsaPrint('Cac Form Response : $response');

                                                  documentStatusCheck();


                                                },
                                                child: Container(
                                                  decoration:
                                                  const BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(15),
                                                      topRight:
                                                      Radius.circular(15),
                                                      bottomLeft:
                                                      Radius.circular(15),
                                                      bottomRight:
                                                      Radius.circular(15),
                                                    ),
                                                    color: Colors.green,
                                                  ),
                                                  width: Responsive.isMobile(
                                                      context)
                                                      ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.8
                                                      : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.1,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 16),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: const <Widget>[
                                                        Text(
                                                          'Accept',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                  242,
                                                                  242,
                                                                  242,
                                                                  1),
                                                              fontFamily:
                                                              'Poppins',
                                                              fontSize: 18,
                                                              letterSpacing:
                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height: 1),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    saving = true;
                                                  });
                                                  var _body = {
                                                    "doctype": 'valid_id',
                                                    "status": '0',
                                                    "panNumber":
                                                    widget.data.panNumber
                                                  };

                                                  dynamic response =
                                                  await profileProvider
                                                      .setPendingAccountKycStatus(
                                                      _body);

                                                  capsaPrint('Cac Form Response : $response');

                                                  documentStatusCheck();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(15),
                                                      topRight:
                                                      Radius.circular(15),
                                                      bottomLeft:
                                                      Radius.circular(15),
                                                      bottomRight:
                                                      Radius.circular(15),
                                                    ),
                                                    color: Colors.red,
                                                  ),
                                                  width:
                                                  Responsive.isMobile(context)
                                                      ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.8
                                                      : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.1,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 16),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'Reject',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                              Color.fromRGBO(
                                                                  242,
                                                                  242,
                                                                  242,
                                                                  1),
                                                              fontFamily:
                                                              'Poppins',
                                                              fontSize: 18,
                                                              letterSpacing:
                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height: 1),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                // OrientationSwitcher(
                                //   orientation: 'Column',
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Container(width: 550, height: 750, child: Column(
                                //       children: [
                                //         Text('Valid ID'),
                                //         SizedBox(height: 10,),
                                //         Container(width: 550, height: 700,child: SfPdfViewer.network(widget.validId)),
                                //       ],
                                //     ),
                                //     ),
                                //
                                //
                                //   ],
                                // ),
                                SizedBox(
                                  height: 40,
                                ),
                                if (saving)
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {

                                          // var _body = {
                                          //   "CAC_Certificate":
                                          //       stringInterpretation(
                                          //           cacCertificate),
                                          //   "CAC_Form_7":
                                          //       stringInterpretation(cacForm),
                                          //   "valid_id":
                                          //       stringInterpretation(validId),
                                          //   "panNumber": widget.data.panNumber
                                          // };
                                          //
                                          // dynamic response =
                                          //     await profileProvider
                                          //         .setPendingAccountKycStatus(
                                          //             _body);
                                          //
                                          // capsaPrint(
                                          //     'Penidng KYC Status : $response');


                                            capsaPrint('Pending pass 1');
                                            if ((cacFormStatus == '2' &&
                                                cacCertificateStatus == '2' &&
                                                validIdStatus == '2') || (widget.data.role2 == 'individual' &&
                                                validIdStatus == '2')) {
                                              setState(() {
                                                saving = true;
                                              });
                                              capsaPrint('Pending pass 2');
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context1) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      32.0))),
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              245, 251, 255, 1),
                                                      content: Container(
                                                        constraints: Responsive
                                                                .isMobile(
                                                                    context)
                                                            ? BoxConstraints(
                                                                minHeight: 300,
                                                              )
                                                            : BoxConstraints(
                                                                minHeight: 220,
                                                                maxWidth: 400),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              245, 251, 255, 1),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  6, 8, 6, 8),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                'Create Account',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              SizedBox(
                                                                height: 22,
                                                              ),
                                                              Text(
                                                                  "Proceed to send account creation request?",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // Figma Flutter Generator YesWidget - TEXT
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      // await actionProvider.actionRejectProposal(widget.bids, "REJECT");
                                                                      //
                                                                      // showToast('Rejected! We will try to bring better deal next time.', context);
                                                                      // // capsaPrint("Yes");
                                                                      // widget.justCallSetState();
                                                                      // actionProvider..bidProposalDetails(Uri.decodeComponent(widget.invoiceNum));
                                                                      // Navigator.of(context, rootNavigator: true).pop();
                                                                      Navigator.pop(
                                                                          context1);
                                                                      dynamic
                                                                          data =
                                                                          await profileProvider
                                                                              .createAccount(widget.data);
                                                                      capsaPrint(
                                                                          'pass 1 create account');
                                                                      if (data[
                                                                              'res'] ==
                                                                          'success') {
                                                                        showToast(
                                                                            'Account Creation Request Sent',
                                                                            context);
                                                                      } else {
                                                                        showToast(
                                                                            'Some error occurred!',
                                                                            context,
                                                                            type:
                                                                                'warning');
                                                                      }
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Yes',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              33,
                                                                              150,
                                                                              83,
                                                                              1),
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              18,
                                                                          letterSpacing:
                                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          height:
                                                                              1),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 50,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context1,
                                                                              rootNavigator: true)
                                                                          .pop();
                                                                      Navigator.of(
                                                                              context,
                                                                              rootNavigator: true)
                                                                          .pop();
                                                                    },
                                                                    child: // Figma Flutter Generator NoWidget - TEXT
                                                                        Text(
                                                                      'No',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              235,
                                                                              87,
                                                                              87,
                                                                              1),
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              18,
                                                                          letterSpacing:
                                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          height:
                                                                              1),
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            }else{
                                              showToast('Accept All Documents Before Creating Account!', context, type: 'warning');
                                            }
                                          //Navigator.pop(context);




                                        },
                                        child: Container(
                                            width: Responsive.isMobile(context)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                            height: 59,
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        topRight:
                                                            Radius.circular(15),
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                      ),
                                                      color: ((cacFormStatus == '2' &&
                                                    cacCertificateStatus == '2' &&
                                                        validIdStatus == '2') || (widget.data.role2 == 'individual' &&
                                                        validIdStatus == '2'))?Color.fromRGBO(
                                                          0, 152, 219, 1):Colors.grey,
                                                    ),
                                                    width: Responsive.isMobile(
                                                            context)
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 16),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Create Account',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        242,
                                                                        242,
                                                                        242,
                                                                        1),
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 18,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height: 1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ])),
                                      ),
                                      SizedBox(
                                        width: 51,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ))
                                    ],
                                  ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ):Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ],
                  )),
            ),
          )
        ],
      ),
    );

    //return
  }
}
