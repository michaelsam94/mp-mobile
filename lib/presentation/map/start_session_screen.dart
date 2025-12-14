import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/presentation/map/charger_screen.dart';

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
        if (state is NotificationUpdate) {
          context.showSuccessMessage(state.data.title);
          Future.delayed(Duration(seconds: 1), () {
            if (context.mounted) {
              context.goOff(ChargerScreen());
            }
          });
        }
      },
      child: Scaffold(
        body: BlocConsumer<ChargingCubit, ChargingState>(
          listener: (context, state) {
            // if (state is ChargingSuccess) {
            //   if (state.data) {
            //     context.goTo(ChargerScreen());
            //   }
            // } else
            if (state is ChargingError) {
              context.showErrorMessage(state.message);
            }
          },
          builder: (context, state) {
            if (state is ChargingLoading || state is ChargingSuccess) {
              return Center(child: CircularProgressIndicator());
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
                        ChargingCubit.get(context).startCharging(
                          chargerId,
                          int.parse(connectorId),
                          rfidCode,
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
