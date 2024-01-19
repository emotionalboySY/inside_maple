// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:inside_maple/controllers/record_manage_multi.dart';
// import 'package:inside_maple/controllers/record_manage_multi_edit.dart';
// import 'package:inside_maple/controllers/record_manage_single_edit.dart';
// import 'package:inside_maple/controllers/record_manage_single.dart';
//
// import '../model/record_boss.dart';
// import '../services/boss_view.dart' as boss_service;
//
//
// class RecordManageDataController extends GetxController {
//
//   final recordManageSingleController = Get.find<RecordManageSingleController>();
//   final recordManageSingleEditController = Get.find<RecordManageSingleEditController>();
//   final recordManageMultiController = Get.find<RecordManageMultiController>();
//   final recordManageMultiEditController = Get.find<RecordManageMultiEditController>();
//
//   final List<RecordBoss> _loadedBossRecords = <RecordBoss>[];
//
//   RxInt viewMode = 1.obs;
//   RxBool isMVPSilver = false.obs;
//
//   Future<void> readBossRecords() async {
//     _loadedBossRecords.clear();
//
//     List<RecordBoss> loadedRecords = await boss_service.loadRecords();
//     _loadedBossRecords.addAll(loadedRecords);
//
//     recordManageSingleController.setDataFromRaw(_loadedBossRecords);
//     recordManageMultiController.setDataFromRaw(_loadedBossRecords);
//   }
//
//   Future<void> removeSingleRecord(RecordBoss recordToRemove) async {
//     _loadedBossRecords.remove(recordToRemove);
//     boss_service.removeRecord(recordToRemove);
//     await readBossRecords();
//   }
//
//   Future<void> updateSingleRecord(RecordBoss existingRecord, RecordBoss recordToSave) async {
//     // TODO: implement updateSingleRecord
//   }
//
//   void toggleMVP() {
//     isMVPSilver.value = !isMVPSilver.value;
//     recordManageSingleController.calculateTotalPrices();
//     recordManageMultiEditController.calculateTotalPrice();
//   }
//
//   List<RecordBoss> get loadedBossRecords => _loadedBossRecords;
//
//   @override
//   void onInit() {
//     readBossRecords();
//     super.onInit();
//   }
//
// }