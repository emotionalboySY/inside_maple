import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';

import '../../controllers/record_controller.dart';
import '../../custom_icons_icons.dart';

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
                  index: -1,
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
                    itemCount: recordController.selectedRecordData.value!.itemList.length,
                    itemBuilder: (context, index) {
                      return _itemComponent(
                        isChild: true,
                        height: 50,
                        index: index,
                        leftChild: Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ExtendedImage.asset(
                                recordController.selectedRecordData.value!.itemList[index].item.imagePath,
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  recordController.selectedRecordData.value!.itemList[index].item.korLabel,
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
                _bottomParameters(),
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
    required int index,
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
                          onPressed: () {
                            recordController.removeItem(index);
                          },
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
            recordController.isRecordEditMode.value && itemCanDuplicated.contains(recordController.selectedRecordData.value!.itemList[index].item)
                ? Obx(() => IconButton(
                      onPressed: recordController.selectedRecordData.value!.itemList[index].count.value == 1
                          ? null
                          : () {
                              recordController.decreaseItemCount(index);
                            },
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                    ))
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                "${recordController.selectedRecordData.value!.itemList[index].count.value}개",
                style: TextStyle(
                  color: recordController.selectedRecordData.value!.itemList[index].count.value == recordController.selectedRecordDataOriginal.value!.itemList[index].count.value
                      ? Colors.black
                      : Colors.red,
                ),
              ),
            ),
            recordController.isRecordEditMode.value && itemCanDuplicated.contains(recordController.selectedRecordData.value!.itemList[index].item)
                ? IconButton(
                    onPressed: () {
                      recordController.increaseItemCount(index);
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
    return recordController.isRecordEditMode.value
        ? Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 25,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (RawKeyEvent event) {
                      if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                        FocusScope.of(Get.context!).unfocus();
                        recordController.applyPrice(index);
                      }
                    },
                    child: TextField(
                      controller: recordController.itemPriceControllers[index],
                      focusNode: recordController.itemFocusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: recordController.f.format(recordController.selectedRecordData.value!.itemList[index].price.value),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: recordController.selectedRecordData.value!.itemList[index].price.value == recordController.selectedRecordDataOriginal.value!.itemList[index].price.value
                                ? Colors.black
                                : Colors.red,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: recordController.selectedRecordData.value!.itemList[index].price.value == recordController.selectedRecordDataOriginal.value!.itemList[index].price.value
                            ? Colors.black
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "메소",
                    style: TextStyle(
                      color: recordController.selectedRecordData.value!.itemList[index].price.value == recordController.selectedRecordDataOriginal.value!.itemList[index].price.value
                          ? Colors.black
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: Text(
              "${recordController.f.format(recordController.selectedRecordData.value!.itemList[index].price.value)} 메소",
            ),
          );
  }

  Widget _bottomParameters() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "파티 인원: ",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              recordController.isRecordEditMode.value
                  ? DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  focusColor: Theme.of(Get.context!).scaffoldBackgroundColor,
                  value: recordController.selectedRecordData.value!.partyAmount.value,
                  iconSize: 20,
                  onChanged: (newValue) {
                    recordController.selectedRecordData.value!.partyAmount.value = newValue!;
                  },
                  items: <int>[1, 2, 3, 4, 5, 6].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        "${value.toString()}명",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Pretendard",
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
                  : Text(
                "${recordController.selectedRecordData.value!.partyAmount.value}명",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Pretendard",
                  fontSize: 14,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "MVP:",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              recordController.isRecordEditMode.value
                  ? _radioButtonsForMVP()
                  : Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  recordController.isMvpSilver.value ? "실버 이상" : "브론즈 이하",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Pretendard",
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: TextButton(
              onPressed: () async {
                await recordController.removeBossRecord();
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
              ),
              child: const Text(
                "삭제하기",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          )
        ],
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
                    "총 수익: ${recordController.totalItemPriceLocale.value} 메소",
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

  Widget _radioButtonsForMVP() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: _radioComponent(
            title: "브론즈 이하",
            value: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: _radioComponent(
            title: "실버 이상",
            value: true,
          ),
        ),
      ],
    );
  }
  Widget _radioComponent({
    required String title,
    required bool value,
  }) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: SizedBox(
            width: 20,
            height: 20,
            child: Radio<bool>(
              value: value,
              groupValue: recordController.isMvpSilver.value,
              onChanged: (value) {
                recordController.isMvpSilver.value = value!;
                recordController.calculateTotalPrices();
              },
              splashRadius: 0.0,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            recordController.isMvpSilver.value = value;
          },
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: recordController.isMvpSilver.value == value ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
