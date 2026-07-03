import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/mvp_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/snackswap/domain/snack_product.dart';

/// Toont de voedingswaarden van een gevonden product + knop naar swaps.
class SnackProductScreen extends StatelessWidget {
  const SnackProductScreen({required this.product, super.key});

  final SnackProduct product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: const Text('Product'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy)),
                  if (product.brand != null && product.brand!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(product.brand!,
                          style: const TextStyle(
                              color: AppColors.slate, fontSize: 16)),
                    ),
                  if (product.source != null) ...[
                    const SizedBox(height: 10),
                    _SourceBadge(source: product.source!),
                  ],
                  const SizedBox(height: 20),
                  _NutritionCard(product: product),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: FilledButton.icon(
                onPressed: () =>
                    context.push(MvpRoutes.swap(product.barcode)),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Vind betere swap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.source});
  final String source;

  @override
  Widget build(BuildContext context) {
    final label = switch (source) {
      'supabase' => 'Uit database',
      'open_food_facts_saved' => 'Nieuw toegevoegd (Open Food Facts)',
      _ => source,
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({required this.product});
  final SnackProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.mist),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Voedingswaarden per 100 g',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 12),
          _row('Calorieën', product.kcal100, 'kcal', bold: true),
          _row('Suiker', product.sugar100, 'g'),
          _row('Eiwit', product.protein100, 'g'),
          _row('Vet', product.fat100, 'g'),
          _row('Koolhydraten', product.carbs100, 'g'),
        ],
      ),
    );
  }

  Widget _row(String label, double? value, String unit, {bool bold = false}) {
    final text = value == null ? '–' : '${_fmt(value)} $unit';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.slate, fontSize: 15)),
          Text(text,
              style: TextStyle(
                  color: AppColors.navy,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  fontSize: bold ? 16 : 15)),
        ],
      ),
    );
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}
