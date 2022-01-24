import 'package:flutter/material.dart';

abstract class DefaultChangeNotifier extends ChangeNotifier {
  bool loading = false;

  void toggleLoading(bool val) {
    loading = val;
    notifyListeners();
  }
}
