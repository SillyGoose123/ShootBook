import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import "package:shootbook/localizations/app_localizations.dart";
import 'package:shootbook/models/shooting/result.dart';
import 'package:shootbook/models/shooting/result_type.dart';
import 'package:shootbook/ui/common/utils.dart';

class ResultAlreadyStoredException implements Exception {
  ResultAlreadyStoredException(String s);
}

//https://docs.flutter.dev/cookbook/persistence/reading-writing-files
class ModelSaver {
  static ModelSaver? _instance;
  final Directory _directory;
  final Directory _backupDirectory;
  Map<ResultType, List<Result>> _storedResults = {};
  bool _loaded = false;

  ModelSaver._create(this._directory, this._backupDirectory);

  static Future<ModelSaver> getInstance() async {
    final appDir = await getApplicationDocumentsDirectory();
    Directory dir = Directory("${appDir.path}/results");

    if (!await dir.exists()) {
      dir = await dir.create();
    }

    _instance ??= ModelSaver._create(dir, Directory("${appDir.path}/backups"));
    return _instance!;
  }

  Future<void> _writeToFiles() async {
    for (ResultType type in _storedResults.keys) {
      for (Result result in _storedResults[type] ?? []) {
        File file = File("${_directory.path}/${result.toFileString()}");
        file.create();

        await file.writeAsString(result.toFormatedJson());
      }
    }
  }

  Future<void> saveAll(List<Result> results, BuildContext context) async {
    for (Result res in results) {
      try {
        await save(res);
      } catch (e) {
        if (context.mounted) {
          showSnackBarError(
              AppLocalizations.of(context)!.importOfFailed(res.toString()),
              context);
        }
      }
    }
  }

  Future<void> save(Result result) async {
    if (_storedResults[result.type] != null &&
        containsResult(_storedResults[result.type]!, result)) {
      throw ResultAlreadyStoredException("Result already stored.");
    }

    if (_storedResults[result.type] == null) _storedResults[result.type] = [];
    _storedResults[result.type]!.add(result);

    await _writeToFiles();
  }

  Future<void> edit(Result result) async {
    int index = _storedResults[result.type]!.indexWhere((Result res) =>
        res.value == result.value && res.timestamp == result.timestamp);
    _storedResults[result.type]?[index].comment = result.comment;

    await _writeToFiles();
  }

  Future<List<Result>> load(bool? loadAgain) async {
    if ((loadAgain != null && loadAgain) || !_loaded) {
      _loaded = true;
      _storedResults = {};
      //load if not loaded before
      await _load();
    }

    //make a list
    return _storedResults.values.expand((list) => list).toList();
  }

  Future<void> _load() async {
    await for (var entity in _directory.list()) {
      if (entity is! File) continue;
      try {
        final contents = await File(entity.path).readAsString();
        final result = Result.fromJson(jsonDecode(contents));

        if (_storedResults[result.type] == null) {
          _storedResults[result.type] = [];
        }
        _storedResults[result.type]!.add(result);
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> delete(Result result) async {
    await for (var entity in _directory.list()) {
      if (entity is! File) continue;
      try {
        final contents = await File(entity.path).readAsString();
        final fileResult = Result.fromJson(jsonDecode(contents));
        if (fileResult == result) {
          await entity.delete();
        }
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> deleteAll() async {
    await for (var entity in _directory.list()) {
      if (entity is! File) continue;
      try {
        await entity.delete();
      } catch (e) {
        continue;
      }
    }
  }

  Future<File> createZip() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    load(false);

    final zipFile = File("${_backupDirectory.path}/${packageInfo.appName}_export_${formatDate(DateTime.now().toLocal())}.zip");

    final zipper = ZipFileEncoder();
    zipper.create(zipFile.path);

    await for (var entity in _directory.list()) {
      if (entity is! File) continue;
      await zipper.addFile(entity);
    }

    zipper.close();

    return zipFile;
  }

  Future<void> zipExportCleanUp() async {
    Directory cacheDir = await getApplicationCacheDirectory();
    //remove cache
    await cacheDir.delete(recursive: true);

    //remove backup
    await _backupDirectory.delete(recursive: true);
  }

  Future<void> importZip(File file) async {
    extractFileToDisk(file.path, _directory.path);
    load(true);
  }

}

bool containsResult(List<Result> results, Result result) {
  return results.indexWhere((Result res) =>
          res.value == result.value && res.timestamp == result.timestamp) !=
      -1;
}


String formatDate(DateTime timestamp) {
  return DateFormat(
    "d-M-y_HH-mm",
  ).format(timestamp);
}
