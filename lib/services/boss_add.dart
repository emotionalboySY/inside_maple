import 'package:dio/dio.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/model/boss.dart';
import '../model/item.dart';
import '../model/record_item.dart';
import 'index.dart';
import '../utils/logger.dart';

final Dio _dio = DioClient.getDio();

Future<List<Boss>?> getBossList() async {
  try {
    Response resp = await _dio.get('/boss_add/load_boss_info');

    if (resp.statusCode == 200) {
      List<Boss> bossList = [];
      for (var boss in resp.data["data"]) {
        loggerNoStack.d(boss);
        bossList.add(Boss.fromJson(boss));
      }
      return bossList;
    }
    return [];
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Get boss list failed");
    return null;
  }
}

Future<List<Item>?> getItemList(int bossId, Difficulty diff) async {
  try {
    String diffStr = diff.engName;
    Response resp = await _dio.post(
      '/boss_add/load_item_info',
      data: {
        "bossId": bossId,
        "diff": diffStr,
      },
    );

    if (resp.statusCode == 200) {
      List<Item> itemList = [];
      for (var item in resp.data["data"]) {
        itemList.add(Item.fromJson(item));
      }
      return itemList;
    }
    return [];
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Get item list failed");
    return null;
  }
}

Future<bool?> addBossRecord(int bossId, Difficulty diff, int memberCount, DateTime date, List<RecordItem> itemList) async {
  try {
    String diffStr = diff.engName;
    final boss = {
      "bossDataId": bossId,
      "difficulty": diffStr,
      "date": date.toIso8601String(),
      "memberCount": memberCount,
    };
    List itemStrList = [];
    for(RecordItem element in itemList) {
      itemStrList.add(element.toJson());
    }
    Response resp = await _dio.post(
      '/boss_add/add_record',
      data: {
        "boss": boss,
        "itemList": itemStrList,
      },
    );

    return resp.data['success'];
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Add Record Failure");
    return null;
  }
}

Future<bool?> checkIsDuplicatedRecord(int bossId, Difficulty diff, DateTime date) async {
  try {
    String diffStr = diff.engName;
    Response resp = await _dio.post(
      '/boss_add/check_record_duplicate',
      data: {
        "bossDataId": bossId,
        "difficulty": diffStr,
        "date": date.toIso8601String(),
      },
    );

    return resp.data['isDuplicated'];
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Checking Duplicated Record Failure");
    return null;
  }
}