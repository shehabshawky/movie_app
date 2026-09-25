import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String appLanguage = "ar";

  void changeLanguage(String newapplanguage) {
    if (appLanguage == newapplanguage) {
      return;
    }
    appLanguage = newapplanguage;
    notifyListeners();
  }
}
