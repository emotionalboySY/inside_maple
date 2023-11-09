import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/RecordController.dart';

import '../constants.dart';

class PageAddRecord extends StatelessWidget {
  PageAddRecord({super.key});

  final recordController = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _topItems(),
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
          _topItemsDifficulty(),
          _topItemsMenu(),
        ],
      ),
    );
  }

  Widget _topItemsDifficulty() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "보스:",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton(
              value: recordController.selectedBoss.value,
              items: recordController.bossList
                  .map(
                    (element) => DropdownMenuItem(
                      value: element,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          element.korName,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (selectedValue) {
                recordController.selectBoss(selectedValue!);
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "난이도:",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: const Text("난이도 선택"),
              items: recordController.diffList.isEmpty
                  ? []
                  : recordController.diffList
                      .map(
                        (element) => DropdownMenuItem(
                          value: element,
                          child: Text(
                            element,
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (selectedValue) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _topItemsMenu() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("추후 추가 예정"),
      ],
    );
  }
}
