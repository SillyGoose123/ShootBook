// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['shots', 'value'],
  );
  return Series(
    (json['shots'] as List<dynamic>)
        .map((e) => Shot.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['value'] as num).toDouble(),
    json['isProbe'] as bool? ?? false,
  );
}

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'isPractice': instance.isPractice,
      'shots': instance.shots,
      'value': instance.value,
    };
