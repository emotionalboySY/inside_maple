import 'package:json_annotation/json_annotation.dart';

import '../constants.dart';

part 'record_boss.g.dart';

@JsonSerializable(explicitToJson: true)
class RecordBoss {
  int recordBossId;
  int bossDataId;
  Difficulty difficulty;
  DateTime date;
  int memberCount;


  RecordBoss(
      this.recordBossId,
      this.bossDataId,
      this.difficulty,
      this.date,
      this.memberCount,
      );

  factory RecordBoss.fromJson(Map<String, dynamic> json) => _$RecordBossFromJson(json);
  Map<String, dynamic> toJson() => _$RecordBossToJson(this);
}