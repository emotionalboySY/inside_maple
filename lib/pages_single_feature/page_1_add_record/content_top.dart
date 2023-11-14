import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record_controller.dart';

import '../../constants.dart';

class TopItemsDifficulty extends StatelessWidget {
  TopItemsDifficulty({super.key});

  final recordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
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
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text("보스 선택"),
              ),
              value: recordController.selectedBoss.value,
              items: recordController.bossList
                  .map(
                    (element) => DropdownMenuItem(
                      value: element,
                      child: Text(
                        element.korName,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (selectedValue) {
                recordController.selectBoss(selectedValue!);
              },
              selectedItemBuilder: (context) {
                return recordController.bossList.map((Boss value) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        value.korName,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList();
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
            child: DropdownButton<Difficulty>(
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text("난이도 선택"),
              ),
              value: recordController.selectedDiff.value,
              items: recordController.diffList.isEmpty
                  ? []
                  : recordController.diffList
                      .map(
                        (Difficulty element) => DropdownMenuItem(
                          value: element,
                          child: Text(
                            element.korName,
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (selectedValue) {
                recordController.selectDiff(selectedValue!);
              },
              selectedItemBuilder: (context) {
                return recordController.diffList.map((Difficulty value) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        value.korName,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class TopItemsMenu extends StatelessWidget {
  const TopItemsMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
