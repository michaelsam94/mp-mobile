import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mega_plus/l10n/app_localizations.dart';
import 'cubit/history_cubit.dart';
import 'history_model.dart';
import 'history_repository.dart';
import '../../core/services/charging_api_service.dart';
import '../../core/services/websocket_cubit/websocket_cubit.dart';
import '../map/charger_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(HistoryRepository())..getChargingHistory(),
      child: const HistoryView(),
    );
  }
}

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          // Stats grid shimmer
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                            childAspectRatio: 1.4,
                            children: List.generate(4, (index) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShimmerWidget(
                                    width: 24,
                                    height: 24,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  const SizedBox(height: 8),
                                  ShimmerWidget(
                                    width: 80,
                                    height: 13,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  const SizedBox(height: 2),
                                  ShimmerWidget(
                                    width: 60,
                                    height: 20,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            )),
                          ),
                          const SizedBox(height: 14),
                          // Filters shimmer
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ShimmerWidget(
                                    width: double.infinity,
                                    height: 50,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                const SizedBox(width: 11),
                                ShimmerWidget(
                                  width: 120,
                                  height: 50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Sessions list shimmer
                          ...List.generate(3, (index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFE9E9E9)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ShimmerWidget(
                                      width: 24,
                                      height: 24,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ShimmerWidget(
                                            width: 100,
                                            height: 15,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          const SizedBox(height: 8),
                                          ShimmerWidget(
                                            width: 150,
                                            height: 32,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    ShimmerWidget(
                                      width: 80,
                                      height: 30,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ShimmerWidget(
                                  width: 200,
                                  height: 15,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    ShimmerWidget(
                                      width: 21,
                                      height: 21,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: ShimmerWidget(
                                        width: double.infinity,
                                        height: 15,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  } else if (state is HistoryError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HistoryCubit>().getChargingHistory();
                            },
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      ),
                    );
                  } else if (state is HistorySuccess) {
                    return _buildContent(context, state);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 57,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffF2F4F8))),
      ),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.chargingHistory,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff212121),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HistorySuccess state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<HistoryCubit>().getChargingHistory();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildStatsGrid(context, state.data.summary),
            const SizedBox(height: 14),
            _buildFilters(context, state),
            _buildSessionsList(context, state.displayedSessions),
            if (state.displayedSessions.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildDownloadButton(context),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, HistorySummary summary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      childAspectRatio: 1.4,
      children: [
        _buildCard(
          "assets/icons/total_energy.svg",
          AppLocalizations.of(context)!.totalEnergy,
          summary.displayTotalKwh,
        ),
        _buildCard(
          "assets/icons/total_cost.svg",
          AppLocalizations.of(context)!.totalCost,
          summary.formattedTotalCost(AppLocalizations.of(context)!.egp),
        ),
        _buildCard(
          "assets/icons/total_time.svg",
          AppLocalizations.of(context)!.totalTime,
          summary.totalDuration,
        ),
        _buildCard(
          "assets/icons/total_sessions.svg",
          AppLocalizations.of(context)!.totalSessions,
          '${summary.totalSessions}',
        ),
      ],
    );
  }

  Widget _buildCard(String icon, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon, height: 24),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, HistorySuccess state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE9E9E9)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton<String>(
                value: state.selectedFilter,
                underline: const SizedBox(),
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: HistoryCubit.filterAll,
                    child: Text(AppLocalizations.of(context)!.allFilter, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff606060))),
                  ),
                  DropdownMenuItem(
                    value: HistoryCubit.filterActive,
                    child: Text(AppLocalizations.of(context)!.active, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff606060))),
                  ),
                  DropdownMenuItem(
                    value: HistoryCubit.filterCompleted,
                    child: Text(AppLocalizations.of(context)!.completed, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff606060))),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<HistoryCubit>().applyFilter(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 11),
          InkWell(
            onTap: () => _showSortOptions(context, state.selectedSort),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE9E9E9)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/lets-icons_sort-arrow-light.svg",
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getSortLabel(context, state.selectedSort),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(BuildContext context, String sortKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (sortKey) {
      case HistoryCubit.sortNewest: return l10n.newest;
      case HistoryCubit.sortOldest: return l10n.oldest;
      case HistoryCubit.sortHighestEnergy: return l10n.highestEnergy;
      case HistoryCubit.sortLowestEnergy: return l10n.lowestEnergy;
      default: return l10n.newest;
    }
  }

  void _showSortOptions(BuildContext context, String currentSort) {
    final l10n = AppLocalizations.of(context)!;
    final sortOptions = [
      (HistoryCubit.sortNewest, l10n.newest),
      (HistoryCubit.sortOldest, l10n.oldest),
      (HistoryCubit.sortHighestEnergy, l10n.highestEnergy),
      (HistoryCubit.sortLowestEnergy, l10n.lowestEnergy),
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sortBy,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...sortOptions.map((option) => ListTile(
                    title: Text(option.$2),
                    trailing: currentSort == option.$1
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      context.read<HistoryCubit>().applySort(option.$1);
                      Navigator.pop(sheetContext);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionsList(BuildContext context, List<ChargingSession> sessions) {
    if (sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.noSessionsFound,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      itemBuilder: (context, index) => _buildSessionCard(context, sessions[index]),
    );
  }

  Widget _buildSessionCard(BuildContext context, ChargingSession session) {
    return InkWell(
      onTap: () => _handleSessionTap(context, session),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE9E9E9)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/icons/card_history.svg"),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalCost,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text(
                        session.displayCost,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        AppLocalizations.of(context)!.egp,
                        style: TextStyle(color: Colors.grey[700], fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: session.isActive 
                      ? const Color(0xffFFF4E6) 
                      : const Color(0xffE6F9EE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Icon(
                      session.isActive ? Icons.sync : Icons.flash_on,
                      size: 17,
                      color: session.isActive 
                          ? Colors.orange 
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      session.isActive ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.completed,
                      style: TextStyle(
                        color: session.isActive 
                            ? Colors.orange 
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${session.startTime ?? ''} • ${session.displayDuration} • ${session.displayKwh}',
            style: const TextStyle(color: Color(0xffB6B6B6), fontSize: 15),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.add_location_alt_outlined,
                color: AppColors.primary,
                size: 21,
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  '${session.station.name}, ${session.station.city}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
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

  Future<void> _handleSessionTap(BuildContext context, ChargingSession session) async {
    // Handle completed sessions
    if (!session.isActive) {
      _handleCompletedSessionTap(context, session);
      return;
    }
    
    // Handle active sessions
    _handleActiveSessionTap(context, session);
  }

  Future<void> _handleCompletedSessionTap(BuildContext context, ChargingSession session) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call the current charging API with session id (integer)
      final response = await ChargingApiService.getCurrentChargingBySession(session.id);

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (response.statusCode == 200 && response.data != null) {
        // Initialize meter data in WebSocketCubit from API response
        if (context.mounted) {
          context.read<WebSocketCubit>().initializeMeterDataFromApi(response.data, isCompleted: true, sessionId: session.id);
        }
        
        // Navigate to ChargerScreen and refresh when returning
        if (context.mounted) {
          if (kDebugMode) {
            print('HistoryScreen: Navigating to ChargerScreen');
          }
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChargerScreen(fromHistory: true)),
          );
          if (kDebugMode) {
            print('HistoryScreen: Returned from ChargerScreen with result: $result');
          }
          // Refetch charging history when returning from charger screen
          // Always refresh when returning from charger screen (regardless of result)
          if (context.mounted) {
            if (kDebugMode) {
              print('HistoryScreen: Refreshing charging history');
            }
            context.read<HistoryCubit>().getChargingHistory();
          }
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.data['message'] ?? AppLocalizations.of(context)!.failedToLoadSession,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        try {
          Navigator.pop(context);
        } catch (_) {
          // Dialog might already be closed
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorLoadingSession,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      if (kDebugMode) {
        print('Error loading completed charging session: $e');
      }
    }
  }

  Future<void> _handleActiveSessionTap(BuildContext context, ChargingSession session) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call the current charging API with session id (integer)
      final response = await ChargingApiService.getCurrentChargingBySession(session.id);

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (response.statusCode == 200 && response.data != null) {
        // Initialize meter data in WebSocketCubit from API response
        if (context.mounted) {
          context.read<WebSocketCubit>().initializeMeterDataFromApi(response.data);
        }
        
        // Navigate to ChargerScreen and refresh when returning
        if (context.mounted) {
          if (kDebugMode) {
            print('HistoryScreen: Navigating to ChargerScreen');
          }
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChargerScreen(fromHistory: true)),
          );
          if (kDebugMode) {
            print('HistoryScreen: Returned from ChargerScreen with result: $result');
          }
          // Refetch charging history when returning from charger screen
          // Always refresh when returning from charger screen (regardless of result)
          if (context.mounted) {
            if (kDebugMode) {
              print('HistoryScreen: Refreshing charging history');
            }
            context.read<HistoryCubit>().getChargingHistory();
          }
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.data['message'] ?? AppLocalizations.of(context)!.failedToLoadSession,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        try {
          Navigator.pop(context);
        } catch (_) {
          // Dialog might already be closed
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorLoadingSession,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      if (kDebugMode) {
        print('Error loading current charging session: $e');
      }
    }
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.file_download_outlined,
            color: Colors.white,
            size: 27,
          ),
          label: Text(
            AppLocalizations.of(context)!.downloadReport,
            style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(vertical: 17),
          ),
          onPressed: () async {
            try {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              // Get auth headers
              final authHeaders = await DioHelper.getAuthHeaders();
              
              // Download PDF with authentication headers using Dio directly
              // We need responseType.bytes for binary PDF data
              final response = await DioHelper.dio.get(
                EndPoints.chargingPdf,
                options: Options(
                  headers: authHeaders,
                  responseType: ResponseType.bytes,
                ),
              );

              if (response.statusCode == 200 && response.data != null) {
                // Get external storage directory (app's external files directory)
                // This doesn't require special permissions and works with FileProvider
                Directory? downloadsDir;
                
                try {
                  // Use external storage directory (app-specific, no permissions needed)
                  final externalDir = await getExternalStorageDirectory();
                  if (externalDir != null) {
                    // Create Downloads subdirectory in app's external storage
                    downloadsDir = Directory('${externalDir.path}/Downloads');
                  }
                } catch (e, stackTrace) {
                  // Log exception
                  if (kDebugMode) {
                    print('Exception getting external storage: $e');
                    print('Stack trace: $stackTrace');
                  }
                  // If external storage fails, use application documents directory
                  try {
                    final appDir = await getApplicationDocumentsDirectory();
                    downloadsDir = Directory('${appDir.path}/Downloads');
                  } catch (e2, stackTrace2) {
                    if (kDebugMode) {
                      print('Exception getting application documents directory: $e2');
                      print('Stack trace: $stackTrace2');
                    }
                    // Show error toast
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.errorAccessingStorage, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red.shade700,
                          behavior: SnackBarBehavior.fixed,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                    return;
                  }
                }
                
                // Fallback to application documents if external storage is not available
                if (downloadsDir == null) {
                  final appDir = await getApplicationDocumentsDirectory();
                  downloadsDir = Directory('${appDir.path}/Downloads');
                }
                
                // Create directory if it doesn't exist
                if (!await downloadsDir.exists()) {
                  await downloadsDir.create(recursive: true);
                }
                
                // Generate unique filename
                final fileName = 'charging_history_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
                final filePath = '${downloadsDir.path}/$fileName';
                
                // Save PDF to external storage
                final file = File(filePath);
                await file.writeAsBytes(response.data as List<int>);

                // Close loading dialog
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.pdfDownloadedSuccessfully, style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.fixed,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }

                // Open the PDF file after download completes using open_file
                // This handles FileProvider automatically for Android
                try {
                  final result = await OpenFile.open(filePath);
                  if (result.type != ResultType.done) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.unableToOpenPdf, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red.shade700,
                          behavior: SnackBarBehavior.fixed,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                } catch (e, stackTrace) {
                  // Log exception
                  if (kDebugMode) {
                    print('Exception opening PDF: $e');
                    print('Stack trace: $stackTrace');
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.errorOpeningPdf, style: const TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red.shade700,
                        behavior: SnackBarBehavior.fixed,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              } else {
                // Close loading dialog
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.failedToDownloadPdf, style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red.shade700,
                      behavior: SnackBarBehavior.fixed,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            } catch (e, stackTrace) {
              // Log exception
              if (kDebugMode) {
                print('Exception downloading PDF: $e');
                print('Stack trace: $stackTrace');
              }
              // Close loading dialog if still open
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.errorDownloadingPdf, style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.fixed,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
