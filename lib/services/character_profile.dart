import 'package:dio/dio.dart';
import 'package:inside_maple/services/index.dart';

import '../utils/logger.dart';

final Dio _dio = DioClient.getDio();

Future<String?> getCharacterName() async {
  try {
    Response resp = await _dio.get("/profile/getCharacterName");

    if(resp.statusCode == 200) {
      String name = resp.data["name"];
      return name;
    }
    else {
      return null;
    }
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Get character name failed");
    return null;
  }
}

Future<Map?> loadCharacterInfo(String name, String date) async {
  try {
    Response resp = await _dio.get(
      "/profile/getCharacterInfo",
      data: {
        "name": name,
        "date": date
      }
    );

    if(resp.statusCode == 200) {
      loggerNoStack.d(resp.data["result"]);
      return resp.data["result"];
    }
    else {
      return null;
    }
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "get character info failed");
    return null;
  }
}