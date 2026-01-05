import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_plus/app_root.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/login/login_screen.dart';
import '../cache/cache_helper.dart';
import '../cache/cache_keys.dart';
import 'end_points.dart';

class TokenExpiredException implements Exception {
  final String message;
  TokenExpiredException([this.message = "Session expired, please login again"]);
}

class NetworkException implements Exception {
  final String message;
  final bool dialogShown;
  NetworkException(this.message, {this.dialogShown = true});
}

class DioHelper {
  static late Dio dio;
  static bool _networkErrorDialogShown = false; // Track if network error dialog is already shown

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
        // Reset network error flag on successful response
        _networkErrorDialogShown = false;
        
        // Check if response indicates unauthorized
        if (response.statusCode == 401 || 
            (response.data is Map && 
             response.data['success'] == false && 
             (response.data['message']?.toString().toLowerCase().contains('unauthorized') == true ||
              response.data['message']?.toString().toLowerCase().contains('login') == true))) {
          // Handle 401 in response - logout immediately
          if (response.requestOptions.path != EndPoints.login) {
            _handleUnauthorized();
          }
        }
        handler.next(response);
      },
      onError: (error, handler) async {
        // Check if error indicates unauthorized
        final isUnauthorized = error.response?.statusCode == 401 ||
            (error.response?.data is Map && 
             error.response?.data['success'] == false && 
             (error.response?.data['message']?.toString().toLowerCase().contains('unauthorized') == true ||
              error.response?.data['message']?.toString().toLowerCase().contains('login') == true));
        
        // If unauthorized and not login endpoint, logout immediately
        if (isUnauthorized && error.requestOptions.path != EndPoints.login) {
          _handleUnauthorized();
          handler.reject(error);
          return;
        }
        
        // Check for network errors - handle centrally
        if (_isNetworkError(error)) {
          if (!_networkErrorDialogShown) {
            _networkErrorDialogShown = true;
            _showNetworkErrorDialog();
          }
          // Reject with NetworkException to prevent error propagation and duplicate toasts
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: NetworkException(
                'Network error: ${error.message ?? "Connection failed"}',
                dialogShown: true,
              ),
              type: error.type,
            ),
          );
          return;
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

  static bool _isNetworkError(DioException error) {
    // Check for network-related errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }

    // Check for SocketException (no internet connection)
    if (error.error is SocketException) {
      return true;
    }

    // Check for network-related error messages
    final errorMessage = error.message?.toLowerCase() ?? '';
    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('internet') ||
        errorMessage.contains('socket') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('failed host lookup') ||
        errorMessage.contains('no address associated with hostname')) {
      return true;
    }

    return false;
  }

  static void _showNetworkErrorDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Network Issue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Connection lost. Please check your internet connection and try again.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _networkErrorDialogShown = false;
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ).then((_) {
      // Reset flag when dialog is closed
      _networkErrorDialogShown = false;
    });
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
      // If it's a network error that's already been handled (dialog shown), throw NetworkException
      if (e.error is NetworkException && (e.error as NetworkException).dialogShown) {
        // Re-throw as NetworkException to prevent duplicate error handling
        throw NetworkException('Network error', dialogShown: true);
      }
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    } on NetworkException {
      // Network error already handled by interceptor (dialog shown)
      // Re-throw to let caller know it's a network error, but no need to show toast
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
      // If it's a network error that's already been handled (dialog shown), throw NetworkException
      if (e.error is NetworkException && (e.error as NetworkException).dialogShown) {
        // Re-throw as NetworkException to prevent duplicate error handling
        throw NetworkException('Network error', dialogShown: true);
      }
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    } on NetworkException {
      // Network error already handled by interceptor (dialog shown)
      // Re-throw to let caller know it's a network error, but no need to show toast
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
      // If it's a network error that's already been handled (dialog shown), throw NetworkException
      if (e.error is NetworkException && (e.error as NetworkException).dialogShown) {
        // Re-throw as NetworkException to prevent duplicate error handling
        throw NetworkException('Network error', dialogShown: true);
      }
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    } on NetworkException {
      // Network error already handled by interceptor (dialog shown)
      // Re-throw to let caller know it's a network error, but no need to show toast
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
      // If it's a network error that's already been handled (dialog shown), throw NetworkException
      if (e.error is NetworkException && (e.error as NetworkException).dialogShown) {
        // Re-throw as NetworkException to prevent duplicate error handling
        throw NetworkException('Network error', dialogShown: true);
      }
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    } on NetworkException {
      // Network error already handled by interceptor (dialog shown)
      // Re-throw to let caller know it's a network error, but no need to show toast
      rethrow;
    }
  }

  static Future<Response> deleteData({
    required String url,
     dynamic data,
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
      return await dio.delete(url, queryParameters: query, options: options,data: data);
    } on DioException catch (e) {
      // If it's a network error that's already been handled (dialog shown), throw NetworkException
      if (e.error is NetworkException && (e.error as NetworkException).dialogShown) {
        // Re-throw as NetworkException to prevent duplicate error handling
        throw NetworkException('Network error', dialogShown: true);
      }
      if (kDebugMode) {
        print(e.message.toString());
      }
      rethrow;
    } on NetworkException {
      // Network error already handled by interceptor (dialog shown)
      // Re-throw to let caller know it's a network error, but no need to show toast
      rethrow;
    }
  }

  static Future<bool> refreshToken() async {
    try {
      // Try with current token first (even if expired, some APIs accept it)
      final currentToken = CacheHelper.getString(CacheKeys.token.name);
      var response = await dio.post(
        EndPoints.refreshToken,
        options: Options(
          contentType: 'application/json',
          headers: {
            "Accept": "application/json",
            if (currentToken != null && currentToken.isNotEmpty)
              "Authorization": "Bearer $currentToken",
          },
        ),
      );
      
      // Check if refresh endpoint returned 401 - this means refresh token is invalid/expired
      if (response.statusCode == 401) {
        if (kDebugMode) {
          print('Refresh token returned 401 - logging out');
        }
        return false;
      }
      
      if (response.statusCode == 200 &&
          response.data["success"] == true &&
          response.data["data"] != null) {
        // The new token is in data.refresh_token
        final newToken = response.data["data"]["refresh_token"];
        final expiresIn = response.data["data"]["expires_in"];
        
        if (newToken != null && expiresIn != null) {
          await CacheHelper.refreshToken(
            newToken,
            expiresIn,
          );
          return true;
        }
      }
      return false;
    } on DioException catch (e) {
      // If refresh endpoint returns 401, handle it
      if (e.response?.statusCode == 401) {
        if (kDebugMode) {
          print('Refresh token returned 401 - logging out');
        }
        return false;
      }
      if (kDebugMode) {
        print('Refresh token error: ${e.toString()}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Refresh token error: ${e.toString()}');
      }
      return false;
    }
  }
}
