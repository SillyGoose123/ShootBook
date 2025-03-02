import 'package:shootbook/disag/disag_client.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/models/result.dart';
import "package:shootbook/localizations/app_localizations.dart";
import '../models/result_type.dart';

List<Result> gatherAllResults(List<dynamic> json, AppLocalizations locale) {
  List<Result> results = [];

  for (final Map<String, dynamic> result in json) {
    results.add(Result.fromDisag(result, locale));
  }

  return results;
}

ResultType typeFromDisag(String disagType) {
  switch (disagType) {
    //lg 20
    case "50_1":
    case "100_2":
      return ResultType.lg20;

    //lg 40
    case "50_2":
    case "100_4":
      return ResultType.lg40;

    //lp 20
    case "50_5":
    case "300_2":
      return ResultType.lg20;

    //lp 40
    case "50_6":
    case "300_4":
      return ResultType.lg40;

    default:
      throw Exception("Unknown Disag type: $disagType");
  }
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
  List<Result> parsedDisagResults = gatherAllResults(disagResults, locale);

  //search & delete results
  for (final Result result in results) {
    int index = parsedDisagResults
        .indexWhere((Result res) => res.toString() == result.toString());
    if (index == -1) continue;

    await client.deleteResult(disagResults[index]["id"]);
  }

  await saver.deleteAll();
}
