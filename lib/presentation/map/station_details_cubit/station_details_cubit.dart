import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/map/models/station_response_model.dart';
import 'package:meta/meta.dart';

part 'station_details_state.dart';

class StationDetailsCubit extends Cubit<StationDetailsState> {
  StationDetailsCubit() : super(StationDetailsInitial());

  static StationDetailsCubit get(context) => BlocProvider.of(context);

  void getStationDetails(int stationId) async {
    emit(LoadingStationDetailsState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.getStationDetails(stationId),
        auth: false, // Station details API doesn't require authentication
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"];
        var station = StationResponseModel.fromJson(data);
        emit(SuccessStationDetailsState(station));
      } else {
        emit(ErrorStationDetailsState(
          response.data["message"] ?? "Failed to load station details",
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching station details: $e");
      }
      emit(ErrorStationDetailsState("Failed to load station details"));
    }
  }
}

