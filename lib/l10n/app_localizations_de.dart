import 'app_localizations.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Sprache';

  @override
  String get country => 'Land';

  @override
  String get invites => 'Einladungen';

  @override
  String get events => 'Veranstaltungen';

  @override
  String get upcomingEvents => 'Kommende Veranstaltungen';

  @override
  String get explore => 'Erkunden';

  @override
  String get discover => 'Entdecken';
}
