import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_manage_data.dart';
import 'package:inside_maple/utils/index.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../data.dart';

class RecordManageMultiEditController extends GetxController {
  final f = NumberFormat("#,##0");

  RecordManageDataController get recordManageDataController => Get.find<RecordManageDataController>();

  RxList<BossRecord> bossRecords = <BossRecord>[].obs;
  Map<ItemData, List<Item>> itemsListRaw = {};
  RxList<Item> itemsList = <Item>[].obs;
  RxMap<ItemData, int> flagList = <ItemData, int>{}.obs;
  RxList<Item> itemsListEdited = <Item>[].obs;

  RxBool isRecordEdited = false.obs;

  RxInt totalPrice = 0.obs;
  RxString totalPriceLocale = "0".obs;

  Map<String, dynamic> savedParams = {};

  void loadBossRecords(Map<Boss, List<Difficulty>> selectedBossAndDiff, DateTime startDate, DateTime endDate) {
    savedParams["selectedBossAndDiff"] = selectedBossAndDiff;
    savedParams["startDate"] = startDate;
    savedParams["endDate"] = endDate;
    bossRecords.clear();
    itemsList.clear();
    itemsListEdited.clear();
    itemsListRaw.clear();
    flagList.clear();
    for (var record in recordManageDataController.loadedBossRecords) {
      if (selectedBossAndDiff.containsKey(record.boss)) {
        if (selectedBossAndDiff[record.boss]!.contains(record.difficulty)) {
          if ((record.date.isAfter(startDate) && record.date.isBefore(endDate)) || record.date == startDate || record.date == endDate) {
            bossRecords.add(BossRecord.clone(record));
          }
        }
      }
    }

    for (var record in bossRecords) {
      for (var item in record.itemList) {
        if (itemsListRaw.containsKey(item.item)) {
          itemsListRaw[item.item]!.add(item);
        } else {
          itemsListRaw[item.item] = [item];
        }
      }
    }

    itemsListRaw.forEach((itemData, itemList) {
      if (itemList.any((element) => element.price.value == 0)) {
        flagList.addAll({itemData: 1});
      } else if (itemList.any((element) => element.price.value != itemList[0].price.value)) {
        flagList.addAll({itemData: 2});
      }
      int totalCount = 0;
      int totalPrice = 0;
      for (var element in itemList) {
        totalCount += element.count.value;
        totalPrice += element.price.value;
      }

      int avgPrice = (totalPrice / totalCount).round();
      itemsList.add(Item(item: itemData, count: totalCount.obs, price: avgPrice.obs));
      itemsListEdited.add(Item(item: itemData, count: totalCount.obs, price: avgPrice.obs));
    });
    itemsList.sort((a, b) => a.item.korLabel.compareTo(b.item.korLabel));
    itemsList.refresh();
    itemsListEdited.refresh();
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    if (bossRecords.isNotEmpty && itemsList.isNotEmpty) {
      int totalPrice = 0;
      for (var item in itemsList) {
        totalPrice += ((item.price * item.count.value) * (recordManageDataController.isMVPSilver.value ? 0.97 : 0.95)).round();
      }
      this.totalPrice.value = totalPrice;
      totalPriceLocale.value = f.format(totalPrice);
    }
  }

