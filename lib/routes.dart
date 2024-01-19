import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/content_main.dart';
import 'package:inside_maple/pages/auth/login.dart';
import 'package:inside_maple/pages/auth/sign_up.dart';
import 'package:inside_maple/pages/page_1_add_record/content.dart';
import 'package:inside_maple/pages/page_2_view_boss_record/content.dart';

import 'controllers/auth.dart';

List<GetPage> routes = [
  GetPage(
    name: '/main',
    page: () => ContentMain(),
  ),
  GetPage(
    name: '/auth_login',
    page: () {
      Get.put(AuthController());
      return LoginPage();
    },
  ),
  GetPage(
    name: '/auth_signup',
    page: () {
      Get.put(AuthController());
      return SignUpPage();
    },
  ),
  GetPage(
    name: '/page',
    page: () => Container(),
    children: [
      GetPage(
        name: '/addRecord',
        page: () => PageAddRecord(),
      ),
      // GetPage(
      //   name: '/viewRecord',
      //   page: () => PageViewBossRecord(),
      // )
    ],
  ),
];