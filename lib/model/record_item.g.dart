// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordItem _$RecordItemFromJson(Map<String, dynamic> json) => RecordItem(
      json['recordBossId'] as int,
      json['recordItemId'] as int,
      json['itemId'] as int,
      json['count'] as int,
      json['price'] as int,
    );

Map<String, dynamic> _$RecordItemToJson(RecordItem instance) =>
    <String, dynamic>{
      'recordBossId': instance.recordBossId,
      'recordItemId': instance.recordItemId,
      'itemId': instance.itemId,
      'count': instance.count,
      'price': instance.price,
    };
