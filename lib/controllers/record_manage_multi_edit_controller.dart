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
  RxList<Item> itemsList = <Item>[].obs;
  RxList<Item> itemsListEdited = <Item>[].obs;

  RxBool isRecordEditMode = false.obs;
  RxBool isRecordEdited = false.obs;

  void loadBossRecords(Map<Boss, List<Difficulty>> selectedBossAndDiff, DateTime startDate, DateTime endDate) {
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
        if(itemsList.any((element) => element.item == item.item)) {
          itemsList.firstWhere((element) => element.item == item.item).count.value += item.count.value;
        } else {
          itemsList.add(item);
        }
        itemsListEdited.add(Item.clone(item));
      }
    }
    itemsList.refresh();
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