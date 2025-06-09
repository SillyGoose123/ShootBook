import 'package:json_annotation/json_annotation.dart';

part 'result_type.g.dart';

@JsonEnum(alwaysCreate: true)
enum ResultType {
  //LG
  @JsonValue("LG10")
  lg10,
  @JsonValue("LG20")
  lg20,
  @JsonValue("LG40")
  lg40,
  @JsonValue("LG60")
  lg60,

  // LP
  @JsonValue("LP10")
  lp10,
  @JsonValue("LP20")
  lp20,
  @JsonValue("LP40")
  lp40,
  @JsonValue("LP60")
  lp60,

  //KK
  @JsonValue("LP10")
  kk10,
  @JsonValue("LP20")
  kk20,
  @JsonValue("KK40")
  kk40,
  @JsonValue("KK60")
  kk60,

  //kk3x (KK Dreistellung)
  @JsonValue("KK3x10")
  kk3x10,
  @JsonValue("KK3x20")
  kk3x20,

  //KKPP (Spopi Präzi)
  @JsonValue("KKPP10")
  kkpp10,
  @JsonValue("KKPP20")
  kkpp20,
  @JsonValue("KKPP40")
  kkpp40,
  @JsonValue("KKPP60")
  kkpp60,

  //KKPD (Spopi Duel)
  @JsonValue("KKPD10")
  kkpd10,
  @JsonValue("KKPD20")
  kkpd20,
  @JsonValue("KKPD40")
  kkpd40,
  @JsonValue("KKPD60")
  kkpd60;

  String toText() => _$ResultTypeEnumMap[this]!;

  int getShootCount() {
    RegExp regExp = RegExp(r'\d+');
    Match? match = regExp.firstMatch(toString());

    if (match == null) throw Exception("Incorrect type.");

    return int.parse(match.group(0)!);
  }

  //target values https://www.dsb.de/fileadmin/DSB.DE/PDF/PDF_2020/Zielscheiben_DSB_SpO_2014.pdf
  //return in mm
  double getRadiusDistance() {
    return switch (this) {
      // LG
      ResultType.lg10 ||
      ResultType.lg20 ||
      ResultType.lg40 ||
      ResultType.lg60 =>
        2.5,

      // LP
      ResultType.lp10 ||
      ResultType.lp20 ||
      ResultType.lp40 ||
      ResultType.lp60 =>
        8,

      // KK
      ResultType.kk10 ||
      ResultType.kk20 ||
      ResultType.kk40 ||
      ResultType.kk60 ||
      ResultType.kk3x10 ||
      ResultType.kk3x20 =>
        8,

      // KKP Precision
      ResultType.kkpp10 ||
      ResultType.kkpp20 ||
      ResultType.kkpp40 ||
      ResultType.kkpp60 =>
        25,

      // KKP Duel
      ResultType.kkpd10 ||
      ResultType.kkpd20 ||
      ResultType.kkpd40 ||
      ResultType.kkpd60 =>
        40
    };
  }

  double getSmallestRadius() {
    return switch (this) {
      // LG
      ResultType.lg10 ||
      ResultType.lg20 ||
      ResultType.lg40 ||
      ResultType.lg60 =>
        0.5,

      // LP
      ResultType.lp10 ||
      ResultType.lp20 ||
      ResultType.lp40 ||
      ResultType.lp60 =>
        11.5,

      // KK
      ResultType.kk10 ||
      ResultType.kk20 ||
      ResultType.kk40 ||
      ResultType.kk60 ||
      ResultType.kk3x10 ||
      ResultType.kk3x20 =>
        10.4,

      // KKP Precision
      ResultType.kkpp10 ||
      ResultType.kkpp20 ||
      ResultType.kkpp40 ||
      ResultType.kkpp60 =>
        50,

      // KKP Duel
      ResultType.kkpd10 ||
      ResultType.kkpd20 ||
      ResultType.kkpd40 ||
      ResultType.kkpd60 =>
        100
    };
  }

  double getMirrorWidth() {
    return switch (this) {
      // LG
      ResultType.lg10 ||
      ResultType.lg20 ||
      ResultType.lg40 ||
      ResultType.lg60 =>
        30.5,

      // LP
      ResultType.lp10 ||
      ResultType.lp20 ||
      ResultType.lp40 ||
      ResultType.lp60 =>
        59.5,

      // KK
      ResultType.kk10 ||
      ResultType.kk20 ||
      ResultType.kk40 ||
      ResultType.kk60 ||
      ResultType.kk3x10 ||
      ResultType.kk3x20 =>
        200,

      // KKP Precision
      ResultType.kkpp10 ||
      ResultType.kkpp20 ||
      ResultType.kkpp40 ||
      ResultType.kkpp60 =>
        200,

      // KKP Duel
      ResultType.kkpd10 ||
      ResultType.kkpd20 ||
      ResultType.kkpd40 ||
      ResultType.kkpd60 =>
        500
    };
  }

  double getScalerFactor() {
    return switch (this) {
      // LG
      ResultType.lg10 ||
      ResultType.lg20 ||
      ResultType.lg40 ||
      ResultType.lg60 =>
        180,

      // LP
      ResultType.lp10 ||
      ResultType.lp20 ||
      ResultType.lp40 ||
      ResultType.lp60 =>
        650,

      // KK
      ResultType.kk10 ||
      ResultType.kk20 ||
      ResultType.kk40 ||
      ResultType.kk60 ||
      ResultType.kk3x10 ||
      ResultType.kk3x20 =>
        500,

      // KKP Precision
      ResultType.kkpp10 ||
      ResultType.kkpp20 ||
      ResultType.kkpp40 ||
      ResultType.kkpp60 =>
        500,

      // KKP Duel
      ResultType.kkpd10 ||
      ResultType.kkpd20 ||
      ResultType.kkpd40 ||
      ResultType.kkpd60 =>
        500
    };
  }
}
