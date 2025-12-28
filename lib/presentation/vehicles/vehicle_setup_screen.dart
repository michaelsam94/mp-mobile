import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/main/main_screen.dart';
import 'package:mega_plus/presentation/vehicles/cubit/vehicles_cubit.dart';
import 'package:mega_plus/presentation/vehicles/models/brand_response_model.dart';
import 'package:mega_plus/presentation/vehicles/models/connector_response_model.dart';
import 'package:mega_plus/presentation/vehicles/models/model_response_model.dart';
import 'package:mega_plus/presentation/vehicles/models/vehicle_response_model.dart';

Future<void> showVehicleAddedBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) => const VehicleAddedSheet(),
  );
}

class VehicleAddedSheet extends StatelessWidget {
  const VehicleAddedSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set your bell image asset here, or use a placeholder Icon if unavailable
    final bellAsset = 'assets/images/bell.png';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 107,
            height: 6,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xffDEDEDE),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Vehicle Added",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          Image.asset(bellAsset, width: 120, height: 120, fit: BoxFit.contain),
          const SizedBox(height: 28),
          const Text(
            "Your EV is now set up",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 13),
          Text.rich(
            TextSpan(
              text: "Congratulations! You’ve earned ",
              style: TextStyle(fontSize: 16, color: Color(0xff757575)),
              children: [
                TextSpan(
                  text: "100 points",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(text: " for adding your plate number"),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 38),
        ],
      ),
    );
  }
}

class VehicleSetupScreen extends StatefulWidget {
  final VehicleResponseModel? vehicle;
  final bool isFromSignUp;

  const VehicleSetupScreen({super.key, this.vehicle, this.isFromSignUp = false});

  @override
  State<VehicleSetupScreen> createState() => _VehicleSetupScreenState();
}

