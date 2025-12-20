import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cubit/history_cubit.dart';
import 'history_model.dart';
import 'history_repository.dart';

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
                            child: const Text('Retry'),
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
          "Charging History",
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildStatsGrid(state.data.summary),
          const SizedBox(height: 14),
          _buildFilters(context, state),
          _buildSessionsList(state.displayedSessions),
          const SizedBox(height: 16),
          _buildDownloadButton(context, state.data.pdfUrl),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(HistorySummary summary) {
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
          'Total Energy',
          summary.displayTotalKwh,
        ),
        _buildCard(
          "assets/icons/total_cost.svg",
          'Total Cost',
          summary.displayTotalCost,
        ),
        _buildCard(
          "assets/icons/total_time.svg",
          'Total Time',
          summary.totalDuration,
        ),
        _buildCard(
          "assets/icons/total_sessions.svg",
          'Total Sessions',
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
                items: ['All', 'Active', 'Completed']
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff606060),
                          ),
                        ),
                      ),
                    )
                    .toList(),
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
                    state.selectedSort,
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

  void _showSortOptions(BuildContext context, String currentSort) {
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
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...[
                'Newest',
                'Oldest',
                'Highest Energy',
                'Lowest Energy',
              ].map((sortType) => ListTile(
                    title: Text(sortType),
                    trailing: currentSort == sortType
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      context.read<HistoryCubit>().applySort(sortType);
                      Navigator.pop(sheetContext);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionsList(List<ChargingSession> sessions) {
    if (sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No sessions found',
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
      itemBuilder: (context, index) => _buildSessionCard(sessions[index]),
    );
  }

  Widget _buildSessionCard(ChargingSession session) {
    return Container(
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
                    'Total Cost',
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
                        'egp',
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
                      session.isActive ? 'Active' : 'DC Fast',
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
    );
  }

  Widget _buildDownloadButton(BuildContext context, String pdfUrl) {
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
          label: const Text(
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
            padding: const EdgeInsets.symmetric(vertical: 17),
          ),
          onPressed: () async {
            if (pdfUrl.isNotEmpty) {
              final uri = Uri.parse(pdfUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
          },
        ),
      ),
    );
  }
}
