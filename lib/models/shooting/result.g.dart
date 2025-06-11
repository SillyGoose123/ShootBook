// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'series',
      'value',
      'type',
      'timestamp',
      'competitionShotCount'
    ],
  );
  return Result(
    (json['series'] as List<dynamic>)
        .map((e) => Series.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['value'] as num).toDouble(),
    $enumDecode(_$ResultTypeEnumMap, json['type']),
    json['comment'] as String? ?? '',
    DateTime.parse(json['timestamp'] as String),
    (json['competitionShotCount'] as num).toInt(),
  );
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'series': instance.series,
      'value': instance.value,
      'type': _$ResultTypeEnumMap[instance.type]!,
      'comment': instance.comment,
      'timestamp': instance.timestamp.toIso8601String(),
      'competitionShotCount': instance.competitionShotCount,
    };

const _$ResultTypeEnumMap = {
  ResultType.lg: 'LG',
  ResultType.lp: 'LP',
  ResultType.kk: 'KK',
  ResultType.kk3x: 'KK 3x',
  ResultType.kkPP: 'KK PP',
  ResultType.kkPD: 'KK KD',
};
