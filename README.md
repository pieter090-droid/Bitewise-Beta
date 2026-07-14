# Bitewise Web Beta

Afzonderlijke testversie van Bitewise, gebouwd op de oorspronkelijke app. Dit
project gebruikt de bestaande Supabase uitsluitend als productdatabron. Het
bevat geen automatische database-, migratie- of Edge Function-deployment.

## Wat deze beta anders doet

- Persoonlijke testdata blijft lokaal in de browser; cloudsync en analytics
  staan uit.
- Swaps worden lokaal en deterministisch gerangschikt vanuit de bestaande
  `product_features_resolved`-view en `swap_family_mapping`.
- Er is geen AI-aanroep per scan: de uitkomst is uitlegbaar, voorspelbaar en
  veroorzaakt geen variabele AI-kosten.
- Onbekende voedingswaarden blijven onbekend en tellen nooit als nul.
- Alleen betekenisvolle verbeteringen worden als swap getoond.
- Onbetrouwbare porties vallen terug op een vergelijking per 100 gram/ml.
- Allergenen- en productinformatie moet altijd op het etiket worden nagekeken.

De map `supabase/` komt uit het oorspronkelijke project en blijft uitsluitend
als historische referentie aanwezig. Voer de migraties en deploycommando's uit
die daar staan **niet** uit voor deze beta.

## Lokaal testen

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run -d chrome \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

Gebruik alleen de publishable/anon key. Plaats nooit een service-role key in de
app, repository of GitHub Pages-configuratie.

## Gratis publiceren via GitHub Pages

1. Gebruik een publieke GitHub-repository met standaardbranch `main`.
2. Kies bij **Settings > Pages** als bron **GitHub Actions**.
3. Voeg bij **Settings > Secrets and variables > Actions > Variables** toe:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Start de workflow **Validate and deploy Bitewise Web Beta**, of push naar
   `main`.

De workflow haalt dependencies op, controleert formatting, analyseert en test
de app, bouwt Flutter Web en publiceert alleen het statische webresultaat. Hij
voert geen Supabase-commando's uit.

## Beta-acceptatie

Test minimaal met:

- een bekend en een onbekend barcodeproduct;
- alle vier swapdoelen;
- producten met ontbrekende waarden of onbetrouwbare porties;
- mobiel Safari/Chrome en desktop Chrome/Edge;
- opnieuw laden en terugkeren om lokale opslag te controleren;
- allergievoorkeuren, waarbij het fysieke etiket altijd leidend blijft.

Techniek: Flutter, Riverpod, go_router, Drift/SQLite, mobile_scanner en
Supabase met uitsluitend een clientveilige publishable key.
