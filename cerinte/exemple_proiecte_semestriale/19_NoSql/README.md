# Exemple de utilizare MongoDB

## Utilizare Docker

Mediul de execuție MongoDB este containerizat prin intermediul **Docker Compose**. Fișierul de configurare `docker-compose.yml` se află în directorul `mongo-init/` și definește două servicii:

- **`mongo_test`** — instanța principală MongoDB, accesibilă pe portul `27017`. La pornire, execută scriptul `mongo-init/mongo-test/init-db.d/seed.js`, care creează utilizatorul `umovies` cu drepturi de citire/scriere asupra bazei de date `moviesdb`.

- **`mongo_seed`** — serviciu auxiliar care importă datele inițiale în baza de date `moviesdb`. Utilizează `mongoimport` pentru a încărca colecțiile `movies` și `comments` din fișierele JSON aflate în `mongo-init/mongo-seed/samplefiles/`.

### Pornirea mediului

```bash
cd mongo-init
docker-compose up
```

Serviciul `mongo_seed` pornește automat după `mongo_test` (prin directiva `depends_on`) și populează baza de date `moviesdb` cu datele de test.

---

## Exemple de operații CRUD (Create, Read, Update, Delete)

Fișierele de tip `*.mongodb.js` sunt **MongoDB Playground** — scripturi interactive specifice extensiei [MongoDB for VS Code](https://marketplace.visualstudio.com/items?itemName=mongodb.mongodb-vscode). Pentru a le rula, este necesară instalarea acestei extensii și configurarea unei conexiuni la instanța MongoDB (implicit `mongodb://localhost:27017`).

Fiecare fișier poate fi executat direct din editorul VS Code prin apăsarea butonului **▶ Run Playground** din bara de titlu sau prin comanda din paleta de comenzi (`Ctrl+Shift+P` → *MongoDB: Run All Playground Blocks*).

Toate operațiile se efectuează asupra bazei de date **`sales`**, care conține colecțiile `customers` și `orders`.

### `CustomersSales.mongodb.js` — Inserarea clienților

Inserează un set de clienți în colecția `customers` utilizând operația `insertMany`. Fiecare document conține câmpuri precum: `customerId`, `firstName`, `lastName`, `email`, `phone`, `address` (câmp document înglobat cu `street`, `city`, `country`, `postalCode`), `registrationDate`, `totalOrders`, `totalSpent`, `preferredPaymentMethod`, `loyaltyPoints` și `isActive`.

### `OrdersInsertSales.mongodb.js` — Inserarea comenzilor

Citește primii trei clienți din colecția `customers` și generează câte două comenzi aleatorii pentru fiecare. Fiecare comandă conține un subset aleatoriu de produse dintr-un catalog predefinit (`Laptop`, `Mouse`, `Keyboard`, `Monitor`, `Webcam`), cu cantități și prețuri variabile. Valoarea totală este calculată dinamic. Documentele sunt inserate în colecția `orders` prin `insertOne`.

### `OrdersUpdateSales.mongodb.js` — Actualizarea comenzilor

Realizează două tipuri de actualizări:

1. **Actualizare multiplă (`updateMany`)** — pentru clientul `CLT001`, actualizează toate comenzile asociate, setând câmpurile `discountPercentage` și `status` (`"Confirmed"`).
2. **Actualizare selectivă cu filtre pe array (`updateOne` + `arrayFilters`)** — pentru clientul `CLT002`, adaugă un nou produs (`Gaming Headset`) în array-ul `products` al primei comenzi și actualizează prețul unui produs existent (`PROD002`) folosind operatorul pozițional filtrat `$[elem]`.

### `LookupSales.mongodb.js` — Interogări și agregări

Demonstrează utilizarea pipeline-ului de agregare MongoDB prin mai multe exemple:

1. **`$lookup` simplu** — realizează o jonctiune (`join`) între colecțiile `orders` și `customers` pe câmpurile `customerId` / `_id`, echivalent cu un `JOIN` SQL.
2. **`$match` + `$lookup` + `$project` + `$sort`** — filtrează clienții activi, calculează numărul de comenzi și valoarea totală a acestora, sortând rezultatele descrescător după valoare.
3. **`$unwind` + `$group` + `$project` + `$sort`** — desfășoară array-ul `products` din comenzi, grupează după `productId` și calculează cantitatea medie și numărul total de apariții ale fiecărui produs în comenzi.
4. **Creare view** — creează view-ul `sales` din colecția `orders`, folosind același pipeline de agregare pentru statistici pe produse.

---
