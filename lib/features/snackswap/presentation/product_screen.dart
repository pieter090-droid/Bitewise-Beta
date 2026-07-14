import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/favorites/data/favorites_repository.dart';
import 'package:bitewise/features/snackswap/data/snackswap_service.dart';
import 'package:bitewise/features/snackswap/domain/snack_product.dart';
import 'package:bitewise/features/sync/application/sync_coordinator.dart';
import 'package:bitewise/features/tracker/application/tracker_providers.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

/// Zoekt zelf het product op via barcode en toont detail + portiecalculator,
/// met "Log dit product", een swap-knop en een favoriet-hartje.
final _lookupProvider =
    FutureProvider.family<LookupOutcome, String>((ref, barcode) {
  return ref.read(snackSwapServiceProvider).lookupProduct(barcode);
});

class ProductScreen extends ConsumerWidget {
  const ProductScreen({required this.barcode, super.key});

  final String barcode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_lookupProvider(barcode));

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: const Text('Product'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Message(icon: Icons.cloud_off, text: '$e'),
        data: (outcome) => switch (outcome) {
          LookupFound(:final product) => _ProductBody(product: product),
          LookupNotFound() => const _Message(
              icon: Icons.search_off,
              text: 'Geen product gevonden voor deze barcode.'),
          LookupError(:final message) =>
            _Message(icon: Icons.cloud_off, text: message),
        },
      ),
    );
  }
}

class _ProductBody extends ConsumerStatefulWidget {
  const _ProductBody({required this.product});
  final SnackProduct product;

  @override
  ConsumerState<_ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends ConsumerState<_ProductBody> {
  late double _grams;
  late MealType _meal;

  @override
  void initState() {
    super.initState();
    final suggested = widget.product.servingQuantity;
    _grams = suggested != null && suggested >= 5 && suggested <= 500
        ? suggested
        : 100;
    // Eetmoment voorgeselecteerd via de '+'-knop op het dashboard? Gebruik dat
    // (en consumeer het eenmalig); anders een verstandige suggestie op tijd.
    final pending = ref.read(pendingMealProvider);
    _meal = pending ?? MealType.suggestForNow();
    if (pending != null) {
      Future.microtask(
          () => ref.read(pendingMealProvider.notifier).state = null);
    }
  }

  double _scale(double? per100) => (per100 ?? 0) * _grams / 100;

  Future<void> _log() async {
    await ref.read(dayLogsRepositoryProvider).logEntry(
          barcode: widget.product.barcode,
          productName: widget.product.name,
          mealType: _meal,
          grams: _grams,
          kcal: _scale(widget.product.kcal100),
          protein: _scale(widget.product.protein100),
          sugar: _scale(widget.product.sugar100),
          carbs: _scale(widget.product.carbs100),
          fat: _scale(widget.product.fat100),
        );
    ref.read(syncCoordinatorProvider).onLogsChanged();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${widget.product.name} gelogd bij ${_meal.label}')),
    );
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isFav = ref.watch(isFavoriteProvider(p.barcode)).valueOrNull ?? false;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Bèta · Controleer product- en allergeneninformatie altijd op het etiket.',
                  style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy)),
                        if (p.brand != null && p.brand!.isNotEmpty)
                          Text(p.brand!,
                              style: const TextStyle(color: AppColors.slate)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.danger : AppColors.slate),
                    onPressed: () => ref
                        .read(favoritesRepositoryProvider)
                        .toggle(barcode: p.barcode, name: p.name),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PortionCard(
                grams: _grams,
                meal: _meal,
                onGrams: (v) => setState(() => _grams = v),
                onMeal: (m) => setState(() => _meal = m),
              ),
              const SizedBox(height: 16),
              _NutritionCard(
                grams: _grams,
                kcal: _scale(p.kcal100),
                sugar: _scale(p.sugar100),
                protein: _scale(p.protein100),
                fat: _scale(p.fat100),
                carbs: _scale(p.carbs100),
              ),
              const SizedBox(height: 12),
              Text(
                p.dataQualityScore == null
                    ? 'Datakwaliteit: niet beoordeeld'
                    : 'Datakwaliteit: ${p.dataQualityScore!.round()}/100',
                style: const TextStyle(color: AppColors.slate, fontSize: 12),
              ),
            ],
          ),
        ),
        SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: _log,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Log dit product'),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: () => context.push(Routes.swap(p.barcode)),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Vind betere swap'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PortionCard extends StatelessWidget {
  const _PortionCard({
    required this.grams,
    required this.meal,
    required this.onGrams,
    required this.onMeal,
  });

  final double grams;
  final MealType meal;
  final ValueChanged<double> onGrams;
  final ValueChanged<MealType> onMeal;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Portie',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.navy)),
              Text('${grams.round()} g',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.gold,
                      fontSize: 18)),
            ],
          ),
          Slider(
            value: grams,
            min: 10,
            max: 500,
            divisions: 49,
            activeColor: AppColors.navy,
            onChanged: onGrams,
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final preset in const [30, 50, 100, 150])
                ActionChip(
                  label: Text('$preset g'),
                  onPressed: () => onGrams(preset.toDouble()),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Eetmoment',
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final m in MealType.values)
                ChoiceChip(
                  label: Text(m.label),
                  selected: meal == m,
                  onSelected: (_) => onMeal(m),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({
    required this.grams,
    required this.kcal,
    required this.sugar,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  final double grams;
  final double kcal;
  final double sugar;
  final double protein;
  final double fat;
  final double carbs;

  @override
  Widget build(BuildContext context) {
    String f(double v) =>
        v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Voedingswaarden (${grams.round()} g)',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          _row('Energie', '${f(kcal)} kcal', bold: true),
          _row('Eiwit', '${f(protein)} g'),
          _row('Suiker', '${f(sugar)} g'),
          _row('Vet', '${f(fat)} g'),
          _row('Koolhydraten', '${f(carbs)} g'),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.slate)),
            Text(value,
                style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
          ],
        ),
      );
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.mist),
        ),
        child: child,
      );
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.slate),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
