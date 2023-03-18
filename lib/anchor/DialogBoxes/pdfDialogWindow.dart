import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdfDialogBox extends StatefulWidget {
  AnchorActionProvider invoiceProvider;
  String fileName;
  pdfDialogBox({Key key,@required this.invoiceProvider, @required this.fileName}) : super(key: key);

  @override
  _pdfDialogBoxState createState() => _pdfDialogBoxState();
}

class _pdfDialogBoxState extends State<pdfDialogBox> {

  /*late PDFDocument document;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
      ),
      elevation: 5,
      child: _dialogScreen(context),
    );
  }

  @override
  void initState(){
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromAsset('assets/pdf-test.pdf');
    setState(() {
      _isLoading = false;
    });
  }

  _dialogScreen(BuildContext context) => SafeArea(
    child: Scaffold(
      body: Container(
        child: _isLoading Center(child: CircularProgressIndicator()) : PDFViewer(document: document),
      ),
    ),
  );*/
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
      ),
      elevation: 5,
      child: _dialogScreen(context,widget.invoiceProvider,widget.fileName),
    );
  }
  // widget.invoiceProvider,widget.fileName
  // _dialogScreen(BuildContext context) => Container(
  //   width: 550,
  //   height: 700,
  //   child: SfPdfViewer.network('https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
  // );

  _dialogScreen(BuildContext context, AnchorActionProvider _invoiceProvider, String fileName){
    capsaPrint('FileName: $fileName');

    // var data = await  _invoiceProvider.getInvFile(_body);
    // capsaPrint('Pdf Data: $data');
    return Container(
      width: 550,
      height: 700,
      child: Builder(builder: (context) {
        var _body = {'fName': fileName};
        return FutureBuilder<Object>(
            future: _invoiceProvider.getInvFile(_body),
            builder: (context, snapshot) {
              dynamic _data = snapshot.data;
              if (snapshot.hasData) {
                if (_data['res'] == 'success') {
                  String url = _data['data']['url'];
                  //capsaPrint('Data 2: $url');
                  var urlDownload = url;
                  return Container(
                      width: 550,
                      height: 700,
                      child: SfPdfViewer.network(url)
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            });
      }),
    );
  }
}
