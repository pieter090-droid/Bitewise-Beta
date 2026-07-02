import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

/// Runtime configuration loaded from `assets/env/env.json`.
///
/// Houd secrets buiten source control. Zie `assets/env/env.example.json`.
/// Je kunt waarden ook via `--dart-define` injecteren; die winnen.
class Env {
  Env._({required this.supabaseUrl, required this.supabaseAnonKey});

  final String supabaseUrl;
  final String supabaseAnonKey;

  static late Env _instance;
  static Env get instance => _instance;

  static const _defineUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const _defineKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  static Future<void> load() async {
    var url = _defineUrl;
    var key = _defineKey;

    if (url.isEmpty || key.isEmpty) {
      try {
        final raw = await rootBundle.loadString('assets/env/env.json');
        final map = json.decode(raw) as Map<String, dynamic>;
        url = url.isEmpty ? (map['SUPABASE_URL'] as String? ?? '') : url;
        key = key.isEmpty ? (map['SUPABASE_ANON_KEY'] as String? ?? '') : key;
      } catch (_) {
        // env.json ontbreekt: app draait dan in "lokale-only" modus.
      }
    }

    _instance = Env._(supabaseUrl: url, supabaseAnonKey: key);
  }

  /// True wanneer Supabase geconfigureerd is; anders draait de app puur lokaal.
  bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
