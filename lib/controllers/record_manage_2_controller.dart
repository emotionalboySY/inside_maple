import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_ui_controller.dart';

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
    if(selectedBossList.containsKey(boss)) {
      if(selectedBossList[boss]!.contains(diff)) {
        selectedBossList[boss]!.remove(diff);
      }
      else {
        selectedBossList[boss]!.add(diff);
      }
    }
    else {
      selectedBossList[boss] = [diff];
    }
    loggerNoStack.d("boss list update: $selectedBossList, value: $checkStatus");
    selectedBossList.refresh();
  }

  void setSelectedBossListGrouped(Boss boss, bool checkStatus) {
    int length = recordUIController.recordedBossList[boss]!.length;
    if(checkStatus == false) {
      selectedBossList.remove(boss);
    } else {
      if(!selectedBossList.containsKey(boss)) {
        selectedBossList.addAll({boss: <Difficulty>[]});
      }
      for(int i = 0; i < length; i++) {
        selectedBossList[boss]!.add(recordUIController.recordedBossList[boss]![i]);
      }
    }
    selectedBossList.refresh();
    recordUIController.recordedBossList.refresh();
  }

  void checkIfParameterIsSet() {
    if(selectedBossList.isNotEmpty) {
      isParameterSet.value = true;
    }
  }

  bool? checkStatus(Boss boss) {
    if(selectedBossList.containsKey(boss)) {
      if(recordUIController.recordedBossList[boss]!.length == selectedBossList[boss]!.length) {
        return true;
      }
      else {
        return null;
      }
    } else {
      return false;
    }
  }

  void setStartDate(List<DateTime?> value) {
    startDate.value = value;
    startDate.refresh();
    loggerNoStack.d("startDate changed: $startDate");
  }

  void setEndDate(List<DateTime?> value) {
    endDate.value = value;
    endDate.refresh();
    loggerNoStack.d("startDate changed: $endDate");
  }
}