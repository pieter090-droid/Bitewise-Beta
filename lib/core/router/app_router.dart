import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/features/favorites/presentation/favorites_screen.dart';
import 'package:bitewise/features/home/presentation/home_screen.dart';
import 'package:bitewise/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bitewise/features/product/presentation/product_detail_screen.dart';
import 'package:bitewise/features/scanner/presentation/scanner_screen.dart';
import 'package:bitewise/features/settings/presentation/settings_screen.dart';
import 'package:bitewise/features/shell/app_shell.dart';
import 'package:bitewise/features/snackswap/presentation/snackswap_screen.dart';

/// Route-paden centraal, zodat verwijzingen typsafe blijven.
abstract final class Routes {
  static const onboarding = '/onboarding';
  static const home = '/';
  static const scanner = '/scanner';
  static const favorites = '/favorites';
  static const settings = '/settings';

  static String product(String barcode) => '/product/$barcode';
  static String snackswap(String barcode) => '/snackswap/$barcode';
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
            path: Routes.scanner,
            builder: (context, state) => const ScannerScreen(),
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
      // Gepushte detailschermen (buiten de shell, volledig scherm).
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/product/:barcode',
        builder: (context, state) => ProductDetailScreen(
          barcode: state.pathParameters['barcode']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/snackswap/:barcode',
        builder: (context, state) => SnackSwapScreen(
          barcode: state.pathParameters['barcode']!,
        ),
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
