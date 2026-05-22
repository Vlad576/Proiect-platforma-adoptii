# Introducere în Vector Embeddings cu MongoDB sample_mflix

---

## Tokenizare

### Ce este tokenizarea?

Primul pas al transformării de la text la vector numeric este **tokenizarea**: procesul prin care un șir de caractere este segmentat în unități mai mici numite **tokeni**, cărora li se atribuie un identificator numeric unic (token ID).

În funcție de algoritmul folosit, un token poate reprezenta:

- **un cuvânt** întreg: `"film"` → `[1 token]`
- **o parte** dintr-un cuvânt: `"cinematografie"` → `["cinema", "tografie"]` → `[2 tokeni]`
- **un semn** de punctuație sau un spațiu: `"."`, `" "`
- **un caracter individual**, în cazuri extreme

De exemplu, propoziția:

```
"Robot teachers have been secretly placed in schools."
```

poate fi tokenizată astfel (tiktoken, modelul `text-embedding-ada-002`):

```
["Robot", " teachers", " have", " been", " secretly", " placed", " in", " schools", "."]
→ [44474,   13639,      617,    1027,    42839,      9277,      304,   8853,        13]
```

> **Relevanța pentru embeddings**  
> Modelele de tip transformer — inclusiv cele care generează embeddings — nu operează pe caractere sau cuvinte brute, ci pe secvențe de token ID-uri. Calitatea și dimensiunea vocabularului tokenizorului influențează direct eficiența și precizia reprezentărilor vectoriale.

---

### Tokenizoare folosite de principalii furnizori

| Furnizor | Model reprezentativ | Tokenizor | Algoritm | Dimensiune vocabular | Observații |
|---|---|---|---|---|---|
| **OpenAI** `cl100k_base`| `text-embedding-ada-002` `text-embedding-3-small` `text-embedding-3-large`, GPT-4 | `tiktoken` | BPE (Byte Pair Encoding) | ~100k tokeni  | Open-source; disponibil în Python și JS; |
 **OpenAI** `o200k_base`| GPT-4o|`tiktoken`| BPE (Byte Pair Encoding) | ~200k tokeni | Open-source; disponibil în Python și JS;
| **Anthropic (Claude)** | Claude 3 / 3.5 / 3.7 | Tokenizor intern (nepublicat) | BPE extins | ~100k tokeni (estimat) | Accesibil indirect prin API (`/v1/messages`, câmpul `usage.input_tokens`); nu există o bibliotecă standalone oficială |
| **Google (Gemini)** | Gemini 1.5 / 2.0 | `SentencePiece` (intern) | Unigram LM / BPE | ~256k tokeni | Expus prin `countTokens` în Gemini API; vocabular mai mare → tokenizare mai eficientă pe limbi ne-latine |

> **BPE (Byte Pair Encoding)**: algoritmul pornește de la caractere individuale și îmbină iterativ cele mai frecvente perechi, construind un vocabular de sub-cuvinte. Rezultatul este un echilibru între vocabulare mari (câte un token per cuvânt) și vocabulare mici (câte un token per caracter).

#### Fuzionarea sub-cuvintelor prin BPE

În loc să trateze cuvintele ca unități indivizibile, această abordare construiește iterativ un vocabular de sub-cuvinte prin identificarea și fuzionarea celor mai frecvente secvențe adiacente de caractere. Procesul de fuzionare de tip *greedy* permite cuvintelor frecvente să rămână intacte sub forma unui token unic, în timp ce cuvintele rare sau complexe sunt segmentate în mod controlat în unități mai mici, recognoscibile ca sub-cuvinte.

*Exemplu*: fie un corpus mic care conține următoarele cuvinte cu frecvențele lor de apariție:

```
("joc", 10), ("juca", 8), ("joacă", 6), ("jucat", 5)
```

ceea ce înseamnă că `"joc"` apare de 10 ori în corpus, `"juca"` de 8 ori, `"joacă"` de 6 ori, iar `"jucat"` de 5 ori. Vocabularul inițial este constituit din toate caracterele distincte întâlnite:

