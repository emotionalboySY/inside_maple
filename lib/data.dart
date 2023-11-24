import 'package:hive/hive.dart';
import 'package:inside_maple/utils/logger.dart';

import 'constants.dart';

part 'data.g.dart';

@HiveType(typeId: 3)
class SelectedItem {

  SelectedItem({
    required this.itemData,
    required this.count,
    this.price = 0,
});

  @HiveField(0)
  final Item itemData;
  @HiveField(1)
  int count;
  @HiveField(2)
  int price = 0;

  void increaseCount() {
    count++;
  }

  void decreaseCount() {
    if(count > 1) {
      count--;
    }
  }

  void setPrice(int price) {
    this.price = price;
  }

  @override
  String toString() {
    return "${itemData.korLabel} : $count, $price메소";
  }

  SelectedItem.clone(SelectedItem item) :
    itemData = item.itemData,
    count = item.count,
    price = item.price;
}

class WeekType {

  WeekType({
    required this.year,
    required this.month,
    required this.weekNum,
    required this.startDate,
    required this.endDate,
  });

  final int year;
  final int month;
  final int weekNum;
  final DateTime startDate;
  final DateTime endDate;

  @override
  String toString() {
    return "$year년 $month월 $weekNum주차";
  }

  String getPeriodKorString() {
    return "${startDate.month}/${startDate.day} ~ ${endDate.month}/${endDate.day}";
  }

  @override
  bool operator ==(Object other) {
    if(other is WeekType) {
      return year == other.year && month == other.month && weekNum == other.weekNum;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

  WeekType.clone(WeekType weekType) :
    year = weekType.year,
    month = weekType.month,
    weekNum = weekType.weekNum,
    startDate = weekType.startDate,
    endDate = weekType.endDate;
}

@HiveType(typeId: 4)
class BossRecord {

    BossRecord({
      required this.boss,
      required this.difficulty,
      required this.date,
      required this.itemList,
      required this.partyAmount,
    });

    @HiveField(0)
    final Boss boss;
    @HiveField(1)
    final Difficulty difficulty;
    @HiveField(2)
    final DateTime date;
    @HiveField(3)
    final List<SelectedItem> itemList;
    @HiveField(4)
    final int partyAmount;

    @override
    String toString() {
      return "${boss.korName}($difficulty) | date: $date | itemList: $itemList | 파티원 수: $partyAmount";
    }

    BossRecord.clone(BossRecord record) :
      boss = record.boss,
      difficulty = record.difficulty,
      date = record.date,
      itemList = record.itemList.map((item) => SelectedItem.clone(item)).toList(),
      partyAmount = record.partyAmount;
}