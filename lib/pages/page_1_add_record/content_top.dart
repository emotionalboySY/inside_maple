import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record.dart';

import '../../constants.dart';
import '../../model/boss.dart';

class TopItemsDifficulty extends StatelessWidget {
  TopItemsDifficulty({super.key});

  final addRecordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
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
          () => Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  focusColor: Theme.of(context).scaffoldBackgroundColor,
                  hint: const Text("보스 선택"),
                  value: addRecordController.selectedBoss.value,
                  items: addRecordController.bossList
                      .map(
                        (element) => DropdownMenuItem(
                          value: element,
                          child: Text(
                            element.name,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (selectedValue) {
                    addRecordController.selectBoss(selectedValue!);
                  },
                  selectedItemBuilder: (context) {
                    return addRecordController.bossList
                        .map(
                          (Boss value) => Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value.name,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 60.0),
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
          () => Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: SizedBox(
              width: 170,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<Difficulty>(
                    focusColor: Theme.of(context).scaffoldBackgroundColor,
                    hint: const Text("난이도 선택"),
                    value: addRecordController.selectedDiff.value,
                    items: addRecordController.diffList.isEmpty
                        ? []
                        : addRecordController.diffList
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
                      addRecordController.selectDiff(selectedValue!);
                    },
                    selectedItemBuilder: (context) {
                      return addRecordController.diffList.map((Difficulty value) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value.korName,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TopItemsMenu extends StatelessWidget {
  TopItemsMenu({super.key});

  final addRecordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: TextButton(
            onPressed: () async {
              await Get.dialog(
                barrierDismissible: false,
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 0,
                  title: const Text(
                    "선택지 초기화"
                  ),
                  content: const Text(
                    "선택한 보스와 난이도를 초기화 하시겠습니까?"
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "취소",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextButton(
                        onPressed: () {
                          addRecordController.resetAll();
                          Get.back();
                        },
                        child: const Text(
                          "초기화",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              );
            },
            child: const Text(
              "선택지 초기화",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15.0, left: 5.0),
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
      ],
    );
  }
}
