import 'package:flutter/material.dart';

String toKorDateLabel(DateTime date) {
  return "${date.year}년 ${date.month}월 ${date.day}일";
}

Widget separator({
  required Axis axis,
}) {
  return Container(
    width: (axis == Axis.vertical) ? 0.5 : double.infinity,
    height: (axis == Axis.horizontal) ? 0.5 : double.infinity,
    decoration: const BoxDecoration(
      color: Colors.black,
    ),
  );
}