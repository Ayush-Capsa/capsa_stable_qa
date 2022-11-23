import 'package:capsa/vendor-new/model/invoice_builder_model.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';


import 'package:flutter/cupertino.dart';


//
// import 'package:pdf/src/widgets/document.dart';
// import 'package:pdf/src/widgets/page.dart';


import 'package:flutter/material.dart';

import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/vendor-new/model/invoice_builder_model.dart';
import 'package:google_fonts/google_fonts.dart';


class InvoiceViewer extends StatelessWidget {
  InvoiceBuilderModel model;
  InvoiceViewer({Key key, this.model}) : super(key: key);
  //


  Widget invoiceInfo(List<String> lead, List<String> info) {
    return Row(
      children: [
        Column(
          children: [
            for (int i = 0; i < lead.length; i++)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  lead[i],
                  textAlign: TextAlign.end,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: HexColor('#333333')),
                ),
              )
          ],
        ),
        SizedBox(
          width: 29,
        ),
        Column(
          children: [
            for (int i = 0; i < info.length; i++)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  info[i],
                  textAlign: TextAlign.end,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: HexColor('#333333')),
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget header(String header, double width){
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        height: 29,
        width: width,
        color: HexColor('#828282'),
        child: Center(
          child: Text(
            header,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: HexColor('#FFFFFF')
            ),
          ),
        ),
      ),
    );
  }

  Widget content(String content, double width){
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        height: 29,
        width: width,
        color: HexColor('#FFFFFF'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                content,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: HexColor('#333333')
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemDescription(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            header('Item Description', 288),
            for(int i = 0;i<model.descriptions.length;i++)
              content(model.descriptions[i].description, 288)
          ],
        ),
        Column(
          children: [
            header('Quantity', 63),
            for(int i = 0;i<model.descriptions.length;i++)
              content(model.descriptions[i].quantity, 63)
          ],
        ),
        Column(
          children: [
            header('Rate', 88),
            for(int i = 0;i<model.descriptions.length;i++)
              content(model.descriptions[i].rate, 88)
          ],
        ),
        Column(
          children: [
            header('Amount', 89),
            for(int i = 0;i<model.descriptions.length;i++)
              content(model.descriptions[i].amount, 89)
          ],
        )
      ],
    );
  }

  Widget pdfView(){
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 34, right: 34),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 47,
              ),
              Row(
                children: [
                  Image.asset('assets/company_icon.png'),
                  Text(
                    'INVOICE',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: HexColor('#333333')),
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
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: HexColor('#828282')),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        model.vendor,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: HexColor('#333333')),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Text(
                        'Bill To :',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: HexColor('#828282')),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        model.anchor,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: HexColor('#333333')),
                      ),
                    ],
                  ),

                  invoiceInfo([
                    'Invoice Number',
                    'Date',
                    'Due Date',
                    'Tenure',
                    'PO Number'
                  ], [
                    model.invNo,
                    model.invDate ,
                    model.invDueDate,
                    model.tenure,
                    model.poNo
                  ])

                ],
              ),

              SizedBox(
                height: 32,
              ),

              itemDescription(),

              SizedBox(
                height: 32,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  invoiceInfo([
                    'Subtotal :',
                    'Tax :',
                    'TOTAL:',
                    'Amount Paid:',
                    'Balance Due:'
                  ], [
                    formatCurrency(model.subTotal, withIcon: true, ),
                    formatCurrency(model.tax, withIcon: true, ),
                    formatCurrency(model.total, withIcon: true, ),
                    formatCurrency(model.paid, withIcon: true, ),
                    formatCurrency(model.balanceDue, withIcon: true, ),
                  ])

                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        pdfView(),
        Positioned(
            right: 20,
            left: 20,
            child: Icon(Icons.download,size: 34,))
      ],
    );

  }
}