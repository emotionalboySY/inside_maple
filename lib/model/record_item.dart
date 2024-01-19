import 'package:json_annotation/json_annotation.dart';

part 'record_item.g.dart';

@JsonSerializable(explicitToJson: true)
class RecordItem {
  int id;
  int recordBossId;
  int itemId;
  int count;
  int price;
  bool duplicable;

  RecordItem(
      this.id,
      this.recordBossId,
      this.itemId,
      this.count,
      this.price,
      this.duplicable,
      );

  factory RecordItem.fromJson(Map<String, dynamic> json) => _$RecordItemFromJson(json);
  Map<String, dynamic> toJson() => _$RecordItemToJson(this);

  void increaseCount() {
    count++;
  }

  void decreaseCount() {
    count--;
  }
}