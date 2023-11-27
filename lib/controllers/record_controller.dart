import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../data.dart';
import '../utils/logger.dart';

class RecordController extends GetxController {
  final f = NumberFormat("#,##0");

  List<FocusNode> itemFocusNodes = [];
  List<TextEditingController> itemPriceControllers = [];

  Rx<LoadStatus> recordLoadStatus = LoadStatus.empty.obs;

  Rx<int> recordViewType = 1.obs;
  RxBool isRecordEditMode = false.obs;
  RxBool isRecordEdited = false.obs;

  List<BossRecord> recordListLoaded = <BossRecord>[];
  RxList<BossRecord> recordListExactWeekType = <BossRecord>[].obs;
  RxList<WeekType> weekTypeList = <WeekType>[].obs;

  RxInt selectedWeekTypeIndex = (-1).obs;
  RxInt selectedRecordIndex = (-1).obs;
  Rx<BossRecord?> selectedRecordDataOriginal = Rx<BossRecord?>(null);
  Rx<BossRecord?> selectedRecordData = Rx<BossRecord?>(null);
  RxInt totalItemPrice = 0.obs;
  RxInt totalItemPriceAfterDivision = 0.obs;
  RxString totalItemPriceLocale = "".obs;
  RxString totalItemPriceAfterDivisionLocale = "".obs;
  RxBool isMvpSilver = false.obs;

  Future<void> loadRecord() async {
    final box = await Hive.openBox("insideMaple");
    recordLoadStatus.value = LoadStatus.loading;
    weekTypeList.clear();

    recordListLoaded = await box.get('bossRecordData', defaultValue: <BossRecord>[]).cast<BossRecord>();
    // logger.d(recordListLoaded);
    for (var record in recordListLoaded) {
      if (!weekTypeList.contains(record.weekType)) {
        weekTypeList.add(record.weekType);
      }
    }

    weekTypeList.sort((a, b) => a.startDate.compareTo(b.startDate));

    recordLoadStatus.value = LoadStatus.success;
    weekTypeList.refresh();
    box.close();
  }

  void initializeFocusNodesAndControllers() {
    for (int i = 0; i < selectedRecordData.value!.itemList.length; i++) {
      itemFocusNodes.add(FocusNode());
      itemPriceControllers.add(TextEditingController());

      itemFocusNodes[i].addListener(() {
        if (!itemFocusNodes[i].hasFocus) {
          applyPrice(i);
        }
        if (itemFocusNodes[i].hasFocus) {
          itemPriceControllers[i].selection = TextSelection(baseOffset: 0, extentOffset: itemPriceControllers[i].text.length);
        }
      });
      itemPriceControllers[i].text = selectedRecordData.value!.itemList[i].price.value.toString();
    }
  }

  void applyPrice(int index) {
    if (itemPriceControllers[index].text.isNotEmpty) {
      int price = int.tryParse(itemPriceControllers[index].text) ?? 0;
      setItemPrice(index, price);
      calculateTotalPrices();
    }
  }

  void selectWeekType(int index) {
    selectedWeekTypeIndex.value = index;
    recordListExactWeekType.clear();
    for (var record in recordListLoaded) {
      if (record.weekType == weekTypeList[index]) {
        recordListExactWeekType.add(record);
      }
    }
    selectedRecordIndex.value = -1;
    selectedRecordData.value = null;
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
    if (selectedRecordData.value == null || selectConfirmed == true || isRecordEdited.value == false) {
      // loggerNoStack.d("selectConfirmed: true so move selection");
      selectedRecordIndex.value = index;
      selectedRecordDataOriginal.value = recordListExactWeekType[selectedRecordIndex.value];
      selectedRecordData.value = BossRecord.clone(recordListExactWeekType[selectedRecordIndex.value]);
      initializeFocusNodesAndControllers();
      // loggerNoStack.d("all record data: $recordListLoaded");
      // loggerNoStack.d("selectedRecordData: $selectedRecordData");
      recordListExactWeekType.refresh();
      isRecordEditMode.value = false;
      isRecordEdited.value = false;
      resetTotalPriceLocale();
    }
  }

  void toggleEditMode() {
    isRecordEditMode.value = !isRecordEditMode.value;
  }

