import 'dart:math';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shootbook/disag/disag_utils.dart';
import 'package:shootbook/models/result_type.dart';
import 'package:shootbook/models/series.dart';
import 'package:shootbook/models/shot.dart';
import "package:shootbook/localisation/app_localizations.dart";


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

  Result(this.series, this.value, this.type, this.comment, this.timestamp);

  void delete() {

  }

  factory Result.fromDisag(Map<String, dynamic> json, AppLocalizations locale) {
    List<Series> series = [];
    List<Shot> shots = [];
    double value = 0.0;

    Iterable<(int, dynamic)> jsonShots = (json["data"]["results"] as List<dynamic>).indexed;

    for(final (index, Map<String, dynamic> jsonShot) in jsonShots) {
      Shot shot = Shot.fromDisag(jsonShot);
      shots.add(shot);
      value += shot.value;

      if((index != 0 && index % 10 == 0) || jsonShots.length - 1 == index) {
        series.add(Series.fromShots(shots, false));
        shots = [];
      }
    }

    final String disagType = json["discipline_id"] as String;
    final ResultType type = typeFromDisag(disagType);

    final comment = isNewTime(disagType) ? locale.newTimeComment : locale.oldTimeComment;

    final DateTime time = DateTime.parse(json["created_at"]);

    // round value with precision 2
    value = double.parse(value.toStringAsFixed(2));

    return Result(series, value, type, comment, time);
  }

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);

  int calcNonTenthValue() {
    int value = 0;

    for(final curSeries in series) {
      value += curSeries.calcNonTenthValue();
    }


    return value;
  }

  String toFileString() {
    return "/${type.toText()}_$timestamp.json";
  }

  String formatTime() {
    return "${DateFormat.jm().format(timestamp)}-${DateFormat.yMd().format(timestamp).replaceAll(" ", "_")}";
  }

  @override
  String toString() {
    return "${type.toText()}_${formatTime()}";
  }
}
