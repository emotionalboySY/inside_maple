import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record.dart';

class BottomItemDropItemList extends StatelessWidget {
  BottomItemDropItemList({super.key});

  final addRecordController = Get.find<AddRecordController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => addRecordController.itemList.isEmpty
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
                      const Text(
                        "아이템 이름 보이기",
                      ),
                      Checkbox(
                        value: addRecordController.showLabel.value,
                        onChanged: (value) {
                          addRecordController.showLabel.value = value!;
                        },
                      )
                    ]
                  )
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(right: 20.0),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: addRecordController.showLabel.value ? 300 : 60,
                      mainAxisExtent: 60,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                    ),
                    itemCount: addRecordController.itemList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          addRecordController.addItem(addRecordController.itemList[index]);
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
                                  addRecordController.itemList[index].imagePath,
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.contain,
                                ),
                                if (addRecordController.showLabel.value)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(
                                        addRecordController.itemList[index].korLabel,
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
