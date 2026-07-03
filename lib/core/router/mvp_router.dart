import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/features/snackswap/domain/snack_product.dart';
import 'package:bitewise/features/snackswap/presentation/manual_barcode_screen.dart';
import 'package:bitewise/features/snackswap/presentation/mvp_home_screen.dart';
import 'package:bitewise/features/snackswap/presentation/snack_product_screen.dart';
import 'package:bitewise/features/snackswap/presentation/snack_settings_screen.dart';
import 'package:bitewise/features/snackswap/presentation/swap_screen.dart';

/// Route-paden voor het SnackSwap-MVP-spoor.
abstract final class MvpRoutes {
  static const home = '/';
  static const manual = '/manual';
  static const product = '/product';
  static const settings = '/settings';

  static String swap(String barcode) => '/swap/$barcode';
}

/// Simpele, platte router voor de MVP. Geen onboarding-gate, geen bottom nav —
/// precies de vijf schermen uit de MVP-flow.
final mvpRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: MvpRoutes.home,
    routes: [
      GoRoute(
        path: MvpRoutes.home,
        builder: (context, state) => const MvpHomeScreen(),
      ),
      GoRoute(
        path: MvpRoutes.manual,
        builder: (context, state) => const ManualBarcodeScreen(),
      ),
      GoRoute(
        path: MvpRoutes.product,
        builder: (context, state) =>
            SnackProductScreen(product: state.extra as SnackProduct),
      ),
      GoRoute(
        path: '/swap/:barcode',
        builder: (context, state) =>
            SwapScreen(barcode: state.pathParameters['barcode']!),
      ),
      GoRoute(
        path: MvpRoutes.settings,
        builder: (context, state) => const SnackSettingsScreen(),
      ),
    ],
  );
});
