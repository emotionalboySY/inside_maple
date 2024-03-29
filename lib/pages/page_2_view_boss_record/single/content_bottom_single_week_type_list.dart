// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
//
// import '../../../constants.dart';
// import '../../../controllers/add_record.dart';
// import '../../../controllers/record_manage_single.dart';
//
// class ContentBottomSingleWeekTypeList extends StatelessWidget {
//   ContentBottomSingleWeekTypeList({super.key});
//
//   final recordController = Get.find<RecordManageSingleController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => switch (recordController.recordLoadStatus.value) {
//         LoadStatus.empty => const Center(
//             child: Text("아직 데이터가 로드되지 않았습니다."),
//           ),
//         LoadStatus.loading => Center(
//             child: LoadingAnimationWidget.prograssiveDots(
//               color: Colors.deepPurple,
//               size: 24.0,
//             ),
//           ),
//         LoadStatus.failed => const Center(
//             child: Text(
//               "보스 격파 데이터 로드에 실패하였습니다.",
//             ),
//           ),
//         LoadStatus.success => recordController.weekTypeList.isEmpty
//             ? Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "저장된 데이터가 없습니다.",
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Get.put(AddRecordController());
//                         Get.offNamed("/page/addRecord");
//                       },
//                       style: TextButton.styleFrom(
//                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         padding: EdgeInsets.zero,
//                         minimumSize: Size.zero,
//                       ),
//                       child: const Text(
//                         "새로운 보스 격파 기록을 추가해 보세요!",
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             : Obx(
//                 () => ListView.builder(
//                   itemCount: recordController.weekTypeList.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(
//                         recordController.weekTypeList[index].toTitleString(),
//                       ),
//                       subtitle: Text(
//                         recordController.weekTypeList[index].getPeriodKorString(),
//                         style: const TextStyle(
//                           fontSize: 13,
//                         ),
//                       ),
//                       trailing: const Icon(
//                         Icons.arrow_forward_ios,
//                         color: Colors.black,
//                         size: 16,
//                       ),
//                       onTap: recordController.weekTypeList.indexOf(recordController.selectedWeekType.value) == index ? null : () {
//                         recordController.selectWeekType(index);
//                       },
//                       selected: recordController.weekTypeList[index] == recordController.selectedWeekType.value,
//                       selectedTileColor: Colors.deepPurple.shade100.withOpacity(0.7),
//                       selectedColor: Colors.black,
//                       titleTextStyle: TextStyle(
//                         fontWeight: recordController.weekTypeList[index] == recordController.selectedWeekType.value ? FontWeight.w700 : FontWeight.w400,
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontFamily: "Pretendard",
//                       ),
//                     );
//                   },
//                 ),
//               ),
//       },
//     );
//   }
// }
