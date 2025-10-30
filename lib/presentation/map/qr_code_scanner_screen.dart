import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/presentation/map/start_session_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerScreen extends StatelessWidget {
  const QrCodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width(),
        height: context.height(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/qr_code.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 200,
              width: 200,
              padding: const EdgeInsets.only(top: 50),

              child: Stack(
                children: [
                  MobileScanner(
                    onDetect: (barcodes) {
                      if (barcodes.raw != null) {
                        context.goTo(StartSessionScreen());
                      }
                      print(barcodes.raw.toString());
                      print(barcodes.barcodes[0].rawValue);
                    },
                  ),
                  SvgPicture.asset("assets/icons/Crosshair.svg"),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                "Find a code to scan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
