import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:internet_file/internet_file.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key key}) : super(key: key);

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  final box = Hive.box('capsaBox');
  final formKey = GlobalKey<FormState>();
  final myController0 = TextEditingController();
  bool processing = false;
  bool isDone = false;

  String pdfLink;
  String role;
  String _errorMsg4 = '';

  bool isChecked = false;
  bool loaded = false;
  Uint8List file;
  PdfController pdfController ;

  void loadFile() async{
    capsaPrint('Document pass 1');
    file = await InternetFile.get(
      pdfLink,
    );
    capsaPrint('Document pass 2');
    pdfController = PdfController(
      document: PdfDocument.openData(file),
    );
    capsaPrint('Document pass 3');
    loaded = true;
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var _body = box.get('signUpData') ?? {};
    role = _body['role'];

    //pdfLink = 'https://storage.googleapis.com/getcapsa-ca-quality.appspot.com/testnew/file1?GoogleAccessId=firebase-adminsdk-ea2mz%40getcapsa-ca-quality.iam.gserviceaccount.com&Expires=1676519786&Signature=h9vs9VEv%2BbhP%2F2iNcRdJLM2uruQFvjjvHj1rRnCQzHmoa2ionJJRRAc2mNtycfzl71pjXXtP8Wu0NkoQhZcbKxRwXFBOQu12%2Ftc%2BKT3UtOfWHJl3oS8zscDsckrYqI5CrFqFGoa75QCnb2tWzJSSDLV3Lox%2F1qrgpjO4fk5%2Fpsv7RSkZD1GnAjpcYqAiyGGV9jorE6vRccqkXGa%2BAp%2FwYfcV4Go%2B66u4YGqakQm1CjjVH9EWO7vfPNTu8r3ngWFh1qZEPxtdDG8VhZU1O5%2B4ktFQqIea8Qkeo6fVvSoqYBz7MQE2chl9UA3ca8jnSpULRUla07bC8b59v7AbODaA2Q%3D%3D';
    pdfLink = 'https://storage.googleapis.com/download/storage/v1/b/fir-anchor-creditassessment.appspot.com/o/Vendor_Terms_Conditions_2.pdf?generation=1669910580228683&alt=media';

    if (role == 'COMPANY')
      pdfLink = 'https://storage.googleapis.com/download/storage/v1/b/fir-anchor-creditassessment.appspot.com/o/Buyer_Terms_Conditions_2.pdf?generation=1669910579883695&alt=media';
          // 'https://storage.googleapis.com/download/storage/v1/b/fir-anchor-creditassessment.appspot.com/o/Vendor_Terms_Conditions_2.pdf?generation=1669910580228683&alt=media';
    loaded = true;
    setState(() {
    });
    //loadFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (!Responsive.isMobile(context))
          ? null
          : AppBar(
              toolbarHeight: 75,
              title: Text("Terms And Condition"),
            ),
      body:loaded? Container(
        child: Form(
          key: formKey,
          child: Padding(
            padding: Responsive.isMobile(context)
                ? EdgeInsets.all(12)
                : EdgeInsets.fromLTRB(45, 45, 45, 5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  if (!Responsive.isMobile(context))
                    Text(
                      "Terms And Condition",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width * 0.5,
                    color: Colors.transparent,
                    child: SfPdfViewer.network(pdfLink),
                    // child: PdfView(
                    //   controller: pdfController,
                    // )
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          checkBox(checked: isChecked),
                          SizedBox(width: 8),
                          Text(
                            'I accept the terms and conditions',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(51, 51, 51, 1),
                                // fontFamily: 'Poppins',
                                fontSize: 14,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Container(),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: processing
                              ? CircularProgressIndicator()
                              : InkWell(
                                  onTap: () async {
                                    if (!isChecked) {
                                      showToast(
                                          'Please confirm Terms & condition',
                                          context,
                                          type: 'warning');
                                      return;
                                    }

                                    var _data = box.get('signUpData') ?? {};
                                    var _body = {};

                                    _body['bvn'] = _data['bvnNumber'];
                                    _body['sign'] = '';

                                    setState(() {
                                      processing = true;
                                    });

                                    final _actionProvider =
                                        Provider.of<SignUpActionProvider>(
                                            context,
                                            listen: false);

                                    await _actionProvider
                                        .updateDigitalSign(_body);

                                    Beamer.of(context)
                                        .beamToNamed('/registration-complete');
                                  },
                                  child: Text(
                                    'Next',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 152, 219, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
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
                ],
              ),
            ),
          ),
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }

  Widget checkBox({checked: false}) {
    if (checked) {
      return // Figma Flutter Generator CheckboxWidget - INSTANCE
          Container(
              width: 15,
              height: 15,
              child: Stack(children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          border: Border.all(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            width: 2,
                          ),
                        ))),
                Positioned(
                    top: 3,
                    left: 3,
                    child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          color: Color.fromRGBO(0, 152, 219, 1),
                          border: Border.all(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            width: 2,
                          ),
                        ))),
              ]));
    }

    return Container(
        width: 15,
        height: 15,
        child: Stack(children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(0, 152, 219, 1),
                      width: 2,
                    ),
                  ))),
        ]));
  }
}
