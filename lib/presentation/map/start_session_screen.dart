import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ChargingCubit, ChargingState>(
        listener: (context, state) {
          if (state is ChargingError) {
            context.showErrorMessage(state.message);
          } else if (state is InsufficientBalanceState) {
            context.showErrorMessage(state.message);
            if (context.mounted) {
              context.goTo(TopUpScreen());
            }
          } else if (state is ChargingSuccess) {
            if (context.mounted) {
              context.read<WebSocketCubit>().clearMeterData();
            }
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
                  const SizedBox(height: 16),
                  ShimmerWidget(
                    width: 150,
                    height: 16,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // MegaPlug Logo
                Image.asset(
                  "assets/images/logo.png",
                  height: 36,
                ),
                const SizedBox(height: 24),
                // Title
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${l10n.connectVehicleTitle}\n',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff121212),
                        ),
                      ),
                      TextSpan(
                        text: l10n.connectVehicleHighlight,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle with inline colored text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xff606060),
                      ),
                      children: [
                        TextSpan(text: l10n.connectVehicleSubtitle),
                        TextSpan(
                          text: l10n.startCharging,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: l10n.connectVehicleSubtitleEnd),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Charging image
                Expanded(
                  child: Image.asset(
                    "assets/images/session_started.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                // Tip card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffE6F9EE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.connectorTip,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xff121212),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Start Session button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.flash_on_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        l10n.startSession,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        final defaultRFID =
                            ProfileCubit.get(context).defaultRFID;
                        if (defaultRFID?.code == null ||
                            defaultRFID!.code!.isEmpty) {
                          context.showErrorMessage(l10n.noRfidError);
                          return;
                        }
                        ChargingCubit.get(context).startCharging(
                          chargerId,
                          int.parse(connectorId),
                          defaultRFID.code!,
                          vehicleId: vehicleId,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