```
Vocabular inițial: ["a", "c", "j", "o", "t", "u", "ă"]
```

Fiecare cuvânt este descompus în caracterele sale componente, frecvența cuvântului rămânând asociată grupului de tokeni rezultat:

```
("j" "o" "c", 10),  ("j" "u" "c" "a", 8),
("j" "o" "a" "c" "ă", 6),  ("j" "u" "c" "a" "t", 5)
```

**Iterația 1.** Algoritmul parcurge întregul corpus și sumează frecvențele fiecărei perechi de tokeni adiacenți:

```
(j, o)  →  "joc"(10)  + "joacă"(6)           = 16  ← cea mai frecventă
(j, u)  →  "juca"(8)  + "jucat"(5)           = 13
(u, c)  →  "juca"(8)  + "jucat"(5)           = 13
(c, a)  →  "juca"(8)  + "jucat"(5)           = 13
(o, c)  →  "joc"(10)                         = 10
(o, a)  →  "joacă"(6)                         =  6
(a, c)  →  "joacă"(6)                         =  6
(c, ă)  →  "joacă"(6)                         =  6
(a, t)  →  "jucat"(5)                         =  5
```

Perechea `(j, o)` este cea mai frecventă (16 apariții) și devine prima regulă de fuzionare: `(j, o) → "jo"`. Vocabularul și reprezentarea corpusului sunt actualizate:

```
Vocabular:  ["a", "c", "j", "jo", "o", "t", "u", "ă"]

Corpus:     ("jo" "c", 10),  ("j" "u" "c" "a", 8),
            ("jo" "a" "c" "ă", 6),  ("j" "u" "c" "a" "t", 5)
```

**Iterația 2.** Frecvențele perechilor sunt recalculate pe corpusul actualizat:

```
(j, u)   →  "juca"(8)  + "jucat"(5)  = 13  ← cea mai frecventă *
(u, c)   →  "juca"(8)  + "jucat"(5)  = 13  ← egalitate
(c, a)   →  "juca"(8)  + "jucat"(5)  = 13  ← egalitate
(jo, c)  →  "joc"(10)                = 10
(jo, a)  →  "joacă"(6)               =  6
(a, c)   →  "joacă"(6)               =  6
(c, ă)   →  "joacă"(6)               =  6
(a, t)   →  "jucat"(5)               =  5
```

> \* În cazul unei egalități, se selectează prima pereche identificată în parcurgerea corpusului.

Regula a doua de fuzionare: `(j, u) → "ju"`.

```
Vocabular:  ["a", "c", "j", "jo", "ju", "o", "t", "u", "ă"]

Corpus:     ("jo" "c", 10),  ("ju" "c" "a", 8),
            ("jo" "a" "c" "ă", 6),  ("ju" "c" "a" "t", 5)
```

**Iterația 3.** Perechile `(ju, c)` și `(c, a)` sunt ambele la 13 apariții; `(ju, c)` este selectată ca primă identificată:

```
(ju, c)  →  "juca"(8) + "jucat"(5)   = 13  ← selectată
(c, a)   →  "juca"(8) + "jucat"(5)   = 13  ← egalitate
(jo, c)  →  "joc"(10)                = 10
(jo, a)  →  "joacă"(6)               =  6
...
```

Regula a treia: `(ju, c) → "juc"`.

```
Vocabular:  ["a", "c", "j", "jo", "ju", "juc", "o", "t", "u", "ă"]

Corpus:     ("jo" "c", 10),  ("juc" "a", 8),
            ("jo" "a" "c" "ă", 6),  ("juc" "a" "t", 5)
```

Procesul continuă în același mod: la iterația 4, perechea `(juc, a)` cu 13 apariții produce tokenul `"juca"`; la iterația 5, perechea `(jo, c)` cu 10 apariții produce tokenul `"joc"`. La finalul antrenamentului, cuvintele frecvente `"joc"` și `"juca"` sunt reprezentate fiecare printr-un token unic, în timp ce `"joacă"` — mai rar și mai complex — rămâne segmentat în sub-unități: `["jo", "a", "c", "ă"]`.

