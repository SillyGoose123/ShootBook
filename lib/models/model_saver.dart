import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shootbook/models/result.dart';
import 'package:shootbook/models/result_type.dart';

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

  void save(Result result) {
    if (_storedResults[result.type] != null &&
        _storedResults[result.type]!.contains(result)) {
      throw Exception("Result already stored.");
    }

    if (_storedResults[result.type] != null) _storedResults[result.type] = [];
    _storedResults[result.type]!.add(result);
  }

  //TODO: implement comment edit
  void edit() {}

  Future<List<Result>> loadAll(ResultType type) async {
    if (_storedResults[type] != null) {
      return _storedResults[type]!;
    }

    _storedResults[type] = [];

    List<FileSystemEntity> typeFiles = await _directory
        .list()
        .where((FileSystemEntity entity) =>
            ResultTypeExtension.fromString(
                entity.path.split("/").last.split("_")[0]) ==
            type)
        .toList();

    for (FileSystemEntity file in typeFiles) {
      final contents = await File(file.path).readAsString();
      _storedResults[type]!.add(Result.fromJson(jsonDecode(contents)));
    }

    return _storedResults[type]!;
  }
}
