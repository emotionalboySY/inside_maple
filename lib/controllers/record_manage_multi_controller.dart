import 'dart:collection';

import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_manage_multi_edit_controller.dart';
import 'package:oktoast/oktoast.dart';

import '../constants.dart';
import '../data.dart';
import '../utils/logger.dart';

class RecordManageMultiController extends GetxController {

  RecordManageMultiEditController get recordManageMultiEditController => Get.find<RecordManageMultiEditController>();

  Rx<LoadStatus> recordSetStatus = LoadStatus.empty.obs;

  RxMap<Boss, List<Difficulty>> recordedBossList = <Boss, List<Difficulty>>{}.obs;
  RxMap<Boss, List<Difficulty>> selectedBossList = <Boss, List<Difficulty>>{}.obs;
  RxList<Item> itemList = <Item>[].obs;

  RxBool isParameterSet = false.obs;
  RxList<DateTime?> startDate = <DateTime?>[].obs;
  RxList<DateTime?> endDate = <DateTime?>[].obs;

  void setDataFromRaw(List<BossRecord> loadedData) {
    recordSetStatus.value = LoadStatus.loading;

    Map<Boss, List<Difficulty>> tempRecordedBossList = {};

    for(var record in loadedData) {
      if (!tempRecordedBossList.containsKey(record.boss)) {
        tempRecordedBossList[record.boss] = [record.difficulty];
      } else {
        if (!tempRecordedBossList[record.boss]!.contains(record.difficulty)) {
          tempRecordedBossList[record.boss]!.add(record.difficulty);
          tempRecordedBossList[record.boss]!.sort((a, b) {
            if (Difficulty.values.indexOf(a) > Difficulty.values.indexOf(b)) {
              return 1;
            } else if (Difficulty.values.indexOf(a) < Difficulty.values.indexOf(b)) {
              return -1;
            } else {
              return 0;
            }
          });
        }
      }
    }

    recordedBossList.value = SplayTreeMap<Boss, List<Difficulty>>.from(
      tempRecordedBossList,
          (key1, key2) {
        if (Boss.values.indexOf(key1) > Boss.values.indexOf(key2)) {
          return 1;
        } else if (Boss.values.indexOf(key1) < Boss.values.indexOf(key2)) {
          return -1;
        } else {
          return 0;
        }
      },
    );

    recordSetStatus.value = LoadStatus.success;
  }

  void setSelectedBossList(Boss boss, Difficulty diff, bool checkStatus) {
    if (selectedBossList.containsKey(boss)) {
      if (selectedBossList[boss]!.contains(diff)) {
        selectedBossList[boss]!.remove(diff);
        if (selectedBossList[boss]!.isEmpty) {
          selectedBossList.remove(boss);
        }
      } else {
        selectedBossList[boss]!.add(diff);
      }
    } else {
      selectedBossList[boss] = [diff];
    }
    loggerNoStack.d("boss list update: $selectedBossList, value: $checkStatus");
    selectedBossList.refresh();
    recordedBossList.refresh();
  }

  void setSelectedBossListGrouped(Boss boss, bool checkStatus) {
    int length = recordedBossList[boss]!.length;
    if (checkStatus == false) {
      selectedBossList.remove(boss);
    } else {
      if (!selectedBossList.containsKey(boss)) {
        selectedBossList.addAll({boss: <Difficulty>[]});
      }
      for (int i = 0; i < length; i++) {
        selectedBossList[boss]!.add(recordedBossList[boss]![i]);
      }
    }
    // loggerNoStack.d("selectedBossList after setGroup: $selectedBossList");
    selectedBossList.refresh();
    recordedBossList.refresh();
  }

  void setParamsByPressingPrefix(List<Boss> bossList) {
    for (int i = 0; i < bossList.length; i++) {
      if (recordedBossList.containsKey(bossList[i])) {
        setSelectedBossListGrouped(bossList[i], true);
      }
    }
  }

  void checkIfParameterIsSet() {
    if (selectedBossList.isNotEmpty) {
      isParameterSet.value = true;
    }
  }

  bool? checkStatus(Boss boss) {
    loggerNoStack.d("Check status of $boss");
    if (selectedBossList.containsKey(boss)) {
      if (recordedBossList[boss]!.length == selectedBossList[boss]!.length) {
        return true;
      } else {
        return null;
      }
    } else {
      return false;
    }
  }

  void setStartDate(List<DateTime?> value) {
    if (endDate.isNotEmpty && endDate[0]!.isBefore(value[0]!)) {
      showToast("마지막 날짜보다 뒷 날짜를 첫 날짜로 지정할 수 없습니다.");
    } else {
      startDate.value = value;
    }
    startDate.refresh();
    loggerNoStack.d("startDate changed: $startDate");
  }

  void setEndDate(List<DateTime?> value) {
    if (startDate.isNotEmpty && startDate[0]!.isAfter(value[0]!)) {
      showToast("첫 날짜보다 앞 날짜를 마지막 날짜로 지정할 수 없습니다.");
    } else {
      endDate.value = value;
    }
    endDate.refresh();
    loggerNoStack.d("startDate changed: $endDate");
  }

  void loadItemData() {
    DateTime startDate = this.startDate[0]!;
    DateTime endDate = this.endDate[0]!;
    recordManageMultiEditController.loadBossRecords(selectedBossList, startDate, endDate);
  }

  @override
  void onInit() {
    ever(selectedBossList, (value) {
      checkIfParameterIsSet();
    });
    super.onInit();
  }
}
