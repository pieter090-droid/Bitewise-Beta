import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/snackswap/application/snackswap_providers.dart';
import 'package:bitewise/features/snackswap/data/snackswap_service.dart';
import 'package:bitewise/features/snackswap/domain/goal.dart';
import 'package:bitewise/features/snackswap/domain/swap_suggestion.dart';

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
    _goal = ref.read(defaultGoalProvider);
    _load();
  }

  Future<void> _load() async {
    setState(() => _view = _View.loading);
    final outcome = await ref.read(snackSwapServiceProvider).recommendSwaps(
          barcode: widget.barcode,
          goal: _goal,
          limit: 3,
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
              child: Wrap(
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
        );
      case _View.found:
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            for (var i = 0; i < _items.length; i++)
              _SwapCard(rank: i + 1, item: _items[i]),
          ],
        );
    }
  }
}

class _SwapCard extends StatelessWidget {
  const _SwapCard({required this.rank, required this.item});

  final int rank;
  final SwapSuggestion item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
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
                    Text(item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.navy)),
                    if (item.brand != null && item.brand!.isNotEmpty)
                      Text(item.brand!,
                          style: const TextStyle(
                              color: AppColors.slate, fontSize: 13)),
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
                if (item.kcal100 != null)
                  _pill('${_fmt(item.kcal100!)} kcal'),
                if (item.sugar100 != null)
                  _pill('${_fmt(item.sugar100!)}g suiker'),
                if (item.protein100 != null)
                  _pill('${_fmt(item.protein100!)}g eiwit'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool get _hasNutrition =>
      item.kcal100 != null || item.sugar100 != null || item.protein100 != null;

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
  const _Info({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

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
          ],
        ),
      ),
    );
  }
}
