// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordItem _$RecordItemFromJson(Map<String, dynamic> json) => RecordItem(
      json['recordItemId'] as int,
      json['recordBossId'] as int,
      $enumDecode(_$ItemDataEnumMap, json['itemData']),
      json['count'] as int,
      json['price'] as int,
    );

Map<String, dynamic> _$RecordItemToJson(RecordItem instance) =>
    <String, dynamic>{
      'recordItemId': instance.recordItemId,
      'recordBossId': instance.recordBossId,
      'itemData': _$ItemDataEnumMap[instance.itemData]!,
      'count': instance.count,
      'price': instance.price,
    };

const _$ItemDataEnumMap = {
  ItemData.item1: 'item1',
  ItemData.item2: 'item2',
  ItemData.item3: 'item3',
  ItemData.item4: 'item4',
  ItemData.item5: 'item5',
  ItemData.item6: 'item6',
  ItemData.item7: 'item7',
  ItemData.item8: 'item8',
  ItemData.item9: 'item9',
  ItemData.item10: 'item10',
  ItemData.item11: 'item11',
  ItemData.item12: 'item12',
  ItemData.item13: 'item13',
  ItemData.item14: 'item14',
  ItemData.item15: 'item15',
  ItemData.item16: 'item16',
  ItemData.item17: 'item17',
  ItemData.item18: 'item18',
  ItemData.item19: 'item19',
  ItemData.item20: 'item20',
  ItemData.item21: 'item21',
  ItemData.item22: 'item22',
  ItemData.item23: 'item23',
  ItemData.item24: 'item24',
  ItemData.item25: 'item25',
  ItemData.item26: 'item26',
  ItemData.item27: 'item27',
  ItemData.item28: 'item28',
  ItemData.item29: 'item29',
  ItemData.item30: 'item30',
  ItemData.item31: 'item31',
  ItemData.item32: 'item32',
  ItemData.item33: 'item33',
  ItemData.item34: 'item34',
  ItemData.item35: 'item35',
  ItemData.item36: 'item36',
  ItemData.item37: 'item37',
  ItemData.item38: 'item38',
  ItemData.item39: 'item39',
  ItemData.item40: 'item40',
  ItemData.item41: 'item41',
  ItemData.item42: 'item42',
  ItemData.item43: 'item43',
  ItemData.item44: 'item44',
  ItemData.item45: 'item45',
  ItemData.item46: 'item46',
  ItemData.item47: 'item47',
  ItemData.item48: 'item48',
  ItemData.item49: 'item49',
  ItemData.item50: 'item50',
};
