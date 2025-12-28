import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/style/app_colors.dart';
import 'models/station_details_model.dart';
import 'station_details_cubit/station_details_cubit.dart';

void showStationBottomSheet(int stationId, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BlocProvider(
        create: (context) =>
            StationDetailsCubit()..getStationDetails(stationId),
        child: StationDetailsBottomSheet(),
      );
    },
  );
}

class StationDetailsBottomSheet extends StatefulWidget {
  const StationDetailsBottomSheet({super.key});

  @override
  State<StationDetailsBottomSheet> createState() =>
      _StationDetailsBottomSheetState();
}

class _StationDetailsBottomSheetState extends State<StationDetailsBottomSheet> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: BlocBuilder<StationDetailsCubit, StationDetailsState>(
            builder: (context, state) {
              if (state is StationDetailsLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is StationDetailsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        state.message,
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
                );
              }

              if (state is StationDetailsSuccess) {
                final station = state.station;
                return Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Title
                    Text(
                      'Station Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: 20),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Carousel
                            _buildImageCarousel(station.mediaUrl),
                            SizedBox(height: 16),

                            // Image Indicators
                            _buildImageIndicators(station.mediaUrl.length),
                            SizedBox(height: 24),

                            // Status and Operating Hours
                            Row(
                              children: [
                                _buildStatusChip(station.status),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Opens',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '24 hours',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            // Station Name and Location
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.ev_station,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        station.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF212121),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Color(0xFF757575),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '7 Mins',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF757575),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 14,
                                            color: Color(0xFF757575),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '2.6 km',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF757575),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.navigation,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),

                            // Connectors Types Section
                            Text(
                              'Connectors Types',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF212121),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Guns List
                            ...station.guns.map(
                              (gun) => _buildConnectorCard(gun),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Color(0xFFF5F5F5),
                  child: Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Color(0xFFBDBDBD),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Color(0xFFF5F5F5),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageIndicators(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentImageIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentImageIndex == index
                ? AppColors.primary
                : Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isAvailable = status.toLowerCase() == 'available';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable ? Color(0xFFD1FADF) : Color(0xFFFFE4E4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isAvailable ? AppColors.primary : Colors.red,
        ),
      ),
    );
  }

  Widget _buildConnectorCard(GunDetail gun) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0), width: 1),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFD1FADF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.ev_station, color: AppColors.primary, size: 24),
          ),
          SizedBox(width: 12),

          // Power
          Column(
            children: [
              Text(
                gun.maxPower,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              Text(
                'kw',
                style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
              ),
            ],
          ),
          SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gun.type,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  gun.name,
                  style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
                ),
                SizedBox(height: 4),
                Text(
                  '${gun.price} EGP/KW',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Charge Button
          ElevatedButton(
            onPressed: () {
              // Handle charge action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'Click to charge',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
