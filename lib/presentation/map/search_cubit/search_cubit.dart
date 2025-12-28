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
  List<StationResponseModel> filteredStations = [];
  String searchQuery = '';

  // Filter variables
  String? filterStatus;
  String? filterConnectorType;
  bool filterFavouriteOnly = false;
  String? filterMinimumPower;

  void getStations() async {
    emit(LoadingGetStationsSearchState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.getStations,
        auth: false,
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        stations = data.map((e) => StationResponseModel.fromJson(e)).toList();
        applyFiltersAndSearch();
        emit(SuccessGetStationsSearchState());
      } else {
        emit(ErrorGetStationsSearchState());
      }
    } catch (e) {
      emit(ErrorGetStationsSearchState());
    }
  }

  void searchStations(String query) {
    searchQuery = query.toLowerCase();
    applyFiltersAndSearch();
  }

  void applyFilters({
    String? status,
    String? connectorType,
    bool? favouriteOnly,
    String? minimumPower,
  }) {
    filterStatus = status;
    filterConnectorType = connectorType;
    filterFavouriteOnly = favouriteOnly ?? false;
    filterMinimumPower = minimumPower;
    applyFiltersAndSearch();
  }

  void applyFiltersAndSearch() {
    filteredStations = stations.where((station) {
      // Search filter
      bool matchesSearch =
          searchQuery.isEmpty ||
          station.name!.toLowerCase().contains(searchQuery) ||
          station.address!.toLowerCase().contains(searchQuery) ||
          station.city!.toLowerCase().contains(searchQuery);

      // Status filter
      bool matchesStatus =
          filterStatus == null || station.status == filterStatus;

      // Connector Type filter
      bool matchesConnectorType = true;
      if (filterConnectorType != null) {
        if (filterConnectorType == 'AC') {
          // For AC: check if acCompatible is true
          matchesConnectorType = station.acCompatible == true;
        } else if (filterConnectorType == 'DC') {
          // For DC: check if acCompatible is false
          matchesConnectorType = station.acCompatible == false;
        }
      }

      // Favourite filter (assuming you have a favourite field)
      // bool matchesFavourite = !filterFavouriteOnly || station.isFavourite == true;

      // Minimum Power filter
      bool matchesPower =
          filterMinimumPower == null ||
          station.guns!.any((gun) {
            double? gunPower = double.tryParse(gun.maxPower ?? '0');
            double? minPower = double.tryParse(
              filterMinimumPower?.replaceAll('kw', '').replaceAll('KW', '') ??
                  '0',
            );
            return gunPower != null && minPower != null && gunPower >= minPower;
          });

      return matchesSearch &&
          matchesStatus &&
          matchesConnectorType &&
          // matchesFavourite &&
          matchesPower;
    }).toList();

    emit(SearchUpdatedState());
  }

  void clearSearch() {
    searchQuery = '';
    applyFiltersAndSearch();
  }

  void clearFilters() {
    filterStatus = null;
    filterConnectorType = null;
    filterFavouriteOnly = false;
    filterMinimumPower = null;
    applyFiltersAndSearch();
  }
}
