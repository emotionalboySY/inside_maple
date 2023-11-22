import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/record_controller.dart';

class ContentBottomItemList extends StatelessWidget {
  ContentBottomItemList({super.key});

  final recordController = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => recordController.selectedWeekTypeIndex.value != -1 && recordController.selectedRecordIndex.value != -1
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _itemComponent(
                    height: 40,
                    leftChild: const Center(
                      child: Text(
                        "아이템 이름",
                      ),
                    ),
                    centerChild: const Center(
                      child: Text(
                        "획득 개수",
                      ),
                    ),
                    rightChild: const Center(
                      child: Text(
                        "판매 단가(메소)",
                      ),
                    )),
                Expanded(
                  child: ListView.builder(
                    itemCount: recordController.selectedRecordData.value!.recordData!.itemList.length,
                    itemBuilder: (context, index) {
                      return _itemComponent(
                        height: 50,
                        leftChild: Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ExtendedImage.asset(
                                recordController.selectedRecordData.value!.recordData!.itemList[index].itemData.imagePath,
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  recordController.selectedRecordData.value!.recordData!.itemList[index].itemData.korLabel,
                                ),
                              )
                            ],
                          ),
                        ),
                        centerChild: Center(
                          child: Text(
                            "${recordController.selectedRecordData.value!.recordData!.itemList[index].count}개",
                          ),
                        ),
                        rightChild: Center(
                          child: Text(
                            "${recordController.selectedRecordData.value!.recordData!.itemList[index].price} 메소",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                "주차와 보스를 먼저 선택해 주세요.",
              ),
            ),
    );
  }

  Widget _itemComponent({
    required Widget leftChild,
    required Widget centerChild,
    required Widget rightChild,
    required double height,
  }) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: leftChild,
          ),
          Expanded(
            flex: 1,
            child: centerChild,
          ),
          Expanded(
            flex: 3,
            child: rightChild,
          ),
        ],
      ),
    );
  }
}
