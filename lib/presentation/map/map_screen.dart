import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/presentation/map/map_cubit/map_cubit.dart';
import 'package:mega_plus/presentation/map/search_screen.dart';
import 'package:mega_plus/presentation/notifications/notifications_screen.dart';

import 'models/map_station_response_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Load data مرة واحدة بس في initState
    Future.microtask(() {
      //Todo Get Back
      MapCubit.get(context).initData(context);
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
                      context.goTo(NotificationsScreen());
                    },
                    child: SvgPicture.asset("assets/icons/notifications.svg"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<MapCubit, MapState>(
                builder: (context, state) {
                  final cubit = MapCubit.get(context);

                  if (state is LoadingMapState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading stations...'),
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
                            onPressed: () => cubit.initData(context),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      //Todo Get Back
                      GoogleMap(
                        padding: EdgeInsets.only(top: 120),
                        initialCameraPosition: CameraPosition(
                          target: LatLng(30.0444, 31.2357),
                          zoom: 14,
                        ),
                        markers: cubit.markers,
                        onMapCreated: cubit.onMapCreated,
                        onCameraMove: cubit.onCameraMove,
                        onCameraIdle: () {
                          cubit.onCameraIdle(context);
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        buildingsEnabled: false,
                        compassEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                      if (state is RefreshingMapState)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.15),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      Positioned(
                        bottom: 25,
                        right: 16,
                        child: InkWell(
                          onTap: () {
                            MapCubit.get(
                              context,
                            ).refreshStationsByCurrentLocation(context);
                          },

                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              "assets/icons/location.svg",
                            ),
                          ),
                        ),
                      ),

                      // Status Container
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 170,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Station Status",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xff242426),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _Dot(color: Colors.green),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "Available",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff606060),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _Dot(color: Colors.red),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "Unavailable",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff606060),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _Dot(color: Colors.blue),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "In Use",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff606060),
                                      fontWeight: FontWeight.w400,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showStationBottomSheet(
  MapStationResponseModel station,
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container();
        },
      );
    },
  );
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
