import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/snackswap/data/snackswap_service.dart';
import 'package:bitewise/features/snackswap/domain/snack_product.dart';
import 'package:bitewise/features/tracker/application/tracker_providers.dart';

/// Toevoegen: zoek op productnaam (suggesties), voer een barcode in, of scan.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({this.pickMode = false, super.key});

  /// In pickMode geeft het scherm de gekozen barcode terug via Navigator.pop
  /// (voor favorieten/gerecht), i.p.v. door te gaan naar het productdetail.
  final bool pickMode;

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _searching = false;
  List<SnackProduct> _results = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final q = value.trim();
    setState(() => _query = q);
    if (q.length < 2 || SnackSwapService.isValidBarcode(q)) {
      setState(() => _results = const []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _runSearch(q));
  }

  Future<void> _runSearch(String q) async {
    setState(() => _searching = true);
    final res = await ref.read(snackSwapServiceProvider).searchProducts(q);
    if (!mounted || q != _query) return;
    setState(() {
      _results = res;
      _searching = false;
    });
  }

  void _open(String barcode) {
    if (widget.pickMode) {
      Navigator.pop(context, barcode);
    } else {
      context.push(Routes.product(barcode));
    }
  }

  Future<void> _openCamera() async {
    if (widget.pickMode) {
      // Camera in kiesmodus geeft de barcode terug; die reiken we door.
      final bc = await context.push<String>(Routes.cameraPick);
      if (bc != null && mounted) _open(bc);
    } else {
      context.push(Routes.camera);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingMeal = ref.watch(pendingMealProvider);
    final isBarcode = SnackSwapService.isValidBarcode(_query);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: Text(widget.pickMode ? 'Kies product' : 'Toevoegen'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (pendingMeal != null && !widget.pickMode)
              Container(
                width: double.infinity,
                color: AppColors.gold.withValues(alpha: 0.18),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text('Toevoegen aan ${pendingMeal.label}',
                    style: const TextStyle(
                        color: AppColors.navy, fontWeight: FontWeight.w700)),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: _onChanged,
                onSubmitted: (v) {
                  final q = v.trim();
                  if (SnackSwapService.isValidBarcode(q)) _open(q);
                },
                decoration: const InputDecoration(
                  hintText: 'Zoek op naam of voer een barcode in',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(child: _body(isBarcode)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: OutlinedButton.icon(
                onPressed: _openCamera,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan met camera'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(bool isBarcode) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      children: [
        if (isBarcode)
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code, color: AppColors.navy),
              title: Text('Zoek barcode $_query'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _open(_query),
            ),
          ),
        if (_searching)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (!_searching && !isBarcode && _query.length >= 2 && _results.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Center(
              child: Text(
                'Geen producten gevonden.\nProbeer een barcode of de camera.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.slate),
              ),
            ),
          ),
        for (final p in _results)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(p.name),
              subtitle: (p.brand != null && p.brand!.isNotEmpty)
                  ? Text(p.brand!)
                  : null,
              trailing: p.kcal100 != null
                  ? Text('${p.kcal100!.round()} kcal',
                      style: const TextStyle(
                          color: AppColors.slate, fontWeight: FontWeight.w600))
                  : null,
              onTap: () => _open(p.barcode),
            ),
          ),
      ],
    );
  }
}
