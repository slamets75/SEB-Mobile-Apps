import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../constants/app_constants.dart';
import '../services/security_service.dart';
import 'exam_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  
  final SecurityService _securityService = SecurityService();
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        setState(() => _isProcessing = true);
        _handleScannedData(rawValue.trim());
        break;
      }
    }
  }

  void _handleScannedData(String scannedText) {
    // Check if the scanned string is a valid URL
    String targetUrl = scannedText;
    if (!targetUrl.startsWith('http://') && !targetUrl.startsWith('https://')) {
      targetUrl = 'https://$targetUrl';
    }

    final isAllowed = _securityService.isUrlAllowed(targetUrl);

    if (!isAllowed) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.gpp_bad_rounded, color: AppConstants.dangerRed),
              SizedBox(width: 8),
              Text('QR Code Tidak Valid'),
            ],
          ),
          content: Text(
            'QR Code tidak mengarah ke server LMS Elena ($targetUrl). Harap pindai QR Code resmi dari pengawas ujian.',
            style: const TextStyle(fontSize: 13),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryBlue,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() => _isProcessing = false);
              },
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      return;
    }

    // Launch into secure ExamScreen
    _scannerController.stop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => ExamScreen(initialUrl: targetUrl),
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryDark,
        elevation: 0,
        title: const Text(
          'Pindai QR Code Ujian',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder<TorchState>(
              valueListenable: _scannerController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off_rounded, color: Colors.white70);
                  case TorchState.on:
                    return const Icon(Icons.flash_on_rounded, color: AppConstants.accentGold);
                }
              },
            ),
            onPressed: () => _scannerController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white70),
            onPressed: () => _scannerController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // Custom Scanner Target Frame
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: AppConstants.accentGold,
                borderRadius: 16,
                borderLength: 30,
                borderWidth: 6,
                cutOutSize: 260,
              ),
            ),
          ),

          // Instruction Text
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner_rounded, color: AppConstants.accentGold, size: 28),
                  SizedBox(height: 6),
                  Text(
                    'Arahkan kamera ke QR Code Ujian Elena',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'QR Code biasanya disediakan oleh Dosen / Pengawas pada papan tulis atau lembar pengawas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
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
}

// Custom Painter Overlay for Scanner
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxRect = Rect.fromCenter(
      center: Offset(width / 2, height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    // Draw dark background with center cutout
    final backgroundPath = Path()
      ..addRect(rect)
      ..addRRect(RRect.fromRectAndRadius(boxRect, Radius.circular(borderRadius)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    // Draw Corner Borders
    final r = borderRadius;
    final l = borderLength;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(boxRect.left, boxRect.top + l)
        ..lineTo(boxRect.left, boxRect.top + r)
        ..arcToPoint(Offset(boxRect.left + r, boxRect.top), radius: Radius.circular(r))
        ..lineTo(boxRect.left + l, boxRect.top),
      borderPaint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(boxRect.right - l, boxRect.top)
        ..lineTo(boxRect.right - r, boxRect.top)
        ..arcToPoint(Offset(boxRect.right, boxRect.top + r), radius: Radius.circular(r))
        ..lineTo(boxRect.right, boxRect.top + l),
      borderPaint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(boxRect.right, boxRect.bottom - l)
        ..lineTo(boxRect.right, boxRect.bottom - r)
        ..arcToPoint(Offset(boxRect.right - r, boxRect.bottom), radius: Radius.circular(r))
        ..lineTo(boxRect.right - l, boxRect.bottom),
      borderPaint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(boxRect.left + l, boxRect.bottom)
        ..lineTo(boxRect.left + r, boxRect.bottom)
        ..arcToPoint(Offset(boxRect.left, boxRect.bottom - r), radius: Radius.circular(r))
        ..lineTo(boxRect.left, boxRect.bottom - l),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}

