import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_manage_single_controller.dart';
import 'package:oktoast/oktoast.dart';

import '../../../constants.dart';
import '../../../controllers/record_manage_multi_controller.dart';

class ContentBottomMultiDateRangePicker extends StatelessWidget {
  ContentBottomMultiDateRangePicker({super.key});

  final recordUIController = Get.find<RecordManageSingleController>();
  final recordManageController = Get.find<RecordManageMultiController>();

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
                      if (recordManageController.startDate.isNotEmpty)
                        Text(
                          "${recordManageController.startDate[0]!.year}년 ${recordManageController.startDate[0]!.month}월 ${recordManageController.startDate[0]!.day}일",
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
                    value: recordManageController.startDate,
                    onValueChanged: (value) {
                      recordManageController.setStartDate(value);
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
                      if (recordManageController.endDate.isNotEmpty)
                        Text(
                          "${recordManageController.endDate[0]!.year}년 ${recordManageController.endDate[0]!.month}월 ${recordManageController.endDate[0]!.day}일",
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
                    value: recordManageController.endDate,
                    onValueChanged: (value) {
                      recordManageController.setEndDate(value);
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
                  showToast("정보 보기 버튼 눌림.");
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
