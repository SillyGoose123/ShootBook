import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shootbook/disag/disag_utils.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/models/shooting/result_type.dart';
import 'package:shootbook/models/shooting/series.dart';
import 'package:shootbook/models/shooting/shot.dart';
import "package:shootbook/localizations/app_localizations.dart";

part "result.g.dart";

@JsonSerializable()
class Result {
  @JsonKey(required: true)
  final List<Series> series;

  @JsonKey(required: true)
  final double value;

  @JsonKey(required: true)
  final ResultType type;

  @JsonKey(required: false, defaultValue: "")
  String comment;

  @JsonKey(required: true)
  final DateTime timestamp;

  @JsonKey(required: true)
  final int competitionShotCount;

  Result(this.series, this.value, this.type, this.comment, this.timestamp, this.competitionShotCount);

  factory Result.fromDisag(Map<String, dynamic> json, AppLocalizations locale) {
    List<Series> series = [];
    List<Shot> shots = [];
    double value = 0.0;

    Iterable<(int, dynamic)> jsonShots =
        (json["data"]["results"] as List<dynamic>).indexed;

    final String disagType = json["discipline_id"] as String;
    final (ResultType type, int competitionShotCount) = parseDisagType(disagType);

    int practiceShootCount = jsonShots.length - competitionShotCount;
    for (final (index, Map<String, dynamic> jsonShot) in jsonShots) {
      Shot shot = Shot.fromDisag(jsonShot);
      shots.add(shot);

      if (index >= practiceShootCount) value += shot.value;

      if ((index != 0 && index % 10 == 0) ||
          jsonShots.length - 1 == index ||
          index == practiceShootCount - 1) {
        series.add(Series.fromShots(shots, index < practiceShootCount));
        shots = [];
      }
    }

    final comment =
        isNewTime(disagType) ? locale.newTimeComment : locale.oldTimeComment;
    final DateTime time = json["created_at"] != null ?DateTime.parse(json["created_at"]) : DateTime.now();

    // round value with precision 2
    value = double.parse(value.toStringAsFixed(2));

    return Result(series, value, type, comment, time, competitionShotCount);
  }

  //JSON parse/encode
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);

  String toFormatedJson()  {
    JsonEncoder encoder = JsonEncoder.withIndent("  ");
    return encoder.convert(toJson());
  }

  int calcNonTenthValue() {
    int value = 0;

    for (final curSeries in series) {
      if (curSeries.isPractice) continue;
      value += curSeries.calcNonTenthValue();
    }

    return value;
  }

  List<Shot> getAllShots() {
    return series.expand((list) => list.shots).toList();
  }

  String get disciplineClass => "$type$competitionShotCount";

  String toFileString() {
    return "${disciplineClass}_${formatDate(timestamp.toLocal())}.json";
  }

  String formatTime() {
    return DateFormat(
      "d.M.y, HH:mm",
    ).format(timestamp.toLocal());
  }

  @override
  String toString() {
    return "${disciplineClass}_${formatTime()}";
  }
}
