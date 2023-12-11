import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_manage_data_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../data.dart';

class RecordManageMultiEditController extends GetxController {
  final f = NumberFormat("#,##0");

  RecordManageDataController get recordManageDataController => Get.find<RecordManageDataController>();

  List<FocusNode> itemFocusNodes = [];
  List<TextEditingController> itemPriceControllers = [];

  RxList<BossRecord> bossRecords = <BossRecord>[].obs;
  Map<ItemData, List<Item>> itemsListRaw = {};
  RxList<Item> itemsList = <Item>[].obs;
  RxList<ItemData> flagList = <ItemData>[].obs;
  RxList<Item> itemsListEdited = <Item>[].obs;

  RxBool isRecordEditMode = false.obs;
  RxBool isRecordEdited = false.obs;

  RxInt totalPrice = 0.obs;
  RxString totalPriceLocale = "0".obs;

  void loadBossRecords(Map<Boss, List<Difficulty>> selectedBossAndDiff, DateTime startDate, DateTime endDate) {
    disposeControllers();
    disposeFocusNodes();
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
      if (itemList.any((element) => element.price.value == 0) || itemList.any((element) => element.price.value != itemList[0].price.value)) {
        flagList.add(itemData);
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
    itemsList.refresh();
    itemsListEdited.refresh();
  }

  void applyPrice(int index) {
    if (itemPriceControllers[index].text.isNotEmpty) {
      int price = int.tryParse(itemPriceControllers[index].text) ?? 0;
      itemsList[index].price.value = price;
      updateIsRecordEdited();
      // calculateTotalPrices();
    }
  }

  void updateIsRecordEdited() {
    if (isRecordEditMode.value) {
      for (var i = 0; i < itemsList.length; i++) {
        if (itemsList[i].price != itemsListEdited[i].price) {
          isRecordEdited.value = true;
          return;
        }
      }
      isRecordEdited.value = false;
    }
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
    await Get.dialog(
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
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Radio<String>(
                    onChanged: (value) {
                      whichType.value = value!;
                    },
                    value: "list",
                    groupValue: whichType.value,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "보스 리스트 중 선택",
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SizedBox(
                height: 150,
                width: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: recordsHaveExactItem.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        recordsHaveExactItem[index].boss.korName,
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Radio<String>(
                    onChanged: (value) {
                      whichType.value = value!;
                    },
                    value: "manual",
                    groupValue: whichType.value,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "직접 입력",
                  ),
                ),
              ],
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
            ),
          )
        ],
      ),
      barrierDismissible: true,
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

  void initializeFocusNodesAndControllers() {
    disposeFocusNodes();
    disposeControllers();
    for (int i = 0; i < itemsList.length; i++) {
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
      itemPriceControllers[i].text = itemsList[i].price.value.toString();
    }
  }

  void toggleEditMode() {
    isRecordEditMode.value = !isRecordEditMode.value;
  }

  void resetAll() {
    disposeFocusNodes();
    disposeControllers();
    itemsListEdited.clear();
    itemsList.clear();
    bossRecords.clear();
    isRecordEditMode.value = false;
    isRecordEdited.value = false;
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
}
