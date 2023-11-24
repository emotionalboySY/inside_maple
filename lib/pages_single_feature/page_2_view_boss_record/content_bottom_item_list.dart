import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';

import '../../controllers/record_controller.dart';
import '../../custom_icons_icons.dart';
import '../../data.dart';
import '../../utils/logger.dart';

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
                  isChild: false,
                  height: 40,
                  leftChild: const Center(
                    child: Text(
                      "아이템 이름",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  centerChild: const Center(
                    child: Text(
                      "획득 개수",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  rightChild: const Center(
                    child: Text(
                      "판매 단가(메소)",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: recordController.selectedRecordData.value.recordData!.itemList.length,
                    itemBuilder: (context, index) {
                      return _itemComponent(
                        isChild: true,
                        height: 50,
                        leftChild: Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ExtendedImage.asset(
                                recordController.selectedRecordData.value.recordData!.itemList[index].itemData.imagePath,
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  recordController.selectedRecordData.value.recordData!.itemList[index].itemData.korLabel,
                                ),
                              )
                            ],
                          ),
                        ),
                        centerChild: _centerChild(index: index),
                        rightChild: _rightChild(index: index),
                      );
                    },
                  ),
                ),
                separator(axis: Axis.horizontal),
                _bottomComponent(),
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
    required bool isChild,
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
            child: Row(
              children: [
                Expanded(
                  child: rightChild,
                ),
                recordController.isRecordEditMode.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          icon: Icon(
                            CustomIcons.trashEmpty,
                            size: 20,
                            color: isChild ? Colors.black : Colors.transparent,
                          ),
                          onPressed: () {},
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerChild({
    required int index,
  }) {
    return Obx(
      () => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            recordController.isRecordEditMode.value &&
                    itemCanDuplicated.contains(recordController.selectedRecordData.value.recordData!.itemList[index].itemData)
                ? IconButton(
                    onPressed: recordController.selectedRecordData.value.recordData!.itemList[index].count == 1
                        ? null
                        : () {
                            recordController.decreaseItemCount();
                          },
                    icon: const Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                "${recordController.selectedRecordData.value.recordData!.itemList[index].count}개",
              ),
            ),
            recordController.isRecordEditMode.value &&
                    itemCanDuplicated.contains(recordController.selectedRecordData.value.recordData!.itemList[index].itemData)
                ? IconButton(
                    onPressed: () {
                      recordController.increaseItemCount();
                    },
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _rightChild({
    required int index,
  }) {
    TextEditingController priceController = TextEditingController();
    return recordController.isRecordEditMode.value
        ? Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 150,
                  height: 30,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (RawKeyEvent event) {
                      if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                        FocusScope.of(Get.context!).unfocus();
                        recordController.setItemPrice(index, int.parse(priceController.text));
                        recordController.calculateTotalPrices();
                      }
                    },
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: recordController.selectedRecordData.value.recordData!.itemList[index].price.toString(),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    "메소",
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: Text(
              "${recordController.selectedRecordData.value.recordData!.itemList[index].price} 메소",
            ),
          );
  }

  Widget _bottomComponent() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "총 합계: ${recordController.totalItemPriceLocale.value} 메소",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: IconButton(
                      onPressed: () async {
                        await recordController.showTotalHelpDialog();
                      },
                      icon: Icon(
                        Icons.help_outline,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          separator(axis: Axis.vertical),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "1인당 분배금: ${recordController.totalItemPriceAfterDivisionLocale.value} 메소",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: IconButton(
                      onPressed: () async {
                        await recordController.showDivisionHelpDialog();
                      },
                      icon: Icon(
                        Icons.help_outline,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
