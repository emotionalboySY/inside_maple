import 'package:get/get.dart';

import '../constants.dart';
import '../utils/logger.dart';

class RecordManage2Controller extends GetxController {

  RxList<MapEntry<Boss, Difficulty>> selectedBossList = <MapEntry<Boss, Difficulty>>[].obs;

  RxBool isParameterSet = false.obs;

  @override
  void onInit() {
    ever(selectedBossList, (value) {
      checkIfParameterIsSet();
    });
    super.onInit();
  }

  void setSelectedBossList(MapEntry<Boss, Difficulty> bossData, bool checkStatus) {
    if(checkStatus) {
      selectedBossList.add(bossData);
    }
    else {
      selectedBossList.remove(bossData);
    }
    loggerNoStack.d("boss list update: $selectedBossList, value: $checkStatus");
  }

  void checkIfParameterIsSet() {
    if(selectedBossList.isNotEmpty) {
      isParameterSet.value = true;
    }
  }
}