#### Fallback la nivel de octet prin BBPE

**BPE la nivel de octet** (*Byte-Level BPE*, BBPE) definește vocabularul de bază utilizând cele 256 de valori posibile de octet ale codificării UTF-8. Atunci când modelul întâlnește un caracter pe care nu îl recunoaște ca token unitar, algoritmul recurge în mod nativ la tokenizarea octeților săi bruti individuali (Wang et al., 2019). Acest mecanism elimină în totalitate problema *Out-of-Vocabulary* (OOV), permițând tokenizatoarelor moderne — precum `cl100k_base` și `o200k_base` de la OpenAI — să proceseze orice șir de caractere arbitrar.

*Exemplu*: caracterul românesc `"ș"` (U+0219) nu este prezent în vocabularele tokenizatoarelor antrenate exclusiv pe text latin de bază. În codificarea UTF-8, acesta este reprezentat prin doi octeți: `0xC8` (200) și `0x99` (153). Un tokenizor BBPE va descompune automat `"ș"` în acești doi octeți, fără a genera o eroare de tip *unknown token*:

```
"ș"   →  octeți UTF-8: [0xC8, 0x99]
      →  tokeni BBPE:  [<0xC8>, <0x99>]

"🎬"  →  octeți UTF-8: [0xF0, 0x9F, 0x8E, 0xAC]
      →  tokeni BBPE:  [<0xF0>, <0x9F>, <0x8E>, <0xAC>]
```

Astfel, indiferent de limba sau simbolurile din textul de intrare, tokenizatorul poate reprezenta orice caracter printr-o secvență de cel mult 4 tokeni de octet.

#### Referințe

- Wang, Changhan, Kyunghyun Cho și Jiatao Gu. „Neural machine translation with byte-level subwords." *Proceedings of the AAAI Conference on Artificial Intelligence*. Vol. 34, Nr. 05. 2020.


