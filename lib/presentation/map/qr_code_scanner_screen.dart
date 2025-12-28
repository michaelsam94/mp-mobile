import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/presentation/map/start_session_screen.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isProcessing = false;

  void _handleBarcode(BarcodeCapture barcodeCapture) {
    // منع المعالجة المتعددة
    if (isProcessing) return;

    if (barcodeCapture.barcodes.isEmpty) return;

    final barcode = barcodeCapture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null && code.isNotEmpty) {
      setState(() => isProcessing = true);

      // إيقاف السكانر مؤقتاً
      controller.stop();

      // الانتقال للشاشة التالية
      _processQrCode(code);
    }
  }

  void _processQrCode(String qrCode) {
    try {
      if (qrCode.length == 12) {
        final chargerId = qrCode.substring(0, 10);
        final connectorId = qrCode.substring(10, 12);

        if (ProfileCubit.get(context).defaultRFID != null) {
          context.goOff(
            StartSessionScreen(
              chargerId: chargerId,
              connectorId: connectorId,
              rfidCode: ProfileCubit.get(context).defaultRFID?.code ?? "",
            ),
          );
        } else {
          context.showErrorMessage("No RFID Card found");
        }
      } else {
        context.showErrorMessage("Code is invalid");
      }
    } catch (e) {
      print('Error parsing QR Code: $e');
      context.showErrorMessage("Invalid QR Code format");
      // إعادة تشغيل السكانر
      Future.delayed(Duration(seconds: 2), () {
        controller.start();
        setState(() => isProcessing = false);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: Stack(
          children: [
            MobileScanner(controller: controller, onDetect: _handleBarcode),
            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SvgPicture.asset("assets/icons/Crosshair.svg"),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  isProcessing ? "Processing..." : "Find a code to scan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
