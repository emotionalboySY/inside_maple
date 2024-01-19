// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_boss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordBoss _$RecordBossFromJson(Map<String, dynamic> json) => RecordBoss(
      json['recordBossId'] as int,
      json['bossDataId'] as int,
      $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      DateTime.parse(json['date'] as String),
      json['memberCount'] as int,
    );

Map<String, dynamic> _$RecordBossToJson(RecordBoss instance) =>
    <String, dynamic>{
      'recordBossId': instance.id,
      'bossDataId': instance.bossDataId,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'date': instance.date.toIso8601String(),
      'memberCount': instance.memberCount,
    };

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.normal: 'normal',
  Difficulty.chaos: 'chaos',
  Difficulty.hard: 'hard',
  Difficulty.extreme: 'extreme',
};
