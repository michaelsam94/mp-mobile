import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/map/search_cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SearchCubit.get(context).getStations(); // استدعِ بعد بناء الـ widget
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    BackButton(),
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Color(0xffFBFBFB),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            // كل ما اليوزر يكتب، نبحث فورًا
                            SearchCubit.get(context).searchStations(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search stations, cities, addresses...',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xffB6B6B6),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                "assets/icons/search.svg",
                              ),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      SearchCubit.get(context).clearSearch();
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xffFBFBFB),
                          ),
                        ),
                      ),
                    ),

                    // في search_screen.dart، فك الـ comment على الـ filter button:
                    SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FilterBottomSheet(
                            selectedStatus: SearchCubit.get(
                              context,
                            ).filterStatus,
                            selectedConnectorType: SearchCubit.get(
                              context,
                            ).filterConnectorType,
                            favouriteOnly: SearchCubit.get(
                              context,
                            ).filterFavouriteOnly,
                            minimumPower: SearchCubit.get(
                              context,
                            ).filterMinimumPower,
                            onApplyFilters:
                                ({
                                  status,
                                  connectorType,
                                  favouriteOnly,
                                  minimumPower,
                                }) {
                                  SearchCubit.get(context).applyFilters(
                                    status: status,
                                    connectorType: connectorType,
                                    favouriteOnly: favouriteOnly,
                                    minimumPower: minimumPower,
                                  );
                                },
                          ),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/filter.svg",
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is LoadingGetStationsSearchState) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final cubit = SearchCubit.get(context);
                  final displayStations =
                      cubit.filteredStations; // استخدم المفلترة

                  if (displayStations.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              cubit.searchQuery.isEmpty
                                  ? 'No stations available'
                                  : 'No stations found for "${cubit.searchQuery}"',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemCount: displayStations.length,
                    itemBuilder: (context, index) {
                      final station = displayStations[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _statusBadge(station.status ?? ""),
                                  Icon(
                                    Icons.star_border,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ],
                              ), // main badge at top
                              SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 8),
                                  Image.asset(
                                    "assets/icons/ac.png",
                                    height: 48,
                                    width: 39,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          station.name ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        Text(
                                          station.address ?? "",
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 15,
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     SvgPicture.asset(
                                        //       "assets/icons/car.svg",
                                        //     ),
                                        //     SizedBox(width: 3),
                                        //     Text(
                                        //       station['mins'].toString(),
                                        //       style: TextStyle(fontSize: 13),
                                        //     ),
                                        //     SizedBox(width: 12),
                                        //     SvgPicture.asset(
                                        //       "assets/icons/distance.svg",
                                        //     ),

                                        //     SizedBox(width: 3),
                                        //     Text(
                                        //       station['distance'].toString(),
                                        //       style: TextStyle(fontSize: 13),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  // SvgPicture.asset("assets/icons/navigation.svg"),
                                ],
                              ),
                              SizedBox(height: 16),
                              Divider(color: Color(0xffE6ECEF)),
                              SizedBox(height: 16),
                              Text(
                                'Connectors Types',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(height: 16),
                              Column(
                                children: station.guns!.map<Widget>((
                                  connector,
                                ) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/charger.svg",
                                            ),
                                            // Text(
                                            //   '${connector['kw']}kw',
                                            //   style: TextStyle(
                                            //     fontSize: 13,
                                            //     color: Colors.grey,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        SizedBox(width: 16),
                                        Container(
                                          width: 1,
                                          color: Color(0xffE6ECEF),
                                          height: 30,
                                        ),
                                        SizedBox(width: 16),
                                        SvgPicture.asset(
                                          "assets/icons/comboccs.svg",
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          connector.type ?? "",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(width: 8),
                                        Spacer(),
                                        _statusBadge(connector.status ?? ""),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color colorBG;
    Color colorText;
    switch (status) {
      case 'available':
        colorText = Color(0xff058A3C);
        break;
      case 'inUse':
        colorText = Color(0xff1261FF);
        break;
      case 'unavailable':
        colorText = Color(0xffC31D07);
        break;
      default:
        colorText = Colors.grey.shade300;
    }
    switch (status) {
      case 'available':
        colorBG = Color(0xffE6F9EE);
        break;
      case 'inUse':
        colorBG = Color(0xffE8EFFF);
        break;
      case 'unavailable':
        colorBG = Color(0xffFFEAE7);
        break;
      default:
        colorBG = Colors.grey.shade300;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorBG,
        borderRadius: BorderRadius.circular(10),
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

class FilterBottomSheet extends StatefulWidget {
  final String? selectedStatus;
  final String? selectedConnectorType;
  final bool? favouriteOnly;
  final String? minimumPower;
  final Function({
    String? status,
    String? connectorType,
    bool? favouriteOnly,
    String? minimumPower,
  })
  onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.selectedStatus,
    this.selectedConnectorType,
    this.favouriteOnly,
    this.minimumPower,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedStatus;
  String? selectedConnectorType;
  bool favouriteOnly = false;
  String? selectedPower;

  final List<String> powerOptions = [
    '7kw',
    '11kw',
    '22kw',
    '50kw',
    '100kw',
    '150kw',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.selectedStatus;
    selectedConnectorType = widget.selectedConnectorType;
    favouriteOnly = widget.favouriteOnly ?? false;
    selectedPower = widget.minimumPower;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          SizedBox(height: 20),

          // Title
          Text(
            'Filter By',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          SizedBox(height: 24),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Station Status
                  Text(
                    'Station Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _filterButton(
                          label: 'Available',
                          isSelected: selectedStatus == 'available',
                          onTap: () {
                            setState(() {
                              selectedStatus = selectedStatus == 'available'
                                  ? null
                                  : 'available';
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _filterButton(
                          label: 'In Use',
                          isSelected: selectedStatus == 'inUse',
                          onTap: () {
                            setState(() {
                              selectedStatus = selectedStatus == 'inUse'
                                  ? null
                                  : 'inUse';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Connector Type
                  Text(
                    'Connector Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _filterButton(
                          label: 'AC',
                          isSelected: selectedConnectorType == 'AC',
                          onTap: () {
                            setState(() {
                              selectedConnectorType =
                                  selectedConnectorType == 'AC' ? null : 'AC';
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _filterButton(
                          label: 'DC',
                          isSelected: selectedConnectorType == 'DC',
                          onTap: () {
                            setState(() {
                              selectedConnectorType =
                                  selectedConnectorType == 'DC' ? null : 'DC';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Favourite Stations
                  Text(
                    'Favourite Stations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12),
                  _filterButton(
                    label: 'Favourite Only',
                    icon: Icons.star_border,
                    isSelected: favouriteOnly,
                    onTap: () {
                      setState(() {
                        favouriteOnly = !favouriteOnly;
                      });
                    },
                  ),
                  SizedBox(height: 24),

                  // Minimum Power
                  Text(
                    'Minimum Power',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedPower,
                        hint: Text(
                          'Select minimum power',
                          style: TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontSize: 14,
                          ),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF212121),
                        ),
                        items: powerOptions.map((String power) {
                          return DropdownMenuItem<String>(
                            value: power,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  power,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedPower = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Apply Filters Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(
                        status: selectedStatus,
                        connectorType: selectedConnectorType,
                        favouriteOnly: favouriteOnly,
                        minimumPower: selectedPower,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Reset All Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedStatus = null;
                        selectedConnectorType = null;
                        favouriteOnly = false;
                        selectedPower = null;
                      });
                      widget.onApplyFilters(
                        status: null,
                        connectorType: null,
                        favouriteOnly: false,
                        minimumPower: null,
                      );
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Reset All',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFD1FADF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Color(0xFFBDBDBD),
                size: 20,
              ),
              SizedBox(width: 8),
            ],
            if (isSelected)
              Icon(Icons.check, color: AppColors.primary, size: 18),
            if (isSelected) SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
