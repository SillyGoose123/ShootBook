import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shootbook/localisation/app_localizations.dart';
import 'package:shootbook/models/result.dart';
import 'package:shootbook/models/result_type.dart';
import 'package:shootbook/ui/common/utils.dart';

//https://docs.flutter.dev/cookbook/persistence/reading-writing-files
class ModelSaver {
  static ModelSaver? _instance;
  final Directory _directory;
  final Map<ResultType, List<Result>> _storedResults = {};

  ModelSaver._create(this._directory);

  static Future<ModelSaver> getInstance() async {
    _instance ??= ModelSaver._create(await getApplicationDocumentsDirectory());
    return _instance!;
  }

  Future<void> _writeToFiles() async {
    for (ResultType type in _storedResults.keys) {
      for (Result result in _storedResults[type] ?? []) {
        await File(_directory.path + result.toFileString())
            .writeAsString(jsonEncode(result.toJson()));
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
      throw Exception("Result already stored.");
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

  Future<List<Result>> loadAll() async {
    List<Result> all = [];

    for (ResultType type in ResultType.values) {
      all.addAll(await load(type));
    }

    return all;
  }

  Future<List<Result>> load(ResultType type) async {
    if (_storedResults[type] != null) {
      return _storedResults[type]!;
    }

    _storedResults[type] = [];

    List<FileSystemEntity> typeFiles = await _directory
        .list()
        .where((FileSystemEntity entity) =>
            entity.path.split("/").last.split("_")[0] == type.toString())
        .toList();

    for (FileSystemEntity file in typeFiles) {
      final contents = await File(file.path).readAsString();
      _storedResults[type]!.add(Result.fromJson(jsonDecode(contents)));
    }

    return _storedResults[type] ?? [];
  }
}

bool containsResult(List<Result> results, Result result) {
  return results.indexWhere((Result res) =>
          res.value == result.value && res.timestamp == result.timestamp) !=
      -1;
}
