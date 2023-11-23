import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/record_controller.dart';

class ViewBossRecordTop extends StatelessWidget {
  ViewBossRecordTop({super.key});

  final recordController = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _radioButtons(),
          _topMenus(),
        ],
      ),
    );
  }

  Widget _radioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _radioComponent(
          title: "단일 기록만 보기(판매금액 관리 가능)",
          value: 1,
        ),
        const SizedBox(
          width: 20,
        ),
        _radioComponent(
          title: "여러 날짜, 여러 보스 모아보기",
          value: 2,
        ),
      ],
    );
  }

  Widget _radioComponent({
    required String title,
    required int value,
  }) {
    return Row(
      children: [
        Obx(
          () => Radio<int>(
            value: value,
            groupValue: recordController.recordViewType.value,
            onChanged: (value) {
              recordController.recordViewType.value = value!;
            },
            splashRadius: 0.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            recordController.recordViewType.value = value;
          },
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _topMenus() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          recordController.selectedRecordData.value.recordData != null
              ? TextButton(
                  onPressed: () {
                    recordController.resetSelections();
                  },
                  child: const Text(
                    "선택지 초기화",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          recordController.selectedRecordData.value.recordData != null
              ? TextButton(
                  onPressed: () {
                    recordController.toggleEditMode();
                    if (recordController.isRecordEditMode.value) {
                    } else {}
                  },
                  child: Text(
                    recordController.isRecordEditMode.value ? "완료" : "수정",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15.0, left: 5.0),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Center(
                child: Text(
                  "나가기",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
