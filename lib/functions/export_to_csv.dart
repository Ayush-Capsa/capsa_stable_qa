import 'dart:convert';
import 'package:file_saver/file_saver.dart';

exportToCSV(var data,{ String fName }) async {
  final bytes = utf8.encode(data);
  var _name = "download.csv";
  if(fName != null){

    _name = fName;
  }
  await FileSaver.instance
      .saveFile(_name, bytes, 'csv', mimeType: MimeType.CSV);
//   final script = html.document.createElement('script') as html.ScriptElement;
//   script.src = "http://cdn.jsdelivr.net/g/filesaver.js";

//   html.document.body.nodes.add(script);

// // calls the "saveAs" method from the FileSaver.js libray
//   js.context.callMethod("saveAs", [
//     html.Blob([bytes]),
//     "accountdata.csv", //File Name (optional) defaults to "download"
//     "text/csv;charset=utf-8" //File Type (optional)
//   ]);

//   // cleanup
//   html.document.body.nodes.remove(script);
}