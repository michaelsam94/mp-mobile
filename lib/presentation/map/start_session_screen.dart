import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/map/charger_screen.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:mega_plus/presentation/wallet/top_up_screen.dart';

import '../../core/services/charging_cubit/charging_cubit.dart';
import '../../core/services/websocket_cubit/websocket_cubit.dart';
import '../../core/style/app_colors.dart';

class StartSessionScreen extends StatelessWidget {
  const StartSessionScreen({
    super.key,
    required this.chargerId,
    required this.connectorId,
    required this.rfidCode,
    this.vehicleId,
  });

  final String chargerId;
  final String connectorId;
  final String rfidCode;
  final int? vehicleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<ChargingCubit, ChargingState>(
          listener: (context, state) {
            if (state is ChargingError) {
              // Show error toast before navigating
              context.showErrorMessage(state.message);
            } else if (state is InsufficientBalanceState) {
              // Navigate to top-up screen when balance is insufficient
              context.showErrorMessage(state.message);
              if (context.mounted) {
                context.goTo(TopUpScreen());
              }
            } else if (state is ChargingSuccess) {
              // Clear cached meter data before navigating to charger screen
              // This ensures shimmer is shown until new meter values arrive
              if (context.mounted) {
                context.read<WebSocketCubit>().clearMeterData();
              }
              // Navigate to ChargerScreen only on success
              if (context.mounted) {
                context.goOff(ChargerScreen());
              }
            }
          },
          builder: (context, state) {
            if (state is ChargingLoading) {
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
            return Container(
              width: context.width(),
              height: context.height(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/session_started.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Image.asset("assets/icons/ic_plug.png",width: 72,height: 72,fit: BoxFit.fill,),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Please plug in the connector,\n then tap Start Session",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Get default RFID from ProfileCubit
                          final defaultRFID = ProfileCubit.get(context).defaultRFID;
                          if (defaultRFID?.code == null || defaultRFID!.code!.isEmpty) {
                            context.showErrorMessage("No default RFID card found. Please add an RFID card.");
                            return;
                          }
                          
                          // Start charging with default RFID
                          // Navigation will happen in listener on success, error toast on failure
                          ChargingCubit.get(context).startCharging(
                            chargerId,
                            int.parse(connectorId),
                            defaultRFID.code!,
                            vehicleId: vehicleId,
                          );
                        },
                        child: Text(
                          "Start Session",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    );
  }
}
