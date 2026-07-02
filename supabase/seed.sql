-- Bitewise – seed data
-- Realistische producten + gecureerde swaps zodat SnackSwap meteen gevuld is.
-- Idempotent: veilig meermaals te draaien (upsert / on conflict do nothing).
--
-- Draai na de migratie:  supabase db push  &&  psql < supabase/seed.sql
-- of plak in de Supabase SQL editor.

-- ---------------------------------------------------------------------------
-- Producten (voedingswaarden per 100 g/ml)
-- ---------------------------------------------------------------------------
insert into public.products
  (barcode, name, brand, categories, kcal, protein, sugar, fat, saturated_fat,
   carbs, salt, fiber, serving_size_grams, nova_group, nutri_score, source)
values
  -- Chocolade
  ('8712345000011', 'Melkchocolade reep', 'Classic', array['chocolade'],
   535, 7, 56, 30, 18, 59, 0.24, 2, 25, 4, 'e', 'supabase'),
  ('8712345000028', 'Pure chocolade 85%', 'Noir', array['chocolade'],
   600, 10, 22, 46, 28, 30, 0.03, 11, 25, 3, 'd', 'supabase'),
  ('8712345000035', 'Eiwitreep chocolade', 'FitBite', array['chocolade','eiwitreep'],
   350, 32, 5, 12, 6, 30, 0.5, 8, 45, 4, 'c', 'supabase'),

  -- Chips / hartige snacks
  ('8712345000042', 'Naturel chips', 'Crunch', array['chips'],
   536, 6, 1, 34, 3.4, 50, 1.2, 4, 30, 3, 'd', 'supabase'),
  ('8712345000059', 'Linzenchips paprika', 'GreenBite', array['chips','peulvruchten'],
   450, 15, 3, 18, 2, 52, 1.0, 9, 30, 3, 'c', 'supabase'),
  ('8712345000066', 'Popcorn licht gezouten', 'PopLight', array['chips','popcorn'],
   380, 11, 1, 8, 1.5, 62, 0.9, 13, 20, 2, 'b', 'supabase'),

  -- Yoghurt
  ('8712345000073', 'Fruityoghurt aardbei', 'DagVers', array['yoghurt','zuivel'],
   95, 3, 14, 2.5, 1.6, 15, 0.12, 0, 150, 4, 'c', 'supabase'),
  ('8712345000080', 'Skyr naturel', 'IJsland', array['yoghurt','zuivel','skyr'],
   63, 11, 4, 0.2, 0.1, 4, 0.1, 0, 150, 1, 'a', 'supabase'),
  ('8712345000097', 'Griekse yoghurt 0%', 'Olympus', array['yoghurt','zuivel'],
   57, 10, 4, 0.2, 0.1, 4, 0.1, 0, 150, 1, 'a', 'supabase'),

  -- Frisdrank (per 100 ml)
  ('8712345000103', 'Cola regular', 'FizzCo', array['frisdrank','cola'],
   42, 0, 10.6, 0, 0, 10.6, 0, 0, 250, 4, 'e', 'supabase'),
  ('8712345000110', 'Cola zero', 'FizzCo', array['frisdrank','cola'],
   0.3, 0, 0, 0, 0, 0, 0.02, 0, 250, 4, 'b', 'supabase'),
  ('8712345000127', 'Bruiswater citroen', 'Bron', array['frisdrank','water'],
   0, 0, 0, 0, 0, 0, 0, 0, 250, 1, 'a', 'supabase'),

  -- Koekjes
  ('8712345000134', 'Roomboterkoekjes', 'Bakhuis', array['koekjes'],
   500, 6, 30, 24, 15, 63, 0.5, 2, 15, 4, 'e', 'supabase'),
  ('8712345000141', 'Havermeel koekjes', 'Bakhuis', array['koekjes','haver'],
   440, 8, 18, 16, 4, 62, 0.4, 6, 15, 3, 'c', 'supabase')
on conflict (barcode) do update set
  name = excluded.name,
  brand = excluded.brand,
  categories = excluded.categories,
  kcal = excluded.kcal,
  protein = excluded.protein,
  sugar = excluded.sugar,
  fat = excluded.fat,
  saturated_fat = excluded.saturated_fat,
  carbs = excluded.carbs,
  salt = excluded.salt,
  fiber = excluded.fiber,
  serving_size_grams = excluded.serving_size_grams,
  nova_group = excluded.nova_group,
  nutri_score = excluded.nutri_score;

-- ---------------------------------------------------------------------------
-- Gecureerde swaps (from_barcode -> to_barcode)
-- ---------------------------------------------------------------------------
insert into public.swaps (from_barcode, to_barcode, base_score, rationale) values
  ('8712345000011', '8712345000028', 0.70,
   'Pure chocolade 85% heeft fors minder suiker en een rijkere smaak — een kleiner stukje voldoet.'),
  ('8712345000011', '8712345000035', 0.65,
   'Deze eiwitreep bevat veel meer eiwit en veel minder suiker, dus je blijft langer verzadigd.'),

  ('8712345000042', '8712345000059', 0.70,
   'Linzenchips leveren meer eiwit en vezels met minder vet dan gewone chips.'),
  ('8712345000042', '8712345000066', 0.65,
   'Popcorn is luchtig: meer volume voor minder calorieën en vet.'),

  ('8712345000073', '8712345000080', 0.78,
   'Skyr bevat veel minder suiker en flink meer eiwit — ideaal als romige snack.'),
  ('8712345000073', '8712345000097', 0.62,
   'Griekse yoghurt 0% is romig met minder suiker; voeg zelf vers fruit toe.'),

  ('8712345000103', '8712345000110', 0.72,
   'Cola zero geeft dezelfde smaak zonder suiker en calorieën.'),
  ('8712345000103', '8712345000127', 0.60,
   'Bruiswater met citroen is suikervrij en verfrissend voor tussendoor.'),

  ('8712345000134', '8712345000141', 0.60,
   'Havermeel koekjes bevatten minder suiker en meer vezels en eiwit.')
on conflict (from_barcode, to_barcode) do update set
  base_score = excluded.base_score,
  rationale = excluded.rationale;
