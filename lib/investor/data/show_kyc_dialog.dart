import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

bool kycErrorCondition(context, _profileProvider) {
  var _boolRes = false;
  capsaPrint('KYC ERROR CONDITIONS : \n${_profileProvider.portfolioData.investorType} \n${_profileProvider.portfolioData.kyc1} \n${_profileProvider.portfolioData.kyc2} \n${_profileProvider.portfolioData.kyc3}\n\n');
  if (_profileProvider.portfolioData.investorType == "individual") {
    if (_profileProvider.portfolioData.kyc3 != 2) {
      _boolRes = true;
    }
  } else {
    // if (_profileProvider.portfolioData.kyc1 != 2 || _profileProvider.portfolioData.kyc2 != 2 || _profileProvider.portfolioData.kyc3 != 2) {
    if (_profileProvider.portfolioData.kyc1 != 2 &&
        _profileProvider.portfolioData.kyc2 != 2 && _profileProvider.portfolioData.kyc3 != 2) {
      _boolRes = true;
    }
  }
  return _boolRes;
}

void showKycError(context, _profileProvider) {
  void redirect() {
    Beamer.of(context).beamToNamed('/upload-kyc-document');
  }
  capsaPrint('kyc error pass 1');

  if (_profileProvider.portfolioData.newUser) {
    capsaPrint('kyc error pass 2');
    if (kycErrorCondition(context, _profileProvider)) {
      capsaPrint('kyc error pass 3');
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'KYC',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            fontWeight: FontWeight.normal, fontSize: 14),
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
                  //               MaterialStateProperty.all<Color>(Colors.white),
                  //           backgroundColor: MaterialStateProperty.all<Color>(
                  //               Theme.of(context).primaryColor),
                  //           shape: MaterialStateProperty.all<
                  //                   RoundedRectangleBorder>(
                  //               RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(50),
                  //                   side: BorderSide(
                  //                       color:
                  //                           Theme.of(context).primaryColor)))),
                  //       onPressed: () async {
                  //         redirect();
                  //         Navigator.of(context, rootNavigator: true).pop();
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
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColor)))),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
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
  }
}
