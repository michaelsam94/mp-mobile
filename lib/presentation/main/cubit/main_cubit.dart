import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

  int selectedIndex = 0;

  // void changeIndex(int index) {
  //   selectedIndex = index;
  //   emit(ChangeScreenIndexState(selectedIndex: selectedIndex));
  // }
}
