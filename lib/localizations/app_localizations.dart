import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localizations/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en')
  ];

  /// No description provided for @newTimeComment.
  ///
  /// In de, this message translates to:
  /// **'Das wurde mit den neuen Schießzeiten geschossen.'**
  String get newTimeComment;

  /// No description provided for @oldTimeComment.
  ///
  /// In de, this message translates to:
  /// **'Das wurde mit den alten Schießzeiten geschossen.'**
  String get oldTimeComment;

  /// No description provided for @password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get password;

  /// No description provided for @disagLoginExplanation.
  ///
  /// In de, this message translates to:
  /// **'Email & Passwort werden nicht auf ihrem Gerät gespeichert. Nur ein temporärer zugangs Token.'**
  String get disagLoginExplanation;

  /// No description provided for @loginDisag.
  ///
  /// In de, this message translates to:
  /// **'Bei Disag Anmelden'**
  String get loginDisag;

  /// No description provided for @noResults.
  ///
  /// In de, this message translates to:
  /// **'Keine Ergebnisse vorhanden. Scannen oder Importieren sie welche in den Einstellungen.'**
  String get noResults;

  /// No description provided for @importDisagResults.
  ///
  /// In de, this message translates to:
  /// **'Disag Ergebnisse Importieren'**
  String get importDisagResults;

  /// No description provided for @importingDisagResults.
  ///
  /// In de, this message translates to:
  /// **'Disag Ergebnisse werden importiert...'**
  String get importingDisagResults;

  /// No description provided for @invalidEmail.
  ///
  /// In de, this message translates to:
  /// **'Ungültige Emailaddresse'**
  String get invalidEmail;

  /// No description provided for @logout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden von Disag'**
  String get logout;

  /// No description provided for @loginFailed.
  ///
  /// In de, this message translates to:
  /// **'Falsche Anmeldedaten'**
  String get loginFailed;

  /// No description provided for @importFailed.
  ///
  /// In de, this message translates to:
  /// **'Ergebnis Import fehlgeschlagen'**
  String get importFailed;

  /// No description provided for @importOfFailed.
  ///
  /// In de, this message translates to:
  /// **'Ergebnis {name} konnte nicht importiert werden'**
  String importOfFailed(String name);

  /// No description provided for @deleteAll.
  ///
  /// In de, this message translates to:
  /// **'Alle Ergebnise löschen'**
  String get deleteAll;

  /// No description provided for @deleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Löschen?'**
  String get deleteTitle;

  /// No description provided for @sureDeletingAll.
  ///
  /// In de, this message translates to:
  /// **'Sind sie sicher alle Ergebnisse zu löschen?'**
  String get sureDeletingAll;

  /// No description provided for @no.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get yes;

  /// No description provided for @yesDisag.
  ///
  /// In de, this message translates to:
  /// **'Ja und auch in Disag'**
  String get yesDisag;

  /// No description provided for @resultAlreadyStored.
  ///
  /// In de, this message translates to:
  /// **'Result ist schon gespeichert.'**
  String get resultAlreadyStored;

  /// No description provided for @export.
  ///
  /// In de, this message translates to:
  /// **'Exportieren'**
  String get export;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
