// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/record_manage_single.dart';
//
// class ContentBottomSingleBossList extends StatelessWidget {
//   ContentBottomSingleBossList({super.key});
//
//   final recordSingleController = Get.find<RecordManageSingleController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => recordSingleController.selectedWeekType.value == null
//       ? const Center(
//         child: Text(
//           "주차를 먼저 선택해 주세요.",
//         ),
//       )
//       : ListView.builder(
//         itemCount: recordSingleController.recordListExactWeekType.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(
//               "${recordSingleController.recordListExactWeekType[index].boss.korName}"
//                   " (${recordSingleController.recordListExactWeekType[index].difficulty.korName})",
//             ),
//             trailing: const Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.black,
//               size: 16,
//             ),
//             onTap: recordSingleController.selectedRecordData.value == recordSingleController.recordListExactWeekType[index] ? null : () async {
//               await recordSingleController.selectRecord(index);
//             },
//             selected: recordSingleController.selectedRecordData.value == recordSingleController.recordListExactWeekType[index],
//             selectedTileColor: Colors.deepPurple.shade100.withOpacity(0.7),
//             selectedColor: Colors.black,
//             titleTextStyle: TextStyle(
//               fontWeight: recordSingleController.selectedRecordData.value == recordSingleController.recordListExactWeekType[index] ? FontWeight.w700 : FontWeight.w400,
//               color: Colors.black,
//               fontSize: 16,
//               fontFamily: "Pretendard",
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
