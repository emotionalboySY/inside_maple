import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/record_manage_single.dart';

class ContentBottomSingleBossList extends StatelessWidget {
  ContentBottomSingleBossList({super.key});

  final recordController = Get.find<RecordManageSingleController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => recordController.selectedWeekType.value == null
      ? const Center(
        child: Text(
          "주차를 먼저 선택해 주세요.",
        ),
      )
      : ListView.builder(
        itemCount: recordController.recordListExactWeekType.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "${recordController.recordListExactWeekType[index].boss.korName}"
                  " (${recordController.recordListExactWeekType[index].difficulty.korName})",
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 16,
            ),
            onTap: recordController.selectedRecordData.value == recordController.recordListExactWeekType[index] ? null : () async {
              await recordController.selectRecord(index);
            },
            selected: recordController.selectedRecordData.value == recordController.recordListExactWeekType[index],
            selectedTileColor: Colors.deepPurple.shade100.withOpacity(0.7),
            selectedColor: Colors.black,
            titleTextStyle: TextStyle(
              fontWeight: recordController.selectedRecordData.value == recordController.recordListExactWeekType[index] ? FontWeight.w700 : FontWeight.w400,
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
