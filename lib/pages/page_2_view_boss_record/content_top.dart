// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:inside_maple/controllers/record_manage_data.dart';
// import 'package:inside_maple/controllers/record_manage_multi.dart';
// import 'package:inside_maple/controllers/record_manage_multi_edit.dart';
// import 'package:inside_maple/controllers/record_manage_single_edit.dart';
//
// import '../../controllers/record_manage_single.dart';
//
// class ViewBossRecordTop extends StatelessWidget {
//   ViewBossRecordTop({super.key});
//
//   final recordManageDataController = Get.find<RecordManageDataController>();
//   final recordManageSingleController = Get.find<RecordManageSingleController>();
//   final recordManageSingleEditController = Get.find<RecordManageSingleEditController>();
//   final recordManageMultiController = Get.find<RecordManageMultiController>();
//   final recordManageMultiEditController = Get.find<RecordManageMultiEditController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 60,
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _radioButtons(),
//           _topMenus(),
//         ],
//       ),
//     );
//   }
//
//   Widget _radioButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: _radioComponent(
//             title: "단일 기록만 보기",
//             value: 1,
//           ),
//         ),
//         const SizedBox(
//           width: 16,
//         ),
//         _radioComponent(
//           title: "여러 날짜, 여러 보스 모아보기",
//           value: 2,
//         ),
//         Obx(
//           () => Padding(
//             padding: const EdgeInsets.only(left: 32.0),
//             child: AnimatedToggleSwitch.dual(
//               current: recordManageDataController.isMVPSilver.value,
//               first: false,
//               second: true,
//               onChanged: (value) {
//                 recordManageDataController.toggleMVP();
//               },
//               height: 30,
//               spacing: 10,
//               indicatorSize: const Size.fromWidth(40),
//               borderWidth: 3.0,
//               style: const ToggleStyle(
//                 borderColor: Colors.transparent,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     spreadRadius: 1,
//                     blurRadius: 2,
//                     offset: Offset(0, 1.5),
//                   ),
//                 ],
//                 indicatorColor: Colors.white,
//               ),
//               styleBuilder: (value) => ToggleStyle(backgroundColor: value ? Colors.grey.shade500 : Colors.brown),
//               textBuilder: (value) => value
//                   ? const Center(
//                       child: Text(
//                         "실버▲",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                     )
//                   : const Center(
//                       child: Text(
//                         "브론즈",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//               customIconBuilder: (context, local, global) {
//                 return const Text(
//                   "MVP",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 );
//               },
//               iconAnimationCurve: Curves.easeInOut,
//               indicatorTransition: const ForegroundIndicatorTransition.fading(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _radioComponent({
//     required String title,
//     required int value,
//   }) {
//     return Row(
//       children: [
//         Obx(
//           () => Radio<int>(
//             value: value,
//             groupValue: recordManageDataController.viewMode.value,
//             onChanged: (value) {
//               recordManageDataController.viewMode.value = value!;
//               if(value == 1) {
//                 recordManageMultiController.resetAll();
//               }
//               else if(value == 2) {
//               }
//             },
//             splashRadius: 0.0,
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             recordManageDataController.viewMode.value = value;
//           },
//           child: Text(
//             title,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _topMenus() {
//     return Obx(
//       () => Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           recordManageDataController.viewMode.value == 1 ? _topMenuSingle() : const SizedBox.shrink(),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15.0, left: 5.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.back();
//               },
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//                 backgroundColor: Colors.deepPurple,
//               ),
//               child: const Center(
//                 child: Text(
//                   "나가기",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _topMenuSingle() {
//     return Row(
//       children: [
//         recordManageSingleEditController.selectedRecordData.value != null &&
//                 recordManageSingleController.isRecordEditMode.value &&
//                 recordManageSingleController.isRecordEdited.value
//             ? Padding(
//                 padding: const EdgeInsets.only(right: 16.0),
//                 child: TextButton(
//                   onPressed: () {
//                     recordManageSingleEditController.revertChanges();
//                   },
//                   child: const Text(
//                     "수정 내역 초기화",
//                   ),
//                 ),
//               )
//             : const SizedBox.shrink(),
//         recordManageSingleEditController.selectedRecordData.value != null
//             ? Padding(
//                 padding: const EdgeInsets.only(right: 16.0),
//                 child: TextButton(
//                   onPressed: () {
//                     if (recordManageSingleController.isRecordEditMode.value) {
//                       recordManageSingleEditController.saveChanges();
//                     } else {
//                       recordManageSingleController.toggleEditMode();
//                     }
//                   },
//                   child: Text(
//                     recordManageSingleController.isRecordEditMode.value ? "저장" : "수정",
//                     style: const TextStyle(
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               )
//             : const SizedBox.shrink(),
//       ],
//     );
//   }
// }
