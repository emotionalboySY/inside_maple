import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/utils/logger.dart';
import 'package:oktoast/oktoast.dart';
import '../../services/boss_add.dart' as boss_service;

import '../data.dart';
import '../model/boss.dart';
import '../model/item.dart';
import '../model/record_item.dart';

class AddRecordController extends GetxController {
  RxList<Boss> bossList = <Boss>[].obs;
  RxList<Difficulty> diffList = <Difficulty>[].obs;
  RxList<Item> itemList = <Item>[].obs;

  RxDouble itemListLength = 250.0.obs;

  Rx<Boss?> selectedBoss = Rx<Boss?>(null);
  Rx<Difficulty?> selectedDiff = Rx<Difficulty?>(null);
  RxBool showLabel = true.obs;

  RxList<RecordItem> selectedItemList = <RecordItem>[].obs;
  Rx<DateTime> selectedDate = DateTime(1900, 01, 01).obs;
  RxInt selectedPartyAmount = 1.obs;

  RxBool saveStatus = false.obs;

  void loadDifficulty() {
    selectedDiff.value = null;
    diffList.clear();

    diffList.addAll(selectedBoss.value!.diffs);

    diffList.refresh();
  }

  void selectBoss(Boss selectValue) {
    selectedBoss.value = selectValue;
    resetSelectedData();
    loadDifficulty();
  }

  void selectDiff(Difficulty diff) {
    selectedDiff.value = diff;
    resetSelectedData();
    loadItemList();
  }

  Future<void> loadItemList() async {
    itemList.clear();

    List<Item>? loadedItemList = await boss_service.getItemList(selectedBoss.value!.id, selectedDiff.value!);

    if(loadedItemList == null) {
      showToast("아이템 목록을 불러오는 데 실패했습니다.");
      return;
    }

    itemList.addAll(loadedItemList);

    itemList.refresh();

  }

  void toggleShowLabel() {
    showLabel.value = !showLabel.value;
    if (showLabel.value == true) {
      itemListLength.value = 250.0;
    } else {
      itemListLength.value = 40.0;
    }
  }

  String getImagePathByIndex(int index) {
    return itemList.firstWhere((element) => element.id == selectedItemList[index - 1].itemId).path;
  }

  String getItemNameByIndex(int index) {
    return itemList.firstWhere((element) => element.id == selectedItemList[index - 1].itemId).name;
  }

  void addItem(Item item) {
    loggerNoStack.d(item.id);
    try {
      RecordItem selectedItem = selectedItemList.firstWhere((element) => element.itemId == item.id);
      loggerNoStack.d(selectedItem.duplicable);
      if(selectedItem.duplicable) {
        selectedItemList.firstWhere((element) => element.itemId == selectedItem.itemId).increaseCount();
      }
      else {
        showToast("선택한 아이템은 한 개만 드롭됩니다.");
      }
    } catch (e) {
      logger. e(e);
      selectedItemList.add(RecordItem(-1, -1, item.id, 1, 0, item.duplicable));
    }
    selectedItemList.refresh();
  }

  void increaseItem(int index) {
    if(selectedItemList[index].duplicable) {
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

  void resetSelectedData() {
    selectedItemList.clear();
    selectedDate.value = DateTime(1900, 01, 01);
    selectedPartyAmount.value = 1;
  }

  Future<void> saveRecordData() async {
    final isDuplicated = await boss_service.checkIsDuplicatedRecord(selectedBoss.value!.id, selectedDiff.value!, selectedDate.value);
    if(isDuplicated == null) {
      showToast("보스 리워드 중복 기록 확인에 실패하였습니다. 관리자에게 문의하세요.");
    } else if(isDuplicated == true) {
      showToast("이미 저장된 기록입니다. 다른 보스 및 난이도를 선택해 주세요.");
    } else {
      final result = await boss_service.addBossRecord(selectedBoss.value!.id, selectedDiff.value!, selectedPartyAmount.value, selectedDate.value, selectedItemList);
      if(result == null) {
        showToast("보스 기록 저장에 실패하였습니다. 관리자에게 문의하세요.");
      } else if(result == false) {
        showToast("보스 기록 저장에 실패했습니다. 관리자에게 문의하세요.");
      } else {
        resetAll();
        showToast("보스 기록이 성공적으로 저장되었습니다.");
      }
    }
  }

  void sortItemList() {
    selectedItemList.sort((a, b) {
      final aa = itemList.firstWhere((element) => element.id == a.id).name;
      final bb = itemList.firstWhere((element) => element.id == b.id).name;
      if(aa.compareTo(bb) < 0) {
        return -1;
      } else if(aa.compareTo(bb) > 0) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  void resetAll() {
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
    bool isBeforeThursday = false;

    DateTime firstDayOfMonth = DateTime(date.year, date.month);
    int daysToAdd = (4 - firstDayOfMonth.weekday) % 7;
    DateTime firstThursday = firstDayOfMonth.add(Duration(days: daysToAdd));

    if (date.isBefore(firstThursday)) {
      isBeforeThursday = true;
      loggerNoStack.d("date is before firstThursday: $date < $firstThursday");
      firstDayOfMonth = DateTime(date.year, date.month - 1);
      daysToAdd = (4 - firstDayOfMonth.weekday) % 7;
      firstThursday = firstDayOfMonth.add(Duration(days: daysToAdd));
    }

    loggerNoStack.d("firstThursday: $firstThursday");

    int differenceInDays = date.difference(firstThursday).inDays;
    int weekNum = (differenceInDays / 7).floor() + 1;
    DateTime startDateOfWeek = firstThursday.add(Duration(days: (7 * (weekNum - 1))));
    DateTime endDateOfWeek = startDateOfWeek.add(const Duration(days: 6));
    if(isBeforeThursday) {
      date = DateTime(date.year, date.month - 1);
    }

    loggerNoStack.d("WeekType\n"
        "year: ${date.year}\n"
        "month: ${date.month}\n"
        "weekNum: $weekNum\n"
        "startDate: $startDateOfWeek\n"
        "endDate: $endDateOfWeek\n");

    return WeekType(
      year: date.year,
      month: date.month,
      weekNum: weekNum,
      startDate: startDateOfWeek,
      endDate: endDateOfWeek,
    );
  }

  Future<void> loadBossList() async {
    try {
      final bossListLoaded = await boss_service.getBossList();
      if(bossListLoaded == null) {
        showToast("보스 몬스터 정보를 불러오는 데 실패했습니다.");
        return;
      }
      bossList.value = bossListLoaded;
      bossList.refresh();
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await loadBossList();
  }
}
