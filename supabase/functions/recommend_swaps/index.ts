// Supabase Edge Function: recommend_swaps
//
// Geeft swap-aanbevelingen voor een product op basis van:
//   - het product zelf,
//   - het voedingsdoel van de gebruiker,
//   - de dagcontext uit de tracker (resterende kcal/eiwit/suiker).
//
// BELANGRIJK (architectuur): de AI mag bestaande producten/swaps alleen
// RANGSCHIKKEN en UITLEGGEN. Kandidaten komen altijd uit Supabase; de function
// publiceert nooit zelf nieuwe globale data.
//
// Request : { "barcode": "...", "goal": {...}, "day_context": {...} }
// Response: { "recommendations": [ { product, reason, score, highlights, ... } ] }

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const json = (b: unknown, s = 200) =>
  new Response(JSON.stringify(b), {
    status: s,
    headers: { ...cors, "Content-Type": "application/json" },
  });

type Row = Record<string, any>;

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  try {
    const { barcode, goal, day_context } = await req.json();
    if (!barcode) return json({ error: "barcode ontbreekt." }, 400);

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // Bronproduct.
    const { data: source } = await supabase
      .from("products").select("*").eq("barcode", barcode).maybeSingle();
    if (!source) return json({ error: "Bronproduct niet gevonden." }, 404);

    // Kandidaten: 1) expliciete swaps, 2) zelfde categorie.
    const candidates = await gatherCandidates(supabase, source);

    // Allergenen eruit filteren.
    const allergies: string[] = goal?.allergies ?? [];
    const safe = candidates.filter((c) => !violatesAllergy(c, allergies));

    // Scoren op basis van doel + dagcontext.
    let ranked = safe
      .map((c) => scoreCandidate(source, c, goal, day_context))
      .filter((r) => r.score > 0)
      .sort((a, b) => b.score - a.score)
      .slice(0, 8);

    // Optioneel: laat Claude de shortlist herordenen + uitleg verrijken.
    ranked = await maybeRerankWithClaude(source, ranked, goal, day_context);

    return json({ recommendations: ranked.slice(0, 5) });
  } catch (e) {
    return json({ error: `Interne fout: ${e}` }, 500);
  }
});

async function gatherCandidates(supabase: any, source: Row): Promise<Row[]> {
  const map = new Map<string, Row>();

  // 1. Expliciete, gecureerde swaps.
  const { data: swaps } = await supabase
    .from("swaps")
    .select("to_barcode, base_score, rationale, products!swaps_to_barcode_fkey(*)")
    .eq("from_barcode", source.barcode);
  for (const s of swaps ?? []) {
    const p = s.products;
    if (p && p.barcode !== source.barcode) {
      map.set(p.barcode, { ...p, _base: s.base_score ?? 0.5, _rationale: s.rationale });
    }
  }

  // 2. Categorie-kandidaten (zelfde eerste categorie), als aanvulling.
  const firstCat = (source.categories ?? [])[0];
  if (firstCat) {
    const { data: sameCat } = await supabase
      .from("products")
      .select("*")
      .contains("categories", [firstCat])
      .neq("barcode", source.barcode)
      .limit(25);
    for (const p of sameCat ?? []) {
      if (!map.has(p.barcode)) map.set(p.barcode, { ...p, _base: 0.35 });
    }
  }

  return [...map.values()];
}

function violatesAllergy(product: Row, allergies: string[]): boolean {
  if (!allergies.length) return false;
  const hay =
    `${product.name ?? ""} ${(product.categories ?? []).join(" ")}`.toLowerCase();
  const terms: Record<string, string[]> = {
    nuts: ["noten", "nut", "amandel", "hazelnoot"],
    peanuts: ["pinda", "peanut"],
    lactose: ["melk", "milk", "lactose", "zuivel", "cheese", "kaas"],
    gluten: ["tarwe", "wheat", "gluten", "brood"],
    soy: ["soja", "soy"],
    egg: ["ei", "egg"],
    fish: ["vis", "fish", "zalm", "tonijn"],
    shellfish: ["schaal", "shrimp", "garnaal", "shellfish"],
  };
  return allergies.some((a) => (terms[a] ?? []).some((t) => hay.includes(t)));
}

