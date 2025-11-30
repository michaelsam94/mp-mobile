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
  void getRFID() async {
    emit(LoadingGetRFIDState());

    try {
      var response = await DioHelper.getData(url: EndPoints.rfidCards);
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        var rfidData = data[0]["rfids"] as List;
        rfidCards = rfidData.map((e) => RFIDResponseModel.fromJson(e)).toList();
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
}
