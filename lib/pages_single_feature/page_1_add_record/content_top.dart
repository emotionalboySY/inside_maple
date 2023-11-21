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
  const TopItemsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Get.defaultDialog(
              backgroundColor: Colors.white,
              buttonColor: Colors.white,
              radius: 5.0,
              title: "선택지 초기화",
              content: const Text(
                "선택한 보스와 난이도를 초기화 하시겠습니까?",
              ),
              confirm: SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Get.find<AddRecordController>().resetSelected();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "초기화",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              cancel: SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "취소",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              textCancel: "취소",
              barrierDismissible: false,
            );
          },
          child: const Text(
            "선택지 초기화",
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
