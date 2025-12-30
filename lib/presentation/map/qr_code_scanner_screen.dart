import 'package:flutter/material.dart';
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
  bool isFlashOn = false;

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
    final scanAreaSize = 250.0;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          MobileScanner(
            controller: controller,
            onDetect: _handleBarcode,
          ),
          
          // Dark overlay with transparent center
          CustomPaint(
            size: Size(context.width(), context.height()),
            painter: ScannerOverlayPainter(
              scanAreaSize: scanAreaSize,
              borderColor: Colors.white,
              overlayColor: Colors.black.withOpacity(0.6),
            ),
          ),
          
          // Close button at top left
          Positioned(
            top: 50,
            left: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          
          // Text at top
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isProcessing ? "Processing..." : "Find a code to scan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          
          // Flash button at bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  controller.toggleTorch();
                  setState(() {
                    isFlashOn = !isFlashOn;
                  });
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isFlashOn ? Colors.white : Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFlashOn ? Icons.flashlight_on : Icons.flashlight_off,
                    color: isFlashOn ? Colors.black : Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final Color borderColor;
  final Color overlayColor;

  ScannerOverlayPainter({
    required this.scanAreaSize,
    required this.borderColor,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double left = centerX - scanAreaSize / 2;
    final double top = centerY - scanAreaSize / 2;
    final double right = centerX + scanAreaSize / 2;
    final double bottom = centerY + scanAreaSize / 2;
    
    // Draw dark overlay
    final overlayPaint = Paint()..color = overlayColor;
    
    // Top area
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, top), overlayPaint);
    // Bottom area
    canvas.drawRect(Rect.fromLTRB(0, bottom, size.width, size.height), overlayPaint);
    // Left area
    canvas.drawRect(Rect.fromLTRB(0, top, left, bottom), overlayPaint);
    // Right area
    canvas.drawRect(Rect.fromLTRB(right, top, size.width, bottom), overlayPaint);
    
    // Draw corner brackets
    final cornerPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final cornerLength = 40.0;
    final cornerRadius = 12.0;
    
    // Top-left corner
    final topLeftPath = Path()
      ..moveTo(left, top + cornerLength)
      ..lineTo(left, top + cornerRadius)
      ..quadraticBezierTo(left, top, left + cornerRadius, top)
      ..lineTo(left + cornerLength, top);
    canvas.drawPath(topLeftPath, cornerPaint);
    
    // Top-right corner
    final topRightPath = Path()
      ..moveTo(right - cornerLength, top)
      ..lineTo(right - cornerRadius, top)
      ..quadraticBezierTo(right, top, right, top + cornerRadius)
      ..lineTo(right, top + cornerLength);
    canvas.drawPath(topRightPath, cornerPaint);
    
    // Bottom-left corner
    final bottomLeftPath = Path()
      ..moveTo(left, bottom - cornerLength)
      ..lineTo(left, bottom - cornerRadius)
      ..quadraticBezierTo(left, bottom, left + cornerRadius, bottom)
      ..lineTo(left + cornerLength, bottom);
    canvas.drawPath(bottomLeftPath, cornerPaint);
    
    // Bottom-right corner
    final bottomRightPath = Path()
      ..moveTo(right - cornerLength, bottom)
      ..lineTo(right - cornerRadius, bottom)
      ..quadraticBezierTo(right, bottom, right, bottom - cornerRadius)
      ..lineTo(right, bottom - cornerLength);
    canvas.drawPath(bottomRightPath, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
