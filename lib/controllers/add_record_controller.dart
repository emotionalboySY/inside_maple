import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/utils/logger.dart';

class AddRecordController extends GetxController {
  late RxList<Boss> bossList;
  Rx<Boss?> selectedBoss = Rx<Boss?>(null);
  Rx<Difficulty?> selectedDiff = Rx<Difficulty?>(null);
  RxList<Difficulty> diffList = <Difficulty>[].obs;

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
  }

  @override
  void onInit() {
    super.onInit();
    bossList = Boss.getKorListAfterCygnus().obs;
    loggerNoStack.d(bossList);
  }
}