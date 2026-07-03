import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/mvp_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';

/// Startscherm: Bitewise-branding + twee acties.
class MvpHomeScreen extends StatelessWidget {
  const MvpHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(MvpRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                'Bitewise',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'SnackSwap',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Scan of zoek een product en vind een betere snack die past bij jouw doel.',
                style: TextStyle(fontSize: 16, color: AppColors.slate, height: 1.4),
              ),
              const Spacer(flex: 2),
              ElevatedButton.icon(
                onPressed: () => context.push(MvpRoutes.manual),
                icon: const Icon(Icons.search),
                label: const Text('Product zoeken'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.push(MvpRoutes.manual),
                icon: const Icon(Icons.keyboard_outlined),
                label: const Text('Handmatige barcode test'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
