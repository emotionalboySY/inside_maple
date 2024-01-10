import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/auth.dart';

import '../../utils/logger.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "사용할 이메일 주소 입력",
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요.';
                    }
                    if (!authController.isEmailValid(value)) {
                      return '이메일 형식이 올바르지 않습니다.';
                    }
                    if (authController.emailDuplicated.value) {
                      return '이미 사용중인 이메일입니다.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    authController.setEmail(value);
                  }
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "비밀번호",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    if (!authController.isPasswordValid(value)) {
                      return '비밀번호는 8자 이상이어야 합니다.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    authController.setPassword(value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "비밀번호 확인",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    if (!authController.isPasswordSame()) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    authController.setPasswordConfirm(value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      await authController.isEmailDuplicated();
                      if(_formKey.currentState!.validate()) {
                        loggerNoStack.d("SignUp has requested and email is not exist in server(Fine to exceed)");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "가입하기",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "이미 회원이신가요?",
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offNamed('/auth_login');
                      },
                      child: const Text(
                        "로그인",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
