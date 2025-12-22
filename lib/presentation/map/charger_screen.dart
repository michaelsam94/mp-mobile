import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/services/charging_cubit/charging_cubit.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/models/session_update_model.dart';
import '../../core/services/websocket_cubit/websocket_cubit.dart';

class ChargerScreen extends StatefulWidget {
  const ChargerScreen({super.key});

  @override
  State<ChargerScreen> createState() => _ChargerScreenState();
}

class _ChargerScreenState extends State<ChargerScreen> {
  SessionStoppedData? stoppedData;
  bool? isSessionStopped;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text("Charging", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocConsumer<WebSocketCubit, WebSocketState>(
        listener: (context, state) {
          if (state is SessionUpdate) {
            final session = state.data;

            // إذا تم إيقاف الجلسة
            if (session.isSessionStopped) {
              isSessionStopped = true;
              stoppedData = session.stoppedData!;
              // showDialog(
              //   context: context,
              //   barrierDismissible: false,
              //   builder: (_) => AlertDialog(
              //     title: Text('Charging Complete'),
              //     content: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text('Reason: ${stopped.stopReason}'),
              //         SizedBox(height: 8),
              //         Text(
              //           'Energy Delivered: ${stopped.energyDeliveredValue.toStringAsFixed(2)} kWh',
              //         ),
              //         Text(
              //           'Duration: ${(stopped.durationValue / 60).toStringAsFixed(1)} min',
              //         ),
              //       ],
              //     ),
              //     actions: [
              //       TextButton(
              //         onPressed: () {
              //           Navigator.of(context).pop(); // Close dialog
              //           Navigator.of(context).pop(); // Go back
              //         },
              //         child: Text('OK'),
              //       ),
              //     ],
              //   ),
              // );
            }
          }

          if (state is NotificationUpdate) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.data.message)));
          }
        },
        builder: (context, state) {
          MeterValueData? meterData;
          String? transactionId;

          // الحصول على آخر meter data
          if (state is SessionUpdate && state.data.isMeterValue) {
            meterData = state.data.meterData;
            transactionId = state.data.transactionId;
          } else if (state is SessionUpdate && state.data.isSessionStopped) {
            isSessionStopped = true;
            stoppedData = state.data.stoppedData!;
            meterData = context.read<WebSocketCubit>().currentMeterData;
          }

          // Show shimmer if no meter data yet (initial loading state)
          if (meterData == null) {
            return _buildShimmerLoading();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _buildStationInfo(meterData),
                  SizedBox(height: 24),
                  _buildChargeProgress(meterData),
                  SizedBox(height: 28),
                  _buildInfoTiles(meterData),
                  SizedBox(height: 24),

                  isSessionStopped ?? false
                      ? _buildDownloadPDF()
                      : state is SessionUpdate && state.data.isMeterValue
                      ? _buildStopButton(meterData, transactionId)
                      : SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Station info shimmer
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(
                    width: 32,
                    height: 40,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(
                          width: double.infinity,
                          height: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        SizedBox(height: 8),
                        ShimmerWidget(
                          width: 150,
                          height: 14,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  ShimmerWidget(
                    width: 80,
                    height: 28,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Charge progress shimmer (circular)
            Center(
              child: ShimmerWidget(
                width: 280,
                height: 280,
                borderRadius: BorderRadius.circular(140),
              ),
            ),
            SizedBox(height: 28),
            // Info tiles shimmer
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                              width: double.infinity,
                              height: 12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                ShimmerWidget(
                                  width: 24,
                                  height: 24,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: ShimmerWidget(
                                    width: double.infinity,
                                    height: 18,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                              width: double.infinity,
                              height: 12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                ShimmerWidget(
                                  width: 24,
                                  height: 24,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: ShimmerWidget(
                                    width: double.infinity,
                                    height: 18,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                              width: double.infinity,
                              height: 12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                ShimmerWidget(
                                  width: 24,
                                  height: 24,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: ShimmerWidget(
                                    width: double.infinity,
                                    height: 18,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                              width: double.infinity,
                              height: 12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                ShimmerWidget(
                                  width: 24,
                                  height: 24,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: ShimmerWidget(
                                    width: double.infinity,
                                    height: 18,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            // Button shimmer
            ShimmerWidget(
              width: double.infinity,
              height: 56,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadPDF() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.file_download_outlined, color: Colors.white, size: 27),
        label: Text(
          'Download Report (PDF)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(vertical: 17),
        ),
        onPressed: () async {
          String? url = ChargingCubit.get(context).pdfUrl;
          if (url != null) {
            try {
              if (await canLaunchUrl(Uri.parse(url))) {
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
            } catch (e) {
              context.showErrorMessage("This pdf link is not working");
            }
          }
        },
      ),
    );
  }

  Widget _buildStationInfo(MeterValueData? meterData) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/icons/ac.png",
            width: 32,
            height: 40,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meterData?.stationName ?? "N/A",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 18,
                  ),
                ),
                Text(
                  meterData?.stationAddress ?? "N/A",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xffE6F9EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Available",
              style: TextStyle(color: Color(0xff058A3C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeProgress(MeterValueData? meterData) {
    final percent = (meterData?.chargePercentageValue ?? 0) / 100;
    final percentValue = (meterData?.chargePercentageValue ?? 0).toInt();

    return Center(
      child: DashedCircularProgress(
        percent: percent,
        totalTicks: 60,
        diameter: 280,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.primary.withValues(alpha: .2),
        strokeWidth: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/flash.svg"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$percentValue",
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  "%",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTiles(MeterValueData? meterData) {
    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoTile(
              'Power Consumption',
              '${meterData?.energyConsumedValue.toStringAsFixed(1) ?? '0.0'} ${meterData?.energyConsumedUnit ?? 'kWh'}',
              "assets/icons/power_cons.png",
            ),
            _infoTile(
              'Cost consumption',
              '${meterData?.costValue.toStringAsFixed(1) ?? '0.0'} ${meterData?.costCurrency ?? 'EGP'}',
              "assets/icons/cost_con.png",
            ),
          ],
        ),
        Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoTile(
              'Charging time',
              meterData?.chargingDurationDisplay ?? '0 min',
              "assets/icons/battery.png",
            ),
            _infoTile(
              'Output power from gun',
              '${meterData?.outputPowerValue.toStringAsFixed(1) ?? '0.0'} ${meterData?.outputPowerUnit ?? 'kW'}',
              "assets/icons/output_power.png",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStopButton(MeterValueData? meterData, String? transactionId) {
    return BlocListener<ChargingCubit, ChargingState>(
      listener: (context, state) {
        if (state is StopChargingSuccess) {
          Navigator.pop(context);
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffF8E8E8),
            padding: EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Color(0xffB71C1C)),
            ),
          ),
          onPressed: () async {
            final bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Stop Charging?'),
                content: Text('Are you sure you want to stop charging?'),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context, false), // Return false
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context, true), // Return true
                    child: Text('Stop', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              context.read<ChargingCubit>().stopCharging(
                meterData?.chargerId.toString() ?? "",
                transactionId ?? "",
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.stop, color: Color(0xffB71C1C)),
              SizedBox(width: 8),
              Text(
                'Stop Charging',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffB71C1C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value, String icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Image.asset(icon, width: 24, height: 24),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Keep the DashedCircularProgress class as is
class DashedCircularProgress extends StatelessWidget {
  final double percent;
  final int totalTicks;
  final double diameter;
  final double strokeWidth;
  final Color activeColor;
  final Color inactiveColor;
  final Widget child;

  const DashedCircularProgress({
    required this.percent,
    required this.totalTicks,
    required this.diameter,
    required this.child,
    required this.activeColor,
    required this.inactiveColor,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(diameter, diameter),
            painter: _TicksRingPainter(
              percent: percent,
              ticks: totalTicks,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              strokeWidth: strokeWidth,
            ),
          ),
          Positioned.fill(child: Center(child: child)),
        ],
      ),
    );
  }
}

class _TicksRingPainter extends CustomPainter {
  final double percent;
  final int ticks;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  _TicksRingPainter({
    required this.percent,
    required this.ticks,
    required this.activeColor,
    required this.inactiveColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width / 2) - strokeWidth / 2;
    final angle = 2 * pi / ticks;
    final activeTicks = (ticks * percent).toInt();

    for (int i = 0; i < ticks; i++) {
      final paint = Paint()
        ..color = i < activeTicks ? activeColor : inactiveColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;
      final startAngle = -pi / 2 + i * angle;
      final x1 = size.width / 2 + radius * cos(startAngle);
      final y1 = size.height / 2 + radius * sin(startAngle);
      final gap = 12.0;
      final x2 = size.width / 2 + (radius - gap) * cos(startAngle);
      final y2 = size.height / 2 + (radius - gap) * sin(startAngle);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(_TicksRingPainter oldDelegate) {
    return percent != oldDelegate.percent ||
        activeColor != oldDelegate.activeColor ||
        inactiveColor != oldDelegate.inactiveColor ||
        ticks != oldDelegate.ticks ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
