import 'package:get/get.dart';

import '../model/user.dart';
import '../utils/index.dart';

class UserController extends GetxController {
  static UserController get to => Get.find<UserController>();

  Rx<User>? user;

  void updateUser(String token) {
    Map<String, dynamic> tokenObj = parseJWTPayload(token);
    user = User.fromJson(tokenObj['user.dart']).obs;
    update();
    refresh();
  }
}