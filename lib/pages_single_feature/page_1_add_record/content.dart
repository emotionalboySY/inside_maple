import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record_controller.dart';
import 'package:inside_maple/pages_single_feature/page_1_add_record/content_bottom.dart';
import 'package:inside_maple/pages_single_feature/page_1_add_record/content_top.dart';

import '../../constants.dart';

class PageAddRecord extends StatelessWidget {
  PageAddRecord({super.key});

  final recordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _topItems(),
          _separator(axis: Axis.horizontal),
          Expanded(
            child: _bottomItems(),
          ),
        ],
      ),
    );
  }

  Widget _topItems() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          TopItemsDifficulty(),
          const TopItemsMenu(),
        ],
      ),
    );
  }

  Widget _bottomItems() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        BottomItemDropItemList(),
      ],
    );
  }

  Widget _separator({
    required Axis axis,
  }) {
    return Container(
      width: (axis == Axis.vertical) ? 1 : double.infinity,
      height: (axis == Axis.horizontal) ? 1 : double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
    );
  }
}
