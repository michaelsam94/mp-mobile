import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/guest_bottom_sheet.dart';
import 'package:mega_plus/presentation/map/models/station_response_model.dart';
import 'package:mega_plus/presentation/map/qr_code_scanner_screen.dart';
import 'package:mega_plus/presentation/map/station_details_cubit/station_details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetailsSheet extends StatelessWidget {
  const StationDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationDetailsCubit, StationDetailsState>(
      builder: (context, state) {
        if (state is LoadingStationDetailsState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  SizedBox(height: 8),
                  // Title shimmer
                  _ShimmerWidget(
                    width: 120,
                    height: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(height: 18),
                  // Image shimmer
                  _ShimmerWidget(
                    width: double.infinity,
                    height: 120,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  SizedBox(height: 18),
                  // Status badge shimmer
                  Row(
                    children: [
                      _ShimmerWidget(
                        width: 80,
                        height: 24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      SizedBox(width: 12),
                      _ShimmerWidget(
                        width: 100,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Station info shimmer
                  Row(
                    children: [
                      _ShimmerWidget(
                        width: 32,
                        height: 32,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ShimmerWidget(
                              width: double.infinity,
                              height: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            SizedBox(height: 8),
                            _ShimmerWidget(
                              width: double.infinity,
                              height: 16,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            SizedBox(height: 4),
                            _ShimmerWidget(
                              width: 150,
                              height: 16,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      _ShimmerWidget(
                        width: 32,
                        height: 32,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Divider(height: 1, color: Color(0xffE6ECEF)),
                  SizedBox(height: 18),
                  // Connectors title shimmer
                  _ShimmerWidget(
                    width: 140,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(height: 12),
                  // Connectors shimmer (3 items)
                  ...List.generate(3, (index) => Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            _ShimmerWidget(
                              width: 40,
                              height: 40,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ShimmerWidget(
                                    width: double.infinity,
                                    height: 18,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  SizedBox(height: 6),
                                  _ShimmerWidget(
                                    width: 120,
                                    height: 14,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  SizedBox(height: 4),
                                  _ShimmerWidget(
                                    width: 100,
                                    height: 14,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            _ShimmerWidget(
                              width: 80,
                              height: 30,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ],
                        ),
                      )),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is ErrorStationDetailsState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is SuccessStationDetailsState) {
          final station = state.station;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Station Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/onboarding1.png",
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      _statusBadge(_formatStatus(station.status ?? 'available')),
                      SizedBox(width: 12),
                      Text(
                        'Opens 24 hours',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/charger.svg",
                        width: 32,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              station.name ?? 'Unknown Station',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              station.address ?? '',
                              style: TextStyle(color: Colors.grey[800], fontSize: 14),
                            ),
                            if (station.city != null) ...[
                              SizedBox(height: 2),
                              Text(
                                station.city ?? '',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (station.latitude != null && station.longitude != null) {
                            await _openGoogleMapsDirections(
                              context,
                              station.latitude!,
                              station.longitude!,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          "assets/icons/navigation.svg",
                          width: 32,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Divider(height: 1, color: Color(0xffE6ECEF)),
                  SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Connectors Types',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  if (station.guns != null && station.guns!.isNotEmpty)
                    ...station.guns!.map((gun) => ConnectorCard(gun: gun)).toList()
                  else
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No connectors available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  Future<void> _openGoogleMapsDirections(
    BuildContext context,
    double latitude,
    double longitude,
  ) async {
    // Try to open Google Maps app first, then fallback to web
    final googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    final googleMapsAppUrl = 'comgooglemaps://?daddr=$latitude,$longitude&directionsmode=driving';
    
    try {
      // Try to launch Google Maps app (iOS/Android)
      final appUri = Uri.parse(googleMapsAppUrl);
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (e) {
      // If app launch fails, continue to web fallback
    }
    
    // Fallback to web Google Maps
    try {
      final webUri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open Google Maps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatStatus(String? status) {
    if (status == null) return 'Available';
    // Convert API status format to display format
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'inuse':
      case 'in_use':
        return 'In Use';
      case 'unavailable':
        return 'Unavailable';
      default:
        return status; // Return as-is if unknown format
    }
  }

  Widget _statusBadge(String status) {
    Color colorBG;
    Color colorText;
    switch (status) {
      case 'Available':
        colorText = Color(0xff058A3C);
        colorBG = Color(0xffE6F9EE);
        break;
      case 'In Use':
        colorText = Color(0xff1261FF);
        colorBG = Color(0xffE8EFFF);
        break;
      case 'Unavailable':
        colorText = Color(0xffC31D07);
        colorBG = Color(0xffFFEAE7);
        break;
      default:
        colorText = Colors.grey.shade300;
        colorBG = Colors.grey.shade300;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorBG,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: colorText,
        ),
      ),
    );
  }
}

class ConnectorCard extends StatelessWidget {
  final Guns gun;

  const ConnectorCard({required this.gun, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Column(
            children: [
              SvgPicture.asset("assets/icons/charger.svg"),
              SizedBox(height: 2),
              Text(
                gun.maxPower != null ? '${gun.maxPower} kW' : 'N/A',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gun.type ?? 'Unknown Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 2),
                Text(
                  gun.name ?? "Connector no/name",
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                Text(
                  gun.price != null ? "${gun.price} EGP/KW" : "Price not available",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF24C064),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            onPressed: () {
              // Check if user is logged in (not in guest mode)
              if (CacheHelper.checkLogin() != 3) {
                GuestBottomSheet.show(context);
                return;
              }
              context.goTo(QrCodeScannerScreen());
            },
            child: Text(
              "Click to charge",
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

void showStationDetails(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: StationDetailsCubit.get(context),
      child: StationDetailsSheet(),
    ),
  );
}

class _ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const _ShimmerWidget({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<_ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<_ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0.0),
              end: Alignment(1.0 - _controller.value * 2, 0.0),
              colors: [
                Color(0xFFEBEBF4),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBF4),
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}
