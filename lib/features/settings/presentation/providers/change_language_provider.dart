import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageProvider with ChangeNotifier {
  Locale? _applicationLocale;
  Locale? get applicationLocale => _applicationLocale;

  void changeLanguage(Locale localeType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (localeType == Locale("en")) {
      await sharedPreferences.setString("languageCode", "en");
    } else if (localeType == Locale("de")) {
      await sharedPreferences.setString("languageCode", "de");
    } else {
      await sharedPreferences.setString("languageCode", "fr");
    }
    notifyListeners();
  }
}
