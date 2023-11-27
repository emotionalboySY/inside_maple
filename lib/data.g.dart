// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 3;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      item: fields[0] as ItemData,
      count: fields[1] as RxInt,
      price: fields[2] as RxInt,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.item)
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
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeekTypeAdapter extends TypeAdapter<WeekType> {
  @override
  final int typeId = 5;

  @override
  WeekType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeekType(
      year: fields[0] as int,
      month: fields[1] as int,
      weekNum: fields[2] as int,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WeekType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.weekNum)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekTypeAdapter &&
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
      itemList: (fields[3] as List).cast<Item>().obs,
      partyAmount: fields[4] as int,
      weekType: fields[5] as WeekType,
    );
  }

  @override
  void write(BinaryWriter writer, BossRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.boss)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.itemList)
      ..writeByte(4)
      ..write(obj.partyAmount)
      ..writeByte(5)
      ..write(obj.weekType);
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

class RxIntAdapter extends TypeAdapter<RxInt> {
  @override
  final int typeId = 6;

  @override
  RxInt read(BinaryReader reader) {
    return RxInt(reader.readInt());
  }

  @override
  void write(BinaryWriter writer, RxInt obj) {
    writer.writeInt(obj.value);
  }
}

class RxListAdapter extends TypeAdapter<RxList> {

  @override
  final int typeId = 7;

  @override
  void write(BinaryWriter writer, RxList obj) {
    writer.writeList(obj);
  }

  @override
  RxList read(BinaryReader reader) {
    return RxList(reader.readList());
  }
}
