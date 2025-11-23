part of 'on_boarding_cubit.dart';

@immutable
sealed class OnBoardingState {}

final class OnBoardingInitial extends OnBoardingState {}

class LoadingOnBoardingState extends OnBoardingState {}

class SuccessOnBoardingState extends OnBoardingState {}

class ErrorOnBoardingState extends OnBoardingState {}

class ChangeOnBoardingState extends OnBoardingState {
  final int newIndex;
  ChangeOnBoardingState(this.newIndex);
}
