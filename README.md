# Ventana Nails & Spa — Katy, TX

Website for **Ventana Nails & Spa**, 22911 Clay Rd, Katy, TX 77449 (Galicia Retail Plaza).

It is one plain `index.html` file plus an `images/` folder. No frameworks, no build step, nothing to install. It has its own look (warm cream, deep charcoal and the Ventana gold, with a photo-led hero and a menu-style price list), a real Spanish translation with a clear EN / ES switch, photos shrunk for phones, a photo lightbox, a reviews carousel, search-engine tags, and accessibility built in.

## What's in this folder

```
ventana-nails-spa-katy/
├── index.html            The whole website (design, text, prices, Spanish, scripts)
├── images/               Photos the site uses (already shrunk for the web)
├── images-originals/     Untouched full-size copies of the photos — NOT part of the site.
│                         Safe to delete when you are happy. Do not upload it.
├── optimize-images.sh    Shrinks photos in images/ (run again after swapping photos)
├── favicon.ico           Browser-tab icon (made from images/logo.png)
├── apple-touch-icon.png  Home-screen icon on iPhone (made from images/logo.png)
├── robots.txt            Tells Google it may index the site
├── sitemap.xml           List of pages for Google (just the one page)
├── README.md             This file
└── BUILD-NOTES.md        What changed vs. Richmond + what you still need to supply
```

## How to open it on your Mac

1. Open **Finder** and go to your home folder → `ventana-nails-spa-katy`.
2. Double-click `index.html`. It opens in your web browser.
3. On the first visit you will see the English / Español chooser. Pick one. The site remembers your choice, and the **EN / ES** switch at the top of every page (labelled "Language · Idioma") changes it any time.

That's it — the site works straight from the file. (The Google Map may not show when opened as a file in some browsers. It always shows once the site is on the internet.)

## How to swap in the Katy photos

Photos are found by **file name**, so you only need to give your new photos the same names and drop them in `images/`, replacing the old ones:

| File name | Where it shows | Best size |
|---|---|---|
| `logo.png` | Top bar, footer, language chooser, browser icons, share image | Square PNG with transparent background, about 600 × 600 |
| `gallery-1.jpg` … `gallery-6.jpg` | "Our Work" gallery. **`gallery-5.jpg` is also the big arched photo at the top of the page** | Square, 1080 × 1080 or bigger |
| `service-manicure.jpg` | Photo beside the Manicures list | Tall (portrait) |
| `service-pedicure.jpg` | Photo beside the Pedicures list, **and the small photo at the top of the page** | Tall (portrait) |
| `service-nails.jpg` | Photo beside the Nails list | Tall (portrait) |
| `service-waxing.jpg` | Photo beside the Waxing list | Tall (portrait) |
| `drink-1.jpg` … `drink-32.jpg` | Drinks Menu tab (in menu order). `drink-1.jpg` is also the photo beside that tab | Tall (portrait), 1080 × 1920 |

Then shrink the new photos so the site stays fast:

1. Open **Terminal** (Applications → Utilities → Terminal).
2. Paste this and press Return:

```bash
cd ~/ventana-nails-spa-katy && bash optimize-images.sh
```

It only touches photos that are new or changed, keeps a full-size copy in `images-originals/`, rebuilds the icons and share image from the logo, and prints the folder size before and after.

**Text to update when photos change** (all in `index.html`, in the `T = { en: {...}, es: {...} }` translations block):

- `gallery.label1` … `gallery.label6` — the caption under each gallery photo.
- `gallery.alt1` … `gallery.alt6` — the spoken description for screen readers (`gallery.alt5` is also used for the big hero photo).
- The 32 drink names live in the `DRINKS` list a little further down. Change them if the menu changes.

## How to change business details

Everything (booking link, phone, email, address, Instagram, Facebook, website address, rating, **opening hours**) lives in **one block** near the bottom of `index.html`, labelled `CONFIG`. Change a value between the quotes, save, reload. Every button, link, map, hours line and search-engine tag updates from it.

```js
const CONFIG = {
  BOOKING:   'https://booking.gocheckin.net/v2/14729',
  PHONE:     '(832) 639-3789',
  ...
  FACEBOOK:  '',   // TODO paste the Facebook page URL here
  SITE_URL:  'https://REPLACE-WITH-YOUR-DOMAIN.example',   // TODO your real domain
  HOURS: [
    { days: [1, 2, 3, 4, 5], open: '9:30 AM',  close: '7:00 PM' },   // Monday – Friday
    { days: [6],             open: '9:00 AM',  close: '7:00 PM' },   // Saturday
    { days: [0],             open: '11:00 AM', close: '5:30 PM' }    // Sunday
  ]
};
```

- **Hours**: `days` uses numbers — 0 is Sunday, 1 Monday … 6 Saturday. The hours table, the footer, the green "Open today" badge at the top, and the search-engine data all read this one list.
- **Prices and service descriptions** are in the `data` block right below the translations (identical to Richmond). Spanish versions of the same services are in `T.es.services`, in the same order.

## How to put it on the internet

Upload these to any web host: `index.html`, the `images/` folder, `favicon.ico`, `apple-touch-icon.png`, `robots.txt`, `sitemap.xml`. Do **not** upload `images-originals/` or `optimize-images.sh`.

Easiest free options:

- **Netlify Drop** — go to app.netlify.com/drop, drag the whole folder (minus `images-originals/`) onto the page. You get a live link in seconds and can attach your own domain later.
- **GitHub Pages**, **Cloudflare Pages**, or the hosting that comes with your domain — all work the same way: upload the files, done.

Once you own a domain (for example `ventananailsspakaty.com`), do a Find & Replace of `https://REPLACE-WITH-YOUR-DOMAIN.example` → your real address in these three files: `index.html`, `robots.txt`, `sitemap.xml`. Then submit `sitemap.xml` in Google Search Console.
