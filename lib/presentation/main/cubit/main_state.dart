part of 'main_cubit.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}

class ChangeScreenIndexState extends MainState {
  final int selectedIndex;

  ChangeScreenIndexState({required this.selectedIndex});
}
