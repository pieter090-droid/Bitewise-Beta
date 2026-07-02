# Bitewise

Premium voedingsapp met **SnackSwap** als eerste kernmodule. Scan een product,
zie de voedingswaarden afgezet tegen je dagdoel, en krijg rustige, betrouwbare
swap-aanbevelingen die passen bij jouw doel en wat je vandaag al at.

- **Flutter** · **Riverpod** · **go_router**
- **Drift/SQLite** (lokale, private data) · **shared_preferences** (instellingen)
- **mobile_scanner** (barcodes) · **supabase_flutter** (backend)

Branding: navy `#0D1B2A`, goud `#C9A84C`. Rustig, premium, betrouwbaar (25–45).

---

## Architectuurprincipes

| Data | Waar | Waarom |
|------|------|--------|
| Persoonlijke logs (`day_logs`), favorieten, feedback | **Lokaal** (Drift) | Privacy-first. Sync is optioneel en staat standaard uit. Bij inschakelen worden logs geüpload naar `user_day_logs` (RLS per gebruiker, anonieme auth). |
| Producten & swaps | **Supabase** | Gedeelde, canonieke data. |
| Open Food Facts | **Alleen via Edge Function** `lookup_product` | Client roept OFF nooit direct aan; nieuwe producten worden altijd geüpsert in `products`. |
| AI-aanbevelingen | **Alleen via Edge Function** `recommend_swaps` | AI mag bestaande swaps/producten **alleen rangschikken en uitleggen**, nooit zelf globale data publiceren. |

De datastroom bij een scan:

```
Scan barcode
   → lokale cache (Drift)                       ── hit? klaar
   → Edge Function lookup_product
        → Supabase products                     ── hit? klaar
        → Open Food Facts → upsert products      (fallback)
   → cache lokaal
```

---

## Projectstructuur (feature-first)

```
lib/
  app.dart                      # MaterialApp.router
  main.dart                     # bootstrap: env, supabase, prefs, ProviderScope
  core/
    config/env.dart             # env.json / --dart-define
    constants/                  # app-brede constanten + edge function namen
    database/                   # Drift: tables.dart + app_database.dart
    preferences/                # shared_preferences wrapper + providers
    router/app_router.dart      # go_router + onboarding redirect
    supabase/                   # SupabaseService
    theme/                      # AppColors, AppTheme
    utils/result.dart           # Result<T> (Success/Failure)
  features/
    onboarding/  { domain, data, application, presentation }
    home/        { presentation (dagprogressie) }
    tracker/     { domain, data, application, presentation }
    scanner/     { presentation (mobile_scanner) }
    product/     { domain, data, application, presentation }
    snackswap/   { domain, data, application, presentation }
    favorites/   { data, presentation }
    settings/    { application, presentation }
    sync/        { data, application }   # optionele log-sync (achter toggle)
    shell/       app_shell.dart # bottom navigation
supabase/
  config.toml                   # lokale dev-config (supabase start/db push)
  migrations/0001_init.sql      # products + swaps + RLS
  migrations/0002_sync.sql      # user_day_logs + RLS per gebruiker
  seed.sql                      # voorbeeldproducten + gecureerde swaps
  functions/lookup_product/     # OFF-fallback + upsert
  functions/recommend_swaps/    # ranker + optionele Claude re-rank
tool/
  setup_platform.ps1            # camera-permissies (Android/iOS) na flutter create
```

### Sync (optioneel, privacy-first)
Logs blijven **lokaal** tot de gebruiker in Settings *"Synchroniseren
inschakelen"* aanzet. Dan:
1. logt de app anoniem in (`signInAnonymously` — vereist dat *Anonymous sign-ins*
   aan staat in je Supabase project, staat al in `config.toml`);
2. pusht alle `dirty` logs naar `user_day_logs` (idempotent via
   `<installId>:<lokale id>`);
3. haalt ontbrekende server-logs op (dedupe op `remoteId`).

Nieuwe logs pushen daarna automatisch op de achtergrond; een lokale delete ruimt
ook de serverrij op. Alles is een no-op zolang de toggle uit staat.