function scoreCandidate(source: Row, cand: Row, goal: Row, day: Row) {
  const sKcal = num(source.kcal), sSugar = num(source.sugar), sProt = num(source.protein);
  const cKcal = num(cand.kcal), cSugar = num(cand.sugar), cProt = num(cand.protein);

  const goalType = goal?.goal_type ?? "maintain";
  let score = num(cand._base, 0.4);
  const highlights: string[] = [];

  // Suiker: bijna altijd beter als het lager is; zwaarder bij lessSugar of
  // wanneer de gebruiker vandaag al over de limiet zit.
  const sugarDelta = cSugar - sSugar;
  if (sSugar > 0 && sugarDelta < 0) {
    const pct = Math.round((-sugarDelta / sSugar) * 100);
    const weight = goalType === "lessSugar" || day?.over_sugar_limit ? 0.5 : 0.3;
    score += weight * Math.min(1, -sugarDelta / (sSugar + 1));
    if (pct >= 10) highlights.push(`-${pct}% suiker`);
  }

  // Eiwit: hoger is beter, sterker bij buildMuscle.
  const protDelta = cProt - sProt;
  if (protDelta > 0) {
    const weight = goalType === "buildMuscle" ? 0.5 : 0.25;
    score += weight * Math.min(1, protDelta / (sProt + 5));
    highlights.push(`+${protDelta.toFixed(0)}g eiwit`);
  }

  // Calorieën: lager is beter bij loseWeight of weinig kcal over vandaag.
  const kcalDelta = cKcal - sKcal;
  if (kcalDelta < 0) {
    const tight = (day?.kcal_remaining ?? 9999) < 300;
    const weight = goalType === "loseWeight" || tight ? 0.4 : 0.2;
    score += weight * Math.min(1, -kcalDelta / (sKcal + 1));
    highlights.push(`${kcalDelta.toFixed(0)} kcal`);
  }

  // Minder bewerkt (lagere NOVA / betere Nutri-Score) is een pluspunt.
  if (num(cand.nova_group) && num(source.nova_group) &&
      num(cand.nova_group) < num(source.nova_group)) {
    score += 0.1;
    highlights.push("minder bewerkt");
  }

  score = Math.max(0, Math.min(1, score));

  const reason = cand._rationale ??
    buildReason(source, cand, { sugarDelta, protDelta, kcalDelta, goalType });

  return {
    product: toClient(cand),
    reason,
    score: round2(score),
    highlights,
    kcal_delta: round1(kcalDelta),
    protein_delta: round1(protDelta),
    sugar_delta: round1(sugarDelta),
  };
}

function buildReason(
  source: Row, cand: Row,
  d: { sugarDelta: number; protDelta: number; kcalDelta: number; goalType: string },
) {
  const parts: string[] = [];
  if (d.sugarDelta < -0.5) parts.push(`minder suiker dan ${source.name}`);
  if (d.protDelta > 0.5) parts.push(`meer eiwit`);
  if (d.kcalDelta < -1) parts.push(`lichter in calorieën`);
  if (!parts.length) parts.push("past goed bij je doel");
  const goalLabel: Record<string, string> = {
    loseWeight: "afvallen",
    buildMuscle: "spieropbouw",
    lessSugar: "minder suiker",
    maintain: "op gewicht blijven",
  };
  return `${cand.name} heeft ${parts.join(", ")} — handig voor je doel ` +
    `“${goalLabel[d.goalType] ?? d.goalType}”.`;
}

// --- Optionele AI-herordening (alleen rangschikken/uitleggen) ---
async function maybeRerankWithClaude(
  source: Row, ranked: any[], goal: Row, day: Row,
): Promise<any[]> {
  const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
  if (!apiKey || ranked.length < 2) return ranked;

  try {
    const items = ranked.map((r, i) => ({
      i,
      name: r.product.name,
      kcal_delta: r.kcal_delta,
      protein_delta: r.protein_delta,
      sugar_delta: r.sugar_delta,
    }));

    const prompt =
      `Je bent een voedingscoach. Herorden UITSLUITEND de gegeven kandidaten ` +
      `(verzin niets nieuws) voor het doel ${goal?.goal_type} met dagcontext ` +
      `${JSON.stringify(day)}. Bronproduct: ${source.name}. ` +
      `Kandidaten: ${JSON.stringify(items)}. ` +
      `Antwoord met JSON: {"order":[indices],"reasons":{"index":"korte NL uitleg"}}.`;

    const res = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: "claude-haiku-4-5-20251001",
        max_tokens: 700,
        messages: [{ role: "user", content: prompt }],
      }),
    });
    if (!res.ok) return ranked;
    const data = await res.json();
    const text = data?.content?.[0]?.text ?? "";
    const parsed = JSON.parse(text.slice(text.indexOf("{"), text.lastIndexOf("}") + 1));

    const order: number[] = parsed.order ?? [];
    const reasons: Record<string, string> = parsed.reasons ?? {};
    const reordered = order
      .filter((i) => ranked[i])
      .map((i) => ({ ...ranked[i], reason: reasons[String(i)] ?? ranked[i].reason }));

    // Vul aan met eventueel weggelaten kandidaten.
    for (let i = 0; i < ranked.length; i++) {
      if (!order.includes(i)) reordered.push(ranked[i]);
    }
    return reordered.length ? reordered : ranked;
  } catch (_) {
    return ranked; // AI faalt? Val stil terug op de heuristiek.
  }
}

// --- helpers ---
const num = (v: unknown, d = 0) =>
  v === null || v === undefined || v === "" ? d : Number(v);
const round1 = (v: number) => Math.round(v * 10) / 10;
const round2 = (v: number) => Math.round(v * 100) / 100;

function toClient(row: Row) {
  return {
    barcode: row.barcode,
    name: row.name,
    brand: row.brand,
    image_url: row.image_url,
    categories: row.categories ?? [],
    nutriments: {
      kcal: num(row.kcal), protein: num(row.protein), sugar: num(row.sugar),
      fat: row.fat, saturated_fat: row.saturated_fat, carbs: row.carbs,
      salt: row.salt, fiber: row.fiber,
    },
    serving_size_grams: row.serving_size_grams,
    nova_group: row.nova_group,
    nutri_score: row.nutri_score,
    source: row.source ?? "supabase",
  };
}
