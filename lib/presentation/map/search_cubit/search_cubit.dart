import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/map/models/station_response_model.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  List<StationResponseModel> stations = [];
  List<StationResponseModel> filteredStations = []; // للنتائج المفلترة
  String searchQuery = '';

  void getStations() async {
    emit(LoadingGetStationsSearchState());
    try {
      var response = await DioHelper.getData(url: EndPoints.getStations);
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        stations = data.map((e) => StationResponseModel.fromJson(e)).toList();
        filteredStations = List.from(stations); // نسخة أولية
        emit(SuccessGetStationsSearchState());
      } else {
        emit(ErrorGetStationsSearchState());
      }
    } catch (e) {
      emit(ErrorGetStationsSearchState());
    }
  }

  // دالة البحث الجديدة
  void searchStations(String query) {
    searchQuery = query.toLowerCase();

    if (query.isEmpty) {
      filteredStations = List.from(stations); // إرجاع الكل
    } else {
      filteredStations = stations.where((station) {
        return station.name!.toLowerCase().contains(searchQuery) ||
            station.address!.toLowerCase().contains(searchQuery) ||
            station.city!.toLowerCase().contains(searchQuery);
      }).toList();
    }

    emit(SearchUpdatedState()); // state جديد للـ search
  }

  // clear search
  void clearSearch() {
    searchQuery = '';
    filteredStations = List.from(stations);
    emit(SearchUpdatedState());
  }
}
