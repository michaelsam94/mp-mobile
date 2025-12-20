import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/vehicles/cubit/vehicles_cubit.dart';
import 'package:mega_plus/presentation/vehicles/models/vehicle_response_model.dart';
import 'package:mega_plus/presentation/vehicles/vehicle_details_screen.dart';
import 'package:mega_plus/presentation/vehicles/vehicle_setup_screen.dart';

import '../../core/style/app_colors.dart';

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  Widget vehicleCard(VehicleResponseModel item, BuildContext context) {
    return InkWell(
      onTap: () {
        context.goTo(VehicleDetailsScreen());
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/vehicle_image.png",
                  width: 140,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: Text(
                    item.connectorType ?? "",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Text(
              item.brandModel?.name ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 2),
            Text(
              item.brandModel?.brand?.name ?? "",
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            // SizedBox(height: 10),
            // Divider(color: Color(0xffE6ECEF)),
            // SizedBox(height: 10),
            // Text(
            //   "License Plate",
            //   style: TextStyle(color: Colors.grey[600], fontSize: 14),
            // ),
            // SizedBox(height: 2),
            // Text(
            //   "",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 19,
            //     color: Colors.black,
            //   ),
            // ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = VehiclesCubit.get(context);
    cubit.getVehicles();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 57,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffF2F4F8))),
                color: Colors.white,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset("assets/icons/back.svg"),
                    ),
                  ),
                  Center(
                    child: Text(
                      "My Vehicles",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff212121),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        context.goTo(VehicleSetupScreen());
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<VehiclesCubit, VehiclesState>(
              builder: (context, state) {
                return Expanded(
                  child: state is LoadingGetVehiclesState
                      ? ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Color(0xFFE6E7EF)),
                              ),
                              child: Row(
                                children: [
                                  ShimmerWidget(
                                    width: 80,
                                    height: 80,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ShimmerWidget(
                                          width: double.infinity,
                                          height: 20,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        SizedBox(height: 8),
                                        ShimmerWidget(
                                          width: 150,
                                          height: 16,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        SizedBox(height: 8),
                                        ShimmerWidget(
                                          width: 100,
                                          height: 16,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : cubit.vehicles.isEmpty
                      ? Center(
                          child: Text(
                            "No Vehicles Found, Please add you first vehicle",
                          ),
                        )
                      : ListView.builder(
                          itemCount: cubit.vehicles.length,
                          itemBuilder: (context, i) =>
                              vehicleCard(cubit.vehicles[i], context),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