class _VehicleSetupScreenState extends State<VehicleSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateNumberController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    final cubit = VehiclesCubit.get(context);
    
    // Initialize for edit mode
    if (widget.vehicle != null) {
      _plateNumberController.text = widget.vehicle!.plateNumber ?? '';
      _yearController.text = widget.vehicle!.year?.toString() ?? '';
      _colorController.text = widget.vehicle!.color ?? '';
      
      cubit.getBrands();
      // Wait for brands and connectors to load, then initialize vehicle
      // This will be handled in the BlocListener when brands are loaded
    } else {
      cubit.getBrands();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final cubit = VehiclesCubit.get(context);
      // Update cubit with form values
      cubit.plateNumber = _plateNumberController.text.trim();
      cubit.year = int.tryParse(_yearController.text.trim());
      cubit.color = _colorController.text.trim();
      
      // All fields valid
      if (widget.vehicle != null) {
        cubit.editVehicle();
      } else {
        cubit.addVehicle();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = VehiclesCubit.get(context);
    const padding = 16.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<VehiclesCubit, VehiclesState>(
          listener: (context, state) {
            if (state is SuccessAddVehiclesState) {
              if (widget.isFromSignUp) {
                // If from sign-up flow, navigate to home screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              } else {
                // Normal flow: show bottom sheet and pop
                showVehicleAddedBottomSheet(context);
                Future.delayed(Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              }
            } else if (state is SuccessUpdateVehiclesState) {
              context.showSuccessMessage("Vehicle updated successfully");
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.pop(context);
              });
            } else if (state is ErrorAddVehiclesState) {
              context.showErrorMessage(state.message);
            } else if (state is ErrorUpdateVehiclesState) {
              context.showErrorMessage(state.message);
            } else if (state is SuccessGetBrandsVehiclesState && widget.vehicle != null && !_isInitialized) {
              // Initialize vehicle after brands and connectors are loaded
              final cubit = VehiclesCubit.get(context);
              if (cubit.brands.isNotEmpty && cubit.connectors.isNotEmpty) {
                cubit.initializeVehicleForEdit(widget.vehicle!);
                setState(() {
                  _isInitialized = true;
                });
              }
            }
          },
          builder: (context, state) {
            return state is LoadingAddVehiclesState
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: padding),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: SvgPicture.asset("assets/icons/back.svg"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Add Your Car Details',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                                color: Color(0xff121212),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Enter your vehicle’s license plate number to\ncomplete registration.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff606060),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Brand Dropdown
                            const Text(
                              'Brand',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121212),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<BrandResponseModel>(
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xff121212),
                              ),
                              value: cubit.selectedBrand,
                              isExpanded: true,
                              decoration: InputDecoration(
                                hintText: 'Select Vehicle Brand',
                                hintStyle: TextStyle(
                                  color: Color(0xffB6B6B6),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xffFBFBFB),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              items: cubit.brands
                                  .map(
                                    (b) => DropdownMenuItem(
                                      value: b,
                                      child: Text(
                                        b.name ?? "",
                                        style: const TextStyle(
                                          color: Color(0xff121212),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                cubit.selectBrand(val);
                              },
                              validator: (val) =>
                                  val == null ? 'Please select a brand' : null,
                            ),
                            const SizedBox(height: 24),
                            // Plate Number field
                            const Text(
                              'Plate number',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121212),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _plateNumberController,
                              decoration: InputDecoration(
                                hintText: 'Enter your plate number here',
                                hintStyle: const TextStyle(
                                  color: Color(0xffB6B6B6),
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                filled: true,
                                fillColor: const Color(0xffF8F8F8),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty
                                  ? 'Please enter your plate number'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            // Year field
                            const Text(
                              'Year',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121212),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _yearController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter year (e.g., 2023)',
                                hintStyle: const TextStyle(
                                  color: Color(0xffB6B6B6),
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                filled: true,
                                fillColor: const Color(0xffF8F8F8),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter year';
                                }
                                final year = int.tryParse(val.trim());
                                if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                                  return 'Please enter a valid year';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            // Color field
                            const Text(
                              'Color',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121212),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _colorController,
                              decoration: InputDecoration(
                                hintText: 'Enter color (e.g., Red)',
                                hintStyle: const TextStyle(
                                  color: Color(0xffB6B6B6),
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                filled: true,
                                fillColor: const Color(0xffF8F8F8),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty
                                  ? 'Please enter color'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            // Plate number field
                            // Row(
                            //   children: [
                            //     const Text(
                            //       'Plate number',
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.w500,
                            //         color: Color(0xff121212),
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //     const SizedBox(width: 8),
                            //     Text(
                            //       '( Earn 100 loyalty point )',
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.w500,
                            //         color: AppColors.primary,
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 8),
                            // TextFormField(
                            //   controller: _plateController,
                            //   decoration: InputDecoration(
                            //     hintText: 'Enter your plate number here',
                            //     hintStyle: const TextStyle(
                            //       color: Color(0xffB6B6B6),
                            //       fontSize: 15,
                            //     ),
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(11),
                            //       borderSide: BorderSide(color: Colors.grey.shade300),
                            //     ),
                            //     filled: true,
                            //     fillColor: const Color(0xffF8F8F8),
                            //     contentPadding: const EdgeInsets.all(16),
                            //   ),
                            //   validator: (val) => val == null || val.trim().isEmpty
                            //       ? 'Please enter your plate number'
                            //       : null,
                            // ),
                            const SizedBox(height: 24),
                            // Take picture for plate
                            InkWell(
                              onTap: () {
                                cubit.chooseImage();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: DottedBorder(
                                options: RectDottedBorderOptions(
                                  color: AppColors.primary,
                                  dashPattern: [10, 5],
                                  strokeWidth: 2,
                                  // padding: EdgeInsets.all(16),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: cubit.plateImage == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/camera.svg",
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              'Take a picture now',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff121212),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Image.file(
                                          cubit.plateImage!,
                                          width: double.infinity,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                '( Earn 100 loyalty point )',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Model',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121212),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<ModelResponseModel>(
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xff121212),
                              ),
                              value: cubit.selectedModel,
                              isExpanded: true,
                              decoration: InputDecoration(
                                hintText: 'Select Vehicle Model',
                                hintStyle: const TextStyle(
                                  color: Color(0xffB6B6B6),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xffFBFBFB),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              items:
                                  (cubit.selectedBrand == null
                                          ? []
                                          : cubit.models)
                                      .map(
                                        (m) =>
                                            DropdownMenuItem<
                                              ModelResponseModel
                                            >(
                                              value: m,
                                              child: Text(
                                                m.name,
                                                style: const TextStyle(
                                                  color: Color(0xff121212),
                                                ),
                                              ),
                                            ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                cubit.selectModel(val);
                              },
                              validator: (val) =>
                                  val == null ? 'Please select a model' : null,
                            ),

                            const SizedBox(height: 24),
                            const Text(
                              'Connectors',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121212),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<ConnectorResponseModel>(
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xff121212),
                              ),
                              value: cubit.selectedConnector,
                              isExpanded: true,
                              decoration: InputDecoration(
                                hintText: 'Select Connectors',
                                hintStyle: const TextStyle(
                                  color: Color(0xffB6B6B6),
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xffF8F8F8),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              items: cubit.connectors
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        c.label ?? "",
                                        style: const TextStyle(
                                          color: Color(0xff121212),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                cubit.selectConnector(val);
                              },
                              validator: (val) => val == null
                                  ? 'Please select a connector'
                                  : null,
                            ),

                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  _submit(context);
                                },
                                child: Text(
                                  widget.vehicle != null ? 'Update Vehicle' : 'Add Vehicle',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
