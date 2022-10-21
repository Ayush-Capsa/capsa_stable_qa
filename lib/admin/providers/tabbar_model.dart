import 'package:flutter/cupertino.dart';

class TabBarModel extends ChangeNotifier {
  int selectedIndex = 1;
  int selectedIndexTmp = 1;

  int editTabIndex ;
  String _editType;
  String _editTitle;
  String _rcNumberForPendingRevenue;
  dynamic editTabData ;

  void rcDataPass(String data) {
    _rcNumberForPendingRevenue = data;
    notifyListeners();
  }

  void changeTab(int index) {
    selectedIndex = index;
    selectedIndexTmp = index;
    notifyListeners();
  }



  void changeTab2(int index,int editTabIndexPass ,dynamic  editTabDataPass,String editTypePass,String editTitlePass) {
    selectedIndex = index;
    editTabIndex = editTabIndexPass;
    editTabData = editTabDataPass;
    _editType = editTypePass;
    _editTitle = editTitlePass;
    notifyListeners();
  }

  int get index => selectedIndex;
  String get editType => _editType;
  String get editTitle => _editTitle;
  String get rcNumberForPendingRevenue => _rcNumberForPendingRevenue;
}
