import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/services/charging_api_service.dart';
import 'package:mega_plus/core/services/charging_cubit/charging_cubit.dart';
import 'package:mega_plus/core/services/websocket_cubit/websocket_cubit.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/map/charger_screen.dart';
import 'package:mega_plus/presentation/map/qr_code_scanner_screen.dart';
import 'package:mega_plus/presentation/vehicles/cubit/current_vehicle_charging_cubit.dart';
import 'package:mega_plus/presentation/vehicles/models/vehicle_charging_response_model.dart';

class CurrentVehicleChargingScreen extends StatefulWidget {
  const CurrentVehicleChargingScreen({super.key});

  @override
  State<CurrentVehicleChargingScreen> createState() => _CurrentVehicleChargingScreenState();
}

class _CurrentVehicleChargingScreenState extends State<CurrentVehicleChargingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CurrentVehicleChargingCubit.get(context).getVehiclesCharging();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      "Current Vehicle Charging",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff212121),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: BlocConsumer<CurrentVehicleChargingCubit, CurrentVehicleChargingState>(
                listener: (context, state) {
                  if (state is ErrorCurrentVehicleChargingState) {
                    context.showErrorMessage(state.message);
                  }
                },
                builder: (context, state) {
                  if (state is LoadingCurrentVehicleChargingState) {
                    return _buildLoadingState();
                  }

                  final cubit = CurrentVehicleChargingCubit.get(context);
                  final vehicles = cubit.vehicles;

                  if (vehicles.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await cubit.getVehiclesCharging();
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        return _buildVehicleCard(context, vehicle);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ShimmerWidget(width: 40, height: 40, borderRadius: BorderRadius.circular(20)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(width: 100, height: 24, borderRadius: BorderRadius.circular(4)),
                        SizedBox(height: 8),
                        ShimmerWidget(width: 150, height: 16, borderRadius: BorderRadius.circular(4)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ShimmerWidget(width: double.infinity, height: 56, borderRadius: BorderRadius.circular(12)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.electric_car_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No vehicles found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add a vehicle to start charging',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, VehicleChargingResponseModel vehicle) {
    final hasChargingSession = vehicle.chargingSession != null;
    final isCharging = vehicle.isCharging;
    final session = vehicle.chargingSession;
    final batteryPercentage = session?.currentBatteryPercentage != null
        ? double.tryParse(session!.currentBatteryPercentage!) ?? 0.0
        : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Charging Status and Vehicle Info
          InkWell(
            onTap: hasChargingSession ? () => _handleChargingVehicleTap(context, vehicle) : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Charging Status Icon
                Container(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rounded Progress Bar - only show for active charging sessions
                      if (isCharging)
                        CircularProgressIndicator(
                          value: batteryPercentage > 0 ? batteryPercentage / 100 : 0.0,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey[200]!,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      // Lightning Icon
                      Icon(
                        Icons.bolt,
                        color: hasChargingSession 
                            ? (isCharging ? AppColors.primary : Colors.grey[400])
                            : Colors.grey[400],
                        size: 30,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Vehicle Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Battery Percentage and Range
                      // Show percentage for active charging sessions, or "N/A" if stopped or no session
                      Text(
                        isCharging 
                            ? (batteryPercentage > 0 ? "${batteryPercentage.toInt()}%" : "0%")
                            : "N/A",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Vehicle Name and Details
                      Text(
                        vehicle.carModel ?? "Unknown Model",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        vehicle.plateNumber ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Vehicle Image
                Container(
                  width: 120,
                  height: 80,
                  child: Image.asset(
                    "assets/images/vehicle_image_green_circle.png",
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 30),
          
          // Action Button
          BlocListener<ChargingCubit, ChargingState>(
            listener: (context, state) {
              if (state is StopChargingSuccess) {
                context.showSuccessMessage("Charging stopped successfully");
                // Don't clear meter data here - it will be cleared when starting a new session
                // Refresh the list
                CurrentVehicleChargingCubit.get(context).getVehiclesCharging();
              } else if (state is ChargingError) {
                context.showErrorMessage(state.message);
              }
            },
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isCharging
                    ? () => _handleStopCharging(context, vehicle)
                    : () => _handleStartCharging(context, vehicle),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCharging 
                      ? Colors.red.shade50 
                      : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isCharging 
                          ? Colors.red 
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCharging ? Icons.pause : Icons.play_arrow,
                      color: isCharging ? Colors.red : Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      isCharging ? "Stop Charging" : "Start Charging",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCharging ? Colors.red : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleChargingVehicleTap(
    BuildContext context,
    VehicleChargingResponseModel vehicle,
  ) async {
    if (!vehicle.isCharging || vehicle.chargingSession == null) return;

    final session = vehicle.chargingSession!;
    final sessionId = session.id;

    if (sessionId == null) {
      context.showErrorMessage("Session ID not available");
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call the current charging API with session id
      final response = await ChargingApiService.getCurrentChargingBySession(sessionId);

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (response.statusCode == 200 && response.data != null) {
        // Initialize meter data in WebSocketCubit from API response
        if (context.mounted) {
          context.read<WebSocketCubit>().initializeMeterDataFromApi(response.data);
        }
        
        // Navigate to ChargerScreen
        if (context.mounted) {
          context.goTo(const ChargerScreen());
        }
      } else {
        // Show error message
        if (context.mounted) {
          context.showErrorMessage(
            response.data['message'] ?? 'Failed to load charging session',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog if still open
        context.showErrorMessage("Error loading charging session");
      }
    }
  }

  Future<void> _handleStopCharging(
    BuildContext context,
    VehicleChargingResponseModel vehicle,
  ) async {
    if (!vehicle.isCharging || vehicle.chargingSession == null) return;

    final session = vehicle.chargingSession!;
    final chargerId = session.chargerId?.toString() ?? "";
    final transactionId = session.transactionId ?? "";
    final connectorId = session.connectorId ?? "";

    if (chargerId.isEmpty || transactionId.isEmpty || connectorId.isEmpty) {
      context.showErrorMessage("Missing charging session data");
      return;
    }

    // Show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Stop Charging?'),
        content: Text('Are you sure you want to stop charging?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Stop', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ChargingCubit.get(context).stopCharging(
        chargerId,
        transactionId,
        connectorId,
      );
    }
  }

  Future<void> _handleStartCharging(
    BuildContext context,
    VehicleChargingResponseModel vehicle,
  ) async {
    // Navigate to QR scanner with vehicle id
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrCodeScannerScreen(vehicleId: vehicle.id),
      ),
    );

    // Refresh the vehicle list after returning from QR scanner
    // This ensures the list is updated if charging was started
    if (context.mounted) {
      CurrentVehicleChargingCubit.get(context).getVehiclesCharging();
    }
  }
}
