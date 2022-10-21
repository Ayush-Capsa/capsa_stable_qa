import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/vendor-new/provider/invoice_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdfDialogBox extends StatefulWidget {
  InvoiceProvider invoiceProvider;
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: dataLoaded?Color.fromRGBO(255, 255, 255, 1):Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 5,
        child: //_dialogScreen(context, widget.invoiceProvider, widget.fileName),
        dataLoaded?_pdfDialogScreen(context, _data['data']['url']):Center(child: CircularProgressIndicator(),)
    );
  }

  _pdfDialogScreen(BuildContext context, String url) {
    capsaPrint('PDF URL : $url');
    return Container(width: 550, height: 700, child: SfPdfViewer.network(url));
  }
}
