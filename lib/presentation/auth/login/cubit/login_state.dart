part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class ChangeCheckRememberMeLoginState extends LoginState {
  final bool checked;
  ChangeCheckRememberMeLoginState(this.checked);
}

class LoadingLoginState extends LoginState {}

class SuccessLoginState extends LoginState {}

class ErrorLoginState extends LoginState {
  final String message;
  ErrorLoginState(this.message);
}
