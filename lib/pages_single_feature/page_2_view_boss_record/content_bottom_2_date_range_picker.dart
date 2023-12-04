import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_ui_controller.dart';
import 'package:oktoast/oktoast.dart';

import '../../constants.dart';
import '../../controllers/record_manage_2_controller.dart';

class ContentBottom2DateRangePicker extends StatelessWidget {
  ContentBottom2DateRangePicker({super.key});

  final recordUIController = Get.find<RecordUIController>();
  final recordManageController = Get.find<RecordManage2Controller>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Text("시작 날짜 칸"),
          ),
        ),
        separator(axis: Axis.horizontal),
        Expanded(
          child: Center(
            child: Text("끝 날짜 칸"),
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
                child: Center(
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