  void toggleMVP() {
    isMvpSilver.value = !isMvpSilver.value;
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
      selectedRecordDataOriginal.value = null;
      selectedRecordData.value = null;
      selectedRecordIndex.value = -1;
      selectedWeekTypeIndex.value = -1;
      recordListExactWeekType.refresh();
      weekTypeList.refresh();
      resetTotalPriceLocale();
    }
  }

  void decreaseItemCount(int index) {
    selectedRecordData.value!.itemList[index].count--;
    updateIsRecordEdited();
  }

  void increaseItemCount(int index) {
    selectedRecordData.value!.itemList[index].count++;
    updateIsRecordEdited();
  }

  void setItemPrice(int index, int price) {
    selectedRecordData.value!.itemList[index].price.value = price;
    updateIsRecordEdited();
    // loggerNoStack.d("original record data: ${selectedRecordList[selectedRecordIndex.value].recordData}");
    // loggerNoStack.d("now record data: ${selectedRecordData.value.recordData}");
  }

  void calculateTotalPrices() {
    int total = 0;
    for (var item in selectedRecordData.value!.itemList) {
      total += ((item.price * item.count.value) * (isMvpSilver.value ? 0.97 : 0.95)).round();
    }
    totalItemPrice.value = total;
    totalItemPriceLocale.value = f.format(total);
    totalItemPriceAfterDivision.value = (total / selectedRecordData.value!.partyAmount.value).round();
    totalItemPriceAfterDivisionLocale.value = f.format(totalItemPriceAfterDivision.value);

    // loggerNoStack.d("calculated totalItemPrice: $totalItemPrice");
    // loggerNoStack.d("calculated totalItemPriceAfterDivision: $totalItemPriceAfterDivision");
  }

  void resetTotalPriceLocale() {
    totalItemPrice.value = 0;
    totalItemPriceLocale.value = f.format(totalItemPrice.value);
    totalItemPriceAfterDivision.value = 0;
    totalItemPriceAfterDivisionLocale.value = f.format(totalItemPriceAfterDivision.value);
  }

  void removeItem(int index) {
    selectedRecordData.value!.itemList.removeAt(index);
    selectedRecordData.value!.itemList.refresh();
    updateIsRecordEdited();
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
            "1인당 분배금은 총 합계를 파티원 수로 나눈 값으로, 소수점에서 올림처리됩니다.\n(정확하지 않을 수 있습니다)",
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
            "<각 아이템 별 판매 수익 계산 방법>\n- (각 아이템 별 획득 개수 * 단가) * (1 - 판매수수료율)\n- 반환받은 보증금은 해당 아이템을 판매 슬롯에 등록한 횟수에 따라 다릅니다.\n\n"
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

  void updateIsRecordEdited() {
    if (isRecordEditMode.value) {
      BossRecord record = recordListExactWeekType
          .firstWhere((item) => (item.boss == selectedRecordData.value!.boss && item.difficulty == selectedRecordData.value!.difficulty && item.date == selectedRecordData.value!.date));
      // loggerNoStack.d("selected record data: ${item.recordData}");
      // loggerNoStack.d("Changed record data: ${selectedRecordData.value.recordData}");
      if (record == selectedRecordData.value) {
        // loggerNoStack.d("selected record data and changed record data are same");
        isRecordEdited = false.obs;
      } else {
        // loggerNoStack.d("selected record data and changed record data are not same");
        isRecordEdited = true.obs;
      }
    }
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
            "- 보스 이름: ${selectedRecordData.value!.boss.korName}\n"
            "- 난이도: ${selectedRecordData.value!.difficulty.korName}\n"
            "- 날짜: ${DateFormat('yyyy-MM-dd').format(selectedRecordData.value!.date)}\n"
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

    if(removeConfirm) {
      recordListLoaded.remove(selectedRecordDataOriginal.value);
      final box = await Hive.openBox("insideMaple");
      await box.put('bossRecordData', recordListLoaded);
      recordListExactWeekType.clear();
      selectedRecordDataOriginal.value = null;
      selectedRecordData.value = null;
      selectedRecordIndex.value = -1;
      selectedWeekTypeIndex.value = -1;
      recordListExactWeekType.refresh();
      weekTypeList.refresh();
      resetTotalPriceLocale();
      isRecordEditMode.value = false;
      isRecordEdited.value = false;
      await loadRecord();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadRecord();
  }

  @override
  void onClose() {
    for (int i = 0; i < itemFocusNodes.length; i++) {
      itemFocusNodes[i].dispose();
      itemPriceControllers[i].dispose();
    }
    super.onClose();
  }
}
