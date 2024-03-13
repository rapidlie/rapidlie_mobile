import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get country => 'Country';

  @override
  String get invites => 'Invites';

  @override
  String get events => 'Events';

  @override
  String get upcomingEvents => 'Upcoming events';

  @override
  String get explore => 'Explore';

  @override
  String get discover => 'Discover';
}
