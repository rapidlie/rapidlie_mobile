import 'dart:ui';

import 'package:rapidlie/l10n/app_localizations.dart';

Locale getDefaultDeviceLocale() {
  // Retrieve the default locale from the window
  Locale defaultLocale = PlatformDispatcher.instance.locale;
  return defaultLocale;
}

Locale returnLoale() {
  List<Locale> allLocales = AppLocalizations.supportedLocales;
  if (allLocales.contains(getDefaultDeviceLocale())) {
    return getDefaultDeviceLocale();
  } else {
    return Locale("en");
  }
}
