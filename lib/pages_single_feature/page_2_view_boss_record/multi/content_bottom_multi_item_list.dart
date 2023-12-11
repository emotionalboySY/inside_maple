import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/record_manage_multi_edit_controller.dart';
import 'package:oktoast/oktoast.dart';

class ContentBottomMultiItemList extends StatelessWidget {
  ContentBottomMultiItemList({super.key});

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
                    itemCount: recordManageMultiEditController.itemsList.length,
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
                        centerChild: _centerChild(index: index),
                        rightChild: _rightChild(index: index),
                      );
                    },
                  ),
                ),
                // _bottomParameters(),
                // separator(axis: Axis.horizontal),
                // _bottomComponent(),
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
        Text(
          "${recordManageMultiEditController.f.format(recordManageMultiEditController.itemsList[index].price.value)} 메소",
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            onPressed: () {
              showToast("단가 수정 버튼 눌림.");
            },
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              hoverColor: Colors.transparent,
              shadowColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            icon: const Icon(
              Icons.edit,
              color: Colors.grey,
              size: 16,
            ),
          ),
        )
      ],
    );
  }
}
