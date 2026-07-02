import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bitewise/app.dart';
import 'package:bitewise/core/config/env.dart';
import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/core/supabase/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Config laden (env.json of --dart-define).
  await Env.load();

  // 2. Supabase initialiseren (no-op wanneer geen env geconfigureerd is).
  await SupabaseService.instance.init();

  // 3. Simpele instellingen.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BitewiseApp(),
    ),
  );
}
