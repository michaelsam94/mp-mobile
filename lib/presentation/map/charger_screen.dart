import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';

class ChargerScreen extends StatefulWidget {
  @override
  State<ChargerScreen> createState() => _ChargerScreenState();
}

class _ChargerScreenState extends State<ChargerScreen> {
  static const int totalSeconds = 20 * 60; // 20 minutes for full progress
  int remainingSeconds = totalSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get percent => 1 - remainingSeconds / totalSeconds;

  int get percentValue => (percent * 100).round();

  String get minutesRemaining {
    final min = remainingSeconds ~/ 60;
    return '$min min remaining';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text("Charging", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/icons/ac.png",
                      width: 32,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cillout Mansoura",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "15 Tahrir Street, Downtown, Cairo",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffE6F9EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Available",
                        style: TextStyle(color: Color(0xff058A3C)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: DashedCircularProgress(
                  percent: percent,
                  totalTicks: 60, // feel free to adjust for smoothness
                  diameter: 280,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primary.withValues(alpha: .2),
                  strokeWidth: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/flash.svg"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$percentValue",
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            "%",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        minutesRemaining,
                        style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoTile(
                    'Power Consumption',
                    '42.5 kWh',
                    "assets/icons/power_cons.png",
                  ),
                  infoTile(
                    'Cost consumption',
                    '315 EGP',
                    "assets/icons/cost_con.png",
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                spacing: 16,

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoTile(
                    'Charging time',
                    '2hr 15min',
                    "assets/icons/battery.png",
                  ),
                  infoTile(
                    'Output power from gun',
                    '22.0 kW',
                    "assets/icons/output_power.png",
                  ),
                ],
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF8E8E8),

                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Color(0xffB71C1C)),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pause, color: Color(0xffB71C1C)),
                      SizedBox(width: 8),
                      Text(
                        'Stop Charging',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffB71C1C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoTile(String title, String value, String icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Image.asset(icon),
                SizedBox(width: 6),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashedCircularProgress extends StatelessWidget {
  final double percent;
  final int totalTicks;
  final double diameter;
  final double strokeWidth;
  final Color activeColor;
  final Color inactiveColor;
  final Widget child;

  const DashedCircularProgress({
    required this.percent,
    required this.totalTicks,
    required this.diameter,
    required this.child,
    required this.activeColor,
    required this.inactiveColor,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(diameter, diameter),
            painter: _TicksRingPainter(
              percent: percent,
              ticks: totalTicks,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              strokeWidth: strokeWidth,
            ),
          ),
          Positioned.fill(child: Center(child: child)),
        ],
      ),
    );
  }
}

class _TicksRingPainter extends CustomPainter {
  final double percent;
  final int ticks;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  _TicksRingPainter({
    required this.percent,
    required this.ticks,
    required this.activeColor,
    required this.inactiveColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width / 2) - strokeWidth / 2;
    final angle = 2 * pi / ticks;
    final activeTicks = (ticks * percent).toInt();

    for (int i = 0; i < ticks; i++) {
      final paint = Paint()
        ..color = i < activeTicks ? activeColor : inactiveColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;
      final startAngle = -pi / 2 + i * angle;
      final x1 = size.width / 2 + radius * cos(startAngle);
      final y1 = size.height / 2 + radius * sin(startAngle);
      final gap = 12.0; // px length of each tick
      final x2 = size.width / 2 + (radius - gap) * cos(startAngle);
      final y2 = size.height / 2 + (radius - gap) * sin(startAngle);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(_TicksRingPainter oldDelegate) {
    return percent != oldDelegate.percent ||
        activeColor != oldDelegate.activeColor ||
        inactiveColor != oldDelegate.inactiveColor ||
        ticks != oldDelegate.ticks ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
