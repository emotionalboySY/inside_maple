import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/record_manage_multi.dart';
import '../../../utils/index.dart';

class ContentBottomMultiDateRangePicker extends StatelessWidget {
  ContentBottomMultiDateRangePicker({super.key});

  final recordManageMultiController = Get.find<RecordManageMultiController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "언제부터? ",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      if (recordManageMultiController.startDate.isNotEmpty)
                        Text(
                          "${recordManageMultiController.startDate[0]!.year}년 ${recordManageMultiController.startDate[0]!.month}월 ${recordManageMultiController.startDate[0]!.day}일",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      lastDate: DateTime.now(),
                    ),
                    value: recordManageMultiController.startDate,
                    onValueChanged: (value) {
                      recordManageMultiController.setStartDate(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        separator(axis: Axis.horizontal),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "언제까지? ",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      if (recordManageMultiController.endDate.isNotEmpty)
                        Text(
                          "${recordManageMultiController.endDate[0]!.year}년 ${recordManageMultiController.endDate[0]!.month}월 ${recordManageMultiController.endDate[0]!.day}일",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      lastDate: DateTime.now(),
                    ),
                    value: recordManageMultiController.endDate,
                    onValueChanged: (value) {
                      recordManageMultiController.setEndDate(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        separator(axis: Axis.horizontal),
        SizedBox(
          height: 50,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () {
                  recordManageMultiController.loadItemData();
                },
                child: const Center(
                  child: Text(
                    "정보 보기",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
