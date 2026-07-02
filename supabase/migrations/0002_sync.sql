-- Bitewise – optionele sync van persoonlijke logs.
-- Alleen actief wanneer de gebruiker sync inschakelt. Elke rij is strikt
-- afgeschermd tot de eigenaar via RLS (auth.uid()).

create table if not exists public.user_day_logs (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null default auth.uid() references auth.users(id) on delete cascade,
  -- Stabiele client-sleutel ("<installId>:<lokale id>") voor idempotente upsert.
  client_id       text not null,
  barcode         text,
  product_name    text not null,
  meal_type_index int  not null,
  grams           numeric not null,
  kcal            numeric not null,
  protein         numeric not null,
  sugar           numeric not null,
  log_date        date not null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (user_id, client_id)
);

create index if not exists user_day_logs_user_idx
  on public.user_day_logs (user_id, log_date);

alter table public.user_day_logs enable row level security;

drop policy if exists "own logs select" on public.user_day_logs;
create policy "own logs select" on public.user_day_logs
  for select using (auth.uid() = user_id);

drop policy if exists "own logs insert" on public.user_day_logs;
create policy "own logs insert" on public.user_day_logs
  for insert with check (auth.uid() = user_id);

drop policy if exists "own logs update" on public.user_day_logs;
create policy "own logs update" on public.user_day_logs
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own logs delete" on public.user_day_logs;
create policy "own logs delete" on public.user_day_logs
  for delete using (auth.uid() = user_id);

drop trigger if exists user_day_logs_touch on public.user_day_logs;
create trigger user_day_logs_touch
  before update on public.user_day_logs
  for each row execute function public.touch_updated_at();
