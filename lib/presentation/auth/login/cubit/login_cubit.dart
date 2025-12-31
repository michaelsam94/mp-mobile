import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/cache/user_cache_model.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  var checked = false;

  void changeChecked() {
    checked = !checked;
    emit(ChangeCheckRememberMeLoginState(checked));
  }

  void login(String email, String pass) async {
    emit(LoadingLoginState());
    String? deviceToken;
    try {
      final messaging = FirebaseMessaging.instance;
      
      // On iOS, get APNS token first
      if (Platform.isIOS) {
        try {
          final apnsToken = await messaging.getAPNSToken();
          if (kDebugMode) {
            print('APNS Token: $apnsToken');
          }
          // Wait a bit if APNS token is not available yet
          if (apnsToken == null) {
            if (kDebugMode) {
              print('APNS token not available yet, waiting...');
            }
            await Future.delayed(const Duration(milliseconds: 500));
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error getting APNS token: $e');
          }
        }
      }
      
      deviceToken = await messaging.getToken();
      if (kDebugMode) {
        print('FCM Token: $deviceToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
      // Continue with login even if token retrieval fails
      deviceToken = null;
    }

    try {
      // Build form data - always include device_token
      final formDataMap = <String, dynamic>{
        "login": email,
        "password": pass,
        "device_token": (deviceToken != null && deviceToken.isNotEmpty) ? deviceToken : "device_token",
      };
      
      var response = await DioHelper.postData(
        url: EndPoints.login,
        data: FormData.fromMap(formDataMap),
        auth: false,
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        await CacheHelper.login(UserCacheModel.fromJson(response.data["data"]));
        emit(SuccessLoginState());
      } else {
        emit(ErrorLoginState(response.data["message"]));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorLoginState("Please try again"));
    }
  }
}
