import 'package:bloc/bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:meta/meta.dart';

import '../models/station_details_model.dart';

part 'station_details_state.dart';

class StationDetailsCubit extends Cubit<StationDetailsState> {
  StationDetailsCubit() : super(StationDetailsInitial());

  void getStationDetails(int stationId) async {
    emit(StationDetailsLoading());
    try {
      var response = await DioHelper.getData(
        url: '/api/stations/$stationId/details',
        auth: false,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var station = StationDetailsModel.fromJson(response.data["data"]);
        emit(StationDetailsSuccess(station));
      } else {
        emit(StationDetailsError('Failed to load station details'));
      }
    } catch (e) {
      emit(StationDetailsError('Error: ${e.toString()}'));
    }
  }
}
