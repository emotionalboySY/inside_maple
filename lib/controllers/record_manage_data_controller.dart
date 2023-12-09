import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inside_maple/controllers/record_manage_multi_controller.dart';
import 'package:inside_maple/controllers/record_manage_single_edit_controller.dart';
import 'package:inside_maple/controllers/record_manage_single_controller.dart';

import '../data.dart';

class RecordManageDataController extends GetxController {

  final recordManageSingleController = Get.find<RecordManageSingleController>();
  final recordManageSingleEditController = Get.find<RecordManageSingleEditController>();
  final recordManageMultiController = Get.find<RecordManageMultiController>();

  List<BossRecord> _loadedBossRecords = <BossRecord>[];

  Future<void> readBossRecords() async {
    final box = await Hive.openBox("insideMaple");
    _loadedBossRecords.clear();
    _loadedBossRecords = await box.get("bossRecordData", defaultValue: <BossRecord>[]).cast<BossRecord>();
    await box.close();
    recordManageSingleController.setDataFromRaw(_loadedBossRecords);
    recordManageMultiController.setDataFromRaw(_loadedBossRecords);
  }

  Future<void> removeSingleRecord(BossRecord recordToRemove) async {
    final box = await Hive.openBox("insideMaple");
    _loadedBossRecords.remove(recordToRemove);
    await box.put("bossRecordData", _loadedBossRecords);
    await box.close();
    await readBossRecords();
  }

  Future<void> updateSingleRecord(BossRecord existingRecord, BossRecord recordToSave) async {
    final box = await Hive.openBox("insideMaple");
    _loadedBossRecords.remove(existingRecord);
    _loadedBossRecords.add(recordToSave);
    await box.put("bossRecordData", _loadedBossRecords);
    await box.close();
    await readBossRecords();
  }

  List<BossRecord> get loadedBossRecords => _loadedBossRecords;

  @override
  void onInit() {
    readBossRecords();
    super.onInit();
  }

}