import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:meta/meta.dart';

import '../../../../core/helpers/cache/cache_helper.dart';
import '../../../../core/helpers/cache/user_cache_model.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  var conWord = false;

  void changeConWord(bool newConWord) {
    conWord = newConWord;
    emit(ChangeConWordSignUpState(conWord));
  }

  String countryCode = '+2';

  void changeCountryCode(String newCountryCode) {
    countryCode = newCountryCode;
    emit(ChangeCountryCodeSignUpState(countryCode));
  }

  String phone = "";
  int resendSeconds = 0;
  String codeSent = "";

  String resetToken = "";
  String tokenType = "";
  void forgetPassword(String p) async {
    emit(LoadingSignUpState());
    phone = p;
    resendSeconds = 0;
    codeSent = "";
    resetToken = "";
    tokenType = "";

    try {
      var response = await DioHelper.postData(
        url: EndPoints.forgetPassword,
        auth: false,
        data: FormData.fromMap({
          "country_code": countryCode,
          "mobile_number": phone,
        }),
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        resendSeconds = response.data["data"]["resend_available_in"];
        codeSent = response.data["data"]["code"];
        resetToken = response.data["data"]["reset_token"];
        tokenType = response.data["data"]["token_type"];
        print(codeSent);
        print(resendSeconds);
        emit(SuccessSignUpState());
      } else {
        emit(ErrorSignUpState(response.data["message"]));
      }
    } catch (e) {
      emit(ErrorSignUpState("Error,Please try again"));
    }
  }

  void changePassword(String pass) async {
    emit(LoadingChangePasswordState());

    try {
      var response = await DioHelper.dio.patch(
        EndPoints.changePassword,
        options: Options(
          contentType: "application/json",
          headers: {"X-Reset-Token": resetToken},
        ),
        data: {
          "country_code": countryCode,
          "mobile_number": phone,
          "password": pass,
        },
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        emit(SuccessChangePasswordState());
      } else {
        emit(ErrorChangePasswordState(response.data["message"]));
      }
    } catch (e) {
      emit(ErrorChangePasswordState("Error,Please try again"));
    }
  }

  void sendOTP(String p) async {
    emit(LoadingSignUpState());
    phone = p;
    resendSeconds = 0;
    codeSent = "";

    try {
      var response = await DioHelper.postData(
        url: EndPoints.sendOtp,
        auth: false,
        data: FormData.fromMap({
          "country_code": countryCode,
          "mobile_number": phone,
        }),
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        resendSeconds = response.data["data"]["resend_available_in"] ?? 0;
        codeSent = response.data["data"]["code"] ?? "";
        print(codeSent);
        print(resendSeconds);
        emit(SuccessSignUpState());
      } else {
        emit(ErrorSignUpState(response.data["message"]));
      }
    } catch (e) {
      print("sendOTP Error: $e");
      emit(ErrorSignUpState("Error,Please try again"));
    }
  }

  void verifyCode(String code) async {
    emit(LoadingSignUpState());

    try {
      var response = await DioHelper.postData(
        url: EndPoints.verifyOtp,
        auth: false,
        data: FormData.fromMap({
          "country_code": countryCode,
          "mobile_number": phone,
          "otp": code,
        }),
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        emit(SuccessVerifyOTPSignUpState());
      } else {
        emit(ErrorVerifyOTPSignUpState(response.data["message"]));
      }
    } catch (e) {
      emit(ErrorVerifyOTPSignUpState("Error,Please try again"));
    }
  }

  void createAccount(String email, String name, String pass) async {
    emit(LoadingCreateAccountState());

    try {
      var response = await DioHelper.postData(
        url: EndPoints.register,
        data: FormData.fromMap({
          "email": email,
          "password": pass,
          "mobile_number": phone,
          "country_code": countryCode,
          "full_name": name,
        }),
        auth: false,
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        await CacheHelper.login(UserCacheModel.fromJson(response.data["data"]));
        emit(SuccessCreateAccountState());
      } else {
        emit(ErrorCreateAccountState(response.data["message"]));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorCreateAccountState("Please try again"));
    }
  }
}
