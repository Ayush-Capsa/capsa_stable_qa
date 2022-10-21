import 'dart:typed_data';

class InvoiceModel {
  final String anchor,
      invAmount,
      amountPayable,
      buyNowPrice,
      date,
      invNo,
      poNo,
      terms,
      rate;
  final Uint8List img;

  InvoiceModel(
      {this.anchor,
      this.invAmount,
      this.amountPayable,
      this.buyNowPrice,
      this.date,
      this.invNo,
      this.poNo,
      this.terms,
      this.rate,
      this.img});
}
