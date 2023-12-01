import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/content_bottom_week_type_list.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/content_top.dart';

import '../../controllers/record_ui_controller.dart';
import 'content_bottom_2_boss_list.dart';
import 'content_bottom_boss_list.dart';
import 'content_bottom_item_list.dart';

class PageViewBossRecord extends StatelessWidget {
  PageViewBossRecord({super.key});

  final recordUIController = Get.find<RecordUIController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ViewBossRecordTop(),
          separator(axis: Axis.horizontal),
          Obx(
            () => Expanded(
              child: recordUIController.recordViewType.value == 1 ? const _BottomWidgetSingle() : const _BottomWidgetMulti(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomWidgetSingle extends StatelessWidget {
  const _BottomWidgetSingle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ContentBottomWeekTypeList(),
        ),
        separator(axis: Axis.vertical),
        Expanded(
          flex: 2,
          child: ContentBottomBossList(),
        ),
        separator(axis: Axis.vertical),
        Expanded(
          flex: 5,
          child: ContentBottomItemList(),
        )
      ],
    );
  }
}

class _BottomWidgetMulti extends StatelessWidget {
  const _BottomWidgetMulti();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ContentBottom2BossList(),
        )
      ],
    );
  }
}
