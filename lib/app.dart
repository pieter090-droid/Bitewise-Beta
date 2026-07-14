import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/constants/app_constants.dart';
import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_theme.dart';

class BitewiseApp extends ConsumerWidget {
  const BitewiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: '${AppConstants.appName} Web Beta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFE9EDF0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
