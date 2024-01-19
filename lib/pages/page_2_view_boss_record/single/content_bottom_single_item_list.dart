// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:inside_maple/constants.dart';
// import 'package:inside_maple/controllers/record_manage_single_edit.dart';
// import 'package:intl/intl.dart';
//
// import '../../../controllers/record_manage_single.dart';
// import '../../../custom_icons_icons.dart';
// import '../../../utils/logger.dart';
// import '../../../utils/index.dart';
//
// class ContentBottomSingleItemList extends StatelessWidget {
//   ContentBottomSingleItemList({super.key});
//
//   final recordManageSingleController = Get.find<RecordManageSingleController>();
//   final recordManageSingleEditController = Get.find<RecordManageSingleEditController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => recordManageSingleController.selectedWeekType.value != null && recordManageSingleEditController.selectedRecordData.value != null
//           ? Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 _itemComponent(
//                   isChild: false,
//                   height: 40,
//                   index: -1,
//                   leftChild: const Center(
//                     child: Text(
//                       "아이템 이름",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                   centerChild: const Center(
//                     child: Text(
//                       "획득 개수",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                   rightChild: const Center(
//                     child: Text(
//                       "판매 단가(메소)",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: recordManageSingleEditController.selectedRecordData.value!.itemList.length,
//                     itemBuilder: (context, index) {
//                       return _itemComponent(
//                         isChild: true,
//                         height: 50,
//                         index: index,
//                         leftChild: Padding(
//                           padding: const EdgeInsets.only(left: 32.0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               ExtendedImage.asset(
//                                 recordManageSingleEditController.selectedRecordData.value!.itemList[index].item.imagePath,
//                                 width: 30,
//                                 height: 30,
//                                 fit: BoxFit.contain,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(
//                                   recordManageSingleEditController.selectedRecordData.value!.itemList[index].item.korLabel,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         centerChild: _centerChild(index: index),
//                         rightChild: _rightChild(index: index),
//                       );
//                     },
//                   ),
//                 ),
//                 _bottomParameters(),
//                 separator(axis: Axis.horizontal),
//                 _bottomComponent(),
//               ],
//             )
//           : const Center(
//               child: Text(
//                 "주차와 보스를 먼저 선택해 주세요.",
//               ),
//             ),
//     );
//   }
//
//   Widget _itemComponent({
//     required bool isChild,
//     required Widget leftChild,
//     required Widget centerChild,
//     required Widget rightChild,
//     required double height,
//     required int index,
//   }) {
//     return SizedBox(
//       height: height,
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: leftChild,
//           ),
//           Expanded(
//             flex: 1,
//             child: centerChild,
//           ),
//           Expanded(
//             flex: 3,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: rightChild,
//                 ),
//                 recordManageSingleController.isRecordEditMode.value
//                     ? Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: IconButton(
//                           icon: Icon(
//                             CustomIcons.trashEmpty,
//                             size: 20,
//                             color: isChild ? Colors.black : Colors.transparent,
//                           ),
//                           onPressed: () {
//                             recordManageSingleEditController.deleteItem(index);
//                           },
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _centerChild({
//     required int index,
//   }) {
//     return Obx(
//       () => Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             recordManageSingleController.isRecordEditMode.value &&
//                     itemCanDuplicated.contains(recordManageSingleEditController.selectedRecordData.value!.itemList[index].item)
//                 ? Obx(() => IconButton(
//                       onPressed: recordManageSingleEditController.selectedRecordData.value!.itemList[index].count.value == 1
//                           ? null
//                           : () {
//                               recordManageSingleEditController.decreaseItemCount(index);
//                             },
//                       icon: const Icon(Icons.remove),
//                       style: IconButton.styleFrom(
//                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         padding: EdgeInsets.zero,
//                         minimumSize: Size.zero,
//                       ),
//                     ))
//                 : const SizedBox.shrink(),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5.0),
//               child: Text(
//                 "${recordManageSingleEditController.selectedRecordData.value!.itemList[index].count.value}개",
//                 style: TextStyle(
//                   color: recordManageSingleEditController.selectedRecordData.value!.itemList[index].count.value ==
//                           recordManageSingleController.selectedRecordData.value!.itemList[index].count.value
//                       ? Colors.black
//                       : Colors.red,
//                 ),
//               ),
//             ),
//             recordManageSingleController.isRecordEditMode.value &&
//                     itemCanDuplicated.contains(recordManageSingleEditController.selectedRecordData.value!.itemList[index].item)
//                 ? IconButton(
//                     onPressed: () {
//                       recordManageSingleEditController.increaseItemCount(index);
//                     },
//                     icon: const Icon(Icons.add),
//                     style: IconButton.styleFrom(
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size.zero,
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _rightChild({
//     required int index,
//   }) {
//     return recordManageSingleController.isRecordEditMode.value
//         ? Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 150,
//                   height: 25,
//                   child: RawKeyboardListener(
//                     focusNode: FocusNode(),
//                     onKey: (RawKeyEvent event) {
//                       if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
//                         FocusScope.of(Get.context!).unfocus();
//                         recordManageSingleEditController.applyPrice(index);
//                       }
//                     },
//                     child: TextField(
//                       controller: recordManageSingleController.itemPriceControllers[index],
//                       focusNode: recordManageSingleController.itemFocusNodes[index],
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.end,
//                       decoration: InputDecoration(
//                         hintText: recordManageSingleController.f.format(recordManageSingleEditController.selectedRecordData.value!.itemList[index].price.value),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                             color: recordManageSingleEditController.selectedRecordData.value!.itemList[index].price.value ==
//                                     recordManageSingleController.selectedRecordData.value!.itemList[index].price.value
//                                 ? Colors.black
//                                 : Colors.red,
//                           ),
//                         ),
//                       ),
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: recordManageSingleEditController.selectedRecordData.value!.itemList[index].price.value ==
//                                 recordManageSingleController.selectedRecordData.value!.itemList[index].price.value
//                             ? Colors.black
//                             : Colors.red,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 5.0),
//                   child: Text(
//                     "메소",
//                     style: TextStyle(
//                       color: recordManageSingleEditController.selectedRecordData.value!.itemList[index].price.value ==
//                               recordManageSingleController.selectedRecordData.value!.itemList[index].price.value
//                           ? Colors.black
//                           : Colors.red,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Center(
//             child: Text(
//               "${recordManageSingleController.f.format(recordManageSingleEditController.selectedRecordData.value!.itemList[index].price.value)} 메소",
//             ),
//           );
//   }
//
//   Widget _bottomParameters() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               const Text(
//                 "날짜: ",
//                 style: TextStyle(
//                   fontSize: 14,
//                 ),
//               ),
//               Text(
//                 DateFormat('yyyy년 MM월 dd일').format(recordManageSingleEditController.selectedRecordData.value!.date),
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 24,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "파티 인원: ",
//                       style: TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                     recordManageSingleController.isRecordEditMode.value
//                         ? DropdownButtonHideUnderline(
//                             child: DropdownButton<int>(
//                               elevation: 0,
//                               padding: EdgeInsets.zero,
//                               isDense: true,
//                               focusColor: Theme.of(Get.context!).scaffoldBackgroundColor,
//                               value: recordManageSingleEditController.selectedRecordData.value!.partyAmount.value,
//                               iconSize: 20,
//                               onChanged: (newValue) {
//                                 loggerNoStack.d("before update(Existing): ${recordManageSingleController.selectedRecordData.value!}");
//                                 loggerNoStack.d("before update(cloned): ${recordManageSingleEditController.selectedRecordData.value!}");
//                                 recordManageSingleEditController.selectedRecordData.value!.partyAmount.value = newValue!;
//                                 loggerNoStack.d("after update(Existing): ${recordManageSingleController.selectedRecordData.value!}");
//                                 loggerNoStack.d("after update(cloned): ${recordManageSingleEditController.selectedRecordData.value!}");
//                                 recordManageSingleController.updateIsRecordEdited();
//                               },
//                               items: <int>[1, 2, 3, 4, 5, 6].map<DropdownMenuItem<int>>((int value) {
//                                 return DropdownMenuItem<int>(
//                                   value: value,
//                                   child: Text(
//                                     "${value.toString()}명",
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "Pretendard",
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           )
//                         : Text(
//                             "${recordManageSingleEditController.selectedRecordData.value!.partyAmount.value}명",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontFamily: "Pretendard",
//                               fontSize: 14,
//                             ),
//                           ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 14.0),
//                   child: TextButton(
//                     onPressed: () async {
//                       await recordManageSingleController.removeBossRecord();
//                     },
//                     style: ButtonStyle(
//                       overlayColor: MaterialStateProperty.all(Colors.transparent),
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       padding: MaterialStateProperty.all(EdgeInsets.zero),
//                       minimumSize: MaterialStateProperty.all(Size.zero),
//                     ),
//                     child: const Text(
//                       "삭제하기",
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _bottomComponent() {
//     return SizedBox(
//       height: 50,
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Expanded(
//             child: Center(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "총 수익: ${recordManageSingleController.totalItemPriceLocale.value} 메소",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 16,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 5.0),
//                     child: IconButton(
//                       onPressed: () async {
//                         await recordManageSingleController.showTotalHelpDialog();
//                       },
//                       icon: Icon(
//                         Icons.help_outline,
//                         size: 16,
//                         color: Colors.grey.shade500,
//                       ),
//                       style: IconButton.styleFrom(
//                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         padding: EdgeInsets.zero,
//                         minimumSize: Size.zero,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           separator(axis: Axis.vertical),
//           Expanded(
//             child: Center(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "1인당 분배금: ${recordManageSingleController.totalItemPriceAfterDivisionLocale.value} 메소",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 16,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 5.0),
//                     child: IconButton(
//                       onPressed: () async {
//                         await recordManageSingleController.showDivisionHelpDialog();
//                       },
//                       icon: Icon(
//                         Icons.help_outline,
//                         size: 16,
//                         color: Colors.grey.shade500,
//                       ),
//                       style: IconButton.styleFrom(
//                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         padding: EdgeInsets.zero,
//                         minimumSize: Size.zero,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
