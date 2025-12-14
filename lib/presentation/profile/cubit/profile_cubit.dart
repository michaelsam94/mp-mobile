import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/profile/models/rfid_response_model.dart';
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

  List<RFIDResponseModel> rfidCards = [];

  RFIDResponseModel? defaultRFID;
  void getRFID() async {
    emit(LoadingGetRFIDState());

    try {
      var response = await DioHelper.getData(url: EndPoints.rfidCards);
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        var rfidData = data[0]["rfids"] as List;
        rfidCards = rfidData.map((e) => RFIDResponseModel.fromJson(e)).toList();

        // Todo Edit
        defaultRFID = rfidCards[0];
        emit(SuccessGetRFIDState());
      } else {
        emit(ErrorGetRFIDState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorGetRFIDState());
    }
  }

  void addRFID(String code) async {
    emit(LoadingGetRFIDState());

    try {
      var response = await DioHelper.postData(
        url: EndPoints.rfidCards,
        data: FormData.fromMap({"code": code, "status": "1"}),
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        getRFID();
      } else {
        emit(ErrorGetRFIDState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorGetRFIDState());
    }
  }

  void deleteRFID(int id) async {
    emit(LoadingGetRFIDState());

    try {
      var response = await DioHelper.deleteData(
        url: "${EndPoints.rfidCards}/$id",
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        getRFID();
      } else {
        emit(ErrorGetRFIDState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorGetRFIDState());
    }
  }

  void deactivateRFID(int id, String status) async {
    emit(LoadingGetRFIDState());

    try {
      var response = await DioHelper.patchData(
        url: "${EndPoints.rfidCards}/$id",
        data: {"status": status},
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        getRFID();
      } else {
        emit(ErrorGetRFIDState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorGetRFIDState());
    }
  }

  List<String> complaintsCategories = [];
  void getcomplaintsCategories() async {
    try {
      emit(LoadingGetCategoriesComplaintsState());

      var response = await DioHelper.getData(url: "/api/complains/categories");
      if (response.statusCode == 200) {
        var data = response.data["data"] as List;
        complaintsCategories = data.map((e) => "$e").toList();
        emit(SuccessGetCategoriesComplaintsState());
      } else {
        emit(ErrorGetCategoriesComplaintsState());
      }
    } catch (e) {
      emit(ErrorGetCategoriesComplaintsState());
    }
  }

  String? selectedCategory;
  void editCategory(String? newValue) {
    selectedCategory = newValue;
    emit(SelectComplaintCategoryState(selectedCategory));
  }

  bool agreePrivacy = false;
  void editAgreePriivacy(bool newValue) {
    agreePrivacy = newValue;
    emit(ChangeAgreePrivacyState(agreePrivacy));
  }

  void makeComplaint(String title, String desc) async {
    try {
      emit(LoadingMakeComplaintsState());

      var response = await DioHelper.postData(
        url: "/api/complains",
        data: FormData.fromMap({
          "title": title,
          "description": desc,
          "category": selectedCategory,
        }),
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        emit(SuccessMakeComplaintsState());
      } else {
        emit(ErrorGetCategoriesComplaintsState());
      }
    } catch (e) {
      emit(ErrorGetCategoriesComplaintsState());
    }
  }


void changePassword({
  required String oldPassword,
  required String newPassword,
}) async {
  emit(LoadingChangePasswordState());

  try {
    var response = await DioHelper.postData(
      url: EndPoints.changePassword, 
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      emit(SuccessChangePasswordState());
    } else {
      emit(ErrorChangePasswordState(
        message: response.data['message'] ?? 'Failed to change password',
      ));
    }
  } catch (e) {
    emit(ErrorChangePasswordState(
      message: 'An error occurred: ${e.toString()}',
    ));
  }
}

}
