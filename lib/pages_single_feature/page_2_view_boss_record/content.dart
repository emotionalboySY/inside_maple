import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/pages_single_feature/page_2_view_boss_record/content_bottom_week_type_list.dart';

class PageViewBossRecord extends StatelessWidget {
  const PageViewBossRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _TopWidget(),
          separator(axis: Axis.horizontal),
          const Expanded(
            child: _BottomWidget(),
          ),
        ],
      ),
    );
  }
}

class _TopWidget extends StatelessWidget {
  const _TopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                    ),
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

class _BottomWidget extends StatelessWidget {
  const _BottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ContentBottomWeekTypeList(),
        separator(axis: Axis.vertical),
      ],
    );
  }
}

