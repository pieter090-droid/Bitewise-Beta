-- Bitewise – Supabase schema
-- Producten en swaps zijn GEDEELDE, globale data. Persoonlijke logs blijven
-- lokaal op het toestel (Drift) tenzij de gebruiker sync inschakelt.

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- products: canonieke productdata (bron: Supabase + Open Food Facts upserts).
-- ---------------------------------------------------------------------------
create table if not exists public.products (
  barcode            text primary key,
  name               text not null,
  brand              text,
  image_url          text,
  categories         text[] not null default '{}',
  -- Voedingswaarden per 100 g/ml.
  kcal               numeric not null default 0,
  protein            numeric not null default 0,
  sugar              numeric not null default 0,
  fat                numeric,
  saturated_fat      numeric,
  carbs              numeric,
  salt               numeric,
  fiber              numeric,
  serving_size_grams numeric,
  nova_group         int,
  nutri_score        text,
  source             text not null default 'supabase',  -- supabase | openfoodfacts
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

create index if not exists products_categories_idx
  on public.products using gin (categories);

-- ---------------------------------------------------------------------------
-- swaps: expliciete "beter alternatief"-relaties tussen producten.
-- from_barcode -> to_barcode. AI mag deze alleen rangschikken/uitleggen.
-- ---------------------------------------------------------------------------
create table if not exists public.swaps (
  id           uuid primary key default gen_random_uuid(),
  from_barcode text not null references public.products(barcode) on delete cascade,
  to_barcode   text not null references public.products(barcode) on delete cascade,
  -- Optionele redenering/curatie.
  rationale    text,
  base_score   numeric not null default 0.5,  -- 0..1
  created_at   timestamptz not null default now(),
  unique (from_barcode, to_barcode)
);

create index if not exists swaps_from_idx on public.swaps (from_barcode);

-- ---------------------------------------------------------------------------
-- Row Level Security
-- Iedereen (anon) mag lezen. Alleen de service role (Edge Functions) schrijft.
-- Zo kan een client nooit zelf globale data publiceren.
-- ---------------------------------------------------------------------------
alter table public.products enable row level security;
alter table public.swaps    enable row level security;

drop policy if exists "products readable by anyone" on public.products;
create policy "products readable by anyone"
  on public.products for select
  using (true);

drop policy if exists "swaps readable by anyone" on public.swaps;
create policy "swaps readable by anyone"
  on public.swaps for select
  using (true);

-- (Geen insert/update/delete policies voor anon: alleen service_role schrijft,
--  en die omzeilt RLS.)

-- Houd updated_at bij.
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists products_touch on public.products;
create trigger products_touch
  before update on public.products
  for each row execute function public.touch_updated_at();
