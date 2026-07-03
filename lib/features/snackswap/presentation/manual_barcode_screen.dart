import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/mvp_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/snackswap/data/snackswap_service.dart';

class ManualBarcodeScreen extends ConsumerStatefulWidget {
  const ManualBarcodeScreen({super.key});

  @override
  ConsumerState<ManualBarcodeScreen> createState() =>
      _ManualBarcodeScreenState();
}

/// Wat we onder het invoerveld tonen.
enum _View { idle, invalid, loading, notFound, error }

class _ManualBarcodeScreenState extends ConsumerState<ManualBarcodeScreen> {
  final _controller = TextEditingController();
  _View _view = _View.idle;
  String _errorMessage = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    final input = _controller.text.trim();

    if (!SnackSwapService.isValidBarcode(input)) {
      setState(() => _view = _View.invalid);
      return;
    }

    setState(() => _view = _View.loading);
    final outcome =
        await ref.read(snackSwapServiceProvider).lookupProduct(input);
    if (!mounted) return;

    switch (outcome) {
      case LookupFound(:final product):
        setState(() => _view = _View.idle);
        context.push(MvpRoutes.product, extra: product);
      case LookupNotFound():
        setState(() => _view = _View.notFound);
      case LookupError(:final message):
        setState(() {
          _view = _View.error;
          _errorMessage = message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: const Text('Barcode zoeken'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Voer een barcode (EAN/UPC) in.',
              style: TextStyle(color: AppColors.slate, fontSize: 15),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'bv. 3017620422003',
                prefixIcon: Icon(Icons.qr_code),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _view == _View.loading ? null : _search,
              child: _view == _View.loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: Colors.white),
                    )
                  : const Text('Zoek product'),
            ),
            const SizedBox(height: 24),
            _StatusArea(view: _view, errorMessage: _errorMessage),
          ],
        ),
      ),
    );
  }
}

class _StatusArea extends StatelessWidget {
  const _StatusArea({required this.view, required this.errorMessage});

  final _View view;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return switch (view) {
      _View.idle || _View.loading => const SizedBox.shrink(),
      _View.invalid => const _Message(
          icon: Icons.error_outline,
          color: AppColors.danger,
          title: 'Ongeldige barcode',
          body: 'Een barcode bestaat uit 8 tot 14 cijfers.',
        ),
      _View.notFound => const _Message(
          icon: Icons.search_off,
          color: AppColors.slate,
          title: 'Geen product gevonden',
          body: 'We konden dit product niet vinden. Controleer de barcode.',
        ),
      _View.error => _Message(
          icon: Icons.cloud_off,
          color: AppColors.danger,
          title: 'Er ging iets mis',
          body: errorMessage,
        ),
    };
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mist),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(color: AppColors.slate)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
