import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/snackswap/application/snackswap_providers.dart';
import 'package:bitewise/features/snackswap/data/snackswap_service.dart';
import 'package:bitewise/features/snackswap/domain/goal.dart';
import 'package:bitewise/features/snackswap/domain/swap_suggestion.dart';
import 'package:bitewise/features/sync/application/sync_coordinator.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

class SwapScreen extends ConsumerStatefulWidget {
  const SwapScreen({required this.barcode, super.key});

  final String barcode;

  @override
  ConsumerState<SwapScreen> createState() => _SwapScreenState();
}

enum _View { loading, found, notFound, error }

class _SwapScreenState extends ConsumerState<SwapScreen> {
  late SnackGoal _goal;
  _View _view = _View.loading;
  String _errorMessage = '';
  List<SwapSuggestion> _items = const [];
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    _goal = ref.read(swapDefaultGoalProvider);
    _load();
  }

  Future<void> _load() async {
    setState(() => _view = _View.loading);
    final outcome = await ref.read(snackSwapServiceProvider).recommendSwaps(
          barcode: widget.barcode,
          goal: _goal,
          limit: 8,
        );
    if (!mounted) return;
    switch (outcome) {
      case SwapFound(:final suggestions):
        setState(() {
          _items = suggestions;
          _view = _View.found;
        });
      case SwapNotFound():
        setState(() => _view = _View.notFound);
      case SwapError(:final message):
        setState(() {
          _view = _View.error;
          _errorMessage = message;
        });
    }
  }

  void _selectGoal(SnackGoal goal) {
    if (goal == _goal) return;
    setState(() => _goal = goal);
    _load();
  }

  /// Logt een gekozen swap direct in het daglog (per portie).
  Future<void> _logSwap(SwapSuggestion item) async {
    final meal = MealType.suggestForNow();
    await ref.read(dayLogsRepositoryProvider).logEntry(
          productName: item.name,
          mealType: meal,
          grams: item.grams ?? 100,
          kcal: item.kcal ?? 0,
          protein: item.proteinG ?? 0,
          sugar: item.sugarG ?? 0,
          carbs: item.carbsG ?? 0,
          fat: item.fatG ?? 0,
        );
    ref.read(syncCoordinatorProvider).onLogsChanged();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} toegevoegd aan ${meal.label}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: const Text('Betere swaps'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Wat wil je verbeteren?',
                      style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text(
                    'Bitewise vergelijkt alleen directe of verwante alternatieven.',
                    style: TextStyle(color: AppColors.slate, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final g in SnackGoal.values)
                        ChoiceChip(
                          label: Text(g.label),
                          selected: _goal == g,
                          onSelected: (_) => _selectGoal(g),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 16),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    switch (_view) {
      case _View.loading:
        return const Center(child: CircularProgressIndicator());
      case _View.notFound:
        return const _Info(
          icon: Icons.inbox_outlined,
          title: 'Geen swaps gevonden',
          body: 'Voor dit product en doel hebben we nog geen alternatief.',
        );
      case _View.error:
        return _Info(
          icon: Icons.cloud_off,
          title: 'Er ging iets mis',
          body: _errorMessage,
          action: FilledButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            label: const Text('Opnieuw proberen'),
          ),
        );
      case _View.found:
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            for (var i = 0; i < _items.length; i++)
              _SwapCard(
                rank: i + 1,
                item: _items[i],
                onLog: () => _logSwap(_items[i]),
                onOpen: _items[i].barcode.isEmpty
                    ? null
                    : () => context.push(Routes.product(_items[i].barcode)),
              ),
          ],
        );
    }
  }
}

class _SwapCard extends StatelessWidget {
  const _SwapCard({
    required this.rank,
    required this.item,
    required this.onLog,
    required this.onOpen,
  });

  final int rank;
  final SwapSuggestion item;
  final VoidCallback onLog;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: rank == 1
            ? AppColors.gold.withValues(alpha: 0.08)
            : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.mist),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.navy,
                child: Text('$rank',
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (rank == 1)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text('BESTE KEUZE VOOR JOU',
                            style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 11,
                                letterSpacing: .7,
                                fontWeight: FontWeight.w900)),
                      ),
                    Text(item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.navy)),
                    if (item.brand != null && item.brand!.isNotEmpty)
                      Text(item.brand!,
                          style: const TextStyle(
                              color: AppColors.slate, fontSize: 13)),
                    if (item.tag != null && item.tag!.isNotEmpty)
                      Text('${item.tag!} · ${item.basisLabel}',
                          style: const TextStyle(
                              color: AppColors.slate, fontSize: 12)),
                  ],
                ),
              ),
              _ScoreBadge(score: item.score),
            ],
          ),
          if (item.explanation != null && item.explanation!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(item.explanation!,
                style: const TextStyle(color: AppColors.ink, height: 1.35)),
          ],
          if (_hasNutrition) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (item.kcal != null) _pill('${_fmt(item.kcal!)} kcal'),
                if (item.sugarG != null) _pill('${_fmt(item.sugarG!)}g suiker'),
                if (item.proteinG != null)
                  _pill('${_fmt(item.proteinG!)}g eiwit'),
              ],
            ),
          ],
          if (item.warnings.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Let op: ${item.warnings.first}',
                style: const TextStyle(color: AppColors.slate, fontSize: 12),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (onOpen != null)
                Expanded(
                  child: TextButton(
                    onPressed: onOpen,
                    child: const Text('Bekijk product'),
                  ),
                ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: item.kcal == null ? null : onLog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Log keuze'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool get _hasNutrition =>
      item.kcal != null || item.sugarG != null || item.proteinG != null;

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.mist),
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.navy)),
      );

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    // Score kan 0..1 of 0..100 zijn; toon beide netjes.
    final display = score <= 1 ? (score * 100).round() : score.round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('score $display',
          style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
              fontSize: 12)),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(
      {required this.icon,
      required this.title,
      required this.body,
      this.action});
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

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
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.navy)),
            const SizedBox(height: 6),
            Text(body,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.slate)),
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
