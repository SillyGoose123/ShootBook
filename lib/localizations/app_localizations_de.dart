import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get newTimeComment => 'Das wurde mit den neuen Schießzeiten geschossen.';

  @override
  String get oldTimeComment => 'Das wurde mit den alten Schießzeiten geschossen.';

  @override
  String get password => 'Passwort';

  @override
  String get disagLoginExplanation => 'Email & Passwort werden nicht auf ihrem Gerät gespeichert. Nur ein temporärer zugangs Token.';

  @override
  String get loginDisag => 'Bei Disag Anmelden';

  @override
  String get noResults => 'Keine Ergebnisse vorhanden. Scannen oder Importieren sie welche in den Einstellungen.';

  @override
  String get importDisagResults => 'Disag Ergebnisse Importieren';

  @override
  String get importingDisagResults => 'Disag Ergebnisse werden importiert...';

  @override
  String get invalidEmail => 'Ungültige Emailaddresse';

  @override
  String get logout => 'Abmelden von Disag';

  @override
  String get loginFailed => 'Falsche Anmeldedaten';

  @override
  String get importFailed => 'Ergebnis Import fehlgeschlagen';

  @override
  String importOfFailed(String name) {
    return 'Ergebnis $name konnte nicht importiert werden';
  }

  @override
  String get deleteAll => 'Alle Ergebnise löschen';

  @override
  String get deleteTitle => 'Löschen?';

  @override
  String get sureDeletingAll => 'Sind sie sicher alle Ergebnisse zu löschen?';

  @override
  String get no => 'Nein';

  @override
  String get yes => 'Ja';

  @override
  String get yesDisag => 'Ja und auch in Disag';

  @override
  String get resultAlreadyStored => 'Result ist schon gespeichert.';
}
