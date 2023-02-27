import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic> _userData;
  String _role;

  Map<String, dynamic> get userData => _userData;

  String get role => _role;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<Object> tokenId() async {}

  void authChange(bool data, String role, {bool notify = true}) {
    _isAuthenticated = data;
    _role = role;
    if(notify) {
      notifyListeners();
    }
  }

  void setUserdata(Map<String, dynamic> user) {
    _userData = user;
    notifyListeners();
  }
}
