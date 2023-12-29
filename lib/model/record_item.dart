import 'package:json_annotation/json_annotation.dart';

import '../constants.dart';

part 'record_item.g.dart';

@JsonSerializable(explicitToJson: true)
class RecordItem {
  int recordItemId;
  int recordBossId;
  ItemData itemData;
  int count;
  int price;

  RecordItem(
      this.recordItemId,
      this.recordBossId,
      this.itemData,
      this.count,
      this.price,
      );

  factory RecordItem.fromJson(Map<String, dynamic> json) => _$RecordItemFromJson(json);
  Map<String, dynamic> toJson() => _$RecordItemToJson(this);
}