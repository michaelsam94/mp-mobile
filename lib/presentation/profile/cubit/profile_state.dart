part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class LoadingLogoutProfileState extends ProfileState {}

class SuccessLogoutProfileState extends ProfileState {}

class LoadingGetRFIDState extends ProfileState {}

class ErrorGetRFIDState extends ProfileState {}

class SuccessGetRFIDState extends ProfileState {}

class ChangeAgreePrivacyState extends ProfileState {
  final bool agree;
  ChangeAgreePrivacyState(this.agree);
}

class SelectComplaintCategoryState extends ProfileState {
  final String? category;
  SelectComplaintCategoryState(this.category);
}

class LoadingGetCategoriesComplaintsState extends ProfileState {}

class ErrorGetCategoriesComplaintsState extends ProfileState {}

class SuccessGetCategoriesComplaintsState extends ProfileState {}

class LoadingMakeComplaintsState extends ProfileState {}
class SuccessMakeComplaintsState extends ProfileState {}
class LoadingChangePasswordState extends ProfileState {}

class SuccessChangePasswordState extends ProfileState {}

class ErrorChangePasswordState extends ProfileState {
  final String? message;
  ErrorChangePasswordState({this.message});
}
