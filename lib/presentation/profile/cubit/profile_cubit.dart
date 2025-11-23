import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  void logout() async {
    emit(LoadingLogoutProfileState());

    try {
      await DioHelper.postData(url: EndPoints.logout);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    emit(SuccessLogoutProfileState());
  }
}
