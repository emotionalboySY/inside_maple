import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_manage_multi_edit_controller.dart';
import 'package:oktoast/oktoast.dart';

import '../../../constants.dart';
import '../../../controllers/record_manage_multi_controller.dart';
import '../../../utils/utils.dart';

class ContentBottomMultiItemList extends StatelessWidget {
  ContentBottomMultiItemList({super.key});

  final recordManageMultiController = Get.find<RecordManageMultiController>();
  final recordManageMultiEditController = Get.find<RecordManageMultiEditController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => recordManageMultiEditController.itemsList.isNotEmpty
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
                  rightChild: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "평균 판매 단가",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: IconButton(
                            onPressed: () async {
                              await recordManageMultiEditController.showAvgPriceHelpDialog();
                            },
                            icon: Icon(
                              Icons.help_outline,
                              color: Colors.grey.shade500,
                              size: 15,
                            ),
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: recordManageMultiEditController.itemsList.length,
                    itemBuilder: (context, index) {
                      return _itemComponent(
                        isChild: true,
                        height: 50,
                        index: index,
                        leftChild: _leftChild(index: index),
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
                "왼쪽에서 검색할 보스 및 날짜 범위를 모두 선택해 주세요.",
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
            child: rightChild,
          ),
        ],
      ),
    );
  }

  Widget _leftChild({
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: GestureDetector(
        onTap: () async {
          await recordManageMultiEditController.showItemHistoryDialog(index);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ExtendedImage.asset(
              recordManageMultiEditController.itemsList[index].item.imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                recordManageMultiEditController.itemsList[index].item.korLabel,
              ),
            )
          ],
        ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                "${recordManageMultiEditController.itemsList[index].count.value}개",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rightChild({
    required int index,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => GestureDetector(
            onTap: () async {
              await recordManageMultiEditController.showPriceEditDialog(recordManageMultiEditController.itemsList[index].item);
            },
            child: Text(
              "${recordManageMultiEditController.f.format(recordManageMultiEditController.itemsList[index].price.value)} 메소",
              style: TextStyle(
                color: recordManageMultiEditController.flagList[recordManageMultiEditController.itemsList[index].item] == 1
                    ? Colors.red
                    : recordManageMultiEditController.flagList[recordManageMultiEditController.itemsList[index].item] == 2
                        ? Colors.blue
                        : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomComponent() {
    return SizedBox(
      height: 50,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "총 수익: ${recordManageMultiEditController.totalPriceLocale.value} 메소",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: IconButton(
                onPressed: () async {
                  await recordManageMultiController.showTotalHelpDialog();
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
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
