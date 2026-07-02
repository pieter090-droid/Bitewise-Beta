import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/favorites/data/favorites_repository.dart';
import 'package:bitewise/features/product/application/portion_controller.dart';
import 'package:bitewise/features/product/data/product_lookup_service.dart';
import 'package:bitewise/features/product/domain/nutriments.dart';
import 'package:bitewise/features/product/domain/product.dart';
import 'package:bitewise/features/sync/application/sync_coordinator.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.barcode, super.key});

  final String barcode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productByBarcodeProvider(barcode));

    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(message: '$e'),
        data: (result) => result.when(
          failure: (message) => _ErrorState(message: message),
          success: (product) => _ProductBody(product: product),
        ),
      ),
    );
  }
}

class _ProductBody extends ConsumerStatefulWidget {
  const _ProductBody({required this.product});
  final Product product;

  @override
  ConsumerState<_ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends ConsumerState<_ProductBody> {
  @override
  void initState() {
    super.initState();
    // Init portie op basis van dit product na de eerste frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(portionControllerProvider.notifier).initFor(widget.product);
    });
  }

  Future<void> _log() async {
    final portion = ref.read(portionControllerProvider);
    await ref.read(dayLogsRepositoryProvider).logProduct(
          product: widget.product,
          mealType: portion.mealType,
          grams: portion.grams,
        );
    // Push naar de backend als sync aan staat (no-op wanneer uit).
    ref.read(syncCoordinatorProvider).onLogsChanged();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.name} gelogd bij ${portion.mealType.label}')),
    );
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final portion = ref.watch(portionControllerProvider);
    final scaled = product.nutriments.scaledToGrams(portion.grams);
    final isFav =
        ref.watch(isFavoriteProvider(product.barcode)).valueOrNull ?? false;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _Header(product: product, isFavorite: isFav),
              const SizedBox(height: 20),
              _PortionCalculator(product: product, portion: portion),
              const SizedBox(height: 20),
              _NutritionCard(scaled: scaled, grams: portion.grams),
            ],
          ),
        ),
        _BottomActions(
          onLog: _log,
          onSwap: () => context.push(Routes.snackswap(product.barcode)),
        ),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.product, required this.isFavorite});
  final Product product;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.mist,
            borderRadius: BorderRadius.circular(16),
            image: product.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(product.imageUrl!), fit: BoxFit.cover)
                : null,
          ),
          child: product.imageUrl == null
              ? const Icon(Icons.inventory_2_outlined, color: AppColors.slate)
              : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name,
                  style: Theme.of(context).textTheme.titleLarge),
              if (product.brand != null)
                Text(product.brand!,
                    style: const TextStyle(color: AppColors.slate)),
              const SizedBox(height: 4),
              if (product.nutriScore != null || product.novaGroup != null)
                Wrap(spacing: 8, children: [
                  if (product.nutriScore != null)
                    _Tag(label: 'Nutri-Score ${product.nutriScore!.toUpperCase()}'),
                  if (product.novaGroup != null)
                    _Tag(label: 'NOVA ${product.novaGroup}'),
                ]),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.danger : AppColors.slate,
          ),
          onPressed: () =>
              ref.read(favoritesRepositoryProvider).toggle(product),
        ),
      ],
    );
  }
}

class _PortionCalculator extends ConsumerWidget {
  const _PortionCalculator({required this.product, required this.portion});
  final Product product;
  final PortionState portion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(portionControllerProvider.notifier);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Portie', style: Theme.of(context).textTheme.titleMedium),
                Text('${portion.grams.round()} g',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: AppColors.gold, fontSize: 18)),
              ],
            ),
            Slider(
              value: portion.grams,
              min: 10,
              max: 500,
              divisions: 49,
              activeColor: AppColors.navy,
              onChanged: ctrl.setGrams,
            ),
            Wrap(
              spacing: 8,
              children: [
                for (final preset in const [30, 50, 100, 150])
                  ActionChip(
                    label: Text('$preset g'),
                    onPressed: () => ctrl.setGrams(preset.toDouble()),
                  ),
                if (product.servingSizeGrams != null)
                  ActionChip(
                    label: Text('1 portie (${product.servingSizeGrams!.round()} g)'),
                    onPressed: () => ctrl.setGrams(product.servingSizeGrams!),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Eetmoment', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final meal in MealType.values)
                  ChoiceChip(
                    label: Text(meal.label),
                    selected: portion.mealType == meal,
                    onSelected: (_) => ctrl.setMealType(meal),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({required this.scaled, required this.grams});
  final Nutriments scaled;
  final double grams;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Voedingswaarden (${grams.round()} g)',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _NutriRow(label: 'Energie', value: '${scaled.kcal.round()} kcal', bold: true),
            _NutriRow(label: 'Eiwit', value: '${scaled.protein.toStringAsFixed(1)} g'),
            _NutriRow(label: 'Suiker', value: '${scaled.sugar.toStringAsFixed(1)} g'),
            if (scaled.carbs != null)
              _NutriRow(label: 'Koolhydraten', value: '${scaled.carbs!.toStringAsFixed(1)} g'),
            if (scaled.fat != null)
              _NutriRow(label: 'Vet', value: '${scaled.fat!.toStringAsFixed(1)} g'),
            if (scaled.saturatedFat != null)
              _NutriRow(label: '— waarvan verzadigd', value: '${scaled.saturatedFat!.toStringAsFixed(1)} g'),
            if (scaled.fiber != null)
              _NutriRow(label: 'Vezels', value: '${scaled.fiber!.toStringAsFixed(1)} g'),
            if (scaled.salt != null)
              _NutriRow(label: 'Zout', value: '${scaled.salt!.toStringAsFixed(2)} g'),
          ],
        ),
      ),
    );
  }
}

class _NutriRow extends StatelessWidget {
  const _NutriRow({required this.label, required this.value, this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      color: bold ? AppColors.navy : AppColors.ink,
      fontSize: bold ? 16 : 15,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.slate, fontSize: style.fontSize)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.onLog, required this.onSwap});
  final VoidCallback onLog;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onLog,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Log dit product'),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: onSwap,
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Geef mij een betere swap'),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: AppColors.slate),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
