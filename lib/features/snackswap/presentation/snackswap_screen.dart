import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/snackswap/application/swap_providers.dart';
import 'package:bitewise/features/snackswap/data/swap_feedback_repository.dart';
import 'package:bitewise/features/snackswap/domain/swap_recommendation.dart';

class SnackSwapScreen extends ConsumerWidget {
  const SnackSwapScreen({required this.barcode, super.key});

  final String barcode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(swapRecommendationsProvider(barcode));

    return Scaffold(
      appBar: AppBar(title: const Text('Betere swaps')),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(swapRecommendationsProvider(barcode)),
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _Message(text: '$e'),
          data: (result) => result.when(
            failure: (message) => _Message(text: message),
            success: (recs) {
              if (recs.isEmpty) {
                return const _Message(
                    text: 'Nog geen betere swaps gevonden voor dit product.');
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  const _Intro(),
                  const SizedBox(height: 12),
                  for (final rec in recs)
                    _SwapCard(fromBarcode: barcode, rec: rec),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Afgestemd op je doel en wat je vandaag al at.',
      style: TextStyle(color: AppColors.slate),
    );
  }
}

class _SwapCard extends ConsumerWidget {
  const _SwapCard({required this.fromBarcode, required this.rec});

  final String fromBarcode;
  final SwapRecommendation rec;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedback = ref
        .watch(_feedbackProvider((from: fromBarcode, to: rec.product.barcode)))
        .valueOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(Routes.product(rec.product.barcode)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(14),
                      image: rec.product.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(rec.product.imageUrl!),
                              fit: BoxFit.cover)
                          : null,
                    ),
                    child: rec.product.imageUrl == null
                        ? const Icon(Icons.eco_outlined, color: AppColors.slate)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rec.product.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        if (rec.product.brand != null)
                          Text(rec.product.brand!,
                              style: const TextStyle(
                                  color: AppColors.slate, fontSize: 13)),
                      ],
                    ),
                  ),
                  _ScoreBadge(score: rec.score),
                ],
              ),
              const SizedBox(height: 12),
              Text(rec.reason,
                  style: const TextStyle(color: AppColors.ink, height: 1.35)),
              if (rec.highlights.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final h in rec.highlights) _Highlight(text: h),
                  ],
                ),
              ],
              const Divider(height: 24),
              Row(
                children: [
                  const Text('Nuttige swap?',
                      style: TextStyle(color: AppColors.slate)),
                  const Spacer(),
                  _ThumbButton(
                    icon: Icons.thumb_up_alt_outlined,
                    active: feedback == true,
                    onTap: () => _record(ref, true),
                  ),
                  const SizedBox(width: 8),
                  _ThumbButton(
                    icon: Icons.thumb_down_alt_outlined,
                    active: feedback == false,
                    onTap: () => _record(ref, false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _record(WidgetRef ref, bool positive) {
    ref.read(swapFeedbackRepositoryProvider).record(
          fromBarcode: fromBarcode,
          toBarcode: rec.product.barcode,
          positive: positive,
        );
  }
}

/// Family voor lokale feedback per (from,to)-combinatie.
final _feedbackProvider = StreamProvider.family<bool?, ({String from, String to})>(
  (ref, key) => ref
      .watch(swapFeedbackRepositoryProvider)
      .watchFeedback(key.from, key.to),
);

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    final pct = (score * 100).round().clamp(0, 100);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$pct% match',
          style: const TextStyle(
              color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

class _ThumbButton extends StatelessWidget {
  const _ThumbButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? AppColors.navy : AppColors.mist,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
            size: 20, color: active ? AppColors.white : AppColors.slate),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 120),
        const Icon(Icons.swap_horiz, size: 48, color: AppColors.slate),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(text, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
