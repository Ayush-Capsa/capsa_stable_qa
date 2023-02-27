import 'dart:typed_data';

class ProfileModel {
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

  ProfileModel({
    this.anchor,
    this.invAmount,
    this.amountPayable,
    this.buyNowPrice,
    this.date,
    this.invNo,
    this.poNo,
    this.terms,
    this.rate,
    this.img,
  });
}

class BankDetails {
  String id,
      PAN_NO,
      bank_name,
      IBTC,
      ifsc,
      account_number,
      bene_account_no,
      bene_ifsc,
      bene_bank,
      bene_account_holdername,
      bene_bvn,
      trf_typ_ft,
      pan_copy,
      chq_copy,
      inflow,
      outflow;

  BankDetails(
      {this.id,
      this.PAN_NO,
      this.bank_name,
      this.IBTC,
      this.ifsc,
      this.account_number,
      this.bene_account_no,
      this.bene_ifsc,
      this.bene_bank,
      this.bene_account_holdername,
      this.bene_bvn,
      this.trf_typ_ft,
      this.pan_copy,
      this.chq_copy,
      this.inflow,
      this.outflow});
}

class TransactionDetails {
  String account_number,
      name,
      blocked_amt,
      closing_balance,
      created_on,
      deposit_amt,
      id,
      narration,
      opening_balance,
      order_number,
      stat_txt,
      status,
      trans_hash,
      updated_on,
      withdrawl_amt,
      reference;

  TransactionDetails(
      {this.account_number,
      this.name,
      this.blocked_amt,
      this.closing_balance,
      this.created_on,
      this.deposit_amt,
      this.id,
      this.narration,
      this.opening_balance,
      this.order_number,
      this.stat_txt,
      this.status,
      this.trans_hash,
      this.updated_on,
      this.withdrawl_amt,
      this.reference});
}

class PendingTransactionDetails {
  String account_number,
      name,
      created_on,
      trans_amt,
      ref_no,
      status,
      updated_on;

  PendingTransactionDetails({
    this.account_number,
    this.name,
    this.created_on,
    this.trans_amt,
    this.ref_no,
    this.status,
    this.updated_on,
  });
}

class PortfolioData {
  var totalDiscount,
      companyPortfolioDetails,
      totalTransactions,
      grandTotalExpReturn,
      grandannualExpReturn,
      marker,
      x_axis,
      y_axis,
      up_pymt,
      retPer,
      returnPercent,
      account_no;

  bool newUser = false;

  var activeAmt;
  var activeCount;

  var ExpectedReturn;
  var investorType;

  var totalUpcomingPaymentin1month;
  var totalUpcomingPaymentin1week;
  var percentageOfPaymentIn1week;
  var percentageOfPaymentIn1month;

  var totalReceived;
  var transactionCount;

  var kyc1, kyc2, kyc3, AL_UPLOAD;
  var kyc1File, kyc2File, kyc3File, account_letterDoc;

  var pymtIn1Week;
  var pymtIn1Month;
  var pymtIn2Month;
  var pymtIn6Month;

  var invIn1Week;
  var invIn1Month;
  var invIn2Month;
  var invIn6Month;

  var perIn1Week;
  var perIn1Month;
  var perIn2Month;
  var perIn6Month;
  var totalUpcomingPayments;
  var y_axis_gain_per;

  PortfolioData({
    this.totalDiscount,
    this.companyPortfolioDetails,
    this.totalTransactions,
    this.ExpectedReturn,
    this.grandTotalExpReturn,
    this.grandannualExpReturn,
    this.totalReceived,
    this.transactionCount,
    this.marker,
    this.x_axis,
    this.y_axis,
    this.y_axis_gain_per,
    this.up_pymt,
    this.retPer,
    this.account_no,
    this.activeAmt,
    this.activeCount,
    this.investorType,
    this.newUser,
    this.kyc1,
    this.kyc2,
    this.kyc3,
    this.AL_UPLOAD,
    this.kyc1File,
    this.kyc2File,
    this.kyc3File,
    this.account_letterDoc,
    this.totalUpcomingPaymentin1month,
    this.totalUpcomingPaymentin1week,
    this.percentageOfPaymentIn1week,
    this.percentageOfPaymentIn1month,
    this.returnPercent = '0',
    this.invIn1Month,
    this.invIn1Week,
    this.invIn2Month,
    this.invIn6Month,
    this.pymtIn1Month,
    this.pymtIn1Week,
    this.pymtIn2Month,
    this.pymtIn6Month,
    this.perIn1Month,
    this.perIn1Week,
    this.perIn2Month,
    this.perIn6Month,
    this.totalUpcomingPayments,
  });
}

class VendorListPortfolio {
  var name;
  var percent;
  var lastInvestment;
  var totalInvestment;
  var companyPan;

  VendorListPortfolio({
    this.name,
    this.percent,
    this.lastInvestment,
    this.totalInvestment,
    this.companyPan,
  });
}

class MyPortfolioData {
  var companyInyPortfolio;
  var invoiceBought;
  List<VendorListPortfolio> vendorList;

  MyPortfolioData({
    this.companyInyPortfolio,
    this.invoiceBought,
    this.vendorList,
  });
}

class BankList {
  final String name;
  final String code;

  const BankList(this.code, this.name);

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
      };
}

class UserData {
  String ADD_LINE;
  String CITY;
  String COUNTRY;
  String STATE;
  final String cc;
  final String contact;
  final String email;
  final String nm;

  UserData(
    this.ADD_LINE,
    this.CITY,
    this.COUNTRY,
    this.STATE,
    this.cc,
    this.contact,
    this.email,
    this.nm,
  );

// Map<String, dynamic> toJson() => {
//   'name': name,
//   'code': code,
// };

}

class AccountData {
  String panNumber;
  String name;
  String role;
  String userId;
  bool isBlackListed;
  bool isRestricted;
  String email;

  AccountData(
      {this.panNumber,
      this.name,
      this.role,
      this.userId,
      this.isBlackListed,
      this.isRestricted,
      this.email});
}

class PendingAccountData {
  String panNumber;
  String name;
  String role;
  String role2;
  String userId;
  String contact;
  bool isBlackListed;
  bool isRestricted;
  String email;
  String isApproved;
  String cacForm;
  String cacCertificate;
  String validId;
  String cacFormExt;
  String cacCertificateExt;
  String validIdExt;
  String createdDate;


  PendingAccountData(
      {this.panNumber,
      this.name,
      this.role,
        this.role2,
      this.userId,
      this.isBlackListed,
      this.isRestricted,
      this.email,
      this.isApproved,
      this.cacCertificate,
      this.cacForm,
      this.validId,
      this.contact,
      this.cacFormExt,
      this.validIdExt,
      this.cacCertificateExt,
      this.createdDate});
}

class ClosingBalanceModel{

  String accountNumber;
  String name;
  String panNumber;
  String closingBalance;

  ClosingBalanceModel({
    this.panNumber,
    this.accountNumber,
    this.name,
    this.closingBalance
});

}