import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/map/models/map_station_response_model.dart';
import 'package:mega_plus/presentation/map/models/station_response_model.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  List<StationResponseModel> stations = [];
  List<StationResponseModel> filteredStations = [];
  List<MapStationResponseModel> nearbyStations = [];
  bool useCachedStations = false;
  String searchQuery = '';

  // Filter variables
  String? filterStatus;
  String? filterConnectorType;
  bool filterFavouriteOnly = false;
  String? filterMinimumPower;

  // Load nearby stations initially
  void getStations() async {
    emit(LoadingGetStationsSearchState());
    try {
      // Get user location
      Position? position;
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            position = await Geolocator.getCurrentPosition(
              timeLimit: Duration(seconds: 5),
            );
          }
        }
      } catch (e) {
        print("Error getting location: $e");
      }

      // Use default location if unable to get user location
      double lat = position?.latitude ?? 30.0444;
      double lng = position?.longitude ?? 31.2357;

      var response = await DioHelper.getData(
        url: EndPoints.getMapStations(lat, lng),
        auth: false, // This endpoint doesn't require authentication
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        nearbyStations = data
            .map((e) => MapStationResponseModel.fromJson(e))
            .toList();
        // Initially show nearby stations
        useCachedStations = false;
        _updateFilteredStations();
        emit(SuccessGetStationsSearchState());
      } else {
        emit(ErrorGetStationsSearchState());
      }
    } catch (e) {
      emit(ErrorGetStationsSearchState());
    }
  }

  // Use cached stations from MapCubit for search/filter
  void useMapCachedStations(List<StationResponseModel> cachedStations) {
    stations = cachedStations;
    useCachedStations = true;
    applyFiltersAndSearch();
  }

  void searchStations(
    String query, {
    List<StationResponseModel>? cachedStations,
  }) {
    searchQuery = query.toLowerCase();

    // If user starts searching and we have cached stations, switch to them
    if (cachedStations != null &&
        cachedStations.isNotEmpty &&
        !useCachedStations) {
      stations = cachedStations;
      useCachedStations = true;
    }

    applyFiltersAndSearch();
  }

  void applyFilters({
    String? status,
    String? connectorType,
    bool? favouriteOnly,
    String? minimumPower,
    List<StationResponseModel>? cachedStations,
  }) {
    filterStatus = status;
    filterConnectorType = connectorType;
    filterFavouriteOnly = favouriteOnly ?? false;
    filterMinimumPower = minimumPower;

    // If applying filters and we have cached stations, switch to them
    if (cachedStations != null &&
        cachedStations.isNotEmpty &&
        !useCachedStations) {
      stations = cachedStations;
      useCachedStations = true;
    }

    applyFiltersAndSearch();
  }

  void _updateFilteredStations() {
    if (!useCachedStations) {
      // Show nearby stations (MapStationResponseModel) - convert to display format
      filteredStations = [];
      return;
    }
    applyFiltersAndSearch();
  }

  void applyFiltersAndSearch() {
    if (!useCachedStations) {
      // If not using cached stations, don't filter (show nearby as is)
      filteredStations = [];
      emit(SearchUpdatedState());
      return;
    }

    filteredStations = stations.where((station) {
      // Search filter
      bool matchesSearch =
          searchQuery.isEmpty ||
          (station.name?.toLowerCase().contains(searchQuery) ?? false) ||
          (station.address?.toLowerCase().contains(searchQuery) ?? false) ||
          (station.city?.toLowerCase().contains(searchQuery) ?? false);

      // Status filter
      bool matchesStatus =
          filterStatus == null || station.status == filterStatus;

      // Connector Type filter
      bool matchesConnectorType = filterConnectorType == null;
      if (!matchesConnectorType &&
          station.guns != null &&
          station.guns!.isNotEmpty) {
        if (filterConnectorType == 'DC') {
          // DC connectors: CCS2 / GB-T, Tesla, CHAdeMO, CCS2
          matchesConnectorType = station.guns!.any((gun) {
            final type = gun.type?.toUpperCase() ?? '';
            return type.contains('CCS2') ||
                type.contains('TESLA') ||
                type.contains('CHADEMO') ||
                type.contains('GB-T');
          });
        } else if (filterConnectorType == 'AC') {
          // AC connectors: AC-Type-2 or any type containing AC
          matchesConnectorType = station.guns!.any((gun) {
            final type = gun.type?.toUpperCase() ?? '';
            return type.contains('AC');
          });
        } else {
          // For other filters, check if type contains the filter string
          matchesConnectorType = station.guns!.any(
            (gun) =>
                gun.type?.toUpperCase().contains(
                  filterConnectorType!.toUpperCase(),
                ) ??
                false,
          );
        }
      }

      // Favourite filter (assuming you have a favourite field)
      // bool matchesFavourite = !filterFavouriteOnly || station.isFavourite == true;

      // Minimum Power filter
      bool matchesPower = filterMinimumPower == null;
      if (!matchesPower && station.guns != null && station.guns!.isNotEmpty) {
        // Parse the minimum power from filter (e.g., "7kw" -> 7.0)
        double? minPowerValue = double.tryParse(
          filterMinimumPower!.replaceAll('kw', '').replaceAll('KW', '').trim(),
        );

        if (minPowerValue != null) {
          // Check if any gun has maxPower >= minimum power
          matchesPower = station.guns!.any((gun) {
            if (gun.maxPower == null || gun.maxPower!.isEmpty) {
              return false; // Skip guns with no power info
            }

            // Parse the gun's max power (e.g., "23.00" -> 23.0)
            double? gunPower = double.tryParse(
              gun.maxPower!.replaceAll('kw', '').replaceAll('KW', '').trim(),
            );

            // Return true if gun power is valid and >= minimum power
            return gunPower != null && gunPower >= minPowerValue;
          });
        }
      }

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

  // Check if station has at least one DC connector
  // DC connectors: CCS2, CCS2 / GB-T, CHAdeMO, Tesla
  bool hasDCConnector(StationResponseModel station) {
    if (station.guns == null || station.guns!.isEmpty) return false;
    return station.guns!.any((gun) {
      final type = gun.type?.toUpperCase() ?? '';
      return type.contains('CCS2') ||
          type.contains('TESLA') ||
          type.contains('CHADEMO') ||
          type.contains('GB-T');
    });
  }

  // Get the appropriate icon path for a station based on status and DC connector presence
  String getStationIconPath(StationResponseModel station) {
    String status = station.status ?? 'available';
    bool isDC = hasDCConnector(station);

    if (isDC) {
      switch (status) {
        case 'available':
          return 'assets/icons/dc_available.png';
        case 'unavailable':
          return 'assets/icons/dc_unavailable.png';
        case 'inUse':
          return 'assets/icons/dc_inuse.png';
        default:
          return 'assets/icons/dc_available.png';
      }
    } else {
      // For non-DC stations, use the regular AC icon
      return 'assets/icons/ac.png';
    }
  }

  //add station to favouries
  Future<bool> favStation(bool isFav, int id) async {
    emit(LoadingGetStationsSearchState());

    try {
      if (isFav) {
        var response = await DioHelper.postData(
          url: "/api/stations/$id/favourite",
        );
        if (response.statusCode! >= 200 && response.statusCode! <= 300) {
          emit(SuccessGetStationsSearchState());
          return true;
        } else {
          emit(ErrorGetStationsSearchState());
          return false;
        }
      } else {
        var response = await DioHelper.deleteData(
          url: "/api/stations/$id/favourite",
        );
        if (response.statusCode! >= 200 && response.statusCode! <= 300) {
          emit(SuccessGetStationsSearchState());
          return true;
        } else {
          emit(ErrorGetStationsSearchState());
          return false;
        }
      }
    } catch (e) {
      emit(ErrorGetStationsSearchState());
      return false;
    }
  }
}
