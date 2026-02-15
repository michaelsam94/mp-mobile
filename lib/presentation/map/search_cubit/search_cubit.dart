import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/map/map_cubit/map_cubit.dart';
import 'package:mega_plus/presentation/map/models/map_station_response_model.dart';
import 'package:mega_plus/presentation/map/models/station_response_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  List<StationResponseModel> stations = [];
  List<StationResponseModel> filteredStations = [];
  List<MapStationResponseModel> nearbyStations = [];
  List<MapStationResponseModel> filteredNearbyStations = [];
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
        auth: CacheHelper.checkLogin() == 3, // Add token if user is logged in
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        nearbyStations = data
            .map((e) => MapStationResponseModel.fromJson(e))
            .toList();
        // Reset filtered nearby stations
        filteredNearbyStations = [];
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
      // If not using cached stations, filter nearby stations
      filteredNearbyStations = nearbyStations.where((station) {
        // Apply favorite filter if enabled
        if (filterFavouriteOnly && station.isFavourite != true) {
          return false;
        }
        return true;
      }).toList();
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

      // Favourite filter
      bool matchesFavourite = !filterFavouriteOnly || (station.isFavourite == true);

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
          matchesFavourite &&
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
    filteredNearbyStations = [];
    applyFiltersAndSearch();
  }

  void resetSearchState() {
    searchQuery = '';
    filterStatus = null;
    filterConnectorType = null;
    filterFavouriteOnly = false;
    filterMinimumPower = null;
    useCachedStations = false;
    filteredStations = [];
    filteredNearbyStations = [];
    emit(SearchUpdatedState());
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

  // Get the appropriate icon path for a station based on status and ac_compatible
  String getStationIconPath(StationResponseModel station) {
    // Use ac_compatible from API if available, otherwise fallback to checking guns
    final isDC = station.acCompatible != null 
        ? !(station.acCompatible ?? false)  // If ac_compatible is true, it's AC (not DC)
        : hasDCConnector(station);  // Fallback to checking guns if ac_compatible not available
    
    final statusLower = (station.status ?? 'available').toLowerCase();

    if (isDC) {
      // DC marker icons
      switch (statusLower) {
        case 'available':
          return 'assets/icons/dc_available.png';
        case 'unavailable':
          return 'assets/icons/dc_unavailable.png';
        case 'inuse':
        case 'in_use':
          return 'assets/icons/dc_inuse.png';
        default:
          return 'assets/icons/dc_available.png';
      }
    } else {
      // AC marker icons
      switch (statusLower) {
        case 'available':
          return 'assets/icons/ac.png';
        case 'unavailable':
          return 'assets/icons/unavailable.png';
        case 'inuse':
        case 'in_use':
          return 'assets/icons/use.png';
        default:
          return 'assets/icons/ac.png';
      }
    }
  }

  // Update station favorite status in cached lists (called from other cubits)
  void updateStationFavorite(int id, bool isFav) {
    // Update nearby stations
    for (var station in nearbyStations) {
      if (station.id == id) {
        station.isFavourite = isFav;
        break;
      }
    }
    // Update filtered nearby stations
    for (var station in filteredNearbyStations) {
      if (station.id == id) {
        station.isFavourite = isFav;
        break;
      }
    }
    // Update cached stations
    for (var station in stations) {
      if (station.id == id) {
        station.isFavourite = isFav;
        break;
      }
    }
    // Update filtered stations
    for (var station in filteredStations) {
      if (station.id == id) {
        station.isFavourite = isFav;
        break;
      }
    }
    emit(SearchUpdatedState());
  }

  //add station to favouries
  Future<bool> favStation(bool isFav, int id, {BuildContext? context}) async {
    try {
      bool success = false;
      if (isFav) {
        // Add to favorites - POST request
        var response = await DioHelper.postData(
          url: "/api/stations/$id/favourite",
        );
        if (response.statusCode! >= 200 && response.statusCode! <= 300) {
          success = true;
        }
      } else {
        // Remove from favorites - DELETE request
        var response = await DioHelper.deleteData(
          url: "/api/stations/$id/favourite",
        );
        if (response.statusCode! >= 200 && response.statusCode! <= 300) {
          success = true;
        }
      }

      if (success) {
        // Update local state
        updateStationFavorite(id, isFav);

        // Update MapCubit cached list if context is provided
        if (context != null) {
          try {
            MapCubit.get(context).updateStationFavorite(id, isFav);
          } catch (e) {
            // MapCubit might not be available, ignore
          }
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Normalize OCPP status to app format
  String _normalizeOcppStatus(String status) {
    final statusLower = status.toLowerCase();

    // Map OCPP statuses to app format
    switch (statusLower) {
      case 'available':
        return 'available';
      case 'charging':
      case 'preparing':
      case 'finishing':
        return 'inUse';
      case 'unavailable':
      case 'faulted':
      case 'suspendedevse':
      case 'suspendedev':
      case 'reserved':
        return 'unavailable';
      default:
        return statusLower;
    }
  }

  // Update station and connector status from WebSocket
  void updateStationFromWebSocket(int stationId, String stationStatus, int connectorId, String connectorStatus) {
    bool updated = false;

    // Update in nearbyStations (MapStationResponseModel - only has status, no guns)
    for (var station in nearbyStations) {
      if (station.id == stationId) {
        station.status = _normalizeOcppStatus(stationStatus);
        updated = true;
        break;
      }
    }

    // Update in filteredNearbyStations (MapStationResponseModel - only has status, no guns)
    for (var station in filteredNearbyStations) {
      if (station.id == stationId) {
        station.status = _normalizeOcppStatus(stationStatus);
        updated = true;
        break;
      }
    }

    // Update in cached stations
    for (var station in stations) {
      if (station.id == stationId) {
        station.status = _normalizeOcppStatus(stationStatus);
        if (station.guns != null) {
          for (var gun in station.guns!) {
            if (gun.id == connectorId) {
              gun.status = _normalizeOcppStatus(connectorStatus);
              break;
            }
          }
        }
        updated = true;
        break;
      }
    }

    // Update in filteredStations
    for (var station in filteredStations) {
      if (station.id == stationId) {
        station.status = _normalizeOcppStatus(stationStatus);
        if (station.guns != null) {
          for (var gun in station.guns!) {
            if (gun.id == connectorId) {
              gun.status = _normalizeOcppStatus(connectorStatus);
              break;
            }
          }
        }
        updated = true;
        break;
      }
    }

    // Emit state if any update occurred
    if (updated) {
      emit(SearchUpdatedState());
    }
  }
}
