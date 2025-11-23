import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/onboarding/models/tip_response_model.dart';
import 'package:meta/meta.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  List<TipResponseModel> tips = [];
  void getData() async {
    tips.clear();

    emit(LoadingOnBoardingState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.onBoarding,
        auth: false,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"]["tips"] as List;
        tips = data.map((e) => TipResponseModel.fromJson(e)).toList();
        emit(SuccessOnBoardingState());
      } else {
        emit(ErrorOnBoardingState());
      }
    } catch (e) {
      emit(ErrorOnBoardingState());
    }
  }

  int currentIndex = 0;

  void changeIndex(int newIndex) {
    currentIndex = newIndex;
    emit(ChangeOnBoardingState(newIndex));
  }
}
