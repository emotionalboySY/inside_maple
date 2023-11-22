import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/controllers/add_record_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../custom_icons_icons.dart';

class ContentBottomSelectedList extends StatelessWidget {
  ContentBottomSelectedList({super.key});

  final addRecordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              itemCount: addRecordController.selectedItemList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 13.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            "선택된 아이템",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            "수량",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            "삭제",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 17.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ExtendedImage.asset(
                                  addRecordController.selectedItemList[index - 1].itemData.imagePath,
                                  width: 25,
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    addRecordController.selectedItemList[index - 1].itemData.korLabel,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              itemCanDuplicated.contains(addRecordController.selectedItemList[index - 1].itemData)
                                  ? IconButton(
                                      onPressed: addRecordController.selectedItemList[index - 1].count == 1 ? null : () {
                                        addRecordController.decreaseItem(index - 1);
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                      ),
                                      style: IconButton.styleFrom(
                                        padding: const EdgeInsets.all(0.0),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        hoverColor: Colors.transparent,
                                      ),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  addRecordController.selectedItemList[index - 1].count.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              itemCanDuplicated.contains(addRecordController.selectedItemList[index - 1].itemData)
                                  ? IconButton(
                                      onPressed: () {
                                        addRecordController.increaseItem(index - 1);
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                      ),
                                      style: IconButton.styleFrom(
                                        padding: const EdgeInsets.all(0.0),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        hoverColor: Colors.transparent,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: IconButton(
                            onPressed: () {
                              addRecordController.removeItem(index - 1);
                            },
                            icon: const Icon(
                              CustomIcons.trashEmpty,
                              size: 18.0,
                            ),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              hoverColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
        _RaidDatePicker(),
        _RaidPartyAmount(),
        SizedBox(
          width: double.infinity,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
            child: Obx(
              () => ElevatedButton(
                onPressed: addRecordController.selectedDate.value != DateTime(1900, 01, 01) && addRecordController.selectedItemList.isNotEmpty
                    ? () {
                        addRecordController.saveRecordData();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  disabledBackgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: addRecordController.saveStatus.value
                    ? Center(
                        child: LoadingAnimationWidget.prograssiveDots(
                          color: Colors.white,
                          size: 12.0,
                        ),
                      )
                    : Text(
                        "저장",
                        style: TextStyle(
                          color: addRecordController.selectedDate.value != DateTime(1900, 01, 01) && addRecordController.selectedItemList.isNotEmpty ? Colors.white : Colors.black54,
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

class _RaidDatePicker extends StatelessWidget {

  final recordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Row(
          children: [
            const Text("레이드 진행 날짜: "),
            Obx(
              () => recordController.selectedDate.value == DateTime(1900, 01, 01)
                  ? TextButton(
                      onPressed: () async {
                        await recordController.pickDate();
                      },
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.all(0.0),
                        minimumSize: Size.zero,
                      ),
                      child: const Text("날짜 선택"),
                    )
                  : Text(
                      "${recordController.selectedDate.value.year}년 ${recordController.selectedDate.value.month}월 ${recordController.selectedDate.value.day}일",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Obx(
              () => recordController.selectedDate.value != DateTime(1900, 01, 01)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: TextButton(
                        onPressed: () async {
                          await recordController.pickDate();
                        },
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0.0),
                          minimumSize: Size.zero,
                        ),
                        child: const Text("날짜 변경"),
                      ),
                    )
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}

class _RaidPartyAmount extends StatelessWidget {
  _RaidPartyAmount({super.key});

  final addRecordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "파티 인원 수: ",
          ),
          Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                focusColor: Theme.of(context).scaffoldBackgroundColor,
                value: addRecordController.selectedPartyAmount.value,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurple,
                ),
                onChanged: (newValue) {
                  addRecordController.selectedPartyAmount.value = newValue!;
                },
                items: <int>[1, 2, 3, 4, 5, 6].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value.toString(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Text(
            "명",
          )
        ],
      ),
    );
  }
}

