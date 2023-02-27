class InvoiceModel {
  String id;
  String companyPan;
  String invoiceNumber;
  String invoiceDate;
  String invoiceDueDate;
  String description;
  String invoiceQuantity;
  String invoiceValue;
  String customerName;
  String paymentTerms;
  String status;
  String invoiceFile;
  String askAmt;
  String askRate;
  String isSplit;
  String parentInvoice;
  String cu_gst;

  InvoiceModel(
      {this.id,
      this.companyPan,
      this.invoiceNumber,
      this.invoiceDate,
      this.invoiceDueDate,
      this.description,
      this.invoiceQuantity,
      this.invoiceValue,
      this.customerName,
      this.paymentTerms,
      this.status,
      this.invoiceFile,
      this.askAmt,
      this.askRate,
      this.isSplit,
      this.parentInvoice,
      this.cu_gst});
}

class AccountLetterModel {
  String anchorName;
  String accountLetterUrl;
  String companyPan;
  String customerPan;
  String fileExtension;
  String isApproved;
  bool approved;
  bool uploaded;

  AccountLetterModel({
    this.anchorName,
    this.accountLetterUrl,
    this.fileExtension,
    this.companyPan,
    this.customerPan,
    this.approved,
    this.uploaded,
    this.isApproved,
  });
}
