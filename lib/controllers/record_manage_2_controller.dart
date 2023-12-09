import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_ui_controller.dart';
import 'package:oktoast/oktoast.dart';

import '../constants.dart';
import '../utils/logger.dart';

class RecordManage2Controller extends GetxController {
  final recordUIController = Get.find<RecordUIController>();

  RxMap<Boss, List<Difficulty>> selectedBossList = <Boss, List<Difficulty>>{}.obs;

  RxBool isParameterSet = false.obs;
  RxList<DateTime?> startDate = <DateTime?>[].obs;
  RxList<DateTime?> endDate = <DateTime?>[].obs;

  @override
  void onInit() {
    ever(selectedBossList, (value) {
      checkIfParameterIsSet();
    });
    super.onInit();
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
    recordUIController.recordedBossList.refresh();
  }

  void setSelectedBossListGrouped(Boss boss, bool checkStatus) {
    int length = recordUIController.recordedBossList[boss]!.length;
    if (checkStatus == false) {
      selectedBossList.remove(boss);
    } else {
      if (!selectedBossList.containsKey(boss)) {
        selectedBossList.addAll({boss: <Difficulty>[]});
      }
      for (int i = 0; i < length; i++) {
        selectedBossList[boss]!.add(recordUIController.recordedBossList[boss]![i]);
      }
    }
    // loggerNoStack.d("selectedBossList after setGroup: $selectedBossList");
    selectedBossList.refresh();
    recordUIController.recordedBossList.refresh();
  }

  void setParamsByPressingPrefix(List<Boss> bossList) {
    for (int i = 0; i < bossList.length; i++) {
      if (recordUIController.recordedBossList.containsKey(bossList[i])) {
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
      if (recordUIController.recordedBossList[boss]!.length == selectedBossList[boss]!.length) {
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
}
