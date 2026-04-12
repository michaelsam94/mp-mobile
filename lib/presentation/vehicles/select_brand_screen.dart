import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/l10n/app_localizations.dart';

class SelectBrandScreen extends StatefulWidget {
  const SelectBrandScreen({super.key});

  @override
  State<SelectBrandScreen> createState() => _SelectBrandScreenState();
}

class _SelectBrandScreenState extends State<SelectBrandScreen> {
  final _searchController = TextEditingController();
  final List<BrandModel> _brands = [
    BrandModel('BMW', 'assets/images/bmw.png'),
    BrandModel('Kia', 'assets/images/bmw.png'),
    BrandModel('Hyundai', 'assets/images/bmw.png'),
    BrandModel('Tata Moters', 'assets/images/bmw.png'),
    BrandModel('Volvo', 'assets/images/bmw.png'),
    BrandModel('Ford', 'assets/images/bmw.png'),
    BrandModel('Tesla', 'assets/images/bmw.png'),
    BrandModel('Audi', 'assets/images/bmw.png'),
  ];
  String? _selectedBrand;
  List<BrandModel> _filteredBrands = [];

  @override
  void initState() {
    super.initState();
    _filteredBrands = List.from(_brands);
    _searchController.addListener(() {
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredBrands = _brands
            .where((b) => b.name.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  void _submit() {
    if (_selectedBrand == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a brand!')));
    } else {
      // Selected
      // context.goTo(VehicleSetupScreen());
    }
  }

  Widget _buildBrandCard(BrandModel brand) {
    final isSelected = brand.name == _selectedBrand;
    return InkWell(
      onTap: () => setState(() => _selectedBrand = brand.name),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffE6F9EE) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use your asset images here
              Image.asset(brand.imageAsset, height: 42, fit: BoxFit.contain),
              const SizedBox(height: 10),
              Text(
                brand.name,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/icons/back.svg"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context)!.selectVehicleBrand,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: Color(0xff121212),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This makes your charging and parking more\nconvenient and personalized.',
                style: TextStyle(fontSize: 16, color: Color(0xff606060)),
              ),
              const SizedBox(height: 40),
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchYourModel,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xffB6B6B6),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SvgPicture.asset("assets/icons/search.svg"),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Color(0xffFBFBFB),
                ),
              ),
              const SizedBox(height: 18),
              // Brand grid
              Expanded(
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.5,
                  children: _filteredBrands.map(_buildBrandCard).toList(),
                ),
              ),
              Container(
                height: 60,
                padding: EdgeInsets.only(top: 8),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _submit,
                  child: Text(
                    AppLocalizations.of(context)!.continueText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandModel {
  final String name;
  final String imageAsset;
  BrandModel(this.name, this.imageAsset);
}
