import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_manage_data_controller.dart';
import 'package:inside_maple/controllers/record_manage_single_edit_controller.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

import '../constants.dart';
import '../data.dart';
import '../utils/logger.dart';

class RecordManageSingleController extends GetxController {
  final f = NumberFormat("#,##0");

  RecordManageSingleEditController get recordManageSingleEditController => Get.find<RecordManageSingleEditController>();
  RecordManageDataController get recordManageDataController => Get.find<RecordManageDataController>();

  List<FocusNode> itemFocusNodes = [];
  List<TextEditingController> itemPriceControllers = [];

  Rx<LoadStatus> recordLoadStatus = LoadStatus.empty.obs;
  Rx<LoadStatus> recordSetStatus = LoadStatus.empty.obs;

  RxBool isRecordEditMode = false.obs;
  RxBool isRecordEdited = false.obs;

  RxList<BossRecord> recordListExactWeekType = <BossRecord>[].obs;
  RxList<WeekType> weekTypeList = <WeekType>[].obs;

  Rx<WeekType?> selectedWeekType = Rx<WeekType?>(null);
  Rx<BossRecord?> selectedRecordData = Rx<BossRecord?>(null);
  RxInt totalItemPrice = 0.obs;
  RxInt totalItemPriceAfterDivision = 0.obs;
  RxString totalItemPriceLocale = "".obs;
  RxString totalItemPriceAfterDivisionLocale = "".obs;
  RxBool isMvpSilver = false.obs;

  void setDataFromRaw(List<BossRecord> loadedData) {
    recordSetStatus.value = LoadStatus.loading;

    for(var record in loadedData) {
      if (!weekTypeList.contains(record.weekType)) {
        weekTypeList.add(record.weekType);
      }
    }

    weekTypeList.sort((a, b) => a.startDate.compareTo(b.startDate));
    weekTypeList.refresh();

    recordLoadStatus.value = LoadStatus.success;
  }

  void selectWeekType(int index) {
    selectedWeekType.value = weekTypeList[index];
    recordListExactWeekType.clear();
    for (var record in recordManageDataController.loadedBossRecords) {
      if (record.weekType == selectedWeekType.value) {
        recordListExactWeekType.add(BossRecord.clone(record));
      }
    }
    recordListExactWeekType.sort((a, b) {
      if (Boss.values.indexWhere((element) => element == a.boss) > Boss.values.indexWhere((element) => element == b.boss)) {
        return 1;
      } else if (Boss.values.indexWhere((element) => element == a.boss) < Boss.values.indexWhere((element) => element == b.boss)) {
        return -1;
      } else {
        return 0;
      }
    });
    selectedRecordData.value = null;
    recordManageSingleEditController.resetSelectedData();
    isRecordEditMode.value = false;
    isRecordEdited.value = false;
    weekTypeList.refresh();
    recordListExactWeekType.refresh();
  }

