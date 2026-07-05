import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/features/favorites/presentation/favorites_screen.dart';
import 'package:bitewise/features/home/presentation/home_screen.dart';
import 'package:bitewise/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bitewise/features/recipes/presentation/recipe_builder_screen.dart';
import 'package:bitewise/features/scanner/presentation/scanner_screen.dart';
import 'package:bitewise/features/settings/presentation/settings_screen.dart';
import 'package:bitewise/features/shell/app_shell.dart';
import 'package:bitewise/features/snackswap/presentation/product_screen.dart';
import 'package:bitewise/features/snackswap/presentation/scan_screen.dart';
import 'package:bitewise/features/snackswap/presentation/swap_screen.dart';

/// Route-paden centraal.
abstract final class Routes {
  static const onboarding = '/onboarding';
  static const home = '/';
  static const scan = '/scan';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const camera = '/camera';
  static const pick = '/pick';
  static const recipeBuilder = '/recipe/new';

  static String product(String barcode) => '/product/$barcode';
  static String swap(String barcode) => '/swap/$barcode';
}

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.home,
    refreshListenable: _OnboardingListenable(ref),
    redirect: (context, state) {
      final complete = ref.read(onboardingCompleteProvider);
      final atOnboarding = state.matchedLocation == Routes.onboarding;
      if (!complete && !atOnboarding) return Routes.onboarding;
      if (complete && atOnboarding) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Bottom-nav shell.
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: Routes.scan,
            builder: (context, state) => const ScanScreen(),
          ),
          GoRoute(
            path: Routes.favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: Routes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      // Volledig-scherm gepushte routes (buiten de shell).
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.camera,
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.pick,
        builder: (context, state) => const ScanScreen(pickMode: true),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.recipeBuilder,
        builder: (context, state) => const RecipeBuilderScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/product/:barcode',
        builder: (context, state) =>
            ProductScreen(barcode: state.pathParameters['barcode']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/swap/:barcode',
        builder: (context, state) =>
            SwapScreen(barcode: state.pathParameters['barcode']!),
      ),
    ],
  );
});

/// Herbouwt de router wanneer de onboarding-status verandert.
class _OnboardingListenable extends ChangeNotifier {
  _OnboardingListenable(Ref ref) {
    ref.listen(onboardingCompleteProvider, (_, __) => notifyListeners());
  }
}
