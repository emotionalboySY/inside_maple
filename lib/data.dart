import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inside_maple/utils/logger.dart';

import 'constants.dart';

part 'data.g.dart';

@HiveType(typeId: 3)
class Item {
  Item({
    required this.item,
    required this.count,
    required this.price,
  });

  @HiveField(0)
  final ItemData item;
  @HiveField(1)
  RxInt count;
  @HiveField(2)
  RxInt price;

  void increaseCount() {
    count.value++;
  }

  void decreaseCount() {
    if (count.value > 1) {
      count.value--;
    }
  }

  void setPrice(int price) {
    this.price.value = price;
  }

  @override
  String toString() {
    return "${item.korLabel} : $count, $price메소";
  }

  Item.clone(Item item)
      : item = item.item,
        count = item.count.value.obs,
        price = item.price.value.obs;

  @override
  bool operator ==(Object other) {
    if (other is Item) {
      return item == other.item && count == other.count && price == other.price;
    }
    return false;
  }

  @override
  int get hashCode {
    return Object.hash(item, count.value, price.value);
  }

}

@HiveType(typeId: 5)
class WeekType {
  WeekType({
    required this.year,
    required this.month,
    required this.weekNum,
    required this.startDate,
    required this.endDate,
  });

  @HiveField(0)
  final int year;
  @HiveField(1)
  final int month;
  @HiveField(2)
  final int weekNum;
  @HiveField(3)
  final DateTime startDate;
  @HiveField(4)
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
    if (other is WeekType) {
      return year == other.year && month == other.month && weekNum == other.weekNum;
    }
    return false;
  }

  @override
  int get hashCode {
    return Object.hash(year, month, weekNum);
  }

  WeekType.clone(WeekType weekType)
      : year = weekType.year,
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
    required this.weekType,
  });

  @HiveField(0)
  Boss boss;
  @HiveField(1)
  Difficulty difficulty;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  RxList<Item> itemList;
  @HiveField(4)
  int partyAmount;
  @HiveField(5)
  WeekType weekType;

  @override
  String toString() {
    return "<BossRecord instance>\n"
        "boss: $boss\n"
        "difficulty: $difficulty\n"
        "date: $date\n"
        "itemList: ${itemList.value}\n"
        "partyAmount: $partyAmount\n"
        "weekType: $weekType\n";
  }

  void update({
    Boss? boss,
    Difficulty? difficulty,
    DateTime? date,
    List<Item>? itemList,
    int? partyAmount,
    WeekType? weekType,
}) {
    if(boss != null) {
      this.boss = boss;
    }
    if(difficulty != null) {
      this.difficulty = difficulty;
    }
    if(date != null) {
      this.date = date;
    }
    if(itemList != null) {
      this.itemList.clear();
      this.itemList.addAll(itemList);
    }
    if(partyAmount != null) {
      this.partyAmount = partyAmount;
    }
    if(weekType != null) {
      this.weekType = weekType;
    }
  }

  BossRecord.clone(BossRecord record)
      : boss = record.boss,
        difficulty = record.difficulty,
        date = record.date,
        itemList = record.itemList.map((item) => Item.clone(item)).toList().obs,
        partyAmount = record.partyAmount,
        weekType = record.weekType;

  @override
  bool operator ==(Object other) {
    if (other is BossRecord) {
      if(other.boss == boss && other.difficulty == difficulty && other.date == date && other.partyAmount == partyAmount) {
        if(other.itemList.length == itemList.length) {
          for(int i = 0; i < itemList.length; i++) {
            if(other.itemList[i] != itemList[i]) {
              loggerNoStack.d("Difference detected: ${other.itemList[i]}\n and ${itemList[i]}");
              loggerNoStack.d("${other.itemList[i].item == itemList[i].item}");
              loggerNoStack.d("${other.itemList[i].count == itemList[i].count}");
              loggerNoStack.d("${other.itemList[i].price == itemList[i].price}");
              return false;
            }
          }
          return true;
        }
      }
    }
    return false;
  }

  @override
  int get hashCode {
    return Object.hash(boss, difficulty, date, itemList, partyAmount, weekType);
  }

}