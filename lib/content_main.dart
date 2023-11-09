import 'package:flutter/material.dart';

class ContentMain extends StatelessWidget {
  const ContentMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _menuButton(
              onPressed: () {

              },
              title: "보스 리워드 관리",
            ),
            _menuButton(
              onPressed: () {

              },
              title: "보스 리워드 기록하기",
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton({
    required Function() onPressed,
    required String title,
}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
          ),
        ),
      ),
    );
  }
}
