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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UploadKycDocument extends StatefulWidget {
  const UploadKycDocument({Key key}) : super(key: key);

  @override
  State<UploadKycDocument> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<UploadKycDocument> {
  final _formKey = GlobalKey<FormState>();

  final Box box = Hive.box('capsaBox');

  bool saving = false;
  bool loadingKYC = false;

  final kyc1Controller = TextEditingController();
  final kyc2Controller = TextEditingController();
  final kyc3Controller = TextEditingController();

  PlatformFile kyc1File, kyc2File, kyc3File;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).queryPortfolioData();
    // Provider.of<ProfileProvider>(context, listen: false).queryProfile();
    // Provider.of<ProfileProvider>(context, listen: false).queryFewData();
  }

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
          if (type == 'kyc1') {
            kyc1File = result.files.first;
            controller.text = kyc1File.name;
          } else if (type == 'kyc2') {
            kyc2File = result.files.first;
            controller.text = kyc2File.name;
          } else if (type == 'kyc3') {
            kyc3File = result.files.first;
            controller.text = kyc3File.name;
          }
          // else if (type == 'pl') {
          //   profitLoss = result.files.first;
          //   controller.text = profitLoss.name;
          // } else if (type == 'br') {
          //   boardResolution = result.files.first;
          //   controller.text = boardResolution.name;
          // } else {
          //   balanceSheet = result.files.first;
          //   controller.text = balanceSheet.name;
          // }
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

  openFiles(profileProvider, _body, name) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              content: Container(
                width: 800,
                child: FutureBuilder<Object>(
                    future: profileProvider.getKYCFiles(_body),
                    builder: (context, snapshot) {
                      // capsaPrint(snapshot.data);
                      dynamic _data = snapshot.data;
                      if (snapshot.hasData) {
                        if (_data['res'] == 'success') {
                          var url = _data['data']['url'];
                          // capsaPrint(url);
                          return Column(
                            children: [
                              Expanded(
                                flex: 5,
                                child: SfPdfViewer.network(url),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      profileProvider.downloadFile(url, name);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(); // dismisses only the dialog and returns nothing
                                    },
                                    child: new Text('Download'),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(); // dismisses only the dialog and returns nothing
                                    },
                                    child: new Text('Close'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
              actions: <Widget>[],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    var _str = '';

    if ((profileProvider.portfolioData.kyc1 != 2 ||
            profileProvider.portfolioData.kyc2 != 2 ||
            profileProvider.portfolioData.kyc3 != 2) &&
        (profileProvider.portfolioData.kyc1 == null ||
            profileProvider.portfolioData.kyc2 == null ||
            profileProvider.portfolioData.kyc3 == null) &&
        ((profileProvider.portfolioData.kyc1 == 1 ||
            profileProvider.portfolioData.kyc2 == 1 ||
            profileProvider.portfolioData.kyc3 == 1)))
      _str = "Re-upload documents";
    else if ((profileProvider.portfolioData.kyc1 != 2 ||
            profileProvider.portfolioData.kyc2 != 2 ||
            profileProvider.portfolioData.kyc3 != 2) &&
        (profileProvider.portfolioData.kyc1 != null ||
            profileProvider.portfolioData.kyc2 != null ||
            profileProvider.portfolioData.kyc3 != null))
      _str = "Pending for approval";

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
              TopBarWidget("View Kyc Documents", _str),
              SizedBox(
                height: 15,
              ),
              uploadKYCDocuments(context, profileProvider),
            ],
          ),
        ),
      ),
    );
  }

  uploadKYCDocuments(BuildContext context, ProfileProvider profileProvider) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          if (profileProvider.portfolioData.kyc1 != 2 &&
              profileProvider.portfolioData.kyc1 != 1)
            UserTextFormField(
              padding: EdgeInsets.only(bottom: 5),
              controller: kyc1Controller,
              onTap: () => pickFile(kyc1Controller, 'kyc1'),
              readOnly: true,
              label: "Upload CAC Certificate',",
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/upload-Icons.png",
                  height: 14,
                ),
              ),
            )
          else
            InkWell(
                onTap: () async {
                  var _body = {'fName': profileProvider.portfolioData.kyc1File};
                  openFiles(profileProvider, _body, "CAC Certificate");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "View CAC Certificate",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 15),
                  ),
                )),
          if (profileProvider.portfolioData.kyc2 != 2 &&
              profileProvider.portfolioData.kyc2 != 1)
            UserTextFormField(
              padding: EdgeInsets.only(bottom: 5),
              controller: kyc2Controller,
              onTap: () => pickFile(kyc2Controller, 'kyc2'),
              readOnly: true,
              label: "Upload CAC Form 7",
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/upload-Icons.png",
                  height: 14,
                ),
              ),
            )
          else
            InkWell(
              onTap: () async {
                var _body = {'fName': profileProvider.portfolioData.kyc2File};

                openFiles(profileProvider, _body, "CAC Form 7");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "View CAC Form 7",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 15),
                ),
              ),
            ),
          if (profileProvider.portfolioData.kyc3 != 2 &&
              profileProvider.portfolioData.kyc3 != 1)
            UserTextFormField(
              padding: EdgeInsets.only(bottom: 5),
              controller: kyc3Controller,
              onTap: () => pickFile(kyc3Controller, 'kyc3'),
              readOnly: true,
              label: "National ID card of a Company Director",
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/upload-Icons.png",
                  height: 14,
                ),
              ),
            )
          else
          // InkWell(
          //   onTap: () async {
          //     var _body = {'fName': profileProvider.portfolioData.kyc3File};

          //     openFiles(profileProvider, _body, "National ID card of a Company Director");
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       "View NATIONAL ID Card of a Company Director",
          //       style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
          //     ),
          //   ),
          // ),

          if (loadingKYC)
            Align(
                alignment: Alignment.centerRight,
                child: CircularProgressIndicator()),
          if ((profileProvider.portfolioData.kyc1 != 2 ||
              profileProvider.portfolioData.kyc2 != 2 ||
              profileProvider.portfolioData.kyc3 != 2))
            if ((profileProvider.portfolioData.kyc1 != 1 ||
                profileProvider.portfolioData.kyc2 != 1 ||
                profileProvider.portfolioData.kyc3 != 1))
              if (!loadingKYC)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    onTap: () async {
                      if (profileProvider.portfolioData.kyc1 ==
                          null) if (kyc1File == null) {
                        showToast('Files are required', context,
                            type: "warning");
                        return;
                      }

                      if (profileProvider.portfolioData.kyc2 ==
                          null) if (kyc2File == null) {
                        showToast('Files are required', context,
                            type: "warning");
                        return;
                      }

                      if (profileProvider.portfolioData.kyc3 ==
                          null) if (kyc3File == null) {
                        showToast('Files are required', context,
                            type: "warning");
                        return;
                      }

                      // capsaPrint(kyc1File);
                      // capsaPrint(kyc2File);
                      // capsaPrint(kyc3File);

                      setState(() {
                        loadingKYC = true;
                      });
                      await profileProvider.uploadKYCFiles(
                          kyc1File, kyc2File, kyc3File);
                      showToast('Documents successfully uploaded', context);
                      await profileProvider.queryPortfolioData();
                      setState(() {
                        loadingKYC = false;
                      });
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Save',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(242, 242, 242, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
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
            height: Responsive.isDesktop(context) ? 30 : 20,
          ),
        ],
      ),
    );
  }
}
