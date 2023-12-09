import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/multi/content_bottom_multi_item_list.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/content_top.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/single/content_bottom_single_item_list.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/single/content_bottom_single_week_type_list.dart';

import '../../controllers/record_manage_single_controller.dart';
import 'multi/content_bottom_multi_boss_list.dart';
import 'multi/content_bottom_multi_date_range_picker.dart';
import 'single/content_bottom_single_boss_list.dart';

class PageViewBossRecord extends StatelessWidget {
  PageViewBossRecord({super.key});

  final recordUIController = Get.find<RecordManageSingleController>();

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
          child: ContentBottomSingleWeekTypeList(),
        ),
        separator(axis: Axis.vertical),
        Expanded(
          flex: 2,
          child: ContentBottomSingleBossList(),
        ),
        separator(axis: Axis.vertical),
        Expanded(
          flex: 5,
          child: ContentBottomSingleItemList(),
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
          flex: 2,
          child: ContentBottomMultiBossList(),
        ),
        separator(axis: Axis.vertical),
        Expanded(
          flex: 2,
          child: ContentBottomMultiDateRangePicker(),
        ),
        separator(axis: Axis.vertical),
        Expanded(
          flex: 5,
          child: ContentBottomMultiItemList(),
        ),
      ],
    );
  }
}
