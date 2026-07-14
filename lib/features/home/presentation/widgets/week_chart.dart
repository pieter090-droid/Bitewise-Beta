import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/tracker/application/tracker_providers.dart';

/// Staafdiagram van de kcal per dag over de laatste 7 dagen, met een doellijn.
class WeekChart extends StatelessWidget {
  const WeekChart({required this.days, required this.calorieTarget, super.key});

  final List<DayKcal> days;
  final int calorieTarget;

  static const _plotHeight = 120.0;
  static const _labels = ['ma', 'di', 'wo', 'do', 'vr', 'za', 'zo'];

  @override
  Widget build(BuildContext context) {
    final target = calorieTarget.toDouble();
    final maxVal = math.max(
      target,
      days.fold<double>(1, (m, d) => math.max(m, d.kcal)),
    );
    final today = DateTime.now();
    final targetBottom = (target / maxVal) * _plotHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _plotHeight,
          child: Stack(
            children: [
              // Doellijn.
              Positioned(
                left: 0,
                right: 0,
                bottom: targetBottom.clamp(0, _plotHeight),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(height: 1.5, color: AppColors.gold),
                    ),
                    const SizedBox(width: 6),
                    Text('doel $calorieTarget',
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              // Staven.
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final d in days)
                    Expanded(
                      child: _Bar(
                        heightFraction:
                            (d.kcal / maxVal).clamp(0, 1).toDouble(),
                        plotHeight: _plotHeight,
                        isToday: _sameDay(d.day, today),
                        overTarget: d.kcal > target && target > 0,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (final d in days)
              Expanded(
                child: Text(
                  _labels[d.day.weekday - 1],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: _sameDay(d.day, today)
                        ? FontWeight.w800
                        : FontWeight.w500,
                    color: _sameDay(d.day, today)
                        ? AppColors.navy
                        : AppColors.slate,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.heightFraction,
    required this.plotHeight,
    required this.isToday,
    required this.overTarget,
  });

  final double heightFraction;
  final double plotHeight;
  final bool isToday;
  final bool overTarget;

  @override
  Widget build(BuildContext context) {
    final color = overTarget
        ? AppColors.danger
        : isToday
            ? AppColors.gold
            : AppColors.navy400;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: math.max(3, heightFraction * plotHeight),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
      ),
    );
  }
}
