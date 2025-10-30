import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/presentation/map/cubit/map_cubit.dart';
import 'package:mega_plus/presentation/map/search_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MapCubit.get(context).initState(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
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
                  SvgPicture.asset("assets/icons/notifications.svg"),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<MapCubit, MapState>(
                builder: (context, state) {
                  if (state is LoadingMapState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Stack(
                    children: [
                      GoogleMap(
                        padding: const EdgeInsets.only(top: 120, bottom: 0),
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(30.0444, 31.2357),
                          zoom: 13,
                        ),
                        markers: MapCubit.get(context).markers,
                        onMapCreated: (ctrl) =>
                            MapCubit.get(context).mapController = ctrl,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        buildingsEnabled: false,
                        compassEnabled: false,
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
