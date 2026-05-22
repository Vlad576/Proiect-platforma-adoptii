/**
 *
 * Scenarii:
 *   3.1 — Căutare semantică după descriere liberă a plot-ului
 *   3.2 — Recomandare "mai multe ca acesta" (top 10)
 *   3.3 — Căutare hibridă: vector search + filtru pe metadata
 *   3.4 — Clustering semantic: matrice de similaritate cosinus
 *
 * Setup:
 *   npm install mongodb openai
 *
 * Variabile de mediu necesare (sau setează direct valorile de mai jos):
 *   MONGO_URI     — connection string Atlas (include /sample_mflix dacă vrei)
 *   OPENAI_API_KEY — cheia API OpenAI
 *
 * Index Atlas Vector Search necesar pe colecția embedded_movies:
 *   Câmp:       plot_embedding
 *   Dimensiuni: 1536
 *   Similaritate: cosine
 *   Nume index: "PlotSemanticIndex"   (sau actualizează INDEX_NAME de mai jos)
 *
 * Rulare:
 *   node embeddings_demo.js
 *   (Dacă "type":"module" în package.json sau fișierul se numește .mjs)
 *   Alternativ CommonJS: se înlocuiește import cu require.
 */

import { MongoClient } from "mongodb";
import OpenAI from "openai";

// ── Configurare ───────────────────────────────────────────────────────────────

const MONGO_URI =
  process.env.MONGO_URI ??
  "mongodb+srv://<user>:<parola>@<cluster>.mongodb.net/";

const OPENAI_API_KEY = process.env.OPENAI_API_KEY ?? "<openai-api-key>";

const DB_NAME        = "sample_mflix";
const COLL_NAME      = "embedded_movies";
const INDEX_NAME     = "PlotSemanticIndex";   // numele indexului Vector Search

const openai = new OpenAI({ apiKey: OPENAI_API_KEY });

// ── Helpers ───────────────────────────────────────────────────────────────────

/**
 * Apelează OpenAI Embeddings API și returnează vectorul de 1536 dimensiuni
 * pentru textul dat, folosind modelul text-embedding-ada-002.
 */
async function generateEmbedding(text) {
  const response = await openai.embeddings.create({
    model: "text-embedding-ada-002",
    input: text.trim(),
  });
  return response.data[0].embedding;   // array de 1536 float-uri
}


function printSeparator(title) {
  const line = "─".repeat(62);
  console.log(`\n${line}`);
  console.log(` ${title}`);
  console.log(line);
}

// ── Scenariu 3.1 — Căutare semantică după plot ────────────────────────────────

/**
 * Generează un embedding pentru queryText și caută filme cu plot-ul
 * semantic cel mai apropiat în spațiul vectorial.
 *
 * @param {Collection} collection
 * @param {string}     queryText  — descriere liberă în orice limbă
 * @param {number}     limit      — număr de rezultate returnate
 */
async function scenario31_semanticSearch(collection, queryText, limit = 5) {
  printSeparator(`3.1  Căutare semantică`);
  console.log(`\n  Query: "${queryText}"\n`);

  const queryVector = await generateEmbedding(queryText);

  const results = await collection
    .aggregate([
      {
        $vectorSearch: {
          index: INDEX_NAME,
          path: "plot_embedding",
          queryVector,
          numCandidates: 150,
          limit,
        },
      },
      {
        $project: {
          _id: 0,
          title: 1,
          year: 1,
          genres: 1,
          plot: 1,
          score: { $meta: "vectorSearchScore" },
        },
      },
    ])
    .toArray();

  results.forEach((movie, i) => {
    const genres = (movie.genres ?? []).join(", ") || "—";
    const plot   = (movie.plot ?? "").substring(0, 110);
    console.log(`  ${i + 1}. [${movie.score.toFixed(4)}]  ${movie.title} (${movie.year})`);
    console.log(`     Genuri : ${genres}`);
    console.log(`     Plot   : ${plot}…\n`);
  });
}

