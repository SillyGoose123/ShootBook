import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'shot.g.dart';
@JsonSerializable()
class Shot {
  @JsonKey(required: true)
  final int x, y;

  @JsonKey(required: true)
  final double value;

  Shot(this.x, this.y, this.value);

  factory Shot.fromDisag(Map<String, dynamic> shot) {
    return Shot(shot["x"], shot["y"], shot["value"] / 10);
  }

  factory Shot.fromJson(Map<String, dynamic> json) => _$ShotFromJson(json);
  Map<String, dynamic> toJson() => _$ShotToJson(this);

  double calcDirection() {
    //calc rotation in which up pointing arrow needs to be rotated
    return (atan2(y, x) * 180 / pi) + 224;
  }

  double calcDivider() {
    return sqrt(pow(x,2)  + pow(y,2)) * 20 / 20;
  }

  @override
  String toString() {
    return _$ShotToJson(this).toString();
  }
}