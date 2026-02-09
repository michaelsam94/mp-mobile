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
  bool isVisible = true;

  void getData() async {
    emit(LoadingOnBoardingState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.onBoarding,
        auth: false,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"];
        isVisible = data["is_visible"] ?? true;
        
        // If onboarding is not visible, emit state to skip it
        if (!isVisible) {
          emit(OnBoardingNotVisibleState());
          return;
        }

        var tipsData = data["tips"] as List;
        tips = tipsData.map((e) => TipResponseModel.fromJson(e)).toList();
        
        // If tips is empty, skip onboarding
        if (tips.isEmpty) {
          emit(OnBoardingNotVisibleState());
          return;
        }
        
        // Sort tips by sort field
        tips.sort((a, b) => (a.sort ?? 0).compareTo(b.sort ?? 0));
        // Reset to first tip
        currentIndex = 0;
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
