import 'package:dio/dio.dart';
import 'package:mega_plus/core/helpers/cache/cache_keys.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import '../cache/cache_helper.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        validateStatus: (status) => status! < 500,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    bool auth = false,
  }) async {
    Options options = Options();

    if (auth) {
      final token = CacheHelper.getString(CacheKeys.token.name);
      if (token != null && token.isNotEmpty) {
        options.headers = {'Authorization': 'Bearer $token'};
      }
    }

    return await dio.get(url, queryParameters: query, options: options);
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    bool auth = false,
  }) async {
    Options options = Options();

    if (auth) {
      final token = CacheHelper.getString(CacheKeys.token.name);
      if (token != null && token.isNotEmpty) {
        options.headers = {'Authorization': 'Bearer $token'};
      }
    }

    return await dio.post(
      url,
      data: data,
      queryParameters: query,
      options: options,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    bool auth = false,
  }) async {
    Options options = Options();

    if (auth) {
      final token = CacheHelper.getString(CacheKeys.token.name);
      if (token != null && token.isNotEmpty) {
        options.headers = {'Authorization': 'Bearer $token'};
      }
    }

    return await dio.put(
      url,
      data: data,
      queryParameters: query,
      options: options,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    bool auth = false,
  }) async {
    Options options = Options();

    if (auth) {
      final token = CacheHelper.getString(CacheKeys.token.name);
      if (token != null && token.isNotEmpty) {
        options.headers = {'Authorization': 'Bearer $token'};
      }
    }

    return await dio.delete(url, queryParameters: query, options: options);
  }
}
