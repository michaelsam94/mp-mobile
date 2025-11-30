part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class LoadingLogoutProfileState extends ProfileState {}

class SuccessLogoutProfileState extends ProfileState {}



class LoadingGetRFIDState extends ProfileState {}
class ErrorGetRFIDState extends ProfileState {}
class SuccessGetRFIDState extends ProfileState {}
