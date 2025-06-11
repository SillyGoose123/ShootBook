import 'package:json_annotation/json_annotation.dart';

part 'result_type.g.dart';

// All double values are mm
@JsonEnum(alwaysCreate: true)
enum ResultType {
  @JsonValue("LG")
  lg(
      diameterOf10: 0.5,
      valueDistance: 2.5,
      targetWidth: 45.5,
      mirrorWidth: 30.5),
  @JsonValue("LP")
  lp(
      diameterOf10: 11.5,
      valueDistance: 8,
      targetWidth: 45.5,
      mirrorWidth: 30.5,
      inner10: 5),
  @JsonValue("KK")
  kk(
      diameterOf10: 10.4,
      valueDistance: 8,
      targetWidth: 154.4,
      mirrorWidth: 112.4,
      inner10: 5),
  @JsonValue("KK 3x")
  kk3x(
      diameterOf10: 10.4,
      valueDistance: 8,
      targetWidth: 154.4,
      mirrorWidth: 112.4,
      inner10: 5),
  @JsonValue("KK PP")
  kkPP(
      diameterOf10: 50,
      valueDistance: 25,
      targetWidth: 500,
      mirrorWidth: 200,
      inner10: 25),
  @JsonValue("KK KD")
  kkPD(
      diameterOf10: 100,
      valueDistance: 40,
      targetWidth: 500,
      mirrorWidth: 200,
      inner10: 50);

  const ResultType({
    required this.diameterOf10,
    required this.valueDistance,
    required this.targetWidth,
    required this.mirrorWidth,
    this.inner10,
  });

  final double diameterOf10, valueDistance, targetWidth, mirrorWidth;
  final double? inner10;

  double get radiusOf10 => diameterOf10 / 2;
  double get mirrorRadius => mirrorWidth / 2;
  double get mirrorNumberAmount => (mirrorWidth / valueDistance) / 2;

  @override
  String toString() => _$ResultTypeEnumMap[this]!;
}
