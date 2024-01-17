// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Boss _$BossFromJson(Map<String, dynamic> json) => Boss(
      json['id'] as int,
      json['name'] as String,
      (json['diffs'] as List<dynamic>)
          .map((e) => $enumDecode(_$DifficultyEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$BossToJson(Boss instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'diffs': instance.diffs.map((e) => _$DifficultyEnumMap[e]!).toList(),
    };

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.normal: 'normal',
  Difficulty.chaos: 'chaos',
  Difficulty.hard: 'hard',
  Difficulty.extreme: 'extreme',
};
