import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/utils/logger.dart';

class RecordController extends GetxController {
  late RxList<Boss> bossList;
  Rx<Boss?> selectedBoss = Rx<Boss?>(null);
  var diffList = [].obs;

  void loadDifficulty() {
    diffList.clear();
    var diffTable = selectedBoss.value!.diffIndex;
    int diffNum = int.parse(diffTable);

    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add("이지");
    }
    diffNum = (diffNum / 10).floor();
    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add("노멀");
    }
    diffNum = (diffNum / 10).floor();
    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add("카오스");
    }
    diffNum = (diffNum / 10).floor();
    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add("하드");
    }
    diffNum = (diffNum / 10).floor();
    if(diffNum != 0 && diffNum % 2 == 1) {
      diffList.add("익스트림");
    }

    diffList.refresh();
  }

  void selectBoss(Boss selectValue) {
    selectedBoss.value = selectValue;
    loadDifficulty();
  }

  @override
  void onInit() {
    super.onInit();
    bossList = Boss.getKorList().obs;
    loggerNoStack.d(bossList);
  }
}