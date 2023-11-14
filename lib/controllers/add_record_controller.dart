import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/utils/logger.dart';

class AddRecordController extends GetxController {
  late RxList<Boss> bossList;
  RxList<Difficulty> diffList = <Difficulty>[].obs;
  RxList<Item> itemList = <Item>[].obs;

  RxDouble itemListLength = 250.0.obs;

  Rx<Boss?> selectedBoss = Rx<Boss?>(null);
  Rx<Difficulty?> selectedDiff = Rx<Difficulty?>(null);
  RxBool showLabel = true.obs;

  void loadDifficulty() {
    selectedDiff.value = null;
    diffList.clear();
    var diffTable = selectedBoss.value!.diffIndex;
    int diffNum = int.parse(diffTable);

    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.easy);
    }
    diffNum = (diffNum / 10).floor();
    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.normal);
    }
    diffNum = (diffNum / 10).floor();
    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.chaos);
    }
    diffNum = (diffNum / 10).floor();
    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add(Difficulty.hard);
    }
    diffNum = (diffNum / 10).floor();
    if(diffNum != 0 && diffNum % 2 == 1) {
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
    if(showLabel.value == true) {
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

    for(var itemElement in Item.values) {
      if(itemIndexList.contains(itemElement.index)) {
        itemList.add(itemElement);
      }
    }

    itemList.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    bossList = Boss.getKorListAfterCygnus().obs;
    loggerNoStack.d(bossList);
  }
}