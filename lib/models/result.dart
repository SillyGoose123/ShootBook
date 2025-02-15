import 'package:json_annotation/json_annotation.dart';
import 'package:shootbook/disag/disag_utils.dart';
import 'package:shootbook/models/result_type.dart';
import 'package:shootbook/models/series.dart';
import 'package:shootbook/models/shot.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    for(final (index, Map<String, dynamic> jsonShot) in json["data"].indexed) {
      Shot shot = Shot.fromDisag(jsonShot);
      shots.add(shot);
      value += shot.value;

      if(index % 10 == 0) {
        shots = [];
        series.add(Series.fromShots(shots, false));
      }
    }
    final String disagType = json["discipline_id"] as String;
    final ResultType type = typeFromDisag(disagType);
    final comment = isNewTime(disagType) ? locale.newTimeComment : locale.oldTimeComment;

    final DateTime time = DateTime.parse(json["created_at"]);

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
    return "/${type}_$timestamp.json";
  }
}
