import 'package:flutter/material.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/content_bottom_week_type_list.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/content_top.dart';

import 'content_bottom_boss_list.dart';
import 'content_bottom_item_list.dart';

class PageViewBossRecord extends StatelessWidget {
  const PageViewBossRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ViewBossRecordTop(),
          separator(axis: Axis.horizontal),
          Expanded(
            child: _BottomWidget(),
          ),
        ],
      ),
    );
  }
}

class _BottomWidget extends StatelessWidget {
  _BottomWidget({super.key});

  final listViewController = ScrollController();

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
