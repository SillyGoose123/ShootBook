// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['series', 'value', 'type', 'timestamp'],
  );
  return Result(
    (json['series'] as List<dynamic>)
        .map((e) => Series.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['value'] as num).toDouble(),
    $enumDecode(_$ResultTypeEnumMap, json['type']),
    json['comment'] as String? ?? '',
    DateTime.parse(json['timestamp'] as String),
  );
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'series': instance.series,
      'value': instance.value,
      'type': _$ResultTypeEnumMap[instance.type]!,
      'comment': instance.comment,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$ResultTypeEnumMap = {
  ResultType.lg10: 'LG10',
  ResultType.lg20: 'LG20',
  ResultType.lg40: 'LG40',
  ResultType.lg60: 'LG60',
  ResultType.lp10: 'LP10',
  ResultType.lp20: 'LP20',
  ResultType.lp40: 'LP40',
  ResultType.lp60: 'LP60',
  ResultType.kk10: 'LP10',
  ResultType.kk20: 'LP20',
  ResultType.kk40: 'KK40',
  ResultType.kk60: 'KK60',
  ResultType.kkpp10: 'KKPP10',
  ResultType.kkpp20: 'KKPP20',
  ResultType.kkpp40: 'KKPP40',
  ResultType.kkpp60: 'KKPP60',
  ResultType.kkpd10: 'KKPD10',
  ResultType.kkpd20: 'KKPD20',
  ResultType.kkpd40: 'KKPD40',
  ResultType.kkpd60: 'KKPD60',
};
