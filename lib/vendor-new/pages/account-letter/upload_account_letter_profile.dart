//import 'package:capsa/admin/models/invoice_model.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/vendor-new/model/account_letter_model.dart';
import 'package:capsa/vendor-new/pages/account-letter/account_letter_upload.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../vendor_new.dart';

class UploadAccountLetter extends StatefulWidget {
  const UploadAccountLetter({Key key}) : super(key: key);

  @override
  State<UploadAccountLetter> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<UploadAccountLetter> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');

  bool saving = false;
  AnchorsListApiModel anchorsListModel;
  List<AccountLetterModel> missingAccountLetter = [];
  bool loaded = false;

  final textController = TextEditingController(text: '');
  PlatformFile file;
  List<String> dropList = [];
  Map<String, String> CIN = {};
  List<String> cuPans = [];
  List<dynamic> selectedList = [];
  bool anchorsAdded = false;

  String error = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).queryProfile();
    Provider.of<ProfileProvider>(context, listen: false).queryFewData();
    getAnchorsList();
  }

  Future<void> getAccountNumber() async {
    var _body = box.get('tmpUserData') ?? {};
    // final _actionProvider =
    //     Provider.of<SignUpActionProvider>(context, listen: false);
    //
    // dynamic response = await _actionProvider.queryFewData();
    dynamic anchorsListResponse =
        await Provider.of<ProfileProvider>(context, listen: false)
            .getAnchorsList();
    dropList = [];
    CIN = {};
    //capsaPrint('Company Names : $anchorsListResponse');

    if (anchorsListResponse['res'] == 'success') {
      for (int i = 0; i < anchorsListResponse['data'].length; i++) {
        if (!cuPans.contains(anchorsListResponse['data'][i]['cu_pan'])) {
          dropList.add(anchorsListResponse['data'][i]['name']);
          CIN[anchorsListResponse['data'][i]['name']] =
              anchorsListResponse['data'][i]['cu_pan'];
        }
      }
    }
    return;
  }

  void getAnchorsList() async {
    capsaPrint('\n\nAccount Letter Response initiated');

    // final profileProvider = Provider.of<ProfileProvider>(context);

    try {
      cuPans = [];
      missingAccountLetter = [];

      anchorsListModel =
          await Provider.of<ProfileProvider>(context, listen: false)
              .getAccountLetters();

      for (int i = 0; i < anchorsListModel.accountLetters.length; i++) {
        cuPans.add(anchorsListModel.accountLetters[i].customerPan);
        capsaPrint('Approved : ${anchorsListModel.accountLetters[i].approved}');
        if (anchorsListModel.accountLetters[i].approved == '2' ||
            anchorsListModel.accountLetters[i].uploaded == '0') {
          missingAccountLetter.add(anchorsListModel.accountLetters[i]);
        }
      }

      await getAccountNumber();
    } catch (e) {
      error = e.toString();
      capsaPrint('error : $error');
      setState(() {
        loaded = true;
      });
    }

    setState(() {
      loaded = true;
    });

    //capsaPrint('\n\nAccount Letter Response : \n$response');
  }

  pickFile(TextEditingController controller, String type) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png', 'docx'],
    );

    if (result != null) {
      if (result.files.first.extension == 'jpg' ||
          result.files.first.extension == 'png' ||
          result.files.first.extension == 'jpeg' ||
          result.files.first.extension == 'docx' ||
          result.files.first.extension == 'pdf') {
        setState(() {
          file = result.files.first;
          textController.text = file.name;
        });
      } else {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                    'Invalid Format Selected. Please Select Another File'),
                actions: <Widget>[
                  TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context)),
                ],
              );
            });
      }
    } else {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('No File selected'),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context)),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    // final _actionProvider =
    //     Provider.of<SignUpActionProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        height: loaded
            ? error == ''
                ? MediaQuery.of(context).size.height * 4
                : MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
        child: Form(
          key: _formKey,
          child: loaded
              ? error == ''
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 22,
                        ),

                        TopBarWidget("Upload Change of Account Letter", ""),

                        SizedBox(
                          height: 35,
                        ),

                        InkWell(
                          onTap: () async {
                            await profileProvider.downloadLetter();
                          },
                          child: Text(
                            'Download Change of Account Letters',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 152, 219, 1),
                                // fontFamily: 'Poppins',
                                fontSize: 18,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ),

                        SizedBox(
                          height: 45,
                        ),

                        !Responsive.isMobile(context)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Anchors you work with : ',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            // fontFamily: 'Poppins',
                                            fontSize: 22,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w700,
                                            height: 1),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  anchorsListModel
                                                      .anchorNameList.length;
                                              i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 8, right: 8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      anchorsListModel
                                                          .anchorNameList[i],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          // fontFamily: 'Poppins',
                                                          fontSize: 16,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 45,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Add New Anchors",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    constraints: BoxConstraints(
                                                        minWidth: 750),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Select Anchors You Work With',
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 24,
                                                                  color: HexColor(
                                                                      '#333333')),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              width: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.7
                                                                  : 400,
                                                              //height: 80,
                                                              child:
                                                                  GFMultiSelect(
                                                                items: dropList,
                                                                onSelect:
                                                                    (value) {
                                                                  selectedList =
                                                                      value;
                                                                  //capsaPrint('selected $value ');
                                                                  // setState(() {
                                                                  //   selectedList =
                                                                  //       value;
                                                                  // });
                                                                },
                                                                dropdownTitleTileText:
                                                                    'Select Anchors ',
                                                                dropdownTitleTileColor:
                                                                    Colors.grey[
                                                                        200],
                                                                dropdownTitleTileMargin:
                                                                    EdgeInsets.only(
                                                                        top: 22,
                                                                        left:
                                                                            18,
                                                                        right:
                                                                            18,
                                                                        bottom:
                                                                            5),
                                                                dropdownTitleTilePadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                dropdownUnderlineBorder:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            2),
                                                                dropdownTitleTileBorder:
                                                                    Border.all(
                                                                        color: Colors.grey[
                                                                            300],
                                                                        width:
                                                                            1),
                                                                dropdownTitleTileBorderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                expandedIcon:
                                                                    const Icon(
                                                                  Icons
                                                                      .keyboard_arrow_down,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                                collapsedIcon:
                                                                    const Icon(
                                                                  Icons
                                                                      .keyboard_arrow_up,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                                submitButton:
                                                                    Text('OK'),
                                                                dropdownTitleTileTextStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black54),
                                                                //padding: const EdgeInsets.all(6),
                                                                //margin: const EdgeInsets.all(6),
                                                                //type: GFCheckboxType.basic,
                                                                activeBgColor: Colors
                                                                    .green
                                                                    .withOpacity(
                                                                        0.5),
                                                                inactiveBorderColor:
                                                                    Colors.grey[
                                                                        200],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            saving
                                                                ? CircularProgressIndicator()
                                                                : InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      // setState(() {
                                                                      //   saving = true;
                                                                      // });

                                                                      List<dynamic>
                                                                          cuGst =
                                                                          [];

                                                                      if (selectedList
                                                                          .isNotEmpty) {
                                                                        for (int i =
                                                                                0;
                                                                            i < selectedList.length;
                                                                            i++) {
                                                                          cuGst.add(
                                                                              CIN[dropList[int.parse(selectedList[i].toString())]]);
                                                                        }

                                                                        showToast(
                                                                            'Please Wait...',
                                                                            context,
                                                                            toastDuration:
                                                                                1,
                                                                            type:
                                                                                'warning');

                                                                        dynamic
                                                                            saveAnchorResponse =
                                                                            await profileProvider.saveAnchorList(cuGst);

                                                                        if (saveAnchorResponse['msg'] ==
                                                                            'success') {
                                                                          anchorsAdded =
                                                                              true;
                                                                          Navigator.pop(
                                                                              context);
                                                                        } else {
                                                                          showToast(
                                                                              saveAnchorResponse['msg'],
                                                                              context,
                                                                              type: 'error');
                                                                        }
                                                                      } else {
                                                                        showToast(
                                                                            'Select Anchors To Proceed',
                                                                            context,
                                                                            type:
                                                                                'warning');
                                                                      }
                                                                      // setState(() {
                                                                      //   saving =
                                                                      //   false;
                                                                      // });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          400,
                                                                      height:
                                                                          50,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              15)),
                                                                          color:
                                                                              HexColor('#0098DB')),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Proceed',
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 16,
                                                                              color: HexColor('#F2F2F2')),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then((value) {
                                            if (anchorsAdded) {
                                              showToast(
                                                  'Anchors Added Successfully',
                                                  context);
                                            }
                                            setState(() {
                                              anchorsAdded = false;
                                              loaded = false;
                                              getAnchorsList();
                                            });
                                          });
                                        },
                                        child: Text(
                                          'Add New Anchors',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  0, 152, 219, 1),
                                              // fontFamily: 'Poppins',
                                              fontSize: 18,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
                                              height: 1),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //SizedBox(width: 200,),

                                  Container(
                                    width: Responsive.isMobile(context)
                                        ? MediaQuery.of(context).size.width *
                                            0.6
                                        : 505,
                                    //height: 319,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Change Of Account Letters ',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: HexColor('#0098DB'),
                                                // fontFamily: 'Poppins',
                                                fontSize: 18,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w600,
                                                height: 1),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          for (int i = 0;
                                              i <
                                                  anchorsListModel
                                                      .accountLetters.length;
                                              i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                width:
                                                    Responsive.isMobile(context)
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4
                                                        : 470,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: HexColor('#F5FBFF'),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        anchorsListModel
                                                            .accountLetters[i]
                                                            .anchorName,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      Icon(
                                                        anchorsListModel
                                                                    .accountLetters[
                                                                        i]
                                                                    .uploaded ==
                                                                '0'
                                                            ? Icons
                                                                .warning_amber
                                                            : anchorsListModel
                                                                        .accountLetters[
                                                                            i]
                                                                        .approved ==
                                                                    '0'
                                                                ? Icons.pending
                                                                : anchorsListModel
                                                                            .accountLetters[
                                                                                i]
                                                                            .approved ==
                                                                        '1'
                                                                    ? Icons
                                                                        .check
                                                                    : Icons
                                                                        .cancel_outlined,
                                                        color: anchorsListModel
                                                                    .accountLetters[
                                                                        i]
                                                                    .uploaded ==
                                                                '0'
                                                            ? Colors.yellow
                                                            : anchorsListModel
                                                                        .accountLetters[
                                                                            i]
                                                                        .approved ==
                                                                    '0'
                                                                ? Colors.yellow
                                                                : anchorsListModel
                                                                            .accountLetters[
                                                                                i]
                                                                            .approved ==
                                                                        '1'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          if (missingAccountLetter.isNotEmpty)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChangeNotifierProvider(
                                                          create: (context) =>
                                                              SignUpActionProvider(),
                                                          child: VendorMain(
                                                              pageUrl:
                                                                  "/email-preference",
                                                              mobileTitle:
                                                                  "Account Letter Upload",
                                                              menuList: false,
                                                              backButton: true,
                                                              pop: true,
                                                              body:
                                                                  AccountLetterUploadProfile(
                                                                accountLetters:
                                                                    missingAccountLetter,
                                                              )),
                                                        ),
                                                      ),
                                                    ).then((value) {
                                                      setState(() {
                                                        anchorsAdded = false;
                                                        loaded = false;
                                                        getAnchorsList();
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 260,
                                                    height: 59,
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
                                                      color: Color.fromRGBO(
                                                          0, 152, 219, 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Upload Account Letter',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                          fontSize: 16,
                                                          letterSpacing:
                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
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
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Anchors you work with : ',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black,
                                        // fontFamily: 'Poppins',
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w700,
                                        height: 1),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: HexColor('#F5FBFF'),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          for (int i = 0;
                                          i <
                                              anchorsListModel
                                                  .anchorNameList.length;
                                          i= i + 2)
                                            Row(
                                              mainAxisAlignment: i == (anchorsListModel
                                                  .anchorNameList.length - 1) ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween  ,
                                              children: [
                                                for (int j = i;
                                                j < ((i < (anchorsListModel
                                                    .anchorNameList.length - 1)) ? (i+2) : anchorsListModel
                                                    .anchorNameList.length);
                                                j++)
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width * 0.38,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                        child: Text(
                                                          anchorsListModel
                                                              .anchorNameList[j],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              // fontFamily: 'Poppins',
                                                              fontSize: 16,
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                              FontWeight.w500,
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
                                  SizedBox(
                                    height: 35,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Add New Anchors",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                margin:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                constraints: BoxConstraints(
                                                    minWidth: 750),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Select Anchors You Work With',
                                                        style: GoogleFonts.poppins(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 16,
                                                            color: HexColor(
                                                                '#333333')),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        width: Responsive
                                                                .isMobile(
                                                                    context)
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7
                                                            : 400,
                                                        //height: 80,
                                                        child:
                                                            GFMultiSelect(
                                                          items: dropList,
                                                          onSelect:
                                                              (value) {
                                                            //capsaPrint('selected $value ');
                                                            setState(() {
                                                              selectedList =
                                                                  value;
                                                            });
                                                          },
                                                          dropdownTitleTileText:
                                                              'Select Anchors ',
                                                          dropdownTitleTileColor:
                                                              Colors.grey[
                                                                  200],
                                                          dropdownTitleTileMargin:
                                                              EdgeInsets.only(
                                                                  top: 22,
                                                                  left: 18,
                                                                  right: 18,
                                                                  bottom:
                                                                      5),
                                                          dropdownTitleTilePadding:
                                                              EdgeInsets
                                                                  .all(10),
                                                          dropdownUnderlineBorder:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 2),
                                                          dropdownTitleTileBorder:
                                                              Border.all(
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  width: 1),
                                                          dropdownTitleTileBorderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5),
                                                          expandedIcon:
                                                              const Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: Colors
                                                                .black54,
                                                          ),
                                                          collapsedIcon:
                                                              const Icon(
                                                            Icons
                                                                .keyboard_arrow_up,
                                                            color: Colors
                                                                .black54,
                                                          ),
                                                          submitButton:
                                                              Text('OK'),
                                                          dropdownTitleTileTextStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14,
                                                                  color: Colors
                                                                      .black54),
                                                          //padding: const EdgeInsets.all(6),
                                                          //margin: const EdgeInsets.all(6),
                                                          //type: GFCheckboxType.basic,
                                                          activeBgColor: Colors
                                                              .green
                                                              .withOpacity(
                                                                  0.5),
                                                          inactiveBorderColor:
                                                              Colors.grey[
                                                                  200],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      saving
                                                          ? CircularProgressIndicator()
                                                          : InkWell(
                                                              onTap:
                                                                  () async {
                                                                setState(
                                                                    () {
                                                                  saving =
                                                                      true;
                                                                });

                                                                List<dynamic>
                                                                    cuGst =
                                                                    [];

                                                                if (selectedList
                                                                    .isNotEmpty) {
                                                                  for (int i =
                                                                          0;
                                                                      i < selectedList.length;
                                                                      i++) {
                                                                    cuGst.add(
                                                                        CIN[dropList[int.parse(selectedList[i].toString())]]);
                                                                  }

                                                                  dynamic
                                                                      saveAnchorResponse =
                                                                      await profileProvider
                                                                          .saveAnchorList(cuGst);

                                                                  if (saveAnchorResponse[
                                                                          'msg'] ==
                                                                      'success') {
                                                                    Navigator.pop(
                                                                        context);
                                                                  } else {
                                                                    showToast(
                                                                        saveAnchorResponse[
                                                                            'msg'],
                                                                        context,
                                                                        type:
                                                                            'error');
                                                                  }
                                                                } else {
                                                                  showToast(
                                                                      'Select Anchors To Proceed',
                                                                      context,
                                                                      type:
                                                                          'warning');
                                                                }
                                                                setState(
                                                                    () {
                                                                  saving =
                                                                      false;
                                                                });
                                                              },
                                                              child:
                                                                  Container(
                                                                width: 400,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            15)),
                                                                    color: HexColor('#0098DB')),
                                                                child:
                                                                    Center(
                                                                  child:
                                                                      Text(
                                                                    'Add Anchors',
                                                                    style: GoogleFonts.poppins(
                                                                        fontWeight: FontWeight
                                                                            .w600,
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            HexColor('#F2F2F2')),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Add New Anchor',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              0, 152, 219, 1),
                                          // fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                  Responsive.isMobile(context)
                                      ? SizedBox(
                                          height: 25,
                                        )
                                      : SizedBox(
                                          height: 0,
                                        ),
                                  Container(
                                    width: Responsive.isMobile(context)
                                        ? MediaQuery.of(context).size.width *
                                            0.9
                                        : 505,
                                    //height: 319,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Change Of Account Letters ',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: HexColor('#0098DB'),
                                                // fontFamily: 'Poppins',
                                                fontSize: 18,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w600,
                                                height: 1),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          for (int i = 0;
                                          i <
                                              anchorsListModel
                                                  .accountLetters.length;
                                          i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(10)),
                                                  color: HexColor('#F5FBFF'),
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        anchorsListModel
                                                            .accountLetters[i]
                                                            .anchorName,
                                                        style:
                                                        GoogleFonts.poppins(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Icon(
                                                        anchorsListModel
                                                            .accountLetters[
                                                        i]
                                                            .uploaded ==
                                                            '0'
                                                            ? Icons
                                                            .warning_amber
                                                            : anchorsListModel
                                                            .accountLetters[
                                                        i]
                                                            .approved ==
                                                            '0'
                                                            ? Icons.pending
                                                            : anchorsListModel
                                                            .accountLetters[
                                                        i]
                                                            .approved ==
                                                            '1'
                                                            ? Icons
                                                            .check
                                                            : Icons
                                                            .cancel_outlined,
                                                        color: anchorsListModel
                                                            .accountLetters[
                                                        i]
                                                            .uploaded ==
                                                            '0'
                                                            ? Colors.yellow
                                                            : anchorsListModel
                                                            .accountLetters[
                                                        i]
                                                            .approved ==
                                                            '0'
                                                            ? Colors.yellow
                                                            : anchorsListModel
                                                            .accountLetters[
                                                        i]
                                                            .approved ==
                                                            '1'
                                                            ? Colors
                                                            .green
                                                            : Colors
                                                            .red,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                          if(missingAccountLetter.isNotEmpty)
                                            SizedBox(
                                              height: 12,
                                            ),

                                          if(missingAccountLetter.isEmpty)
                                            Text(

                                              'All account letters have been accepted',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  // fontFamily: 'Poppins',
                                                  fontSize: 18,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1),
                                            ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          if (missingAccountLetter.isNotEmpty)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChangeNotifierProvider(
                                                          create: (context) =>
                                                              SignUpActionProvider(),
                                                          child: VendorMain(
                                                              pageUrl:
                                                                  "/email-preference",
                                                              mobileTitle:
                                                                  "Account Letter Upload",
                                                              menuList: false,
                                                              backButton: true,
                                                              pop: true,
                                                              body:
                                                                  AccountLetterUploadProfile(
                                                                accountLetters:
                                                                    missingAccountLetter,
                                                              )),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 260,
                                                    height: 59,
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
                                                      color: Color.fromRGBO(
                                                          0, 152, 219, 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Upload Account Letter',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                          fontSize: 16,
                                                          letterSpacing:
                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
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
                                ],
                              ),

                        // if(profileProvider.portfolioData.AL_UPLOAD == 0)
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.4,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: InkWell(
                        //           onTap: () async{
                        //             await profileProvider.downloadLetter();
                        //
                        //           },
                        //           child: Text('Download Change of Account Letters', textAlign: TextAlign.left, style: TextStyle(
                        //               color: Color.fromRGBO(0, 152, 219, 1),
                        //               // fontFamily: 'Poppins',
                        //               fontSize: 16,
                        //               letterSpacing: 0  ,
                        //               fontWeight: FontWeight.normal,
                        //               height: 1
                        //           ),),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 15,
                        //       ),
                        //       Row(
                        //         children: [
                        //           Expanded(
                        //             child: UserTextFormField(
                        //               onTap: () => pickFile(textController, 'account_letter'),
                        //               label: "Upload Change of Account Letter",
                        //               hintText: "PDF, Docs or Image file",
                        //               controller: textController,
                        //               readOnly: true,
                        //               suffixIcon: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Image.asset(
                        //                   "assets/images/upload-Icons.png",
                        //                   height: 14,
                        //                 ),
                        //               ),
                        //
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //
                        //       if (saving)
                        //         Center(
                        //           child: CircularProgressIndicator(),
                        //         )
                        //       else
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: InkWell(
                        //             onTap: () async {
                        //               if (_formKey.currentState.validate()) {
                        //
                        //
                        //                 setState(() {
                        //                   saving = true;
                        //                 });
                        //                 var userData = Map<String, dynamic>.from(box.get('userData'));
                        //                 var _body = {};
                        //
                        //                 _body['panNumber'] = userData['panNumber'];
                        //
                        //                 dynamic response =  await profileProvider.uploadAccountLetterFile(file);
                        //
                        //                 setState(() {
                        //                   saving = false;
                        //                 });
                        //                 if (response['res'] == 'success') {
                        //
                        //                 await  profileProvider.queryPortfolioData();
                        //
                        //
                        //
                        //                 } else {
                        //                   showToast('Error ! ' + response['messg'], context, toastDuration: 15, type: 'error');
                        //                 }
                        //               }
                        //             },
                        //             child: Container(
                        //                 width: 200,
                        //                 height: 59,
                        //                 child: Stack(children: <Widget>[
                        //                   Positioned(
                        //                       top: 0,
                        //                       left: 0,
                        //                       child: Container(
                        //                         decoration: BoxDecoration(
                        //                           borderRadius: BorderRadius.only(
                        //                             topLeft: Radius.circular(15),
                        //                             topRight: Radius.circular(15),
                        //                             bottomLeft: Radius.circular(15),
                        //                             bottomRight: Radius.circular(15),
                        //                           ),
                        //                           color: Color.fromRGBO(0, 152, 219, 1),
                        //                         ),
                        //                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        //                         child: Row(
                        //                           mainAxisSize: MainAxisSize.min,
                        //                           children: <Widget>[
                        //                             Text(
                        //                               'Save',
                        //                               textAlign: TextAlign.center,
                        //                               style: TextStyle(
                        //                                   color: Color.fromRGBO(242, 242, 242, 1),
                        //                                   fontFamily: 'Poppins',
                        //                                   fontSize: 18,
                        //                                   letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        //                                   fontWeight: FontWeight.normal,
                        //                                   height: 1),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       )),
                        //                 ])),
                        //           ),
                        //         ),
                        //       SizedBox(
                        //         height: 50,
                        //       ),
                        //     ],
                        //   ),
                        // )
                        //  else
                        //    Container(
                        //      width: MediaQuery.of(context).size.width * 0.4,
                        //
                        //      child: Column(
                        //      mainAxisAlignment: MainAxisAlignment.start,
                        //      crossAxisAlignment: CrossAxisAlignment.start,
                        //      children: [
                        //        Padding(
                        //          padding: const EdgeInsets.all(8.0),
                        //          child: Text(
                        //            'Thank you for uploading your change of account form. Please give us some minutes to verify your details. An email will be sent to you shortly',
                        //            textAlign: TextAlign.left,
                        //          ),
                        //        ),
                        //      ],
                        //    ),)
                      ],
                    )
                  : Center(
                      child: Text(error),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