  Future<void> showPriceEditDialog(ItemData itemData) async {
    List<BossRecord> recordsHaveExactItem;
    recordsHaveExactItem = readRecordsWithExactItem(itemData);
    RxString whichType = "list".obs;
    TextEditingController controller = TextEditingController();
    RxInt selectedIndex = (-1).obs;
    String previousText = "";
    int priceToEdit = 0;
    await Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        title: const Text(
          "아이템 단가 수정",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "주의!",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              "여러 보스 모아보기에서 단가를 수정하는 경우,\n선택한 범위로 조회된 모든 보스 몬스터 격파 기록에 저장된\n동일 아이템에 대한 단가가 모두 수정됩니다!",
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "단가 수정은 해당 아이템 드랍된 보스 몬스터 격파 기록에 저장된 단가들 중 선택하거나, 직접 입력하여 수정할 수 있습니다.\n수정할 단가를 아래 리스트에서 선택하거나, 최하단 입력칸을 통해 입력해 주세요.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: separator(axis: Axis.horizontal),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Transform.scale(
                    scale: 0.8,
                    child: Radio<String>(
                      onChanged: (value) {
                        whichType.value = value!;
                      },
                      value: "list",
                      groupValue: whichType.value,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    whichType.value = "list";
                    controller.clear();
                  },
                  child: const Text(
                    "보스 리스트 중 선택",
                  ),
                ),
              ],
            ),
            Obx(
              () => Opacity(
                opacity: whichType.value == "list" ? 1 : 0.3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: SizedBox(
                    height: 150,
                    width: 700,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "보스명(난이도)",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "잡은 날짜",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "아이템 판매 단가",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: separator(axis: Axis.horizontal),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: recordsHaveExactItem.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                selectedIndex.value = index;
                                priceToEdit = recordsHaveExactItem[selectedIndex.value].itemList.firstWhere((element) => element.item == itemData).price.value;
                              },
                              child: SizedBox(
                                height: 30,
                                child: Obx(
                                  () => DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: selectedIndex.value == index ? Colors.deepPurple.shade100 : Colors.transparent,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "${recordsHaveExactItem[index].boss.korName}(${recordsHaveExactItem[index].difficulty.korName})",
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              toKorDateLabel(recordsHaveExactItem[index].date),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "${f.format(recordsHaveExactItem[index].itemList.firstWhere((element) => element.item == itemData).price.value)} 메소",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Transform.scale(
                    scale: 0.8,
                    child: Radio<String>(
                      onChanged: (value) {
                        whichType.value = value!;
                      },
                      value: "manual",
                      groupValue: whichType.value,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    whichType.value = "manual";
                    selectedIndex.value = -1;
                  },
                  child: const Text(
                    "직접 입력",
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: SizedBox(
                width: 300,
                child: Obx(
                  () => TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (controller.text.isNotEmpty && int.tryParse(controller.text) == null) {
                        controller.text = previousText;
                      }
                      priceToEdit = int.tryParse(controller.text)!;
                      previousText = controller.text;
                    },
                    enabled: whichType.value == "manual",
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "취소",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          TextButton(
            onPressed: () async {
              bool confirmed = await priceEditConfirmDialog(itemData, priceToEdit);
              if(confirmed) {
                Get.back();
              }
            },
            child: const Text(
              "저장",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> priceEditConfirmDialog(ItemData item, int price) async {
    bool confirmed = false;
    await Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        title: const Center(
          child: Text(
            "아이템 판매 단가 수정 확인",
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "아이템: ",
                ),
                Text(
                    item.korLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "변경할 금액: "
                ),
                Text(
                  "${f.format(price)} 메소",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                "위 정보대로 아이템 판매 단가를 수정하시겠습니까?",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              loadBossRecords(savedParams["selectedBossAndDiff"], savedParams["startDate"], savedParams["endDate"]);
              Get.back();
              confirmed = true;
            },
            child: const Text(
              "네",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "아니오",
              style: TextStyle(
                  color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
    return confirmed;
  }

  Future<void> showItemHistoryDialog(int index) async {
    ItemData itemData = itemsList[index].item;
    List<BossRecord> recordContainsItemData = [];
    for (var record in bossRecords) {
      if (record.itemList.indexWhere((element) => element.item == itemData) != -1) {
        recordContainsItemData.add(record);
      }
    }

    recordContainsItemData.sort((a, b) {
      if (a.date == b.date) {
        return 0;
      } else if (a.date.isBefore(b.date)) {
        return -1;
      } else {
        return 1;
      }
    });

    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        title: const Center(
          child: Text("보스 정보 보기"),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text("보스명(난이도)"),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "잡은 날짜",
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: separator(axis: Axis.horizontal),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: recordContainsItemData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "${recordContainsItemData[index].boss.korName}(${recordContainsItemData[index].difficulty.korName})",
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              toKorDateLabel(recordContainsItemData[index].date),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAvgPriceHelpDialog() async {
    await Get.dialog(
      AlertDialog(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: const Center(
          child: Text(
            "<평균 판매 단가 색 구별 방법>",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "- 검은색: 이 아이템에 대한 판매 가격이 모두 같음",
              ),
            ),
            Text(
              "- 빨간색: 저장된 아이템 정보 중 가격이 저장되지 않은 기록이 있음",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            Text(
              "  (빨간색 영역을 누르면, 저장되지 않은 판매 단가를 저장할 수 있습니다.)",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            Text(
              "- 파란색: 저장된 아이템 정보 중 서로 다른 가격에 판매된 아이템이 있음",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            Text(
              "  (파란색 영역은 참고용이며, 문제가 있는 부분이 아닙니다.)",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "확인",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  List<BossRecord> readRecordsWithExactItem(ItemData itemData) {
    List<BossRecord> foundRecords = [];
    for (var record in bossRecords) {
      if (record.itemList.indexWhere((element) => element.item == itemData) != -1) {
        foundRecords.add(record);
      }
    }
    return foundRecords;
  }

  void resetAll() {
    itemsListEdited.clear();
    itemsList.clear();
    bossRecords.clear();
    isRecordEdited.value = false;
  }
}
