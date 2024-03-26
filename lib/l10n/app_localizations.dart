import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In de, this message translates to:
  /// **'Hallo Welt!'**
  String get helloWorld;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @country.
  ///
  /// In de, this message translates to:
  /// **'Land'**
  String get country;

  /// No description provided for @invites.
  ///
  /// In de, this message translates to:
  /// **'Einladungen'**
  String get invites;

  /// No description provided for @events.
  ///
  /// In de, this message translates to:
  /// **'Veranstaltungen'**
  String get events;

  /// No description provided for @upcomingEvents.
  ///
  /// In de, this message translates to:
  /// **'Kommende Veranstaltungen'**
  String get upcomingEvents;

  /// No description provided for @explore.
  ///
  /// In de, this message translates to:
  /// **'Erkunden'**
  String get explore;

  /// No description provided for @discover.
  ///
  /// In de, this message translates to:
  /// **'Entdecken'**
  String get discover;

  /// No description provided for @general.
  ///
  /// In de, this message translates to:
  /// **'Allgemein'**
  String get general;

  /// No description provided for @seeAll.
  ///
  /// In de, this message translates to:
  /// **'Alle sehen'**
  String get seeAll;

  /// No description provided for @hi.
  ///
  /// In de, this message translates to:
  /// **'Hallo'**
  String get hi;

  /// No description provided for @noEventCreated.
  ///
  /// In de, this message translates to:
  /// **'Sie haben noch keine Veranstaltung erstellt. Klicken Sie auf die Schaltfläche, um Ihre Veranstaltung hinzuzufügen'**
  String get noEventCreated;

  /// No description provided for @description.
  ///
  /// In de, this message translates to:
  /// **'Beschreibung'**
  String get description;

  /// No description provided for @date.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get date;

  /// No description provided for @time.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit'**
  String get time;

  /// No description provided for @venue.
  ///
  /// In de, this message translates to:
  /// **'Veranstaltungsort'**
  String get venue;

  /// No description provided for @directions.
  ///
  /// In de, this message translates to:
  /// **'Wegbeschreibung'**
  String get directions;

  /// No description provided for @createEvent.
  ///
  /// In de, this message translates to:
  /// **'Ereignis erstellen'**
  String get createEvent;

  /// No description provided for @eventTitle.
  ///
  /// In de, this message translates to:
  /// **'Veranstaltungstitel'**
  String get eventTitle;

  /// No description provided for @uploadFlyer.
  ///
  /// In de, this message translates to:
  /// **'Flyer hochladen'**
  String get uploadFlyer;

  /// No description provided for @next.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get next;

  /// No description provided for @selectDate.
  ///
  /// In de, this message translates to:
  /// **'Datum auswählen'**
  String get selectDate;

  /// No description provided for @startTime.
  ///
  /// In de, this message translates to:
  /// **'Startzeit'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In de, this message translates to:
  /// **'Endzeit'**
  String get endTime;

  /// No description provided for @location.
  ///
  /// In de, this message translates to:
  /// **'Ort'**
  String get location;

  /// No description provided for @locationDescription.
  ///
  /// In de, this message translates to:
  /// **'Dies ist der Name des Gebäudes'**
  String get locationDescription;

  /// No description provided for @publicEvent.
  ///
  /// In de, this message translates to:
  /// **'Öffentliches Ereignis'**
  String get publicEvent;

  /// No description provided for @inviteFriends.
  ///
  /// In de, this message translates to:
  /// **'Freunde einladen'**
  String get inviteFriends;

  /// No description provided for @english.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get english;

  /// No description provided for @german.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @french.
  ///
  /// In de, this message translates to:
  /// **'Französisch'**
  String get french;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
