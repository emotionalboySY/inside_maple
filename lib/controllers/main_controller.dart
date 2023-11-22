import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {

  Future<void> contactUs() async {
    await Get.defaultDialog(
      title: "추후 추가될 예정입니다."
    );
  }
}