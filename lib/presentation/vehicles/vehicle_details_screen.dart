import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/vehicles/models/vehicle_response_model.dart';
import 'package:mega_plus/presentation/vehicles/vehicle_setup_screen.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final VehicleResponseModel? vehicle;
  
  const VehicleDetailsScreen({super.key, this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 0),
          children: [
            // Custom AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 57,
              width: double.infinity,
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
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset("assets/icons/back.svg"),
                    ),
                  ),
                  Center(
                    child: Text(
                      "My Vehicle",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff212121),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (vehicle != null) {
                          context.goTo(VehicleSetupScreen(vehicle: vehicle));
                        }
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17),
            // Vehicle card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/vehicle_image.png",
                          width: 110,
                          height: 65,
                          fit: BoxFit.contain,
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 17,
                          ),
                          child: Text(
                            "CCS2",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Tesla Model 3",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "2023 • Pearl White",
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Color(0xffE6ECEF)),
                    SizedBox(height: 6),
                    Text(
                      "License Plate",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      "ABC 1234",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 22),
            // Vehicle Specifications Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Text(
                "Vehicle Specifications",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(height: 13),
            // Vehicle Specifications Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Column(
                children: [
                  // Make
                  _buildTextField(label: "Make", value: "Tesla"),
                  // Model
                  _buildTextField(label: "Model", value: "Model 3"),
                  // Year & Color Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: "Year", value: "2023"),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _buildTextField(
                          label: "Color",
                          value: "Pearl White",
                        ),
                      ),
                    ],
                  ),
                  // License Plate
                  _buildTextField(label: "License Plate", value: "ABC 1234"),
                  // Plate Number with Loyalty
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Plate number",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "( Earn 100 loyalty point )",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Container(
                        margin: EdgeInsets.only(bottom: 13),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: "ABC 1234",
                            filled: true,
                            fillColor: Color(0xFFF7F7F7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE6ECEF)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 17,
                            ),
                          ),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  // Charging Type Dropdown
                  Container(
                    margin: EdgeInsets.only(bottom: 13),
                    child: DropdownButtonFormField<String>(
                      initialValue: "CCS2",
                      decoration: InputDecoration(
                        labelText: "Charging Type",
                        filled: true,
                        fillColor: Color(0xFFF7F7F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFFE6ECEF)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "CCS2",
                          child: Text("CCS2", style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      onChanged: (val) {},
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String value}) {
    return Container(
      margin: EdgeInsets.only(bottom: 13),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          hintText: value,
          filled: true,
          fillColor: Color(0xFFF7F7F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFFE6ECEF)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        ),
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
