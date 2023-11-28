import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_manage_controller.dart';

import '../../controllers/record_ui_controller.dart';

class ViewBossRecordTop extends StatelessWidget {
  ViewBossRecordTop({super.key});

  final recordUIController = Get.find<RecordUIController>();
  final recordManageController = Get.find<RecordManageController>();

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
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: AnimatedToggleSwitch.dual(
              current: recordUIController.isMvpSilver.value,
              first: false,
              second: true,
              onChanged: (value) {
                recordUIController.toggleMVP();
              },
              height: 30,
              spacing: 10,
              indicatorSize: const Size.fromWidth(40),
              borderWidth: 3.0,
              style: const ToggleStyle(
                borderColor: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1.5),
                  ),
                ],
                indicatorColor: Colors.white,
              ),
              styleBuilder: (value) => ToggleStyle(backgroundColor: value ? Colors.grey.shade500 : Colors.brown),
              textBuilder: (value) => value
                  ? const Center(
                      child: Text(
                        "실버▲",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : const Center(
                      child: Text(
                        "브론즈",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
              customIconBuilder: (context, local, global) {
                return const Text(
                  "MVP",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
              iconAnimationCurve: Curves.easeInOut,
              indicatorTransition: const ForegroundIndicatorTransition.fading(),
            ),
          ),
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
            groupValue: recordUIController.recordViewType.value,
            onChanged: (value) {
              recordUIController.recordViewType.value = value!;
            },
            splashRadius: 0.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            recordUIController.recordViewType.value = value;
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
          recordManageController.selectedRecordData.value != null &&
                  recordUIController.isRecordEditMode.value &&
                  recordUIController.isRecordEdited.value
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextButton(
                    onPressed: () {
                      recordManageController.revertChanges();
                    },
                    child: const Text(
                      "수정 내역 초기화",
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          recordManageController.selectedRecordData.value != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextButton(
                    onPressed: () {
                      if (recordUIController.isRecordEditMode.value) {
                        recordManageController.saveChanges();
                      } else {
                        recordUIController.toggleEditMode();
                      }
                    },
                    child: Text(
                      recordUIController.isRecordEditMode.value ? "저장" : "수정",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
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
                    fontSize: 14,
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
