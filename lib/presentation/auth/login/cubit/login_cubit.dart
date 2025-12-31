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
      deviceToken = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) {
        print('FCM Token: $deviceToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
      // Continue with registration even if token retrieval fails
      deviceToken = null;
    }

    try {
      var response = await DioHelper.postData(
        url: EndPoints.login,
        data: FormData.fromMap({
          "login": email,
          "password": pass,
          "device_token": deviceToken ?? "",
        }),
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
