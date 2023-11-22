// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SelectedItemAdapter extends TypeAdapter<SelectedItem> {
  @override
  final int typeId = 3;

  @override
  SelectedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelectedItem(
      itemData: fields[0] as Item,
      count: fields[1] as int,
      price: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SelectedItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.itemData)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BossRecordAdapter extends TypeAdapter<BossRecord> {
  @override
  final int typeId = 4;

  @override
  BossRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BossRecord(
      boss: fields[0] as Boss,
      difficulty: fields[1] as Difficulty,
      date: fields[2] as DateTime,
      itemList: (fields[3] as List).cast<SelectedItem>(),
      partyAmount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BossRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.boss)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.itemList)
      ..writeByte(4)
      ..write(obj.partyAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BossRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
