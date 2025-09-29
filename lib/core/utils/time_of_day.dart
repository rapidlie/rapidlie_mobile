import 'package:flutter/material.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

String getTimeOfDayGreeting(BuildContext context) {
  final hour = TimeOfDay.now().hour;

  if (hour >= 3 && hour < 12) {
    return AppLocalizations.of(context).morning;
  } else if (hour >= 12 && hour < 17) {
    return AppLocalizations.of(context).afternoon;
  } else {
    return AppLocalizations.of(context).evening;
  }
}
