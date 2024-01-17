import 'package:dio/dio.dart';

import '../utils/logger.dart';
import 'index.dart';

final Dio _dio = DioClient.getDio();


Future<bool?> checkIsEmailDuplicated(String email) async {
  try {
    Response resp = await _dio.post(
      '/auth/checkEmailExist',
      data: {
        'email': email,
      },
    );

    if(resp.statusCode == 200) {
      if(resp.data['duplication'] == true) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Email duplication check failed");
    return null;
  }
}

Future<bool?> signUp(String email, String password) async {
  try {
    Response resp = await _dio.post(
      '/auth/signup',
      data: {
        'email': email,
        'password': password,
      },
    );

    if(resp.data['success'] == true) {
      return true;
    } else {
      return false;
    }
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Sign up failed");
    return null;
  }
}

Future<Map?> logIn(String email, String password) async {
  try {
    Response resp = await _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return resp.data;
  } on DioException catch (e) {
    logger.e('Error sending request!\n${e.response}\n${e.type}\n${e.message}', error: "Sign in failed");
    return null;
  }
}