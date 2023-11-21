import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record_controller.dart';

class BottomItemDropItemList extends StatelessWidget {
  BottomItemDropItemList({super.key});

  final recordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => recordController.itemList.isEmpty
          ? const Center(
              child: Text(
                "상단 보스 및 난이도를 먼저 선택해 주세요",
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "아이템 이름 보이기",
                      ),
                      Checkbox(
                        value: recordController.showLabel.value,
                        onChanged: (value) {
                          recordController.showLabel.value = value!;
                        },
                      )
                    ]
                  )
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(right: 20.0),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: recordController.showLabel.value ? 300 : 60,
                      mainAxisExtent: 60,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                    ),
                    itemCount: recordController.itemList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          recordController.addItem(recordController.itemList[index]);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ExtendedImage.asset(
                                  recordController.itemList[index].imagePath,
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.contain,
                                ),
                                if (recordController.showLabel.value)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(
                                        recordController.itemList[index].korLabel,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
