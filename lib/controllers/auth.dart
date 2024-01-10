import 'package:get/get.dart';
import 'package:inside_maple/utils/regexp.dart';

import 'package:inside_maple/services/auth.dart' as service;
import 'package:oktoast/oktoast.dart';

class AuthController extends GetxController {

  static AuthController get to => Get.find();

  RxBool passwordVisibility = true.obs;
  RxBool passwordConfirmVisibility = true.obs;
  RxBool emailDuplicated = false.obs;

  final RxString _email = "".obs;
  final RxString _password = "".obs;
  final RxString _passwordConfirm = "".obs;

  RxBool isSignUpButtonEnabled = false.obs;

  bool isEmailValid(String email) {
    return emailRegExp.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return passwordRegExp.hasMatch(password);
  }

  bool isPasswordSame() {
    return _password.value == _passwordConfirm.value;
  }

  Future<void> isEmailDuplicated() async {
    bool? isDuplicated = await service.checkIsEmailDuplicated(_email.value);
    if(isDuplicated == null) {
      showToast("이메일 중복 확인에 실패하였습니다.");
      return;
    }
    emailDuplicated.value = isDuplicated;
  }

  void setEmail(String email) {
    _email.value = email;
  }

  void setPassword(String password) {
    _password.value = password;
  }

  void setPasswordConfirm(String passwordConfirm) {
    _passwordConfirm.value = passwordConfirm;
  }
}