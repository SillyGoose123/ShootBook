import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get newTimeComment => 'This was shot with new time.';

  @override
  String get oldTimeComment => 'This was shot in old time.';

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

  @override
  String get deleteAll => 'Delete All Results';

  @override
  String get deleteTitle => 'Delete?';

  @override
  String get sureDeletingAll => 'Sure deleting all Results?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get yesDisag => 'Yes in Disag too';

  @override
  String get yesCloud => 'Yes in Cloud too';

  @override
  String get resultAlreadyStored => 'Result already saved.';

  @override
  String resultAlreadyStoredName(String name) {
    return 'Result $name already saved.';
  }

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get qrCodeScanFailed => 'Qr Code reading failed.';

  @override
  String get saveFailed => 'Couln\'t save result.';
}
