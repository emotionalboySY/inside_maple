import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../controllers/user.dart';

final box = Hive.box('insideMaple');

Map<String, dynamic> parseJWTPayload(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  String output = parts[1].replaceAll('-', '+').replaceAll('_', '/');
  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }
  final payload = utf8.decode(base64Url.decode(output));
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload format');
  }

  return payloadMap;
}

String toKorDateLabel(DateTime date) {
  return "${date.year}년 ${date.month}월 ${date.day}일";
}

String toDashDateLabel(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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

String getServerUrl() {
  return dotenv.env['SERVER_URL']!;
}

void updateUser(String token) {
  box.put('auth_token', token);

  final user = Get.find<UserController>();
  user.updateUser(token);
}

void removeUser() {
  box.delete('auth_token');

  final user = Get.find<UserController>();
  user.user = null;
}