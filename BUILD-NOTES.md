# Build notes — Katy site

Built 2026-09-01/02 from `~/ventana-nails-spa-richmond/index.html` (1,706 lines, read in full; nothing in that folder was touched). Version 2 (2026-09-02) gives Katy its own interface after the first version looked nearly identical to Richmond.

## What Katy keeps from Richmond

- One plain `index.html`, no frameworks, no build step, same `images/` file names.
- Section order: language overlay → header → hero → intro → services → reviews → gallery → features → hours/location → footer → mobile Call/Book bar.
- One plain page, the same section order, the gold accent, the tabbed service menu and the lazy Drinks tab. The service list itself is now Katy's own (see "Menu rewrite" below) and no longer matches Richmond.
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

Logo sizes changed with the layout: header 46 px, footer 64 px, language chooser 120 px. The hero shows photos rather than the logo. The Katy logo ("Ventana Nails Spa", 576 × 721) was installed on 2026-09-02 and the icons/share image were rebuilt from it.

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
| Above the fold (HTML + logo + 2 hero photos + first list photo) | ~1.0 MB |
| Full first visit, scrolled to the bottom (adds the gallery) | ~2.2 MB (with Google Fonts + Map) |
| Drinks tab, all 32 photos scrolled through | +8.0 MB (only if opened; loads one row at a time) |

## Still needed from you

1. **Facebook URL** → `CONFIG.FACEBOOK` in `index.html`. The footer icon and the JSON-LD `sameAs` entry stay hidden until it's filled in.
2. **Domain** → replace `https://REPLACE-WITH-YOUR-DOMAIN.example` in `index.html` (`CONFIG.SITE_URL`), `robots.txt` and `sitemap.xml`. `.example` is a reserved name that nobody can own.
3. **Remaining Richmond photos.** Done so far (2026-09-02): the new Katy logo (`logo.png`, 576 × 721) and all six gallery photos, with captions/alt text updated in both languages. Still Richmond's: the four `service-*.jpg` list photos (`service-pedicure.jpg` also appears in the hero) and the 32 `drink-*.jpg` photos. Swap them by name and run `bash optimize-images.sh`.
5. Optional: with `cwebp` installed (`brew install webp`), `bash optimize-images.sh --force` also writes `.webp` copies; the HTML would then need `<picture>` tags to use them.

## Drink names (as read off the photos, in order)

1 Viet Coffee with Cream · 2 Red Wine · 3 White Wine · 4 Mimosa · 5 Margarita · 6 Mama Mojito · 7 Tequila Sunset · 8 Old Fashion · 9 Mango Margarita · 10 Mai Tai · 11 Strawberry Long Island · 12 Pineapple Cocktail · 13 Egg Nog · 14 Blue Margarita · 15 Malibu Sunrise · 16 Strawberry Sweet Love · 17 Long Island Iced Tea · 18 Piña Colada · 19 Watermelon Cocktail · 20 Devil Margarita · 21 Ripe Tomato · 22 Viet Coffee Cocktail (Hot or Iced) · 23 Midnight Splash · 24 Strawberry Açaí (alcohol-free) · 25 Cucumber Fresh (alcohol-free) · 26 Orange Creamsicle (alcohol-free) · 27 Creamsicle Fizz (alcohol-free) · 28 Green Tea (Iced or Hot) · 29 Coca-Cola · 30 Sprite · 31 Diet Coca-Cola · 32 Bottled Water

## Security review (2026-09-02)

What the site is: one static HTML page, no server code, no database, no forms, no logins, no cookies, nothing collected from visitors. That removes most web risks by design. Checked line by line:

