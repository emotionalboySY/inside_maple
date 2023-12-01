import 'package:get/get.dart';

import 'package:inside_maple/controllers/record_ui_controller.dart';

import '../constants.dart';
import '../data.dart';
import '../utils/logger.dart';

class RecordManageController extends GetxController {

  RecordUIController get recordUIController => Get.find<RecordUIController>();

  Rx<BossRecord?> selectedRecordData = Rx<BossRecord?>(null);

  void setRecordData(BossRecord recordData) {
    selectedRecordData.value = recordData;
    // sortItemList();
  }

  void applyPrice(int index) {
    if (recordUIController.itemPriceControllers[index].text.isNotEmpty) {
      int price = int.tryParse(recordUIController.itemPriceControllers[index].text) ?? 0;
      selectedRecordData.value!.itemList[index].price.value = price;
      recordUIController.updateIsRecordEdited();
      recordUIController.calculateTotalPrices();
    }
  }

  void sortItemList() {
    selectedRecordData.value!.itemList.sort((a, b) {
      if(ItemData.values.indexOf(a.item) < ItemData.values.indexOf(b.item)) {
        return -1;
      } else if(ItemData.values.indexOf(a.item) > ItemData.values.indexOf(b.item)) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  void resetSelectedData() {
    selectedRecordData.value = null;
  }

  void decreaseItemCount(int index) {
    selectedRecordData.value!.itemList[index].count--;
    recordUIController.updateIsRecordEdited();
  }

  void increaseItemCount(int index) {
    selectedRecordData.value!.itemList[index].count++;
    recordUIController.updateIsRecordEdited();
  }

  void deleteItem(int index) {
    selectedRecordData.value!.itemList.removeAt(index);
    selectedRecordData.value!.itemList.refresh();
    recordUIController.updateIsRecordEdited();
  }

  Future<void> revertChanges() async {
    if(await recordUIController.showRevertChangesConfirmDialog()) {
      loggerNoStack.d("before revert: $selectedRecordData");
      selectedRecordData.value = BossRecord.clone(recordUIController.selectedRecordData.value!);
      loggerNoStack.d("after revert: $selectedRecordData");
      for(int i = 0; i < selectedRecordData.value!.itemList.length; i++) {
        recordUIController.itemPriceControllers[i].text = selectedRecordData.value!.itemList[i].price.value.toString();
      }
      selectedRecordData.value!.itemList.refresh();
      recordUIController.updateIsRecordEdited();
    }
  }

  Future<void> saveChanges() async {
    await recordUIController.saveData(selectedRecordData.value!);
  }
}