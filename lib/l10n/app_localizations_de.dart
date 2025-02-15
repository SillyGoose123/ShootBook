// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get newTimeComment => 'Das wurde mit den neuen Schießzeiten geschossen';

  @override
  String get oldTimeComment => 'Das wurde mit den alten Schießzeiten geschossen';

  @override
  String get password => 'Passwort';

  @override
  String get disagLoginExplanation => 'Email & Passwort werden nicht auf ihrem Gerät gespeichert. Nur ein temporärer zugangs Token.';

  @override
  String get loginDisag => 'Bei Disag Anmeldung';

  @override
  String get noResults => 'Keine Ergebnisse vorhanden. Scannen oder Importieren sie welche in den Einstellungen.';

  @override
  String get importDisagResults => 'Disag Ergebnisse Importieren';
}
