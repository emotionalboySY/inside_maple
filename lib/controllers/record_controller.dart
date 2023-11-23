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
  RxBool isRecordEditMode = false.obs;

  Rx<LoadStatus> recordLoadStatus = LoadStatus.empty.obs;

  List<BossRecord> recordRawList = <BossRecord>[];
  RxList<RecordItem> recordList = <RecordItem>[].obs;

  RxList<WeekType> weekTypeList = <WeekType>[].obs;
  RxList<RecordItem> selectedRecordList = <RecordItem>[].obs;

  RxInt selectedWeekTypeIndex = (-1).obs;
  RxInt selectedRecordIndex = (-1).obs;
  Rx<RecordItem> selectedRecordData = RecordItem().obs;
  RxInt totalItemPrice = 0.obs;
  RxInt totalItemPriceAfterDivision = 0.obs;

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

  void toggleEditMode() {
    isRecordEditMode.value = !isRecordEditMode.value;
  }

  void resetSelections() {
    selectedRecordData.value = RecordItem();
    selectedRecordIndex.value = -1;
    selectedWeekTypeIndex.value = -1;
    selectedRecordList.refresh();
    weekTypeList.refresh();
  }

  void decreaseItemCount() {

  }

  void increaseItemCount() {

  }

  void setItemPrice(int index, int price) {
    selectedRecordData.value.recordData!.itemList[index].price = price;
  }

  void calculateTotalPrices() {
    int total = 0;
    for(var item in selectedRecordData.value.recordData!.itemList) {
      total += item.price;
    }
    totalItemPrice.value = total;
    totalItemPriceAfterDivision.value = (total / selectedRecordData.value.recordData!.partyAmount).round();

    loggerNoStack.d("calculated totalItemPrice: $totalItemPrice");
    loggerNoStack.d("calculated totalItemPriceAfterDivision: $totalItemPriceAfterDivision");
  }

  @override
  void onInit() {
    super.onInit();
    loadRecord();
  }
}