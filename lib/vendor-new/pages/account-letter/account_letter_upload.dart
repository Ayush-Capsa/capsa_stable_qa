import 'package:beamer/beamer.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/encryption.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/vendor-new/model/account_letter_model.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountLetterUploadProfile extends StatefulWidget {
  List<AccountLetterModel> accountLetters;
  AccountLetterUploadProfile({Key key, this.accountLetters}) : super(key: key);

  @override
  State<AccountLetterUploadProfile> createState() => _AccountLetterUploadProfileState();
}

class _AccountLetterUploadProfileState extends State<AccountLetterUploadProfile> {
  String text1 = 'Change of Account Letters';
  String text2 =
      'The information required are for verification purposes. Capsa will never disclose your information to anyone else.';
  String text3 = '';
  String accountNumber = '';
  String bankName = '';
  String errorText = '';
  bool saving = false;

  List<dynamic> selectedList = [];

  List<PlatformFile> files = [];
  List<String> cuGst = [];
  List<String> extensions = [];
  List<TextEditingController> fileNamesControllers = [];


  //dynamic CIN;

  bool dataLoaded = true;

  pickFile(int index, String type) async {
    PlatformFile file;
    String extension;
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png',],
    );

    if (result != null) {
      if (result.files.first.extension == 'jpg' ||
          result.files.first.extension == 'png' ||
          result.files.first.extension == 'jpeg' ||
          result.files.first.extension == 'pdf') {
        setState(() {
          file = result.files.first;
          extension = result.files.first.extension;
          fileNamesControllers[index].text = file.name;
          //textController.text = file.name;
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
    files.add(file);
    extensions.add(extension);
    cuGst.add(widget.accountLetters[index].customerPan);
  }

  void getAccountNumber() async {
    var _body = box.get('tmpUserData') ?? {};
    capsaPrint('Pass 1 Upload');
    final _actionProvider =
        Provider.of<SignUpActionProvider>(context, listen: false);
    capsaPrint('Pass 2 Upload');

    // dynamic response = await _actionProvider.fewDataResponse;
    //
    // if (response['res'] == 'success') {
    //   accountNumber =
    //       response['data']['bankDetails'][0]['account_number'].toString();
    //   bankName = response['data']['bankDetails'][0]['bank_name'].toString();
    // } else {
    //   errorText = 'Some unexpected error occurred!';
    // }



    capsaPrint('Pass 3 Upload');

    //CIN = _actionProvider.cinList;

    capsaPrint('Pass 4 Upload');

    for (int i = 0; i < widget.accountLetters.length; i++) {
      selectedList.add(widget.accountLetters[i].anchorName);
    }

    var userData = Map<String, dynamic>.from(box.get('userData'));

    // capsaPrint('Pass 5 Upload $userData');

    for (int i = 0; i < selectedList.length; i++) {
      TextEditingController controller = TextEditingController();
      fileNamesControllers.add(controller);
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
          ? errorText == ''
              ? SingleChildScrollView(
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
                          'Change Of Account Letter',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: HexColor('#333333')),
                        ),
                      SizedBox(
                        height: (!Responsive.isMobile(context)) ? 42 : 15,
                      ),
                      // Container(
                      //   width: 400,
                      //   height: 180,
                      //   color: Colors.white,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 19),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'Capsa Bank Account Number',
                      //           style: GoogleFonts.poppins(
                      //               fontWeight: FontWeight.w600,
                      //               fontSize: 18,
                      //               color: HexColor('#333333')),
                      //         ),
                      //         Text(
                      //           accountNumber,
                      //           style: GoogleFonts.poppins(
                      //               fontWeight: FontWeight.w700,
                      //               fontSize: 36,
                      //               color: HexColor('#0098DB')),
                      //         ),
                      //         Text(
                      //           bankName,
                      //           style: GoogleFonts.poppins(
                      //               fontWeight: FontWeight.w600,
                      //               fontSize: 24,
                      //               color: HexColor('#828282')),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: (!Responsive.isMobile(context)) ? 42 : 15,
                      // ),
                      for (int i = 0; i < selectedList.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            width: Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width * 0.7
                                : MediaQuery.of(context).size.width * 0.3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: UserTextFormField(
                                    onTap: () => pickFile(i, 'account_letter'),
                                    label:
                                        "Upload Change of Account Letter for " +
                                            selectedList[i],
                                    hintText: "PDF or Image file",
                                    controller: fileNamesControllers[i],
                                    readOnly: true,
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "assets/images/upload-Icons.png",
                                        height: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      saving
                          ? CircularProgressIndicator()
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  saving = true;
                                });
                                if (files.isNotEmpty) {
                                  dynamic response;
                                  for (int i = 0; i < files.length; i++) {
                                    var body = {};
                                    body['anchorPan'] = cuGst[i];
                                    body['extensionAccountLetter'] =
                                        extensions[i];

                                    response = await _actionProvider
                                        .uploadAccountLetterFile(
                                            body, files[i]);
                                    capsaPrint('Response : $response');
                                  }
                                  if (response['msg'] == 'success') {
                                    showToast('Upload Successful', context,);
                                    Navigator.pop(context);

                                  } else {
                                    showToast('Something went wrong!', context,
                                        type: 'error');
                                  }
                                } else {
                                  showToast(
                                      'You need to select at least one file!',
                                      context,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: files.length == 0
                                        ? HexColor('#DBDBDB')
                                        : HexColor('#0098DB')),
                                child: Center(
                                  child: Text(
                                    'Upload Account Letters',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: HexColor('#F2F2F2')),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 150,),
                    ],
                  ),
                )
              : Center(
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