Elke feature heeft duidelijk gescheiden lagen: **domain** (modellen), **data**
(services/repositories), **application** (Riverpod providers/controllers) en
**presentation** (schermen/widgets).

---

## Setup

> Flutter is nog niet geïnstalleerd op deze machine. Installeer eerst de
> [Flutter SDK](https://docs.flutter.dev/get-started/install) (Windows) en
> zorg dat `flutter doctor` groen is.

### 1. Platform-mappen genereren
De `lib/`-broncode en `pubspec.yaml` staan er al. Genereer de platform-mappen
(android/ios/web/…) in deze projectmap:

```bash
cd bitewise
flutter create . --org app.bitewise --project-name bitewise
```

Dit voegt `android/`, `ios/`, `web/` etc. toe zonder je `lib/` te overschrijven.

### 2. Dependencies + codegen
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```
De laatste stap genereert `lib/core/database/app_database.g.dart` (Drift).

### 3. Camera-permissies (voor mobile_scanner)
Draai het meegeleverde script — het injecteert idempotent de CAMERA-permissie
(Android) en `NSCameraUsageDescription` (iOS) en controleert `minSdk >= 21`:

```bash
pwsh ./tool/setup_platform.ps1        # of: powershell ./tool/setup_platform.ps1
```

Of handmatig:
- **Android** — in `android/app/src/main/AndroidManifest.xml`:
  `<uses-permission android:name="android.permission.CAMERA"/>` (minSdk ≥ 21).
- **iOS** — in `ios/Runner/Info.plist`: key `NSCameraUsageDescription`.

### 4. Backend (Supabase) — optioneel voor lokaal draaien
De app draait **ook zonder backend** (lokale-only modus: onboarding, tracker,
handmatig gelogde producten). Voor scan-lookup en swaps configureer je Supabase:

```bash
# In supabase/
supabase db push                                   # past 0001_init.sql toe
psql "$DATABASE_URL" -f supabase/seed.sql          # seed: producten + swaps (optioneel)
supabase functions deploy lookup_product
supabase functions deploy recommend_swaps

# Secrets voor de functions
supabase secrets set ANTHROPIC_API_KEY=sk-ant-...  # optioneel (AI re-rank)
# SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY zijn in functions al beschikbaar.
```

### 5. App-config
Kopieer het voorbeeld en vul je project-URL + anon key in:
```bash
cp assets/env/env.example.json assets/env/env.json
```
```json
{ "SUPABASE_URL": "https://xxx.supabase.co", "SUPABASE_ANON_KEY": "eyJ..." }
```
Alternatief via `--dart-define` (wint van env.json):
```bash
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

### 6. Draaien
```bash
flutter run
flutter test        # unit (nutriments/daily summary) + sync-integratietest
```

> De sync-integratietest gebruikt een in-memory Drift-database
> (`NativeDatabase.memory()`) en vereist een sqlite3-library op de host
> (standaard aanwezig op macOS/Linux; op Windows `sqlite3.dll` op PATH).

---

## MVP-status

1. ✅ Thema & routing (navy/goud, go_router + onboarding-redirect, bottom nav)
2. ✅ Onboarding + lokale `user_goals` (doeltype, targets, voorkeuren, allergieën)
3. ✅ Tracker + lokale `day_logs` per eetmoment
4. ✅ Scanner + product-lookup (lokaal → `lookup_product`)
5. ✅ Productdetail + portiecalculator + "Log dit product"
6. ✅ SnackSwap-scherm ("Geef mij een betere swap")
7. ✅ Settings: doelen, privacy (sync/analytics), lokale data beheren
8. ✅ Lokale favorieten + feedbackknoppen (duim omhoog/omlaag)

### Logische vervolgstappen
- Volwaardige auth (e-mail/social) i.p.v. anonieme sessies, met account-migratie.
- Conflictresolutie bij sync (nu: last-write-wins via upsert, geen edits).
- Meer curatie van de `swaps`-tabel voor rijkere aanbevelingen.
- Grafieken/weekoverzicht in de tracker.
```
