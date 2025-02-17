import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get newTimeComment => 'This was shot with new Time';

  @override
  String get oldTimeComment => 'This was shot in old time';

  @override
  String get password => 'Password';

  @override
  String get disagLoginExplanation => 'Email & Password aren\'t stored on your device. Only a temporary access token.';

  @override
  String get loginDisag => 'Login to Disag';

  @override
  String get noResults => 'No results found. Scan or import them in the settings.';

  @override
  String get importDisagResults => 'Import Disag Results';

  @override
  String get importingDisagResults => 'Importing Disag Results...';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get logout => 'Logout from Disag';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get importFailed => 'Result import failed';

  @override
  String importOfFailed(String name) {
    return 'Result $name couldn\'t be imported';
  }
}
