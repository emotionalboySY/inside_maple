import 'package:json_annotation/json_annotation.dart';

import '../constants.dart';

part 'boss.g.dart';

@JsonSerializable(explicitToJson: true)
class Boss {
  int id;
  String name;
  List<Difficulty> diffs;

  Boss(this.id, this.name, this.diffs);

  factory Boss.fromJson(Map<String, dynamic> json) => _$BossFromJson(json);

  Map<String, dynamic> toJson() => _$BossToJson(this);
}