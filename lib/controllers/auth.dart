import 'package:get/get.dart';
import 'package:inside_maple/controllers/user.dart';
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

  Future<void> signUp() async {
    bool? isSuccess = await service.signUp(_email.value, _password.value);
    if(isSuccess == null) {
      showToast("서버 오류입니다. 운영자에게 문의해 주세요.");
      return;
    }
    if(isSuccess) {
      showToast("회원가입에 성공하였습니다.");
      Get.offNamed("/auth_login");
    } else {
      showToast("회원가입에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
    }
  }

  Future<void> login() async {
    Map? isSuccess = await service.logIn(_email.value, _password.value);
    if(isSuccess == null) {
      showToast("서버 오류입니다. 운영자에게 문의해 주세요.");
      return;
    }
    else if(isSuccess['success'] == true) {
      UserController.to.updateUser(isSuccess['token']);
      showToast("로그인에 성공하였습니다.");
      Get.offNamed("/main");
    } else {
      if(isSuccess['message'] == "id") {
        showToast("존재하지 않는 이메일입니다.");
      } else if(isSuccess['message'] == "pw") {
        showToast("비밀번호가 일치하지 않습니다.");
      } else {
        showToast("로그인에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
      }
    }
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