// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordItem _$RecordItemFromJson(Map<String, dynamic> json) => RecordItem(
      json['id'] as int,
      json['recordBossId'] as int,
      json['itemId'] as int,
      json['count'] as int,
      json['price'] as int,
      json['duplicable'] as bool,
    );

Map<String, dynamic> _$RecordItemToJson(RecordItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recordBossId': instance.recordBossId,
      'itemId': instance.itemId,
      'count': instance.count,
      'price': instance.price,
      'duplicable': instance.duplicable,
    };
