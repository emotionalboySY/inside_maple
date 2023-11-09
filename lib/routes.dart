import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/content_main.dart';
import 'package:inside_maple/pages_single_feature/page_1_add_record.dart';

List<GetPage> routes = [
  GetPage(
    name: '/main',
    page: () => const ContentMain(),
  ),
  GetPage(
    name: '/page',
    page: () => Container(),
    children: [
      GetPage(
        name: '/addRecord',
        page: () => PageAddRecord(),
      ),
    ],
  ),
];