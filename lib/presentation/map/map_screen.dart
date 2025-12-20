import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/auth/guest_bottom_sheet.dart';
import 'package:mega_plus/presentation/map/map_cubit/map_cubit.dart';
import 'package:mega_plus/presentation/map/search_screen.dart';
import 'package:mega_plus/presentation/map/station_details_bottom_sheet.dart';
import 'package:mega_plus/presentation/map/station_details_cubit/station_details_cubit.dart';
import 'package:mega_plus/presentation/notifications/notifications_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isStatusCardCollapsed = false;

  @override
  void initState() {
    super.initState();
    // ✅ Load data مرة واحدة بس في initState
    Future.microtask(() {
      //Todo Get Back
      MapCubit.get(context).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(CacheHelper.getString("token"));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.goTo(SearchScreen());
                      },
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Color(0xffFBFBFB),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Search your Model',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xffB6B6B6),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            suffixIcon: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                border: BorderDirectional(
                                  start: BorderSide(color: Color(0xffDCDCDC)),
                                ),
                                borderRadius: BorderRadiusDirectional.only(
                                  bottomEnd: Radius.circular(11),
                                  topEnd: Radius.circular(11),
                                ),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/filter.svg",
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                "assets/icons/search.svg",
                              ),
                            ),
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
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      // Check if user is logged in for notifications
                      if (CacheHelper.checkLogin() != 3) {
                        GuestBottomSheet.show(context);
                        return;
                      }
                      context.goTo(NotificationsScreen());
                    },
                    child: SvgPicture.asset("assets/icons/notifications.svg"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<MapCubit, MapState>(
                listener: (context, state) {
                  if (state is MarkerTappedState) {
                    // Show bottom sheet first, then fetch data
                    showStationDetails(context);
                    // Fetch station details after bottom sheet is shown
                    Future.microtask(() {
                      StationDetailsCubit.get(context).getStationDetails(state.stationId);
                    });
                  } else if (state is LoadedMapState) {
                    // Zoom to current location when map is loaded (only once)
                    final cubit = MapCubit.get(context);
                    if (cubit.userLatLng != null && 
                        cubit.mapController != null && 
                        !cubit.hasZoomedToLocation) {
                      // Small delay to ensure map is fully initialized
                      Future.delayed(Duration(milliseconds: 300), () {
                        if (!cubit.hasZoomedToLocation) {
                          cubit.zoomToCurrentLocation();
                        }
                      });
                    }
                  }
                },
                builder: (context, state) {
                  final cubit = MapCubit.get(context);

                  if (state is LoadingMapState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerWidget(
                            width: 50,
                            height: 50,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          SizedBox(height: 16),
                          ShimmerWidget(
                            width: 150,
                            height: 16,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ErrorMapState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16),
                          Text('Error: ${state.message}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => cubit.initData(),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Handle MarkerTappedState by showing the map (listener handles the bottom sheet)
                  // Treat MarkerTappedState as LoadedMapState for UI purposes
                  if (state is MarkerTappedState || state is LoadedMapState) {
                    return Stack(
                    children: [
                      //Todo Get Back
                      GoogleMap(
                        padding: EdgeInsets.only(top: 120),
                        initialCameraPosition: CameraPosition(
                          target: cubit.userLatLng ?? LatLng(30.0444, 31.2357),
                          zoom: 13.5, // 5km radius zoom level
                        ),
                        markers: cubit.markers,
                        onMapCreated: cubit.onMapCreated,
                        onCameraMove: cubit.onCameraMove,
                        onCameraIdle: cubit.onCameraIdle,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        buildingsEnabled: false,
                        compassEnabled: false,
                      ),

                      // Location button (bottom right)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              cubit.zoomToCurrentLocation();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.my_location,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Status Container
                      Positioned(
                        top: 8,
                        right: 8,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: _isStatusCardCollapsed ? 50 : 170,
                          padding: EdgeInsets.symmetric(
                            horizontal: _isStatusCardCollapsed ? 0 : 12,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: _isStatusCardCollapsed
                              ? Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.chevron_left,
                                      color: Color(0xff242426),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isStatusCardCollapsed = false;
                                      });
                                    },
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: const Text(
                                            "Station Status",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Color(0xff242426),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(
                                            minWidth: 24,
                                            minHeight: 24,
                                          ),
                                          icon: Icon(
                                            Icons.chevron_right,
                                            size: 20,
                                            color: Color(0xff242426),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isStatusCardCollapsed = true;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/ac.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: const Text(
                                            "Available",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff606060),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/unavailable.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: const Text(
                                            "Unavailable",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff606060),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/use.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: const Text(
                                            "In Use",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff606060),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

