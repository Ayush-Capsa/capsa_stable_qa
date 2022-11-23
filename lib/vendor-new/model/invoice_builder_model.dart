import 'dart:typed_data';

import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/vendor-new/model/invoice_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class InvoiceBuilderModel {

  String  anchor,
      vendor,
      invNo,
      poNo,
      invDate,
      cuGst,
      tenure,
      invDueDate,
      subTotal,
      discount,
      tax,
      total,
      paid,
      balanceDue,
      currency,
      notes,
      discountType,
      customerCin;
  bool complete;
  bool uploaded;

  List<InvoiceBuilderItemDescriptionModel> descriptions;

  String img;

  InvoiceBuilderModel(
      {this.anchor,
       this.vendor,
        this.invNo,
        this.poNo,
        this.invDate,
        this.cuGst,
        this.tenure,
        this.invDueDate,
        this.subTotal,
        this.discount,
        this.tax,
        this.total,
        this.paid,
        this.balanceDue,
        this.currency,
        this.img,
        this.descriptions,
        this.notes,
        this.discountType,
        this.complete,
        this.customerCin,
        this.uploaded
        });

  // Map<String, dynamic> toJson() {
  //   var _obj = {
  //     'anchor': anchor,
  //     'cacAddress': cacAddress,
  //     'invNo': invNo,
  //     'poNo': poNo,
  //     'invDate': invDate,
  //     'terms': terms,
  //     'invDueDate': invDueDate,
  //     'details': details,
  //     'rate': rate,
  //     'invAmount': invAmount,
  //     'buyNowPrice': buyNowPrice,
  //     'tenureDaysDiff': tenureDaysDiff,
  //     'fileType': fileType,
  //     'bvnNo': bvnNo,
  //     'cuGst': cuGst,
  //     'currency': currency,
  //   };
  //   if (noOfCustomer != null) _obj['noOfCustomer'] = noOfCustomer;
  //   if (amtPerCustomer != null) _obj['amtPerCustomer'] = amtPerCustomer;
  //
  //   return _obj;
  // }

}

