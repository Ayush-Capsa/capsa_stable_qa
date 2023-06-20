class AnchorInvoiceModel {
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
      vendorPAN,
      vendorName,
      extendedDueDate,
      platformFee,
      actualValue;

  List<dynamic> childInvoice;

  String noOfCustomer = '0';
  String amtPerCustomer = '0';

  AnchorInvoiceModel({
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
    this.vendorPAN,
    this.extendedDueDate,
    this.vendorName,
    this.platformFee,
    this.actualValue

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
      'bvnNo': vendorPAN,
      'cuGst': cuGst,
      'extDueDate': extendedDueDate ?? invDueDate,
      'actualValue' : actualValue

    };
    if (noOfCustomer != null) _obj['noOfCustomer'] = noOfCustomer;
    if (amtPerCustomer != null) _obj['amtPerCustomer'] = amtPerCustomer;

    return _obj;
  }
}