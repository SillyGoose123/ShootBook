import 'dart:convert';
import 'package:shootbook/models/result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../models/result_type.dart';

List<Result> gatherAllResults(String json, AppLocalizations locale) {
  List<Result> results = [];

  for (final Map<String, dynamic> result in jsonDecode(json)) {
    results.add(Result.fromDisag(result["data"]["results"], locale));
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
