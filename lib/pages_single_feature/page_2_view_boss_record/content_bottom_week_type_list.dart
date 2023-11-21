import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants.dart';
import '../../controllers/add_record_controller.dart';
import '../../controllers/record_controller.dart';

class ContentBottomWeekTypeList extends StatelessWidget {
  ContentBottomWeekTypeList({super.key});

  final viewRecordController = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: 300,
      child: Obx(
        () => switch (viewRecordController.recordLoadStatus.value) {
          LoadStatus.empty => const Center(
              child: Text("아직 데이터가 로드되지 않았습니다."),
            ),
          LoadStatus.loading => Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: Colors.deepPurple,
                size: 12.0,
              ),
            ),
          LoadStatus.failed => const Center(
              child: Text(
                "보스 격파 데이터 로드에 실패하였습니다.",
              ),
            ),
          LoadStatus.success => viewRecordController.recordList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "저장된 데이터가 없습니다.",
                      ),
                      TextButton(
                        onPressed: () {
                          Get.put(AddRecordController());
                          Get.offNamed("/page/addRecord");
                        },
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                        ),
                        child: const Text(
                          "새로운 보스 격파 기록을 추가해 보세요!",
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: viewRecordController.recordList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        viewRecordController.recordList[index].weekType.toString(),
                      ),
                    );
                  },
                ),
        },
      ),
    );
  }
}
