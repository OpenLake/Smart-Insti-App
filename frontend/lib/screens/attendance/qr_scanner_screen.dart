
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/attendance_service.dart';
import 'dart:convert';

class QRScannerScreen extends ConsumerStatefulWidget {
  const QRScannerScreen({super.key});

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.stop();
    }
    controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _processBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
        final String rawValue = barcode.rawValue!;
        // Valid QR format: {"courseId": "...", "sessionId": "..."}
        // Or encrypted string
        
        Map<String, dynamic> data;
        try {
            data = jsonDecode(rawValue);
        } catch (e) {
             _showResultDialog("Invalid QR Code", false);
             setState(() => _isProcessing = false);
             return;
        }

        if (!data.containsKey('courseId') || !data.containsKey('sessionId')) {
            _showResultDialog("Invalid QR Data", false);
            setState(() => _isProcessing = false);
            return;
        }

        // Get Location
        Map<String, double>? locationData;
        try {
            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (serviceEnabled) {
                var permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                }
                
                if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
                    final position = await Geolocator.getCurrentPosition();
                    locationData = {
                        'latitude': position.latitude,
                        'longitude': position.longitude
                    };
                }
            }
        } catch (e) {
            // Ignore location errors for now or handle them
        }

        final result = await ref.read(attendanceServiceProvider).markAttendance(
            data['courseId'], 
            data['sessionId'],
            location: locationData
        );

        if (mounted) {
            _showResultDialog(result['message'] ?? "Processing...", result['status'] == true);
        }

    } catch (e) {
        if (mounted) {
            _showResultDialog("Error processing QR: $e", false);
        }
    } finally {
        if (mounted) {
             // Delay processing flag reset to prevent double scans immediately
             Future.delayed(const Duration(seconds: 2), () {
                 if (mounted) setState(() => _isProcessing = false);
             });
        }
    }
  }

  void _showResultDialog(String message, bool success) {
      showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
              backgroundColor: UltimateTheme.surfaceColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      Icon(
                          success ? Icons.check_circle : Icons.error, 
                          color: success ? Colors.green : Colors.red, 
                          size: 64
                      ),
                      const SizedBox(height: 16),
                      Text(
                          success ? "Success" : "Failed",
                          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 8),
                      Text(message, textAlign: TextAlign.center, style: GoogleFonts.outfit()),
                  ],
              ),
              actions: [
                  TextButton(
                      onPressed: () {
                          Navigator.pop(ctx);
                          if (success) {
                              context.pop(); // Go back to home
                          }
                      }, 
                      child: Text("OK", style: GoogleFonts.outfit(color: UltimateTheme.primaryColor))
                  )
              ],
          )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Scan Attendance", style: GoogleFonts.outfit(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
          children: [
              MobileScanner(
                  controller: controller,
                  onDetect: _processBarcode,
              ),
              Center(
                  child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                          border: Border.all(color: UltimateTheme.primaryColor, width: 4),
                          borderRadius: BorderRadius.circular(16)
                      ),
                  ),
              ),
              Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text(
                              "Align QR code within the frame",
                              style: GoogleFonts.outfit(color: Colors.white)
                          ),
                      ),
                  ),
              )
          ],
      ),
    );
  }
}
