

class AnchorsListApiModel {
  List<String> anchorNameList;
  List<AccountLetterModel> accountLetters;

  AnchorsListApiModel(
      this.anchorNameList,
      this.accountLetters,
      );
}



class AccountLetterModel {
  String anchorName;
  String companyPan;
  String customerPan;
  String accountLetterUrl;
  String accountLetterExt;
  String uploaded;
  String approved;

  AccountLetterModel(
    this.anchorName,
    this.companyPan,
    this.customerPan,
    this.accountLetterUrl,
    this.accountLetterExt,
    this.uploaded,
    this.approved,
  );
}
