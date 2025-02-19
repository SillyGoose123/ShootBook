import 'package:json_annotation/json_annotation.dart';
import 'package:shootbook/models/shot.dart';

part "series.g.dart";
@JsonSerializable()
class Series {
  @JsonKey(required: false, defaultValue: false)
  bool isPractice;

  @JsonKey(required: true)
  List<Shot> shots;

  @JsonKey(required: true)
  double value;

  Series(this.shots, this.value, this.isPractice);

  factory Series.fromShots(List<Shot> shots, bool isProbe) {
    double value = 0.0;

    for(final shot in shots) {
      value += shot.value;
    }

    return Series(shots, value, isProbe);
  }

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesToJson(this);

  int calcNonTenthValue() {
    int value = 0;

    for(final Shot shot in shots) {
      value += shot.value.truncate();
    }

    return value;
  }

  @override
  String toString() {
    return _$SeriesToJson(this).toString();
  }
}