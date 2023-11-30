import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controllers/record_ui_controller.dart';

class ContentBottom2BossList extends StatelessWidget {
  ContentBottom2BossList({super.key});

  final recordUIController = Get.find<RecordUIController>();

  @override
  Widget build(BuildContext context) {
    return switch(recordUIController.recordLoadStatus.value) {
      LoadStatus.loading => Center(
        child: LoadingAnimationWidget.prograssiveDots(
          color: Colors.deepPurple,
          size: 24.0,
        ),
      ),
      LoadStatus.success => ListView.builder(
        itemCount: recordUIController.recordedBossList.length,
        itemBuilder: (context, index) {
          return Obx(
            () => ListTile(
              title: Text(recordUIController.recordedBossList[index].key.korName),
              onTap: () {
              },
            ),
          );
        },
      ),
      LoadStatus.failed => const Center(
        child: Text(
          "데이터 로드에 실패하였습니다.",
        ),
      ),
      LoadStatus.empty => const Center(
        child: Text("아직 데이터가 로드되지 않았습니다."),
      ),
    };
  }
}
