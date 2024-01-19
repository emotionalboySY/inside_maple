import 'package:dio/dio.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/model/boss.dart';
import '../model/item.dart';
import '../model/record_boss.dart';
import 'index.dart';
import '../utils/logger.dart';

final Dio _dio = DioClient.getDio();

Future<List<Boss>?> getBossList() async {
  try {
    Response resp = await _dio.get('/boss_add/load_boss_info');

    if (resp.statusCode == 200) {
      List<Boss> bossList = [];
      for (var boss in resp.data["data"]) {
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

Future<bool?> addBossRecord(Map data, List itemList) async {
  try {
    loggerNoStack.d(data);
    Response resp = await _dio.post(
      '/boss_add/add_record',
      data: {
        "boss": data,
        "itemList": itemList,
      },
    );
    loggerNoStack.d("resp: ${resp.data}");

    if(resp.statusCode == 200) {
      if(resp.data["success"] == true) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Add boss record failed");
    return null;
  }
}
