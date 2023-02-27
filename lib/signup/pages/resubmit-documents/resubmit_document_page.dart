import 'package:beamer/src/beamer.dart';
import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/signup/provider/action_provider.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReUploadDocumentPage extends StatefulWidget {
  const ReUploadDocumentPage({Key key}) : super(key: key);

  @override
  State<ReUploadDocumentPage> createState() => _ReUploadDocumentPageState();
}

class _ReUploadDocumentPageState extends State<ReUploadDocumentPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController cacForm7Controller0 = TextEditingController();
  TextEditingController idFileController0 = TextEditingController();
  TextEditingController cacCertificateController0 = TextEditingController();

  PlatformFile ccFile;
  PlatformFile f7File;
  PlatformFile idFile;

  String text1 = "Reupload Document";
  String text2 = "";
  String text3 = "";

  bool saving = false;


  String role, role2;
  String cacForm,cacCertificate,id;
  String panNumber;

  pickFile(TextEditingController controller, String type) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png'],
    );

    if (result != null) {
      if (result.files.first.extension == 'jpg' ||
          result.files.first.extension == 'png' ||
          result.files.first.extension == 'jpeg' ||
          result.files.first.extension == 'pdf') {
        setState(() {
          if (type == 'cc') {
            ccFile = result.files.first;
            cacCertificateController0.text = ccFile.name;
          } else if (type == 'f7') {
            f7File = result.files.first;
            cacForm7Controller0.text = f7File.name;
          } else if (type == 'id') {
            idFile = result.files.first;
            idFileController0.text = idFile.name;
          }
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
  void initState() {
    // TODO: implement initState
    super.initState();

    var _body = box.get('signUpData') ?? {};


    // phoneNoController0.text = _body['phoneNo'] ?? '';
    role = _body['role'];
    role2 = _body['ROLE2'];
    cacCertificate = _body['CAC_Certificate_URL'];
    cacForm = _body['CAC_Form_7'];
    id = _body['valid_id_URL'];
    panNumber = _body['bvnNumber'];


    // capsaPrint('_body');
    // capsaPrint(_body);
  }


  @override
  Widget build(BuildContext context) {
    final _actionProvider =
    Provider.of<SignUpActionProvider>(context, listen: false);
    return Stack(
      children: [
        Positioned(
          top: 30, right: 30,
          child: InkWell(
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
        ),
        Center(
          child: Container(
            width: Responsive.isMobile(context)?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width * 0.4,
            height: double.infinity,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                child: OrientationSwitcher(
                  orientation: 'Column',
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    topHeading(),
                    SizedBox(height: 30,),
                    if(!notNull(cacCertificate) && role2 != 'individual')
                    UserTextFormField(
                      padding: EdgeInsets.only(bottom: 4, top: 4),
                      label: "Upload CAC Certificate",
                      // prefixIcon: Image.asset("assets/images/currency.png"),
                      hintText: "PDF or Image file",
                      controller: cacCertificateController0,
                      readOnly: true,
                      // initialValue: '',
                      //errorText: _errorMsg7,
                      onTap: () => pickFile(cacCertificateController0, 'cc'),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/upload-Icons.png",
                          height: 14,
                        ),
                      ),

                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'CAC Certificate is required';
                        }

                        return null;
                      },
                      onChanged: (v) {},
                      keyboardType: TextInputType.text,
                    ),
                    if(!notNull(cacCertificate) && role2 != 'individual')SizedBox(height: 30,),
                    if(!notNull(cacForm) && role2 != 'individual')
                      UserTextFormField(
                        padding: EdgeInsets.only(bottom: 4, top: 4),
                        label: "Upload CAC Form 7",
                        // prefixIcon: Image.asset("assets/images/currency.png"),
                        hintText: "PDF or Image file",
                        controller: cacForm7Controller0,
                        readOnly: true,
                        // initialValue: '',
                        //errorText: _errorMsg7,
                        onTap: () => pickFile(cacForm7Controller0, 'f7'),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/upload-Icons.png",
                            height: 14,
                          ),
                        ),

                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'CAC Form 7 is required';
                          }

                          return null;
                        },
                        onChanged: (v) {},
                        keyboardType: TextInputType.text,
                      ),
                    if(!notNull(cacForm) && role2 != 'individual')SizedBox(height: 30,),
                    if(!notNull(id))
                      Column(
                        children: [
                          UserTextFormField(
                            padding: EdgeInsets.only(bottom: 0, top: 4),
                            label: "Upload Valid ID",
                            // prefixIcon: Image.asset("assets/images/currency.png"),
                            hintText: "PDF or Image file",
                            controller: idFileController0,
                            readOnly: true,
                            // initialValue: '',

                            onTap: () => pickFile(idFileController0, 'id'),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/upload-Icons.png",
                                height: 14,
                              ),
                            ),

                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'CAC Form 7 is required';
                              }

                              return null;
                            },
                            onChanged: (v) {},
                            keyboardType: TextInputType.text,
                          ),
                          Text(
                              "Accepted Valid ID: National ID Card, Voter’s Card,  Driver’s licence, or Passport"),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        saving?CircularProgressIndicator():SizedBox(
                          width: 330,
                          child: InkWell(
                            onTap: () async{
                              setState(() {
                                saving = true;
                              });
                              var _body = {
                                'extensionCAC' : ccFile!=null?ccFile.extension:'',
                                'extensionFORM7' : f7File!=null?f7File.extension:'',
                                'extensionValid_id' : idFile!=null?idFile.extension:'',
                                'panNumber' : panNumber
                              };
                             dynamic response = await _actionProvider.reUploadDocument(_body, ccFile, f7File, idFile);

                              setState(() {
                                saving = false;
                              });

                             if(response['msg'] == 'success'){
                               showToast('Document Uploaded Successfully', context,);
                               context.beamToNamed('/resubmit-document-success-page');
                             }else{
                               showToast(response['msg'], context, type: 'error');
                             }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                color: Color.fromRGBO(0, 152, 219, 1),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Center(
                                child: Text(
                                  'Upload',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(242, 242, 242, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget topHeading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     InkWell(
          //       onTap:(){
          //         logout(context);
          //       },
          //       child: Container(
          //         width: Responsive.isMobile(context)
          //             ? 100 : 180 ,
          //         height: Responsive.isMobile(context)
          //             ? 42 : 58 ,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(
          //               Radius.circular(15 )),
          //           border: Border.all(color: Colors.red, width: 3 ),
          //         ),
          //         child: Center(
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               const Icon(Icons.logout, color: Colors.red,),
          //               Text(
          //                 'Logout',
          //                 style: TextStyle(
          //                     fontSize: Responsive.isMobile(context)
          //                         ? 14  : 20 ,
          //                     fontWeight: FontWeight.w700,
          //                     color: Colors.red),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(width: 20,),
          //   ],
          // ),
          SizedBox(height: 20,),
          Text(
            text1,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontFamily: 'Poppins',
                fontSize: Responsive.isMobile(context)? 24 : 32,
                letterSpacing:
                0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          if (text2 != '')
            SizedBox(
              height: 10,
            ),
          if (text2 != '')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
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
