import 'package:shootbook/models/backup/gdrive_client.dart';
import 'package:shootbook/models/settings.dart';

import '../shooting/result.dart';
import 'backup_type.dart';

abstract class BackupClient {
  static BackupClient? _instance;


  static Future<BackupClient?> getInstance() async {
    Settings settings = await Settings.getInstance();
    switch(settings.backup) {
      case BackupType.drive:
        if(_instance.runtimeType == GDriveClient) return _instance;
        _instance = await GDriveClient.getInstance();

      default:
        return null;
    }

    return _instance;
  }

  Future<void> add(Result result);

  Future<void> validateBackup();

  Future<void> remove(Result result);

  Future<void> import();
}