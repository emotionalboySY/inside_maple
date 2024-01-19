import 'package:dio/dio.dart';
import 'package:inside_maple/model/record_boss.dart';
import '../utils/logger.dart';
import 'index.dart';

final Dio _dio = DioClient.getDio();

Future<List<RecordBoss>> loadRecords() async {
  try {
    Response resp = await _dio.get('/record_manage/load_records');

    if(resp.statusCode == 200) {
      List<RecordBoss> recordList = [];
      for(var record in resp.data) {
        recordList.add(RecordBoss.fromJson(record));
      }
      return recordList;
    }
    return [];
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Get record list failed");
    return [];
  }
}

Future<bool> removeRecord(RecordBoss recordToRemove) async {
  try {
    Response resp = await _dio.post('/record_manage/remove_record', data: recordToRemove.toJson());

    if(resp.statusCode == 200) {
      return true;
    }
    return false;
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Remove record failed");
    return false;
  }
}