// ── Scenariu 3.2 — Recomandare "mai multe ca acesta" (top 10) ─────────────────

/**
 * Preia embedding-ul existent al unui film din colecție (fără apel API),
 * apoi returnează top-10 filme cu plot-ul cel mai similar.
 *
 * @param {Collection} collection
 * @param {string}     movieTitle — titlul exact din colecție
 * @param {number}     limit      — implicit 10
 */
async function scenario32_moreLikeThis(collection, movieTitle, limit = 10) {
  printSeparator(`3.2  Mai multe ca: "${movieTitle}"`);

  const source = await collection.findOne(
    { title: movieTitle },
    { projection: { _id: 1, title: 1, year: 1, genres: 1, plot: 1, plot_embedding: 1 } }
  );

  if (!source?.plot_embedding) {
    console.log(`\n  ✗ Film negăsit sau fără embedding: "${movieTitle}"`);
    return;
  }

  console.log(`\n  Film sursă : ${source.title} (${source.year})`);
  console.log(`  Genuri     : ${(source.genres ?? []).join(", ")}`);
  console.log(`  Plot       : ${(source.plot ?? "").substring(0, 110)}…`);
  console.log(`\n  ${"#".padEnd(3)} ${"Scor".padEnd(8)} ${"Titlu".padEnd(36)} ${"An".padEnd(6)} Genuri`);
  console.log(`  ${"─".repeat(72)}`);

  const results = await collection
    .aggregate([
      {
        $vectorSearch: {
          index: INDEX_NAME,
          path: "plot_embedding",
          queryVector: source.plot_embedding,
          numCandidates: 200,
          limit: limit + 1,   // +1 deoarece filmul sursă apare în rezultate
        },
      },
      { $match: { _id: { $ne: source._id } } },   // excludem filmul sursă
      { $limit: limit },
      {
        $project: {
          _id: 0,
          title: 1,
          year: 1,
          genres: 1,
          score: { $meta: "vectorSearchScore" },
        },
      },
    ])
    .toArray();

  results.forEach((movie, i) => {
    const rank   = String(i + 1).padStart(2);
    const score  = movie.score.toFixed(4).padEnd(8);
    const title  = movie.title.substring(0, 34).padEnd(36);
    const year   = String(movie.year ?? "—").padEnd(6);
    const genres = (movie.genres ?? []).join(", ");
    console.log(`  ${rank}. ${score} ${title} ${year} ${genres}`);
  });
}

// ── Scenariu 3.3 — Căutare hibridă: vector + filtru metadata ─────────────────

/**
 * Combină căutarea semantică cu filtre pe metadata (gen, interval de ani).
 *
 * Strategie: post-filter cu $match după $vectorSearch.
 * Aceasta funcționează cu orice index Vector Search, fără configurare suplimentară.
 *
 * ALTERNATIVĂ (mai precisă, necesită câmpuri de filtru în index):
 *   Adaugă { filter: mongoFilter } direct în $vectorSearch și mărește numCandidates.
 *   Documentație: https://www.mongodb.com/docs/atlas/atlas-vector-search/vector-search-stage/
 *
 * @param {Collection} collection
 * @param {string}     queryText    — descriere liberă a plot-ului căutat
 * @param {object}     mongoFilter  — filtru MongoDB standard pe alte câmpuri
 * @param {number}     limit        — număr de rezultate dorite după filtrare
 */
