import 'package:hive/hive.dart';
import 'package:get/get.dart';

import '../controllers/user.dart';

final box = Hive.box('insideMaple');

void updateUser(String token) {
  box.put('auth_token', token);

  final user = Get.find<UserController>();
  user.updateUser(token);
}

Future<bool> checkIsUserLoggedIn() async {
  String? authToken = await box.get('auth_token');

  if(authToken != null) {
    updateUser(authToken);
    return true;
  }
  return false;
}