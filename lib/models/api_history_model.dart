import 'dart:typed_data';

class ApiHistoryModel {
  final String endPoint,
      date,
      amount,
      walletBalance,
      refNo,
      status;

  ApiHistoryModel({
    this.endPoint,
    this.date,
    this.amount,
    this.walletBalance,
    this.refNo,
    this.status,
  });
}