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
    for(var record in recordManageDataController.loadedBossRecords) {
      if(selectedBossAndDiff.containsKey(record.boss)) {
        if(selectedBossAndDiff[record.boss]!.contains(record.difficulty)) {
          if((record.date.isAfter(startDate) && record.date.isBefore(endDate)) || record.date == startDate || record.date == endDate) {
            bossRecords.add(BossRecord.clone(record));
          }
        }
      }
    }

    for(var record in bossRecords) {
      for(var item in record.itemList) {
        if(itemsListRaw.containsKey(item.item)) {
          itemsListRaw[item.item]!.add(item);
        } else {
          itemsListRaw[item.item] = [item];
        }
      }
    }

    itemsListRaw.forEach((itemData, itemList) {
      if(itemList.any((element) => element.price.value == 0) || itemList.any((element) => element.price.value != itemList[0].price.value)) {
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
      for(var i = 0; i < itemsList.length; i++) {
        if(itemsList[i].price != itemsListEdited[i].price) {
          isRecordEdited.value = true;
          return;
        }
      }
      isRecordEdited.value = false;
    }
  }

  void calculateTotalPrice() {
    if(bossRecords.isNotEmpty && itemsList.isNotEmpty) {
      int totalPrice = 0;
      for(var item in itemsList) {
        totalPrice += ((item.price * item.count.value) * (recordManageDataController.isMVPSilver.value ? 0.97 : 0.95)).round();
      }
      this.totalPrice.value = totalPrice;
      totalPriceLocale.value = f.format(totalPrice);
    }
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