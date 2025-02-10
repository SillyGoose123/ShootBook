import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
  kkpd60,
}

extension ResultTypeExtension on ResultType {
  static ResultType fromString(String type) {
    return $enumDecode(_$ResultTypeEnumMap, jsonDecode(type));
  }
}

