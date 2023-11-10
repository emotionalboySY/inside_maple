import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/add_record_controller.dart';

class ContentMain extends StatelessWidget {
  const ContentMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _menuButton(
                  onPressed: () {

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
                    Get.toNamed("/page/addRecord");
                  },
                  title: "보스 리워드 기록하기",
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
