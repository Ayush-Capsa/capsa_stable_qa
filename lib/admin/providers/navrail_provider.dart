import 'package:flutter/cupertino.dart';

class NavRailModel extends ChangeNotifier {
  bool show = true;
  void showNavRail(bool v) {
    show = v;
    notifyListeners();
  }

  bool get showNavRailValue => show;
}