async function scenario33_hybridSearch(collection, queryText, mongoFilter = {}, limit = 5) {
  const filterDesc = Object.keys(mongoFilter).length > 0
    ? JSON.stringify(mongoFilter)
    : "fără filtru";
  printSeparator(`3.3  Căutare hibridă`);
  console.log(`\n  Query  : "${queryText}"`);
  console.log(`  Filtru : ${filterDesc}\n`);

  const queryVector = await generateEmbedding(queryText);

  // Solicităm mai mulți candidați (numCandidates ridicat) pentru a compensa
  // faptul că post-filter-ul va reduce rezultatele.
  const candidateMultiplier = Object.keys(mongoFilter).length > 0 ? 10 : 3;

  const results = await collection
    .aggregate([
      {
        $vectorSearch: {
          index: INDEX_NAME,
          path: "plot_embedding",
          queryVector,
          numCandidates: limit * candidateMultiplier,
          limit: limit * candidateMultiplier,
        },
      },
      ...(Object.keys(mongoFilter).length > 0 ? [{ $match: mongoFilter }] : []),
      { $limit: limit },
      {
        $project: {
          _id: 0,
          title: 1,
          year: 1,
          genres: 1,
          plot: 1,
          score: { $meta: "vectorSearchScore" },
        },
      },
    ])
    .toArray();

  if (results.length === 0) {
    console.log("  Niciun rezultat. Încearcă un filtru mai puțin restrictiv.");
    return;
  }

  results.forEach((movie, i) => {
    const genres = (movie.genres ?? []).join(", ") || "—";
    const plot   = (movie.plot ?? "").substring(0, 110);
    console.log(`  ${i + 1}. [${movie.score.toFixed(4)}]  ${movie.title} (${movie.year})`);
    console.log(`     Genuri : ${genres}`);
    console.log(`     Plot   : ${plot}…\n`);
  });
}

// ── Scenariu 3.4 — Clustering semantic ───────────────────────────────────────

/**
 * Preia embedding-urile existente pentru o listă de filme și calculează
 * matricea de similaritate cosinus pereche.
 * Nu necesită apeluri la OpenAI — folosește vectorii precalculați din colecție.
 *
 * @param {Collection} collection
 * @param {string[]}   titles — titlurile filmelor de comparat
 */
async function scenario34_semanticClustering(collection, titles) {
  printSeparator("3.4  Clustering semantic: matrice de similaritate cosinus");

  // Pasul 1: preia embedding-urile sursă (o singură interogare)
  const sources = await collection
    .find(
      { title: { $in: titles }, plot_embedding: { $exists: true } },
      { projection: { title: 1, year: 1, genres: 1, plot_embedding: 1 } }
    )
    .toArray();

  if (sources.length < 2) {
    console.log("\n  Filme insuficiente găsite. Verifică titlurile în colecție.");
    return;
  }

  sources.sort((a, b) => titles.indexOf(a.title) - titles.indexOf(b.title));

  console.log(`\n  ${sources.length} filme găsite:\n`);
  sources.forEach((m, i) => {
    console.log(`  ${i + 1}. ${m.title} (${m.year}) — ${(m.genres ?? []).join(", ")}`);
  });

  // Pasul 2: pentru fiecare film sursă, rulează $vectorSearch cu embedding-ul său
  // și restrânge rezultatele doar la filmele din lista noastră.
  // vectorSearchScore reprezintă similaritatea cosinus față de filmul sursă.
  const foundTitles = sources.map((m) => m.title);

  const simMatrix = {};   // simMatrix[titleA][titleB] = scor

  for (const source of sources) {
    const neighbors = await collection
      .aggregate([
        {
          $vectorSearch: {
            index: INDEX_NAME,
            path: "plot_embedding",
            queryVector: source.plot_embedding,
            numCandidates: 300,
            limit: sources.length,
            filter: { title: { $in: foundTitles } },
          },
        },
        {
          $project: {
            _id: 0,
            title: 1,
            score: { $meta: "vectorSearchScore" },
          },
        },
      ])
      .toArray();

    simMatrix[source.title] = {};

    // Filmul față de el însuși este întotdeauna 1.000
    simMatrix[source.title][source.title] = 1.0;

    for (const neighbor of neighbors) {
      if (neighbor.title !== source.title) {
        simMatrix[source.title][neighbor.title] = neighbor.score;
      }
    }

    // Fallback: dacă un film din listă nu a apărut în rezultate, marcăm N/A
    for (const t of foundTitles) {
      simMatrix[source.title][t] ??= null;
    }
  }

  // ── Afișare matrice ──
  const COL_W = 9;
  const labels = sources.map((m) => m.title.substring(0, COL_W - 1).padEnd(COL_W));

  console.log("\n  Matrice de similaritate cosinus (1.000 = identic, 0 = ortogonal):\n");
  console.log("  " + " ".repeat(28) + labels.join(" "));

  for (const rowMovie of sources) {
    const rowLabel = rowMovie.title.substring(0, 26).padEnd(28);
    const cells = sources.map((colMovie) => {
      const val = simMatrix[rowMovie.title][colMovie.title];
      if (val === null) return "  N/A   ";
      return ` ${val.toFixed(3)}   `;
    });
    console.log("  " + rowLabel + cells.join(""));
  }

  // ── Cel mai apropiat vecin ──
  console.log("\n\n  Cel mai apropiat vecin semantic:\n");

  for (const source of sources) {
    const best = sources
      .filter((m) => m.title !== source.title)
      .map((m) => ({ title: m.title, sim: simMatrix[source.title][m.title] ?? 0 }))
      .sort((a, b) => b.sim - a.sim)[0];

    console.log(
      `  ${source.title.padEnd(30)}  →  ${best.title.padEnd(26)} (${best.sim.toFixed(4)})`
    );
  }

}