- [BPE examples](https://huggingface.co/learn/llm-course/chapter6/5)

---

### Exemplu practic — `tiktoken` în JavaScript

Biblioteca [`tiktoken`](https://www.npmjs.com/package/tiktoken) este suportul oficial OpenAI pentru numărarea și inspecția tokenilor.

#### Instalare

```bash
npm install tiktoken
```

#### Cod

```javascript
import { encoding_for_model } from "tiktoken";

const text = "Robot teachers have been secretly placed in schools.";

// Inițializează encodingul specific modelului text-embedding-ada-002
const enc = encoding_for_model("text-embedding-ada-002");

// Tokenizează textul → array de token ID-uri (Uint32Array)
const tokenIds = enc.encode(text);

// Decodează fiecare token ID înapoi în șirul de bytes corespunzător
const tokens = Array.from(tokenIds).map((id) => {
  const bytes = enc.decode(new Uint32Array([id]));
  return new TextDecoder().decode(bytes);
});

console.log("Text original:    ", text);
console.log("Număr de tokeni:  ", tokenIds.length);
console.log("Token IDs:        ", Array.from(tokenIds));
console.log("Tokeni (text):    ", tokens);

// Eliberează memoria alocată de WebAssembly
enc.free();
```

#### Output așteptat

```
Text original:     Robot teachers have been secretly placed in schools.
Număr de tokeni:   9
Token IDs:         [44474, 13639, 617, 1027, 42839, 9277, 304, 8853, 13]
Tokeni (text):     ['Robot', ' teachers', ' have', ' been', ' secretly', ' placed', ' in', ' schools', '.']
```

> **Observație**: spațiile fac parte din token (`" teachers"`, nu `"teachers"`). Aceasta este o caracteristică a encodingului BPE folosit de OpenAI — spațiul prefix este inclus în token pentru a reduce ambiguitățile la granițele dintre cuvinte.

---

### De reținut

- Tokenizarea este **dependentă de model** — același text produce token ID-uri diferite cu tokenizoare diferite.
- Numărul de tokeni dintr-un text determină **costul unui apel API** și dacă textul se încadrează în fereastra de context a modelului.
- Pentru modelul `text-embedding-ada-002`, limita maximă de input este **8 191 de tokeni**. Textele mai lungi trebuie tăiate sau împărțite înainte de a genera embeddings.

---

---

## De la tokeni la embeddings

După tokenizare, fiecare token ID este convertit într-un vector dens prin intermediul unei **matrici de embedding de intrare** antrenate odată cu modelul. Fiecărui ID îi corespunde un rând unic în această matrice. Modelul adaugă, de asemenea, un **embedding pozițional** care codifică poziția tokenului în secvență — mecanismul de attention este prin natură invariant la ordine, deci poziția trebuie injectată explicit.

---

### Self-Attention

**Self-attention** este mecanismul prin care fiecare token își actualizează reprezentarea ținând cont de toți ceilalți tokeni din secvență. Intuiția fundamentală: sensul unui cuvânt depinde de contextul în care apare.

Pentru fiecare token $i$, modelul derivă trei vectori din reprezentarea sa curentă:

- $\mathbf{q}_i$ — **query**: ce informație caută tokenul $i$?
- $\mathbf{k}_j$ — **key**: ce informație oferă tokenul $j$?
- $\mathbf{v}_j$ — **value**: conținutul efectiv transmis de tokenul $j$

Scorul de atenție între tokenul $i$ și tokenul $j$ este calculat ca produs scalar scalat:

$$a_{ij} = \frac{\mathbf{q}_i \cdot \mathbf{k}_j}{\sqrt{d_k}}$$

unde $d_k$ este dimensiunea vectorilor query/key (factorul $\sqrt{d_k}$ previne valori prea mari care ar destabiliza softmax-ul). Scorurile sunt normalizate cu **softmax** → ponderi $\hat{a}_{ij} \in [0,1]$, suma pe $j$ egală cu 1.

Reprezentarea actualizată a tokenului $i$ este suma ponderată a vectorilor value:

$$\mathbf{z}_i = \sum_j \hat{a}_{ij} \cdot \mathbf{v}_j$$

*Exemplu*: în propoziția `"Robot teachers have been secretly placed in schools."`, tokenul `" secretly"` va obține ponderi de atenție ridicate față de `" placed"` (verbul pe care îl modifică) și mai reduse față de `"Robot"` (subiectul îndepărtat semantic). Rezultatul este un vector $\mathbf{z}$ pentru `" secretly"` care înglobează această relație contextuală.

---

### Pooling

După ce toate straturile transformer procesează secvența, fiecare dintre cei $n$ tokeni deține un vector dens $\mathbf{z}_i$ care încorporează contextul întregii propoziții. Pentru a obține **un singur vector** reprezentativ pentru întregul text — necesar în căutarea semantică, clasificare sau indexare — se aplică o operație de **pooling**.

Principalele strategii:

| Strategie | Descriere | Utilizare tipică |
|---|---|---|
| **Mean pooling** | Media aritmetică a vectorilor tuturor tokenilor | `text-embedding-3-*` (OpenAI), `all-MiniLM` (sentence-transformers) |
| **Max pooling** | Valoarea maximă pe fiecare dimensiune a vectorilor | Modele clasice; rar utilizat în transformere moderne |

*Exemplu*: pentru textul `"Robot teachers have been secretly placed in schools."` cu $n = 9$ tokeni, mean pooling calculează:

$$\mathbf{e}_{\text{text}} = \frac{1}{9} \sum_{i=1}^{9} \mathbf{z}_i$$

Vectorul rezultat $\mathbf{e}_{\text{text}} \in \mathbb{R}^{1536}$ (pentru `text-embedding-3-small`) reprezintă semnificația semantică a întregii propoziții într-un spațiu în care textele similare sunt apropiate ca distanță.

#### Referințe

- Vaswani, Ashish, et al. „Attention is all you need." *Advances in Neural Information Processing Systems* 30 (2017).

- Lin, Zhouhan, et al. „A structured self-attentive sentence embedding." *arXiv preprint* arXiv:1703.03130 (2017).

---

### De reținut

- **Self-attention** permite fiecărui token să își actualizeze reprezentarea în funcție de întregul context — acesta este mecanismul prin care modelul înțelege sensul.
- **Pooling-ul** condensează secvența de vectori per-token într-un singur vector per-document, utilizabil direct în operații de similaritate.
- Alegerea strategiei de pooling influențează calitatea embeddingurilor — modelele moderne preferă **mean pooling** deoarece preservă contribuția uniformă a tuturor tokenilor.

---

## Aplicații — `embeddings_demo.js`

Scriptul `embeddings_demo.js` conectează conceptele prezentate anterior la colecția `embedded_movies` din dataset-ul MongoDB `sample_mflix`. Fiecare document din colecție conține câmpul `plot_embedding` — un vector de 1 536 dimensiuni generat cu modelul `text-embedding-ada-002` — care permite patru tipuri de interogări semantice.

### Scenariile implementate

**Scenariul 3.1 — Căutare semantică după descriere liberă**  
Primește un text liber (ex: `"Robot teachers have been secretly placed in institutions."`), generează embedding-ul său prin API-ul OpenAI, apoi execută un `$vectorSearch` în Atlas pentru a returna filmele cu plot-ul semantic cel mai apropiat. Scorul de similaritate cosinus este afișat pentru fiecare rezultat.

**Scenariul 3.2 — Recomandare „mai multe ca acesta"**  
Preia embedding-ul *precalculat* al unui film din colecție (fără apel suplimentar la API), îl folosește direct ca vector de interogare și returnează top-10 filme cu plot-ul cel mai similar, excluzând filmul sursă din rezultate.

**Scenariul 3.3 — Căutare hibridă: vector search + filtru pe metadata**  
Combină căutarea semantică cu filtre MongoDB standard pe câmpuri precum `genres` sau `year`. Strategia aplicată este *post-filter* (`$match` după `$vectorSearch`), cu un număr de candidați mai ridicat pentru a compensa reducerea produsă de filtru.

**Scenariul 3.4 — Clustering semantic: matrice de similaritate cosinus**  
Preia embedding-urile existente pentru o listă de filme și calculează matricea de similaritate cosinus pereche, fără niciun apel la API. Afișează matricea completă și cel mai apropiat vecin semantic pentru fiecare film, permițând observarea măsurii în care grupările semantice coincid cu genurile.

---

### Cerințe și rulare

#### Instalare pachete

```bash
npm install mongodb openai
```

#### Variabile de mediu

Scriptul citește conexiunea și cheia API din variabilele de mediu. Setează-le înainte de rulare sau înlocuiește valorile direct în fișier.

**Linux / macOS**

```bash
export MONGO_URI="mongodb+srv://<user>:<parola>@<cluster>.mongodb.net/"
export OPENAI_API_KEY="sk-..."
```

**Windows (Command Prompt)**

```cmd
set MONGO_URI=mongodb+srv://<user>:<parola>@<cluster>.mongodb.net/
set OPENAI_API_KEY=sk-...
```

**Windows (PowerShell)**

```powershell
$env:MONGO_URI     = "mongodb+srv://<user>:<parola>@<cluster>.mongodb.net/"
$env:OPENAI_API_KEY = "sk-..."
```

#### Index Vector Search necesar

Înainte de rulare, colecția `embedded_movies` trebuie să aibă un index Atlas Vector Search cu următoarea configurație:

| Câmp | Valoare |
|---|---|
| Câmp indexat | `plot_embedding` |
| Dimensiuni | `1536` |
| Similaritate | `cosine` |
| Nume index | `PlotSemanticIndex` |

#### Rulare

```bash
node embeddings_demo.js
```