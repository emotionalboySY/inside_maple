import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/record_controller.dart';

class ContentBottomBossList extends StatelessWidget {
  ContentBottomBossList({super.key});

  final recordController = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => recordController.selectedWeekTypeIndex.value == -1
      ? const Center(
        child: Text(
          "주차를 먼저 선택해 주세요.",
        ),
      )
      : ListView.builder(
        itemCount: recordController.selectedRecordList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "${recordController.selectedRecordList[index].recordData!.boss.korName}"
                  " (${recordController.selectedRecordList[index].recordData!.difficulty.korName})",
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 16,
            ),
            onTap: () {
              recordController.selectRecordItem(index);
            },
            selected: index == recordController.selectedRecordIndex.value,
            selectedTileColor: Colors.grey.shade300,
            selectedColor: Colors.black,
            titleTextStyle: TextStyle(
              fontWeight: index == recordController.selectedRecordIndex.value ? FontWeight.w700 : FontWeight.w400,
              color: Colors.black,
              fontSize: 16,
              fontFamily: "Pretendard",
            ),
          );
        },
      ),
    );
  }
}
