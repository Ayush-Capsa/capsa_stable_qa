import 'dart:js';
import 'dart:typed_data';

import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:flutter/cupertino.dart' as cp;
import 'package:flutter/material.dart' as mt;
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import 'invoice_builder_model.dart';
import 'package:intl/intl.dart';

class pdfBuilder {
  static Widget invoiceInfo(List<String> lead, List<String> info) {
    return Column(children: [
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < lead.length; i++)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    lead[i],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: PdfColors.black),
                  ),
                )
            ],
          ),
          SizedBox(
            width: 29,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < info.length; i++)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    info[i] == '' ? 'NA':info[i],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: (info[i] != 'NA' && info[i] != '')?PdfColors.black:PdfColors.white),
                  ),
                ),
            ],
          ),
        ],
      )
    ]);
  }

  static Widget header(String header, double width) {
    return Container(
      height: 29,
      width: width,
      color: PdfColors.grey400,
      child: Center(
        child: Text(
          header,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: PdfColors.white),
        ),
      ),
    );
  }

  static Widget content(String content, double width) {
    return Container(
      height: 29,
      width: width,
      color: PdfColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }

  static Widget itemDescription(InvoiceBuilderModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              header('Item Description', 210),
              for (int i = 0; i < model.descriptions.length; i++)
                content(model.descriptions[i].description, 210)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              header('Quantity', 63),
              for (int i = 0; i < model.descriptions.length; i++)
                content(formatCurrency(model.descriptions[i].quantity), 63)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              header('Rate', 80),
              for (int i = 0; i < model.descriptions.length; i++)
                content(formatCurrency(model.descriptions[i].rate), 80)
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                header('Amount', 83),
                for (int i = 0; i < model.descriptions.length; i++)
                  content(formatCurrency(model.descriptions[i].amount), 83)
              ],
            )),
        // Column(
        //   children: [
        //     header('Item Description', 210),
        //     for(int i = 0;i<model.descriptions.length;i++)
        //       content(model.descriptions[i].description, 210)
        //   ],
        // ),
        // Column(
        //   children: [
        //     header('Quantity', 63),
        //     for(int i = 0;i<model.descriptions.length;i++)
        //       content(model.descriptions[i].quantity, 63)
        //   ],
        // ),
        // Column(
        //   children: [
        //     header('Rate', 80),
        //     for(int i = 0;i<model.descriptions.length;i++)
        //       content(model.descriptions[i].rate, 80)
        //   ],
        // ),
        // Column(
        //   children: [
        //     header('Amount', 83),
        //     for(int i = 0;i<model.descriptions.length;i++)
        //       content(model.descriptions[i].amount, 83)
        //   ],
        // )
      ],
    );
  }

  static Widget pdfView(InvoiceBuilderModel model, final netImage, cp.BuildContext context) {
    return Container(
      color: PdfColors.white,
      child: Column(
        children: [
          SizedBox(
            height: 47,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(netImage, width: 140, height: 70, fit: BoxFit.contain),
              Text(
                'INVOICE',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: PdfColors.black),
              ),
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Company Name :',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: PdfColors.grey400),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    model.vendor,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: PdfColors.black),
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Text(
                    'Bill To :',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: PdfColors.grey400),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    model.anchor,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: PdfColors.black),
                  ),
                ],
              ),
              invoiceInfo([
                'Invoice Number : ',
                'Date : ',
                'Due Date : ',
                'Tenure : ',
                'PO Number : '
              ], [
                model.invNo,
                model.invDate != ''
                    ?
                //model.invDate
                DateFormat('yyyy-MM-dd').format(
                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                        .parse(model.invDate))
                    : 'NA',
                model.invDueDate != ''
                    ?
                //model.invDueDate
                DateFormat('yyyy-MM-dd').format(
                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                        .parse(model.invDueDate))
                    : 'NA',
                model.tenure == ''?'NA':model.tenure,
                model.poNo == ''?'NA':model.poNo
              ])
            ],
          ),
          SizedBox(
            height: 32,
          ),
          itemDescription(model),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment:Responsive.isMobile(context)?MainAxisAlignment.start:(model.notes!=null || model.notes!='')?MainAxisAlignment.spaceBetween: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if(model.notes!=null || model.notes!='')
                Text(
                  "Note : ${model.notes}",
                ),


              invoiceInfo([
                'Subtotal :',
                'Tax :',
                'TOTAL:',
                'Amount Paid:',
                'Balance Due:'
              ], [
                formatCurrency(model.subTotal,
                    withIcon: false, withCurrencyName: true) ,
                formatCurrency(model.tax,
                    withIcon: false, withCurrencyName: true),
                formatCurrency(model.total,
                    withIcon: false, withCurrencyName: true),
                formatCurrency(model.paid,
                    withIcon: false, withCurrencyName: true),
                formatCurrency(model.balanceDue,
                    withIcon: false, withCurrencyName: true),
              ])

            ],
          ),
        ],
      ),
    );
  }

  static Future<void> printDoc(InvoiceBuilderModel model, dynamic image, cp.BuildContext buildContext) async {
    final doc = Document();
    doc.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return pdfView(model, image, buildContext);
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
