import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get helloWorld => 'Bonjour le monde';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get country => 'Pays';

  @override
  String get invites => 'Invitations';

  @override
  String get events => 'Evénements';

  @override
  String get upcomingEvents => 'Événements à venir';

  @override
  String get explore => 'Explorer';

  @override
  String get discover => 'Découvrir';
}
