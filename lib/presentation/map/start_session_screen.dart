import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/map/charger_screen.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';

import '../../core/services/charging_cubit/charging_cubit.dart';
import '../../core/services/websocket_cubit/websocket_cubit.dart';
import '../../core/style/app_colors.dart';

class StartSessionScreen extends StatelessWidget {
  const StartSessionScreen({
    super.key,
    required this.chargerId,
    required this.connectorId,
    required this.rfidCode,
  });

  final String chargerId;
  final String connectorId;
  final String rfidCode;

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebSocketCubit, WebSocketState>(
      listener: (context, state) {
        // Show success message when notification arrives (in ChargerScreen)
        if (state is NotificationUpdate) {
          context.showSuccessMessage(state.data.title);
        }
      },
      child: Scaffold(
        body: BlocConsumer<ChargingCubit, ChargingState>(
          listener: (context, state) {
            // Note: Error handling is done in ChargerScreen since we navigate immediately
            // If there's an error, it will be shown in ChargerScreen
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
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
                        ChargingCubit.get(context).startCharging(
                          chargerId,
                          int.parse(connectorId),
                          defaultRFID.code!,
                        );
                        // Navigate immediately to ChargerScreen to show shimmer
                        // The shimmer will disappear when WebSocket receives meter data
                        if (context.mounted) {
                          context.goOff(ChargerScreen());
                        }
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
                  SizedBox(height: 60),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
