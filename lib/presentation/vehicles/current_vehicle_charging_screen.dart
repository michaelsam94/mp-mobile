import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';

class CurrentVehicleChargingScreen extends StatefulWidget {
  const CurrentVehicleChargingScreen({super.key});

  @override
  State<CurrentVehicleChargingScreen> createState() => _CurrentVehicleChargingScreenState();
}

class _CurrentVehicleChargingScreenState extends State<CurrentVehicleChargingScreen> {
  bool isCharging = false; // Toggle between start/stop charging states

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 57,
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset("assets/icons/back.svg"),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Current Vehicle Charging",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff212121),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    
                    // Vehicle Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Top Section: Charging Status and Vehicle Info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Charging Status Icon
                              Container(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Rounded Progress Bar
                                    CircularProgressIndicator(
                                      value: isCharging ? 0.75 : 0.0,
                                      strokeWidth: 4,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                    // Lightning Icon
                                    Icon(
                                      Icons.bolt,
                                      color: AppColors.primary,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(width: 16),
                              
                              // Vehicle Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Battery Percentage and Range
                                    Text(
                                      isCharging ? "75%" : "75%",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Vehicle Name and Details
                                    Text(
                                      "Tesla Model 3",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Black x,8914 ب ق",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Vehicle Image
                              Container(
                                width: 120,
                                height: 80,
                                child: Image.asset(
                                      "assets/images/vehicle_image_green_circle.png",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 30),
                          
                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isCharging = !isCharging;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCharging 
                                    ? Colors.red.shade50 
                                    : AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isCharging 
                                        ? Colors.red 
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isCharging ? Icons.pause : Icons.play_arrow,
                                    color: isCharging ? Colors.red : Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    isCharging ? "Stop Charging" : "Start Charging",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isCharging ? Colors.red : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