// ── Main ──────────────────────────────────────────────────────────────────────

async function main() {
  console.log(`  OpenAI API Key: ${OPENAI_API_KEY}`);
  console.log(`  MongoDB URI: ${MONGO_URI}\n`);
  const client = new MongoClient(MONGO_URI);

  try {
    await client.connect();
    console.log("✓ Conectat la MongoDB Atlas\n");
    
    const collection = client.db(DB_NAME).collection(COLL_NAME);

    // ── 3.1 — Căutare semantică ──────────────────────────────────────────────
    await scenario31_semanticSearch(
      collection,
      "Robot teachers have been silently placed in institutions.",
      5
    );

    // ── 3.2 — Recomandare top 10 ─────────────────────────────────────────────
    await scenario32_moreLikeThis(collection, "The Matrix", 10);

    // ── 3.3 — Căutare hibridă ────────────────────────────────────────────────
    // Exemplu 1: gen + deceniu
    await scenario33_hybridSearch(
      collection,
      "A hero discovers hidden powers and fights evil",
      { genres: "Action", year: { $gte: 1990, $lte: 1999 } },
      5
    );

    // Exemplu 2: gen + director (decomentează pentru a testa)
    // await scenario33_hybridSearch(
    //   collection,
    //   "family adventure with talking animals",
    //   { genres: "Animation", year: { $gte: 1995 } },
    //   5
    // );

    // ── 3.4 — Clustering semantic ────────────────────────────────────────────
    // Alege filme din colecția embedded_movies — titlurile trebuie să fie exacte.
    // Verifică disponibilitatea cu:
    //   db.embedded_movies.find({ title: /Matrix/ }, { title: 1 })
    await scenario34_semanticClustering(collection, [
      "The Matrix",
      "Inception",
      "The Twelve Tasks of Asterix",
      "Ice Age: Dawn of the Dinosaurs",
      "The Adventures of Robin Hood",
      "King Solomon's Mines",
      "Knights of the Round Table",
      "Ice Age: The Meltdown"
    ]);

  } catch (err) {
    console.error("\n✗ Eroare:", err.message);
    if (err.codeName === "Unauthorized") {
      console.error("  → Verifică OPENAI_API_KEY sau MONGO_URI");
    }
    if (err.message?.includes("$vectorSearch")) {
      console.error(`  → Verifică că există un index Vector Search numit "${INDEX_NAME}"`);
      console.error("    pe câmpul plot_embedding al colecției embedded_movies.");
    }
  } finally {
    await client.close();
    console.log("✓ Conexiune MongoDB închisă");
  }
}

main();