- **No secrets in the code.** No API keys, tokens or passwords anywhere (the booking link, phone and email are public business info).
- **No inline event handlers, no `javascript:` links.** All behaviour is in one script block.
- **Every dynamic string is escaped** (`esc()`) before being inserted with `innerHTML`, and the only data inserted comes from constants inside the file (services, drink names, hours), never from a URL, a form or a visitor.
- **Every link that opens a new tab has `rel="noopener"`**, so the booking site, Instagram, Facebook and Google Maps cannot reach back into this page.
- **The only third parties loaded** are Google Fonts (fonts.googleapis.com / fonts.gstatic.com) and the Google Maps embed (`www.google.com`, in a lazy-loaded iframe with `referrerpolicy="no-referrer-when-downgrade"`).
- **Local storage** holds exactly one value, the language choice (`ventana_katy_lang`), wrapped in try/catch so private-browsing modes can't break the page.
- **`vercel.json` adds hardening headers on every response:** a Content-Security-Policy that only allows scripts/styles from the page itself, fonts from Google, frames from Google Maps, and blocks plugins and framing by other sites (`frame-ancestors 'none'`, plus `X-Frame-Options: DENY`); `X-Content-Type-Options: nosniff`; `Referrer-Policy: strict-origin-when-cross-origin`; `Permissions-Policy` that turns off camera, microphone, location and payment APIs; and HSTS (`Strict-Transport-Security`) so browsers always use HTTPS. Images get a 30-day cache header.
- **Repository hygiene.** `.gitignore` keeps `images-originals/` (108 MB of full-size photos), `.DS_Store` and the local `.claude/` settings out of GitHub. Nothing personal is committed except the public business details on the page.
- Known, accepted: the CSP allows `'unsafe-inline'` for the page's own script and style blocks because they live inside `index.html` (using hashes instead would break the site every time CONFIG is edited). There is no user input on the page, so this carries no practical risk here.

## Publishing with GitHub and Vercel (step by step)

Two free accounts. GitHub stores your files; Vercel publishes them and gives you an https address. Do this once; afterwards every update is "commit → push" and the live site refreshes itself.

**A. Create the GitHub account and the empty repository**

1. Go to github.com and click **Sign up**. Use your email, pick a password, finish the verification.
2. Once signed in, click the **+** at the top right → **New repository**.
3. Repository name: `ventana-nails-spa-katy`. Leave it **Public** or choose **Private** (either works with Vercel). Do **not** tick "Add a README" (the folder already has one). Click **Create repository**.
4. Leave that page open; you'll come back to it.

**B. Put the folder on GitHub with GitHub Desktop (no typing needed)**

1. Download GitHub Desktop from desktop.github.com, open it, and sign in with the account from step A.
2. Menu **File → Add Local Repository…**, click **Choose…**, pick your home folder → `ventana-nails-spa-katy`, click **Add Repository**. (It is already a Git repository with one commit, so it opens straight away.)
3. Click the big **Publish repository** button at the top. In the box that appears, make the name `ventana-nails-spa-katy`, untick "Keep this code private" if you chose Public in A3, and click **Publish repository**.
4. Wait for the upload to finish (about 10 MB). Refresh the GitHub page from A4 and you'll see all the files.

**C. Publish with Vercel**

1. Go to vercel.com and click **Sign Up** → **Continue with GitHub**. Approve the connection when GitHub asks.
2. On the Vercel dashboard click **Add New… → Project**.
3. Find `ventana-nails-spa-katy` in the list and click **Import**. If it isn't listed, click **Adjust GitHub App Permissions** and allow access to that repository.
4. On the settings screen change nothing: Framework Preset "Other", no build command, output directory blank. Click **Deploy**.
5. About a minute later you'll see "Congratulations". Click **Visit**. Your site is live at an address like `ventana-nails-spa-katy.vercel.app`, with HTTPS and the security headers from `vercel.json` already active.

**D. Every time you change something later**

1. Edit files in the folder as usual (or run the photo script).
2. Open GitHub Desktop. It lists what changed. Type a short note in the "Summary" box at the bottom left (for example "new pedicure photo") and click **Commit to main**.
3. Click **Push origin** at the top. Vercel notices and republishes automatically; refresh the site after a minute.

**E. When you have your own domain**

