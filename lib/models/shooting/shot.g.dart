// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shot _$ShotFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['x', 'y', 'value'],
  );
  return Shot(
    (json['x'] as num).toInt(),
    (json['y'] as num).toInt(),
    (json['value'] as num).toDouble(),
  );
}

Map<String, dynamic> _$ShotToJson(Shot instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'value': instance.value,
    };
