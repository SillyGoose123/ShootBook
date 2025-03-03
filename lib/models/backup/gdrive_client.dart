import 'dart:convert';

import 'package:drive_helper/drive_helper.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/models/shooting/result.dart';
import 'backup_client.dart';

class GDriveClient implements BackupClient {
  static GDriveClient? _instance;
  DriveHelper driveHelper;
  String? folderId;

  GDriveClient._create(this.driveHelper);

  Future<String?> _exists(String name) async {
    try {
      return (await driveHelper.getFileID(name))[0];
    } catch (e) {
      return null;
    }
  }

  _checkFolder() async {
    String? exists = await _exists("ShootBookResults");

    exists ??=
        await driveHelper.createFile("ShootBookResults", FileMIMETypes.folder);

    return exists;
  }

  static Future<GDriveClient> getInstance() async {
    DriveHelper driveHelper = await DriveHelper.initialise(
        ["https://www.googleapis.com/auth/drive.file"]);
    _instance ??= GDriveClient._create(driveHelper);
    return _instance!;
  }

  @override
  Future<void> add(Result result) async {
    await driveHelper.createFile(result.toFileString(), "application/json",
        text: result.toFormatedJson().replaceAll("ß", "ss"),
        parents: [folderId!]);
  }

  @override
  Future<void> validateBackup() async {
    ModelSaver saver = await ModelSaver.getInstance();
    List<Result> results = await saver.load(false);

    folderId = await _checkFolder();

    for (final result in results) {
      if ((await _exists(result.toFileString())) != null) {
        await remove(result);
      }

      await add(result);
    }
  }

  @override
  Future<void> remove(Result result) async {
    String id = (await driveHelper.getFileID(result.toFileString())).first;
    await driveHelper.deleteFile(id);
  }

  @override
  Future<void> import() async {
    var files = (await driveHelper.driveAPI.files.list(q: "trashed=false", spaces: folderId)).files;
    if(files == null) throw "No results in gdrive found";

    ModelSaver saver = await ModelSaver.getInstance();
    for(var file in files) {
      try {
        String fileContent = await driveHelper.getData(file.id!);
        saver.save(Result.fromJson(jsonDecode(fileContent)));
      } catch(e) {
        continue;
      }
    }

  }
}
