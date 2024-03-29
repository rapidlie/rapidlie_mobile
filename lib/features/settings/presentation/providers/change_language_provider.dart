import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageProvider with ChangeNotifier {
  Locale? _applicationLocale;
  Locale? get applicationLocale => _applicationLocale;

  ChangeLanguageProvider() {
    notifyListeners();
  }

  void changeLanguage(Locale localeType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _applicationLocale = localeType;

    if (localeType == Locale("en")) {
      sharedPreferences.setString("languageCode", "en");
    } else if (localeType == Locale("de")) {
      sharedPreferences.setString("languageCode", "de");
    } else {
      sharedPreferences.setString("languageCode", "fr");
    }

    notifyListeners();
  }
}
