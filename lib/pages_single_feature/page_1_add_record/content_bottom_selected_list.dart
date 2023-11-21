import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ContentBottomSelectedList extends StatelessWidget {
  ContentBottomSelectedList({super.key});

  final recordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              itemCount: recordController.selectedItemList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                  recordController.selectedItemList[index - 1].itemData.imagePath,
                                  width: 25,
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    recordController.selectedItemList[index - 1].itemData.korLabel,
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
                              IconButton(
                                onPressed: () {
                                  recordController.decreaseItem(index - 1);
                                },
                                icon: const Icon(
                                  Icons.remove,
                                ),
                              ),
                              Text(
                                recordController.selectedItemList[index - 1].count.toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  recordController.increaseItem(index - 1);
                                },
                                icon: const Icon(
                                  Icons.add,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: IconButton(
                            onPressed: () {
                              recordController.removeItem(index - 1);
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => ElevatedButton(
                onPressed: recordController.selectedDate.value != DateTime(1900, 01, 01) && recordController.selectedItemList.isNotEmpty
                    ? () {
                        recordController.saveRecordData();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  disabledBackgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: recordController.saveStatus.value
                    ? Center(
                        child: LoadingAnimationWidget.prograssiveDots(
                          color: Colors.white,
                          size: 12.0,
                        ),
                      )
                    : Text(
                        "저장",
                        style: TextStyle(
                          color: recordController.selectedDate.value != DateTime(1900, 01, 01) && recordController.selectedItemList.isNotEmpty ? Colors.white : Colors.black54,
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
  _RaidDatePicker({super.key});

  final recordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
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
