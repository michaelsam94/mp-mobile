part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

class ChangeConWordSignUpState extends SignUpState {
  final bool conWord;
  ChangeConWordSignUpState(this.conWord);
}

class ChangeCountryCodeSignUpState extends SignUpState {
  final String countryCode;
  ChangeCountryCodeSignUpState(this.countryCode);
}


class LoadingSignUpState extends SignUpState {}

class SuccessSignUpState extends SignUpState {}
class ErrorSignUpState extends SignUpState {
    final String message;
  ErrorSignUpState(this.message);
}

class SuccessVerifyOTPSignUpState extends SignUpState {}
class ErrorVerifyOTPSignUpState extends SignUpState {
    final String message;
  ErrorVerifyOTPSignUpState(this.message);
}