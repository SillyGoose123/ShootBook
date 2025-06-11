import 'package:shootbook/disag/disag_client.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/models/shooting/result.dart';
import "package:shootbook/localizations/app_localizations.dart";
import '../models/shooting/result_type.dart';

List<dynamic> gatherAllResults(List<dynamic> json, AppLocalizations locale) {
  List<dynamic> results = [];

  for (final Map<String, dynamic> result in json) {
    try {
      results.add(Result.fromDisag(result, locale));
    } catch (e) {
      results.add("Test $e");
    }
  }

  return results;
}

class UnknownDisagTypeException implements Exception {

}

(ResultType, int) parseDisagType(String disagType) {
  List<int> split = disagType.split("_").map((val) => int.parse(val)).toList();

  if(split[0] == 50) {
    return switch(split[1]) {
      1 => (ResultType.lg, 20),
      2 => (ResultType.lg, 40),
      5 => (ResultType.lp, 20),
      6 => (ResultType.lp, 40),
      _ => throw UnknownDisagTypeException()
    };
  }

  ResultType type = switch (split[0]) {
    100 => ResultType.lg,
    300 => ResultType.lp,
    400 => ResultType.kk,
    500 => ResultType.kk3x,
    _ => throw UnknownDisagTypeException()
  };

  return (type, split[1] * 10);
}

bool isNewTime(String disagType) {
  return disagType.split("_")[0] == "50";
}

bool checkEmail(String value) {
  final regex = RegExp(r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])');

  return regex.hasMatch(value);
}

Future<void> deleteAllResults(AppLocalizations locale) async {
  //instantiate clients
  ModelSaver saver = await ModelSaver.getInstance();
  DisagClient client = await DisagClient.getInstance(locale);

  //gather all results
  List<Result> results = await saver.load(true);
  List<dynamic> disagResults = await client.makeResultReq();
  List<dynamic> parsedDisagResults = gatherAllResults(disagResults, locale);

  //search & delete results
  for (final Result result in results) {
    int index = parsedDisagResults
        .indexWhere((dynamic res) => res.toString() == result.toString());
    if (index == -1) continue;

    await client.deleteResult(disagResults[index]["id"]);
  }

  await saver.deleteAll();
}
