import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";

  String get displayName => _displayName;

  void updateName(String name) {
    _displayName = name;
    notifyListeners();
  }

  void refresh() {
    _displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
    notifyListeners();
  }
}
