import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class adminPdfDialogBox extends StatefulWidget {
  String url;
  adminPdfDialogBox(
      {Key key, @required this.url,})
      : super(key: key);

  @override
  _adminPdfDialogBoxState createState() => _adminPdfDialogBoxState();
}

class _adminPdfDialogBoxState extends State<adminPdfDialogBox> {
  var _data;
  bool dataLoaded = true;

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
        dataLoaded?_pdfDialogScreen(context, widget.url):Center(child: CircularProgressIndicator(),)
    );
  }

  _pdfDialogScreen(BuildContext context, String url) {
    capsaPrint('PDF URL : $url');
    return Row(
      children: [
        Container(width: 550, height: 700, child: SfPdfViewer.network(url)),
        Container(width: 550, height: 700, child: SfPdfViewer.network(url)),
      ],
    );
  }
}
