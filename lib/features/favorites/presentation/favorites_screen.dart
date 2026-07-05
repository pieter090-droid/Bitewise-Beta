import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/favorites/data/favorites_repository.dart';
import 'package:bitewise/features/recipes/data/recipes_repository.dart';
import 'package:bitewise/features/recipes/domain/recipe.dart';
import 'package:bitewise/features/snackswap/data/snackswap_service.dart';
import 'package:bitewise/features/sync/application/sync_coordinator.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  Future<MealType?> _pickMeal() {
    return showModalBottomSheet<MealType>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Voeg toe aan…',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            for (final m in MealType.values)
              ListTile(
                leading: Icon(m.icon, color: AppColors.navy600),
                title: Text(m.label),
                onTap: () => Navigator.pop(context, m),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _addRecipeToDay(Recipe recipe) async {
    final messenger = ScaffoldMessenger.of(context);
    final meal = await _pickMeal();
    if (meal == null || !mounted) return;
    await ref.read(dayLogsRepositoryProvider).logEntry(
          productName: recipe.name,
          mealType: meal,
          grams: 0,
          kcal: recipe.totalKcal,
          protein: recipe.totalProtein,
          sugar: recipe.totalSugar,
          carbs: recipe.totalCarbs,
          fat: recipe.totalFat,
        );
    ref.read(syncCoordinatorProvider).onLogsChanged();
    messenger.showSnackBar(
      SnackBar(content: Text('${recipe.name} toegevoegd aan ${meal.label}')),
    );
  }

  Future<void> _addFavorite() async {
    final messenger = ScaffoldMessenger.of(context);
    final barcode = await context.push<String>(Routes.pick);
    if (barcode == null || !mounted) return;
    final outcome =
        await ref.read(snackSwapServiceProvider).lookupProduct(barcode);
    if (!mounted) return;
    if (outcome is LookupFound) {
      await ref.read(favoritesRepositoryProvider).add(
          barcode: outcome.product.barcode, name: outcome.product.name);
      messenger.showSnackBar(SnackBar(
          content: Text('${outcome.product.name} toegevoegd aan favorieten')));
    } else {
      messenger.showSnackBar(
          const SnackBar(content: Text('Product niet gevonden.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipesProvider).valueOrNull ?? const [];
    final favorites = ref.watch(favoritesProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Favorieten')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _SectionHeader(
            title: 'Mijn gerechten',
            actionLabel: 'Nieuw',
            onAction: () => context.push(Routes.recipeBuilder),
          ),
          if (recipes.isEmpty)
            const _Empty('Nog geen gerechten. Maak er één om snel toe te voegen.'),
          for (final r in recipes)
            _RecipeTile(
              recipe: r,
              onAdd: () => _addRecipeToDay(r),
              onDelete: () =>
                  ref.read(recipesRepositoryProvider).delete(r.id),
            ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Favoriete producten',
            actionLabel: 'Toevoegen',
            onAction: _addFavorite,
          ),
          if (favorites.isEmpty)
            const _Empty('Nog geen favorieten. Tik op "Toevoegen" of het hartje bij een product.'),
          for (final f in favorites)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.mist,
                  child: Icon(Icons.favorite, color: AppColors.danger, size: 20),
                ),
                title: Text(f.name),
                subtitle: Text('Barcode ${f.barcode}',
                    style: const TextStyle(fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.slate),
                  onPressed: () =>
                      ref.read(favoritesRepositoryProvider).remove(f.barcode),
                ),
                onTap: () => context.push(Routes.product(f.barcode)),
              ),
            ),
        ],
      ),
    );
  }
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({
    required this.recipe,
    required this.onAdd,
    required this.onDelete,
  });

  final Recipe recipe;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: AppColors.navy)),
                  Text(
                      '${recipe.items.length} producten · ${recipe.totalKcal.round()} kcal',
                      style: const TextStyle(
                          color: AppColors.slate, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.gold),
              tooltip: 'Toevoegen aan dag',
              onPressed: onAdd,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.slate),
              tooltip: 'Verwijder',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 38),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            onPressed: onAction,
            icon: const Icon(Icons.add, size: 18),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text, style: const TextStyle(color: AppColors.slate)),
      );
}
