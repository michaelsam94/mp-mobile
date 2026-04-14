import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/services/websocket_cubit/websocket_cubit.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/map/map_cubit/map_cubit.dart';
import 'package:mega_plus/presentation/map/models/map_station_response_model.dart';
import 'package:mega_plus/presentation/map/models/station_response_model.dart';
import 'package:mega_plus/presentation/map/search_cubit/search_cubit.dart';
import 'package:mega_plus/presentation/map/station_details_bottom_sheet.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/map/station_details_cubit/station_details_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchCubit = SearchCubit.get(context);
      // Reset search state when screen opens
      searchCubit.resetSearchState();
      // Clear search text field
      _searchController.clear();
      // Load nearby stations
      searchCubit.getStations();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    // Create a new timer with debounce duration (e.g., 300ms)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // This callback will be called after the debounce duration
      if (mounted) {
        // Always get all cached stations from MapCubit (not filtered results)
        // This ensures search works on the full dataset, then filters are applied
        final mapCubit = MapCubit.get(context);
        final cachedStations = mapCubit.mapStations;
        SearchCubit.get(
          context,
        ).searchStations(value, cachedStations: cachedStations);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    BackButton(),
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Color(0xffFBFBFB),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.searchStationsHint,
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xffB6B6B6),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                "assets/icons/search.svg",
                              ),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      SearchCubit.get(context).clearSearch();
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xffFBFBFB),
                          ),
                        ),
                      ),
                    ),

                    // في search_screen.dart، فك الـ comment على الـ filter button:
                    SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FilterBottomSheet(
                            selectedStatus: SearchCubit.get(
                              context,
                            ).filterStatus,
                            selectedConnectorType: SearchCubit.get(
                              context,
                            ).filterConnectorType,
                            favouriteOnly: SearchCubit.get(
                              context,
                            ).filterFavouriteOnly,
                            minimumPower: SearchCubit.get(
                              context,
                            ).filterMinimumPower,
                            onApplyFilters:
                                ({
                                  status,
                                  connectorType,
                                  favouriteOnly,
                                  minimumPower,
                                }) {
                                  // Clear search field when filters are applied
                                  _searchController.clear();
                                  // Get cached stations from MapCubit
                                  final mapCubit = MapCubit.get(context);
                                  final cachedStations = mapCubit.mapStations;
                                  SearchCubit.get(context).applyFilters(
                                    status: status,
                                    connectorType: connectorType,
                                    favouriteOnly: favouriteOnly,
                                    minimumPower: minimumPower,
                                    cachedStations: cachedStations,
                                  );
                                },
                          ),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/filter.svg",
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocListener<WebSocketCubit, WebSocketState>(
                listener: (context, state) {
                  if (state is StatusNotificationUpdate) {
                    // Update SearchCubit with new station/connector status
                    SearchCubit.get(context).updateStationFromWebSocket(
                      state.data.stationId,
                      state.data.stationStatus,
                      state.data.connectorId,
                      state.data.connectorStatus,
                    );
                  }
                },
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is LoadingGetStationsSearchState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ShimmerWidget(
                                      width: 80,
                                      height: 24,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    ShimmerWidget(
                                      width: 24,
                                      height: 24,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 8),
                                    ShimmerWidget(
                                      width: 39,
                                      height: 48,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ShimmerWidget(
                                            width: double.infinity,
                                            height: 20,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          ShimmerWidget(
                                            width: 120,
                                            height: 16,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                ShimmerWidget(
                                  width: double.infinity,
                                  height: 1,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    ShimmerWidget(
                                      width: 40,
                                      height: 40,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ShimmerWidget(
                                            width: double.infinity,
                                            height: 18,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          ShimmerWidget(
                                            width: 100,
                                            height: 14,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  final cubit = SearchCubit.get(context);
                  final mapCubit = MapCubit.get(context);

                  // Determine which stations to display
                  List<dynamic> displayStations;
                  bool isNearbyMode =
                      !cubit.useCachedStations &&
                      cubit.searchQuery.isEmpty &&
                      cubit.filterStatus == null &&
                      cubit.filterConnectorType == null &&
                      cubit.filterMinimumPower == null &&
                      !cubit.filterFavouriteOnly;

                  if (isNearbyMode) {
                    // Show nearby stations (MapStationResponseModel)
                    // Use filtered list if filters are applied, otherwise use original
                    displayStations = cubit.filterFavouriteOnly 
                        ? cubit.filteredNearbyStations 
                        : cubit.nearbyStations;
                  } else {
                    // Use cached stations from map if available, otherwise use filtered
                    if (mapCubit.mapStations.isNotEmpty &&
                        !cubit.useCachedStations) {
                      // Switch to cached stations for search/filter
                      cubit.useMapCachedStations(mapCubit.mapStations);
                    }
                    // Show filtered cached stations (StationResponseModel)
                    displayStations = cubit.filteredStations;
                  }

                  if (displayStations.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              cubit.searchQuery.isEmpty
                                  ? AppLocalizations.of(context)!.noStationsAvailable
                                  : AppLocalizations.of(context)!.noStationsFound(cubit.searchQuery),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemCount: displayStations.length,
                    itemBuilder: (context, index) {
                      final station = displayStations[index];
                      final isNearbyStation =
                          station is MapStationResponseModel;

                      // Extract station data based on type
                      int? stationId;
                      String? stationName;
                      String? stationStatus;
                      MapStationResponseModel? nearbyStation;
                      StationResponseModel? fullStation;
                      bool isFav = false;

                      if (isNearbyStation) {
                        nearbyStation = station;
                        stationId = nearbyStation.id;
                        stationName = nearbyStation.name;
                        stationStatus = nearbyStation.status;
                        isFav = nearbyStation.isFavourite ?? false;
                      } else {
                        fullStation = station;
                        stationId = fullStation!.id;
                        stationName = fullStation.name;
                        stationStatus = fullStation.status;
                        isFav = fullStation.isFavourite ?? false;
                      }

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            if (stationId != null) {
                              // Show bottom sheet first, then fetch data
                              showStationDetails(context);
                              // Fetch station details after bottom sheet is shown
                              Future.microtask(() {
                                StationDetailsCubit.get(
                                  context,
                                ).getStationDetails(stationId!);
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _statusBadge(stationStatus ?? ""),
                                    if (CacheHelper.checkLogin() == 3)
                                      InkWell(
                                        onTap: () async {
                                          final l10n = AppLocalizations.of(context)!;
                                          final removedMsg = l10n.removedFromFavorites;
                                          final addedMsg = l10n.addedToFavorites;
                                          final failedMsg = l10n.failedToUpdateFavorite;
                                          var done = await SearchCubit.get(
                                            context,
                                          ).favStation(!isFav, stationId ?? 0, context: context);
                                          if (!context.mounted) return;
                                          if (done) {
                                            context.showSuccessMessage(
                                              isFav ? removedMsg : addedMsg,
                                            );
                                          } else {
                                            context.showErrorMessage(failedMsg);
                                          }
                                        },
                                        child: Icon(
                                          isFav
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: AppColors.primary,
                                          size: 24,
                                        ),
                                      ),
                                  ],
                                ), // main badge at top
                                SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 8),
                                    Image.asset(
                                      fullStation != null
                                          ? SearchCubit.get(
                                              context,
                                            ).getStationIconPath(fullStation)
                                          : nearbyStation
                                                    ?.getStationIconPath() ??
                                                "assets/images/ac_available.png",
                                      height: 48,
                                      width: 39,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            stationName ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          if (isNearbyStation &&
                                              nearbyStation != null) ...[
                                            if (nearbyStation.distance != null)
                                              Text(
                                                AppLocalizations.of(context)!.kmAway(double.parse(nearbyStation.distance!).toStringAsFixed(1)),
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15,
                                                ),
                                              ),
                                            if (nearbyStation.totalGunsFormat !=
                                                null)
                                              Text(
                                                AppLocalizations.of(context)!.gunsCount(nearbyStation.totalGunsFormat!),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                ),
                                              ),
                                          ] else if (fullStation != null) ...[
                                            Text(
                                              fullStation.address ?? "",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 15,
                                              ),
                                            ),
                                            if (fullStation.city != null)
                                              Text(
                                                fullStation.city ?? "",
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                ),
                                              ),
                                          ],
                                          // Row(
                                          //   children: [
                                          //     SvgPicture.asset(
                                          //       "assets/icons/car.svg",
                                          //     ),
                                          //     SizedBox(width: 3),
                                          //     Text(
                                          //       station['mins'].toString(),
                                          //       style: TextStyle(fontSize: 13),
                                          //     ),
                                          //     SizedBox(width: 12),
                                          //     SvgPicture.asset(
                                          //       "assets/icons/distance.svg",
                                          //     ),

                                          //     SizedBox(width: 3),
                                          //     Text(
                                          //       station['distance'].toString(),
                                          //       style: TextStyle(fontSize: 13),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                    // SvgPicture.asset("assets/icons/navigation.svg"),
                                  ],
                                ),
                                if (!isNearbyStation &&
                                    fullStation != null) ...[
                                  SizedBox(height: 16),
                                  Divider(color: Color(0xffE6ECEF)),
                                  SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)!.connectorsTypes,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  if (fullStation.guns != null &&
                                      fullStation.guns!.isNotEmpty)
                                    Column(
                                      children: fullStation.guns!.map<Widget>((
                                        connector,
                                      ) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    _getGunIconPath(
                                                      connector.type,
                                                      connector.status,
                                                    ),
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    connector.maxPower != null
                                                        ? '${connector.maxPower} kW'
                                                        : 'N/A',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            connector.type ??
                                                                'Unknown Type',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        _statusBadge(
                                                          _formatConnectorStatus(
                                                            connector.status,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      connector.name ??
                                                          "Connector no/name",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                    Text(
                                                      connector.price != null
                                                          ? "${connector.price} ${AppLocalizations.of(context)!.egp}/KW"
                                                          : AppLocalizations.of(context)!.priceNotAvailable,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Colors.green[700],
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.noConnectorsAvailable,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                ] else if (isNearbyStation &&
                                    nearbyStation != null &&
                                    nearbyStation.totalGunsFormat != null) ...[
                                  SizedBox(height: 16),
                                  Divider(color: Color(0xffE6ECEF)),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.availableGunsLabel,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${nearbyStation.availableGuns ?? "0"}/${nearbyStation.totalGuns ?? "0"}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Determines if the gun type is DC or AC
  bool _isDCType(String? type) {
    if (type == null) return false;
    final upperType = type.toUpperCase();
    return upperType.contains('CCS2') ||
        upperType.contains('CHADEMO') ||
        upperType.contains('TESLA') ||
        upperType.contains('GB-T');
  }

  /// Gets the appropriate icon path based on gun type and status
  String _getGunIconPath(String? type, String? status) {
    final isDC = _isDCType(type);
    final statusLower = status?.toLowerCase() ?? 'available';

    String statusKey;
    if (statusLower == 'inuse' || statusLower == 'in_use') {
      statusKey = 'inuse';
    } else if (statusLower == 'unavailable') {
      statusKey = isDC
          ? 'unavailable'
          : 'unavailabe'; // Note: AC has typo in filename
    } else {
      statusKey = 'available';
    }

    final prefix = isDC ? 'dc' : 'ac';
    return 'assets/images/${prefix}_$statusKey.png';
  }

  String _formatConnectorStatus(String? status) {
    if (status == null) return 'available';
    final statusLower = status.toLowerCase();
    if (statusLower == 'inuse' || statusLower == 'in_use') {
      return 'inUse';
    }
    return statusLower;
  }

  Widget _statusBadge(String status) {
    Color colorBG;
    Color colorText;
    switch (status) {
      case 'available':
        colorText = Color(0xff058A3C);
        break;
      case 'inUse':
        colorText = Color(0xff1261FF);
        break;
      case 'unavailable':
        colorText = Color(0xffC31D07);
        break;
      default:
        colorText = Colors.grey.shade300;
    }
    switch (status) {
      case 'available':
        colorBG = Color(0xffE6F9EE);
        break;
      case 'inUse':
        colorBG = Color(0xffE8EFFF);
        break;
      case 'unavailable':
        colorBG = Color(0xffFFEAE7);
        break;
      default:
        colorBG = Colors.grey.shade300;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorBG,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: colorText,
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final String? selectedStatus;
  final String? selectedConnectorType;
  final bool? favouriteOnly;
  final String? minimumPower;
  final Function({
    String? status,
    String? connectorType,
    bool? favouriteOnly,
    String? minimumPower,
  })
  onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.selectedStatus,
    this.selectedConnectorType,
    this.favouriteOnly,
    this.minimumPower,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedStatus;
  String? selectedConnectorType;
  bool favouriteOnly = false;
  String? selectedPower;

  final List<String> powerOptions = [
    '7kw',
    '11kw',
    '22kw',
    '50kw',
    '100kw',
    '150kw',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.selectedStatus;
    selectedConnectorType = widget.selectedConnectorType;
    favouriteOnly = widget.favouriteOnly ?? false;
    selectedPower = widget.minimumPower;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),

          // Title
          Text(
            AppLocalizations.of(context)!.filterBy,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          SizedBox(height: 24),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Station Status
                  Text(
                    AppLocalizations.of(context)!.stationStatus,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _filterButton(
                          label: AppLocalizations.of(context)!.available,
                          isSelected: selectedStatus == 'available',
                          onTap: () {
                            setState(() {
                              selectedStatus = selectedStatus == 'available'
                                  ? null
                                  : 'available';
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _filterButton(
                          label: AppLocalizations.of(context)!.inUse,
                          isSelected: selectedStatus == 'inUse',
                          onTap: () {
                            setState(() {
                              selectedStatus = selectedStatus == 'inUse'
                                  ? null
                                  : 'inUse';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Connector Type
                  Text(
                    AppLocalizations.of(context)!.connectorType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _filterButton(
                          label: 'AC',
                          isSelected: selectedConnectorType == 'AC',
                          onTap: () {
                            setState(() {
                              selectedConnectorType =
                                  selectedConnectorType == 'AC' ? null : 'AC';
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _filterButton(
                          label: 'DC',
                          isSelected: selectedConnectorType == 'DC',
                          onTap: () {
                            setState(() {
                              selectedConnectorType =
                                  selectedConnectorType == 'DC' ? null : 'DC';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Favourite Stations (only show if logged in)
                  if (CacheHelper.checkLogin() == 3) ...[
                    Text(
                      AppLocalizations.of(context)!.favouriteStations,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: 12),
                    _filterButton(
                      label: AppLocalizations.of(context)!.favouriteOnly,
                      icon: Icons.star_border,
                      isSelected: favouriteOnly,
                      onTap: () {
                        setState(() {
                          favouriteOnly = !favouriteOnly;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                  ],

                  // Minimum Power
                  Text(
                    AppLocalizations.of(context)!.minimumPower,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedPower,
                        hint: Text(
                          AppLocalizations.of(context)!.selectMinimumPower,
                          style: TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontSize: 14,
                          ),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF212121),
                        ),
                        items: powerOptions.map((String power) {
                          return DropdownMenuItem<String>(
                            value: power,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  power,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedPower = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Apply Filters Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(
                        status: selectedStatus,
                        connectorType: selectedConnectorType,
                        favouriteOnly: favouriteOnly,
                        minimumPower: selectedPower,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.applyFilters,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Reset All Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedStatus = null;
                        selectedConnectorType = null;
                        favouriteOnly = false;
                        selectedPower = null;
                      });
                      widget.onApplyFilters(
                        status: null,
                        connectorType: null,
                        favouriteOnly: false,
                        minimumPower: null,
                      );
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.resetAll,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFD1FADF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Color(0xFFBDBDBD),
                size: 20,
              ),
              SizedBox(width: 8),
            ],
            if (isSelected)
              Icon(Icons.check, color: AppColors.primary, size: 18),
            if (isSelected) SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
