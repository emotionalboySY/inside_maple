import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../data.dart';
import '../utils/logger.dart';

class RecordItem {

  RecordItem({
    required this.recordData,
    required this.weekType,
  });

  BossRecord recordData;
  WeekType weekType;

  void updateRecord(BossRecord data) {
    recordData = data;
  }
}

class RecordController extends GetxController {

  Rx<LoadStatus> recordLoadStatus = LoadStatus.empty.obs;

  List<BossRecord> recordRawList = <BossRecord>[];
  RxList<RecordItem> recordList = <RecordItem>[].obs;

  final box = Hive.box('insideMaple');

  Future<void> loadRecord() async {
    recordLoadStatus.value = LoadStatus.loading;
    recordList.clear();

    recordRawList = await box.get('bossRecordData', defaultValue: <BossRecord>[]).cast<BossRecord>();
    logger.d(recordRawList);

    logger.d(recordList);
    for(var record in recordRawList) {
      WeekType? weekType = getWeekType(record);

      if(weekType == null) {
        continue;
      }

      RecordItem singleRecordItem = RecordItem(recordData: record, weekType: weekType);

      recordList.add(singleRecordItem);
    }

    logger.d(recordList);
    recordLoadStatus.value = LoadStatus.success;
    recordList.refresh();
  }

  WeekType? getWeekType(BossRecord record) {
    DateTime date = record.date;

    DateTime firstDayOfMonth = DateTime(date.year, date.month);
    int daysToAdd = (4 - firstDayOfMonth.weekday) % 7;
    DateTime firstThursday = firstDayOfMonth.add(Duration(days: daysToAdd));

    if(date.isBefore(firstThursday)) {
      return null;
    }

    int differenceInDays = date.difference(firstThursday).inDays;
    int weekNum = (differenceInDays / 7).floor() + 1;
    DateTime startDateOfWeek = firstThursday.add(Duration(days: (7 * (weekNum - 1))));
    DateTime endDateOfWeek = startDateOfWeek.add(const Duration(days: 6));

    return WeekType(
      year: date.year,
      month: date.month,
      weekNum: weekNum,
      startDate: startDateOfWeek,
      endDate: endDateOfWeek,
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadRecord();
  }
}