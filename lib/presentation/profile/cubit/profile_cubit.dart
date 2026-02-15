import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/profile/models/rfid_response_model.dart';
import 'package:mega_plus/presentation/profile/models/settings_response_model.dart';

import '../models/content_page_model.dart';

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
        var allRfids = rfidData
            .map((e) => RFIDResponseModel.fromJson(e))
            .toList();

        // Set default RFID to the one with is_default = 1
        try {
          defaultRFID = allRfids.firstWhere((rfid) => rfid.isDefault == 1);
        } catch (e) {
          // If no default RFID found, fallback to first RFID in the list
          if (allRfids.isNotEmpty) {
            defaultRFID = allRfids.first;
          } else {
            defaultRFID = null;
          }
        }

        // Filter out the default RFID for UI display
        if (defaultRFID != null) {
          rfidCards = allRfids
              .where((rfid) => rfid.id != defaultRFID!.id)
              .toList();
        } else {
          rfidCards = allRfids;
        }

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
      if (response.statusCode == 200 &&
          (response.data["success"] == true ||
              response.data["status"] == true)) {
        emit(SuccessAddRFIDState());
        getRFID();
      } else {
        // Extract error message from response
        String errorMessage = 'Failed to add RFID card';
        if (response.data["message"] != null) {
          errorMessage = response.data["message"];
        } else if (response.data["errors"] != null) {
          // Check for specific field errors
          final errors = response.data["errors"];
          if (errors is Map) {
            // Get first error message from errors map
            final firstErrorKey = errors.keys.first;
            if (errors[firstErrorKey] is List &&
                (errors[firstErrorKey] as List).isNotEmpty) {
              errorMessage = errors[firstErrorKey][0];
            } else if (errors[firstErrorKey] is String) {
              errorMessage = errors[firstErrorKey];
            }
          }
        }
        emit(ErrorGetRFIDState(message: errorMessage));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorGetRFIDState(message: e.toString()));
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
    required String confirmationPassword,
  }) async {
    emit(LoadingChangePasswordState());

    try {
      var response = await DioHelper.patchData(
        url: EndPoints.changePassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirmation_password': confirmationPassword,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        emit(SuccessChangePasswordState());
      } else {
        emit(
          ErrorChangePasswordState(
            message: response.data['message'] ?? 'Failed to change password',
          ),
        );
      }
    } catch (e) {
      emit(
        ErrorChangePasswordState(message: 'An error occurred: ${e.toString()}'),
      );
    }
  }

  List<ContentPageModel> termsConditions = [];

  void getTermsConditions() async {
    emit(LoadingGetTermsState());

    try {
      var response = await DioHelper.getData(
        url: "/api/content",
        query: {"type": "page"},
        auth: false, // Set to true if authentication is required
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"]["tips"] as List;
        termsConditions = data
            .map((e) => ContentPageModel.fromJson(e))
            .toList();

        // Sort by sort field
        termsConditions.sort((a, b) => a.sort.compareTo(b.sort));

        emit(SuccessGetTermsState());
      } else {
        emit(
          ErrorGetTermsState(
            message: response.data["message"] ?? "Failed to load terms",
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorGetTermsState(message: e.toString()));
    }
  }

  void updateProfile({
    required String fullName,
    required String email,
    required String birthday,
    required String gender,
    File? imageFile,
  }) async {
    emit(LoadingUpdateProfileState());

    try {
      var response = await DioHelper.postData(
        url: EndPoints.updateProfile,
        data: FormData.fromMap({
          "full_name": fullName,
          "email": email,
          "birthday": birthday,
          "gender": gender,
          "media": imageFile == null
              ? null
              : await MultipartFile.fromFile(imageFile.path),
        }),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        // Update cache with new user data
        if (response.data["data"] != null) {
          await CacheHelper.updateUserData(response.data["data"]);
        }
        // Reload profile data
        getProfile();
        emit(SuccessUpdateProfileState());
      } else {
        emit(
          ErrorUpdateProfileState(
            message: response.data["message"] ?? "Failed to update profile",
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorUpdateProfileState(message: e.toString()));
    }
  }

  void getProfile() async {
    try {
      var response = await DioHelper.getData(url: EndPoints.updateProfile);

      if (response.statusCode == 200 && response.data["success"] == true) {
        // Update cache with fresh user data
        if (response.data["data"] != null) {
          await CacheHelper.updateUserData(response.data["data"]);
        }
        emit(ProfileReloadedState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  List<SettingsResponseModel> settings = [];

  void getSettings() async {
    emit(LoadingGetSettingsState());

    try {
      var response = await DioHelper.getData(url: EndPoints.getSettings);

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        settings = data.map((e) => SettingsResponseModel.fromJson(e)).toList();
        emit(SuccessGetSettingsState());
      } else {
        emit(
          ErrorGetSettingsState(
            message: response.data["message"] ?? "Failed to load settings",
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ErrorGetSettingsState(message: e.toString()));
    }
  }

  // Helper method to get setting value by key
  String? getSettingValue(String key) {
    try {
      return settings.firstWhere((setting) => setting.key == key).value;
    } catch (e) {
      return null;
    }
  }

  void deleteAccount(String reason) async {
    emit(LoadingLogoutProfileState());

    try {
      var response = await DioHelper.deleteData(
        url: EndPoints.deleteAccount,
        data: FormData.fromMap({"delete_reason": reason}),
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        emit(SuccessLogoutProfileState());
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
}
