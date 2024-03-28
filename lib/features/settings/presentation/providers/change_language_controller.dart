import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageController with ChangeNotifier {
  Locale? _applicationLocale;
  Locale? get applicationLocale => _applicationLocale;

  void changeLanguage(Locale locale) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  }
}
