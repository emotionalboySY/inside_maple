import 'package:dio/dio.dart';
import 'package:inside_maple/model/boss.dart';
import 'index.dart';
import '../utils/logger.dart';

final Dio _dio = DioClient.getDio();

Future<List<Boss>?> getBossList() async {
  try {
    Response resp = await _dio.get('/boss_add/load_boss_info');

    if(resp.statusCode == 200) {
      List<Boss> bossList = [];
      for(var boss in resp.data) {
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