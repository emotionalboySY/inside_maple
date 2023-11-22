import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../data.dart';
import '../utils/logger.dart';

class RecordItem {

  RecordItem({
    this.recordData,
    this.weekType,
  });

  BossRecord? recordData;
  WeekType? weekType;

  void updateRecord(BossRecord data) {
    recordData = data;
  }

  @override
  String toString() {
    return 'RecordItem{recordData: $recordData, weekType: $weekType}';
  }
}

class RecordController extends GetxController {

  Rx<int> recordViewType = 1.obs;

  Rx<LoadStatus> recordLoadStatus = LoadStatus.empty.obs;

  List<BossRecord> recordRawList = <BossRecord>[];
  RxList<RecordItem> recordList = <RecordItem>[].obs;

  RxList<WeekType> weekTypeList = <WeekType>[].obs;
  RxList<RecordItem> selectedRecordList = <RecordItem>[].obs;
  Rx<RecordItem?> selectedRecordData = RecordItem().obs;

  RxInt selectedWeekTypeIndex = (-1).obs;
  RxInt selectedRecordIndex = (-1).obs;

  Future<void> loadRecord() async {
    final box = await Hive.openBox("insideMaple");
    recordLoadStatus.value = LoadStatus.loading;
    recordList.clear();

    recordRawList = await box.get('bossRecordData', defaultValue: <BossRecord>[]).cast<BossRecord>();
    for(var record in recordRawList) {
      WeekType? weekType = getWeekType(record);

      if(weekType == null) {
        continue;
      }

      RecordItem singleRecordItem = RecordItem(recordData: record, weekType: weekType);
      loggerNoStack.d("calculated weekType: $weekType");
      loggerNoStack.d("existing weekTypeList: $weekTypeList");
      loggerNoStack.d("is WeekTypeList contains weekType? ${weekTypeList.contains(weekType)}");
      if(!weekTypeList.contains(weekType)) {
        weekTypeList.add(weekType);
      }

      recordList.add(singleRecordItem);
    }

    weekTypeList.sort((a, b) => a.startDate.compareTo(b.startDate));

    recordLoadStatus.value = LoadStatus.success;
    weekTypeList.refresh();
    recordList.refresh();
    box.close();
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

  void selectRecord(int index) {
    selectedWeekTypeIndex.value = index;
    selectedRecordList.clear();
    for(var record in recordList) {
      if(record.weekType == weekTypeList[index]) {
        selectedRecordList.add(record);
      }
    }
    selectedRecordIndex.value = -1;
    weekTypeList.refresh();
    selectedRecordList.refresh();
    recordList.refresh();
  }

  void selectRecordItem(int index) {
    selectedRecordIndex.value = index;
    loadSingleRecord();
    selectedRecordList.refresh();
  }

  void loadSingleRecord() {
    selectedRecordData.value = selectedRecordList[selectedRecordIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    loadRecord();
  }
}