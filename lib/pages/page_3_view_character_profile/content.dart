import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/character_profile.dart';
import 'package:inside_maple/pages/page_3_view_character_profile/content_top.dart';
import 'package:inside_maple/utils/index.dart';

class PageCharacterProfile extends StatelessWidget {
  PageCharacterProfile({super.key});

  final characterProfileController = Get.find<CharacterProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _topItems(),
          separator(axis: Axis.horizontal),
        ],
      ),
    );
  }

  Widget _topItems() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          TopItemsProfile(),
          TopItemsMenu(),
        ],
      ),
    );
  }
}
