import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../cache/cache_helper.dart';
import '../cache/cache_keys.dart';
import 'end_points.dart';

class TokenExpiredException implements Exception {
  final String message;
  TokenExpiredException([this.message = "Session expired, please login again"]);
}

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        validateStatus: (status) => status! <= 500,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Map<String, String>?> getAuthHeaders() async {
    var token = CacheHelper.getString(CacheKeys.token.name);

    if (token != null && token.isNotEmpty) {
      if (CacheHelper.checkLogin() == 2) {
        if (await refreshToken()) {
          token = CacheHelper.getString(CacheKeys.token.name);
        } else {
          throw TokenExpiredException();
        }
      }
      return {'Authorization': 'Bearer $token'};
    }
    throw TokenExpiredException();
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    bool auth = true,
  }) async {
    Options options = Options();

    if (auth) {
      options.headers = await getAuthHeaders();
    }

    try {
      return await dio.get(url, queryParameters: query, options: options);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    }
  }

  // تعديل postData لقبول FormData أو Map<String, dynamic>
  static Future<Response> postData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    bool auth = true,
  }) async {
    Options options = Options();

    if (auth) {
      options.headers = await getAuthHeaders();
    }

    // إذا كانت البيانات FormData نعدل الهيدر Content-Type
    if (data != null) {
      if (data is FormData) {
        options.contentType = 'multipart/form-data';
      } else {
        options.contentType = 'application/json';
      }
    }

    try {
      return await dio.post(
        url,
        data: data,
        queryParameters: query,
        options: options,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    }
  }

  // تعديل مشابه على putData
  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    bool auth = true,
  }) async {
    Options options = Options();

    if (auth) {
      options.headers = await getAuthHeaders();
    }

    if (data is FormData) {
      options.contentType = 'multipart/form-data';
    } else {
      options.contentType = 'application/json';
    }

    try {
      return await dio.put(
        url,
        data: data,
        queryParameters: query,
        options: options,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    }
  }



  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    bool auth = true,
  }) async {
    Options options = Options();

    if (auth) {
      options.headers = await getAuthHeaders();
    }
    try {
      return await dio.delete(url, queryParameters: query, options: options);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    }
  }

  static Future<bool> refreshToken() async {
    try {
      var response = await dio.post(
        EndPoints.refreshToken,
        options: Options(
          contentType: 'application/json',
          headers: {
            "Accept": "application/json",
            "Authorization":
                "Bearer ${CacheHelper.getString(CacheKeys.token.name)}",
          },
        ),
      );
      if (response.statusCode == 200 &&
          response.data["success"] == true &&
          response.data["data"]["refresh_token"] != null) {
        await CacheHelper.refreshToken(
          response.data["data"]["refresh_token"],
          response.data["data"]["expires_in"],
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }
}
