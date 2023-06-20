import 'package:beamer/beamer.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:capsa/vendor-new/pages/add_invoice/confirm_invoice.dart';
import 'package:capsa/vendor-new/pages/confirm_invoice_page.dart';

import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../anchor/provider/anchor_action_providers.dart';
import '../provider/anchor_invoice_provider.dart';

class SingleVendorInvite extends StatefulWidget {
  SingleVendorInvite({
    Key key,
  }) : super(key: key);

  @override
  State<SingleVendorInvite> createState() => _SingleVendorInviteState();
}

class _SingleVendorInviteState extends State<SingleVendorInvite> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');

  bool saving = false;

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  final companyNameController = TextEditingController(text: '');
  final rcNumberController = TextEditingController(text: '');

  final emailController = TextEditingController(text: '');
  final directorNameController = TextEditingController(text: '');
  final directorPhnNoController = TextEditingController(text: '');
  final bvnController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final invoiceProvider =
        Provider.of<AnchorInvoiceProvider>(context, listen: false);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: Responsive.isMobile(context) ? 0 : 185,
            height: MediaQuery.of(context).size.height * 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
              ),
              color: Color.fromARGB(255, 15, 15, 15),
            ),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: [
                Positioned(
                    left: 42.5,
                    top: 38.0,
                    right: null,
                    bottom: null,
                    width: 34,
                    height: 34,
                    child: Container(
                      width: 80.0,
                      height: 45,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image.asset(
                            "assets/images/arrow-left.png",
                            color: null,
                            fit: BoxFit.cover,
                            width: 34.0,
                            height: 34,
                            colorBlendMode: BlendMode.dstATop,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!Responsive.isMobile(context))
                    SizedBox(
                      height: 22,
                    ),
                  TopBarWidget("Invite Vendor", ""),
                  SizedBox(
                    height: (!Responsive.isMobile(context)) ? 8 : 15,
                  ),
                  if (Responsive.isMobile(context)) mobileFormSteper(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Form(
                      // onChanged: ,
                      key: _formKey,
                      child: OrientationSwitcher(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // orientation: Responsive.isMobile(context) ? "Column" : "Row" ,
                        children: [
                          Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrientationSwitcher(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: UserTextFormField(
                                          label: "Company Name",
                                          hintText: "Company Name",
                                          controller: companyNameController,
                                          onChanged: (v) {},
                                        ),
                                      ),
                                      Flexible(
                                        child: UserTextFormField(
                                          label: "RC Number",
                                          controller: rcNumberController,
                                          hintText: "RC Number",
                                        ),
                                      ),
                                    ],
                                  ),
                                  OrientationSwitcher(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: UserTextFormField(
                                          label: "Email Address",
                                          hintText: "abc@xyz.com",
                                          controller: emailController,
                                        ),
                                      ),
                                      Flexible(
                                        child: UserTextFormField(
                                          label: "Director's Name",
                                          hintText: "Director's Name",

                                          // Image.asset(
                                          //     "assets/images/currency.png"),
                                          controller: directorNameController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  OrientationSwitcher(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: UserTextFormField(
                                          label: "Director's Phone Number",
                                          hintText: "Director's Phone Number",
                                          controller: directorPhnNoController,
                                        ),
                                      ),
                                      Flexible(
                                        child: UserTextFormField(
                                          label: "BVN",
                                          hintText: "Enter BVN",

                                          // Image.asset(
                                          //     "assets/images/currency.png"),
                                          controller: bvnController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        saving = true;
                                      });

                                      dynamic _body = {
                                        'company_name': companyNameController.text,
                                        'rc_number': rcNumberController.text,
                                        'email': emailController.text,
                                        'director_name': directorNameController.text,
                                        'director_phone':
                                            directorNameController.text,
                                        'vendor_bvn': bvnController.text
                                      };

                                      dynamic response = await callApi('dashboard/a/vendorInvite',body: _body);

                                      if(response['res'] == 'success' || response['msg'] == 'success'){
                                        showToast('Invite Sent', context);
                                        Navigator.pop(context);
                                      }else{
                                        showToast(response['messg'], context, type: 'warning');
                                      }

                                      setState(() {
                                        saving = false;
                                      });
                                    },
                                    child: Container(
                                      width: 230,
                                      height: 59,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                        color: Color.fromRGBO(0, 152, 219, 1),
                                      ),
                                      child: saving
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color.fromRGBO(
                                                      242, 242, 242, 1),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                'Invite',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      242, 242, 242, 1),
                                                  fontSize: 24,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 40,
                          ),
                          Flexible(
                              flex: 1,
                              child: Visibility(
                                visible: false,
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * 0.6,
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                    ),
                                    color: Color.fromRGBO(0, 152, 219, 1),
                                  ),
                                  child: Container(),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileFormSteper() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            //color: Color.fromRGBO(255, 255, 255, 1),
            ),
        child: Center(
          child: Stack(children: <Widget>[
            Positioned(
                top: 14,
                left: 104,
                child: Container(
                    width: 180,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(130, 130, 130, 1),
                    ))),
            Positioned(
                top: 0,
                left: 67,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: Color.fromRGBO(245, 251, 255, 1),
                    border: Border.all(
                      color: Color.fromRGBO(0, 152, 219, 1),
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '1',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 152, 219, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 0,
                left: 264,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: Color.fromRGBO(245, 251, 255, 1),
                    border: Border.all(
                      color: Color.fromRGBO(130, 130, 130, 1),
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '2',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(130, 130, 130, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ],
                  ),
                )),
          ]),
        ));
  }
}

class SplitInvoiceWarning extends StatelessWidget {
  String invNo;
  Function nav;
  SplitInvoiceWarning({Key key, @required this.invNo, @required this.nav})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 584,
      height: 579,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: HexColor('#F5FBFF')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/warning.png',
            width: 80,
            height: 80,
          ),
          Text(
            'Invoice Splitting',
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Text(
            'Please note that your invoice will be split into smaller invoices. This will allow for faster trading of your invoice.\n\n This does not affect the invoice value. A breakdown of the split can be seen on the next page.',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: () {
              // nav;
              // Beamer.of(context).beamToNamed('/confirmInvoice');
              Navigator.pop(context);
            },
            child: Container(
              height: 60,
              width: 342,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: HexColor('#0098DB')),
              child: Center(
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
