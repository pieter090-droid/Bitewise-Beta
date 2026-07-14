import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({this.pickMode = false, super.key});

  /// In pickMode geeft een scan de barcode terug via Navigator.pop (voor een
  /// gerecht/favoriet), i.p.v. door te gaan naar het productdetail.
  final bool pickMode;

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final code = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
    if (code == null) return;
    _handled = true;
    _handleBarcode(code);
  }

  void _handleBarcode(String barcode) {
    if (widget.pickMode) {
      Navigator.pop(context, barcode);
      return;
    }
    context.push(Routes.product(barcode)).then((_) {
      // Bij terugkeer weer klaar voor een nieuwe scan.
      if (mounted) setState(() => _handled = false);
    });
  }

  Future<void> _manualEntry() async {
    final controller = TextEditingController();
    final barcode = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Barcode invoeren'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'bv. 8710398526007'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Zoeken'),
          ),
        ],
      ),
    );
    if (barcode != null && barcode.isNotEmpty) _handleBarcode(barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        title: const Text('Scan', style: TextStyle(color: AppColors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_outlined),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          const _ScannerOverlay(),
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Column(
              children: [
                const Text(
                  'Richt op de streepjescode van het product',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.white, fontSize: 15),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.white),
                  ),
                  onPressed: _manualEntry,
                  icon: const Icon(Icons.keyboard_outlined),
                  label: const Text('Barcode handmatig invoeren'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gold, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
