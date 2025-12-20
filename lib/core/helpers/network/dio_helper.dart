import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_plus/app_root.dart';
import 'package:mega_plus/presentation/auth/login/login_screen.dart';
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
        connectTimeout: Duration(seconds: 100),
        receiveTimeout: Duration(seconds: 100),
        validateStatus: (status) => status! <= 500,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => print(obj),
      ));
    }

    // Add unauthorized interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        // Check if response indicates unauthorized
        if (response.statusCode == 401 || 
            (response.data is Map && 
             response.data['success'] == false && 
             (response.data['message']?.toString().toLowerCase().contains('unauthorized') == true ||
              response.data['message']?.toString().toLowerCase().contains('login') == true))) {
          _handleUnauthorized();
        }
        handler.next(response);
      },
      onError: (error, handler) {
        // Check if error indicates unauthorized
        if (error.response?.statusCode == 401 ||
            (error.response?.data is Map && 
             error.response?.data['success'] == false && 
             (error.response?.data['message']?.toString().toLowerCase().contains('unauthorized') == true ||
              error.response?.data['message']?.toString().toLowerCase().contains('login') == true))) {
          _handleUnauthorized();
        }
        handler.next(error);
      },
    ));
  }

  static void _handleUnauthorized() {
    // Clear cache and navigate to login
    CacheHelper.logout();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
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
    dynamic data,
    bool auth = true,
  }) async {
    Options options = Options();

    if (auth) {
      options.headers = await getAuthHeaders();
    }
    if (data != null) {
      if (data is FormData) {
        options.contentType = 'multipart/form-data';
      } else {
        options.contentType = 'application/json';
      }
    }
    try {
      return await dio.get(
        url,
        queryParameters: query,
        options: options,
        data: data,
      );
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

  // تعديل مشابه على putData
  static Future<Response> patchData({
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
      return await dio.patch(
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
