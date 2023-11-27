import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/utils/logger.dart';
import 'package:oktoast/oktoast.dart';

import '../data.dart';

class AddRecordController extends GetxController {
  late RxList<Boss> bossList;
  RxList<Difficulty> diffList = <Difficulty>[].obs;
  RxList<ItemData> itemList = <ItemData>[].obs;

  RxDouble itemListLength = 250.0.obs;

  Rx<Boss?> selectedBoss = Rx<Boss?>(null);
  Rx<Difficulty?> selectedDiff = Rx<Difficulty?>(null);
  RxBool showLabel = true.obs;

  RxList<Item> selectedItemList = <Item>[].obs;
  Rx<DateTime> selectedDate = DateTime(1900, 01, 01).obs;
  RxInt selectedPartyAmount = 1.obs;

  RxBool saveStatus = false.obs;

  void loadDifficulty() {
    selectedDiff.value = null;
    diffList.clear();
    var diffTable = selectedBoss.value!.diffIndex;
    int diffNum = int.parse(diffTable);

    if (diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.easy);
    }
    diffNum = (diffNum / 10).floor();
    if (diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.normal);
    }
    diffNum = (diffNum / 10).floor();
    if (diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.chaos);
    }
    diffNum = (diffNum / 10).floor();
    if (diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.hard);
    }
    diffNum = (diffNum / 10).floor();
    if (diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.extreme);
    }

    diffList.refresh();
  }

  void selectBoss(Boss selectValue) {
    selectedBoss.value = selectValue;
    loadDifficulty();
  }

  void selectDiff(Difficulty diff) {
    selectedDiff.value = diff;
    loadItemList();
  }

  void toggleShowLabel() {
    showLabel.value = !showLabel.value;
    if (showLabel.value == true) {
      itemListLength.value = 250.0;
    } else {
      itemListLength.value = 40.0;
    }
  }

  void loadItemList() {
    itemList.clear();
    String bossName = describeEnum(selectedBoss);
    String diffName = selectedDiff.value!.engName;

    var itemIndexList = dropData[bossName]![diffName]!;

    for (var itemElement in ItemData.values) {
      if (itemIndexList.contains(itemElement.index)) {
        itemList.add(itemElement);
      }
    }

    itemList.refresh();
  }

  void addItem(ItemData item) {
    try {
      Item selectedItem = selectedItemList.firstWhere((element) => element.item == item);
      if(itemCanDuplicated.contains(selectedItem.item)) {
        selectedItem.increaseCount();
      }
      else {
        showToast("선택한 아이템은 한 개만 드롭됩니다.");
      }
    } catch (e) {
      selectedItemList.add(Item(item: item, count: 1.obs, price: 0.obs));
    }
    selectedItemList.refresh();
  }

  void increaseItem(int index) {
    if(itemCanDuplicated.contains(selectedItemList[index].item)) {
      selectedItemList[index].increaseCount();
      selectedItemList.refresh();
    }
    else {
      showToast("선택한 아이템은 한 개만 드롭됩니다.");
    }
  }

  void decreaseItem(int index) {
    selectedItemList[index].decreaseCount();
    selectedItemList.refresh();
  }

  void removeItem(int index) {
    selectedItemList.removeAt(index);
    selectedItemList.refresh();
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if(date != null) {
      setRaidDate(date);
    }
    else {
      setRaidDate(DateTime(1900, 01, 01));
    }
  }

  void setRaidDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> saveRecordData() async {
    saveStatus.value = true;
    try {
      final box = await Hive.openBox("insideMaple");
      List<BossRecord> recordRawList = await box.get('bossRecordData', defaultValue: <BossRecord>[]).cast<BossRecord>();
      WeekType? weekType = getWeekType(selectedDate.value);
      BossRecord singleRecord = BossRecord(
        boss: selectedBoss.value!,
        difficulty: selectedDiff.value!,
        date: selectedDate.value,
        itemList: selectedItemList,
        partyAmount: selectedPartyAmount.value,
        weekType: weekType!,
      );
      if(checkDuplicatedRecord(recordRawList, singleRecord)) {
        showToast("이미 저장된 기록입니다.");
        saveStatus.value = false;
        return;
      }
      recordRawList.add(singleRecord);
      await box.put('bossRecordData', recordRawList);
      resetSelected();
      box.close();
      showToast("보스 기록이 성공적으로 저장되었습니다.");
    } catch (e) {
      showToast("보스 기록 저장에 실패했습니다. $e");
      logger.e(e);
    }
    saveStatus.value = false;
  }

  bool checkDuplicatedRecord(List<BossRecord> recordRawList, BossRecord recordToSave) {
    bool isDuplicated = false;
    for(var record in recordRawList) {
      if(record.boss == recordToSave.boss && record.difficulty == recordToSave.difficulty && record.date == recordToSave.date) {
        isDuplicated = true;
        break;
      }
    }
    return isDuplicated;
  }

  void resetSelected() {
    selectedBoss.value = null;
    selectedDiff.value = null;
    selectedItemList.clear();
    selectedItemList.refresh();
    itemList.clear();
    itemList.refresh();
    selectedDate.value = DateTime(1900, 01, 01);
  }

  WeekType getWeekType(DateTime rawDate) {
    DateTime date = rawDate;

    DateTime firstDayOfMonth = DateTime(date.year, date.month);
    int daysToAdd = (4 - firstDayOfMonth.weekday) % 7;
    DateTime firstThursday = firstDayOfMonth.add(Duration(days: daysToAdd));

    if (date.isBefore(firstThursday)) {
      firstDayOfMonth = DateTime(date.year, date.month - 1);
      int daysToAdd = (4 - firstDayOfMonth.weekday) % 7;
      firstThursday = firstDayOfMonth.add(Duration(days: daysToAdd));
    }

    int differenceInDays = date.difference(firstThursday).inDays;
    int weekNum = (differenceInDays / 7).floor() + 1;
    DateTime startDateOfWeek = firstThursday.add(Duration(days: (7 * (weekNum - 1))));
    DateTime endDateOfWeek = startDateOfWeek.add(const Duration(days: 6));

    return WeekType(
      year: date.year,
      month: date.month,
      weekNum: weekNum,
      startDate: startDateOfWeek,
      endDate: endDateOfWeek,
    );
  }

  @override
  void onInit() {
    super.onInit();
    bossList = Boss.getKorListAfterCygnus().obs;
  }
}
