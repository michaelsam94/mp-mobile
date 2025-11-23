part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class LoadingLogoutProfileState extends ProfileState {}

class SuccessLogoutProfileState extends ProfileState {}
