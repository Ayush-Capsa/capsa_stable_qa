import 'package:flutter/cupertino.dart';

class TabBarModel extends ChangeNotifier {
  int selectedIndex = 0;
  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  int get index => selectedIndex;
}
