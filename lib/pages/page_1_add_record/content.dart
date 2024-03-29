import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record.dart';
import 'package:inside_maple/pages/page_1_add_record/content_bottom_item_grid.dart';
import 'package:inside_maple/pages/page_1_add_record/content_top.dart';

import '../../utils/index.dart';
import 'content_bottom_selected_list.dart';

class PageAddRecord extends StatelessWidget {
  PageAddRecord({super.key});

  final addRecordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => switch(addRecordController.bossList.isNotEmpty) {
          true => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _topItems(),
              separator(axis: Axis.horizontal),
              Expanded(
                child: _bottomItems(),
              ),
            ],
          ),
          false => const Center(
            child: CircularProgressIndicator(),
          ),
        }
      ),
    );
  }

  Widget _topItems() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          TopItemsDifficulty(),
          TopItemsMenu(),
        ],
      ),
    );
  }

  Widget _bottomItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: BottomItemDropItemList(),
          ),
        ),
        separator(axis: Axis.vertical),
        Expanded(
          flex: 1,
          child: ContentBottomSelectedList(),
        )
      ],
    );
  }
}