1. In Vercel: your project → **Settings → Domains** → type the domain → **Add**. Vercel shows one or two DNS records to enter at the company you bought the domain from; copy them exactly. It usually goes live within an hour and HTTPS is automatic.
2. In the folder: Find & Replace `https://REPLACE-WITH-YOUR-DOMAIN.example` → `https://your-domain.com` in `index.html`, `robots.txt` and `sitemap.xml`. Commit and push (step D).
3. Optional but worth it: search.google.com/search-console → add your domain → submit `https://your-domain.com/sitemap.xml`.

## Menu rewrite (2026-09-08)

The whole service menu was replaced with Katy's own pricing. It no longer matches Richmond.

| Category | Items | Notes |
|---|---|---|
| Manicures | 3 | $20 / $40 / $50, descriptions rewritten |
| Pedicures | 11 | Basic $36 · Sugar $42 · Sugar and Mask $50 · Deluxe $60 · Billionaire Spa $70 · Volcano Spa Eruption $70 · Bomb Spa $80 · Collagen Spa $90 · Herbal Bliss Spa $100 · Volcano Luxury $100 · Ventana Herbal $120. Listed in price order |
| Nail Enhancement | 19 | Renamed from "Nails". Seven full sets (Gel X, Hybrid Gel, Acrylic, Builder, Pink & White / Ombre, Dip, Full Set Color Powder) then twelve add-ons |
| Waxing | 10 | New prices, and Brows Tinting added |
| Eyelashes | 3 | **New category and new tab**: Strips $25, Individuals $120, Cluster $45 |
| Drinks Menu | 32 | Unchanged |

**Nothing was deleted.** On the owner's instruction the seven services the new list did not mention were restored with their original English and Spanish wording: Volcano Spa Eruption $70, Volcano Luxury Pedicure $100, Ventana Herbal Pedicure $120, Gel Manicure $40, Add Gel Color to Service $20, Paraffin $8, Extra Massage $1/min. Two price points are intentionally shared (Billionaire Spa and Volcano Spa Eruption at $70; Herbal Bliss Spa and Volcano Luxury at $100). Every other old service is present under its new name: Classic Pedicure became Basic Pedicure, Acrylic Full Set plus Acrylic Fill In became one Acrylic row with a fill-in line, Full Set Liqui / Fill In Liqui became Builder at the same $60 / $50, Color Powder Full Set plus its two refills became Full Set Color Powder with a fill-in line, and the waxing entries were renamed and repriced. 42 old services became 46.

Supporting changes:

- **Two-price services.** Items with a fill-in price use a new optional `sub` field, printed as a small grey line under the main price ("Fill in $47"). Translated separately in Spanish ("Relleno $47").
- **Category photo is now optional.** A category with no entry in `SERVICE_IMG` hides the photo frame instead of breaking. Eyelashes has no photo yet; adding `eyelash: { src: 'images/service-eyelash.jpg', w: …, h: … }` to `SERVICE_IMG` turns it on.
- **Salon Policy section** added between Location and the footer, linked from the top menu, the phone menu and the footer. Its 9 lines are stored as translations (`policy.1`…`policy.9`) and rendered by `renderPolicy()`, so they switch language with everything else. The count is controlled by `POLICY_COUNT`.
- The source text was headed "Apollo Nails & Spa Policy". The owner confirmed to ignore the name, so the heading reads "Salon Policy" and the site name stays Ventana throughout.
- The source was written for a kiosk app; the owner confirmed to ignore that, so on the website it became a page section reachable from the navigation.
- Translation dictionary grew from 126 to 142 keys per language, still at full parity.

Verified in headless Chrome at 1440 and 375: no console errors, no failed requests, all six tabs render the right rows and prices, fill-in sub-prices show in both languages, expanding a row works, the Eyelashes tab hides the photo and the other tabs bring it back, the policy list renders 9 numbered items in both languages, the wider navigation still fits, and there is no sideways overflow on a phone.
