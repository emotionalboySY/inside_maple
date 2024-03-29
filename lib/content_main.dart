import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record.dart';
import 'package:inside_maple/controllers/character_profile.dart';
import 'package:oktoast/oktoast.dart';
// import 'package:inside_maple/controllers/record_manage_data.dart';
// import 'package:inside_maple/controllers/record_manage_multi_edit.dart';

import 'controllers/main.dart';
import 'controllers/record_manage_multi.dart';
import 'controllers/record_manage_single_edit.dart';
import 'controllers/record_manage_single.dart';

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
                          // Get.put(RecordManageSingleController());
                          // Get.put(RecordManageSingleEditController());
                          // Get.put(RecordManageMultiController());
                          // Get.put(RecordManageMultiEditController());
                          // Get.put(RecordManageDataController());
                          // Get.toNamed("/page/viewRecord")?.then((value) {
                          //   Get.delete<RecordManageSingleController>();
                          //   Get.delete<RecordManageSingleEditController>();
                          //   Get.delete<RecordManageMultiController>();
                          //   Get.delete<RecordManageDataController>();
                          //   Get.delete<RecordManageMultiEditController>();
                          // });
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
                    const SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: _menuButton(
                        onPressed: () {
                          if(DateTime.now().hour == 0) {
                            showToast("매일 오전 0시부터 1시까지는 넥슨 OpenAPI를 이용한 기능 사용이 불가능합니다.");
                          }
                          else {
                            Get.put(CharacterProfileController());
                            Get.toNamed("/page/profile")?.then((value) {
                              Get.delete<CharacterProfileController>();
                            });
                          }
                        },
                        title: "캐릭터 프로필"
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
