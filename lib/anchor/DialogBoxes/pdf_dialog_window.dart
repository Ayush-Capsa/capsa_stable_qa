import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdfDialogBox extends StatefulWidget {
  AnchorActionProvider invoiceProvider;
  String fileName;
  pdfDialogBox(
      {Key key, @required this.invoiceProvider, @required this.fileName})
      : super(key: key);

  @override
  _pdfDialogBoxState createState() => _pdfDialogBoxState();
}

class _pdfDialogBoxState extends State<pdfDialogBox> {
  var _data;
  bool dataLoaded = false;

  void initialise() async {
    var _body = {'fName': widget.fileName};
    _data = await widget.invoiceProvider.getInvFile(_body);
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

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
      //   width: 550,
      //   height: 700,
      // decoration: BoxDecoration(
      //   color: Colors.transparent,
      //   borderRadius: BorderRadius.circular(25),
      // ),
        backgroundColor: dataLoaded?Color.fromRGBO(255, 255, 255, 1):Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 5,
        child: //_dialogScreen(context, widget.invoiceProvider, widget.fileName),
        dataLoaded?_pdfDialogScreen(context, _data['data']['url']):Center(child: CircularProgressIndicator(),)
    );
  }
  // widget.invoiceProvider,widget.fileName
  // _dialogScreen(BuildContext context) => Container(
  //   width: 550,
  //   height: 700,
  //   child: SfPdfViewer.network('https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
  // );

  _dialogScreen(BuildContext context, AnchorActionProvider _invoiceProvider,
      String fileName) {
    capsaPrint('FileName: $fileName');

    // var data = await  _invoiceProvider.getInvFile(_body);
    // capsaPrint('Pdf Data: $data');
    return Container(
      width: 550,
      height: 700,
      child: Builder(builder: (context) {
        var _body = {'fName': fileName};
        return Expanded(
          flex: 1,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Builder(builder: (context) {
              return FutureBuilder<Object>(
                  future: _invoiceProvider.getInvFile(_body),
                  builder: (context, snapshot) {
                    dynamic _data = snapshot.data;
                    if (snapshot.hasData) {
                      if (_data['res'] == 'success') {
                        var url = _data['data']['url'];
                        return Column(
                          children: [
                            Expanded(child: SfPdfViewer.network(url)),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  });
            }),
          ),
        );
      }),
    );
  }

  _pdfDialogScreen(BuildContext context, String url) {
    capsaPrint('PDF URL : $url');
    return Container(width: 550, height: 700, child: SfPdfViewer.network(url));
  }
}
