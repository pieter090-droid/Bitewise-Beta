import 'package:flutter/material.dart';

/// Bitewise brand palette.
///
/// Premium, rustig en betrouwbaar. Navy als basis, goud als accent.
abstract final class AppColors {
  // Brand
  static const Color navy = Color(0xFF0D1B2A);
  static const Color gold = Color(0xFFC9A84C);

  // Navy shades
  static const Color navy800 = Color(0xFF16273A);
  static const Color navy600 = Color(0xFF1F3A54);
  static const Color navy400 = Color(0xFF3B5470);

  // Neutrals
  static const Color ink = Color(0xFF0D1B2A);
  static const Color slate = Color(0xFF5B6B7B);
  static const Color mist = Color(0xFFEDF1F5);
  static const Color surface = Color(0xFFFAFBFC);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF3E9E6B);
  static const Color warning = Color(0xFFD9A441);
  static const Color danger = Color(0xFFC65B54);

  // Macro accents (used in progress rings)
  static const Color kcal = gold;
  static const Color protein = Color(0xFF4B8FB3);
  static const Color sugar = Color(0xFFC65B54);
}
