# 01-broken — Exercitiul Lighthouse

Site-ul asta **arata decent in browser** dar are **10 probleme deliberate** pe care Lighthouse le prinde pe toate.

## Cum rulezi exercitiul

1. Deschide `index.html` cu Live Server.
2. Deschide DevTools (F12) → tab-ul **Lighthouse**.
3. Selecteaza toate 4 categoriile (Performance, Accessibility, Best Practices, SEO).
4. Click **Analyze page load**.
5. Citeste raportul.

## Scor asteptat (inainte de fix)

| Categoria | Scor |
|---|---|
| Performance | ~50 |
| Accessibility | ~60 |
| Best Practices | ~75 |
| SEO | ~55 |

## Cele 10 probleme + fix-uri

> **Pentru trainer:** lista de mai jos e cheat sheet. Studentii sa o descopere prin Lighthouse, nu sa o citeasca de aici.

| # | Problema in `index.html` | Pica pe | Fix |
|---|---|---|---|
| 1 | `<title>Document</title>` (generic) | SEO | Pune un title specific (ex: `<title>Eveniment X — 15 mai, Iasi</title>`) |
| 2 | Lipseste `<meta name="description">` | SEO | Adauga `<meta name="description" content="...120-160 caractere...">` |
| 3 | Lipseste `<meta name="viewport">` | SEO + Best Practices | Adauga `<meta name="viewport" content="width=device-width, initial-scale=1.0">` |
| 4 | `<img>` fara `alt` | Accessibility | Adauga `alt="..."` (sau `alt=""` daca e decorativa) |
| 5 | Imagine 2400×1600 randata la 800px | Performance | Foloseste imagine la dimensiunea afisata, sau adauga `srcset` |
| 6 | `<input>` fara `<label>` | Accessibility | Inlocuieste `placeholder` cu `<label for="..."><input id="...">` |
| 7 | Buton contrast 2.1:1 (`#cccccc` pe `#aaaaaa`) | Accessibility | Schimba la macar 4.5:1 (ex: alb pe albastru inchis) |
| 8 | `<script>` inline blocant in `<head>` | Performance | Muta in fisier extern cu `<script src="..." defer>` |
| 9 | `<h2>` inainte de `<h1>`; `<h3>` sare peste `<h2>` | Accessibility | Restructureaza: 1× `<h1>`, apoi `<h2>` per sectiune, apoi `<h3>` daca trebuie |
| 10 | Lipseste `lang="ro"` pe `<html>` | Accessibility + SEO | Adauga `<html lang="ro">` |

## Scor dupa toate fix-urile

| Categoria | Scor |
|---|---|
| Performance | 95+ |
| Accessibility | 100 |
| Best Practices | 100 |
| SEO | 100 |

## Lectia

Cele 10 fix-uri sunt **toate de 1-2 linii**. Costa 5 minute. Diferenta: amator vs profesionist.

**Lighthouse e judecatorul.** Cand un senior face code review, ruleaza Lighthouse pe ce ai scris. Daca scorul e sub 90, te trimite inapoi. Standardul e 95+.
