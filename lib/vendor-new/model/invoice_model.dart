import 'dart:typed_data';

import 'package:capsa/functions/custom_print.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class InvoiceModel {
  String anchor,
      cacAddress,
      invNo,
      poNo,
      invDate,
      cuGst,
      terms,
      invDueDate,
      invAmt,
      details,
      invSell,
      rate,
      invAmount,
      amountPayable,
      buyNowPrice,
      date,
      tenureDaysDiff,
      fileType,
      bvnNo,
      isRevenue,
      discount_status,
      invStatus,
      payment_status,
      ilcStatus,
      status,
      extendedDueDate;

  List<dynamic> childInvoice;

  String noOfCustomer = '0';
  String amtPerCustomer = '0';

  PlatformFile img;

  InvoiceModel({
    this.anchor,
    this.cacAddress,
    this.invNo,
    this.poNo,
    this.invDate,
    this.cuGst,
    this.terms,
    this.invDueDate,
    this.invAmt,
    this.details,
    this.invSell,
    this.rate,
    this.invAmount,
    this.amountPayable,
    this.buyNowPrice,
    this.date,
    this.tenureDaysDiff,
    this.img,
    this.fileType,
    this.isRevenue,
    this.bvnNo,
    this.status,
    this.noOfCustomer,
    this.discount_status,
    this.invStatus,
    this.payment_status,
    this.ilcStatus,
    this.amtPerCustomer,
    this.childInvoice,
    this.extendedDueDate

  });

  Map<String, dynamic> toJson() {
    var _obj = {
      'anchor': anchor,
      'cacAddress': cacAddress,
      'invNo': invNo,
      'poNo': poNo,
      'invDate': invDate,
      'terms': terms,
      'invDueDate': invDueDate,
      'details': details,
      'rate': rate,
      'invAmount': invAmount,
      'buyNowPrice': buyNowPrice,
      'tenureDaysDiff': tenureDaysDiff,
      'fileType': fileType,
      'bvnNo': bvnNo,
      'cuGst': cuGst,
      'extDueDate' : extendedDueDate ?? invDueDate,
    };
    if (noOfCustomer != null) _obj['noOfCustomer'] = noOfCustomer;
    if (amtPerCustomer != null) _obj['amtPerCustomer'] = amtPerCustomer;

    return _obj;
  }

  @override
  String toString() {
    capsaPrint(
      '$anchor' +
          '\n' +
          '$cacAddress' +
          '\n' +
          '$invNo' +
          '\n' +
          '$poNo' +
          '\n' +
          '$date' +
          '\n' +
          '$terms' +
          '\n' +
          '$invDueDate' +
          '\n' +
          '$invAmount' +
          '\n' +
          '$details' +
          '\n' +
          '$invSell' +
          '\n' +
          '$rate' +
          '\n' +
          '$fileType',
    );
    return super.toString();
  }
}

class InvoiceBuilderItemDescriptionModel {
  String description;
  String quantity;
  String rate;
  String amount;

  InvoiceBuilderItemDescriptionModel({
    this.description,
    this.quantity,
    this.rate,
    this.amount,
  });

  Map<String,dynamic> toJson(){
    var _obj = {
      'description': description.toString(),
      'quantity': quantity.toString(),
      'rate': rate.toString(),
      'amount': amount.toString()
    };

    return _obj;
  }

}
