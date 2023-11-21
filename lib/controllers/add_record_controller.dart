import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/controllers/record_controller.dart';
import 'package:inside_maple/utils/logger.dart';
import 'package:oktoast/oktoast.dart';

import '../data.dart';

class AddRecordController extends GetxController {
  late RxList<Boss> bossList;
  RxList<Difficulty> diffList = <Difficulty>[].obs;
  RxList<Item> itemList = <Item>[].obs;

  RxDouble itemListLength = 250.0.obs;

  Rx<Boss?> selectedBoss = Rx<Boss?>(null);
  Rx<Difficulty?> selectedDiff = Rx<Difficulty?>(null);
  RxBool showLabel = true.obs;

  RxList<SelectedItem> selectedItemList = <SelectedItem>[].obs;
  Rx<DateTime> selectedDate = DateTime(1900, 01, 01).obs;

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

    for (var itemElement in Item.values) {
      if (itemIndexList.contains(itemElement.index)) {
        itemList.add(itemElement);
      }
    }

    itemList.refresh();
  }

  void addItem(Item item) {
    try {
      SelectedItem selectedItem = selectedItemList.firstWhere((element) => element.itemData == item);
      selectedItem.increaseCount();
    } catch (e) {
      selectedItemList.add(SelectedItem(itemData: item, count: 1));
    }
    selectedItemList.refresh();
  }

  void increaseItem(int index) {
    selectedItemList[index].increaseCount();
    selectedItemList.refresh();
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
    );
    if(date != null) {
      setRaidDate(date);
    }
    else {
      setRaidDate(DateTime(1900, 01, 01));
    }
  }

  void setRaidDate(DateTime date) {
    logger.d(date);
    selectedDate.value = date;
  }

  Future<void> saveRecordData() async {
    saveStatus.value = true;
    try {
      final box = Hive.box('insideMaple');
      List<BossRecord> recordRawList = await box.get('bossRecordData', defaultValue: <BossRecord>[]);
      BossRecord singleRecord = BossRecord(
        boss: selectedBoss.value!,
        difficulty: selectedDiff.value!,
        date: selectedDate.value,
        itemList: selectedItemList,
      );
      logger.d(singleRecord.toString());
      recordRawList.add(singleRecord);
      await box.put('bossRecordData', recordRawList);
      resetSelected();
      showToast("보스 기록이 성공적으로 저장되었습니다.");
    } catch (e) {
      showToast("보스 기록 저장에 실패했습니다. $e");
      logger.e(e);
    }
    saveStatus.value = false;
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

  @override
  void onInit() {
    super.onInit();
    bossList = Boss.getKorListAfterCygnus().obs;
    loggerNoStack.d(bossList);
  }
}
