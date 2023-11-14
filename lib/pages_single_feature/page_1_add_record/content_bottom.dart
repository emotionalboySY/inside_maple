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
                CheckboxListTile(
                  title: const Text("아이템 이름 보이기"),
                  value: recordController.showLabel.value,
                  onChanged: (bool? value) {
                    recordController.toggleShowLabel();
                  },
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: recordController.itemListLength.value,
                      mainAxisExtent: 50,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                    ),
                    itemCount: recordController.itemList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ExtendedImage.asset(
                                recordController.itemList[index].imagePath,
                                width: 25,
                                height: 25,
                                fit: BoxFit.contain,
                              ),
                            ),
                            if (recordController.showLabel.value)
                              Text(
                                recordController.itemList[index].korLabel,
                              ),
                          ],
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
