import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';

/// Scaffold met bottom-navigatie rond de hoofdschermen.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _tabs = [
    (route: Routes.home, icon: Icons.home_outlined, active: Icons.home, label: 'Home'),
    (route: Routes.scanner, icon: Icons.qr_code_scanner_outlined, active: Icons.qr_code_scanner, label: 'Scan'),
    (route: Routes.favorites, icon: Icons.favorite_outline, active: Icons.favorite, label: 'Favorieten'),
    (route: Routes.settings, icon: Icons.settings_outlined, active: Icons.settings, label: 'Instellingen'),
  ];

  int _indexFor(String location) {
    final i = _tabs.indexWhere((t) => t.route == location);
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _indexFor(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(_tabs[i].route),
        destinations: [
          for (final t in _tabs)
            NavigationDestination(
              icon: Icon(t.icon),
              selectedIcon: Icon(t.active),
              label: t.label,
            ),
        ],
      ),
    );
  }
}
