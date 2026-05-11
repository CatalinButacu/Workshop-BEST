# 02-reference — Site complet

Asta e **destinația**. Site-ul pe care il construim impreuna in training, cu toate best practices aplicate.

## Cum il deschizi

1. Deschide folderul in VS Code (`File → Open Folder`).
2. Click dreapta pe `index.html` → **Open with Live Server**.

## Ce sa observi

### HTML (`index.html`)
- `lang="ro"` pe `<html>` — Lighthouse + screen readers stiu limba.
- `<meta viewport>` — fara el, media query-urile pic pe mobil.
- `<title>` specific (nu "Document") + `<meta description>` pentru SEO.
- Open Graph complet (og:title, og:type, og:image, og:url) — preview frumos pe WhatsApp.
- `og:image` cu **URL absolut** (`https://...`) — relativ nu functioneaza.
- Tag-uri semantice: `<header>`, `<main>`, `<section>`, `<footer>`, `<nav>`.
- Un singur `<h1>`. `<h2>` in ordine. Nu sari peste niveluri.
- `<label for="...">` perechi cu `<input id="...">`. Accesibilitate de baza.
- `<script defer>` — JS nu blocheaza randarea HTML.

### CSS (`style.css`)
- `:root` cu variabile (`--primary`, `--bg`, `--text`...) — schimbi tema in 1 linie.
- `light-dark()` + `color-scheme: light dark` — dark mode in 2 linii.
- Reset minimal de 5 linii (paste, nu te complica).
- Flex pentru navbar si form (3 linii).
- **Mobile-first:** scrii pentru telefon, apoi `@media (min-width: 768px)` pentru desktop.
- `:focus-visible` cu outline — accesibilitate la navigare cu Tab.

### JS (`script.js`)
- Pattern `select → listen → change` aplicat de 3 ori (hamburger, smooth scroll, form).
- `const` peste tot, `let` doar daca reasignezi.
- `aria-expanded` actualizat — accesibilitate pentru screen readers.

## Targetul Lighthouse

Ruleaza Lighthouse pe acest site (DevTools → Lighthouse → Analyze):

| Categoria | Scor asteptat |
|---|---|
| Performance | 95+ |
| Accessibility | 100 |
| Best Practices | 100 |
| SEO | 100 |

**Daca ai sub asta**: ceva nu merge in setup-ul tau. Vino la trainer.
