import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/user.dart';
import '../utils/index.dart';
import '../utils/logger.dart';

class UserController extends GetxController {
  static UserController get to => Get.find<UserController>();

  Rx<User>? user;

  Future<void> updateUser(String token) async {
    await saveToken(token);
    Map<String, dynamic> tokenObj = parseJWTPayload(token);
    user = User.fromJson(tokenObj['user']).obs;
    update();
    refresh();
  }

  Future<void> saveToken(String token) async {
    try {
      final box = Hive.box("insideMaple");
      await box.put("auth_token", token);
    } catch (e) {
      logger.e("token save failure: $e", error: "Token Save Failure");
    }
  }
}