  Future<void> selectRecord(int index) async {
    bool selectConfirmed = false;
    if (isRecordEditMode.value == true && isRecordEdited.value == true) {
      await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          title: const Text("다른 기록 보기 전 확인사항"),
          content: const Text("수정 중인 기록이 있습니다.\n다른 기록을 보시겠습니까?\n\n(저장하지 않는 경우 수정 기록은 초기화됩니다.)\n(\"취소\"를 누르면 계속 수정할 수 있습니다."),
          actions: [
            TextButton(
              onPressed: () {
                selectConfirmed = false;
                Get.back();
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                selectConfirmed = true;
                Get.back();
              },
              child: const Text("저장하지 않고 넘어가기"),
            ),
            TextButton(
              onPressed: () {
                selectConfirmed = true;
                Get.back();
              },
              child: const Text("저장하고 넘어가기"),
            ),
          ],
        ),
      );
    }
    if (recordManageSingleEditController.selectedRecordData.value == null || selectConfirmed == true || isRecordEdited.value == false) {
      // loggerNoStack.d("selectConfirmed: true so move selection");
      selectedRecordData.value = recordListExactWeekType[index];
      // selectedRecordDataOriginal.value = recordListExactWeekType[selectedRecordIndex.value];
      recordManageSingleEditController.setRecordData(BossRecord.clone(selectedRecordData.value!));
      initializeFocusNodesAndControllers();
      // loggerNoStack.d("all record data: $recordListLoaded");
      // loggerNoStack.d("selectedRecordData: $selectedRecordData");
      recordListExactWeekType.refresh();
      isRecordEditMode.value = false;
      isRecordEdited.value = false;
      resetTotalPriceLocale();
      calculateTotalPrices();
    }
  }

  void initializeFocusNodesAndControllers() {
    disposeFocusNodes();
    disposeControllers();
    for (int i = 0; i < recordManageSingleEditController.selectedRecordData.value!.itemList.length; i++) {
      itemFocusNodes.add(FocusNode());
      itemPriceControllers.add(TextEditingController());

      itemFocusNodes[i].addListener(() {
        if (!itemFocusNodes[i].hasFocus) {
          recordManageSingleEditController.applyPrice(i);
        }
        if (itemFocusNodes[i].hasFocus) {
          itemPriceControllers[i].selection = TextSelection(baseOffset: 0, extentOffset: itemPriceControllers[i].text.length);
        }
      });
      itemPriceControllers[i].text = recordManageSingleEditController.selectedRecordData.value!.itemList[i].price.value.toString();
    }
  }

  void toggleEditMode() {
    isRecordEditMode.value = !isRecordEditMode.value;
  }

  void toggleMVP() {
    isMvpSilver.value = !isMvpSilver.value;
    if (recordManageSingleEditController.selectedRecordData.value != null) {
      calculateTotalPrices();
    }
  }

  void calculateTotalPrices() {
    int total = 0;
    for (var item in recordManageSingleEditController.selectedRecordData.value!.itemList) {
      total += ((item.price * item.count.value) * (isMvpSilver.value ? 0.97 : 0.95)).round();
    }
    totalItemPrice.value = total;
    totalItemPriceLocale.value = f.format(total);
    totalItemPriceAfterDivision.value = (total / recordManageSingleEditController.selectedRecordData.value!.partyAmount.value).round();
    totalItemPriceAfterDivisionLocale.value = f.format(totalItemPriceAfterDivision.value);

    // loggerNoStack.d("calculated totalItemPrice: $totalItemPrice");
    // loggerNoStack.d("calculated totalItemPriceAfterDivision: $totalItemPriceAfterDivision");
  }

  void updateIsRecordEdited() {
    if (isRecordEditMode.value) {
      loggerNoStack.d("selected record data: ${selectedRecordData.value}");
      loggerNoStack.d("Changed record data: ${recordManageSingleEditController.selectedRecordData.value}");
      if (selectedRecordData.value == recordManageSingleEditController.selectedRecordData.value) {
        loggerNoStack.d("selected record data and changed record data are same");
        isRecordEdited.value = false;
      } else {
        loggerNoStack.d("selected record data and changed record data are not same");
        isRecordEdited.value = true;
      }
    }
  }

  Future<void> resetSelections() async {
    bool? isResetConfirmed;
    if (isRecordEditMode.value) {
      await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          insetPadding: EdgeInsets.zero,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          title: const Text("선택지 초기화 알림"),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "수정 중인 기록이 있습니다.",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text("선택지를 초기화하시겠습니까?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                isResetConfirmed = false;
                Get.back();
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                isResetConfirmed = true;
                Get.back();
              },
              child: const Text("초기화"),
            ),
          ],
        ),
      );
    }
    if (isResetConfirmed == false) {
      return;
    } else {
      isRecordEditMode.value = false;
      isRecordEdited.value = false;
      selectedRecordData.value = null;
      recordManageSingleEditController.resetSelectedData();
      recordListExactWeekType.refresh();
      weekTypeList.refresh();
      resetTotalPriceLocale();
    }
  }

  void resetTotalPriceLocale() {
    totalItemPrice.value = 0;
    totalItemPriceLocale.value = f.format(totalItemPrice.value);
    totalItemPriceAfterDivision.value = 0;
    totalItemPriceAfterDivisionLocale.value = f.format(totalItemPriceAfterDivision.value);
  }

  Future<void> showDivisionHelpDialog() async {
    await Get.dialog(
      barrierDismissible: true,
      AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        title: null,
        content: const Padding(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            "1인당 분배금은 총 수익을 파티원 수로 나눈 값으로, 소수점에서 올림처리됩니다.\n(정확하지 않을 수 있습니다)",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("확인"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showTotalHelpDialog() async {
    await Get.dialog(
      barrierDismissible: true,
      AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        title: null,
        content: const Padding(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            "<각 아이템 별 판매 수익 계산 방법>\n"
            "- (각 아이템 별 획득 개수 * 단가) * (1 - 판매수수료율)\n"
            "- 예시: [MVP 브론즈일 때] 반짝이는 파란 별 물약 2개를 각 4,500,000메소에 판매 = 9,000,000메소 * (1 - 0.05) = 8,550,000메소\n\n"
            "- 판매수수료율은 MVP 등급에 따라 3% 또는 5%로 적용됩니다.(브론즈 이하: 5%, 실버 이상: 3%)\n\n"
            "- 총 판매 수익(합계)는 각 아이템 별 판매 수익을 모두 합친 후 판매수수료를 제한 값으로, 소수점에서 반올림처리됩니다.\n(정확하지 않을 수 있습니다)",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("확인"),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> showRevertChangesConfirmDialog() async {
    bool isConfirmed = false;
    await Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        title: const Text("수정 내역 초기화"),
        content: const Text("현재까지 수정한 모든 내역을 초기화합니다.\n계속하시겠습니까?\n(이 과정은 되돌릴 수 없습니다.)"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                isConfirmed = false;
                Get.back();
              },
              child: const Text("취소"),
            ),
          ),
          TextButton(
            onPressed: () {
              isConfirmed = true;
              Get.back();
            },
            child: const Text(
              "초기화",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
    return isConfirmed;
  }

  Future<void> removeBossRecord() async {
    bool removeConfirm = false;

    await Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: const Text(
          "보스 데이터 삭제",
        ),
        content: Text("<현재 보스>\n"
            "- 보스 이름: ${recordManageSingleEditController.selectedRecordData.value!.boss.korName}\n"
            "- 난이도: ${recordManageSingleEditController.selectedRecordData.value!.difficulty.korName}\n"
            "- 날짜: ${DateFormat('yyyy-MM-dd').format(recordManageSingleEditController.selectedRecordData.value!.date)}\n"
            "\n이 보스에 대한 기록을 지울까요? (삭제된 기록은 복구할 수 없습니다.)"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                removeConfirm = false;
                Get.back();
              },
              child: const Text("취소"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton(
              onPressed: () {
                removeConfirm = true;
                Get.back();
              },
              child: const Text(
                "삭제",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (removeConfirm) {
      await recordManageDataController.removeSingleRecord(selectedRecordData.value!);
      selectWeekType(weekTypeList.indexOf(selectedWeekType.value!));
      selectedRecordData.value = null;
      recordManageSingleEditController.resetSelectedData();
      resetTotalPriceLocale();
      isRecordEditMode.value = false;
      isRecordEdited.value = false;
    }
  }

  Future<void> saveData(BossRecord recordToSave) async {
    if (isRecordEdited.value == false) {
      toggleEditMode();
      return;
    }
    try {
      await recordManageDataController.updateSingleRecord(selectedRecordData.value!, recordToSave);
      selectWeekType(weekTypeList.indexOf(selectedWeekType.value!));
      selectedRecordData.value = recordManageDataController.loadedBossRecords.last;
      selectRecord(recordListExactWeekType.indexOf(selectedRecordData.value!));
      isRecordEditMode.value = false;
      isRecordEdited.value = false;
      recordManageSingleEditController.selectedRecordData.value!.itemList.refresh();
      showToast("변경된 데이터가 저장되었습니다.");
    } catch (e) {
      e.printInfo();
      showToast("데이터 저장에 실패했습니다. e: $e");
      loggerNoStack.e(e);
    }
  }

  void disposeFocusNodes() {
    if (itemFocusNodes.isNotEmpty) {
      for (int i = 0; i < itemFocusNodes.length; i++) {
        itemFocusNodes[i].dispose();
      }
      itemFocusNodes.clear();
    }
  }

  void disposeControllers() {
    if (itemPriceControllers.isNotEmpty) {
      for (int i = 0; i < itemPriceControllers.length; i++) {
        itemPriceControllers[i].dispose();
      }
      itemPriceControllers.clear();
    }
  }

  @override
  void onClose() {
    disposeFocusNodes();
    disposeControllers();
    super.onClose();
  }
}
