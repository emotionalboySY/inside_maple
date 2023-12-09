import 'package:get/get.dart';

import 'package:inside_maple/controllers/record_manage_single_controller.dart';

import '../constants.dart';
import '../data.dart';
import '../utils/logger.dart';

class RecordManageSingleEditController extends GetxController {

  RecordManageSingleController get recordManageSingleController => Get.find<RecordManageSingleController>();

  Rx<BossRecord?> selectedRecordData = Rx<BossRecord?>(null);

  void setRecordData(BossRecord recordData) {
    selectedRecordData.value = recordData;
    // sortItemList();
  }

  void applyPrice(int index) {
    if (recordManageSingleController.itemPriceControllers[index].text.isNotEmpty) {
      int price = int.tryParse(recordManageSingleController.itemPriceControllers[index].text) ?? 0;
      selectedRecordData.value!.itemList[index].price.value = price;
      recordManageSingleController.updateIsRecordEdited();
      recordManageSingleController.calculateTotalPrices();
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
    recordManageSingleController.updateIsRecordEdited();
  }

  void increaseItemCount(int index) {
    selectedRecordData.value!.itemList[index].count++;
    recordManageSingleController.updateIsRecordEdited();
  }

  void deleteItem(int index) {
    selectedRecordData.value!.itemList.removeAt(index);
    selectedRecordData.value!.itemList.refresh();
    recordManageSingleController.updateIsRecordEdited();
  }

  Future<void> revertChanges() async {
    if(await recordManageSingleController.showRevertChangesConfirmDialog()) {
      loggerNoStack.d("before revert: $selectedRecordData");
      selectedRecordData.value = BossRecord.clone(recordManageSingleController.selectedRecordData.value!);
      loggerNoStack.d("after revert: $selectedRecordData");
      for(int i = 0; i < selectedRecordData.value!.itemList.length; i++) {
        recordManageSingleController.itemPriceControllers[i].text = selectedRecordData.value!.itemList[i].price.value.toString();
      }
      selectedRecordData.value!.itemList.refresh();
      recordManageSingleController.updateIsRecordEdited();
    }
  }

  Future<void> saveChanges() async {
    await recordManageSingleController.saveData(selectedRecordData.value!);
  }
}