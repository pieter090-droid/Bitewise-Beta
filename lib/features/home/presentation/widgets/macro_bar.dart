import 'package:flutter/material.dart';

import 'package:bitewise/core/theme/app_colors.dart';

/// Horizontale macro-voortgangsbalk met label en waarde.
class MacroBar extends StatelessWidget {
  const MacroBar({
    required this.label,
    required this.progress,
    required this.color,
    required this.valueText,
    this.warning = false,
    super.key,
  });

  final String label;
  final double progress;
  final Color color;
  final String valueText;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            Text(
              valueText,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: warning ? AppColors.danger : AppColors.slate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 10,
            backgroundColor: AppColors.mist,
            valueColor: AlwaysStoppedAnimation(
              warning ? AppColors.danger : color,
            ),
          ),
        ),
      ],
    );
  }
}
