# Build notes — Katy site

Built 2026-09-01/02 from `~/ventana-nails-spa-richmond/index.html` (1,706 lines, read in full; nothing in that folder was touched). Version 2 (2026-09-02) gives Katy its own interface after the first version looked nearly identical to Richmond.

## What Katy keeps from Richmond

- One plain `index.html`, no frameworks, no build step, same `images/` file names.
- Section order: language overlay → header → hero → intro → services → reviews → gallery → features → hours/location → footer → mobile Call/Book bar.
- The services `data` object (42 services: 3 manicures, 8 pedicures, 22 nails, 9 waxing) — copied programmatically and verified byte-for-byte. Prices and descriptions are exactly Richmond's.
- The Ventana gold (#D4AF37 / #E6C550 / #C5A028 / #FBF5DC), the 5 service tabs, the "See Details ▼" expand, a per-service Book button, the lazy-built Drinks tab, fade-up-on-scroll animations, smooth scrolling, the 220 ms tab fade.

## The Katy look (version 2) — what is different from Richmond

| | Richmond | Katy |
|---|---|---|
| Palette | Black hero/footer, white sections, gold | Warm cream page, deep charcoal bands, the same gold used as the accent |
| Fonts | Cormorant Garamond + Montserrat, wide-tracked caps | Marcellus (matches the logo lettering) + DM Sans, sentence-case pill buttons |
| Header | Transparent over a dark hero, flag emoji | Cream sticky bar with logo + "Ventana Nails & Spa / Katy, TX", an **EN / ES switch with both flags and "Language · Idioma" under it** |
| Hero | Centered 280 px logo on a black grid | Split: headline + rating + buttons + perks on the left, arched photo with a smaller offset photo and a live "Open today · hours" badge on the right |
| Intro | Three icon columns | Dark stats band (4.6★ · 900+ · 32 drinks · 7 days) + a two-column welcome |
| Services | Centered tab pills + bordered cards + side photo | Vertical category list on the left with the category photo under it; menu-style rows (name · price · Book) that expand in place |
| Reviews | Black section, dark cards | Sand section, white cards with a big gold quote mark, "Google review" label, dots + round arrows |
| Gallery | 12-column mosaic with hover labels | Clean 3-column grid, rounded 4:5 frames, caption under each photo, zoom hint |
| Why us | Three white cards | Dark section with numbered items (01 / 02 / 03) and Book / Call buttons |
| Location | Two columns, hours + small map | Full-width rounded map with a floating cream info card (hours, contact, Directions / Call) |
| Footer | Black | Sand with a dark bottom strip |

Logo sizes changed with the layout: header 46 px, footer 64 px, language chooser 120 px. The hero no longer shows the logo (it shows photos); the logo artwork currently says "Richmond", which is another reason to lead with photos until the Katy logo arrives.

## Katy business info (every Richmond value replaced)

Name, address (22911 Clay Rd, Katy, TX 77449 · Galicia Retail Plaza), phone (832) 639-3789 → `tel:+18326393789`, email ventana.nailsandspa@icloud.com, 4.6 stars / 900+ reviews, Instagram, booking link `https://booking.gocheckin.net/v2/14729`, hours, the plain `?q=…&output=embed` map URL (Richmond's hand-built `pb=` string is gone), copyright "© 2026 Ventana Nails & Spa Katy". All of it lives in the `CONFIG` object at the top of the script. **Hours are now also in CONFIG** (`HOURS`) and feed the hours table, the footer, the hero's "Open today" badge and the structured data, so hours are a one-place edit too.

Requested copy: "Katy's premier destination…" (now the hero headline), "Trusted by our Katy community" is replaced by the stats band, "Visit us on Clay Road in Galicia Retail Plaza." (footer), "4.6 Stars · 900+ Google Reviews" (hero rating line), "900+ Google Reviews" (reviews pill + stats), footer copyright / "Katy, TX 77449".

Reviews: the six Katy reviews replace Richmond's six. They stay in English in both languages and are marked `lang="en"`.

## The five upgrades

1. **Real Spanish.** `T = { en, es }` dictionary with 126 keys per language, plus Spanish versions of all 42 services and 32 drink names. Text is marked with `data-i18n` (and `data-i18n-alt` / `-aria` / `-title`). `applyLang(lang)` swaps everything, re-renders the services list and hours, sets `<html lang>` and the page title, and saves to `localStorage['ventana_katy_lang']`. A tiny script in `<head>` reads that key before anything paints so returning Spanish visitors never see an English flash. The header switch shows both options at once (🇺🇸 EN | 🇪🇸 ES, active one dark with gold text) with "Language · Idioma" under it; the first-visit overlay is still there. "Book Now" → "Reservar", "See Details" → "Ver Detalles", "Deluxe Pedicure" → "Pedicura Deluxe".
2. **Image speed pass.** `optimize-images.sh` (macOS `sips` only). `images/` went from **108.0 MB → 10.0 MB**. `cwebp` is not installed, so no `.webp` files were produced and the HTML uses plain `<img>` tags (nothing references a file that doesn't exist). Every `<img>` has `width`/`height`; everything below the fold has `loading="lazy" decoding="async"`. The 32 drink images are still built only when the Drinks tab is first opened.
3. **SEO pack.** Requested `<title>`, meta description, JSON-LD `NailSalon` (address, phone, `$$`, 7-day `openingHoursSpecification` generated from `CONFIG.HOURS`, `aggregateRating` 4.6/900, `hasMap`, `ReserveAction` → booking URL, `sameAs`), Open Graph + Twitter tags, canonical, `robots.txt`, `sitemap.xml`, `favicon.ico` + `apple-touch-icon.png` + `images/og-image.jpg` (1200 × 630) generated from `logo.png` by the script.
4. **Lightbox + reviews.** Gallery photos and drink photos are real `<button>`s that open a no-library lightbox: dark backdrop, gold close/arrows, ←/→/Esc keys, touch swipe, backdrop click, body scroll lock, focus returns to the photo you clicked. Reviews carousel has dot indicators, 6-second autoplay (pauses on hover, keyboard focus, touch, hidden tab, or off-screen), ←/→ keys, and the last card can be the "current" one.
5. **Accessibility & polish.** `role="tablist"` / `role="tab"` / `aria-selected` / roving `tabindex` with ←/→/↑/↓/Home/End; language switch uses `aria-pressed`; gold `:focus-visible` ring on everything interactive; `prefers-reduced-motion` turns off fades, slides and the pulsing button; descriptive alt text on every photo (drink alts use the real drink names read off the photos); mobile sticky bar with **Call** (gold outline) beside **Book Now** (gold fill), safe-area aware.

## Verified (headless Chrome, 1440 / 768 / 375)

Zero console errors or warnings, zero failed requests, every image file + icons + robots + sitemap return 200, no broken images, all 5 tabs, expand/collapse rows, both lightboxes (keys, buttons, backdrop, swipe), carousel next/dots/keys/autoplay/hover-pause, keyboard tabs, focus ring, reduced motion, Spanish switch (every translatable element changes) + persistence after reload with no flash, hamburger menu, sticky bar, no horizontal overflow at any width.

Page weight (what a visitor downloads):

| Scenario | Size |
|---|---|
| Above the fold (HTML + logo + 2 hero photos + first list photo) | ~0.7 MB |
| Full first visit, scrolled to the bottom (adds the gallery) | ~1.8 MB (~1.9 MB with Google Fonts + Map) |
| Drinks tab, all 32 photos scrolled through | +8.0 MB (only if opened; loads one row at a time) |

## Still needed from you

1. **Facebook URL** → `CONFIG.FACEBOOK` in `index.html`. The footer icon and the JSON-LD `sameAs` entry stay hidden until it's filled in.
2. **Domain** → replace `https://REPLACE-WITH-YOUR-DOMAIN.example` in `index.html` (`CONFIG.SITE_URL`), `robots.txt` and `sitemap.xml`. `.example` is a reserved name that nobody can own.
3. **Katy photos.** The current files are Richmond's. `logo.png` literally says "NAILS & SPA RICHMOND". `gallery-5.jpg` and `service-pedicure.jpg` also appear in the hero, so pick strong ones for those two names. The favicon, Apple icon and share image are rebuilt from the logo by `optimize-images.sh`.
4. After swapping gallery photos, update `gallery.label1–6` and `gallery.alt1–6` in both languages.
5. Optional: with `cwebp` installed (`brew install webp`), `bash optimize-images.sh --force` also writes `.webp` copies; the HTML would then need `<picture>` tags to use them.

## Drink names (as read off the photos, in order)

1 Viet Coffee with Cream · 2 Red Wine · 3 White Wine · 4 Mimosa · 5 Margarita · 6 Mama Mojito · 7 Tequila Sunset · 8 Old Fashion · 9 Mango Margarita · 10 Mai Tai · 11 Strawberry Long Island · 12 Pineapple Cocktail · 13 Egg Nog · 14 Blue Margarita · 15 Malibu Sunrise · 16 Strawberry Sweet Love · 17 Long Island Iced Tea · 18 Piña Colada · 19 Watermelon Cocktail · 20 Devil Margarita · 21 Ripe Tomato · 22 Viet Coffee Cocktail (Hot or Iced) · 23 Midnight Splash · 24 Strawberry Açaí (alcohol-free) · 25 Cucumber Fresh (alcohol-free) · 26 Orange Creamsicle (alcohol-free) · 27 Creamsicle Fizz (alcohol-free) · 28 Green Tea (Iced or Hot) · 29 Coca-Cola · 30 Sprite · 31 Diet Coca-Cola · 32 Bottled Water
