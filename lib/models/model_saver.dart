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
  bool _loaded = false;

  ModelSaver._create(this._directory);

  static Future<ModelSaver> getInstance() async {
    final appDir = await getApplicationDocumentsDirectory();
    Directory dir = Directory("${appDir.path}/results");

    if(!await dir.exists()) {
      dir = await dir.create();
    }

    _instance ??= ModelSaver._create(dir);
    return _instance!;
  }

  Future<void> _writeToFiles() async {
    var encoder = JsonEncoder.withIndent("     ");

    for (ResultType type in _storedResults.keys) {
      for (Result result in _storedResults[type] ?? []) {
        File file = File(_directory.path + result.toFileString());

        String json = encoder.convert(result.toJson());

        await file.writeAsString(json);
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

  Future<List<Result>> load() async {
    //load if not loaded before
    await _load();

    //make a list
    return _storedResults.values.expand((list) => list).toList();
  }

  Future<void> _load() async {
    if (_loaded) return;
    _loaded = true;

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
}

bool containsResult(List<Result> results, Result result) {
  return results.indexWhere((Result res) =>
          res.value == result.value && res.timestamp == result.timestamp) !=
      -1;
}
