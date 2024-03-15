import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/services/character_profile.dart' as profile_service;
import 'package:inside_maple/utils/index.dart';
import 'package:oktoast/oktoast.dart';

import '../constants.dart';
import '../utils/logger.dart';

class CharacterProfileController extends GetxController {
  String characterName = "";
  Rx<DateTime> date = DateTime.now().subtract(const Duration(days: 1)).obs;

  Rx<LoadStatus> dataLoadStatus = LoadStatus.empty.obs;

  @override
  void onInit() async {
    super.onInit();
    String? name = await profile_service.getCharacterName();
    if (name == null) {
      showToast("계정에 저장된 캐릭터 이름을 불러오는데 실패하였습니다.");
    } else {
      characterName = name;
    }
  }

  Future<void> loadCharacterData() async {
    dataLoadStatus.value = LoadStatus.loading;
    try {
      Map? result = await profile_service.loadCharacterInfo(characterName, toDashDateLabel(date.value));
      if(result != null) {
        dataLoadStatus.value = LoadStatus.success;
      }
      else {
        showToast("캐릭터 프로필이 정상적으로 로드되지 않았습니다. 다시 시도하거나 관리자에게 문의해 주세요.");
        dataLoadStatus.value = LoadStatus.failed;
      }
    } catch (e) {
      logger.e("Data load failed!\n$e");
      showToast("캐릭터 프로필 로드 중 오류가 발생하였습니다. 관리자에게 문의해 주세요.");
      dataLoadStatus.value = LoadStatus.failed;
    }
  }

  Future<void> selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime(2023, 12, 21),
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
      currentDate: date.value,
      barrierDismissible: false,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            datePickerTheme: const DatePickerThemeData().copyWith(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0.0,
            )
          ),
          child: child!,
        );
      }
    );
    if(selectedDate != null) {
      date.value = selectedDate;
    }
  }
}