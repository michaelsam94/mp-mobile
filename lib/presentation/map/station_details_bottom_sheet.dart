import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/services/websocket_cubit/websocket_cubit.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/map/models/station_response_model.dart';
import 'package:mega_plus/presentation/map/station_details_cubit/station_details_cubit.dart';
import 'package:mega_plus/core/locale/locale_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetailsSheet extends StatelessWidget {
  const StationDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebSocketCubit, WebSocketState>(
      listener: (context, state) {
        if (state is StatusNotificationUpdate) {
          // Update StationDetailsCubit with new station/connector status
          StationDetailsCubit.get(context).updateFromWebSocket(
            state.data.stationId,
            state.data.stationStatus,
            state.data.connectorId,
            state.data.connectorStatus,
          );
        }
      },
      child: BlocBuilder<StationDetailsCubit, StationDetailsState>(
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
                    child: Text(AppLocalizations.of(context)!.close),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is SuccessStationDetailsState) {
          final station = state.station;
          final isArabic = LocaleCubit.get(context).isArabic;
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      // Dragging down - close the bottom sheet
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.stationDetails,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Fixed header content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 18),
                      _buildImageCarousel(station),
                      SizedBox(height: 18),
                      Row(
                        children: [
                          _statusBadge(context, _formatStatus(context, station.status ?? 'available')),
                          SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.opens24Hours,
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
                          Image.asset(
                            _getStationIconPath(station),
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (isArabic ? station.nameAr : station.name) ?? 'Unknown Station',
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
                          AppLocalizations.of(context)!.connectorsTypes,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
                // Scrollable connectors section
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      if (station.guns != null && station.guns!.isNotEmpty)
                        ...station.guns!.map((gun) => ConnectorCard(gun: gun))
                      else
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            AppLocalizations.of(context)!.noConnectorsAvailable,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      SizedBox(height: 16), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox.shrink();
      },
    ),
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
          content: Text(AppLocalizations.of(context)!.couldNotOpenGoogleMaps),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Checks if station has at least one DC gun
  bool _hasDCGun(StationResponseModel station) {
    if (station.guns == null || station.guns!.isEmpty) return false;
    return station.guns!.any((gun) {
      final type = gun.type?.toUpperCase() ?? '';
      return type.contains('CCS2') ||
          type.contains('CHADEMO') ||
          type.contains('TESLA') ||
          type.contains('GB-T');
    });
  }

  /// Gets the appropriate station icon path based on ac_compatible and status
  /// Uses marker icons from assets/icons/ instead of rounded icons
  String _getStationIconPath(StationResponseModel station) {
    // Use ac_compatible from API if available, otherwise fallback to checking guns
    final isDC = station.acCompatible != null 
        ? !(station.acCompatible ?? false)  // If ac_compatible is true, it's AC (not DC)
        : _hasDCGun(station);  // Fallback to checking guns if ac_compatible not available
    
    final status = station.status?.toLowerCase() ?? 'available';
    
    if (isDC) {
      // DC marker icons
      switch (status) {
        case 'available':
          return 'assets/icons/dc_available.png';
        case 'unavailable':
          return 'assets/icons/dc_unavailable.png';
        case 'inuse':
        case 'in_use':
          return 'assets/icons/dc_inuse.png';
        default:
          return 'assets/icons/dc_available.png';
      }
    } else {
      // AC marker icons
      switch (status) {
        case 'available':
          return 'assets/icons/ac.png';
        case 'unavailable':
          return 'assets/icons/unavailable.png';
        case 'inuse':
        case 'in_use':
          return 'assets/icons/use.png';
        default:
          return 'assets/icons/ac.png';
      }
    }
  }

  String _formatStatus(BuildContext context, String? status) {
    final l10n = AppLocalizations.of(context)!;
    if (status == null) return l10n.available;
    switch (status.toLowerCase()) {
      case 'available':
        return l10n.available;
      case 'inuse':
      case 'in_use':
        return l10n.inUse;
      case 'unavailable':
        return l10n.unavailable;
      default:
        return status;
    }
  }

  Widget _statusBadge(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    Color colorBG;
    Color colorText;
    if (status == l10n.available) {
      colorText = Color(0xff058A3C);
      colorBG = Color(0xffE6F9EE);
    } else if (status == l10n.inUse) {
      colorText = Color(0xff1261FF);
      colorBG = Color(0xffE8EFFF);
    } else if (status == l10n.unavailable) {
      colorText = Color(0xffC31D07);
      colorBG = Color(0xffFFEAE7);
    } else {
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

  Widget _buildImageCarousel(StationResponseModel station) {
    final imageUrls = station.imageUrls;
    
    // If no images, show placeholder
    if (imageUrls.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey[200],
          child: Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.grey[400],
          ),
        ),
      );
    }

    // Single image - no carousel needed
    if (imageUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrls[0],
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey[400],
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      );
    }

    // Multiple images - show carousel
    return _ImageCarouselWidget(imageUrls: imageUrls);
  }
}

class _ImageCarouselWidget extends StatefulWidget {
  final List<String> imageUrls;

  const _ImageCarouselWidget({required this.imageUrls});

  @override
  State<_ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<_ImageCarouselWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageUrls.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConnectorCard extends StatelessWidget {
  final Guns gun;

  const ConnectorCard({required this.gun, super.key});

  /// Determines if the gun type is DC or AC
  bool _isDCType(String? type) {
    if (type == null) return false;
    final upperType = type.toUpperCase();
    return upperType.contains('CCS2') ||
        upperType.contains('CHADEMO') ||
        upperType.contains('TESLA') ||
        upperType.contains('GB-T');
  }

  /// Gets the appropriate icon path based on gun type and status
  String _getGunIconPath() {
    final isDC = _isDCType(gun.type);
    final status = gun.status?.toLowerCase() ?? 'available';
    
    String statusKey;
    if (status == 'inuse' || status == 'in_use') {
      statusKey = 'inuse';
    } else if (status == 'unavailable') {
      statusKey = isDC ? 'unavailable' : 'unavailabe'; // Note: AC has typo in filename
    } else {
      statusKey = 'available';
    }
    
    final prefix = isDC ? 'dc' : 'ac';
    return 'assets/images/${prefix}_$statusKey.png';
  }

  String _formatConnectorStatus(BuildContext context, String? status) {
    final l10n = AppLocalizations.of(context)!;
    if (status == null) return l10n.available;
    switch (status.toLowerCase()) {
      case 'available':
        return l10n.available;
      case 'inuse':
      case 'in_use':
        return l10n.inUse;
      case 'unavailable':
        return l10n.unavailable;
      default:
        return status;
    }
  }

  Widget _connectorStatusBadge(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    Color colorBG;
    Color colorText;
    if (status == l10n.available) {
      colorText = Color(0xff058A3C);
      colorBG = Color(0xffE6F9EE);
    } else if (status == l10n.inUse) {
      colorText = Color(0xff1261FF);
      colorBG = Color(0xffE8EFFF);
    } else if (status == l10n.unavailable) {
      colorText = Color(0xffC31D07);
      colorBG = Color(0xffFFEAE7);
    } else {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Column(
            children: [
              Image.asset(
                _getGunIconPath(),
                width: 40,
                height: 40,
              ),
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
                  gun.price != null
                    ? "${double.tryParse(gun.price!)?.toStringAsFixed(2) ?? gun.price} ${AppLocalizations.of(context)!.egp}/KW"
                    : AppLocalizations.of(context)!.priceNotAvailable,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _connectorStatusBadge(context, _formatConnectorStatus(context, gun.status)),
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
    enableDrag: true,
    isDismissible: true,
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
