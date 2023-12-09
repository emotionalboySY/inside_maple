import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record_controller.dart';
import 'package:inside_maple/controllers/record_manage_data_controller.dart';

import 'controllers/main_controller.dart';
import 'controllers/record_manage_multi_controller.dart';
import 'controllers/record_manage_single_edit_controller.dart';
import 'controllers/record_manage_single_controller.dart';

class ContentMain extends StatelessWidget {
  ContentMain({super.key});

  final mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PopupMenuButton<int>(
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 1,
                            child: Text(
                              "문의하기"
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) async {
                        if (value == 1) {
                          await mainController.contactUs();
                        }
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: _menuButton(
                        onPressed: () async {
                          Get.put(RecordManageSingleController());
                          Get.put(RecordManageSingleEditController());
                          Get.put(RecordManageMultiController());
                          Get.put(RecordManageDataController());
                          Get.toNamed("/page/viewRecord")?.then((value) {
                            Get.delete<RecordManageSingleController>();
                            Get.delete<RecordManageSingleEditController>();
                            Get.delete<RecordManageMultiController>();
                            Get.delete<RecordManageDataController>();
                          });
                        },
                        title: "보스 리워드 관리",
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: _menuButton(
                        onPressed: () {
                          Get.put(AddRecordController());
                          Get.toNamed("/page/addRecord")?.then((value) {
                            Get.delete<AddRecordController>();
                          });
                        },
                        title: "보스 리워드 기록하기",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton({
    required Function() onPressed,
    required String title,
}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        )
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
