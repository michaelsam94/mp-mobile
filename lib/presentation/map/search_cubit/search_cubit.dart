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
  List<StationResponseModel> allCachedStations = []; // Keep all cached stations for re-filtering
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
        nearbyStations = data.map((e) => MapStationResponseModel.fromJson(e)).toList();
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

  void searchStations(String query, {List<StationResponseModel>? cachedStations}) {
    searchQuery = query.trim().toLowerCase();
    
    // If search query is empty, don't switch to cached stations (keep nearby stations)
    if (searchQuery.isEmpty) {
      useCachedStations = false;
      filteredStations = [];
      emit(SearchUpdatedState());
      return;
    }
    
    // Check if filters are applied
    bool hasFilters = filterStatus != null || 
                     filterConnectorType != null || 
                     filterMinimumPower != null || 
                     filterFavouriteOnly;
    
    if (hasFilters && useCachedStations && allCachedStations.isNotEmpty) {
      // Filters are applied, search within the filtered results
      // Use the already filtered stations as the base for search
      // Don't update stations list, keep using filtered results
    } else {
      // No filters applied, use all cached stations for searching
      if (cachedStations != null && cachedStations.isNotEmpty) {
        stations = cachedStations;
        allCachedStations = cachedStations; // Store all cached stations
        useCachedStations = true;
      }
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
    
    // Clear search query when filters are applied
    searchQuery = '';
    
    // Always use all cached stations when applying filters
    if (cachedStations != null && cachedStations.isNotEmpty) {
      stations = cachedStations; // Update with all cached stations
      allCachedStations = cachedStations; // Store all cached stations for later use
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

    // Check if filters are applied
    bool hasFilters = filterStatus != null || 
                     filterConnectorType != null || 
                     filterMinimumPower != null || 
                     filterFavouriteOnly;
    
    // If filters are applied and user is searching, search within the filtered results
    // First apply filters to get filtered results, then apply search on top
    List<StationResponseModel> stationsToFilter = stations;
    
    // Apply filters first
    if (hasFilters) {
      stationsToFilter = stations.where((station) {
        // Status filter
        bool matchesStatus =
            filterStatus == null || station.status == filterStatus;

        // Connector Type filter
        bool matchesConnectorType = filterConnectorType == null;
        if (!matchesConnectorType && station.guns != null && station.guns!.isNotEmpty) {
          if (filterConnectorType == 'DC') {
            matchesConnectorType = station.guns!.any((gun) {
              final type = gun.type?.toUpperCase() ?? '';
              return type.contains('CCS2') || 
                     type.contains('TESLA') || 
                     type.contains('CHADEMO') ||
                     type.contains('GB-T');
            });
          } else if (filterConnectorType == 'AC') {
            matchesConnectorType = station.guns!.any((gun) {
              final type = gun.type?.toUpperCase() ?? '';
              return type.contains('AC');
            });
          } else {
            matchesConnectorType = station.guns!.any(
              (gun) => gun.type?.toUpperCase().contains(filterConnectorType!.toUpperCase()) ?? false,
            );
          }
        }

        // Minimum Power filter
        bool matchesPower = filterMinimumPower == null;
        if (!matchesPower && station.guns != null && station.guns!.isNotEmpty) {
          double? minPowerValue = double.tryParse(
            filterMinimumPower!.replaceAll('kw', '').replaceAll('KW', '').trim(),
          );
          
          if (minPowerValue != null) {
            matchesPower = station.guns!.any((gun) {
              if (gun.maxPower == null || gun.maxPower!.isEmpty) {
                return false;
              }
              
              double? gunPower = double.tryParse(
                gun.maxPower!.replaceAll('kw', '').replaceAll('KW', '').trim(),
              );
              
              return gunPower != null && gunPower >= minPowerValue;
            });
          }
        }

        return matchesStatus && matchesConnectorType && matchesPower;
      }).toList();
    }
    
    // Now apply search on the filtered results (or all stations if no filters)
    filteredStations = stationsToFilter.where((station) {
      // Search filter - only apply if search query is not empty
      bool matchesSearch =
          searchQuery.isEmpty ||
          (station.name?.toLowerCase().contains(searchQuery) ?? false) ||
          (station.address?.toLowerCase().contains(searchQuery) ?? false) ||
          (station.city?.toLowerCase().contains(searchQuery) ?? false);

      return matchesSearch;
    }).toList();

    emit(SearchUpdatedState());
  }

  void clearSearch() {
    searchQuery = '';
    // Reset to nearby stations when search is cleared
    useCachedStations = false;
    filteredStations = [];
    getStations(); // Reload nearby stations
  }

  void resetSearchState() {
    // Reset all search and filter state
    searchQuery = '';
    useCachedStations = false;
    filteredStations = [];
    stations = [];
    nearbyStations = [];
    filterStatus = null;
    filterConnectorType = null;
    filterFavouriteOnly = false;
    filterMinimumPower = null;
    emit(SearchInitial());
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
}
