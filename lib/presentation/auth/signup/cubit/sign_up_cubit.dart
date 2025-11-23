import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:meta/meta.dart';

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
        resendSeconds = response.data["data"]["resend_available_in"];
        codeSent = response.data["data"]["code"];
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

  
  void verifyCode(String code) async {
    emit(LoadingSignUpState());
   
    try {
      var response = await DioHelper.postData(
        url: EndPoints.verifyOtp,
        auth: false,
        data: FormData.fromMap({
          "country_code": countryCode,
          "mobile_number": phone,
          "otp":code
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

  
}
