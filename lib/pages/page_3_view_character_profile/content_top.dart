import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/controllers/character_profile.dart';
import 'package:inside_maple/utils/index.dart';

class TopItemsProfile extends StatelessWidget {
  TopItemsProfile({super.key});

  final characterProfileController = Get.find<CharacterProfileController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "캐릭터 닉네임:",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: SizedBox(
            width: 170,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "닉네임 입력",
                contentPadding: const EdgeInsets.all(7.0),
              ),
              onChanged: (value) {
                characterProfileController.characterName = value;
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "날짜:",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Obx(
            () => Text(
              toDashDateLabel(characterProfileController.date.value),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: TextButton(
            child: const Text(
              "변경",
              style: TextStyle(
                fontSize: 15,
                color: Colors.deepPurpleAccent,
              ),
            ),
            onPressed: () async {
              await characterProfileController.selectDate();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
          child: ElevatedButton(
            onPressed: () async {
              characterProfileController.loadCharacterData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              )
            ),
            child: const Center(
              child: Text(
                "검색하기",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TopItemsMenu extends StatelessWidget {
  const TopItemsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15.0, left: 5.0),
          child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              backgroundColor: Colors.deepPurple,
            ),
            child: const Center(
              child: Text(
                "나가기",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
