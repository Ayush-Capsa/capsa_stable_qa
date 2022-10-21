import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/logout.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class UploadAccountLetter extends StatefulWidget {
  const UploadAccountLetter({Key key}) : super(key: key);

  @override
  State<UploadAccountLetter> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<UploadAccountLetter> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');

  bool saving = false;

  final textController = TextEditingController(text: '');
  PlatformFile file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).queryProfile();
    Provider.of<ProfileProvider>(context, listen: false).queryFewData();
  }


  pickFile(TextEditingController controller, String type) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png','docx'],
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
                content: const Text('Invalid Format Selected. Please Select Another File'),
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


    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 22,
              ),
              TopBarWidget("Upload Change of Account Letter", ""),
              SizedBox(
                height: 15,
              ),
             if(profileProvider.portfolioData.AL_UPLOAD == 0)
             Container(
               width: MediaQuery.of(context).size.width * 0.4,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: InkWell(
                       onTap: () async{
                         await profileProvider.downloadLetter();

                       },
                       child: Text('Download Change of Account Letters', textAlign: TextAlign.left, style: TextStyle(
                           color: Color.fromRGBO(0, 152, 219, 1),
                           // fontFamily: 'Poppins',
                           fontSize: 16,
                           letterSpacing: 0  ,
                           fontWeight: FontWeight.normal,
                           height: 1
                       ),),
                     ),
                   ),
                   SizedBox(
                     height: 15,
                   ),
                   Row(
                     children: [
                       Expanded(
                         child: UserTextFormField(
                           onTap: () => pickFile(textController, 'account_letter'),
                           label: "Upload Change of Account Letter",
                           hintText: "PDF, Docs or Image file",
                           controller: textController,
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

                   if (saving)
                     Center(
                       child: CircularProgressIndicator(),
                     )
                   else
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap: () async {
                           if (_formKey.currentState.validate()) {


                             setState(() {
                               saving = true;
                             });
                             var userData = Map<String, dynamic>.from(box.get('userData'));
                             var _body = {};

                             _body['panNumber'] = userData['panNumber'];

                             dynamic response =  await profileProvider.uploadAccountLetterFile(file);

                             setState(() {
                               saving = false;
                             });
                             if (response['res'] == 'success') {

                             await  profileProvider.queryPortfolioData();



                             } else {
                               showToast('Error ! ' + response['messg'], context, toastDuration: 15, type: 'error');
                             }
                           }
                         },
                         child: Container(
                             width: 200,
                             height: 59,
                             child: Stack(children: <Widget>[
                               Positioned(
                                   top: 0,
                                   left: 0,
                                   child: Container(
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.only(
                                         topLeft: Radius.circular(15),
                                         topRight: Radius.circular(15),
                                         bottomLeft: Radius.circular(15),
                                         bottomRight: Radius.circular(15),
                                       ),
                                       color: Color.fromRGBO(0, 152, 219, 1),
                                     ),
                                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                     child: Row(
                                       mainAxisSize: MainAxisSize.min,
                                       children: <Widget>[
                                         Text(
                                           'Save',
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                               color: Color.fromRGBO(242, 242, 242, 1),
                                               fontFamily: 'Poppins',
                                               fontSize: 18,
                                               letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                               fontWeight: FontWeight.normal,
                                               height: 1),
                                         ),
                                       ],
                                     ),
                                   )),
                             ])),
                       ),
                     ),
                   SizedBox(
                     height: 50,
                   ),
                 ],
               ),
             )
              else
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,

                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Thank you for uploading your change of account form. Please give us some minutes to verify your details. An email will be sent to you shortly',
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),)
            ],
          ),
        ),
      ),
    );
  }



}
