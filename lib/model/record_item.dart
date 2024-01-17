import 'package:json_annotation/json_annotation.dart';

import '../constants.dart';

part 'record_item.g.dart';

@JsonSerializable(explicitToJson: true)
class RecordItem {
  int recordBossId;
  int recordItemId;
  int itemId;
  int count;
  int price;

  RecordItem(
      this.recordBossId,
      this.recordItemId,
      this.itemId,
      this.count,
      this.price,
      );

  factory RecordItem.fromJson(Map<String, dynamic> json) => _$RecordItemFromJson(json);
  Map<String, dynamic> toJson() => _$RecordItemToJson(this);
}