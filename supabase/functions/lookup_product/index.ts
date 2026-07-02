// Supabase Edge Function: lookup_product
//
// Zoekt een product op barcode:
//   1. Supabase `products`-tabel.
//   2. Fallback naar Open Food Facts (alleen hier — nooit client-side).
//   3. Upsert het OFF-product in `products` zodat het gedeeld/gecachet is.
//
// Request : { "barcode": "8710398526007" }
// Response: { "product": { ... } }  of  { "error": "..." }

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  try {
    const { barcode } = await req.json();
    if (!barcode || typeof barcode !== "string") {
      return json({ error: "Ongeldige of ontbrekende barcode." }, 400);
    }
    const code = barcode.trim();

    // Service role: mag schrijven, omzeilt RLS.
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // 1. Bestaat het al in Supabase?
    const { data: existing } = await supabase
      .from("products")
      .select("*")
      .eq("barcode", code)
      .maybeSingle();

    if (existing) {
      return json({ product: toClient(existing) });
    }

    // 2. Fallback: Open Food Facts.
    const off = await fetchFromOpenFoodFacts(code);
    if (!off) {
      return json({ error: "Geen product gevonden." }, 404);
    }

    // 3. Upsert zodat het gedeeld beschikbaar wordt.
    const row = { ...off, barcode: code, source: "openfoodfacts" };
    const { data: upserted, error } = await supabase
      .from("products")
      .upsert(row, { onConflict: "barcode" })
      .select("*")
      .single();

    if (error) {
      // Upsert mislukt: geef het OFF-product alsnog terug.
      return json({ product: toClient(row) });
    }
    return json({ product: toClient(upserted) });
  } catch (e) {
    return json({ error: `Interne fout: ${e}` }, 500);
  }
});

// --- Open Food Facts ---
async function fetchFromOpenFoodFacts(barcode: string) {
  const url =
    `https://world.openfoodfacts.org/api/v2/product/${barcode}.json` +
    `?fields=product_name,brands,image_url,categories_tags,nutriments,` +
    `serving_quantity,nova_group,nutriscore_grade`;
  const res = await fetch(url, {
    headers: { "User-Agent": "Bitewise/0.1 (support@bitewise.app)" },
  });
  if (!res.ok) return null;
  const data = await res.json();
  if (data.status !== 1 || !data.product) return null;

  const p = data.product;
  const n = p.nutriments ?? {};
  const num = (v: unknown) =>
    v === undefined || v === null || v === "" ? null : Number(v);

  return {
    name: p.product_name || "Onbekend product",
    brand: (p.brands ?? "").split(",")[0]?.trim() || null,
    image_url: p.image_url ?? null,
    categories: (p.categories_tags ?? [])
      .map((c: string) => c.replace(/^..:/, "")),
    kcal: num(n["energy-kcal_100g"]) ?? 0,
    protein: num(n["proteins_100g"]) ?? 0,
    sugar: num(n["sugars_100g"]) ?? 0,
    fat: num(n["fat_100g"]),
    saturated_fat: num(n["saturated-fat_100g"]),
    carbs: num(n["carbohydrates_100g"]),
    salt: num(n["salt_100g"]),
    fiber: num(n["fiber_100g"]),
    serving_size_grams: num(p.serving_quantity),
    nova_group: num(p.nova_group),
    nutri_score: p.nutriscore_grade ?? null,
  };
}

// Zet een DB-rij om naar het client-formaat (geneste nutriments).
function toClient(row: Record<string, unknown>) {
  return {
    barcode: row.barcode,
    name: row.name,
    brand: row.brand,
    image_url: row.image_url,
    categories: row.categories ?? [],
    nutriments: {
      kcal: row.kcal ?? 0,
      protein: row.protein ?? 0,
      sugar: row.sugar ?? 0,
      fat: row.fat,
      saturated_fat: row.saturated_fat,
      carbs: row.carbs,
      salt: row.salt,
      fiber: row.fiber,
    },
    serving_size_grams: row.serving_size_grams,
    nova_group: row.nova_group,
    nutri_score: row.nutri_score,
    source: row.source ?? "supabase",
  };
}
