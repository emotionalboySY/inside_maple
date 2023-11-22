import 'package:hive/hive.dart';

import 'constants.dart';

part 'data.g.dart';

@HiveType(typeId: 3)
class SelectedItem {

  SelectedItem({
    required this.itemData,
    required this.count,
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
    return "${itemData.korLabel} : $count";
  }
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
}

@HiveType(typeId: 4)
class BossRecord {

    BossRecord({
      required this.boss,
      required this.difficulty,
      required this.date,
      required this.itemList,
    });

    @HiveField(0)
    final Boss boss;
    @HiveField(1)
    final Difficulty difficulty;
    @HiveField(2)
    final DateTime date;
    @HiveField(3)
    final List<SelectedItem> itemList;

    @override
    String toString() {
      return "${boss.korName} $difficulty $date $itemList";
    }
}