import 'package:capsa/common/constants.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/widgets/capsaapp/generatedaddinvoicewidget/generated/GeneratedButtonWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedaddinvoicewidget/generated/GeneratedAddinvoiceWidget1.dart';
import 'package:beamer/beamer.dart';
import 'package:provider/provider.dart';

/* Frame Add invoice
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedAddinvoiceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void navigate() {
      Beamer.of(context).beamToNamed('/upload-account-letter');
    }

    void navigate2() {
      Beamer.of(context).beamToNamed('/profile');
    }

    final _profileProvider =
        Provider.of<ProfileProvider>(context, listen: true);

    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {

            var userData = Map<String, dynamic>.from(box.get('userData'));
            print('User Data $userData');

            int isBlackListed = int.parse(userData['isBlacklisted']);


            if(isBlackListed == 1){
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Function Suspended',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'This functionality has been temporarily suspended',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 4,
                          ),

                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text("Close".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                          ),
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(50),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColor)))),
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true)
                                  .pop(),
                        ),
                      ),
                    ],
                  ));
              return;
            }

            if (_profileProvider.portfolioData.AL_UPLOAD != 2) {
              // capsaPrint('Add incoive check');
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text(
                          'Change of Account Letter',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profileProvider.portfolioData.AL_UPLOAD == 1
                                    ? 'Thank you for uploading your change of account form.\nPlease give us some minutes to verify your details.\nAn email will be sent to you shortly'
                                    : 'To trade your Invoice, please upload change of account letter.',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          if (_profileProvider.portfolioData.AL_UPLOAD == 0)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                        "Upload account letter".toUpperCase(),
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                  style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty
                                          .all<Color>(Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                      shape:
                                          MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor)))),
                                  onPressed: () async {
                                    navigate();
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  }),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text("Close".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                              ),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor),
                                  shape:
                                      MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor)))),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () => {Navigator.of(context, rootNavigator: true).pop(), _tab.changeTab(3)},
                          //   child: const Text('Update details'),
                          // ),
                        ],
                      ));

              return;
            }

            if (_profileProvider.portfolioData.newUser) if (_profileProvider
                        .portfolioData.kyc1 !=
                    2 ||
                _profileProvider.portfolioData.kyc2 != 2 ||
                _profileProvider.portfolioData.kyc3 != 2) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text(
                          'KYC',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your KYC Documents are currently being reviewed. Please give us some minutes to verify your details. An email will be sent to you shortly.',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              // const Text(
                              //   'Please provide and link your company’s bank account to proceed further!',
                              //   style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                              // ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: ElevatedButton(
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(4),
                          //         child: Text("Upload documents".toUpperCase(),
                          //             style: TextStyle(fontSize: 14)),
                          //       ),
                          //       style: ButtonStyle(
                          //           foregroundColor:
                          //               MaterialStateProperty.all<Color>(
                          //                   Colors.white),
                          //           backgroundColor:
                          //               MaterialStateProperty.all<Color>(
                          //                   Theme.of(context).primaryColor),
                          //           shape:
                          //               MaterialStateProperty.all<RoundedRectangleBorder>(
                          //                   RoundedRectangleBorder(
                          //                       borderRadius:
                          //                           BorderRadius.circular(50),
                          //                       side: BorderSide(
                          //                           color: Theme.of(context)
                          //                               .primaryColor)))),
                          //       onPressed: () async {
                          //         navigate2();
                          //         Navigator.of(context, rootNavigator: true)
                          //             .pop();
                          //       }),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text("Close".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                              ),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor),
                                  shape:
                                      MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor)))),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () => {Navigator.of(context, rootNavigator: true).pop(), _tab.changeTab(3)},
                          //   child: const Text('Update details'),
                          // ),
                        ],
                      ));

              return;
            }




            context.beamToNamed('/addInvoice');
          },
          child: Container(
            width: 196.0,
            height: 64.0,
            child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: [
                  if (!Responsive.isMobile(context))
                    Positioned(
                      left: 0.0,
                      top: 11.0,
                      right: null,
                      bottom: null,
                      width: 155.0,
                      height: 42.0,
                      child: GeneratedButtonWidget(),
                    ),
                  Positioned(
                    left: 132.0,
                    top: 0.0,
                    right: null,
                    bottom: null,
                    width: Responsive.isMobile(context) ? 46 : 64.0,
                    height: Responsive.isMobile(context) ? 46 : 64.0,
                    child: GeneratedAddinvoiceWidget1(),
                  )
                ]),
          ),
        ));
  }
}
