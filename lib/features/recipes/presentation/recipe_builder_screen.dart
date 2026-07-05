import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/recipes/data/recipes_repository.dart';
import 'package:bitewise/features/recipes/domain/recipe.dart';
import 'package:bitewise/features/snackswap/data/snackswap_service.dart';
import 'package:bitewise/features/snackswap/domain/snack_product.dart';

/// Stel een gerecht samen: geef het een naam, voeg producten toe (via de
/// normale zoek/scan-manier) en sla het op.
class RecipeBuilderScreen extends ConsumerStatefulWidget {
  const RecipeBuilderScreen({super.key});

  @override
  ConsumerState<RecipeBuilderScreen> createState() =>
      _RecipeBuilderScreenState();
}

class _RecipeBuilderScreenState extends ConsumerState<RecipeBuilderScreen> {
  final _nameController = TextEditingController();
  final List<RecipeItem> _items = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    final barcode = await context.push<String>(Routes.pick);
    if (barcode == null || !mounted) return;

    final outcome =
        await ref.read(snackSwapServiceProvider).lookupProduct(barcode);
    if (!mounted) return;
    if (outcome is! LookupFound) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product niet gevonden.')),
      );
      return;
    }

    final grams = await _askGrams(outcome.product);
    if (grams == null || !mounted) return;

    final p = outcome.product;
    double s(double? per100) => (per100 ?? 0) * grams / 100;
    setState(() {
      _items.add(RecipeItem(
        name: p.name,
        barcode: p.barcode,
        grams: grams,
        kcal: s(p.kcal100),
        protein: s(p.protein100),
        sugar: s(p.sugar100),
        carbs: s(p.carbs100),
        fat: s(p.fat100),
      ));
    });
  }

  Future<double?> _askGrams(SnackProduct product) {
    double grams = 100;
    return showModalBottomSheet<double>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              Text('Portie: ${grams.round()} g',
                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
              Slider(
                value: grams,
                min: 10,
                max: 500,
                divisions: 49,
                activeColor: AppColors.navy,
                onChanged: (v) => setLocal(() => grams = v.roundToDouble()),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, grams),
                child: const Text('Toevoegen aan gerecht'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Geef je gerecht een naam.')));
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Voeg minstens één product toe.')));
      return;
    }
    await ref.read(recipesRepositoryProvider).save(name: name, items: _items);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Gerecht "$name" opgeslagen')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final totalKcal =
        _items.fold<double>(0, (s, i) => s + i.kcal).round();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: const Text('Nieuw gerecht'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Naam van het gerecht',
                      hintText: 'bv. Mijn ontbijt',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Producten',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy)),
                      Text('$totalKcal kcal totaal',
                          style: const TextStyle(color: AppColors.slate)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Nog geen producten toegevoegd.',
                          style: TextStyle(color: AppColors.slate)),
                    ),
                  for (var i = 0; i < _items.length; i++)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(_items[i].name),
                        subtitle: Text(
                            '${_items[i].grams.round()} g · ${_items[i].kcal.round()} kcal'),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: AppColors.slate),
                          onPressed: () => setState(() => _items.removeAt(i)),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _addProduct,
                    icon: const Icon(Icons.add),
                    label: const Text('Product toevoegen'),
                  ),
                ],
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Gerecht opslaan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
