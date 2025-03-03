import 'package:shared_preferences/shared_preferences.dart';
import 'package:shootbook/models/backup/backup_type.dart';



class Settings {
  static Settings? _instance;
  final SharedPreferences _prefs;

  late BackupType backup;

  Settings._create(this._prefs);

  static Future<Settings> getInstance() async {
    final prefs = await SharedPreferences.getInstance();

    _instance ??= Settings._create(prefs);
    await _instance!.load();

    return _instance!;
  }

  Future<void> load() async {
    backup = BackupType.values[_prefs.getInt("backup") ?? 0];
  }

  Future<void> store() async {
    await _prefs.setInt("backup", backup.index);
  }

  Future<void> reset() async {
    backup = BackupType.none;

    store();
  }
}
